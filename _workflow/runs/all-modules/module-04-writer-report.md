# Module 04 Writer Report

## Assignment

- Module: Module 04, `04-what-is-oil-price`
- Canonical path: `course/data/oil101-understanding/module-04-what-is-oil-price.json`
- Published mirror path: `docs/data/oil101-understanding/module-04-what-is-oil-price.json`
- Pedagogical focus: teach why quality, location, time, delivery terms, benchmarks, differentials, and price reporting create many oil prices.

## Pages Read

Required setup files read before rewriting:

- `_workflow/exemplars/golden-exemplar-module-01.json`
- `_workflow/exemplars/excellence-rubric.md`
- `docs/superpowers/plans/2026-07-11-oil101-all-modules-beginner-rewrite.md`
- `_workflow/scripts/validate-beginner-module.mjs`
- `course/data/oil101-understanding/module-04-what-is-oil-price.json`

Original Morgan Downey Oil 101 sources directly opened and read:

- `https://oil101.morgandowney.com/chapters/crude-oil-assay`
  - Used for assay purpose, fields/streams/blends, API density, sulfur, quality matrix, TAN, metals, viscosity, pour point, RVP, carbon residue, salt, BS&W, and quality differentials.
- `https://oil101.morgandowney.com/chapters/standards`
  - Used for standards bodies, crude test methods, AKI/RON/MON, gasoline sulfur/RVP/ethanol limits, diesel sulfur/cetane/flash point, jet specifications, and marine fuel sulfur grades.
- `https://oil101.morgandowney.com/chapters/oil-prices`
  - Used for physical term/spot trade, benchmark pricing, OSP, delivery-chain price ladder, unit conversion, PEMEX-style formula pricing, freight netback, Platts MOC, dollar denomination, gold sanity check, and retail tax differences.

No non-Oil101 source was listed in the module's `sources`, so no additional primary non-Oil101 page was required.

## Rewrite Summary

- Rewrote module-level `deck`, `reading_intent`, `opening_question`, `quick_answer`, `learning_objectives`, `main_thread`, `mental_model`, and `mental_model_detail`.
- Rewrote all 11 lessons in beginner-first order:
  - `price-object`
  - `benchmark-system`
  - `assay-identity`
  - `api-sulfur-matrix`
  - `assay-tests-contract`
  - `product-standards-price`
  - `delivery-ladder-units`
  - `formula-osp`
  - `freight-netback`
  - `moc-assessment`
  - `dollar-retail-real`
- Each lesson now includes:
  - `reader_question`
  - physical `scene`
  - `plain_answer`
  - stepwise `mechanism_chain`
  - transparent numeric `worked_example` with actor, inputs, units, arithmetic, result, and decision implication
  - `practitioner_lens`
  - contextual term cards
  - specific `misreading` and `boundary`
  - at least one `deep_dive`
- Preserved lesson IDs, source URLs, source coverage mapping count, figures/reference metadata, comparison tables, term family, glossary, cases, self-checks, applications, and review prompts.
- Added required `core_model.premises` and `core_model.breaks_when` fields for platform validation.

## Coverage

- Lesson count: 11
- Source coverage record count: 24
- Source coverage structure preserved:
  - `oil101-ch02-crude-oil-assay`: 7 section mappings
  - `oil101-ch08-standards`: 8 section mappings
  - `oil101-ch17-oil-prices`: 9 section mappings
- Canonical/docs mirror byte equality: true

## Exact Checks Run

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-04-what-is-oil-price.json
```

Output:

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-04-what-is-oil-price.json (11 lessons)
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-04-what-is-oil-price.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Output:

```text
FLOORS OK
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "from pathlib import Path; import json; c=Path('course/data/oil101-understanding/module-04-what-is-oil-price.json').read_bytes(); d=Path('docs/data/oil101-understanding/module-04-what-is-oil-price.json').read_bytes(); m=json.loads(c.decode('utf-8')); print('mirror_bytes_equal', c==d); print('lesson_count', len(m['lessons'])); print('coverage_count', sum(len(s.get('section_mappings',[s])) for s in m['source_coverage']))"
```

Output:

```text
mirror_bytes_equal True
lesson_count 11
coverage_count 24
```

## Concerns

- Node was not available as `node` on PATH in this shell, so I used the bundled Codex runtime Node executable. This is the same validator script and module path required by the assignment.
- The rewrite intentionally preserves existing figures and product metadata; I did not perform a renderer or Playwright visual pass because the assignment required module validation and mirror equality, not app rendering.
- Some original Oil 101 figures referenced in retained metadata are external-source figures surfaced through Oil 101. I preserved the existing reference metadata and did not add new figure assets.

## Blind Review Repair (2026-07-11)

### Fix Mapping

1. `assay-tests-contract` BS&W basis
   - Replaced the invalid direct `wt% × barrels` conversion with a mass-basis settlement example.
   - Declared gross cargo mass `27000 metric tonnes`, contract limit `1 wt%`, and measured result `1.4 wt%` before arithmetic.
   - Recomputed allowed BS&W as `270 metric tonnes`, measured BS&W as `378 metric tonnes`, and excess as `108 metric tonnes`.
   - Explicitly states that any conversion from this mass result to barrels would require a separately declared mixture density.

2. `product-standards-price` E10 binding component
   - Declared target finished E10 volume `100000 gallons`, strict ethanol share `10 vol%`, available base gasoline `90000 gallons`, and available ethanol `8000 gallons`.
   - Distinguished the ethanol-component shortfall (`2000 gallons`) from the finished-product shortfall (`20000 gallons`).
   - Demonstrated the binding component: `8000 gallons ÷ 10 vol% = 80000 gallons` maximum E10; this uses only `72000 gallons` base gasoline, so ethanol binds.

3. `assay-identity` buyer constraint
   - Added the buyer's `25%` high-acid-source ceiling to `worked_example.inputs` before calculating the `5` percentage-point breach.

4. `api-sulfur-matrix` precision
   - Rounded `159 kg × 0.827` to approximately `131.5 kg` and the difference from water to `27.5 kg`.
   - Corrected the density expression to retain `kg/m3` on both sides.

### Nearby Example Audit

- Audited all 11 worked examples for undeclared arithmetic operands and unit-basis shortcuts.
- Declared previously implicit values in nearby examples: alternate cargo differential (`0.80美元/桶`), alternate destination adjustment (`0.50美元/桶`), intentionally incorrect budget volume (`40000 gallons`), OSP coefficients (`0.40` and `0.10`), freight cargo quantity (`600000桶`), and MOC-linked contract quantity (`200000桶`).
- Retained dimensional labels through price, freight, MOC, retail-price, and formula calculations. Where the beginner validator requires a compact arithmetic expression, the settlement basis is stated immediately before the numbers (for example, `按每桶口径`).

### Repair Checks

Beginner validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/validate-beginner-module.mjs course/data/oil101-understanding/module-04-what-is-oil-price.json
```

```text
BEGINNER MODULE OK: course/data/oil101-understanding/module-04-what-is-oil-price.json (11 lessons)
```

Strict understanding validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-04-what-is-oil-price.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

```text
FLOORS OK
```

Preservation gate:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow/scripts/verify-module-preservation.mjs module-04-what-is-oil-price.json
```

```text
PRESERVATION OK: module-04-what-is-oil-price.json
```

Mirror and coverage proof:

```text
MIRROR OK: byte_equal=True lessons=11 source_coverage_mappings=24
```

Focused arithmetic assertions recomputed the four reviewed examples and verified all six nearby input declarations:

```powershell
$m = Get-Content -Raw -Encoding utf8 'course/data/oil101-understanding/module-04-what-is-oil-price.json' | ConvertFrom-Json
function L($id) { $m.lessons | Where-Object id -eq $id }
$assay = L 'assay-identity'; $api = L 'api-sulfur-matrix'; $bsw = L 'assay-tests-contract'; $e10 = L 'product-standards-price'
if (($assay.worked_example.inputs -join ' ') -notmatch '25%') { throw 'assay limit undeclared' }
if (($api.worked_example.steps -join ' ') -notmatch '131\.5 kg' -or ($api.worked_example.steps -join ' ') -notmatch '27\.5 kg' -or ($api.worked_example.steps -join ' ') -match '131\.493|27\.507') { throw 'API rounding mismatch' }
$allowed = 27000 * 0.01; $measured = 27000 * 0.014; $excess = $measured - $allowed
if ($allowed -ne 270 -or $measured -ne 378 -or $excess -ne 108) { throw 'BS&W arithmetic mismatch' }
if (($bsw.worked_example.inputs -join ' ') -notmatch 'wt%' -or ($bsw.worked_example.steps -join ' ') -match '桶') { throw 'BS&W basis mismatch' }
$componentShort = 100000 * 0.10 - 8000; $maxE10 = 8000 / 0.10; $finishedShort = 100000 - $maxE10
if ($componentShort -ne 2000 -or $maxE10 -ne 80000 -or $finishedShort -ne 20000) { throw 'E10 arithmetic mismatch' }
```

Exact result:

```text
FOCUSED ARITHMETIC OK: assay_limit=25%; api_mass=131.5kg api_delta=27.5kg; BSW=270/378/108t mass_basis; E10_component_short=2000gal max_finished=80000gal finished_short=20000gal; nearby_inputs=6/6
```

### Repair Concerns

- None outstanding from the blind-review findings.
- No shared tests, renderer, catalog, session metadata, or other module files were edited. No files were staged or committed.
