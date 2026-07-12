# Reference Renderer Report

- Scope: `docs/assets/platform.js`, `tests/oil101-platform.test.mjs`
- Change: `renderFigure` keeps the escaped chapter reference URL, label, accessed date, and optional `原图 Original asset` link. Figure sources with leading `./` or repeated `../` segments now normalize to exactly `../assets/...` for `docs/learn/module.html`.
- Safety: both reference links, visible source strings, and the normalized image source go through `escapeHtml`. Sources outside the local `assets/` subtree, malformed URL encoding, and decoded traversal segments are neutralized. Missing `asset_url` produces no empty link and no `undefined`.
- Validation:
  - Bundled Node: `C:\Users\justi\AppData\Local\OpenAI\Codex\runtimes\cua_node\1b23c930bdf84ed6\bin\node.exe` (`v24.14.0`)
  - `node --check docs/assets/platform.js`
  - `node --check tests/oil101-platform.test.mjs`
  - `node --test --test-name-pattern "figure renderer" tests/oil101-platform.test.mjs`
  - `node --test tests/oil101-platform.test.mjs`
  - `git diff --check`
- Result:
  - Both `node --check` commands passed.
  - Focused renderer/path tests passed: 2 tests, 2 passed, 0 failed.
  - Full Node suite passed: 19 tests, 19 passed, 0 failed.
  - `git diff --check` passed.
