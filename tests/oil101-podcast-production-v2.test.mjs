import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";

const seriesDir = new URL("../podcast-series/oil101/", import.meta.url);
const entries = await readdir(seriesDir, { withFileTypes: true });
const productionEpisodes = entries
  .filter((entry) => entry.isDirectory() && /^episode-(0[2-9]|1[0-9])$/.test(entry.name))
  .map((entry) => entry.name)
  .sort();

assert.ok(productionEpisodes.length >= 1, "at least Episode 02 must be prepared");

for (const directory of productionEpisodes) {
  const id = directory.slice(-2);
  const base = new URL(`${directory}/`, seriesDir);
  const manifest = JSON.parse(await readFile(new URL(`episode-${id}-manifest.json`, base), "utf8"));
  const source = await readFile(new URL(manifest.source_packet, base));
  const prompt = await readFile(new URL(manifest.generation_prompt, base));
  const sourceText = source.toString("utf8");
  const promptText = prompt.toString("utf8");

  assert.equal(manifest.episode, id);
  assert.equal(manifest.language, "zh-CN");
  assert.equal(manifest.notebooklm.language, "中文（简体）");
  assert.equal(manifest.content_contract.central_claims, 1);
  assert.equal(manifest.content_contract.mental_images, 3);
  assert.equal(manifest.content_contract.calculations, 0);
  assert.equal(manifest.content_contract.quizzes, 0);
  assert.equal(manifest.content_contract.active_recall_pauses, 0);
  assert.equal(manifest.content_contract.standalone_recaps, 0);
  assert.equal(manifest.content_contract.maximum_full_claim_expressions, 2);
  assert.equal(
    createHash("sha256").update(source).digest("hex").toUpperCase(),
    manifest.sha256.source_packet,
  );
  assert.equal(
    createHash("sha256").update(prompt).digest("hex").toUpperCase(),
    manifest.sha256.generation_prompt,
  );

  assert.match(sourceText, /## 三个记忆画面/);
  assert.match(sourceText, /## 原始来源/);
  assert.match(promptText, /简体中文/);
  assert.match(promptText, /去重复硬约束/);
  assert.doesNotMatch(promptText, /主动回忆|闭卷|心算|请你复述/);
  assert.doesNotMatch(promptText, /第一阶段复盘|一分钟总结|三点回顾/);

  if (Number(id) >= 4) {
    assert.match(promptText, /只能使用简体中文/);
  }

  if (manifest.notebooklm.wrong_language_attempt) {
    assert.equal(manifest.notebooklm.wrong_language_attempt.disposition, "deleted");
    assert.equal(manifest.notebooklm.retry_language_verified, "中文（简体）");
    assert.match(promptText, /只能使用简体中文/);
  }
}

console.log(`PODCAST PRODUCTION V2 OK: ${productionEpisodes.join(", ")}`);
