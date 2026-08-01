# Rejected Exemplar: Episode 01 V1

User verdict date: 2026-07-28

## Verdict

Rejected as the series exemplar.

The user preferred the male/female voices and overall podcast quality of the
FRM NotebookLM version. The Oil 101 V1 episode was judged:

- too didactic and dry;
- too numerically complicated;
- too repetitive;
- unclear about what mattered most;
- easy to drift away from while listening;
- low-retention despite high information volume;
- overly dependent on quizzes, recall prompts, and arithmetic.

## Root cause

V1 optimized for an auditable learning lesson rather than an audio program. It
treated the second host as an examiner, packed the full geology-to-meter chain
into one episode, and used explicit recalls, calculations, distinctions, and
recaps as if listening were a classroom session.

The deterministic Edge-TTS fallback also failed the FRM voice benchmark. A
correct transcript and exact text-to-audio alignment did not compensate for
weak host chemistry and flat prosody.

## Calibration rules for V2 and later episodes

| Dimension | Pass | Fail | Anti-cheat rule |
|---|---|---|---|
| Listening mode | Two people discover one surprising idea together | Lecturer asks a student questions | Removing the word “quiz” is insufficient if one host still behaves like an examiner |
| Focus | One sentence can state the episode's memorable claim | A complete chapter checklist drives the episode | Every technical detail must earn its place by advancing the central claim |
| Numbers | At most one hook number; no arithmetic unless the story collapses without it | Constructed calculations and percentage exercises | A number used only to demonstrate rigor does not qualify |
| Retention | Two or three concrete mental images recur naturally | Eight-term verbal chain or definition recap | Repetition must add a new consequence, not paraphrase an earlier definition |
| Interaction | Curious interruptions, surprise, clarification, market connection | Active recall pauses or closed-book transfer tests | A rhetorical question followed by a formal answer still counts as testing |
| Voice | NotebookLM Simplified Chinese Deep Dive male/female benchmark | Deterministic fallback TTS as the signed product | Factual audit cannot be used to waive the voice benchmark |
| Density | A commuting listener can follow without looking at notes | Many adjacent terms introduced within one minute | A plain-language gloss does not excuse excessive term count |

## Production consequence

V1 remains an internal factual-audit artifact and must not be presented as the
golden podcast exemplar. Episodes 02-12 remain blocked until the user signs a
new V2 audio exemplar.
