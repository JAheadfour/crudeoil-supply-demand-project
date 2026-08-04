# Oil 101 Podcast Pipeline State

Updated: 2026-08-04

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
- [x] Confirm Episode 06 completed in Simplified Chinese at 20:30
- [x] Build Episodes 07-09 directly from original Chapters 8-11
- [x] Submit Episodes 07-09 after Simplified-Chinese preflight checks
- [x] Confirm Episode 07 completed in Simplified Chinese at 19:29
- [x] Confirm Episode 08 completed in Simplified Chinese at 11:46
- [x] Confirm Episode 09 completed in Simplified Chinese at 17:59
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
`EPISODE_BLUEPRINTS_V2.md`, and `episode-map-v2.json`. Episode 06 completed in
Simplified Chinese at 20:30 and remains pending listening review because it exceeds
the duration target. On 2026-08-04, the rolling allowance restored three Audio
Overview slots. Episodes 07, 08, and 09 were rebuilt directly from the original
Standards, Finished Products, Petrochemicals, Components, and Transporting Oil
pages. All three passed the Simplified-Chinese, explicit-language-constraint, Deep
Dive, and Default-length preflight checks and were accepted into generation without
a quota error. All three completed in Simplified Chinese: Episode 07 is `同名汽油为何不能互换`
at 19:29, Episode 08 is `蒸汽裂解出的石化积木` at 11:46, and Episode 09 is
`为什么有油你却加不到` at 17:59. All remain pending listening review; Episode 08
is 14 seconds under the target window, while Episodes 07 and 09 exceed it. Today's
three slots are now consumed. The next production action is to listen-review Episodes
04-09 against the Episode 01 V2 benchmark. Do not use fallback TTS.
