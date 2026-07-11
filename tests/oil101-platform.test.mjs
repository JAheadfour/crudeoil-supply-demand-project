import assert from "node:assert/strict";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import vm from "node:vm";
import { test } from "node:test";

const read = (path) => readFileSync(path, "utf8");
const dataPath = "docs/data/oil101-understanding/module-05-inventory-curve.json";
const escapeRegExp = (text) => text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const isSubstantiveString = (value, minLength = 1) =>
  typeof value === "string" && value.trim().length >= minLength;
const termPattern = (label) =>
  /[A-Za-z0-9]/.test(label)
    ? new RegExp(`(^|[^A-Za-z0-9])${escapeRegExp(label)}($|[^A-Za-z0-9])`, "i")
    : new RegExp(escapeRegExp(label), "i");
const numberPattern = /\d[\d,]*(?:\.\d+)?/;
const recognizedUnitPattern =
  /\b(?:bbl|bbls|barrel|barrels|bpd|kbpd|mbpd|tonne|tonnes|ton|tons|gallon|gallons|psi|API|RVP|octane|cetane|hours?|days?|kg|m3|m³|liters?|litres?|L|days?)\b|°API|US\$|\$|%/i;
const calculationUnitPattern = String.raw`(?:[\u4ebf\u4e07]?(?:\u6876|\u7f8e\u5143|bbls?|barrels?|bpd|kbpd|mbpd|tonnes?|tons?|gallons?|psi|API|RVP|octane|cetane|hours?|days?|kg|m3|m\u00c2\u00b3|liters?|litres?|L|%))`;
const calculationOperandPattern = String.raw`\d[\d,]*(?:\.\d+)?(?:\s*${calculationUnitPattern})?`;
const explicitCalculationPattern = new RegExp(
  String.raw`${calculationOperandPattern}\s*[\u00d7\u00f7+\-]\s*${calculationOperandPattern}\s*=\s*\d[\d,]*(?:\.\d+)?\s*${calculationUnitPattern}(?:\s*\/\s*(?:\u6876|bbls?|barrels?|\u7f8e\u5143|bpd|kbpd|mbpd))?`,
  "i"
);
const preDefinitionFields = (lesson) => [
  lesson.reader_question,
  ...Object.values(lesson.scene || {}),
  lesson.plain_answer,
  lesson.explanation,
  ...(lesson.mechanism_chain || []),
  lesson.worked_example?.actor,
  ...(lesson.worked_example?.inputs || []),
  lesson.worked_example?.setup,
  ...(lesson.worked_example?.steps || []),
  lesson.worked_example?.answer,
  lesson.practitioner_lens,
].filter((value) => typeof value === "string" && value.trim());
const loadPlatformSandbox = () => {
  const sandbox = {
    URLSearchParams,
    document: { querySelector: () => null },
    window: { addEventListener() {}, location: { search: "" } },
    navigator: {},
    localStorage: { getItem: () => null, setItem() {} },
    fetch: () => Promise.reject(new Error("Unexpected fetch during platform unit test")),
    console,
  };
  sandbox.globalThis = sandbox;
  vm.runInNewContext(read("docs/assets/platform.js"), sandbox, { filename: "docs/assets/platform.js" });
  return sandbox;
};

test("homepage exposes the thematic learning route and full course shell", () => {
  const html = read("docs/index.html");
  assert.match(html, /原油市场理解平台/);
  assert.match(html, /九步学习路线/);
  assert.match(html, /learn\/module\.html\?module=module-01-barrel-journey/);
  assert.match(html, /产业纵深/);
});

test("sample module meets the understanding content floor", () => {
  const module = JSON.parse(read(dataPath));
  assert.equal(module.variant, "understanding");
  assert.ok(module.main_thread.length >= 200);
  assert.ok(module.lessons.length >= 5);
  assert.ok(module.lessons.every((lesson) => lesson.explanation.length >= 150));
  assert.ok(module.lessons.every((lesson) => lesson.mechanism_chain.length >= 3));
  assert.ok(module.lessons.every((lesson) => lesson.misreading.length >= 15));
  assert.ok(module.lessons.every((lesson) => lesson.boundary.length >= 15));
  assert.ok(module.glossary.length >= 5);
  assert.ok(module.self_checks.length >= 5);
  assert.ok(module.self_checks.every((item) => item.model_answer.length >= 30));
  assert.ok(module.applications.length >= 3);
  assert.ok(module.sources.length >= 3);
  assert.ok(module.source_coverage.length >= 20);
  assert.ok(module.source_coverage.every((item) =>
    typeof item === "string"
      ? item.length >= 20 && item.includes("→")
      : item.source && item.section && item.disposition
  ));
});

test("every referenced figure is local, informative, and attributed", () => {
  const module = JSON.parse(read(dataPath));
  assert.ok(module.figures.length >= 1);
  for (const figure of module.figures) {
    assert.ok(figure.alt.length >= 20);
    assert.ok(figure.reading_guide.length >= 40);
    assert.ok(figure.caption.length >= 30);
    assert.match(figure.reference.url, /^https:\/\//);
    assert.ok(figure.reference.accessed);
    assert.ok(existsSync(`docs/${figure.src.replace(/^\.\.\//, "")}`));
  }
});

test("lesson shell supports progress, self checks, and source references", () => {
  const html = read("docs/learn/inventory-curve.html");
  const js = read("docs/assets/platform.js");
  assert.match(html, /data-module-root/);
  assert.match(js, /oil101Progress/);
  assert.match(js, /data-self-check/);
  assert.match(js, /model_answer/);
  assert.match(js, /reference-note/);
});

test("generic lesson shell loads only a named course module", () => {
  const html = read("docs/learn/module.html");
  const js = read("docs/assets/platform.js");
  assert.match(html, /data-module-root/);
  assert.match(js, /URLSearchParams/);
  assert.match(js, /moduleNamePattern/);
  assert.match(js, /data\/oil101-understanding/);
});

test("generic lesson shell exposes the full learning product", () => {
  const js = read("docs/assets/platform.js");
  assert.match(js, /learning_objectives/);
  assert.match(js, /term_family/);
  assert.match(js, /extreme_detail/);
  assert.match(js, /review_prompts/);
  assert.match(js, /module\.cases\.map/);
  assert.doesNotMatch(js, /完整样课/);
});

test("homepage reflects saved sample progress", () => {
  const html = read("docs/index.html");
  const js = read("docs/assets/home.js");
  assert.match(html, /data-home-progress/);
  assert.match(html, /data-route-list/);
  assert.match(js, /catalog\.json/);
  assert.match(js, /oil101Progress:/);
  assert.match(js, /data-home-progress/);
});

test("offline bundle includes the product shell, lesson data, and figure", () => {
  const manifest = JSON.parse(read("docs/manifest.webmanifest"));
  const sw = read("docs/sw.js");
  const catalog = JSON.parse(read("docs/data/oil101-understanding/catalog.json"));
  assert.equal(manifest.name, "Oil 101 原油市场理解平台");
  assert.match(sw, /assets\/platform\.css/);
  assert.match(sw, /assets\/platform\.js/);
  assert.match(sw, /learn\/inventory-curve\.html/);
  assert.match(sw, /learn\/module\.html/);
  assert.match(sw, /module-05-inventory-curve\.json/);
  assert.match(sw, /catalog\.json/);
  for (const module of catalog.modules) {
    assert.match(sw, new RegExp(`${module.file}\\.json`));
  }
  assert.match(sw, /eia-wti-negative-2020\.svg/);
  assert.match(read("docs/assets/home.js"), /serviceWorker/);
  assert.match(read("docs/assets/platform.js"), /serviceWorker/);
  assert.match(sw, /cache\.put/);
});

test("service worker replaces stale caches and never stores failed module responses", () => {
  const sw = read("docs/sw.js");
  const platform = read("docs/assets/platform.js");
  const moduleHtml = read("docs/learn/module.html");
  const dedicatedHtml = read("docs/learn/inventory-curve.html");
  const dataVersion = platform.match(/MODULE_DATA_VERSION = "([^"]+)"/)?.[1];
  assert.match(sw, /skipWaiting/);
  assert.match(sw, /clients\.claim/);
  assert.match(sw, /response\.ok/);
  assert.match(platform, /MODULE_DATA_VERSION/);
  assert.match(platform, /[?&]v=/);
  assert.match(moduleHtml, new RegExp(`platform\\.js\\?v=${escapeRegExp(dataVersion)}`));
  assert.match(dedicatedHtml, new RegExp(`platform\\.js\\?v=${escapeRegExp(dataVersion)}`));
});

test("teaching lessons render beginner-first sections in the intended order", () => {
  const module = JSON.parse(read("docs/data/oil101-understanding/module-01-barrel-journey.json"));
  const source = read("docs/assets/platform.js");
  const { renderTeachingLesson } = loadPlatformSandbox();
  const lesson = module.lessons.find((item) => item.id === "refinery-transformation");
  const figures = module.figures.filter((figure) => figure.lesson_id === lesson.id);
  const html = renderTeachingLesson(lesson, figures);
  const checkpoints = [
    "这一节要解决什么困惑",
    "先看真实场景",
    "一句话答案",
    "一步步讲机制",
    "用数字走一遍",
    'class="figure-block"',
    "它为什么影响市场",
    "专业语言对照",
    "容易误会什么",
    "这个结论的边界",
    "深入一层",
  ];

  let previousIndex = -1;
  for (const marker of checkpoints) {
    const index = html.indexOf(marker);
    assert.ok(index > previousIndex, `${marker} should appear after the previous teaching block`);
    previousIndex = index;
  }
  assert.match(source, /lesson\.reader_question\s*\?\s*renderTeachingLesson\(lesson,\s*figures\)\s*:\s*renderLesson\(lesson,\s*figures\)/);
  assert.match(html, /class="content-band lesson-section teaching-lesson"/);
});

test("teaching lessons render actor, inputs, calculation, conclusion, and escape source content", () => {
  const { renderTeachingLesson } = loadPlatformSandbox();
  const html = renderTeachingLesson({
    id: "lesson<script>",
    title: "标题<img onerror=1>",
    reader_question: "问题<script>alert(1)</script>",
    scene: {
      setting: "地点<svg>",
      actors: "人物<b>甲</b>",
      action: "动作<i>发生</i>",
    },
    plain_answer: "答案<iframe>",
    explanation: "解释<math>",
    mechanism_chain: ["第一步<u>", "第二步<em>"],
    worked_example: {
      actor: "甲方分析师<img>",
      inputs: ["已知 A<1>", "已知 B&2"],
      setup: "起点<3>",
      steps: ["计算 1<script>", "计算 2<style>"],
      answer: "结论<final>",
    },
    practitioner_lens: "市场意义<lens>",
    terms_in_context: [{
      term: "Stream<script>",
      cn: "物流批次<cn>",
      plain_definition: "定义<def>",
      why_it_matters: "重要性<why>",
    }],
    misreading: "误读<bad>",
    boundary: "边界<limit>",
    deep_dive: [{
      title: "深入标题<deep>",
      explanation: "深入解释<detail>",
    }],
  }, []);

  assert.match(html, /例子里是谁在做决定/);
  assert.match(html, /已知条件/);
  assert.match(html, /怎么计算/);
  assert.match(html, /结论/);
  assert.match(html, /甲方分析师&lt;img&gt;/);
  assert.match(html, /已知 A&lt;1&gt;/);
  assert.match(html, /结论&lt;final&gt;/);
  assert.doesNotMatch(html, /<script>alert\(1\)<\/script>/);
  assert.doesNotMatch(html, /<img onerror=1>/);
});

test("teaching lessons tolerate missing optional arrays without leaking undefined", () => {
  const { renderTeachingLesson } = loadPlatformSandbox();
  const html = renderTeachingLesson({
    id: "optional-arrays",
    title: "数组兼容",
    reader_question: "为什么这里也要能稳住可选字段？",
    scene: {
      setting: "场景说明",
      actors: "现场角色",
      action: "正在发生的动作",
    },
    plain_answer: "因为模块 02-09 还在走旧路径，而新路径必须对空数组温柔一点。",
    explanation: "可选字段为空时，渲染器也应该给出稳定 HTML。",
    mechanism_chain: null,
    worked_example: {
      actor: "测试者",
      inputs: null,
      setup: "已知条件",
      steps: null,
      answer: "仍然能给出结论",
    },
    practitioner_lens: "不要把可选字段当成必填字段。",
    misreading: "空数组不等于页面报错。",
    boundary: "缺少补充块时，核心内容仍可读。",
  }, []);

  assert.equal(typeof html, "string");
  assert.doesNotMatch(html, /undefined|null/);
  assert.match(html, /专业语言对照/);
  assert.match(html, /深入一层/);
});

test("teaching renderer and lesson shells keep cache-busting versions aligned", () => {
  const platform = read("docs/assets/platform.js");
  const sw = read("docs/sw.js");
  const moduleHtml = read("docs/learn/module.html");
  const dedicatedHtml = read("docs/learn/inventory-curve.html");
  const dataVersion = platform.match(/MODULE_DATA_VERSION = "([^"]+)"/)?.[1];
  const moduleScriptVersion = moduleHtml.match(/platform\.js\?v=([0-9-]+)/)?.[1];
  const dedicatedScriptVersion = dedicatedHtml.match(/platform\.js\?v=([0-9-]+)/)?.[1];
  const cacheName = sw.match(/CACHE_NAME = 'oil101-understanding-v(\d+)'/)?.[1];

  assert.equal(dataVersion, "20260711-3");
  assert.equal(moduleScriptVersion, dataVersion);
  assert.equal(dedicatedScriptVersion, dataVersion);
  assert.equal(cacheName, "6");
});

test("catalog links all nine complete and mirrored course modules", () => {
  const catalog = JSON.parse(read("docs/data/oil101-understanding/catalog.json"));
  assert.equal(catalog.modules.length, 9);
  for (const entry of catalog.modules) {
    const published = `docs/data/oil101-understanding/${entry.file}.json`;
    const canonical = `course/data/oil101-understanding/${entry.file}.json`;
    assert.ok(existsSync(published), published);
    assert.ok(existsSync(canonical), canonical);
    assert.equal(read(published), read(canonical), `${entry.file} mirror drift`);

    const module = JSON.parse(read(published));
    assert.equal(module.id, entry.id);
    assert.equal(module.variant, "understanding");
    assert.equal(module.self_checks.length, entry.checks);
    assert.ok(module.lessons.length >= 5);
    assert.ok(module.source_coverage.length >= 1);
    assert.ok(module.sources.length >= 3);
    for (const figure of module.figures || []) {
      assert.ok(existsSync(`docs/${figure.src.replace(/^\.\.\//, "")}`), figure.src);
      assert.match(figure.reference.url, /^https:\/\//);
      assert.ok(figure.reading_guide.length >= 30);
    }
  }
});

test("module 01 only uses newly introduced lesson terms after terms_in_context defines them", () => {
  const module = JSON.parse(read("docs/data/oil101-understanding/module-01-barrel-journey.json"));
  const firstDefinitionLessonByLabel = new Map();

  assert.equal(module.lessons.length, 8);
  module.lessons.forEach((lesson, lessonIndex) => {
    for (const term of lesson.terms_in_context || []) {
      for (const label of [term.term, term.cn]) {
        if (!isSubstantiveString(label) || firstDefinitionLessonByLabel.has(label)) {
          continue;
        }
        firstDefinitionLessonByLabel.set(label, lessonIndex);
      }
    }
  });

  const preDefinitionTextByLesson = module.lessons.map((lesson) =>
    preDefinitionFields(lesson).join(" ")
  );

  for (const lesson of module.lessons) {
    assert.ok(lesson.reader_question.length >= 20, lesson.id);
    assert.ok(lesson.scene.setting.length >= 30, lesson.id);
    assert.ok(lesson.scene.actors.length >= 15, lesson.id);
    assert.ok(lesson.scene.action.length >= 40, lesson.id);
    assert.ok(lesson.plain_answer.length >= 40, lesson.id);
    assert.ok(lesson.mechanism_chain.length >= 3, lesson.id);
    assert.ok(lesson.terms_in_context.length >= 2, lesson.id);
    assert.ok(lesson.terms_in_context.every((term) =>
      term.term && term.cn && term.plain_definition && term.why_it_matters
    ), lesson.id);
    const currentLabels = [...new Set(lesson.terms_in_context.flatMap((term) =>
      [term.term, term.cn].filter((label) => isSubstantiveString(label))
    ))];
    for (const label of currentLabels) {
      const firstDefinitionLessonIndex = firstDefinitionLessonByLabel.get(label);
      for (let lessonIndex = 0; lessonIndex <= firstDefinitionLessonIndex; lessonIndex += 1) {
        assert.doesNotMatch(
          preDefinitionTextByLesson[lessonIndex],
          termPattern(label),
          `${module.lessons[lessonIndex].id}: ${label}`
        );
      }
    }
    const example = lesson.worked_example;
    assert.ok(isSubstantiveString(example.actor, 8), `${lesson.id}: example actor`);
    assert.ok(Array.isArray(example.inputs), `${lesson.id}: example inputs array`);
    assert.ok(
      example.inputs.filter((input) => isSubstantiveString(input, 8)).length >= 2,
      `${lesson.id}: example substantive inputs`
    );
    assert.match(example.setup, numberPattern, `${lesson.id}: setup numeric value`);
    assert.match(example.setup, recognizedUnitPattern, `${lesson.id}: setup recognized unit`);
    assert.ok(example.steps.length >= 2, `${lesson.id}: example steps`);
    assert.ok(example.steps.every((step) => step.length >= 20), `${lesson.id}: step detail`);
    assert.ok(
      example.steps.some((step) => explicitCalculationPattern.test(step)),
      `${lesson.id}: explicit = calculation with numbers and units`
    );
    assert.ok(isSubstantiveString(example.answer, 25), `${lesson.id}: substantive answer`);
    assert.ok(lesson.deep_dive.length >= 1, lesson.id);
  }
});

test("product files contain no unfinished markers", () => {
  const files = [
    "docs/index.html",
    "docs/learn/inventory-curve.html",
    "docs/assets/platform.js",
    "docs/assets/home.js",
    "docs/assets/platform.css",
    dataPath,
  ];
  for (const file of files) {
    assert.doesNotMatch(read(file), /TODO|TBD|missing source|source unclear/i, file);
  }
});

test("published course modules contain readable Chinese rather than mojibake", () => {
  const files = readdirSync("docs/data/oil101-understanding")
    .filter((file) => /^module-\d{2}-.+\.json$/.test(file));
  for (const file of files) {
    const content = read(`docs/data/oil101-understanding/${file}`);
    assert.doesNotMatch(content, /ä¾|åŽ|æ²|çš|è¿|éœ|ï¼|Â|Ã|ðŸ|[\u0080-\u009f]/, file);
  }
});
