# Reference Renderer Report

- Scope: `docs/assets/platform.js`, `tests/oil101-platform.test.mjs`
- Change: `renderFigure` keeps the chapter reference URL, label, and accessed date, and conditionally appends an escaped `asset_url` link as `原图 Original asset` when present.
- Safety: both link `href` values and visible strings go through `escapeHtml`; missing `asset_url` produces no empty link and no `undefined`.
- Validation:
  - `node --test tests/oil101-platform.test.mjs --test-name-pattern "figure renderer escapes chapter and original asset references without leaking empty links"`
  - `node --check docs/assets/platform.js`
  - `node --check tests/oil101-platform.test.mjs`
  - `git diff --check`
- Result:
  - `git diff --check` passed.
  - The three Node commands could not run in this shell because `node` is not installed or not available on `PATH` (`CommandNotFoundException`).
