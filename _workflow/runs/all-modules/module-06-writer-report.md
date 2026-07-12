# Module 06 Writer Report

## Scope

- Canonical: `course/data/oil101-understanding/module-06-risk-management.json`
- Published mirror: `docs/data/oil101-understanding/module-06-risk-management.json`
- Report: `_workflow/runs/all-modules/module-06-writer-report.md`
- Assignment focus: begin with producer/refiner/airline/trader physical cash-flow exposure, then build toward futures, swaps, options, basis, roll, risk metrics, governance, and perpetuals.

## Source Reading

- Read `_workflow/exemplars/golden-exemplar-module-01.json`.
- Read `_workflow/exemplars/excellence-rubric.md`.
- Read `docs/superpowers/plans/2026-07-11-oil101-all-modules-beginner-rewrite.md`.
- Read `_workflow/scripts/validate-beginner-module.mjs`.
- Read current canonical Module 06 JSON to preserve IDs, source mappings, figure metadata, cases, self-checks, glossary, applications, and product interfaces.
- Directly opened Oil 101 Chapter 18: `https://oil101.morgandowney.com/chapters/futures-swaps`.
- Directly opened Oil 101 Chapter 19: `https://oil101.morgandowney.com/chapters/options`.
- Directly opened Oil 101 Chapter 20: `https://oil101.morgandowney.com/chapters/risk-management`.
- Directly opened Oil 101 Appendix 1: `https://oil101.morgandowney.com/appendices/forward-markets-mechanics`.
- Directly opened Oil 101 Appendix 3 with approved network access after sandbox failure: `https://oil101.morgandowney.com/appendices/perpetual-futures`.
- Also checked current CME WTI and ICE Brent product pages for time-sensitive contract-spec context; the lesson text keeps execution-specific rules framed as current-rulebook checks rather than timeless facts.

## What Changed

- Rewrote the module-level title, deck, intent, opening question, quick answer, objectives, main thread, and mental model in beginner-facing Chinese.
- Rebuilt all seven lessons into the signed teaching sequence:
  - reader question
  - physical scene
  - plain answer
  - mechanism chain
  - worked numeric example with actor, inputs, units, arithmetic, and decision impact
  - market meaning via `practitioner_lens`
  - contextual terms
  - misreading and boundary
  - deep dive
- Preserved all lesson IDs:
  - `exposure`
  - `linear-hedge`
  - `options`
  - `basis-roll`
  - `risk-metrics`
  - `governance`
  - `perpetuals`
- Preserved module-level figure metadata, cases, applications, review prompts, glossary, self-checks, formulas, and all source records.

## Preservation Checks

- Source record count preserved: 5.
- Source coverage record count preserved: 48.
- Figure record count preserved: 1.
- Case record count preserved: 2.
- Self-check record count preserved: 8.
- Canonical and docs mirror were written from the same serialized JSON text.

## Validation

- PASS: `C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-06-risk-management.json`
  - Output: `BEGINNER MODULE OK: course/data/oil101-understanding/module-06-risk-management.json (7 lessons)`
- PASS: Python `build_course_app.validate_module(..., 'understanding')`
  - Output: `FLOORS OK`
- PASS: canonical/docs mirror byte equality
  - Output: `MIRROR OK bytes=85768`
- PASS: source and product count check
  - Output: `sources=5 source_coverage=48 lessons=7 self_checks=8`

## Blind-Review Repair (2026-07-11)

### Contract-spec correction and dynamic-claim audit

- Rechecked the reader-facing WTI/Brent contract table against primary exchange materials accessed 2026-07-11:
  - ICE Brent Crude Futures product 219: `https://www.ice.com/products/219/Brent-Crude-Futures`
  - CME NYMEX Rulebook Chapter 200: `https://www.cmegroup.com/rulebook/NYMEX/2/200.pdf`
  - CME NYMEX energy daily settlement procedure: `https://www.cmegroup.com/trading/energy/files/NYMEX_Energy_Futures_Daily_Settlement_Procedure.pdf`
- Corrected ICE daily settlement to the weighted average during the two-minute period beginning at 19:28 London time.
- Corrected ICE expiry/delivery language: the contract is deliverable through EFP, with an option to cash settle against the ICE Brent Index for the last trading day. Removed the incorrect framing of cash as the default and removed the incorrect description of physical delivery as entry into 21-day BFOETM.
- Kept BFOETM, Dated Brent, and CFDs only as context for the basis plumbing between physical, forward, and futures prices.
- Added the 2026-07-11 verification date to the comparison-table title, dated the WTI contract-size formula and EFP-example inputs, and retained the instruction to recheck the current rulebook before trading.
- Audited nearby dynamic venue examples. The perpetual worked example now labels price, notional, funding rate, and eight-hour frequency as teaching assumptions rather than current platform specifications.

### Worked-example repair

- The producer collar now declares a 4 USD/bbl bought-put premium and an equal 4 USD/bbl sold-call premium on 100,000 bbl before arithmetic.
- It explicitly recomputes each premium leg as 400,000 USD and net premium as `400,000 - 400,000 = 0 USD`, while stating that brokerage, bid-offer, margin funding, and tax are excluded from the teaching assumption.
- Declared the 55 USD/bbl and 90 USD/bbl expiry scenarios before their 1,000,000 USD payoff calculations.
- Declared the perpetual example's 75 USD/bbl notional input before computing 7,500,000 USD notional and 3,750 USD funding.
- Declared the stress example's 18,000,000 USD paper loss, 7,000,000 USD exchange margin, and 5,000,000 USD OTC collateral before computing 12,000,000 USD cash need.

### Post-repair evidence

- PASS: bundled Node beginner validator
  - Output: `BEGINNER MODULE OK: course/data/oil101-understanding/module-06-risk-management.json (7 lessons)`
- PASS: Python `build_course_app.validate_module(..., 'understanding')`
  - Output: `FLOORS OK`
- PASS: canonical/docs byte equality
  - Output: `MIRROR OK bytes=87300`
- PASS: preservation count
  - Output: `sources=5 source_coverage=48 lessons=7 self_checks=8`
- PASS: focused recomputations
  - Collar premiums: `4 × 100,000 = 400,000 USD` on each leg; net premium `= 0 USD`.
  - Collar expiry payoffs: `(65 - 55) × 100,000 = 1,000,000 USD`; `(90 - 80) × 100,000 = 1,000,000 USD`.
  - EFP quantity: `500 contracts × 1,000 bbl = 500,000 bbl`; the contract-unit input carries the 2026-07-11 verification date.
  - Perpetual teaching assumptions: `75 × 100,000 = 7,500,000 USD`; `7,500,000 × 0.05% = 3,750 USD`.
  - Stress liquidity: `7,000,000 + 5,000,000 = 12,000,000 USD`.
  - ICE assertions found in canonical text: daily settlement contains `19:28`; expiry terms contain both `EFP` and `ICE Brent Index`.
- PASS: `git diff --check` for the canonical, mirror, and report; only the existing Windows LF-to-CRLF advisory was emitted.
