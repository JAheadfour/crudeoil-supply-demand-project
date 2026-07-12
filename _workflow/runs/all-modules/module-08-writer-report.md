# Module 08 Writer Report

## Scope

- Assignment: Module 08, `course/data/oil101-understanding/module-08-products-petrochem-transition.json`
- Mirror updated: `docs/data/oil101-understanding/module-08-products-petrochem-transition.json`
- Report written: `_workflow/runs/all-modules/module-08-writer-report.md`
- No staging or commit performed.
- No files outside the assigned Module 08 canonical JSON, docs mirror, and this report were edited.

## Rewrite Summary

- Rewrote the module intro and all 7 lessons to the signed Module 01 beginner-first teaching contract.
- Preserved exact lesson IDs:
  `product-barrel-map`, `specification-feedback`, `hard-to-substitute-fuels`, `petrochemical-molecule-tree`, `engine-stock-flow`, `lng-globalization`, `transition-portfolio`.
- Preserved the 1 figure/reference, 6 sources, 64 source-coverage rows, glossary, cases, applications, comparison tables, review prompts, extreme-detail blocks, and self-checks.
- Added required lesson fields throughout: reader question, physical scene, plain answer, mechanism chain, actor/input/unit/arithmetic example, market meaning, contextual terms, misreading, boundary, and deep dive.
- Added `core_model.premises` and `core_model.breaks_when` for the strict understanding validator.
- Avoided a single transition date forecast; the module now teaches heterogeneous demand by product, molecule, equipment stock, logistics capacity, and scenario path.

## Source Discipline

Directly read the Module 08 interface files and gates:

- `_workflow/exemplars/golden-exemplar-module-01.json`
- `_workflow/exemplars/excellence-rubric.md`
- `docs/superpowers/plans/2026-07-11-oil101-all-modules-beginner-rewrite.md`
- `_workflow/scripts/validate-beginner-module.mjs`
- `_workflow/scripts/verify-module-preservation.mjs`
- `_workflow/runs/all-modules/baseline.json`
- Existing Module 08 JSON, for IDs/interfaces only.

Read the six listed Oil 101 chapter source captures in the workspace:

- `outputs/oil101-KB/part-one-oil-fundamentals/09-finished-products/00-source-layer.md`
- `outputs/oil101-KB/part-one-oil-fundamentals/10-petrochemicals/00-source-layer.md`
- `outputs/oil101-KB/part-one-oil-fundamentals/15-environmental/00-source-layer.md`
- `outputs/oil101-KB/part-one-oil-fundamentals/16-engine-technologies/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/24-us-lng/00-source-layer.md`
- `outputs/oil101-KB/part-three-modern-era/25-energy-transition/00-source-layer.md`

Also opened the public Oil 101 pages for `finished-products`, `petrochemicals`, `us-lng`, and `energy-transition`. The public fetch for `environmental` and `engine-technologies` returned web-tool `Internal Error / Cache miss`, so those chapters were read from the local source-layer captures and structured notes generated from the original Oil 101 pages. Old Module 08 reader prose was used only as interface metadata, not as a factual source.

## Validation Evidence

Actual bundled Node beginner validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow\scripts\validate-beginner-module.mjs course\data\oil101-understanding\module-08-products-petrochem-transition.json
```

```text
BEGINNER MODULE OK: course\data\oil101-understanding\module-08-products-petrochem-transition.json (7 lessons)
```

Strict understanding validator:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-08-products-petrochem-transition.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

```text
FLOORS OK
```

Preservation gate:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' _workflow\scripts\verify-module-preservation.mjs module-08-products-petrochem-transition.json
```

```text
PRESERVATION OK: module-08-products-petrochem-transition.json
```

Mirror and coverage check:

```text
{"mirror_bytes_equal":true,"canonical_bytes":72797,"docs_bytes":72797,"lessons":7,"sources":6,"source_coverage":64,"figures":1,"self_checks":7,"lesson_ids":["product-barrel-map","specification-feedback","hard-to-substitute-fuels","petrochemical-molecule-tree","engine-stock-flow","lng-globalization","transition-portfolio"]}
```

## Repair Notes

- First validation attempt exposed a PowerShell-to-Node encoding issue that replaced newly piped Chinese text with `?`. The module was immediately rewritten through an explicit UTF-8 stdin path and revalidated.
- A later beginner-validator pass required a longer `worked_example.actor` label and numeric setup lines in several examples. These were repaired without changing IDs, source coverage, source count, figure count, or self-check count.
