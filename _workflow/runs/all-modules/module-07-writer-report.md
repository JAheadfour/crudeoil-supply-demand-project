# Module 07 Writer Report

## Scope

- Assignment: Module 07, `course/data/oil101-understanding/module-07-producers-opec-shale.json`
- Mirror updated: `docs/data/oil101-understanding/module-07-producers-opec-shale.json`
- Shared files, tests, renderer, catalog, and session metadata were not edited.
- No staging or commit performed.

## Rewrite Summary

- Rewrote the complete module-level teaching path and all 7 lessons to the Module 01 beginner-first standard.
- Preserved lesson IDs:
  `supply-power-history`, `project-pipeline`, `reserves-bookability`, `shale-short-cycle`, `opec-spare-capacity`, `hormuz-forced-shutins`, `supply-dashboard`.
- Preserved source URLs, figures/reference metadata, comparison tables, glossary, cases, applications, self-checks, and `source_coverage`.
- Added required lesson fields throughout: `reader_question`, physical `scene`, `plain_answer`, mechanism chain, worked example with actor/inputs/units/arithmetic/decision meaning, market meaning, contextual terms, misreading/boundary, and deep dive.
- Added missing `core_model.premises` and `core_model.breaks_when` required by the app validator.

## Source Discipline

Directly opened and read all listed Morgan Downey Oil 101 sources:

- `https://oil101.morgandowney.com/chapters/history`
- `https://oil101.morgandowney.com/chapters/exploration-production`
- `https://oil101.morgandowney.com/chapters/reserves`
- `https://oil101.morgandowney.com/chapters/shale-revolution`
- `https://oil101.morgandowney.com/chapters/opec-plus`
- `https://oil101.morgandowney.com/chapters/iran-strait`

Directly opened/read listed primary sources:

- EIA OPEC capacity definitions, including maximum sustainable capacity, effective capacity, disruptions, and surplus capacity.
- EIA July 7, 2026 STEO global oil markets page; preserved release date and recovery context for the 2026 Hormuz episode.
- IEA March 11, 2026 emergency stock release.
- IEA March 2026 Oil Market Report.
- OPEC Declaration of Cooperation materials at the module's existing generic OPEC+ URL; the repair retains only the policy mechanism because the artifact does not preserve an exact dated adjustment-release URL.

Time-sensitive claims are dated in the prose. The 2026 Hormuz material is treated as a bounded disruption/recovery episode, not a permanent condition.

## Validation

- Literal command attempted:
  `node _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-07-producers-opec-shale.json`
  Result: blocked because `node` is not installed/on PATH in this PowerShell environment.
- Local Python equivalent of the beginner-module validator:
  `BEGINNER MODULE OK: course/data/oil101-understanding/module-07-producers-opec-shale.json (7 lessons)`
- Python app validator:
  `build_course_app.validate_module(..., 'understanding')`
  Result: `FLOORS OK`
- Mirror equality:
  `mirror equal`
- Source coverage count:
  `68`

## Notes For Reviewer

- The module now teaches supply power through physical conversion gates first: time to first oil, decline, spare capacity, export routes, and investment constraints.
- It explicitly distinguishes resources, reserves, capacity, production, restrictions, and exportable barrels.
- Worked examples use declared actors, numeric inputs with units, arithmetic expressions, and decision consequences.

## Blind-Review Repair Evidence — 2026-07-11

The earlier validation note that Node was unavailable is superseded by this repair run. The bundled runtime was located and used directly at `C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe`.

### Repairs

- Reproduced the reported failure with the actual bundled Node validator. It failed only at `reserves-bookability: explicit arithmetic` because the gate does not recognize `million` as a unit modifier.
- Rewrote the reserve calculation with recognized explicit units throughout: `500,000,000 barrels × 35% = 175,000,000 barrels`, followed by `175,000,000 barrels × 60% = 105,000,000 barrels` and `175,000,000 barrels × 40% = 70,000,000 barrels`.
- Removed `million barrels` from every worked-example input, setup, and calculation operand. The Hormuz storage example now uses `120,000,000 barrels ÷ 12.0 Mbpd = 10 days`; the supply-dashboard discovery uses `1,000,000,000 barrels`.
- Removed the precise `2026年7月5日` and `188 kbpd` OPEC claim. The lesson now retains only the generic OPEC+ mechanism of member coordination and voluntary adjustment, supported by the existing listed OPEC+ materials URL, and explicitly avoids treating an unlinked dated quantity as verified.
- No source URL or source-coverage record was added, removed, or remapped.

### Dynamic-Fact Traceability Audit

- EIA Short-Term Energy Outlook, released `2026-07-07`: supports the effective closure from `2026-02-28`, the `2026-06-18` MOU/opening context, average June shut-ins of `8.3 Mbpd`, the May peak of `11.2 Mbpd`, and gradual recovery toward pre-conflict patterns by year-end. Existing listed URL: `https://www.eia.gov/outlooks/steo/report/global_oil.php`.
- IEA Oil Market Report, published `2026-03-12`: supports pre-war flows of about `20 Mbpd` falling to a trickle and Gulf-country total oil-production cuts of at least `10 Mbpd`. Existing listed URL: `https://www.iea.org/reports/oil-market-report-march-2026`.
- IEA emergency-stock press release, published `2026-03-11`: supports the `400 million barrels` collective release. Existing listed URL: `https://www.iea.org/news/iea-member-countries-to-carry-out-largest-ever-oil-stock-release-amid-market-disruptions-from-middle-east-conflict`.
- EIA capacity-definition article, published `2025-12-19`: supports effective capacity as production reachable within `90 days`, sustainable under sound practices, and net of disruptions. Existing listed URL: `https://www.eia.gov/todayinenergy/detail.php?id=66904`.
- Exact publication dates were added in the lesson prose where the earlier wording named only a month. All remaining 2026 factual quantities have a dated listed-source path; hypothetical worked-example values remain presented as assumptions, not current facts.

### Focused Recalculation Audit

All seven lesson examples were recomputed from declared inputs:

- Supply control: `2.0 Mbpd - 0.6 Mbpd = 1.4 Mbpd`.
- Project pipeline: `200,000 bpd × 60% = 120,000 bpd`; `120,000 bpd × 365 days = 43,800,000 barrels`.
- Reserves: `500,000,000 barrels × 35% = 175,000,000 barrels`; the `60%` and `40%` splits equal `105,000,000 barrels` and `70,000,000 barrels`.
- Shale: decline is `200,000 bpd`, net addition is `60,000 bpd`, and ending flow is `560,000 bpd`.
- OPEC target example: target is `3.5 Mbpd` and actual reduction is `0.1 Mbpd`.
- Hormuz: export gap is `12.0 Mbpd` and `120,000,000 barrels` provides `10 days` of storage at that gap.
- Dashboard: annual first-year flow is `43,800,000 barrels`, or `4.38%` of `1,000,000,000 barrels`.

Focused assertion result: `FOCUSED OK: 7 examples recomputed; explicit barrel units; dated source markers; unsupported OPEC precision absent`.

### Final Repair Checks

Actual bundled Node beginner validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-07-producers-opec-shale.json
```

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-07-producers-opec-shale.json (7 lessons)
```

Understanding validator:

```text
FLOORS OK
```

Preservation gate:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/verify-module-preservation.mjs module-07-producers-opec-shale.json
```

```text
PRESERVATION OK: module-07-producers-opec-shale.json
```

Mirror and count proof:

```text
MIRROR OK: byte_equal=True bytes=83784 lessons=7 sources=11 source_coverage=68
```
