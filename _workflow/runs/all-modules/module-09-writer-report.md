# Module 09 Writer Report

## Scope

Owned files only:

- `course/data/oil101-understanding/module-09-industry-synthesis-lab.json`
- `docs/data/oil101-understanding/module-09-industry-synthesis-lab.json`
- `_workflow/runs/all-modules/module-09-writer-report.md`

No staging, no commit, and no edits outside this scope.

## Governing Inputs Read

- Signed exemplar: `_workflow/exemplars/golden-exemplar-module-01.json`
- Rubric: `_workflow/exemplars/excellence-rubric.md`
- Plan: `docs/superpowers/plans/2026-07-11-oil101-all-modules-beginner-rewrite.md`
- Baseline: `_workflow/runs/all-modules/baseline.json`
- Validators: `_workflow/scripts/validate-beginner-module.mjs`, `_workflow/scripts/verify-module-preservation.mjs`
- Current Module 09 canonical and docs mirror for interfaces and preserved IDs/counts.

## Source Reading

Directly read all six Oil101 chapter source layers:

- `outputs/oil101-KB/part-three-modern-era/21-shale-revolution/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/22-opec-plus/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/23-negative-prices/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/24-us-lng/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/25-energy-transition/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/26-iran-strait/00-source-layer.md`

Old reader prose was treated only as interface context, not as factual input.

Directly checked all eight listed primary sources:

- [EIA, Strait of Hormuz, June 16, 2025](https://www.eia.gov/todayinenergy/detail.php?id=65504): 2024 oil flow through Hormuz averaged 20 million b/d, about 20% of global petroleum liquids consumption; about one-fifth of global LNG trade also moved through the strait. EIA also reported about 2.6 million b/d of available Saudi/UAE bypass pipeline capacity and Asia as the main destination region.
- [CFTC, May 2020 WTI report release, November 23, 2020](https://www.cftc.gov/PressRoom/PressReleases/8315-20): May 2020 WTI settled at -$37.63/bbl on April 20, 2020 after opening at $17.73/bbl; CFTC attributed the event to fundamental factors, including COVID demand loss, oversupply and storage concerns, plus technical factors including high open interest, trader exits and reduced liquidity.
- [EIA, U.S. LNG exports in 2024, March 27, 2025](https://www.eia.gov/todayinenergy/detail.php?id=64844): U.S. LNG exports averaged 11.9 Bcf/d in 2024; Europe including Turkiye took 53% or 6.3 Bcf/d; Asia took 33% or 4.0 Bcf/d; seven terminals averaged 104% of nominal capacity and 86% of peak capacity.
- [EIA, tight oil production, June 2, 2025](https://www.eia.gov/todayinenergy/detail.php?id=65404): Lower 48 onshore production more than tripled since January 2010; tight oil rose from 0.8 million b/d in 2010 to 8.9 million b/d in 2024; Permian production was 5.6 million b/d in December 2024.
- [OPEC, 9th Extraordinary OPEC and non-OPEC Ministerial Meeting, April 9, 2020](https://www.opec.org/pr-detail/313-09-apr-2020.html): OPEC+ announced adjustments of 10.0 million b/d for May-June 2020, then 8.0 million b/d for July-December 2020, then 6.0 million b/d for January 2021-April 2022, with October 2018 baselines except Saudi Arabia and Russia at 11.0 million b/d.
- [IEA, Global EV Outlook 2025, electric car market trends](https://www.iea.org/reports/global-ev-outlook-2025/trends-in-electric-car-markets-2): global electric car sales topped 17 million in 2024, above 20% of new car sales; the global electric car fleet reached almost 58 million, about 4% of the passenger car fleet.
- [IEA, Global EV Outlook 2025, energy demand outlook](https://www.iea.org/reports/global-ev-outlook-2025/outlook-for-energy-demand): EVs displaced over 1.3 million b/d of oil demand in 2024; under STEPS, displacement exceeds 5 million b/d by 2030.
- [IRENA, Renewable Capacity Statistics 2025 PDF](https://www.irena.org/-/media/Files/IRENA/Agency/Publication/2025/Mar/IRENA_DAT_RE_Capacity_Statistics_2025.pdf): by end-2024 renewables were 46% of global installed power capacity; 2024 renewable additions were 585 GW, 92.5% of global power additions; solar added 452 GW and wind 113 GW.

Time-sensitive facts in the module are dated in prose. Unsupported precision from the old module or non-primary prose was not reused.

## Rewrite Summary

Rebuilt Module 09 as a synthesis method for a finance/econ reader with no oil operations background. The seven preserved lesson IDs now teach the sequence:

1. Classify the shock by the first changed observable.
2. Quantify flows, baselines and lags.
3. Locate the bottleneck using marginal available capacity.
4. Track inventory migration across crude, storage, refining, products and transport.
5. Use relative prices to locate time, place, quality and conversion constraints.
6. Model actor reaction functions with speed, tools and limits.
7. Write falsifiable next checks and explicit invalidation rules.

Each lesson now includes a reader question, physical scene, plain answer, mechanism chain, worked example with actor, numeric inputs, units, explicit arithmetic and decision meaning, practitioner/market link, contextual terms, misreading/boundary and deep dive. Core oil terms such as WTI, Cushing, OPEC+, LNG, Henry Hub, TTF, JKM, EV oil displacement and spare route are explained before or at first use.

## Preservation

Preserved exact lesson IDs:

- `shock-classification`
- `flow-and-lag`
- `bottleneck-geometry`
- `inventory-migration`
- `relative-price-map`
- `reaction-functions`
- `falsifiable-thesis`

Preserved required structural counts:

- 14 sources
- 63 source coverage records
- 1 figure/reference
- 7 lessons
- 7 self-checks
- 3 cases
- 6 applications
- 14 glossary entries

The source coverage records remain present and mapped honestly to the rewritten teaching surfaces, including all six Oil101 chapters and all eight primary-source records.

## Validation Evidence

Node beginner validator:

```text
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow\scripts\validate-beginner-module.mjs course\data\oil101-understanding\module-09-industry-synthesis-lab.json
BEGINNER MODULE OK: course\data\oil101-understanding\module-09-industry-synthesis-lab.json (7 lessons)
```

Strict understanding validator:

```text
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-09-industry-synthesis-lab.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
FLOORS OK
```

Preservation gate:

```text
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow\scripts\verify-module-preservation.mjs module-09-industry-synthesis-lab.json
PRESERVATION OK: module-09-industry-synthesis-lab.json
```

Mirror and coverage check:

```text
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' -e "const fs=require('fs'); const c=fs.readFileSync('course/data/oil101-understanding/module-09-industry-synthesis-lab.json'); const d=fs.readFileSync('docs/data/oil101-understanding/module-09-industry-synthesis-lab.json'); const m=JSON.parse(c); console.log(JSON.stringify({mirror_bytes_equal:Buffer.compare(c,d)===0,lessons:m.lessons.length,sources:m.sources.length,source_coverage:m.source_coverage.length,figures:(m.figures||[]).length,self_checks:m.self_checks.length,cases:m.cases.length,applications:m.applications.length,glossary:m.glossary.length},null,2))"
{
  "mirror_bytes_equal": true,
  "lessons": 7,
  "sources": 14,
  "source_coverage": 63,
  "figures": 1,
  "self_checks": 7,
  "cases": 3,
  "applications": 6,
  "glossary": 14
}
```

Focused case arithmetic:

```text
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' -e "const round=x=>Math.round(x*100)/100; if(round(17.73-55.36)!==-37.63) throw new Error('WTI arithmetic'); if(5000000-2600000!==2400000) throw new Error('Hormuz gap'); if(48000000/2400000!==20) throw new Error('Hormuz buffer'); if(12-10-1!==1) throw new Error('LNG netback'); if(1*3000000!==3000000) throw new Error('LNG cargo'); console.log('CASE ARITHMETIC OK: WTI -37.63; Hormuz 2400000 bpd and 20 days; LNG 1 USD/MMBtu and 3000000 USD');"
CASE ARITHMETIC OK: WTI -37.63; Hormuz 2400000 bpd and 20 days; LNG 1 USD/MMBtu and 3000000 USD
```

Scoped diff check:

```text
git diff --check -- course/data/oil101-understanding/module-09-industry-synthesis-lab.json docs/data/oil101-understanding/module-09-industry-synthesis-lab.json _workflow/runs/all-modules/module-09-writer-report.md
warning: in the working copy of 'course/data/oil101-understanding/module-09-industry-synthesis-lab.json', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/data/oil101-understanding/module-09-industry-synthesis-lab.json', LF will be replaced by CRLF the next time Git touches it
```

The diff check returned exit code 0; only Git line-ending warnings were reported.

## Blind Review Repair — 2026-07-12

Repaired only the canonical Module 09 JSON, its docs mirror, and this report.

### Definitions Before Use

- Added compact opening-path decoders for all eight requested terms, with the physical object or place first: WTI, Cushing, OPEC+, LNG, EV, Henry Hub, TTF, and JKM.
- Split the decoders across short `reading_intent` paragraphs and `main_thread`; kept `opening_question` in plain language so the opening does not become a parenthetical wall.
- Added eight durable glossary records with `definition`, `example`, and `confusion`. Glossary count is now 22; required source and preservation counts are unchanged.

### Source Coverage Audit

Audited all 63 `source_coverage` records. The 60 unflagged rows matched an existing teaching surface or already carried an explicit selective/deferred limitation. Three overclaims were repaired without changing the count:

- `Lifting the Crude Export Ban`: added a `bottleneck-geometry` deep dive explaining that legal export access lets domestic light sweet crude reach overseas refinery demand, easing a regional mismatch without creating production.
- `Consolidation and the Chevron-Hess Deal`: marked deferred to Module 07 because Module 09 teaches only the generic capital-discipline mechanism and the transaction status requires separate company/regulatory primary-source verification.
- `FSRUs and Europe's 2022 Scramble`: added a `reaction-functions` deep dive defining an FSRU as a floating storage and regasification vessel, explaining its faster receiving-capacity response and its berth, pipeline, and cargo constraints; project lists and dates remain deferred without primary verification.

### Hypothetical Input Audit

- All 24 numeric inputs across the seven lesson worked examples now say either `假设教学输入（非历史事实）` or `来源事实` with the source date.
- Case 1 distinguishes the two CFTC source prices from the derived price change.
- Case 2 labels the 5,000,000 bpd disruption and 48,000,000 barrel inventory as hypothetical teaching inputs, while identifying EIA's dated 2,600,000 bpd bypass estimate as a source fact.
- Case 3 labels the 12/10/1 USD/MMBtu prices and cost plus the 3,000,000 MMBtu cargo as hypothetical, not market quotes or a real cargo.

### Repair Validation Evidence

Actual Node beginner validator:

```text
BEGINNER MODULE OK: course\data\oil101-understanding\module-09-industry-synthesis-lab.json (7 lessons)
```

Actual strict understanding validator:

```text
FLOORS OK
```

Actual preservation gate:

```text
PRESERVATION OK: module-09-industry-synthesis-lab.json
```

Mirror, coverage, glossary, and assumption-label audit:

```json
{
  "mirror_bytes_equal": true,
  "lessons": 7,
  "sources": 14,
  "source_coverage": 63,
  "figures": 1,
  "self_checks": 7,
  "cases": 3,
  "applications": 6,
  "glossary": 22,
  "required_decoders": 8,
  "worked_inputs_labeled": 24
}
```

Focused arithmetic runner checked every lesson and case:

```text
ARITHMETIC OK: lessons 1-7 and cases 1-3 (20 checks)
```

No staging and no commit.

## Final Visible-Order Repair — 2026-07-12

The renderer was read but not changed. It displays `opening_question`, `quick_answer`, `learning_objectives`, and then `main_thread`; it does not display `reading_intent`.

### Visible Definitions

- Kept `opening_question` and `quick_answer` acronym-free.
- Replaced the first visible objective's `OPEC+` and `LNG` acronyms with plain-language `产油国联盟` and `液化天然气贸易商`.
- Rewrote `main_thread` so each requested first visible use carries a compact physical-first decoder: WTI as the U.S. light-sweet crude benchmark in NYMEX deliverable-contract context; Cushing as the Oklahoma pipeline-and-tank delivery hub; OPEC+ as the producer alliance; LNG as liquefied gas moved by specialized ship; EV as a vehicle driven by an onboard battery and electric motor.
- Rechecked Henry Hub, TTF, and JKM. Their first visible uses remain decoded respectively as the U.S. gas hub, Dutch-European virtual gas hub, and Northeast Asian delivered-LNG price marker.

### Case 1 Arithmetic Repair

`cases[0].model_answer[1]` now distinguishes all three quantities:

```text
price change = -37.63 - 17.73 = -55.36 USD/bbl
absolute decline = 55.36 USD/bbl
endpoint cross-check = 17.73 - 55.36 = -37.63 USD/bbl
```

The endpoint equation is no longer called the decline.

### Final Validation Evidence

Actual Node beginner validator:

```text
BEGINNER MODULE OK: course\data\oil101-understanding\module-09-industry-synthesis-lab.json (7 lessons)
```

Global platform test:

```text
tests 18
pass 18
fail 0
```

Actual strict understanding validator:

```text
FLOORS OK
```

Actual preservation gate:

```text
PRESERVATION OK: module-09-industry-synthesis-lab.json
```

Mirror and preservation counts:

```json
{
  "mirror_bytes_equal": true,
  "lessons": 7,
  "sources": 14,
  "source_coverage": 63,
  "figures": 1,
  "self_checks": 7,
  "cases": 3,
  "applications": 6,
  "glossary": 22
}
```

Focused visible-order assertion:

```text
FIRST-VISIBLE-USE OK: opening/question/answers/objectives contain no target acronyms; main_thread decodes all 8 before later use
```

Focused Case 1 assertion:

```text
CASE1 OK: change -55.36 USD/bbl; absolute decline 55.36 USD/bbl; endpoint -37.63 USD/bbl
```

All-case arithmetic sweep:

```text
CASE ARITHMETIC OK: cases 1-3 (7 checks)
```

No staging and no commit.
