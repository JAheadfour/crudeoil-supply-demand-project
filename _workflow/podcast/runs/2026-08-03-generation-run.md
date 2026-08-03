# Oil 101 Podcast Generation Run — 2026-08-03

## Scope

Generate Episodes 04, 05, and 06 as NotebookLM two-host Deep Dives in Simplified Chinese. All source packets are bounded to the original Oil 101 chapter pages.

## Language-control incident and repair

NotebookLM's language menu did not honor the visible Playwright option click: selecting `中文（简体）` by option name landed on Korean again. The mismatch was caught before generation because the selected value was read back from the DOM.

The reliable sequence was:

1. Open the language combobox.
2. Confirm that `中文（简体）` exists in the menu snapshot.
3. Press `End`, `ArrowUp`, `ArrowUp`, `Enter`.
4. Read the selected value back and require `中文（简体）`.
5. Require the prompt to contain `只能使用简体中文` before enabling generation.

All three episodes passed four preflight checks: Simplified Chinese selected, explicit language hard constraint present, Deep Dive selected, and Default length selected.

## Results

| Episode | Notebook | Result | Audio title | Duration | Review state |
| --- | --- | --- | --- | --- | --- |
| 04 | <https://notebook.google.com/notebook/b6209e61-5777-4834-82ef-c7856b3fc68e> | Ready | 石油产量新高的统计幻觉 | 17:58 | Pending listening review; above the 12–15 minute target |
| 05 | <https://notebook.google.com/notebook/3b6d7ed7-1b59-4ecb-ad48-06ffdfbdc32c> | Ready | 谁在为十亿桶石油打工 | 13:39 | Pending listening review |
| 06 | <https://notebook.google.com/notebook/28098073-230a-4df4-aedd-e5674ea32dfa> | Generating | — | — | Pending generation and listening review |

No daily-limit error occurred during this run. A Chinese title confirms the output language at the artifact level, but does not substitute for a full listening review of pacing, repetition, factual clarity, and host dynamics.

## Verification

- `oil101-podcast-production-v2.test.mjs`: passed for Episodes 02–06.
- `oil101-podcast-plan-v2.test.mjs`: passed; 19 core episodes cover Chapters 1–26.
- Production test now requires every prompt from Episode 04 onward to contain the Simplified-Chinese-only hard constraint.
