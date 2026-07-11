# Module 01 Teaching Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite Module 01 so a reader who understands economics and finance but knows nothing about the oil industry can independently understand the physical barrel journey and its market consequences.

**Architecture:** Keep the existing JSON-driven course and legacy lesson fields required by the understanding validator. Add a small set of reader-facing teaching fields to each Module 01 lesson, render those fields through a new `renderTeachingLesson()` path, and keep `renderLesson()` as the fallback for Modules 02-09. The canonical JSON remains the source of truth and is copied byte-for-byte to the published mirror.

**Tech Stack:** Static HTML/CSS/JavaScript, JSON course data, Node.js built-in test runner, bundled Python `book-to-platform` validator, Playwright browser smoke tests.

## Global Constraints

- Reader baseline: understands basic economics, finance, supply/demand, inventory, and futures; has no assumed oil-industry knowledge.
- Morgan Downey's current Oil 101 web pages remain the sole primary writing input.
- A term must be explained through its physical object and purpose before its English industry label appears.
- One sentence carries one main judgment; causal chains are split into explicit steps.
- Every lesson connects a physical process to cost, volume, inventory, margin, risk, or price.
- Every lesson contains one concrete numerical walkthrough with units, actors, inputs, calculation, and conclusion.
- Technical details are preserved under `deep_dive`; they do not block the core explanation.
- Existing 87-section source coverage, source anomalies, figures, and references remain traceable.
- Modules 02-09 must continue rendering without data migration.

---

### Task 1: Lock the beginner-readable lesson contract

**Files:**
- Create: `_workflow/module-01-concept-map.md`
- Modify: `tests/oil101-platform.test.mjs`
- Test: `tests/oil101-platform.test.mjs`

**Interfaces:**
- Consumes: existing `module-01-barrel-journey.json`, design spec at `docs/superpowers/specs/2026-07-11-oil101-content-rewrite-design.md`.
- Produces: a concept dependency map and the required reader-facing lesson fields `reader_question`, `scene`, `plain_answer`, `terms_in_context`, and `deep_dive`.

- [ ] **Step 1: Create the concept dependency map from the original sources**

Write `_workflow/module-01-concept-map.md` with this exact eight-lesson order:

```markdown
# Module 01 Concept Map

1. Oil in rock pores: source rock -> migration -> reservoir -> trap -> pressure.
2. Reservoir to surface: wellbore, pressure drawdown, recovery factor, water/gas production.
3. First surface treatment: oil/water/gas separation, dehydration, stabilization, measurement.
4. From well streams to a commercial grade: gathering, commingling, blend, custody transfer.
5. Why crude quality changes value: density/API, sulfur, TAN, metals, salt, water, yield.
6. What a refinery actually does: separation, conversion, treatment, blending, product yield.
7. How the barrel moves: pipeline, tanker, rail, truck, storage, batch and capacity constraints.
8. When a barrel becomes economically usable: grade + location + timing + compatible facility.
```

For each lesson, list prerequisites, terms first introduced, original Oil 101 H2 blocks, one numerical example, and the market question the lesson answers. Record source anomalies separately; do not resolve them from the old course prose.

- [ ] **Step 2: Write a failing schema and readability test**

Add this test to `tests/oil101-platform.test.mjs`:

```js
test("module 01 teaches oil concepts before using industry shorthand", () => {
  const module = JSON.parse(read("docs/data/oil101-understanding/module-01-barrel-journey.json"));
  const unexplainedShorthand = /\b(stream|blend|grade|assay|custody|gathering|PONA)\b/i;

  assert.equal(module.lessons.length, 8);
  for (const lesson of module.lessons) {
    assert.ok(lesson.reader_question.length >= 20, lesson.id);
    assert.ok(lesson.scene.setting.length >= 30, lesson.id);
    assert.ok(lesson.scene.actors.length >= 15, lesson.id);
    assert.ok(lesson.scene.action.length >= 40, lesson.id);
    assert.ok(lesson.plain_answer.length >= 40, lesson.id);
    assert.doesNotMatch(
      `${lesson.reader_question} ${lesson.scene.setting} ${lesson.scene.action} ${lesson.plain_answer}`,
      unexplainedShorthand,
      lesson.id
    );
    assert.ok(lesson.mechanism_chain.length >= 3, lesson.id);
    assert.match(JSON.stringify(lesson.worked_example), /\d/, lesson.id);
    assert.ok(lesson.terms_in_context.length >= 2, lesson.id);
    assert.ok(lesson.terms_in_context.every((term) =>
      term.term && term.cn && term.plain_definition && term.why_it_matters
    ), lesson.id);
    assert.ok(lesson.deep_dive.length >= 1, lesson.id);
  }
});
```

- [ ] **Step 3: Run the test and verify the intended failure**

Run:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
```

Expected: the new Module 01 test fails because `reader_question` is missing; the existing tests continue to pass.

- [ ] **Step 4: Commit the contract and concept map**

```powershell
git add _workflow/module-01-concept-map.md tests/oil101-platform.test.mjs
git commit -m "Define beginner-readable Module 01 contract"
```

---

### Task 2: Rewrite Module 01 from the original web edition

**Files:**
- Modify: `course/data/oil101-understanding/module-01-barrel-journey.json`
- Modify: `docs/data/oil101-understanding/module-01-barrel-journey.json`
- Reference: `_workflow/module-01-concept-map.md`
- Reference: `docs/superpowers/specs/2026-07-11-oil101-content-rewrite-design.md`
- Test: `tests/oil101-platform.test.mjs`

**Interfaces:**
- Consumes: the Task 1 field contract and the current author pages for crude assay, components, chemistry, industry overview, exploration/production, refining, finished products, and transporting oil.
- Produces: eight rewritten lessons that retain the validator fields and add the reader-facing teaching fields.

- [ ] **Step 1: Re-read and inventory the original source pages**

Read these pages directly and record every used H2 in the concept map:

```text
https://oil101.morgandowney.com/chapters/crude-oil-assay
https://oil101.morgandowney.com/chapters/components
https://oil101.morgandowney.com/chapters/chemistry
https://oil101.morgandowney.com/chapters/industry-overview
https://oil101.morgandowney.com/chapters/exploration-production
https://oil101.morgandowney.com/chapters/refining
https://oil101.morgandowney.com/chapters/finished-products
https://oil101.morgandowney.com/chapters/transporting-oil
```

Do not use `outputs/oil101-KB`, old chapter HTML, or the current lesson prose as factual input. The current JSON may be read only to preserve IDs, figures, references, source coverage, and anomaly records.

- [ ] **Step 2: Rewrite the module-level introduction**

Replace `deck`, `reading_intent`, `opening_question`, `quick_answer`, `learning_objectives`, `main_thread`, and `mental_model` with natural Chinese that introduces no unexplained oil-industry shorthand. The introduction must establish this baseline before Lesson 1:

```text
原油不是从地下抽出来就能卖给汽车。它先要从岩石孔隙流进井筒，到地面后分掉水和天然气，再被测量、混合、运输和加工。每一步都会改变这一桶油能否被使用、由谁承担风险，以及它值多少钱。
```

Keep `quick_answer` to three items rather than five; each item covers one stage of the journey and contains no more than one new technical label.

- [ ] **Step 3: Rewrite all eight lessons using the new field contract**

Each lesson must follow this JSON shape while retaining `concept`, `explanation`, `mechanism_chain`, `worked_example`, `practitioner_lens`, `misreading`, and `boundary` for the existing validator:

```json
{
  "id": "reservoir-reality",
  "title": "地下没有一座装满原油的湖",
  "reader_question": "钻头打到地下以后，为什么不能像插进水桶一样把原油全部抽出来？",
  "scene": {
    "setting": "把视线放到地下数千米的砂岩层。岩石看起来坚硬，内部却有大量肉眼看不见的微小孔隙。",
    "actors": "储集岩、孔隙中的油水气、井筒和负责控制产量的油田工程师。",
    "action": "地下压力推动油穿过彼此连通的孔隙流向低压井筒；工程师调节压差，避免水或天然气过早冲到井边。"
  },
  "plain_answer": "油藏更像一块吸满油的石头，而不是地下油湖。能采出多少取决于孔隙是否连通、地下压力是否足够，以及生产速度是否破坏了原来的流动路径。",
  "concept": {
    "en": "Reservoir rock and recovery factor",
    "cn": "储集岩与采收率",
    "definition": "储集岩用孔隙容纳油，并通过连通通道让油流动；采收率表示地下原始石油中最终能够采出的比例。"
  },
  "explanation": "用短段落解释来源、压力、孔隙连通和采收率，不在第一段堆叠成藏系统术语。",
  "mechanism_chain": [
    "地下压力高于井筒压力，油开始向井筒移动",
    "生产使井边压力下降，越来越远的流体被吸引过来",
    "压差过大时，水或天然气可能沿高渗通道提前突破",
    "部分原油被绕过并留在岩石中，最终可采量下降"
  ],
  "worked_example": {
    "setup": "一个油藏含有 10 亿桶地下原始石油。方案 A 的采收率为 35%，方案 B 因过快生产降到 28%。",
    "steps": [
      "方案 A 可采量 = 10 亿桶 × 35% = 3.5 亿桶。",
      "方案 B 可采量 = 10 亿桶 × 28% = 2.8 亿桶。",
      "为了更高的短期日产量，油田可能永久少采 7000 万桶。"
    ],
    "answer": "生产速度既影响今天的供应，也可能改变油田一生能够提供的总供应。"
  },
  "practitioner_lens": "看到企业宣布提高井口产量时，还要检查含水率、压力、递减率和预计采收率。",
  "terms_in_context": [
    {
      "term": "Reservoir rock",
      "cn": "储集岩",
      "plain_definition": "能够在孔隙中容纳油，并允许油在内部流动的岩石。",
      "why_it_matters": "它决定地下的油是否能流到井筒，而不只决定地下有没有油。"
    },
    {
      "term": "Recovery factor",
      "cn": "采收率",
      "plain_definition": "地下原始石油中最终能够被采到地面的比例。",
      "why_it_matters": "资源量相同的两个油田，市场供应能力可能相差很大。"
    }
  ],
  "misreading": "发现 10 亿桶地下石油，不等于市场未来会得到 10 亿桶供应。",
  "boundary": "采收率随岩性、流体性质、开发方式和经济条件变化，教学示例不是所有油田的固定比例。",
  "deep_dive": [
    {
      "title": "源岩、运移、圈闭和盖层分别做什么",
      "explanation": "在核心直觉建立后，再补充完整成藏系统及其适用边界。"
    }
  ]
}
```

Apply the same level of clarity to all eight lessons. In each lesson, define the physical object before the English term, and ensure the numerical example changes the reader's economic interpretation rather than merely decorating the prose.

- [ ] **Step 4: Preserve source and figure traceability**

Retain the existing figure files and references. Rewrite each `reading_guide` so it tells a novice exactly where to look first, what relationship the figure demonstrates, and what the figure does not prove. Preserve all 87 H2 mappings; update lesson targets when IDs change.

- [ ] **Step 5: Copy canonical data to the published mirror**

Run:

```powershell
Copy-Item -LiteralPath 'course/data/oil101-understanding/module-01-barrel-journey.json' -Destination 'docs/data/oil101-understanding/module-01-barrel-journey.json' -Force
```

- [ ] **Step 6: Run the readability contract and understanding validator**

Run:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json,sys; sys.path.insert(0,r'C:\Users\justi\.codex\skills\book-to-platform\scripts'); from build_course_app import validate_module; m=json.load(open(r'course/data/oil101-understanding/module-01-barrel-journey.json',encoding='utf-8')); e=validate_module(m,'understanding'); print(chr(10).join(e) if e else 'FLOORS OK')"
```

Expected: all Node tests pass and the validator prints `FLOORS OK`.

- [ ] **Step 7: Commit the rewritten canonical content**

```powershell
git add course/data/oil101-understanding/module-01-barrel-journey.json docs/data/oil101-understanding/module-01-barrel-journey.json
git commit -m "Rewrite Module 01 for oil-industry beginners"
```

---

### Task 3: Render the teaching sequence without breaking other modules

**Files:**
- Modify: `docs/assets/platform.js`
- Modify: `docs/assets/platform.css`
- Modify: `tests/oil101-platform.test.mjs`
- Modify: `tests/ui-smoke.mjs`

**Interfaces:**
- Consumes: optional lesson fields `reader_question`, `scene`, `plain_answer`, `terms_in_context`, and `deep_dive` from Task 2.
- Produces: `renderTeachingLesson(lesson, figures)` and keeps `renderLesson(lesson, figures)` unchanged as the fallback for lessons without `reader_question`.

- [ ] **Step 1: Add failing renderer contract tests**

Extend `tests/oil101-platform.test.mjs`:

```js
test("teaching lessons render scene, plain answer, terms, and deep dive in order", () => {
  const js = read("docs/assets/platform.js");
  assert.match(js, /function renderTeachingLesson/);
  assert.match(js, /这一节要解决什么困惑/);
  assert.match(js, /先看真实场景/);
  assert.match(js, /一句话答案/);
  assert.match(js, /它为什么影响市场/);
  assert.match(js, /专业语言对照/);
  assert.match(js, /深入一层/);
  assert.match(js, /lesson\.reader_question\s*\?\s*renderTeachingLesson/);
});
```

Run the Node test command and expect failure because `renderTeachingLesson` does not exist.

- [ ] **Step 2: Implement `renderTeachingLesson()` with progressive terminology**

Add a renderer beside the existing `renderLesson()`:

```js
function renderTeachingLesson(lesson, figures) {
  const example = lesson.worked_example;
  const terms = lesson.terms_in_context.map((term) => `
    <article class="term-in-context">
      <h4>${escapeHtml(term.cn)} <span>${escapeHtml(term.term)}</span></h4>
      <p>${escapeHtml(term.plain_definition)}</p>
      <p><strong>为什么重要：</strong>${escapeHtml(term.why_it_matters)}</p>
    </article>`).join("");
  const deepDive = lesson.deep_dive.map((item) => `
    <details class="deep-dive">
      <summary>${escapeHtml(item.title)}</summary>
      <p>${escapeHtml(item.explanation)}</p>
    </details>`).join("");

  return `
    <section class="content-band lesson-section teaching-lesson" id="${escapeHtml(lesson.id)}">
      <p class="eyebrow">这一节要解决什么困惑</p>
      <h2>${escapeHtml(lesson.title)}</h2>
      <p class="reader-question">${escapeHtml(lesson.reader_question)}</p>
      <h3>先看真实场景</h3>
      <div class="scene-block">
        <p>${escapeHtml(lesson.scene.setting)}</p>
        <p><strong>现场有哪些人和东西：</strong>${escapeHtml(lesson.scene.actors)}</p>
        <p><strong>他们正在做什么：</strong>${escapeHtml(lesson.scene.action)}</p>
      </div>
      <h3>一句话答案</h3>
      <p class="plain-answer">${escapeHtml(lesson.plain_answer)}</p>
      <h3>一步步讲机制</h3>
      <p>${escapeHtml(lesson.explanation)}</p>
      ${list(lesson.mechanism_chain, "mechanism-chain")}
      <div class="example-block">
        <h3>用数字走一遍</h3>
        <p>${escapeHtml(example.setup)}</p>
        ${list(example.steps, "case-flow")}
        <p><strong>结论：</strong>${escapeHtml(example.answer)}</p>
      </div>
      ${figures.map(renderFigure).join("")}
      <h3>它为什么影响市场</h3>
      <p>${escapeHtml(lesson.practitioner_lens)}</p>
      <h3>专业语言对照</h3>
      <div class="terms-in-context">${terms}</div>
      <div class="warning-grid">
        <div class="warning misread"><h4>容易误会什么</h4><p>${escapeHtml(lesson.misreading)}</p></div>
        <div class="warning boundary"><h4>这个结论的边界</h4><p>${escapeHtml(lesson.boundary)}</p></div>
      </div>
      <h3>深入一层</h3>
      ${deepDive}
    </section>`;
}
```

Change lesson selection to:

```js
const lessonHtml = module.lessons.map((lesson) => {
  const figures = asArray(module.figures).filter((figure) => figure.lesson_id === lesson.id);
  return lesson.reader_question ? renderTeachingLesson(lesson, figures) : renderLesson(lesson, figures);
}).join("");
```

- [ ] **Step 3: Add restrained styles for the new semantic blocks**

Add to `docs/assets/platform.css`:

```css
.reader-question { max-width: 680px; font-size: 21px; font-weight: 700; }
.scene-block { border-left: 3px solid var(--blue); padding: 14px 18px; background: #f6f9fb; }
.plain-answer { max-width: 700px; font-size: 19px; font-weight: 650; }
.terms-in-context { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.term-in-context { border-top: 2px solid var(--green); padding-top: 10px; }
.term-in-context h4 { margin: 0 0 6px; }
.term-in-context h4 span { color: var(--muted); font-weight: 500; }
.deep-dive { border-top: 1px solid var(--line); padding: 12px 0; }
.deep-dive summary { cursor: pointer; font-weight: 700; }
@media (max-width: 840px) { .terms-in-context { grid-template-columns: 1fr; } }
```

Do not create new card layers or decorative surfaces. These styles indicate semantic changes without turning the page into a dashboard.

- [ ] **Step 4: Extend browser smoke tests for actual teaching copy**

In `tests/ui-smoke.mjs`, after opening Module 01, assert:

```js
assert.equal(await desktop.locator(".teaching-lesson").count(), 8);
assert.ok(await desktop.getByText("先看真实场景", { exact: true }).count() >= 1);
assert.ok(await desktop.getByText("用数字走一遍", { exact: true }).count() >= 1);
assert.ok(await desktop.getByText("专业语言对照", { exact: true }).count() >= 1);
assert.ok(await desktop.locator("details.deep-dive").count() >= 8);
```

Retain the loop that opens all nine modules so the fallback renderer remains covered.

- [ ] **Step 5: Run unit, syntax, and browser tests**

Run:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --check docs/assets/platform.js
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' --test tests/oil101-platform.test.mjs
$env:NODE_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\.pnpm\node_modules'
$env:PLAYWRIGHT_PATH='C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\node_modules\playwright'
$env:PLAYWRIGHT_BROWSER_PATH='C:\Program Files\Google\Chrome\Application\chrome.exe'
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe' tests/ui-smoke.mjs
```

Expected: syntax check exits 0, all Node tests pass, and the browser test reports `UI SMOKE OK: 9 modules, desktop + mobile`.

- [ ] **Step 6: Commit the compatible renderer**

```powershell
git add docs/assets/platform.js docs/assets/platform.css tests/oil101-platform.test.mjs tests/ui-smoke.mjs
git commit -m "Render beginner-first teaching lessons"
```

---

### Task 4: Independent content review and sample handoff

**Files:**
- Modify if defects are found: `course/data/oil101-understanding/module-01-barrel-journey.json`
- Modify if defects are found: `docs/data/oil101-understanding/module-01-barrel-journey.json`
- Modify if defects are found: `docs/assets/platform.js`
- Modify if defects are found: `docs/assets/platform.css`
- Test: `tests/oil101-platform.test.mjs`
- Test: `tests/ui-smoke.mjs`

**Interfaces:**
- Consumes: rewritten Module 01 and the compatible renderer.
- Produces: one user-reviewable sample whose source coverage, readability contract, validator, desktop rendering, and mobile rendering all pass.

- [ ] **Step 1: Run an independent jargon and dependency audit**

Review each lesson without relying on the writer's intent. Record a defect whenever:

- a term appears before its physical object is explained;
- a sentence carries more than one unexplained causal jump;
- a numerical example lacks units or does not alter the economic conclusion;
- the market link assumes knowledge of WTI, Cushing, refining equipment, or contracts;
- a deep-dive fact is necessary to understand the core answer, meaning it is in the wrong layer.

Fix every recorded defect in the canonical JSON, then copy the canonical file to the published mirror again.

- [ ] **Step 2: Verify source coverage and mirror identity**

Run a Python check that counts 87 mapped H2 blocks across string and grouped coverage formats, confirms canonical and mirror bytes are identical, and prints the result:

```powershell
& 'C:\Users\justi\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -c "import json, pathlib; p=pathlib.Path(r'course/data/oil101-understanding/module-01-barrel-journey.json'); q=pathlib.Path(r'docs/data/oil101-understanding/module-01-barrel-journey.json'); m=json.loads(p.read_text(encoding='utf-8')); cov=sum(len(x.get('section_mappings',[])) if isinstance(x,dict) and isinstance(x.get('section_mappings'),list) else 1 for x in m['source_coverage']); print({'coverage':cov,'mirror':p.read_bytes()==q.read_bytes()}); assert cov==87; assert p.read_bytes()==q.read_bytes()"
```

Expected: `{'coverage': 87, 'mirror': True}`.

- [ ] **Step 3: Capture focused desktop and mobile screenshots**

Capture the Module 01 introduction and one complete teaching lesson at 1440×1000 and 390×844. Inspect the images for clipped text, unreadably dense paragraphs, repeated labels, jargon appearing before definitions, and any blank figure.

- [ ] **Step 4: Run the complete verification suite**

Repeat the Node tests, understanding validator, syntax check, and nine-module browser smoke test from Tasks 2 and 3. Do not declare the sample ready unless every command exits 0.

- [ ] **Step 5: Commit review fixes and publish the sample**

```powershell
git add course/data/oil101-understanding/module-01-barrel-journey.json docs/data/oil101-understanding/module-01-barrel-journey.json docs/assets/platform.js docs/assets/platform.css tests/oil101-platform.test.mjs tests/ui-smoke.mjs
git commit -m "Polish beginner-readable Module 01 sample"
git push origin main
```

- [ ] **Step 6: Hand Module 01 to the user for actual reading approval**

Provide the direct local and GitHub Pages Module 01 URLs. Ask the user to identify the first sentence or concept that still feels unclear. Do not begin Modules 02-09 until the user confirms that Module 01's teaching style is understandable enough to become the shared standard.

