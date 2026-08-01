# Oil 101 Podcast Pipeline State

Updated: 2026-08-01

## North star

- Process exemplar: FRM Reading 9 NotebookLM pilot
- Format exemplar: source-bounded Simplified Chinese two-host Deep Dive
- Signed Oil 101 episode exemplar: Episode 01 V2 accepted as the baseline with a mandatory semantic-repetition repair
- Mass-production rule: every episode uses one central question, three memory images, explicit exclusions, and a semantic-repetition gate
- Runtime language gate: after filling the prompt, re-read the NotebookLM language control and require `中文（简体）`; reject and delete any output whose title or spoken language is not Chinese

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
- [x] Submit Episodes 02-04 as Simplified Chinese NotebookLM Deep Dives
- [x] Prepare Episode 05 and stop at NotebookLM's first explicit daily Audio Overview limit
- [ ] Download and listen-review Episodes 02-03
- [ ] Regenerate Episode 04 after deleting the rejected Korean output
- [ ] Resume with the prepared Episode 05 notebook after the daily allowance returns

## Current gate

V1 remains a rejected, fact-audited artifact. An accidental English NotebookLM
generation is also non-deliverable. The Simplified Chinese Episode 01 V2 has
been generated and listened to by the user; it is the qualified golden
exemplar. Its voice, clarity, and single-thread structure pass, while semantic
repetition is the mandatory repair for every later episode.

The complete series now contains 19 core episodes plus two appendix shorts.
Design work is complete in `podcast-series/oil101/SERIES_PLAN.md`,
`EPISODE_BLUEPRINTS_V2.md`, and `episode-map-v2.json`. On 2026-08-01,
Episodes 02, 03, and 04 were accepted by NotebookLM as Simplified Chinese Deep
Dives. Episodes 02 and 03 are ready pending listening review. Episode 04 completed
in Korean, was rejected and deleted, and its corrected Simplified Chinese retry
was blocked by the daily limit after both the UI language and prompt constraint
were verified. Episode 05 was fully prepared and uploaded,
but its generation request returned `You have reached your daily Audio Overview
limits, come back later.` No later episodes were submitted. The next production
action is to listen-review Episodes 02-03, regenerate Episode 04 from its existing
notebook, then resume from the existing Episode 05 notebook after the allowance
returns. Do not use fallback TTS.
