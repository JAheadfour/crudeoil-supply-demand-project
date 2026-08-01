import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";

const mapPath = new URL(
  "../podcast-series/oil101/episode-map-v2.json",
  import.meta.url,
);
const planPath = new URL(
  "../podcast-series/oil101/SERIES_PLAN.md",
  import.meta.url,
);
const blueprintPath = new URL(
  "../podcast-series/oil101/EPISODE_BLUEPRINTS_V2.md",
  import.meta.url,
);
const exemplarPath = new URL(
  "../_workflow/podcast/exemplars/golden-episode-01-v2.md",
  import.meta.url,
);
const v2ManifestPath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-v2-manifest.json",
  import.meta.url,
);
const v2SourcePath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-v2-source.md",
  import.meta.url,
);
const v2PromptPath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-v2-notebooklm-prompt.md",
  import.meta.url,
);

const map = JSON.parse(await readFile(mapPath, "utf8"));
const plan = await readFile(planPath, "utf8");
const blueprints = await readFile(blueprintPath, "utf8");
const exemplar = await readFile(exemplarPath, "utf8");
const v2Manifest = JSON.parse(await readFile(v2ManifestPath, "utf8"));
const v2Source = await readFile(v2SourcePath);
const v2Prompt = await readFile(v2PromptPath);

assert.equal(map.variant, "understanding");
assert.equal(map.core_episode_count, 19);
assert.equal(map.bonus_episode_count, 2);
assert.equal(map.episodes.length, map.core_episode_count);
assert.equal(map.bonus_episodes.length, map.bonus_episode_count);

const ids = map.episodes.map((episode) => episode.id);
assert.equal(new Set(ids).size, ids.length);
assert.deepEqual(ids, Array.from({ length: 19 }, (_, index) => String(index + 1).padStart(2, "0")));

for (const episode of map.episodes) {
  assert.equal(episode.memory_images.length, 3, `${episode.id} must have three memory images`);
  assert.ok(episode.central_question.endsWith("？"), `${episode.id} needs one explicit question`);
  assert.ok(episode.primary_chapters.length >= 1, `${episode.id} needs an original-book anchor`);
  if (episode.id !== "01") {
    assert.ok(episode.exclude.length >= 3, `${episode.id} needs explicit content boundaries`);
  }
}

const primaryCoverage = new Set(map.episodes.flatMap((episode) => episode.primary_chapters));
assert.deepEqual([...primaryCoverage].sort((a, b) => a - b), Array.from({ length: 26 }, (_, index) => index + 1));

assert.equal(map.production_rules.central_questions_per_episode, 1);
assert.equal(map.production_rules.memory_images_per_episode, 3);
assert.equal(map.production_rules.recall_pauses, 0);
assert.equal(map.production_rules.listener_calculations, 0);
assert.equal(map.production_rules.standalone_recaps, 0);
assert.equal(map.production_rules.max_full_claim_expressions, 2);
assert.match(map.production_rules.source_policy, /original author chapter pages/);
assert.match(map.production_rules.repetition_policy, /new information is repetition/);

assert.doesNotMatch(plan, /two active-recall pauses/i);
assert.doesNotMatch(plan, /one spoken calculation/i);
assert.match(plan, /12-17 分钟/);
assert.match(plan, /去重复闸门/);
assert.match(plan, /Episode 02 负责验证/);

for (let episode = 2; episode <= 19; episode += 1) {
  const id = String(episode).padStart(2, "0");
  assert.match(blueprints, new RegExp(`## ${id}｜`), `missing blueprint ${id}`);
}

assert.match(exemplar, /比较满意/);
assert.match(exemplar, /重复的废话还是略多/);
assert.match(exemplar, /semantic repetition/i);
assert.match(exemplar, /mandatory repair/i);

assert.equal(v2Manifest.status, "generated_user_accepted_pending_download");
assert.equal(v2Manifest.content_contract.calculations, 0);
assert.equal(v2Manifest.content_contract.quizzes, 0);
assert.equal(v2Manifest.content_contract.active_recall_pauses, 0);
assert.equal(
  createHash("sha256").update(v2Source).digest("hex").toUpperCase(),
  v2Manifest.sha256.source_packet,
);
assert.equal(
  createHash("sha256").update(v2Prompt).digest("hex").toUpperCase(),
  v2Manifest.sha256.generation_prompt,
);

console.log("PODCAST PLAN V2 OK: 19 core episodes cover Chapters 1-26 with repetition gates");
