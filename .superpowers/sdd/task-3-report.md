# Task 3 Report

## Scope

- Owner files changed:
  - `docs/assets/platform.js`
  - `docs/assets/platform.css`
  - `tests/oil101-platform.test.mjs`
  - `tests/ui-smoke.mjs`
  - `docs/sw.js`
  - `docs/learn/module.html`
  - `docs/learn/inventory-curve.html`
- New file:
  - `.superpowers/sdd/task-3-report.md`

## Red -> Green Evidence

### Red

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
```

Output:

```text
✖ teaching lessons render beginner-first sections in the intended order
  TypeError: renderTeachingLesson is not a function

✖ teaching lessons render actor, inputs, calculation, conclusion, and escape source content
  TypeError: renderTeachingLesson is not a function

✖ teaching lessons tolerate missing optional arrays without leaking undefined
  TypeError: renderTeachingLesson is not a function

✖ teaching renderer and lesson shells keep cache-busting versions aligned
  actual: '20260711-2'
  expected: '20260711-3'
```

Interpretation:

- The new renderer contract was genuinely missing.
- Cache/data/script version strings were still on the stale revision.

### Green

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --check docs/assets/platform.js
```

Output:

```text
[exit 0]
```

Command:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
```

Output:

```text
✔ teaching lessons render beginner-first sections in the intended order
✔ teaching lessons render actor, inputs, calculation, conclusion, and escape source content
✔ teaching lessons tolerate missing optional arrays without leaking undefined
✔ teaching renderer and lesson shells keep cache-busting versions aligned
ℹ pass 17
ℹ fail 0
```

Server health check:

```powershell
try { (Invoke-WebRequest -Uri 'http://localhost:8787/' -UseBasicParsing -TimeoutSec 5).StatusCode } catch { Write-Output $_.Exception.Message; exit 1 }
```

Output:

```text
200
```

Browser smoke:

```powershell
$env:NODE_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\.pnpm\node_modules'
$env:PLAYWRIGHT_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\playwright'
$env:PLAYWRIGHT_BROWSER_PATH='C:\Program Files\Google\Chrome\Application\chrome.exe'
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' tests/ui-smoke.mjs
```

Output:

```text
UI SMOKE OK: 9 modules, desktop + mobile
```

Whitespace check:

```powershell
git diff --check
```

Output:

```text
warning: in the working copy of 'docs/assets/platform.css', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/assets/platform.js', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/learn/inventory-curve.html', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/learn/module.html', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/sw.js', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'tests/oil101-platform.test.mjs', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'tests/ui-smoke.mjs', LF will be replaced by CRLF the next time Git touches it
```

Interpretation:

- No diff-format errors were reported.
- Remaining output is line-ending warning noise only.

## Files Changed

- `docs/assets/platform.js`
  - Added `renderTeachingLesson(lesson, figures)`.
  - Routed lessons with `reader_question` to the new renderer.
  - Preserved `renderLesson()` as the fallback path.
  - Added rendering for worked-example actor, inputs, setup, steps, and conclusion.
  - Used `asArray()`/defaults for optional arrays.
  - Bumped `MODULE_DATA_VERSION` from `20260711-2` to `20260711-3`.
- `docs/assets/platform.css`
  - Added restrained semantic styling for teaching lessons, scene, plain answer, example labels, terms, and deep dives.
  - Forced terms into one column on mobile.
  - Added `overflow-wrap` protection to keep mobile text within the viewport.
- `tests/oil101-platform.test.mjs`
  - Added red/green contract tests for teaching lesson order.
  - Added tests for actor/input/calculation/conclusion rendering.
  - Added escaping and optional-array coverage.
  - Added version-alignment checks across `platform.js`, both lesson HTML files, and `sw.js`.
- `tests/ui-smoke.mjs`
  - Added Module 01 assertions for exactly 8 `.teaching-lesson` sections.
  - Checked teaching labels, deep dives, example actor/input/conclusion content, and no horizontal overflow.
  - Kept the all-nine-modules loop to cover fallback rendering.
- `docs/sw.js`
  - Bumped `CACHE_NAME` from `oil101-understanding-v5` to `oil101-understanding-v6`.
- `docs/learn/module.html`
  - Bumped `platform.js` query version to `20260711-3`.
- `docs/learn/inventory-curve.html`
  - Bumped `platform.js` query version to `20260711-3`.

## Backward-Compatibility Evidence

- The runtime branch still calls `renderLesson()` when `lesson.reader_question` is absent.
- Browser smoke still opens all 9 catalog modules successfully.
- The smoke suite still verifies self-check counts for every module.
- Existing progress/self-check/source-reference tests stayed green.
- `UI SMOKE OK: 9 modules, desktop + mobile` confirms Module 01 and Modules 02-09 still render through the shared shell.

## Cache-Version Evidence

- `docs/assets/platform.js`: `MODULE_DATA_VERSION = "20260711-3"`
- `docs/learn/module.html`: `platform.js?v=20260711-3`
- `docs/learn/inventory-curve.html`: `platform.js?v=20260711-3`
- `docs/sw.js`: `CACHE_NAME = 'oil101-understanding-v6'`
- Static test `teaching renderer and lesson shells keep cache-busting versions aligned` passes.

## Concerns

- `sw.js` still uses `caches.match(..., { ignoreSearch: true })` by design. This task only applied the requested targeted refresh through cache/version bumps; future asset/data updates will need the same coordinated bump unless the caching strategy is changed later on purpose.
- `git diff --check` is clean apart from CRLF warnings from the local working-copy settings.
