import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { basename, join } from "node:path";

const requestedFiles = process.argv.slice(2);
assert.ok(requestedFiles.length > 0, "Usage: node verify-module-preservation.mjs <module-file-name> [...]");

const baselineRows = JSON.parse(
  readFileSync("_workflow/runs/all-modules/baseline.json", "utf8").replace(/^\uFEFF/, "")
);
const baselineByFile = new Map(baselineRows.map((row) => [row.file, row]));

for (const requestedFile of requestedFiles) {
  const file = basename(requestedFile);
  const baseline = baselineByFile.get(file);
  assert.ok(baseline, `${file}: missing baseline`);

  const canonicalPath = join("course/data/oil101-understanding", file);
  const publishedPath = join("docs/data/oil101-understanding", file);
  const canonicalBytes = readFileSync(canonicalPath);
  const publishedBytes = readFileSync(publishedPath);
  const module = JSON.parse(canonicalBytes.toString("utf8"));

  assert.deepEqual(module.lessons.map((lesson) => lesson.id), baseline.lesson_ids, `${file}: lesson IDs changed`);
  assert.equal(module.lessons.length, baseline.lesson_count, `${file}: lesson count changed`);
  assert.equal(module.source_coverage.length, baseline.coverage_count, `${file}: source coverage count changed`);
  assert.equal((module.figures || []).length, baseline.figure_count, `${file}: figure count changed`);
  assert.equal(module.sources.length, baseline.source_count, `${file}: source count changed`);
  assert.equal(module.self_checks.length, baseline.self_check_count, `${file}: self-check count changed`);
  assert.deepEqual(publishedBytes, canonicalBytes, `${file}: canonical/docs mirror drift`);

  console.log(`PRESERVATION OK: ${file}`);
}
