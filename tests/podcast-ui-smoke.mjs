import assert from "node:assert/strict";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const { chromium } = require(process.env.PLAYWRIGHT_PATH);
const baseUrl = process.env.OIL101_BASE_URL || "http://localhost:8787";
const screenshotDir = process.env.OIL101_SCREENSHOT_DIR;

const browser = await chromium.launch({
  headless: true,
  executablePath: process.env.PLAYWRIGHT_BROWSER_PATH || undefined,
});

async function checkViewport(page, name) {
  await page.goto(`${baseUrl}/podcast/episode-01.html`, { waitUntil: "domcontentloaded" });
  await page.locator("[data-chapter-list] .chapter-button").first().waitFor({ timeout: 30_000 });
  assert.equal(await page.locator("[data-chapter-list] .chapter-button").count(), 8);
  assert.equal(await page.locator("[data-transcript] .transcript-turn").count(), 132);
  assert.equal(await page.locator("[data-transcript] .recall-pause").count(), 4);
  assert.ok(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth + 1));

  await page.waitForFunction(() => {
    const element = document.querySelector("[data-podcast-audio]");
    return element && (element.readyState >= 1 || element.error);
  }, null, { timeout: 60_000 });
  const media = await page.locator("[data-podcast-audio]").evaluate(async (element) => {
    element.currentTime = 600;
    await new Promise((resolve) => element.addEventListener("seeked", resolve, { once: true }));
    return {
      duration: element.duration,
      currentTime: element.currentTime,
      error: element.error?.code || null,
      currentSrc: element.currentSrc,
      networkState: element.networkState,
      readyState: element.readyState,
    };
  });
  assert.ok(media.duration > 1580 && media.duration < 1585, `${name} duration`);
  assert.ok(
    media.currentTime > 599 && media.currentTime < 601,
    `${name} seek ${JSON.stringify(media)}`,
  );
  assert.equal(media.error, null, `${name} media error`);

  if (screenshotDir) {
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.screenshot({ path: `${screenshotDir}/podcast-${name}-top.png` });
    await page.screenshot({ path: `${screenshotDir}/podcast-${name}-full.png`, fullPage: true });
  }
}

try {
  const desktop = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  await desktop.goto(baseUrl, { waitUntil: "domcontentloaded" });
  assert.ok(await desktop.getByRole("link", { name: /播放第一集/ }).isVisible());
  await checkViewport(desktop, "desktop");

  const mobile = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true });
  await mobile.goto(`${baseUrl}/podcast/`, { waitUntil: "domcontentloaded" });
  assert.ok(await mobile.getByRole("link", { name: /地下没有一座原油湖/ }).isVisible());
  assert.ok(await mobile.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth + 1));
  await checkViewport(mobile, "mobile");

  console.log("PODCAST UI OK: desktop + mobile, media metadata + seek verified");
} finally {
  await browser.close();
}
