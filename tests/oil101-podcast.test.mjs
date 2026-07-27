import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFile, stat } from "node:fs/promises";

const root = new URL("../", import.meta.url);
const dataPath = new URL("../docs/data/podcast/episode-01.json", import.meta.url);
const audioPath = new URL(
  "../docs/assets/audio/oil101/episode-01-underground-no-lake.mp3",
  import.meta.url,
);
const episodePath = new URL("../docs/podcast/episode-01.html", import.meta.url);
const seriesPath = new URL("../docs/podcast/index.html", import.meta.url);
const homePath = new URL("../docs/index.html", import.meta.url);
const swPath = new URL("../docs/sw.js", import.meta.url);
const manifestPath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-manifest.json",
  import.meta.url,
);
const sourcePath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-source.md",
  import.meta.url,
);
const promptPath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-notebooklm-prompt.md",
  import.meta.url,
);
const scriptPath = new URL(
  "../podcast-series/oil101/episode-01/episode-01-script.md",
  import.meta.url,
);

const data = JSON.parse(await readFile(dataPath, "utf8"));
const manifest = JSON.parse(await readFile(manifestPath, "utf8"));
const audio = await readFile(audioPath);
const source = await readFile(sourcePath);
const prompt = await readFile(promptPath);
const script = await readFile(scriptPath);
const episodeHtml = await readFile(episodePath, "utf8");
const seriesHtml = await readFile(seriesPath, "utf8");
const homeHtml = await readFile(homePath, "utf8");
const serviceWorker = await readFile(swPath, "utf8");
const audioStat = await stat(audioPath);

assert.equal(data.episode, "01");
assert.equal(data.duration_display, "26:22");
assert.ok(data.duration_seconds > 1580 && data.duration_seconds < 1585);
assert.equal(data.chapters.length, 8);
assert.equal(data.transcript.length, 136);
assert.equal(data.transcript.filter((segment) => segment.speaker === "A").length, 67);
assert.equal(data.transcript.filter((segment) => segment.speaker === "B").length, 65);
assert.equal(data.transcript.filter((segment) => segment.kind === "pause").length, 4);
assert.ok(data.chapters.every((chapter, index, chapters) => (
  chapter.start_seconds < data.duration_seconds
  && (index === 0 || chapter.start_seconds > chapters[index - 1].start_seconds)
)));

assert.equal(audioStat.size, manifest.audited_audio.bytes);
assert.equal(
  createHash("sha256").update(audio).digest("hex").toUpperCase(),
  data.audio_sha256,
);
assert.equal(createHash("sha256").update(source).digest("hex").toUpperCase(), data.source_packet_sha256);
assert.equal(createHash("sha256").update(script).digest("hex").toUpperCase(), data.script_sha256);
assert.equal(createHash("sha256").update(source).digest("hex").toUpperCase(), manifest.sha256.source_packet);
assert.equal(createHash("sha256").update(prompt).digest("hex").toUpperCase(), manifest.sha256.generation_prompt);
assert.equal(createHash("sha256").update(script).digest("hex").toUpperCase(), manifest.sha256.audited_script);
assert.equal(createHash("sha256").update(audio).digest("hex").toUpperCase(), manifest.sha256.published_audio);
assert.ok(audio.subarray(0, 3).toString("ascii") === "ID3");
assert.match(episodeHtml, /data-podcast-audio/);
assert.match(episodeHtml, /data-chapter-list/);
assert.match(episodeHtml, /data-transcript/);
assert.match(episodeHtml, /Exploration &amp; Production/);
assert.match(seriesHtml, /12 集/);
assert.match(seriesHtml, /地下没有一座原油湖/);
assert.match(homeHtml, /podcast\/episode-01\.html/);
assert.match(serviceWorker, /oil101-understanding-v9/);
assert.match(serviceWorker, /\.\/podcast\/episode-01\.html/);
assert.match(serviceWorker, /event\.request\.destination === 'audio'/);
assert.match(serviceWorker, /event\.request\.headers\.has\('range'\)/);
assert.ok(root);

console.log("PODCAST DATA OK: 26:22, 136 timed segments, 8 chapters, audio checksum verified");
