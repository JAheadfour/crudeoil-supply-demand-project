# Task 4 Report: Independent Module 01 Final QA

## Verdict

Pass after one narrow production content fix. The final QA found an unexplained early use of `烃类` before the physical object had been explained as carbon-and-hydrogen molecules. I fixed that in the canonical Module 01 JSON, synced the docs mirror byte-for-byte, captured desktop/mobile screenshots, and reran the full fresh suite.

## Files Changed

- `course/data/oil101-understanding/module-01-barrel-journey.json`
- `docs/data/oil101-understanding/module-01-barrel-journey.json`
- `.superpowers/sdd/task-4-report.md`

Temporary, not staged:

- `.superpowers/sdd/capture-module-01-screenshots.mjs`
- `.superpowers/sdd/screenshots/*.png`

## Independent Lesson Audit

| Lesson | QA result |
| --- | --- |
| `reservoir-to-well` | Defect found and fixed. `main_thread`, `concept.definition`, `explanation`, and `mechanism_chain` used `烃类` / `液态烃` before explaining the physical object. Replaced with `由碳和氢组成的油气分子` or `液态油气分子`. Scene still starts from rock pores, pressure, water/gas, and well path. Worked example has units and changes the economic conclusion: `10亿桶 × 35% = 3.5亿桶` versus `10亿桶 × 28% = 2.8亿桶`, a `0.7亿桶` final-supply difference. |
| `physical-chain` | Pass. Physical objects come first: valves, short lines, separator tanks, meters, oil/water/gas mixture. The example converts `10,000桶/日` gross wellstream into `8,900 bpd` stable liquid after `8%` water and `3%` gas, changing revenue, pipeline capacity, and inventory interpretation. |
| `liquids-family` | Pass. Terminal tanks, gathering routes, sampling, and batch size precede `Gathering system`, `Blend`, and `Grade`. The example combines `10,000 bpd + 20,000 bpd + 20,000 bpd = 50,000 bpd` and changes unit dispatch cost from `2.50美元/桶` to `0.50美元/桶`. |
| `assay-quality` | Pass. The lab sheet and refinery buyer are introduced before `Assay`, `API gravity`, and `Sulfur content`. API formula remains in deep dive after the light/heavy physical meaning is taught. The example changes purchase economics: a difficult crude needs a `69美元/桶` max buy price instead of `75美元/桶` to preserve `4美元/桶` margin. |
| `molecular-barrel` | Defect fixed. Scene and concept previously used `烃类分子` before the physical definition. They now say molecules are made of carbon and hydrogen before discussing size/boiling behavior. The `42 gallons` example changes expected gasoline-range volume by `8.4 gallons`. |
| `refinery-transformation` | Pass. The lesson explains distillation, conversion, treatment, and blending as physical operations before terms. The example uses `42 gallons`, `45 gallons`, `2.10美元/gallon`, `80美元/桶`, and `7美元/桶` to reach `7.5美元/桶` margin, so the number changes the profit conclusion. |
| `products-specifications` | Pass. Product tanks, blending, lab tests, and seasonal/regional rules precede `Blendstock`, `RVP`, and `Product slate`. The `100,000 gallons × 25% × 2.80美元/gallon = 70,000美元` example changes whether inventory is usable or costly. |
| `logistics-availability` | Pass. Transport modes remain clear in the main path: truck for short flexible collection, pipeline for stable large flow, rail for missing pipeline/rerouting, tanker for cross-sea movement, and storage as a time buffer. Usable-supply synthesis remains clear: grade, location, time, facility, testing, turnaround, and delivery terms must align. The example shows a `$5/bbl` discount is not usable supply when extra cost is `$7/bbl`, producing a `2美元/桶` net loss. |

No lesson assumes WTI, Cushing, equipment names, or contract terms as prerequisites for its core market link. Worldscale, capacity booking, hub constraints, and delivery constraints remain in `logistics-availability.deep_dive` and are explained there; the core answer does not depend on unexplained deep-dive facts.

## Coverage And Mirror Proof

Command:

```powershell
$env:PYTHONIOENCODING='utf-8'; & 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json, pathlib; p=pathlib.Path(r'course/data/oil101-understanding/module-01-barrel-journey.json'); q=pathlib.Path(r'docs/data/oil101-understanding/module-01-barrel-journey.json'); m=json.loads(p.read_text(encoding='utf-8')); cov=sum(len(x.get('section_mappings',[])) if isinstance(x,dict) and isinstance(x.get('section_mappings'),list) else 1 for x in m['source_coverage']); print({'coverage':cov,'mirror':p.read_bytes()==q.read_bytes()}); assert cov==87; assert p.read_bytes()==q.read_bytes()"
```

Output:

```text
{'coverage': 87, 'mirror': True}
```

Audit extractor output after the fix:

```text
sha256 d106b4c39b34a26db4f7e335c8479731f7a4773758163b533d92f7c9e388a233
lessons 8
figures [('refinery-transformation', '../assets/figures/module-01/crude-fractional-distillation.jpg')]
early_hydrocarbon_jargon_lines
reservoir-to-well terms 3 deep 1 inputs 2 steps 3
physical-chain terms 3 deep 1 inputs 2 steps 3
liquids-family terms 3 deep 1 inputs 5 steps 4
assay-quality terms 3 deep 2 inputs 4 steps 5
molecular-barrel terms 2 deep 1 inputs 2 steps 3
refinery-transformation terms 3 deep 1 inputs 5 steps 4
products-specifications terms 3 deep 1 inputs 3 steps 3
logistics-availability terms 3 deep 3 inputs 5 steps 4
```

## Screenshot Evidence

Captured with local `http://localhost:8787` using 1440x1000 and 390x844 viewports.

- `.superpowers/sdd/screenshots/module-01-desktop-1440x1000-intro-top.png`
- `.superpowers/sdd/screenshots/module-01-desktop-1440x1000-lesson-01-viewport.png`
- `.superpowers/sdd/screenshots/module-01-desktop-1440x1000-lesson-01-complete.png`
- `.superpowers/sdd/screenshots/module-01-desktop-1440x1000-figure-lesson-viewport.png`
- `.superpowers/sdd/screenshots/module-01-desktop-1440x1000-figure-lesson.png`
- `.superpowers/sdd/screenshots/module-01-mobile-390x844-intro-top.png`
- `.superpowers/sdd/screenshots/module-01-mobile-390x844-lesson-01-viewport.png`
- `.superpowers/sdd/screenshots/module-01-mobile-390x844-lesson-01-complete.png`
- `.superpowers/sdd/screenshots/module-01-mobile-390x844-figure-lesson-viewport.png`
- `.superpowers/sdd/screenshots/module-01-mobile-390x844-figure-lesson.png`

Capture metrics:

```text
desktop-1440x1000 {"scrollWidth":1440,"innerWidth":1440,"teachingLessons":8,"figures":[{"naturalWidth":1600,"naturalHeight":2075,"complete":true,"src":"../../assets/figures/module-01/crude-fractional-distillation.jpg"}]}
mobile-390x844 {"scrollWidth":390,"innerWidth":390,"teachingLessons":8,"figures":[{"naturalWidth":1600,"naturalHeight":2075,"complete":true,"src":"../../assets/figures/module-01/crude-fractional-distillation.jpg"}]}
```

Visual observations:

- Desktop introduction/top: no clipped heading, no overlapping sidebar/topbar, readable opening question and objectives.
- Desktop first complete lesson: content complete; term cards and warning boxes readable. The stitched element capture includes a sticky-nav artifact, so viewport captures were used for actual overlap judgment.
- Desktop figure lesson: source figure is nonblank, labels are present, and the reading guide explains the figure's limited scope.
- Mobile introduction/top: no horizontal overflow; heading wraps naturally; top navigation does not cover content.
- Mobile first complete lesson: dense but readable; example, mechanism chain, term cards, warnings, and deep dive stack within viewport.
- Mobile figure lesson: figure loads and remains visible; no repeated/missing rendered labels found; no clipped or overlapping text.

## Fresh Verification Suite

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --check docs/assets/platform.js
```

Output:

```text
[exit 0; no stdout]
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
```

Output:

```text
tests 17
pass 17
fail 0
duration_ms 239.1965
```

Command:

```powershell
$env:PYTHONIOENCODING='utf-8'; & 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-01-barrel-journey.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK'); raise SystemExit(bool(e))"
```

Output:

```text
FLOORS OK
```

Command:

```powershell
$env:NODE_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\.pnpm\node_modules'; $env:PLAYWRIGHT_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\playwright'; $env:PLAYWRIGHT_BROWSER_PATH='C:\Program Files\Google\Chrome\Application\chrome.exe'; & 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' tests/ui-smoke.mjs
```

Output:

```text
UI SMOKE OK: 9 modules, desktop + mobile
```

Command:

```powershell
git diff --check
```

Output:

```text
warning: in the working copy of 'course/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
```

Exit code was 0; no whitespace errors were reported.

## Residual Risks

- The complete lesson element screenshots are useful for full content coverage but can show sticky topbar artifacts in the stitched image. Viewport screenshots were used for actual visual-overlap judgment.
- Mobile reading is still long and dense by nature of the sample, though it fits the viewport and does not overflow.
- The user still needs to do the intended human reading approval before applying this style to Modules 02-09.
