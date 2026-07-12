# Final Visual QA - Oil 101 Complete Course

Date: 2026-07-12
Server: http://localhost:8787
Scope: Modules 03, 06, 08, 09 at desktop 1440x1000 and mobile 390x844.
Production files: read-only; no production edits made.

## Verdict

APPROVED.

No blocking visual/readability issue remains in the inspected scope. The previously blocking Module 06 figure was replaced and passed focused desktop, mobile, direct-asset, overflow, and reference-link re-review. The upstream original retains a slightly crowded title where `Unhedged` and `Probability` touch; this is a minor source artifact rather than a blocking learner issue because it does not obscure the chart body, distributions, annotations, axes, caption, or instructional point.

## Method

- Used the bundled Playwright/Chrome setup documented by `tests/ui-smoke.mjs`.
- Temporary capture script:
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\capture-final-visual-qa.mjs`
- Metrics JSON:
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\metrics.json`
- Module 06 replacement recheck script and metrics:
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\recheck-module-06-figure.mjs`
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-replacement-metrics.json`
- Contact sheets used for visual sweep:
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\contact-all.png`
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\contact-all-expanded.png`

## Sticky Header Artifact Check

Some tall element screenshots show the sticky `Oil 101` topbar stitched through the middle of a long section. This is a Playwright element/full-section screenshot artifact caused by capturing content taller than the viewport while a sticky header is active.

Viewport-centered screenshots were captured for the same sections. Those viewport checks did not show real content hidden behind the sticky header during normal viewport inspection.

Relevant viewport checks include:

- `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-long-worked-example-viewport.png`
- `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-lng-transition-example-viewport.png`
- `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-case-1-negative-price-viewport.png`
- `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-opening-definitions-viewport.png`

## DOM Metrics

| Module | Viewport | innerWidth | scrollWidth | Overflow elements | Figures natural size | Table metrics |
|---|---:|---:|---:|---:|---|---|
| module-03-local-shortages | desktop 1440x1000 | 1440 | 1440 | 0 | 1600x2075; 2463x1724; 960x641 | t0 820/820 cols4 rows5; t1 820/820 cols3 rows7 |
| module-06-risk-management | desktop 1440x1000 | 1440 | 1440 | 0 | 2752x1536 | t0 820/820 cols4 rows6; t1 820/820 cols4 rows6; t2 820/820 cols3 rows6; t3 820/820 cols3 rows4 |
| module-08-products-petrochem-transition | desktop 1440x1000 | 1440 | 1440 | 0 | 1980x990 | t0 820/820 cols4 rows6; t1 820/820 cols3 rows4; t2 820/820 cols4 rows4 |
| module-09-industry-synthesis-lab | desktop 1440x1000 | 1440 | 1440 | 0 | 959x1035 | t0 820/820 cols4 rows5; t1 820/820 cols4 rows6; t2 820/820 cols4 rows5 |
| module-03-local-shortages | mobile 390x844 | 390 | 390 | 0 | 1600x2075; 2463x1724; 960x641 | t0 358/358 cols4 rows5; t1 358/358 cols3 rows7 |
| module-06-risk-management | mobile 390x844 | 390 | 390 | 0 | 2752x1536 | t0 358/537 cols4 rows6; t1 358/599 cols4 rows6; t2 358/358 cols3 rows6; t3 358/358 cols3 rows4 |
| module-08-products-petrochem-transition | mobile 390x844 | 390 | 390 | 0 | 1980x990 | t0 358/358 cols4 rows6; t1 358/358 cols3 rows4; t2 358/358 cols4 rows4 |
| module-09-industry-synthesis-lab | mobile 390x844 | 390 | 390 | 0 | 959x1035 | t0 358/358 cols4 rows5; t1 358/358 cols4 rows6; t2 358/358 cols4 rows5 |

Notes:

- No page-level mobile horizontal overflow detected (`scrollWidth == innerWidth`) for any checked module/viewport.
- All loaded figures had nonzero `naturalWidth`.
- Module 06 mobile tables t0 and t1 are internally horizontally scrollable. Font size is readable and page-level overflow is clean, but the table requires horizontal scroll to see all columns.

## Module 06 Blocker Re-review

Replacement evidence:

- Production asset inspected read-only: `C:\Users\justi\OneDrive\Documents\oil\docs\assets\figures\module-06\ch20-hedged-vs-unhedged.png`
- File size: 4,239,241 bytes.
- SHA256: `1EF35B3A876C8159210B300FF03073AB8AECAAAFF2C0E1D75D0A98D29BB1A050`.
- Intrinsic image size: 2752x1536; complete with nonzero `naturalWidth` at both page viewports.
- Desktop page render: 820x459 inside an 820 px figure block; `innerWidth=1440`, `scrollWidth=1440`, visible overflow elements `0`.
- Mobile page render: 358x201 inside a 358 px figure block; `innerWidth=390`, `scrollWidth=390`, visible overflow elements `0`.
- Original asset link is visible and contained at both sizes. Desktop: 398x16 at 12 px; mobile: 353x36 at 12 px, wrapping within the content column with no overflow.

Visual result:

- The plot fills the image canvas. There is no blank lower canvas or compressed top-strip chart.
- All chart-body annotations and arrows are present and remain inside the image; none are clipped.
- Axes, bankruptcy/windfall regions, hedged/unhedged distributions, forward-price marker, caption, and page reading guide are readable in context.
- The slightly crowded upstream title is visible at both viewports but does not interfere with the learner's ability to read or interpret the chart body. Classified minor/non-blocking.
- Viewport screenshots show no real sticky-header overlap with the figure or reference block.

Focused evidence:

- Direct asset scaled: `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\asset-check-module-06-hedged-vs-unhedged-replacement-scaled.png`
- Desktop figure block: `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-replacement-figure-block.png`
- Desktop viewport: `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-replacement-figure-viewport.png`
- Mobile figure block: `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-replacement-figure-block.png`
- Mobile viewport: `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-replacement-figure-viewport.png`

## Visual Findings By Module

### Module 03 - Local Shortages

Status: pass for inspected surfaces.

- Desktop and mobile top/introduction screenshots are readable; no heading repetition, missing heading, or overflow observed.
- Complete long teaching lesson `#refinery-config` is readable on desktop and mobile.
- Figures load and are not blank. Module 03 reference blocks and Original asset links wrap within the content column.

### Module 06 - Risk Management

Status: pass for inspected surfaces after replacement re-review.

- Replaced hedged/unhedged figure passes desktop/mobile page rendering and direct-asset inspection. Chart body is complete and readable; the crowded upstream title is minor/non-blocking.
- Comparison table and derivative equation render without page-level overflow.
- Mobile comparison table is readable but requires internal horizontal scrolling for full columns.
- Long worked example text is readable in viewport screenshots; sticky topbar visible in tall element captures is a stitching artifact, not a real overlap.

### Module 08 - Products / Petrochem / Transition

Status: pass for inspected surfaces.

- Top/introduction screenshots are readable on desktop and mobile.
- Petrochemical molecule-tree lesson and LNG/transition lesson are readable.
- Figure `us-ethane-ethylene-derivative-exports.svg` is not blank; labels are legible at desktop and mobile sizes.
- Reference block with Original asset link is readable and wraps correctly:
  `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-figure-reference-block.png`

### Module 09 - Industry Synthesis Lab

Status: pass for inspected surfaces.

- Opening definitions / mental model section is readable on desktop and mobile.
- Case 1 negative-price section is readable on desktop and mobile.
- Strait of Hormuz figure loads and is legible; no blank image or clipping observed in the inspected long lesson screenshot.
- Sticky topbar in tall element screenshots is a stitching artifact; viewport checks are readable.

## Screenshot Manifest

- module-03-local-shortages | desktop | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-desktop-complete-long-lesson-refinery-config.png`
- module-03-local-shortages | desktop | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-desktop-long-worked-example-viewport.png`
- module-03-local-shortages | desktop | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-desktop-top-viewport.png`
- module-03-local-shortages | mobile | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-mobile-complete-long-lesson-refinery-config.png`
- module-03-local-shortages | mobile | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-mobile-long-worked-example-viewport.png`
- module-03-local-shortages | mobile | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-03-local-shortages-mobile-top-viewport.png`
- module-06-risk-management | desktop | comparison table / derivative content | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-comparison-table.png`
- module-06-risk-management | desktop | comparison table viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-comparison-table-viewport.png`
- module-06-risk-management | desktop | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-complete-long-lesson-exposure.png`
- module-06-risk-management | desktop | derivative equation | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-derivative-equation.png`
- module-06-risk-management | desktop | derivative equation viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-derivative-equation-viewport.png`
- module-06-risk-management | desktop | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-long-worked-example-viewport.png`
- module-06-risk-management | desktop | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-desktop-top-viewport.png`
- module-06-risk-management | mobile | comparison table / derivative content | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-comparison-table.png`
- module-06-risk-management | mobile | comparison table viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-comparison-table-viewport.png`
- module-06-risk-management | mobile | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-complete-long-lesson-exposure.png`
- module-06-risk-management | mobile | derivative equation | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-derivative-equation.png`
- module-06-risk-management | mobile | derivative equation viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-derivative-equation-viewport.png`
- module-06-risk-management | mobile | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-long-worked-example-viewport.png`
- module-06-risk-management | mobile | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-06-risk-management-mobile-top-viewport.png`
- module-08-products-petrochem-transition | desktop | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-complete-long-lesson-petrochemical-molecule-tree.png`
- module-08-products-petrochem-transition | desktop | figure and reference block | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-figure-reference-block.png`
- module-08-products-petrochem-transition | desktop | figure/reference viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-figure-reference-block-viewport.png`
- module-08-products-petrochem-transition | desktop | LNG / transition example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-lng-transition-example-viewport.png`
- module-08-products-petrochem-transition | desktop | LNG / transition lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-lng-transition-lesson.png`
- module-08-products-petrochem-transition | desktop | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-long-worked-example-viewport.png`
- module-08-products-petrochem-transition | desktop | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-desktop-top-viewport.png`
- module-08-products-petrochem-transition | mobile | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-complete-long-lesson-petrochemical-molecule-tree.png`
- module-08-products-petrochem-transition | mobile | figure and reference block | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-figure-reference-block.png`
- module-08-products-petrochem-transition | mobile | figure/reference viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-figure-reference-block-viewport.png`
- module-08-products-petrochem-transition | mobile | LNG / transition example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-lng-transition-example-viewport.png`
- module-08-products-petrochem-transition | mobile | LNG / transition lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-lng-transition-lesson.png`
- module-08-products-petrochem-transition | mobile | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-long-worked-example-viewport.png`
- module-08-products-petrochem-transition | mobile | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-08-products-petrochem-transition-mobile-top-viewport.png`
- module-09-industry-synthesis-lab | desktop | Case 1 negative-price section | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-case-1-negative-price.png`
- module-09-industry-synthesis-lab | desktop | Case 1 negative-price viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-case-1-negative-price-viewport.png`
- module-09-industry-synthesis-lab | desktop | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-complete-long-lesson-bottleneck-geometry.png`
- module-09-industry-synthesis-lab | desktop | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-long-worked-example-viewport.png`
- module-09-industry-synthesis-lab | desktop | opening definitions / mental model | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-opening-definitions.png`
- module-09-industry-synthesis-lab | desktop | opening definitions viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-opening-definitions-viewport.png`
- module-09-industry-synthesis-lab | desktop | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-desktop-top-viewport.png`
- module-09-industry-synthesis-lab | mobile | Case 1 negative-price section | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-case-1-negative-price.png`
- module-09-industry-synthesis-lab | mobile | Case 1 negative-price viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-case-1-negative-price-viewport.png`
- module-09-industry-synthesis-lab | mobile | complete long teaching lesson | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-complete-long-lesson-bottleneck-geometry.png`
- module-09-industry-synthesis-lab | mobile | long worked example viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-long-worked-example-viewport.png`
- module-09-industry-synthesis-lab | mobile | opening definitions / mental model | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-opening-definitions.png`
- module-09-industry-synthesis-lab | mobile | opening definitions viewport check | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-opening-definitions-viewport.png`
- module-09-industry-synthesis-lab | mobile | top viewport | `C:\Users\justi\OneDrive\Documents\oil\_workflow\runs\all-modules\screenshots-final\module-09-industry-synthesis-lab-mobile-top-viewport.png`
