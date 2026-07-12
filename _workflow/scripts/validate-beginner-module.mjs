import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const paths = process.argv.slice(2);
assert.ok(paths.length > 0, "Usage: node validate-beginner-module.mjs <module.json> [...]");

const escapeRegExp = (text) => text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const isSubstantiveString = (value, minLength = 1) =>
  typeof value === "string" && value.trim().length >= minLength;
const termPattern = (label) =>
  /[A-Za-z0-9]/.test(label)
    ? new RegExp(`(^|[^A-Za-z0-9])${escapeRegExp(label)}($|[^A-Za-z0-9])`, "i")
    : new RegExp(escapeRegExp(label), "i");
const numberPattern = /\d[\d,]*(?:\.\d+)?/;
const recognizedUnitPattern =
  /\b(?:bbl|bbls|barrel|barrels|bpd|kbpd|mbpd|boe|tonne|tonnes|ton|tons|gallon|gallons|psi|API|RVP|octane|cetane|hours?|days?|weeks?|months?|years?|kg|m3|m³|liters?|litres?|L|contracts?|lots?|MMBtu|MWh)\b|°API|US\$|\$|%/i;
const calculationUnitPattern = String.raw`(?:[\u4ebf\u4e07]?(?:\u6876|\u7f8e\u5143|bbls?|barrels?|bpd|kbpd|mbpd|boe|tonnes?|tons?|gallons?|psi|API|RVP|octane|cetane|hours?|days?|weeks?|months?|years?|kg|m3|m\u00b3|liters?|litres?|L|contracts?|lots?|MMBtu|MWh|%))`;
const calculationOperandPattern = String.raw`\d[\d,]*(?:\.\d+)?(?:\s*${calculationUnitPattern})?`;
const explicitCalculationPattern = new RegExp(
  String.raw`${calculationOperandPattern}\s*[\u00d7\u00f7+\-]\s*${calculationOperandPattern}\s*=\s*\d[\d,]*(?:\.\d+)?\s*${calculationUnitPattern}(?:\s*\/\s*(?:\u6876|bbls?|barrels?|\u7f8e\u5143|bpd|kbpd|mbpd|months?|years?))?`,
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
].filter((value) => isSubstantiveString(value));

for (const path of paths) {
  const module = JSON.parse(readFileSync(path, "utf8"));
  const firstDefinitionLessonByLabel = new Map();

  assert.ok(module.lessons.length >= 5, `${path}: at least five lessons`);
  module.lessons.forEach((lesson, lessonIndex) => {
    for (const term of lesson.terms_in_context || []) {
      for (const label of [term.term, term.cn]) {
        if (isSubstantiveString(label) && !firstDefinitionLessonByLabel.has(label)) {
          firstDefinitionLessonByLabel.set(label, lessonIndex);
        }
      }
    }
  });

  const preDefinitionTextByLesson = module.lessons.map((lesson) =>
    preDefinitionFields(lesson).join(" ")
  );

  for (const lesson of module.lessons) {
    const label = `${path}/${lesson.id}`;
    assert.ok(isSubstantiveString(lesson.reader_question, 20), `${label}: reader_question`);
    assert.ok(isSubstantiveString(lesson.scene?.setting, 30), `${label}: scene.setting`);
    assert.ok(isSubstantiveString(lesson.scene?.actors, 15), `${label}: scene.actors`);
    assert.ok(isSubstantiveString(lesson.scene?.action, 40), `${label}: scene.action`);
    assert.ok(isSubstantiveString(lesson.plain_answer, 40), `${label}: plain_answer`);
    assert.ok(lesson.mechanism_chain.length >= 3, `${label}: mechanism_chain`);
    assert.ok(lesson.terms_in_context.length >= 2, `${label}: terms_in_context`);
    assert.ok(lesson.terms_in_context.every((term) =>
      term.term && term.cn && term.plain_definition && term.why_it_matters
    ), `${label}: contextual term fields`);

    for (const term of lesson.terms_in_context) {
      for (const termLabel of [term.term, term.cn].filter((item) => isSubstantiveString(item))) {
        const firstDefinitionLessonIndex = firstDefinitionLessonByLabel.get(termLabel);
        for (let lessonIndex = 0; lessonIndex <= firstDefinitionLessonIndex; lessonIndex += 1) {
          assert.doesNotMatch(
            preDefinitionTextByLesson[lessonIndex],
            termPattern(termLabel),
            `${path}/${module.lessons[lessonIndex].id}: ${termLabel} appears before its term card`
          );
        }
      }
    }

    const example = lesson.worked_example;
    assert.ok(isSubstantiveString(example?.actor, 8), `${label}: example.actor`);
    assert.ok(Array.isArray(example?.inputs), `${label}: example.inputs`);
    assert.ok(example.inputs.filter((input) => isSubstantiveString(input, 8)).length >= 2, `${label}: example inputs`);
    assert.match(example.setup, numberPattern, `${label}: setup number`);
    assert.match(example.setup, recognizedUnitPattern, `${label}: setup unit`);
    assert.ok(example.steps.length >= 2, `${label}: example steps`);
    assert.ok(example.steps.every((step) => step.length >= 20), `${label}: detailed example steps`);
    assert.ok(example.steps.some((step) => explicitCalculationPattern.test(step)), `${label}: explicit arithmetic`);
    assert.ok(isSubstantiveString(example.answer, 25), `${label}: example answer`);
    assert.ok(lesson.deep_dive.length >= 1, `${label}: deep_dive`);
  }

  console.log(`BEGINNER MODULE OK: ${path} (${module.lessons.length} lessons)`);
}
