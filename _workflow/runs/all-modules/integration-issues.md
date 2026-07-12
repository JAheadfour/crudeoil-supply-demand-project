# Integrated Course Issues

## Closed

- `docs/assets/platform.js`: now renders escaped `figure.reference.asset_url` when present; focused renderer test passes.
- `docs/sw.js` and lesson script/data versions: bumped to cache `v7` and data/script version `20260711-4`.
- Browser QA: Modules 03, 06, 08, and 09 inspected on desktop/mobile; full nine-module smoke passes.
- Module 06 malformed local figure: replaced byte-for-byte with the current author-hosted original asset; visual re-review approved.
- GitHub Pages project-path figures: renderer now normalizes all canonical path forms to `../assets/...`; Module 01/07/09 URL-resolution regression tests pass.

## Closed During Module Review

- Module 07 writer could not execute the bundled Node gate; parent execution found `reserves-bookability` lacked a recognized arithmetic expression. Sent to its blind reviewer for mandatory repair.
