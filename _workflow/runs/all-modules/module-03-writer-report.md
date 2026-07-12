# Module 03 Writer Report

## Scope

- Assignment: Module 03, `03-local-shortages`.
- Canonical: `course/data/oil101-understanding/module-03-local-shortages.json`.
- Published mirror: `docs/data/oil101-understanding/module-03-local-shortages.json`.
- Pedagogical focus implemented: starts from the Bayonne/New York Harbor terminal and Gulf Coast-to-East Coast product logistics scene, then teaches refinery configuration, product standards, transport, storage, seasonality, and compound local shocks before price signals.

## Source Pages Read

Original Morgan Downey Oil 101 pages opened and read directly before rewriting:

1. `https://oil101.morgandowney.com/chapters/refining`
   - Used for feedstock/product/crude slate, 42 gallons to roughly 45 gallons refinery gain, four refining stages, ADU/VDU, FCC, hydrocracker, coker, treatment, blending, refinery complexity, PADD geography, and turnaround timing.
2. `https://oil101.morgandowney.com/chapters/standards`
   - Used for standards bodies, crude assay tests, RON/MON/AKI, gasoline sulfur/RVP, diesel sulfur/cetane, jet fuel specifications, and IMO 2020 bunker sulfur categories.
3. `https://oil101.morgandowney.com/chapters/transporting-oil`
   - Used for tanker classes, clean versus dirty tanker distinction, Worldscale arithmetic, Colonial Pipeline distance/share/travel time, batching, DRA, rail/truck roles, chokepoints, hubs, and Incoterms boundary.
4. `https://oil101.morgandowney.com/chapters/storage`
   - Used for operational/strategic/commercial storage distinction, storage categories, tank types, dead stock/heel, working capacity, Cushing, line fill, salt caverns, and SPR mechanism boundaries.
5. `https://oil101.morgandowney.com/chapters/seasonality`
   - Used for overlapping oil calendars, gasoline demand seasonality, RVP transition dates, HDD method, heating oil/propane seasonality, refinery utilization/turnaround calendar, hurricanes, Rhine low-water bottlenecks, and the point that product seasonality is sharper than crude seasonality.

No non-Oil101 source URLs were listed in the module `sources` array, so no additional primary non-Oil101 source was required by the assignment.

## Rewrite Summary

- Rewrote all module-level teaching fields:
  - `title`
  - `deck`
  - `reading_intent`
  - `opening_question`
  - `quick_answer`
  - `learning_objectives`
  - `main_thread`
  - `mental_model`
  - `mental_model_detail`
  - Added a local-availability bottleneck formula while preserving existing formulas.
- Rewrote all 7 lessons in beginner-first order:
  1. `five-gates`
  2. `refinery-config`
  3. `spec-frag`
  4. `transport-net`
  5. `storage-local`
  6. `season-cycle`
  7. `compound-shock`
- Each lesson now includes:
  - `reader_question`
  - physical `scene`
  - `plain_answer`
  - mechanism chain
  - transparent numeric `worked_example` with actor, units, arithmetic, and decision implication
  - market/practitioner meaning
  - `terms_in_context`
  - `misreading`
  - `boundary`
  - `deep_dive`
- Preserved existing lesson IDs, source URLs, figures/reference metadata, comparison tables, glossary, extreme detail, cases, applications, self checks, review prompts, source anomalies, and source coverage records.
- Added `core_model.premises` and `core_model.breaks_when` to satisfy the understanding-course validation floor while retaining existing `core_model.core_points` and `one_liner`.

## Counts And Identity

- Lesson count: 7.
- Source URL count: 5.
- Source coverage record count: 53.
- Canonical bytes: 80939.
- Docs mirror bytes: 80939.
- Canonical/docs byte equality: true.

## Exact Checks Run

1. Beginner module validator:

```powershell
& 'C:\Users\justi\AppData\Local\OpenAI\Codex\bin\5b9024f90663758b\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-03-local-shortages.json
```

Result:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-03-local-shortages.json (7 lessons)
```

2. Python course-app validation:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json, sys; sys.path.insert(0, r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-03-local-shortages.json', encoding='utf-8')); e=validate_module(m, 'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Result:

```text
FLOORS OK
```

3. Mirror equality and coverage count:

```powershell
& 'C:\Users\justi\AppData\Local\OpenAI\Codex\bin\5b9024f90663758b\node.exe' -e "const fs=require('fs'); const c=fs.readFileSync('course/data/oil101-understanding/module-03-local-shortages.json'); const d=fs.readFileSync('docs/data/oil101-understanding/module-03-local-shortages.json'); const m=JSON.parse(c); console.log('canonical_bytes', c.length); console.log('docs_bytes', d.length); console.log('mirror_equal', Buffer.compare(c,d)===0); console.log('lessons', m.lessons.length); console.log('source_coverage', m.source_coverage.length); console.log('sources', m.sources.length);"
```

Result:

```text
canonical_bytes 80939
docs_bytes 80939
mirror_equal true
lessons 7
source_coverage 53
sources 5
```

## Concerns

- The Storage Oil 101 page contains internally inconsistent 2026 SPR figures and capacity captions; the existing `source_anomalies` record was preserved. The rewritten lessons avoid depending on those disputed current-event numbers and use only mechanism-level conclusions about strategic crude not directly replacing offline refining or product logistics.
- Several old retained sections, especially glossary/extreme detail/cases, still contain compact industry terms by design. They were preserved for product depth, while the rewritten main lesson path introduces physical objects before jargon.
- Node is not on the default PATH in this shell; checks were run with the Codex-bundled Node executable at `C:\Users\justi\AppData\Local\OpenAI\Codex\bin\5b9024f90663758b\node.exe`.

## Blind Review Repair - 2026-07-11

### Repair Scope

- Edited only the Module 03 canonical JSON, published mirror, and this report.
- Did not edit `platform.js`, shared tests, catalog/session metadata, or any other module.
- Kept all 53 `source_coverage` records, all lesson IDs, figures, sources, cases, applications, glossary material, and self-checks.
- Coverage disposition after audit: 44 `covered`, 9 `deferred`.

### All 53 Source Coverage Rows Audited

| # | Source section | Status | Audit evidence or deferral reason |
|---:|---|---|---|
| 1 | Refining - Feedstock, Slate, and Refinery Gain | covered | `refinery-config` main explanation teaches crude suitability and 42-to-45 gallon volume gain. |
| 2 | Refining - The Four Stages of Refining | covered | `refinery-config` main path follows separation, conversion/treatment, and blending; retained detail supplies the full four-stage framing. |
| 3 | Refining - Separation: The Crude Distillation Unit | covered | `refinery-config` physically introduces the heated tower and boiling-range cuts before terminology. |
| 4 | Refining - Conversion: Where Margin Is Made | covered | `refinery-config` explains cracking, hydroprocessing, coking, product yield, and the failed-unit bottleneck. |
| 5 | Refining - Combining: Alkylation and Polymerization | covered | `spec-frag` and retained detail connect combination units to blend components needed for finished gasoline. |
| 6 | Refining - Modifying: Catalytic Reforming, Isomerization, Ethers | covered | `spec-frag` and retained detail connect molecular modification to octane and gasoline-pool compatibility. |
| 7 | Refining - Treatment: Hydroprocessing, Amine, Merox, Claus | covered | `refinery-config`/`spec-frag` explain treatment capacity as the route from sulfur-bearing fractions to compliant products; retained detail names the systems. |
| 8 | Refining - Bitumen, Lubricants, Waxes, and Grease | deferred | Specialty non-fuel product chains are outside Module 03's local transport-fuel scarcity thread; no false lesson mapping was added. |
| 9 | Refining - Blending: Where Finished Product Is Born | covered | `spec-frag` main path and revised worked example teach that finished gasoline exists only after a tested recipe combines compatible components. |
| 10 | Refining - Refinery Types and the Nelson Complexity Index | covered | `refinery-config` contrasts simple and complex plants and explains why more conversion routes add flexibility and specialized failure points. |
| 11 | Refining - US Refining Geography and the PADDs | covered | `five-gates` and retained comparison material place Gulf Coast production against East Coast demand and regional logistics. |
| 12 | Refining - Turnaround Season | covered | `season-cycle` teaches planned maintenance removing capacity during shoulder seasons and interacting with changeover timing. |
| 13 | Standards - Why Standards Matter | covered | `spec-frag` explains both trade-enabling test consistency and short-run exclusion of incompatible barrels. |
| 14 | Standards - Standards-Setting Organizations | covered | `spec-frag` retained detail preserves the organizations and shows how regulatory/contract tests govern acceptance. |
| 15 | Standards - Crude Oil Tests | covered | Repaired in `refinery-config` main explanation and deep dive: sample density/API, sulfur, yield curve, viscosity, acidity, metals, water, and sediment translate a crude name into unit and yield constraints. |
| 16 | Standards - Octane: RON, MON, and AKI | covered | `spec-frag` main path and term card distinguish pump-number conventions and define AKI. |
| 17 | Standards - Gasoline Specifications | covered | `spec-frag` teaches RVP, sulfur/quality compatibility, seasonal cutoffs, and a terminal blending decision. |
| 18 | Standards - Diesel Specifications | covered | `spec-frag` teaches sulfur and cold-performance constraints as gates to local diesel supply. |
| 19 | Standards - Jet Fuel Specifications | covered | `spec-frag` and the refinery example connect low-temperature/safety requirements with qualified jet output. |
| 20 | Standards - Residual and Bunker Fuel | covered | `spec-frag` retained detail preserves residual/bunker categories and sulfur-driven compatibility. |
| 21 | Transporting Oil - Five Methods of Moving Oil | covered | `transport-net` compares pipeline, tanker, barge, rail, and truck roles and limitations. |
| 22 | Transporting Oil - Tanker Ships | covered | `transport-net` introduces clean-product cargo compatibility and voyage/berth timing. |
| 23 | Transporting Oil - Chartering and Worldscale | covered | `transport-net` term card and retained formula explain route benchmark versus current market percentage. |
| 24 | Transporting Oil - Pipelines | covered | `transport-net` main mechanism and numeric example teach direction, batching, speed, distance, and line fill. |
| 25 | Transporting Oil - Crude by Rail and the Bakken Boom | covered | `transport-net` retained comparison explains rail flexibility, scale, and cost relative to fixed pipelines. |
| 26 | Transporting Oil - Trucking: The Last Mile | covered | `transport-net` identifies truck scale/cost and last-mile use; compound example quantifies its limited substitution. |
| 27 | Transporting Oil - IMO 2020 and the Transformation of Bunker Fuel | covered | `spec-frag` retained detail maps sulfur-rule change to separated compliant and noncompliant fuel pools. |
| 28 | Transporting Oil - Shipping Chokepoints | covered | Repaired in `transport-net` deep dive: narrow straits/canals cause queues or rerouting, lengthen voyages, occupy vessels, and reduce arrivals inside the local shortage window. |
| 29 | Transporting Oil - LNG Carriers in Brief | deferred | LNG vessel design and gas-chain handling are outside this oil-products module; no oil-tanker equivalence is implied. |
| 30 | Transporting Oil - Trading Hubs | covered | `storage-local` and retained hub material show that connectivity and deliverable storage, not a place name alone, create a hub. |
| 31 | Transporting Oil - Incoterms and Delivery Pricing | deferred | Title/risk-transfer clauses are commercial contracting depth rather than the physical compatibility/timing mechanism taught here. |
| 32 | Storage - Why Store Oil? | covered | `storage-local` explains inventory as a timing buffer between uneven production, transport, refining, and consumption. |
| 33 | Storage - Categories of Storage | covered | `storage-local` distinguishes operational, commercial, line-fill, and strategic availability in the main path and retained material. |
| 34 | Storage - Tank Types | covered | `storage-local` physically distinguishes tanks/pressure vessels by product volatility, heating, contamination, and handling needs. |
| 35 | Storage - Cushing, Oklahoma: The Pipeline Crossroads | covered | `storage-local` scene and retained hub comparison connect tanks, pipelines, and deliverability at Cushing. |
| 36 | Storage - Salt Caverns | covered | Repaired in `storage-local` deep dive: water-leached salt void, well/pump/pressure withdrawal, geology/product/pipeline constraints, and why stored crude cannot directly supply Bayonne gasoline. |
| 37 | Storage - The US Strategic Petroleum Reserve | deferred | Module teaches only the policy-fit boundary; detailed SPR history/current figures remain deferred because they are not needed for local product mechanics and the source has recorded figure inconsistencies. |
| 38 | Storage - International Strategic Reserves | deferred | Cross-country reserve mandates and governance are policy depth outside the local terminal/refinery mechanism. |
| 39 | Storage - Iran's Floating Shadow Storage | deferred | Sanctions-driven floating storage is a geopolitical case outside the beginner local-availability chain. |
| 40 | Storage - The Contango Storage Play | deferred | Time-spread storage economics are trading depth; Module 03 keeps storage focused on physical deliverability. |
| 41 | Storage - Inventory Reports and the Five-Year Range | covered | Repaired in `storage-local` deep dive: current inventory is compared with the same-season five-year range as a buffer warning, while regional/product aggregation cannot prove terminal-level deliverability. |
| 42 | Storage - AI and the 30 Percent Inventory Reduction | deferred | Vendor/forecasting claim is not necessary to establish the physical storage mechanism and is unsuitable as a beginner core fact without separate substantiation. |
| 43 | Storage - Where Storage Sits in the Value Chain | covered | `storage-local` traces tanks between incoming transport, processing, terminal dispatch, and final demand. |
| 44 | Seasonality - Four Overlapping Calendars | covered | `season-cycle` overlays demand, product specification, refinery maintenance, and weather/logistics calendars. |
| 45 | Seasonality - Gasoline: Memorial Day to Labor Day | covered | `season-cycle` teaches the driving-season demand peak and advance inventory requirement. |
| 46 | Seasonality - Summer Grade and Winter Grade: The RVP Calendar | covered | `spec-frag` and `season-cycle` teach RVP changeover, cutoff dates, and stranded old-season barrels. |
| 47 | Seasonality - Heating Oil, Propane, and the HDD Framework | covered | `season-cycle` defines the 65°F HDD calculation and connects colder weather with heating-fuel draw. |
| 48 | Seasonality - Natural Gas Storage: Inject and Withdraw | deferred | Natural-gas reservoir/cavern seasonality is outside this liquid-oil product module. |
| 49 | Seasonality - The Refinery Turnaround Calendar | covered | `season-cycle` explains why planned outages cluster in shoulder periods and reduce product flexibility. |
| 50 | Seasonality - Atlantic Hurricanes | covered | `compound-shock` teaches simultaneous offshore, refinery, power, port, pipeline, and terminal interruption plus recovery order. |
| 51 | Seasonality - North Sea Storms and Baltic Ice | covered | Repaired in `compound-shock` deep dive: unsafe offshore/loading hours, icebreaker/slow-speed/port restrictions, and inventory-days versus arrival-delay transmission. |
| 52 | Seasonality - Rivers and Canals: Low Water Bottlenecks | covered | `compound-shock` main path and worked example quantify draft-driven barge load reduction and inland shortfall. |
| 53 | Seasonality - Why Crude Oil Itself Is Less Seasonal Than Its Products | covered | `season-cycle` deep dive explains offsetting gasoline, heating-fuel, and turnaround effects on aggregate crude demand. |

### Worked Example Constraint Audit

- `five-gates`: declared the 7-day planning window, converted terminal inventory to a sustainable 7-day daily dispatch rate, and stated that no other route can arrive inside the window.
- `refinery-config`: changed 100,000 bpd from an ordinary observed input to the current maximum refinery run rate imposed by the operating/unit bottleneck. Added `9,000 bpd ÷ 6% = 150,000 bpd` required crude input and `150,000 - 100,000 = 50,000 bpd` excess over capacity. The decision now explicitly states why the 3,000 bpd jet gap cannot be fixed by running more crude.
- `spec-frag`: declared a laboratory-approved 1:1 teaching recipe, calculated 40,000 barrels old gasoline treated, 80,000 barrels finished compliant blend, and 60,000 barrels untreated. It explicitly warns that 1:1 is an input, not a general linear RVP law.
- `transport-net`: declared the favorable lower-bound assumption of immediate pipeline entry and 0 days additional queue/testing/unloading time; 16.7 days still exceeds 10 days inventory cover by 6.7 days.
- `storage-local`: clarified that the 20,000-barrel operational reserve sits inside the stated 500,000-barrel daily-use capacity and is not a second deduction for tank bottom/headspace.
- `season-cycle`: declared the previously implicit 30-day high-demand window and the requirement that inventory/imports be available inside that window.
- `compound-shock`: declared fixed barge count and trip frequency plus no extra charter availability, making the 30% vessel-load factor valid for system capacity.

### Post-Repair Checks

1. Beginner validator:

```powershell
& 'C:\Users\justi\AppData\Local\OpenAI\Codex\bin\5b9024f90663758b\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-03-local-shortages.json
```

Result: `BEGINNER MODULE OK: course/data/oil101-understanding/module-03-local-shortages.json (7 lessons)`.

2. Understanding validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json, sys; sys.path.insert(0, r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-03-local-shortages.json', encoding='utf-8')); e=validate_module(m, 'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Result: `FLOORS OK`.

3. Preservation validator:

```powershell
& 'C:\Users\justi\AppData\Local\OpenAI\Codex\bin\5b9024f90663758b\node.exe' _workflow/scripts/verify-module-preservation.mjs module-03-local-shortages.json
```

Result: `PRESERVATION OK: module-03-local-shortages.json`.

4. Focused arithmetic and constraint assertions:

- Ran an inline Node assertion set that independently recomputed all 23 displayed arithmetic results across the 7 lessons.
- Asserted every lesson still has an actor, declared inputs, arithmetic steps, and decision answer.
- Asserted the refinery example contains the 100,000 bpd maximum, 150,000 bpd requirement, and 50,000 bpd capacity excess.
- Asserted all five repaired coverage rows remain `covered`, retain their original lesson mappings, and now have mapped deep-dive/main-path evidence.

Result: `FOCUSED ARITHMETIC OK: 23 calculations; all 7 examples constrained` and `COVERAGE FOCUS OK: 53 rows retained; 5 repaired mappings present`.

5. Mirror and count proof:

Result: `MIRROR OK: 85253 bytes each; byte-identical`; `source_coverage = 53` with `covered = 44` and `deferred = 9`.

### Remaining Concerns

- The five repaired source topics are intentionally concise and mechanism-first; they do not attempt to reproduce the source chapters' full technical or historical detail.
- The crude-test discussion is a screening model for beginners. Actual refinery acceptance uses a full assay, operating limits, contracts, and plant-specific optimization.
- The blending arithmetic is explicitly a laboratory-approved teaching recipe. Real gasoline vapor-pressure blending is not generally linear.
- No integration repair was attempted for the parent-owned `platform.js` issue.
