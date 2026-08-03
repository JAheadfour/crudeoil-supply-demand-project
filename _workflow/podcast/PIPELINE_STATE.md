# Oil 101 Podcast Pipeline State

Updated: 2026-08-03

## North star

- Process exemplar: FRM Reading 9 NotebookLM pilot
- Format exemplar: source-bounded Simplified Chinese two-host Deep Dive
- Signed Oil 101 episode exemplar: Episode 01 V2 accepted as the baseline with a mandatory semantic-repetition repair
- Mass-production rule: every episode uses one central question, three memory images, explicit exclusions, and a semantic-repetition gate
- Runtime language gate: select the last language option with keyboard navigation, move up twice, confirm `中文（简体）` by DOM readback, then require an explicit Simplified-Chinese-only instruction in the prompt; reject and delete any output whose title or spoken language is not Chinese

## Episode 01

- [x] Freeze episode boundary and causal spine
- [x] Draft source-bounded episode packet from original-author pages
- [x] Draft NotebookLM generation prompt
- [x] Independent factual and teachability review
- [x] Generate audited audio from the reviewed script
- [x] Verify media integrity, metadata, duration, and checksum
- [x] Produce an exact timed transcript from the synthesis input
- [x] Audit spoken claims against the source packet
- [x] Publish pilot to Oil 101 mobile site
- [x] User rejected V1 as the episode exemplar

## Episode 01 V2

- [x] Freeze the V1 rejection as a negative calibration fixture
- [x] Narrow the episode to one memorable claim
- [x] Remove quizzes, calculations, recall pauses, and equipment encyclopedism
- [x] Draft a podcast-native source packet from the original-source audit
- [x] Draft a NotebookLM prompt calibrated to the FRM voice benchmark
- [x] Generate the NotebookLM male/female Deep Dive in Simplified Chinese
- [ ] Download and verify media integrity
- [ ] Replace the public V1 audio only after listening review
- [x] User accepts V2 as the production baseline, with the required repair “reduce repetitive filler”

## Series V2 design

- [x] Recheck the 2026 web second-edition table of contents
- [x] Replace the old 12-episode exam-like format with a 19-episode understanding series
- [x] Map original Chapters 1-26 to at least one primary episode
- [x] Define one central question, three memory images, and explicit exclusions for Episodes 02-19
- [x] Add semantic-repetition gates and freeze Episode 01 V2 as the qualified golden exemplar
- [x] Produce Episode 02 source packet directly from the original Chapter 1 page
- [x] Submit Episodes 02-06 as Simplified Chinese NotebookLM Deep Dives
- [x] Regenerate Episode 04 after deleting the rejected Korean output
- [x] Resume Episode 05 after the daily allowance returned
- [x] Build Episode 06 directly from the original refining chapter and submit it
- [ ] Download and listen-review Episodes 02-03
- [ ] Download and listen-review Episodes 04-06

## Current gate

V1 remains a rejected, fact-audited artifact. An accidental English NotebookLM
generation is also non-deliverable. The Simplified Chinese Episode 01 V2 has
been generated and listened to by the user; it is the qualified golden
exemplar. Its voice, clarity, and single-thread structure pass, while semantic
repetition is the mandatory repair for every later episode.

The complete series contains 19 core episodes plus two appendix shorts. Design
work is complete in `podcast-series/oil101/SERIES_PLAN.md`,
`EPISODE_BLUEPRINTS_V2.md`, and `episode-map-v2.json`. On 2026-08-03, the daily
allowance returned. Episode 04 was regenerated in Simplified Chinese and is ready
at 17:58; Episode 05 is ready in Simplified Chinese at 13:39. Episode 06 was built
directly from the original refining chapter and submitted after all four preflight
checks passed; NotebookLM is still generating it. These outputs remain pending
listening review, so they are not yet qualified as final-quality releases. The next
production action is to finish Episode 06, then download and listen-review Episodes
04-06 against the Episode 01 V2 benchmark. Do not use fallback TTS.
