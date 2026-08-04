# Oil 101 Podcast Generation Run - 2026-08-04

## Scope

Use the three restored standard-account Audio Overview slots to build and submit Episodes 07, 08, and 09. Every packet was reconstructed from the current original-author Oil 101 web chapters rather than from earlier local summaries.

## Source boundaries

| Episode | Central question | Original sources |
| --- | --- | --- |
| 07 | Why can two fuels with the same product name still be non-interchangeable? | Chapters 8 Standards and 9 Finished Products |
| 08 | How do oil and gas molecules become materials instead of fuel? | Chapter 10 Petrochemicals; Chapter 3 Components only for feedstock boundaries |
| 09 | Why can a region be short when the world has enough oil? | Chapter 11 Transporting Oil |

## Preflight gate

Each episode passed all four checks before submission:

1. The live NotebookLM control read back `中文（简体）`.
2. The prompt contained `只能使用简体中文`.
3. `Deep Dive` was selected.
4. `Default` length was selected, with an explicit 15-minute ceiling in the prompt.

The language menu again briefly rendered stale English text immediately after keyboard selection. A fresh DOM readback showed the actual selected value as Simplified Chinese. Generation was blocked until that second readback passed.

## Submission results

| Episode | Notebook | Submission state |
| --- | --- | --- |
| 07 | <https://notebook.google.com/notebook/53e2aac7-4b06-4944-a3da-72757b158694> | Ready: `同名汽油为何不能互换`, 19:29; pending listening review |
| 08 | <https://notebook.google.com/notebook/c9cd11df-dcc0-4c19-80d2-e01d24f540c1> | Ready: `蒸汽裂解出的石化积木`, 11:46; pending listening review |
| 09 | <https://notebook.google.com/notebook/e2e8479d-70aa-42a4-86d7-916c671183f3> | Ready: `为什么有油你却加不到`, 17:59; pending listening review |

No daily-limit error occurred. These submissions consume all three standard Audio Overview slots restored on 2026-08-04. The outputs are not quality-approved until their Chinese language, pacing, repetition, factual clarity, and host dynamics have been checked by listening.

All three episodes completed in Simplified Chinese. Episode 07 runs 19:29, Episode 08 runs 11:46, and Episode 09 runs 17:59. Episode 08 is 14 seconds below the target window, while Episodes 07 and 09 exceed it; completion does not count as quality approval.

## Verification

- `oil101-podcast-production-v2.test.mjs`: passed for Episodes 02-09 before submission.
- Each source packet contains one central claim, three memory images, no calculations, no quizzes, and explicit exclusions.
