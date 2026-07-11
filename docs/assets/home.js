const panel = document.querySelector("[data-home-progress]");
const routeList = document.querySelector("[data-route-list]");

const escapeHtml = (value = "") => String(value)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;")
  .replaceAll("'", "&#039;");

function loadModuleProgress(moduleId) {
  try {
    return JSON.parse(localStorage.getItem(`oil101Progress:${moduleId}`)) || { checks: {} };
  } catch {
    return { checks: {} };
  }
}

function renderCatalog(catalog) {
  const progress = catalog.modules.map((module) => {
    const state = loadModuleProgress(module.id);
    const mastered = Object.values(state.checks || {}).filter((value) => value === "mastered").length;
    return { ...module, mastered };
  });

  routeList.innerHTML = progress.map((module) => `
    <a class="route-item available" href="learn/module.html?module=${encodeURIComponent(module.file)}">
      <span class="route-number">${escapeHtml(module.reading)}</span>
      <span class="route-copy">
        <strong>${escapeHtml(module.title)}</strong>
        <span>${escapeHtml(module.description)}</span>
      </span>
      <span class="route-state">${module.mastered ? `${module.mastered}/${module.checks} 已掌握` : "开始学习"} →</span>
    </a>`).join("");

  if (!panel) return;
  const total = progress.reduce((sum, module) => sum + module.checks, 0);
  const mastered = progress.reduce((sum, module) => sum + module.mastered, 0);
  const pct = total ? Math.round((mastered / total) * 100) : 0;
  const next = progress.find((module) => module.mastered < module.checks) || progress[progress.length - 1];

  panel.querySelector("[data-home-progress-value]").textContent = `${pct}%`;
  panel.querySelector("[data-home-progress-fill]").style.width = `${pct}%`;
  panel.querySelector("[data-home-progress-label]").textContent = mastered
    ? `全路线已掌握 ${mastered}/${total} 个理解检查`
    : `${catalog.modules.length} 个模块 · 可以开始`;

  const continueLink = panel.querySelector("[data-continue-link]");
  continueLink.href = `learn/module.html?module=${encodeURIComponent(next.file)}`;
  continueLink.textContent = mastered ? `继续 ${next.reading} · ${next.title} →` : "开始第一模块 →";
}

if (routeList) {
  fetch("data/oil101-understanding/catalog.json")
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then(renderCatalog)
    .catch(() => {
      routeList.innerHTML = '<p class="error-state">学习路线暂时载入失败，请刷新页面重试。</p>';
    });
}

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => navigator.serviceWorker.register("./sw.js").catch(() => {}));
}
