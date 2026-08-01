# Oil 101 Podcast Golden Exemplar: Episode 01 V2

## Sign-off record

- Exemplar: NotebookLM Simplified Chinese two-host Deep Dive for Episode 01 V2.
- Notebook: <https://notebook.google.com/notebook/f0b26921-48a1-475e-bedb-266652429a86>
- User verdict on 2026-08-01: “我对这版比较满意，说的重复的废话还是略多。”
- Production status: accepted as the baseline **with one mandatory repair**. Future episodes must retain the voice, clarity, and one-thread structure while reducing semantic repetition.

This is not approval of the earlier English mis-generation or the rejected local TTS V1.

## What future episodes must preserve

1. Natural male/female conversation rather than narrated lecture notes.
2. One central question that appears in the opening and is resolved at the end.
3. Three concrete mental images that carry the mechanism.
4. Beginner-friendly explanations without turning Host B into an examiner.
5. No recall pauses, quiz prompts, or listener arithmetic.
6. Source-bounded facts derived from the original author chapter pages.

## Mandatory improvement: semantic repetition

### Pass example

The opening asks why a well-test number is not a sales number. The middle returns to that number only after adding a new location, composition, or measurement condition. The ending resolves the question once.

### Fail example

The hosts say “wellhead volume is not sales volume,” then “the two numbers are different,” then “you cannot treat the first number as the second,” without adding a new mechanism or boundary.

### Anti-cheating rule

Changing vocabulary, swapping sentence order, or introducing another analogy does not count as new information. A repeated passage passes only if it adds a mechanism, condition, example, or boundary that changes the listener's model.

## Production delta for Episode 02 onward

- Default runtime: 12-17 minutes.
- Central claim: at most two full expressions, including near-paraphrases.
- Standalone recap blocks: zero.
- Main analogies per concept: one.
- Hard numbers: default zero to three.
- Every segment must declare the new information it contributes before generation.
- Adjacent episode concepts are invoked in one sentence and not retaught.
