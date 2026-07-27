# Episode 01 Review Summary

Date: 2026-07-27

## Release candidate

- Title: 地下没有一座原油湖
- Duration: 26:22
- Format: Simplified Chinese, two-host deep dive
- Audio: `docs/assets/audio/oil101/episode-01-underground-no-lake.mp3`
- Exact timed transcript: `docs/data/podcast/episode-01.json`
- Public route: `/podcast/episode-01.html`

## Source boundary

The episode was rebuilt from the original-author Oil 101 pages rather than
from the site's earlier summaries:

- Exploration & Production
- Components
- Industry Overview

The source packet separates source claims, teaching constructions, prohibited
overclaims, unit rules, and required distinctions. The spoken script does not
introduce external factual claims beyond that reviewed packet.

## Independent review

Two separate review passes were completed before synthesis.

Factual review:

- First pass identified measurement-basis ambiguity, US artificial-lift
  denominator wording, wildcat terminology, OOIP/reserves distinctions,
  pressure wording, trap/seal mechanics, and stabilization boundaries.
- The packet, prompt, and script were repaired.
- Final result: approved with no open critical, important, or minor findings.

Teachability review:

- First pass identified terminology density, missing learner probes, an
  incomplete eight-verb recap, and insufficiently explicit causal transitions.
- The episode was revised to include three acts, two active-recall pauses, two
  complete calculations, recurring boundary questions, and a closed-book
  transfer test.
- Final result: approved with no open critical, important, or minor findings.

## Audio integrity

- Bytes: 12,671,929
- Duration: 1,582.248 seconds
- Bitrate: 64 kbps
- Sample rate: 24 kHz
- Channels: mono
- Speech segments: Host A 67, Host B 65
- Active-recall pauses: 4
- SHA-256:
  `6D5C33ADCA1ACF411A56C1377CBD7BBB14EAD73A3B8E90CDABA26207962D8915`

The 132 reviewed speech turns are decoded and encoded into one continuous
64-kbps MP3 stream. This avoids publishing a byte-level concatenation of many
small MP3 files and gives browsers a stable stream for duration detection and
random seeking.

The published transcript is generated from the exact synthesis input, with
timestamps calculated from each rendered speech segment. This gives a
deterministic text-to-audio correspondence; it is not an automatic
speech-recognition approximation.

## NotebookLM status

Notebook:
`https://notebook.google.com/notebook/1030df80-d6c2-4b3f-9a17-3680a19f064a`

The reviewed source packet and final generation instructions are preserved in
NotebookLM. Audio Overview generation hit the account's daily limit after the
FRM series generation performed earlier that day. The deterministic audited
version was therefore used for this release candidate; the NotebookLM variant
can be generated later without rebuilding the source work.

## Remaining acceptance gate

Automated checks can establish loading, duration, seek behavior, transcript
identity, layout, source links, and file integrity. They cannot decide whether
the voice chemistry and listening rhythm feel right to the intended listener.
No Episodes 02-12 should enter batch audio production until the user has
listened to this pilot and accepted or revised that experience.

## Publication verification

- Live page:
  `https://jaheadfour.github.io/crudeoil-supply-demand-project/podcast/episode-01.html`
- Page response: HTTP 200
- Audio response: HTTP 206 for byte-range requests
- Published range size: `bytes 0-1023/12671929`
- Service worker: v9; audio and Range requests bypass Cache API
- Automated live-browser result: desktop and 390-pixel mobile both loaded the
  26:22 duration, rendered 8 chapters and 136 transcript segments, and sought
  to 10:00 without a media error
- Final two-viewport online run: 9.2 seconds
