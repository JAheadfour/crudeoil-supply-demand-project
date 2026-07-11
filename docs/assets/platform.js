const root = document.querySelector("[data-module-root]");
const moduleNamePattern = /^module-\d{2}-[a-z0-9-]+$/;
const MODULE_DATA_VERSION = "20260711-3";

function resolveModuleUrl() {
  if (!root) return null;
  if (root.dataset.moduleUrl) return `${root.dataset.moduleUrl}?v=${MODULE_DATA_VERSION}`;
  const moduleName = new URLSearchParams(window.location.search).get("module");
  return moduleNamePattern.test(moduleName || "")
    ? `../data/oil101-understanding/${moduleName}.json?v=${MODULE_DATA_VERSION}`
    : null;
}

const escapeHtml = (value = "") => String(value)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;")
  .replaceAll("'", "&#039;");

const asArray = (value) => Array.isArray(value) ? value : [];
const list = (items, className = "") => `<ol class="${className}">${asArray(items).map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ol>`;
const bullets = (items, className = "") => `<ul class="${className}">${asArray(items).map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>`;

function loadProgress(moduleId) {
  try {
    return JSON.parse(localStorage.getItem(`oil101Progress:${moduleId}`)) || { checks: {} };
  } catch {
    return { checks: {} };
  }
}

function saveProgress(moduleId, state) {
  localStorage.setItem(`oil101Progress:${moduleId}`, JSON.stringify(state));
}

function renderFigure(figure) {
  return `
    <figure class="figure-block">
      <p class="figure-guide">怎么看这张图：${escapeHtml(figure.reading_guide)}</p>
      <img src="../${escapeHtml(figure.src)}" alt="${escapeHtml(figure.alt)}" loading="lazy">
      <figcaption class="figure-caption">${escapeHtml(figure.caption)}</figcaption>
      <div class="reference-note">Reference: <a href="${escapeHtml(figure.reference.url)}">${escapeHtml(figure.reference.label)}</a>，访问日期 ${escapeHtml(figure.reference.accessed)}</div>
    </figure>`;
}

function renderLesson(lesson, figures) {
  const example = lesson.worked_example;
  return `
    <section class="content-band lesson-section" id="${escapeHtml(lesson.id)}">
      <p class="eyebrow">核心机制</p>
      <h2>${escapeHtml(lesson.title)}</h2>
      <div class="concept-line">
        <span class="concept-name">${escapeHtml(lesson.concept.en)} · ${escapeHtml(lesson.concept.cn)}</span>
        ${escapeHtml(lesson.concept.definition)}
      </div>
      <p>${escapeHtml(lesson.explanation)}</p>
      <h3>因果链</h3>
      ${list(lesson.mechanism_chain, "mechanism-chain")}
      <div class="example-block">
        <h4>现实推演</h4>
        <p>${escapeHtml(example.setup)}</p>
        ${list(example.steps, "case-flow")}
        <p><strong>这说明：</strong>${escapeHtml(example.answer)}</p>
      </div>
      ${figures.map(renderFigure).join("")}
      <p><strong>分析者视角：</strong>${escapeHtml(lesson.practitioner_lens)}</p>
      <div class="warning-grid">
        <div class="warning misread"><h4>常见误读</h4><p>${escapeHtml(lesson.misreading)}</p></div>
        <div class="warning boundary"><h4>适用边界</h4><p>${escapeHtml(lesson.boundary)}</p></div>
      </div>
    </section>`;
}

function renderTeachingLesson(lesson, figures) {
  const scene = lesson.scene || {};
  const example = lesson.worked_example || {};
  const terms = asArray(lesson.terms_in_context).map((term) => `
    <article class="term-in-context">
      <h4>${escapeHtml(term.cn)} <span>${escapeHtml(term.term)}</span></h4>
      <p>${escapeHtml(term.plain_definition)}</p>
      <p><strong>为什么重要：</strong>${escapeHtml(term.why_it_matters)}</p>
    </article>`).join("");
  const deepDive = asArray(lesson.deep_dive).map((item) => `
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
        <p>${escapeHtml(scene.setting)}</p>
        <p><strong>现场是谁在参与：</strong>${escapeHtml(scene.actors)}</p>
        <p><strong>他们正在做什么：</strong>${escapeHtml(scene.action)}</p>
      </div>
      <h3>一句话答案</h3>
      <p class="plain-answer">${escapeHtml(lesson.plain_answer)}</p>
      <h3>一步步讲机制</h3>
      <p>${escapeHtml(lesson.explanation)}</p>
      ${list(lesson.mechanism_chain, "mechanism-chain")}
      <div class="example-block">
        <h3>用数字走一遍</h3>
        <p><strong>例子里是谁在做决定：</strong>${escapeHtml(example.actor)}</p>
        <p><strong>题目设定：</strong>${escapeHtml(example.setup)}</p>
        <div class="example-subsection">
          <p class="example-label"><strong>已知条件</strong></p>
          ${bullets(example.inputs, "example-inputs")}
        </div>
        <div class="example-subsection">
          <p class="example-label"><strong>怎么计算</strong></p>
          ${list(example.steps, "case-flow")}
        </div>
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

function renderTable(table) {
  return `
    <h3>${escapeHtml(table.title)}</h3>
    <table class="data-table">
      <thead><tr>${table.headers.map((cell) => `<th>${escapeHtml(cell)}</th>`).join("")}</tr></thead>
      <tbody>${table.rows.map((row) => `<tr>${row.map((cell) => `<td>${escapeHtml(cell)}</td>`).join("")}</tr>`).join("")}</tbody>
    </table>`;
}

function renderMentalModel(module) {
  const detail = module.mental_model_detail || {};
  const labels = {
    market_translation: "市场含义",
    decision_rule: "判断顺序",
    exposure_vector: "敞口向量",
    operating_translation: "经营含义",
  };
  const details = Object.entries(detail)
    .filter(([key, value]) => key !== "equation" && value)
    .map(([key, value]) => `<p><strong>${escapeHtml(labels[key] || key.replaceAll("_", " "))}：</strong>${escapeHtml(value)}</p>`)
    .join("");
  return `
    <div class="model-box">
      ${detail.equation ? `<div class="model-equation">${escapeHtml(detail.equation)}</div>` : ""}
      <p>${escapeHtml(module.mental_model)}</p>
      ${details}
    </div>`;
}

function renderCase(item, index) {
  const modelAnswer = Array.isArray(item.model_answer)
    ? list(item.model_answer, "answer-list")
    : item.model_answer ? `<p>${escapeHtml(item.model_answer)}</p>` : "";
  return `
    <section class="case-study">
      <p class="eyebrow">案例 ${index + 1}</p>
      <h3>${escapeHtml(item.title)}</h3>
      ${item.scenario ? `<p><strong>情境：</strong>${escapeHtml(item.scenario)}</p>` : ""}
      ${item.background ? `<p><strong>背景：</strong>${escapeHtml(item.background)}</p>` : ""}
      ${item.shock ? `<p><strong>关键冲击：</strong>${escapeHtml(item.shock)}</p>` : ""}
      ${asArray(item.transmission).length ? list(item.transmission, "mechanism-chain") : ""}
      ${item.market_result ? `<p><strong>市场结果：</strong>${escapeHtml(item.market_result)}</p>` : ""}
      ${item.lesson ? `<p><strong>真正的教训：</strong>${escapeHtml(item.lesson)}</p>` : ""}
      ${modelAnswer}
    </section>`;
}

function renderTermFamily(termFamily) {
  if (!termFamily) return "";
  const branches = asArray(termFamily.branches).map((branch) => `
    <li><strong>${escapeHtml(branch.name)}</strong>：${asArray(branch.children).map(escapeHtml).join(" · ")}</li>`).join("");
  return `
    <section class="content-band">
      <h2>术语之间怎样连接</h2>
      ${termFamily.root ? `<p><strong>根概念：</strong>${escapeHtml(termFamily.root)}</p>` : ""}
      ${termFamily.tree ? `<div class="model-box">${escapeHtml(termFamily.tree)}</div>` : ""}
      ${termFamily.analogy ? `<p>${escapeHtml(termFamily.analogy)}</p>` : ""}
      ${branches ? `<ul class="answer-list">${branches}</ul>` : ""}
    </section>`;
}

function renderExtremeDetails(items) {
  if (!asArray(items).length) return "";
  const labels = {
    why_it_matters: "为什么重要",
    micro_example: "微型例子",
    misreading: "容易误读",
    takeaway: "带走什么",
  };
  return `
    <section class="content-band">
      <p class="eyebrow">EXTREME DETAIL</p>
      <h2>把容易被略过的细节讲透</h2>
      <div class="detail-list">${items.map((item) => {
        const title = item.mechanism || item.title || item.name || "细节机制";
        const body = Object.entries(item)
          .filter(([key, value]) => !["mechanism", "title", "name"].includes(key) && value)
          .map(([key, value]) => `<p><strong>${escapeHtml(labels[key] || key.replaceAll("_", " "))}：</strong>${escapeHtml(Array.isArray(value) ? value.join("；") : value)}</p>`)
          .join("");
        return `<article class="detail-item"><h3>${escapeHtml(title)}</h3>${body}</article>`;
      }).join("")}</div>
    </section>`;
}

function renderFormulas(formulas) {
  if (!asArray(formulas).length) return "";
  return `
    <section class="content-band">
      <h2>需要会读的公式</h2>
      <div class="detail-list">${formulas.map((item) => `<article class="detail-item">
        <h3>${escapeHtml(item.name || item.title)}</h3>
        <div class="model-equation">${escapeHtml(item.formula || item.equation)}</div>
        ${item.interpretation ? `<p>${escapeHtml(item.interpretation)}</p>` : ""}
        ${item.use ? `<p><strong>用途：</strong>${escapeHtml(item.use)}</p>` : ""}
      </article>`).join("")}</div>
    </section>`;
}

function renderModule(module) {
  const lessonLinks = module.lessons.map((lesson) => `<a href="#${escapeHtml(lesson.id)}">${escapeHtml(lesson.title)}</a>`).join("");
  const lessonHtml = module.lessons.map((lesson) => {
    const figures = asArray(module.figures).filter((figure) => figure.lesson_id === lesson.id);
    return lesson.reader_question ? renderTeachingLesson(lesson, figures) : renderLesson(lesson, figures);
  }).join("");
  const checks = module.self_checks.map((item, index) => `
    <div class="check-item" data-self-check="${index}">
      <p><strong>${index + 1}.</strong> ${escapeHtml(item.prompt)}</p>
      <div class="check-actions">
        <button class="icon-button" type="button" data-check-reveal="${index}">查看要点</button>
        <button class="status-button" type="button" data-check-status="review" data-check-index="${index}">待复习</button>
        <button class="status-button" type="button" data-check-status="mastered" data-check-index="${index}">已掌握</button>
      </div>
      <div class="check-answer" data-check-answer="${index}" hidden>${escapeHtml(item.model_answer)}</div>
    </div>`).join("");

  root.innerHTML = `
    <div class="course-layout">
      <aside class="course-rail">
        <p class="rail-title">本模块</p>
        <nav>
          <a href="#overview">先建立模型</a>
          ${lessonLinks}
          <a href="#case">综合案例</a>
          <a href="#checks">理解自检</a>
          <a href="#glossary">术语表</a>
          <a href="#sources">来源</a>
        </nav>
      </aside>
      <article class="course-main">
        <header class="lesson-hero" id="overview">
          <p class="eyebrow">模块 ${escapeHtml(module.reading)} · 深度课程</p>
          <h1>${escapeHtml(module.title)}</h1>
          <p class="lesson-deck">${escapeHtml(module.deck)}</p>
          <div class="lesson-meta"><span>理解版</span><span>${module.lessons.length} 个机制单元</span><span>${module.self_checks.length} 个自检</span></div>
          <div class="course-progress">
            <div class="progress-track"><div class="progress-fill" data-progress-fill></div></div>
            <p class="microcopy" data-progress-label>尚未完成理解自检</p>
          </div>
        </header>
        <section class="content-band">
          <h2>先用一个问题进入</h2>
          <p class="opening-question">${escapeHtml(module.opening_question)}</p>
          <h3>先给结论</h3>
          <ul class="answer-list">${module.quick_answer.map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>
          <h3>学完你应该能做到</h3>
          <ul class="answer-list">${asArray(module.learning_objectives).map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>
        </section>
        <section class="content-band">
          <h2>核心心智模型</h2>
          ${renderMentalModel(module)}
          <h3>整条主线</h3>
          <p>${escapeHtml(module.main_thread)}</p>
        </section>
        ${renderFormulas(module.formulas)}
        ${lessonHtml}
        <section class="content-band" id="case">
          <p class="eyebrow">综合案例</p>
          <h2>把机制放进真实世界</h2>
          ${module.cases.map(renderCase).join("")}
          ${asArray(module.comparison_tables).map(renderTable).join("")}
        </section>
        ${renderExtremeDetails(module.extreme_detail)}
        <section class="content-band">
          <h2>压缩成五句话</h2>
          <ul class="answer-list">${module.core_model.core_points.map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>
          <div class="model-box"><strong>${escapeHtml(module.core_model.one_liner)}</strong></div>
        </section>
        <section class="content-band" id="checks">
          <p class="eyebrow">不是考试</p>
          <h2>合上内容，你能解释吗？</h2>
          <div class="checks">${checks}</div>
        </section>
        <section class="content-band">
          <h2>什么时候调用这套知识</h2>
          <ul class="application-list">${module.applications.map((item) => `<li><strong>${escapeHtml(item.situation)}</strong><br>${escapeHtml(item.action)}</li>`).join("")}</ul>
        </section>
        ${renderTermFamily(module.term_family)}
        <section class="content-band" id="glossary">
          <h2>术语表</h2>
          <div class="glossary-grid">${module.glossary.map((item) => `<div class="glossary-entry"><h3>${escapeHtml(item.term)} · ${escapeHtml(item.cn)}</h3><p>${escapeHtml(item.definition)}</p><p><strong>例：</strong>${escapeHtml(item.example)}</p><p><strong>别混淆：</strong>${escapeHtml(item.confusion)}</p></div>`).join("")}</div>
        </section>
        <section class="content-band">
          <h2>之后怎样复习</h2>
          ${list(module.review_prompts, "answer-list")}
        </section>
        <section class="content-band" id="sources">
          <h2>来源与追溯</h2>
          <ul class="source-list">${module.sources.map((source) => `<li><a href="${escapeHtml(source.url)}">${escapeHtml(source.label)}</a><br><span class="microcopy">${escapeHtml(source.coverage)}</span></li>`).join("")}</ul>
        </section>
      </article>
    </div>`;

  const state = loadProgress(module.id);
  const updateProgress = () => {
    const mastered = Object.values(state.checks).filter((value) => value === "mastered").length;
    const pct = Math.round((mastered / module.self_checks.length) * 100);
    document.querySelector("[data-progress-fill]").style.width = `${pct}%`;
    document.querySelector("[data-progress-label]").textContent = mastered ? `已掌握 ${mastered}/${module.self_checks.length} 个理解检查` : "尚未完成理解自检";
    document.querySelectorAll("[data-check-status]").forEach((button) => {
      button.classList.toggle("active", state.checks[button.dataset.checkIndex] === button.dataset.checkStatus);
    });
  };

  root.addEventListener("click", (event) => {
    const reveal = event.target.closest("[data-check-reveal]");
    if (reveal) {
      const answer = root.querySelector(`[data-check-answer="${reveal.dataset.checkReveal}"]`);
      answer.hidden = !answer.hidden;
      reveal.textContent = answer.hidden ? "查看要点" : "收起要点";
    }
    const status = event.target.closest("[data-check-status]");
    if (status) {
      state.checks[status.dataset.checkIndex] = status.dataset.checkStatus;
      saveProgress(module.id, state);
      updateProgress();
    }
  });
  updateProgress();
}

if (root) {
  const moduleUrl = resolveModuleUrl();
  if (!moduleUrl) {
    root.innerHTML = '<div class="error-state">课程地址无效，请从学习路线重新进入。</div>';
  } else fetch(moduleUrl)
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then(renderModule)
    .catch((error) => {
      root.innerHTML = `<div class="error-state">课程数据加载失败：${escapeHtml(error.message)}</div>`;
    });
}

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => navigator.serviceWorker.register("../sw.js").catch(() => {}));
}
