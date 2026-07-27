"""Build the published podcast media and exact timed transcript."""

from __future__ import annotations

import hashlib
import json
import re
import shutil
from pathlib import Path

from mutagen.mp3 import MP3


ROOT = Path(__file__).resolve().parents[1]
EPISODE_DIR = ROOT / "podcast-series" / "oil101" / "episode-01"
SCRIPT = EPISODE_DIR / "episode-01-script.md"
SOURCE = EPISODE_DIR / "episode-01-source.md"
RENDER_DIR = EPISODE_DIR / "render"
SOURCE_AUDIO = RENDER_DIR / "episode-01-audited.mp3"
PUBLISHED_AUDIO = (
    ROOT / "docs" / "assets" / "audio" / "oil101" / "episode-01-underground-no-lake.mp3"
)
PUBLISHED_DATA = ROOT / "docs" / "data" / "podcast" / "episode-01.json"

TURN_RE = re.compile(r"^(A|B):\s*(\S.*)$")
PAUSE_RE = re.compile(r"^PAUSE:\s*(\d+(?:\.\d+)?)$")
CHAPTER_MARKERS = [
    (0, "开场：12,000 桶到底是什么", "先阻止自己把未定义的井口流量直接乘以油价。"),
    (6, "第一幕：地下没有原油湖", "从生成、运移、封存讲到孔隙度、渗透率和油藏驱动力。"),
    (33, "三种桶数不能混用", "分清地下原始石油、最终可采量和当前产量。"),
    (50, "第二幕：井是受控通道", "地震、钻井、套管、水泥、完井和井口控制各自解决什么问题。"),
    (81, "第三幕：井口流量还不是销售量", "油气水混合流必须经过分离、稳定、计量和质量确认。"),
    (101, "口算：10,000 如何变成 8,900", "在统一计量基准下，逐步扣除水和稳定处理移走的轻端。"),
    (118, "八个动词串起整条链", "生成、运移、封存、连通、流动、分离、稳定、计量。"),
    (124, "闭卷迁移：再看 12,000 桶", "用组成、处理口径和持续能力三道闸门判断一条产量新闻。"),
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def format_time(seconds: float) -> str:
    whole = int(seconds)
    return f"{whole // 60}:{whole % 60:02d}"


def parse_segments() -> list[dict[str, object]]:
    segments: list[dict[str, object]] = []
    for line_number, raw in enumerate(SCRIPT.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line:
            continue
        turn = TURN_RE.fullmatch(line)
        if turn:
            segments.append(
                {
                    "kind": "turn",
                    "speaker": turn.group(1),
                    "text": turn.group(2),
                    "line": line_number,
                }
            )
            continue
        pause = PAUSE_RE.fullmatch(line)
        if pause:
            segments.append(
                {
                    "kind": "pause",
                    "seconds": min(float(pause.group(1)), 30.0),
                    "line": line_number,
                }
            )
            continue
        raise ValueError(f"{SCRIPT}:{line_number}: unsupported script line")
    return segments


def add_timings(segments: list[dict[str, object]]) -> None:
    elapsed = 0.0
    cache_dir = RENDER_DIR / "segments"
    for index, segment in enumerate(segments):
        segment["start_seconds"] = round(elapsed, 3)
        segment["start_display"] = format_time(elapsed)
        if segment["kind"] == "pause":
            duration = float(segment["seconds"])
        else:
            matches = list(cache_dir.glob(f"{index:03d}-{segment['speaker']}-*.mp3"))
            if len(matches) != 1:
                raise ValueError(f"expected one rendered segment for index {index}, found {len(matches)}")
            duration = MP3(matches[0]).info.length
        segment["duration_seconds"] = round(duration, 3)
        elapsed += duration


def build_payload(segments: list[dict[str, object]]) -> dict[str, object]:
    audio = MP3(SOURCE_AUDIO)
    chapters = []
    for segment_index, title, summary in CHAPTER_MARKERS:
        start = float(segments[segment_index]["start_seconds"])
        chapters.append(
            {
                "title": title,
                "summary": summary,
                "start_seconds": start,
                "start_display": format_time(start),
            }
        )

    return {
        "series": "Oil 101 中文深度播客",
        "episode": "01",
        "title": "地下没有一座原油湖",
        "deck": "岩石里的烃，如何穿过地质、井筒和地面处理三组闸门，最终成为稳定、可计量、能进入商业系统的一桶液体。",
        "duration_seconds": round(audio.info.length, 3),
        "duration_display": format_time(audio.info.length),
        "published_audio": "../assets/audio/oil101/episode-01-underground-no-lake.mp3",
        "audio_sha256": sha256(SOURCE_AUDIO),
        "script_sha256": sha256(SCRIPT),
        "source_packet_sha256": sha256(SOURCE),
        "chapters": chapters,
        "takeaways": [
            "地下原油存在于岩石孔隙中；孔隙度决定能装多少，渗透率决定能否流动。",
            "地下原始石油、最终可采量、当前日产量是三种口径，不能互相替代。",
            "井是受控通道；钻井、完井、井口控制和人工举升解决的是不同问题。",
            "井口总流量通常仍含油、气和水，不能直接当作销售量或收入桶数。",
            "看到产量新闻，先问组成，再问处理与计量口径，最后问设施能否持续接住。",
        ],
        "sources": [
            {
                "label": "Oil 101: Exploration & Production",
                "url": "https://oil101.morgandowney.com/chapters/exploration-production",
            },
            {
                "label": "Oil 101: Components",
                "url": "https://oil101.morgandowney.com/chapters/components",
            },
            {
                "label": "Oil 101: Industry Overview",
                "url": "https://oil101.morgandowney.com/chapters/industry-overview",
            },
        ],
        "production": {
            "format": "双主持人中文深度讲解",
            "method": "经逐句事实审校的固定脚本与双声道神经语音合成",
            "transcript_relation": "逐字稿与合成输入完全一致",
            "notebooklm_notebook": (
                "https://notebook.google.com/notebook/1030df80-d6c2-4b3f-9a17-3680a19f064a"
            ),
            "notebooklm_status": "源资料与生成指令已就绪；当日 Audio Overview 配额已用尽",
        },
        "transcript": segments,
    }


def main() -> None:
    if not SOURCE_AUDIO.exists():
        raise SystemExit(f"missing rendered audio: {SOURCE_AUDIO}")

    segments = parse_segments()
    add_timings(segments)
    payload = build_payload(segments)

    PUBLISHED_AUDIO.parent.mkdir(parents=True, exist_ok=True)
    PUBLISHED_DATA.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SOURCE_AUDIO, PUBLISHED_AUDIO)
    PUBLISHED_DATA.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "audio": str(PUBLISHED_AUDIO.relative_to(ROOT)),
                "audio_bytes": PUBLISHED_AUDIO.stat().st_size,
                "data": str(PUBLISHED_DATA.relative_to(ROOT)),
                "segments": len(segments),
                "chapters": len(payload["chapters"]),
                "duration": payload["duration_display"],
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
