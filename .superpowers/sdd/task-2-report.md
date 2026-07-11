# Task 2 Report: Module 01 Beginner Rewrite

## Status

Complete. Rewrote Module 01 reader-facing content for the beginner-readable Oil 101 path, preserved the existing eight lesson IDs, preserved 87 source coverage records, synced the docs mirror byte-for-byte, and got both required checks green.

## Pages Read

Directly read the eight current author pages from `oil101.morgandowney.com`:

- `https://oil101.morgandowney.com/chapters/crude-oil-assay`
- `https://oil101.morgandowney.com/chapters/components`
- `https://oil101.morgandowney.com/chapters/chemistry`
- `https://oil101.morgandowney.com/chapters/industry-overview`
- `https://oil101.morgandowney.com/chapters/exploration-production`
- `https://oil101.morgandowney.com/chapters/refining`
- `https://oil101.morgandowney.com/chapters/finished-products`
- `https://oil101.morgandowney.com/chapters/transporting-oil`

I also read:

- `.superpowers/sdd/task-2-brief.md`
- `docs/superpowers/specs/2026-07-11-oil101-content-rewrite-design.md`
- `_workflow/module-01-concept-map.md`
- `tests/oil101-platform.test.mjs`

I inspected the current Module 01 JSON only for schema, IDs, figures, sources, source coverage, and audit metadata.

## Files Changed

- `course/data/oil101-understanding/module-01-barrel-journey.json`
- `docs/data/oil101-understanding/module-01-barrel-journey.json`

The docs mirror was produced with:

```powershell
Copy-Item -LiteralPath 'course/data/oil101-understanding/module-01-barrel-journey.json' -Destination 'docs/data/oil101-understanding/module-01-barrel-journey.json' -Force
```

## Per-Lesson Counts

| Lesson | Scene chars | Plain answer chars | Explanation chars | Terms | Deep-dive | Example steps | Inputs |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `reservoir-to-well` | 131 | 73 | 322 | 3 | 1 | 3 | 2 |
| `physical-chain` | 126 | 66 | 320 | 3 | 1 | 3 | 2 |
| `liquids-family` | 138 | 64 | 322 | 3 | 1 | 4 | 3 |
| `assay-quality` | 129 | 58 | 315 | 3 | 1 | 4 | 2 |
| `molecular-barrel` | 143 | 63 | 312 | 2 | 1 | 3 | 2 |
| `refinery-transformation` | 139 | 64 | 310 | 3 | 1 | 4 | 2 |
| `products-specifications` | 125 | 63 | 329 | 3 | 1 | 3 | 2 |
| `logistics-availability` | 140 | 64 | 301 | 3 | 1 | 3 | 2 |

All worked examples include `actor`, substantive `inputs`, `setup`, `steps`, and `answer`. Each example has at least one explicit arithmetic expression with a recognized unit.

## Coverage And Mirror Evidence

Command:

```powershell
$env:PYTHONIOENCODING='utf-8'; & 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json, pathlib, hashlib; p=pathlib.Path(r'course/data/oil101-understanding/module-01-barrel-journey.json'); q=pathlib.Path(r'docs/data/oil101-understanding/module-01-barrel-journey.json'); m=json.load(open(p,encoding='utf-8')); print('coverage',len(m['source_coverage'])); print('mirror_equal',p.read_bytes()==q.read_bytes()); print('sha',hashlib.sha256(p.read_bytes()).hexdigest()); ..."
```

Output:

```text
coverage 87
mirror_equal True
sha c50259e64030c46436d96cf5d21fc84e607ffc118a686f68724b9a5163bdb1cd
reservoir-to-well scene 131 plain 73 expl 322 terms 3 deep 1 steps 3 inputs 2
physical-chain scene 126 plain 66 expl 320 terms 3 deep 1 steps 3 inputs 2
liquids-family scene 138 plain 64 expl 322 terms 3 deep 1 steps 4 inputs 3
assay-quality scene 129 plain 58 expl 315 terms 3 deep 1 steps 4 inputs 2
molecular-barrel scene 143 plain 63 expl 312 terms 2 deep 1 steps 3 inputs 2
refinery-transformation scene 139 plain 64 expl 310 terms 3 deep 1 steps 4 inputs 2
products-specifications scene 125 plain 63 expl 329 terms 3 deep 1 steps 3 inputs 2
logistics-availability scene 140 plain 64 expl 301 terms 3 deep 1 steps 3 inputs 2
```

## Exact Verification Commands And Output

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests\oil101-platform.test.mjs
```

Output:

```text
✔ homepage exposes the thematic learning route and full course shell (3.138ms)
✔ sample module meets the understanding content floor (1.3643ms)
✔ every referenced figure is local, informative, and attributed (0.9402ms)
✔ lesson shell supports progress, self checks, and source references (0.6059ms)
✔ generic lesson shell loads only a named course module (0.5145ms)
✔ generic lesson shell exposes the full learning product (0.7447ms)
✔ homepage reflects saved sample progress (0.5849ms)
✔ offline bundle includes the product shell, lesson data, and figure (2.3533ms)
✔ service worker replaces stale caches and never stores failed module responses (0.9538ms)
✔ catalog links all nine complete and mirrored course modules (33.2823ms)
✔ module 01 only uses newly introduced lesson terms after terms_in_context defines them (8.1081ms)
✔ product files contain no unfinished markers (1.7244ms)
✔ published course modules contain readable Chinese rather than mojibake (6.3618ms)
ℹ tests 13
ℹ suites 0
ℹ pass 13
ℹ fail 0
ℹ cancelled 0
ℹ skipped 0
ℹ todo 0
ℹ duration_ms 218.6106
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-01-barrel-journey.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Output:

```text
FLOORS OK
```

## Self-Review

- Rebuilt module-level `deck`, `reading_intent`, `opening_question`, `quick_answer`, `learning_objectives`, `main_thread`, and `mental_model` in natural Chinese with no unexplained first-step shorthand.
- Rewrote all eight lessons with `reader_question`, `scene`, `plain_answer`, `terms_in_context`, `deep_dive`, and expanded `worked_example`.
- Preserved legacy validator fields: `concept`, `explanation`, `mechanism_chain`, `worked_example`, `practitioner_lens`, `misreading`, and `boundary`.
- Preserved the single figure asset/reference and improved its `reading_guide`.
- Preserved all 87 source coverage records in count and traceability.
- Adjusted term-card labels where needed so the strict definition-point contract passes.
- Restored clean UTF-8 after an early PowerShell pipe attempt exposed an encoding hazard; final mojibake test is green.

## Concerns

- Some term-card Chinese labels use slightly more descriptive synonyms to satisfy the strict “label may not appear before card” contract. The lesson prose remains natural, but future writers should be aware that common labels like `分馏`, `储罐`, and `油种` can easily trip the validator if introduced in prose before term cards.
- Git reports LF-to-CRLF warnings for the two JSON files on future touches; this did not affect byte identity between canonical and mirror in the current working tree.

## Commit

`58fda7c` (`Rewrite Module 01 for oil-industry beginners`)

## Review-Fix Section: 2026-07-11

### Finding-To-Fix Map

- Finding 1, final synthesis: rewrote `logistics-availability` in both JSON mirrors from a route/capacity-only lesson into the final economic-usability synthesis. It now teaches that nominal supply becomes usable supply only when grade, location, timing, compatible facility, operational constraints, specification window, turnaround state, and delivery terms line up. The lesson keeps the same ID and now has an integrated port/refinery scene, a worked example with declared costs, new terms, and a deep dive on operating/spec/turnaround/delivery constraints.
- Finding 2, source coverage IDs: audited all 87 `source_coverage` rows and preserved the count. Updated semantic targets for `Fields, Streams, and Blends` and `Streams, Blends, and Grades` to `liquids-family`; also moved `The Downstream Footprint` and `Turnaround Season` to `logistics-availability` because the final lesson now owns compatible facility and turnaround usability.
- Finding 3, worked-example number order: audited all eight examples. Added missing declared inputs before calculation for `assay-quality` (`15美元/桶`, then computed `69美元/桶` after margin arithmetic), `refinery-transformation` (`80美元/桶`, `7美元/桶`), `products-specifications` (`2.80美元/gallon`), and the rewritten final lesson. Each example now flows inputs -> arithmetic -> interpretation.
- Finding 4, premature API jargon: removed the module-level API formula. Removed API arithmetic from `liquids-family`; that example now teaches commercial batch scale and fixed-cost dilution. Preserved the API formula only inside `assay-quality.deep_dive`, after light/heavy physical meaning and the API term card are established.
- Finding 5, mixed units: removed the named mixed-unit strings `10亿桶 barrels`, `50,000桶/日 bpd`, `39.2API`, `600,000桶 bpd`, and `US$`. Remaining validator-facing units use one convention per phrase, such as `bpd`, `$75/bbl`, or `gallons`.

### Review Audit Evidence

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' -e "...review audit..."
```

Output:

```text
mirror_equal true
coverage_count 87
lesson_ids reservoir-to-well,physical-chain,liquids-family,assay-quality,molecular-barrel,refinery-transformation,products-specifications,logistics-availability
module_level_api_formula false
mixed_unit_phrases none
coverage_target Fields, Streams, and Blends => liquids-family
coverage_target Streams, Blends, and Grades => liquids-family
coverage_target The Downstream Footprint => logistics-availability
coverage_target Turnaround Season => logistics-availability
sha256 f31a6fc36659f0c73a16abf58b8a2f412a5611b429e854d84021bac3f04a148c
```

### Verification Evidence

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests\oil101-platform.test.mjs
```

Output:

```text
tests 13
pass 13
fail 0
duration_ms 182.6866
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-01-barrel-journey.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Output:

```text
FLOORS OK
```

Command:

```powershell
git diff --check
```

Output:

```text
warning: in the working copy of '.superpowers/sdd/task-2-report.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'course/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
```

## Second review fix: 2026-07-11

### Finding-to-fix map

- Restored a transport foundation inside `logistics-availability` without weakening its economic-usability synthesis. One refinery-dispatch scene now follows route selection through truck, pipeline, rail, tanker, storage, and a trading hub before applying the grade + location + timing + compatible-facility test.
- Put the essential mode roles and tradeoffs in `plain_answer`, `explanation`, and `mechanism_chain`: truck for flexible short-haul collection, pipeline for fixed-route high-volume flow, rail for rerouting or places without pipeline access, tanker for large cross-sea movement, and storage for bridging arrival and use time.
- Added deep dives on all-in freight, booked versus usable capacity, hub inflow/outflow bottlenecks, and Worldscale. The Worldscale explanation distinguishes a route-specific flat rate from a WS percentage and notes the remaining delivered-cost adjustments.
- Removed the false statement that earlier lessons had already taught logistics. Kept all 11 coverage rows mapped to this lesson because their promised subjects are now taught in the main path or deep dive; all 87 module coverage rows remain.
- Preserved the usable-supply worked example and its declared-input -> arithmetic -> interpretation order, including grade/specification, delivery timing, turnaround, and facility-fit constraints.

### Red-green content evidence

Pre-fix assertion output (exit 1):

```text
missing main:油轮,main:铁路,main:卡车,deep:Worldscale,deep:运费,deep:枢纽,deep:capacity
```

Post-fix assertion output (exit 0):

```text
missing none
```

### Verification evidence

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests\oil101-platform.test.mjs
```

Output:

```text
tests 13
pass 13
fail 0
duration_ms 205.8386
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-01-barrel-journey.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK'); raise SystemExit(bool(e))"
```

Output:

```text
FLOORS OK
```

Mirror and coverage audit output:

```text
mirror_equal true
coverage_count 87
lesson_ids reservoir-to-well,physical-chain,liquids-family,assay-quality,molecular-barrel,refinery-transformation,products-specifications,logistics-availability
main_modes 卡车:true,管道:true,铁路:true,油轮:true,储存:true
synthesis 牌号:true,地点:true,时间:true,设施:true,检修:true,检测:true,交货:true
deep_dive Worldscale:true,运费:true,枢纽:true,能力:true
mapped_rows 11
coverage Five Methods of Moving Oil => true
coverage Tanker Ships => true
coverage Chartering and Worldscale => true
coverage Pipelines => true
coverage Crude by Rail and the Bakken Boom => true
coverage Trucking: The Last Mile => true
coverage Trading Hubs => true
coverage Incoterms and Delivery Pricing => true
sha256 7f07a2d8ef50f7e19d0cb99b65b970415da95f75830085bb01985faa87660a88
```

Command:

```powershell
git diff --check
```

Output (exit 0; line-ending warnings only):

```text
warning: in the working copy of '.superpowers/sdd/task-2-report.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'course/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/data/oil101-understanding/module-01-barrel-journey.json', LF will be replaced by CRLF the next time Git touches it
```
