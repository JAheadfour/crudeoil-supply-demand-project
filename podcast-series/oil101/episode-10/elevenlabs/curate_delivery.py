#!/usr/bin/env python3
"""Reduce repetitive Enhance tags while preserving frozen spoken words."""

from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SANITIZED = ROOT / "sanitized-canonical.json"
CANONICAL = ROOT.parent / "frozen" / "canonical.json"
OUTPUT = ROOT / "final-canonical.json"
REPORT = ROOT / "delivery-curation-report.json"

# Sparse cues mark genuine changes in stance; unlisted turns rely on punctuation.
KEEP_TURNS = {2, 8, 14, 18, 22, 27, 38, 46, 51, 53, 56, 58}
TAG_RE = re.compile(r"^\[([^\]\r\n]+)\]\s*")


def main() -> int:
    sanitized = json.loads(SANITIZED.read_text(encoding="utf-8"))
    canonical = json.loads(CANONICAL.read_text(encoding="utf-8"))
    kept = Counter()

    for index, (turn, frozen) in enumerate(
        zip(sanitized["turns"], canonical["turns"], strict=True), start=1
    ):
        match = TAG_RE.match(str(turn["text"]))
        tag = match.group(1).lower() if match and index in KEEP_TURNS else None
        turn["text"] = f"[{tag}] {frozen['text']}" if tag else frozen["text"]
        if tag:
            kept[tag] += 1

    mismatches = []
    for index, (turn, frozen) in enumerate(
        zip(sanitized["turns"], canonical["turns"], strict=True), start=1
    ):
        spoken = TAG_RE.sub("", str(turn["text"]))
        if spoken != str(frozen["text"]):
            mismatches.append(index)

    sanitized["status"] = "studio-enhance-curated"
    sanitized["delivery_enhancement"]["policy"] = (
        "Restore canonical words and retain sparse Enhance cues only at stance changes."
    )
    sanitized["delivery_enhancement"]["tagged_turns"] = sorted(KEEP_TURNS)
    sanitized["delivery_enhancement"]["kept_tag_counts"] = dict(kept)

    report = {
        "status": "PASS" if not mismatches else "FAIL",
        "turns": len(sanitized["turns"]),
        "tagged_turns": sorted(KEEP_TURNS),
        "tag_count": sum(kept.values()),
        "kept_tag_counts": dict(kept),
        "spoken_word_mismatches_after_removing_tags": mismatches,
    }
    OUTPUT.write_text(json.dumps(sanitized, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    REPORT.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if report["status"] == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
