# Module 02 Writer Report

Assignment: Module 02, `02-supply-demand-balance`

Canonical file:
`course/data/oil101-understanding/module-02-supply-demand-balance.json`

Published mirror:
`docs/data/oil101-understanding/module-02-supply-demand-balance.json`

## Source Pages Read

Opened and read the five Morgan Downey Oil 101 pages listed in the module `sources` array:

1. `https://oil101.morgandowney.com/chapters/industry-overview`
   - Used for upstream/midstream/downstream handoffs, company/control structure, OPEC+ quota context, refinery footprint, and market-institution context.
2. `https://oil101.morgandowney.com/chapters/exploration-production`
   - Used for rights, petroleum-system gates, reservoir pressure, recovery, production phases, artificial lift, decline behavior, offshore timing, and shale mechanics.
3. `https://oil101.morgandowney.com/chapters/finished-products`
   - Used for product demand, product families, gasoline blending/RVP, jet/diesel/LPG/asphalt uses, and product-to-crude demand translation.
4. `https://oil101.morgandowney.com/chapters/seasonality`
   - Used for driving season, heating demand, RVP transition dates, refinery turnaround months, hurricane exposure, low-water bottlenecks, and why crude is less seasonal than products.
5. `https://oil101.morgandowney.com/chapters/reserves`
   - Used for OOIP/resources/reserves, Three Ps, PDP/PDNP/PUD, recategorization, reserve-estimation methods, decline curves, R/P, RRR, and political reserve revisions.

No non-Oil101 source appears in the module `sources` array, so no additional primary source was required by the assignment rule.

## Rewrite Scope

Rewrote:

- module-level `title`, `deck`, `reading_intent`, `opening_question`, `quick_answer`, `learning_objectives`, `main_thread`, `mental_model`, and `mental_model_detail`
- all 7 lessons, preserving lesson IDs:
  1. `balance-as-physical-flow`
  2. `resource-to-flow`
  3. `decline-and-reinvestment`
  4. `products-to-crude-demand`
  5. `seasonal-balance`
  6. `reserves-capacity-production`
  7. `control-and-concentration`
- `core_model` premises and break conditions, to satisfy the understanding validator and align with the rewritten teaching frame

Preserved:

- `sources`: 5 records
- `source_coverage`: 57 records
- `figures`, `figure_candidates`, `comparison_tables`, `term_family`, `glossary`, `extreme_detail`, `cases`, `self_checks`, `applications`, and `review_prompts`
- all lesson IDs and product-facing JSON interfaces

## Teaching Order Check

Each lesson now follows the Module 01 signed teaching order:

- reader question
- physical scene
- plain answer
- mechanism chain
- numeric worked example with actor, inputs, units, arithmetic, and decision meaning
- market meaning via `practitioner_lens`
- terms in context
- misreading and boundary
- deep dive

Pedagogical focus implemented:

- starts from barrels-in/barrels-out inventory accounting
- then builds to development lags, decline and reinvestment, product-to-crude demand translation, seasonal balance, reserves/capacity/production distinctions, and reconciliation of forecasts with observed balances
- explains stock changes before price abstractions

## Validation

Node beginner-module validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-02-supply-demand-balance.json
```

Result:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-02-supply-demand-balance.json (7 lessons)
```

Python understanding validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-02-supply-demand-balance.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Result:

```text
FLOORS OK
```

Mirror and coverage proof:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,pathlib; p=pathlib.Path(r'course/data/oil101-understanding/module-02-supply-demand-balance.json'); q=pathlib.Path(r'docs/data/oil101-understanding/module-02-supply-demand-balance.json'); m=json.loads(p.read_text(encoding='utf-8')); print({'coverage': len(m['source_coverage']), 'mirror': p.read_bytes()==q.read_bytes(), 'lessons': len(m['lessons']), 'sources': len(m['sources']), 'canonical_bytes': len(p.read_bytes()), 'docs_bytes': len(q.read_bytes())})"
```

Result:

```text
{'coverage': 57, 'mirror': True, 'lessons': 7, 'sources': 5, 'canonical_bytes': 74118, 'docs_bytes': 74118}
```

## Concerns

- The module-level retained `applications`, `self_checks`, `glossary`, and `extreme_detail` were preserved for product depth and interface stability. They still include some older English shorthand, but they are outside the new beginner lesson path and were not required by the beginner validator.
- There are unrelated modified files in other modules and untracked workflow artifacts in the worktree. I did not edit, stage, revert, or commit them.

## Blind-Judge Repair Pass (2026-07-11)

### Exact Finding-to-Fix Mapping

1. `control-and-concentration` inventory signs and undeclared delayed supply
   - Defined the accounting boundary as one coastal region's commercial crude tanks and directly connected pipelines. In-transit barrels outside the region and finished-product stocks are excluded.
   - Defined the sign convention before arithmetic: positive increases crude inventory inside the boundary; negative reduces it.
   - Declared all inputs, including the previously undeclared `800000 bpd` independent scheduled arrival delayed to the next month and the `30 days` window.
   - Recomputed the local stock change as `+700000 bpd + 400000 bpd + 200000 bpd - 200000 bpd - 800000 bpd = +300000 bpd`.
   - Recomputed the monthly change as `+300000 bpd × 30 days = +9000000 barrels` and changed the decision implication from a draw/tightness call to a local inventory build, capacity check, and looser near-month interpretation.

2. All 57 `source_coverage` records
   - Reopened and read all five original Oil 101 pages listed in `sources` during the repair pass.
   - Audited every record against actual main-path or deep-dive teaching. Final disposition is `41 covered + 16 deferred = 57`.
   - Added substantive coverage for seismic surveys (`2D/3D/4D`, physical sound-wave object, and `10%-20%` wildcat success), offshore timing, production phases, EUR/drilling inventory, refinery footprint, gasoline blending, Jet Fuel/SAF mandates and `2-5x` cost with sub-`1%` scale, middle distillates/LPG, bitumen/kerosene seasonality, reserve probability/development categories, re-catting, Peak Oil/Hubbert, OPEC reserve revisions, RRR, OPEC+ control, product trade routes, weather/logistics bottlenecks, and Giant Fields.
   - Changed six unsupported `covered` labels to honest, specific deferrals:
     - H2-03 `The NOC League Table` -> Module 07 producer/NOC behavior.
     - H2-04 `US Independents: The Shale Cohort` -> Module 07 shale producer strategy.
     - H2-06 `Pure-Play Refiners` -> refinery economics and crack-spread topic.
     - H2-07 `Physical Trading Houses` -> Module 04 physical pricing and trading houses.
     - H2-15 `Types of E&P Agreements` -> upstream fiscal terms and contracts.
     - H2-28 `Residual Fuel and the Bunker Market After IMO 2020` -> shipping fuel and environmental standards.
   - Retained the ten already-deferred records only after confirming each reason names the omitted subject and a concrete later topic.

Full 57-record disposition by source page:

| Source records | Covered after substantive audit | Deferred with specific reason |
|---|---|---|
| Industry Overview H2-01 to H2-12 | H2-01, H2-02, H2-10, H2-11 | H2-03, H2-04, H2-05, H2-06, H2-07, H2-08, H2-09, H2-12 |
| Exploration and Production H2-13 to H2-23 | H2-13, H2-14, H2-16, H2-17, H2-18, H2-20, H2-21, H2-22, H2-23 | H2-15, H2-19 |
| Finished Products H2-24 to H2-36 | H2-24, H2-25, H2-26, H2-27, H2-29, H2-33, H2-34, H2-36 | H2-28, H2-30, H2-31, H2-32, H2-35 |
| Seasonality H2-37 to H2-45 | H2-37 through H2-45 | None |
| Reserves H2-46 to H2-57 | H2-46 through H2-54, H2-56, H2-57 | H2-55 |

3. `products-to-crude-demand` marginal yield
   - Declared current gasoline yield `45%`, the two-point shift to `47%`, current throughput `17000000 bpd`, and the assumption that marginal crude runs at the adjusted `47%` gasoline yield.
   - Recomputed yield-shift gasoline as `17000000 bpd × 2% = 340000 bpd`.
   - Recomputed the remaining gap as `700000 bpd - 340000 bpd = 360000 bpd`.
   - Recomputed marginal crude as `360000 bpd ÷ 47% = 765957 bpd`, approximately `766000 bpd`, and tied that result to the crude-purchase decision.

### Final Validation Outputs

Beginner module validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-02-supply-demand-balance.json
```

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-02-supply-demand-balance.json (7 lessons)
```

Strict understanding validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-02-supply-demand-balance.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

```text
FLOORS OK
```

Preservation gate:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/verify-module-preservation.mjs module-02-supply-demand-balance.json
```

```text
PRESERVATION OK: module-02-supply-demand-balance.json
```

Mirror, counts, and coverage proof:

```text
{"mirror_bytes_equal":true,"canonical_bytes":84257,"docs_bytes":84257,"lessons":7,"sources":5,"source_coverage":57,"covered":41,"deferred":16}
```

Focused arithmetic audit result:

```text
ARITHMETIC OK {"balance_net":100000,"balance_7d":700000,"balance_end":10700000,"resource_recoverable":150000000,"resource_annual":29200000,"decline_end":65000,"decline_gap":35000,"decline_wells":50,"gasoline_no_shift":1555556,"gasoline_yield_shift":340000,"gasoline_gap":360000,"gasoline_marginal":765957,"season_july":17100000,"season_oct":16020000,"season_30d":32400000,"reserves_recoverable":14550000,"reserves_years":14.55,"reserves_revised":11550000,"control_net":300000,"control_30d":9000000}
```

The first post-edit beginner-validator attempt rejected the leading `+` sign in an otherwise correct arithmetic expression because its regex expects an unsigned result token. The lesson keeps the explicit sign convention and full signed reconciliation, while one preceding step now formats `1000000 bpd - 300000 bpd = 700000 bpd` and labels it inventory-positive in prose. The final validator output above is the rerun after that formatting repair.

### Remaining Concerns

- No unresolved blind-judge finding remains in the owned Module 02 files.
- All time-stamped figures from the 2026 web edition are framed as source-page teaching facts rather than timeless constants.
- No files outside the Module 02 canonical JSON, docs mirror, and this report were edited; nothing was staged or committed.

## Final H2-50 Repair (2026-07-11)

Reopened and read `https://oil101.morgandowney.com/chapters/reserves`, especially `Reserve Estimation Methods` and Table 14-2. Added the compact deep dive `五种储量估算方法随油田成熟接力` under `reserves-capacity-production`.

Exact substantive mapping:

- `Analogy / 类比法`: requires evidence from comparable known fields, including geology, recovery and well performance; useful before local production data exist; uncertainty is dominated by whether the comparison is genuinely similar.
- `Volumetric / 容积法`: requires seismic, logs and cores for area, net pay, porosity, hydrocarbon saturation and formation volume factor; useful after a discovery is drilled but before material production; uncertainty sits mainly in static geometry, rock properties and recovery assumptions.
- `Material balance / 物质平衡法`: requires cumulative oil/gas/water withdrawals, repeated reservoir pressure, compressibility and aquifer-support assumptions; useful in early production after measurable pressure decline; actual pressure response constrains the static estimate but poor pressure communication can mislead.
- `Decline-curve analysis / 递减曲线分析`: requires post-peak rate history, decline parameters and an economic cutoff; useful in declining wells and mature fields for EUR; uncertainty depends on history length, curve choice and tail assumptions, especially in shale.
- `Reservoir simulation / 油藏数值模拟`: requires a 3-D geological grid plus seismic, well, rock, fluid, pressure and production data with history matching; usable at any stage for development scenarios, but expensive and model-dependent.
- Uncertainty progression is explicit: measured production and pressure replace some early analogy and static assumptions, usually narrowing the range, while new evidence can also move the estimate by revealing faults, weak connectivity, aquifer support or abnormal decline. H2-50 therefore remains honestly `covered`.

Final checks:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-02-supply-demand-balance.json (7 lessons)
FLOORS OK
PRESERVATION OK: module-02-supply-demand-balance.json
H2-50 COVERAGE OK: five methods + evidence/stage + uncertainty progression; status=covered
```

Final mirror and preservation counts:

```json
{"mirror_bytes_equal":true,"canonical_bytes":85908,"docs_bytes":85908,"lessons":7,"sources":5,"source_coverage":57,"covered":41,"deferred":16}
```

Commands rerun:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-02-supply-demand-balance.json
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-02-supply-demand-balance.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/verify-module-preservation.mjs module-02-supply-demand-balance.json
```

No other file was edited, staged, or committed in this repair.
