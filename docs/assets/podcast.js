const dataUrl = "../data/podcast/episode-01.json";
const audio = document.querySelector("[data-podcast-audio]");
const chapterList = document.querySelector("[data-chapter-list]");
const transcript = document.querySelector("[data-transcript]");
const status = document.querySelector("[data-player-status]");
const durationNodes = document.querySelectorAll("[data-episode-duration]");

function seekTo(seconds) {
  audio.currentTime = seconds;
  audio.play().catch(() => {});
  audio.scrollIntoView({ behavior: "smooth", block: "center" });
}

function makeSeekButton(label, seconds, className) {
  const button = document.createElement("button");
  button.type = "button";
  button.className = className;
  button.textContent = label;
  button.addEventListener("click", () => seekTo(seconds));
  return button;
}

function renderChapters(chapters) {
  chapterList.replaceChildren();
  for (const chapter of chapters) {
    const button = makeSeekButton("", chapter.start_seconds, "chapter-button");
    const time = document.createElement("span");
    time.className = "chapter-time";
    time.textContent = chapter.start_display;
    const copy = document.createElement("span");
    copy.className = "chapter-copy";
    const title = document.createElement("strong");
    title.textContent = chapter.title;
    const summary = document.createElement("span");
    summary.textContent = chapter.summary;
    copy.append(title, summary);
    button.append(time, copy);
    chapterList.append(button);
  }
}

function renderTranscript(segments) {
  transcript.replaceChildren();
  for (const segment of segments) {
    if (segment.kind === "pause") {
      const pause = document.createElement("p");
      pause.className = "recall-pause";
      pause.textContent = `主动回忆：留给你 ${Math.round(segment.seconds)} 秒，在答案出现前先自己说出来。`;
      transcript.append(pause);
      continue;
    }

    const turn = document.createElement("article");
    turn.className = "transcript-turn";
    const speaker = document.createElement("div");
    speaker.className = "speaker";
    const speakerName = document.createElement("strong");
    speakerName.textContent = segment.speaker === "A" ? "讲解者" : "分析者";
    const time = makeSeekButton(segment.start_display, segment.start_seconds, "time-link");
    speaker.append(speakerName, time);
    const text = document.createElement("p");
    text.textContent = segment.text;
    turn.append(speaker, text);
    transcript.append(turn);
  }
}

async function init() {
  try {
    const response = await fetch(dataUrl);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    audio.src = data.published_audio;
    for (const node of durationNodes) node.textContent = data.duration_display;
    renderChapters(data.chapters);
    renderTranscript(data.transcript);
    status.textContent = "音频与逐字稿来自同一份审校脚本";
  } catch (error) {
    status.textContent = `单集数据加载失败：${error.message}`;
    chapterList.innerHTML = '<p class="microcopy">章节导航暂时不可用。</p>';
    transcript.innerHTML = '<p class="microcopy">逐字稿暂时不可用。</p>';
  }
}

audio.addEventListener("loadedmetadata", () => {
  if (Number.isFinite(audio.duration)) {
    status.textContent = `已载入 ${Math.floor(audio.duration / 60)}:${String(Math.floor(audio.duration % 60)).padStart(2, "0")} · 音频与逐字稿一一对应`;
  }
});

init();
