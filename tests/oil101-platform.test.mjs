import assert from "node:assert/strict";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { test } from "node:test";

const read = (path) => readFileSync(path, "utf8");
const dataPath = "docs/data/oil101-understanding/module-05-inventory-curve.json";

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
  assert.match(sw, /skipWaiting/);
  assert.match(sw, /clients\.claim/);
  assert.match(sw, /response\.ok/);
  assert.match(platform, /MODULE_DATA_VERSION/);
  assert.match(platform, /[?&]v=/);
  assert.match(moduleHtml, /platform\.js\?v=20260711-2/);
  assert.match(dedicatedHtml, /platform\.js\?v=20260711-2/);
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
