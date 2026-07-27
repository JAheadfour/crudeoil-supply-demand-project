"""Render an A/B podcast script with two Edge neural voices."""

from __future__ import annotations

import argparse
import asyncio
import hashlib
import json
import re
import struct
from dataclasses import dataclass
from pathlib import Path

import edge_tts
import lameenc
from mutagen.id3 import ID3, TALB, TCOM, TIT2, TPE1, TXXX
from mutagen.mp3 import MP3


TURN_RE = re.compile(r"^(A|B):\s*(\S.*)$")
PAUSE_RE = re.compile(r"^PAUSE:\s*(\d+(?:\.\d+)?)$")


@dataclass(frozen=True)
class Segment:
    kind: str
    text: str = ""
    seconds: float = 0.0


def parse_script(path: Path) -> list[Segment]:
    segments: list[Segment] = []
    errors: list[str] = []
    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line:
            continue
        turn = TURN_RE.fullmatch(line)
        if turn:
            segments.append(Segment(kind=turn.group(1), text=turn.group(2)))
            continue
        pause = PAUSE_RE.fullmatch(line)
        if pause:
            seconds = float(pause.group(1))
            if not 0.2 <= seconds <= 60:
                errors.append(f"line {number}: pause must be between 0.2 and 60 seconds")
            segments.append(Segment(kind="PAUSE", seconds=seconds))
            continue
        errors.append(f"line {number}: expected A:, B:, or PAUSE:")

    counts = {key: sum(segment.kind == key for segment in segments) for key in ("A", "B", "PAUSE")}
    if counts["A"] < 20 or counts["B"] < 20:
        errors.append("script needs at least 20 turns for each host")
    if counts["PAUSE"] < 2:
        errors.append("script needs at least two active-recall pauses")
    if errors:
        raise ValueError("\n".join(errors))
    return segments


def segment_cache_path(cache_dir: Path, index: int, segment: Segment, voice: str, rate: str) -> Path:
    digest = hashlib.sha256(f"{voice}\0{rate}\0{segment.text}".encode("utf-8")).hexdigest()[:16]
    return cache_dir / f"{index:03d}-{segment.kind}-{digest}.mp3"


async def synthesize_turn(
    semaphore: asyncio.Semaphore,
    index: int,
    segment: Segment,
    voice: str,
    rate: str,
    cache_dir: Path,
) -> Path:
    target = segment_cache_path(cache_dir, index, segment, voice, rate)
    if target.exists() and target.stat().st_size > 500:
        return target

    async with semaphore:
        for attempt in range(1, 5):
            temporary = target.with_suffix(".tmp")
            try:
                communicate = edge_tts.Communicate(
                    segment.text,
                    voice,
                    rate=rate,
                    volume="+0%",
                    pitch="+0Hz",
                )
                with temporary.open("wb") as output:
                    async for chunk in communicate.stream():
                        if chunk["type"] == "audio":
                            output.write(chunk["data"])
                if temporary.stat().st_size <= 500:
                    raise RuntimeError("speech service returned an empty segment")
                temporary.replace(target)
                return target
            except Exception:
                temporary.unlink(missing_ok=True)
                if attempt == 4:
                    raise
                await asyncio.sleep(1.5 * attempt)
    raise AssertionError("unreachable")


def encode_silence(seconds: float) -> bytes:
    sample_rate = 24_000
    sample_count = int(sample_rate * seconds)
    pcm = struct.pack("<h", 0) * sample_count
    encoder = lameenc.Encoder()
    encoder.set_bit_rate(48)
    encoder.set_in_sample_rate(sample_rate)
    encoder.set_channels(1)
    encoder.set_quality(2)
    return encoder.encode(pcm) + encoder.flush()


async def render(args: argparse.Namespace, segments: list[Segment]) -> dict[str, object]:
    cache_dir = args.cache
    cache_dir.mkdir(parents=True, exist_ok=True)
    args.output.parent.mkdir(parents=True, exist_ok=True)

    voices = {"A": args.voice_a, "B": args.voice_b}
    rates = {"A": args.rate_a, "B": args.rate_b}
    semaphore = asyncio.Semaphore(args.concurrency)
    tasks: list[asyncio.Task[Path] | None] = []
    for index, segment in enumerate(segments):
        if segment.kind == "PAUSE":
            tasks.append(None)
        else:
            tasks.append(
                asyncio.create_task(
                    synthesize_turn(
                        semaphore,
                        index,
                        segment,
                        voices[segment.kind],
                        rates[segment.kind],
                        cache_dir,
                    )
                )
            )

    rendered: list[Path | None] = []
    completed = 0
    for task in tasks:
        if task is None:
            rendered.append(None)
            continue
        rendered.append(await task)
        completed += 1
        if completed % 20 == 0:
            print(f"rendered {completed} speech segments", flush=True)

    with args.output.open("wb") as combined:
        for segment, audio_path in zip(segments, rendered, strict=True):
            if segment.kind == "PAUSE":
                combined.write(encode_silence(min(segment.seconds, args.max_pause)))
            else:
                combined.write(audio_path.read_bytes())

    tags = ID3()
    tags.add(TIT2(encoding=3, text=args.title))
    tags.add(TALB(encoding=3, text="Oil 101 中文深度播客"))
    tags.add(TPE1(encoding=3, text="Oil 101 中文播客"))
    tags.add(TCOM(encoding=3, text="Source-bounded educational adaptation"))
    tags.add(TXXX(encoding=3, desc="VOICE_A", text=args.voice_a))
    tags.add(TXXX(encoding=3, desc="VOICE_B", text=args.voice_b))
    tags.save(args.output)

    audio = MP3(args.output)
    digest = hashlib.sha256(args.output.read_bytes()).hexdigest().upper()
    metadata = {
        "output": str(args.output),
        "bytes": args.output.stat().st_size,
        "duration_seconds": round(audio.info.length, 3),
        "duration_display": f"{int(audio.info.length // 60)}:{int(audio.info.length % 60):02d}",
        "bitrate": audio.info.bitrate,
        "sample_rate": audio.info.sample_rate,
        "channels": audio.info.channels,
        "sha256": digest,
        "segments": {
            "A": sum(segment.kind == "A" for segment in segments),
            "B": sum(segment.kind == "B" for segment in segments),
            "pauses": sum(segment.kind == "PAUSE" for segment in segments),
        },
        "voices": voices,
        "rates": rates,
        "max_rendered_pause_seconds": args.max_pause,
    }
    args.metadata.write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return metadata


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("script", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--metadata", type=Path)
    parser.add_argument("--cache", type=Path, default=Path("render/segments"))
    parser.add_argument("--voice-a", default="zh-CN-YunxiNeural")
    parser.add_argument("--voice-b", default="zh-CN-XiaoxiaoNeural")
    parser.add_argument("--rate-a", default="-3%")
    parser.add_argument("--rate-b", default="-1%")
    parser.add_argument("--concurrency", type=int, default=4)
    parser.add_argument("--max-pause", type=float, default=30.0)
    parser.add_argument("--title", default="地下没有一座原油湖")
    parser.add_argument("--validate-only", action="store_true")
    return parser


def main() -> None:
    args = build_parser().parse_args()
    segments = parse_script(args.script)
    counts = {key: sum(segment.kind == key for segment in segments) for key in ("A", "B", "PAUSE")}
    print(json.dumps({"segments": len(segments), **counts}, ensure_ascii=False))
    if args.validate_only:
        return
    if args.output is None or args.metadata is None:
        raise SystemExit("--output and --metadata are required unless --validate-only is used")
    metadata = asyncio.run(render(args, segments))
    print(json.dumps(metadata, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
