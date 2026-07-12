# Module 05 Writer Report

## Scope

- Assignment: Module 05, `module-05-inventory-curve`
- Canonical file: `course/data/oil101-understanding/module-05-inventory-curve.json`
- Published mirror: `docs/data/oil101-understanding/module-05-inventory-curve.json`
- Report file: `_workflow/runs/all-modules/module-05-writer-report.md`
- Work performed: complete beginner-first rewrite of module-level intro fields and all 5 lessons, preserving existing lesson IDs, source URLs, figure metadata, comparison table, term family, glossary, extreme detail, case, applications, self-checks, review prompts, and source coverage count.

## Required Files Read

- `_workflow/exemplars/golden-exemplar-module-01.json`
- `_workflow/exemplars/excellence-rubric.md`
- `docs/superpowers/plans/2026-07-11-oil101-all-modules-beginner-rewrite.md`
- `_workflow/scripts/validate-beginner-module.mjs`
- `course/data/oil101-understanding/module-05-inventory-curve.json`

## Source Pages Read

Directly opened and read all source URLs listed in the module:

- Oil 101 Chapter 12: Storage  
  `https://oil101.morgandowney.com/chapters/storage`
- Oil 101 Chapter 17: Oil Prices  
  `https://oil101.morgandowney.com/chapters/oil-prices`
- Oil 101 Chapter 18: Futures and Swaps  
  `https://oil101.morgandowney.com/chapters/futures-swaps`
- Oil 101 Chapter 23: When Oil Went Negative  
  `https://oil101.morgandowney.com/chapters/negative-prices`
- U.S. EIA: Low liquidity and limited available storage pushed WTI below zero  
  `https://www.eia.gov/todayinenergy/detail.php?id=43495`

## Lesson Rewrite Summary

- Lesson count preserved: 5
- Lesson IDs preserved:
  - `inventory-buffer`
  - `stock-flow`
  - `curve-carry`
  - `physical-convergence`
  - `reading-framework`
- Teaching order applied in each lesson:
  - reader question
  - physical scene
  - plain answer
  - mechanism chain
  - numeric worked example with actor, unit inputs, arithmetic, and decision impact
  - market meaning / practitioner lens
  - contextual terms
  - misreading and boundary
  - deep dive

## Source Coverage

- Original source coverage record count: 37
- Final source coverage record count: 37
- Coverage records were preserved without reduction.
- Existing semantic mapping was kept:
  - storage fundamentals and categories mapped to `inventory-buffer`
  - inventory reports mapped to `reading-framework`
  - forward curve and carry mapped to `curve-carry`
  - paper/wet barrels, physical convergence, and negative WTI mapped to `physical-convergence`
  - module-deferred items remain deferred in the original coverage records

## Product Interfaces Preserved

- `figures`: 1 retained, including EIA negative WTI figure metadata and reference.
- `comparison_tables`: retained.
- `term_family`: retained.
- `glossary`: 8 retained.
- `extreme_detail`: 4 retained.
- `cases`: 1 retained.
- `self_checks`: 5 retained.
- `applications`: 4 retained.
- `sources`: 5 retained.

## Validation

Node beginner validator:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-05-inventory-curve.json (5 lessons)
```

Python platform validator:

```text
FLOORS OK
```

Mirror and count proof:

```json
{
  "canonicalBytes": 48939,
  "docsBytes": 48939,
  "mirror_equal": true,
  "source_coverage_count": 37,
  "lesson_count": 5,
  "sources_count": 5
}
```

Commands run:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-05-inventory-curve.json
```

```powershell
$env:PYTHONIOENCODING='utf-8'; & 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-05-inventory-curve.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

## Concerns

- I did not stage or commit.
- The working tree contains unrelated modified and untracked files for other modules/runs; I did not edit or revert them.
- The JSON files were regenerated with pretty formatting, so the diff includes formatting expansion in retained arrays/objects as well as the content rewrite.

## Blind Review Repair Evidence

Repair scope was limited to the canonical Module 05 JSON, its published mirror, and this assigned report.

### First-Use Definitions and Jargon Audit

- Removed `WTI` and `Cushing` from `opening_question`, `learning_objectives`, and `main_thread`, so module-level prose no longer assumes either name.
- Defined futures at its first module-level use as a standardized, exchange-traded delivery-month contract. The definition states that positions are usually offset before expiry but remain subject to physical delivery near expiry.
- In `physical-convergence`, introduced the physical Oklahoma pipes and tanks before naming Cushing as the pipeline-and-tank delivery hub.
- Defined WTI as the U.S. light sweet crude benchmark and placed the example in the NYMEX CL contract context, including physical delivery at Cushing.
- Defined a long as a buy position, closing as selling the same delivery month and quantity, and rolling as selling the expiring contract and buying a later month.
- Defined a swap at first use as a contract that receives no oil and cash-settles the difference between the agreed price and settlement benchmark.
- Defined nearby first-use jargon for open interest and spot differentials in plain language.

Focused first-use assertion result:

```text
FOCUSED REPAIR OK: first-use definitions; non-Cushing +6,000,000 barrels; exit cash USD 376,300 is not total P&L
```

### Focused Arithmetic

The `reading-framework` example now states that the national commercial crude inventory total includes Cushing, then computes the implied non-Cushing change:

```text
Non-Cushing implied change = national change - Cushing change
= +4,000,000 barrels - (-2,000,000 barrels)
= +6,000,000 barrels
```

The inverse total check is explicit:

```text
6,000,000 barrels - 2,000,000 barrels = 4,000,000 barrels
```

The `physical-convergence` example computes the negative-price exit cash flow:

```text
-37.63 USD/barrel x 10,000 barrels = -376,300 USD
```

The lesson now states that USD 376,300 is cash paid to exit at the negative price. It is not total P&L because the entry price is undeclared, so total P&L cannot be calculated.

### Final Validation

Beginner validator:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-05-inventory-curve.json (5 lessons)
```

Understanding validator:

```text
FLOORS OK
```

Repository preservation validator:

```text
PRESERVATION OK: module-05-inventory-curve.json
```

Final mirror and count proof:

```json
{
  "canonicalBytes": 50670,
  "docsBytes": 50670,
  "mirror_equal": true,
  "source_coverage_count": 37,
  "lesson_count": 5,
  "sources_count": 5,
  "figure_count": 1,
  "self_check_count": 5
}
```

Preservation confirms the original five lesson IDs, five source URLs, 37 source-coverage records, one figure, and five self-checks remain intact. Canonical and docs files are byte-identical.

### Final Concerns

- No content concern remains from the three blind-review findings.
- No shared tests, renderer, catalog, session metadata, or other module was edited.
- No files were staged or committed.
