import assert from "node:assert/strict";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const { chromium } = require(process.env.PLAYWRIGHT_PATH);
const baseUrl = process.env.OIL101_BASE_URL || "http://localhost:8787";
const screenshotDir = process.env.OIL101_SCREENSHOT_DIR;

const catalog = await fetch(`${baseUrl}/data/oil101-understanding/catalog.json`).then((response) => response.json());
const browser = await chromium.launch({
  headless: true,
  executablePath: process.env.PLAYWRIGHT_BROWSER_PATH || undefined,
});

try {
  const desktop = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  await desktop.goto(baseUrl, { waitUntil: "networkidle" });
  assert.equal(await desktop.locator("[data-route-list] .route-item").count(), 9);
  assert.equal(await desktop.locator(".route-item.locked").count(), 0);
  assert.ok(await desktop.locator("[data-home-progress-value]").isVisible());
  assert.ok(await desktop.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth + 1));
  if (screenshotDir) await desktop.screenshot({ path: `${screenshotDir}/home-desktop.png`, fullPage: true });

  for (const module of catalog.modules) {
    await desktop.goto(`${baseUrl}/learn/module.html?module=${module.file}`, { waitUntil: "networkidle" });
    assert.equal(await desktop.locator(".error-state").count(), 0, module.file);
    assert.equal(await desktop.locator(".lesson-section").count() >= 5, true, module.file);
    assert.equal(await desktop.locator("[data-self-check]").count(), module.checks, module.file);
    const images = desktop.locator(".figure-block img");
    for (let index = 0; index < await images.count(); index += 1) {
      const image = images.nth(index);
      await image.scrollIntoViewIfNeeded();
      await image.evaluate((element) => element.complete
        ? undefined
        : new Promise((resolve) => element.addEventListener("load", resolve, { once: true })));
      assert.ok(await image.evaluate((element) => element.naturalWidth > 0), module.file);
    }
  }

  await desktop.goto(`${baseUrl}/learn/module.html?module=module-04-what-is-oil-price`, { waitUntil: "networkidle" });
  if (screenshotDir) await desktop.screenshot({ path: `${screenshotDir}/module-04-desktop.png`, fullPage: true });

  const mobile = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true });
  await mobile.goto(baseUrl, { waitUntil: "networkidle" });
  assert.equal(await mobile.locator("[data-route-list] .route-item").count(), 9);
  assert.ok(await mobile.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth + 1));
  if (screenshotDir) await mobile.screenshot({ path: `${screenshotDir}/home-mobile.png`, fullPage: true });

  await mobile.goto(`${baseUrl}/learn/module.html?module=module-05-inventory-curve`, { waitUntil: "networkidle" });
  assert.equal(await mobile.locator(".error-state").count(), 0);
  assert.ok(await mobile.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth + 1));
  await mobile.locator('[data-check-reveal="0"]').click();
  assert.ok(await mobile.locator('[data-check-answer="0"]').isVisible());
  await mobile.locator('[data-check-status="mastered"][data-check-index="0"]').click();
  assert.match(await mobile.locator("[data-progress-label]").textContent(), /1\/5/);
  if (screenshotDir) await mobile.screenshot({ path: `${screenshotDir}/module-05-mobile.png`, fullPage: true });

  console.log(`UI SMOKE OK: ${catalog.modules.length} modules, desktop + mobile`);
} finally {
  await browser.close();
}
