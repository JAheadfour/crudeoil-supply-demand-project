param(
  [string]$KbRoot = "outputs/oil101-KB",
  [string]$SiteRoot = "outputs/oil101-mobile-site"
)

$ErrorActionPreference = "Stop"

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )
  $parent = Split-Path -Parent $Path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $parent).Path + "\" + (Split-Path -Leaf $Path), $Content, [System.Text.UTF8Encoding]::new($false))
}

function Encode-Html {
  param([string]$Text)
  return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Convert-InlineMarkdown {
  param([string]$Text)
  $encoded = Encode-Html $Text
  $encoded = [regex]::Replace($encoded, '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>')
  $encoded = [regex]::Replace($encoded, '`([^`]+)`', '<code>$1</code>')
  return $encoded
}

function Close-Blocks {
  param(
    [System.Text.StringBuilder]$Html,
    [ref]$InUl,
    [ref]$InOl,
    [ref]$InTable
  )
  if ($InUl.Value) { [void]$Html.AppendLine("</ul>"); $InUl.Value = $false }
  if ($InOl.Value) { [void]$Html.AppendLine("</ol>"); $InOl.Value = $false }
  if ($InTable.Value) { [void]$Html.AppendLine("</tbody></table>"); $InTable.Value = $false }
}

function Convert-MarkdownToHtml {
  param([string]$Markdown)

  $html = New-Object System.Text.StringBuilder
  $inCode = $false
  $inUl = $false
  $inOl = $false
  $inTable = $false
  $tableHeaderDone = $false

  foreach ($line in ($Markdown -split "`r?`n")) {
    if ($line -match '^```') {
      Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
      if ($inCode) {
        [void]$html.AppendLine("</code></pre>")
        $inCode = $false
      } else {
        [void]$html.AppendLine("<pre><code>")
        $inCode = $true
      }
      continue
    }

    if ($inCode) {
      [void]$html.AppendLine((Encode-Html $line))
      continue
    }

    if ($line.Trim().Length -eq 0) {
      Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
      continue
    }

    if ($line -match '^\s*\|.*\|\s*$') {
      if (-not $inTable) {
        Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
        [void]$html.AppendLine("<table><tbody>")
        $inTable = $true
        $tableHeaderDone = $false
      }
      if ($line -match '^\s*\|[\s:\-]+\|') { continue }
      $cells = $line.Trim().Trim("|") -split '\|'
      if (-not $tableHeaderDone) {
        [void]$html.AppendLine("<tr>" + (($cells | ForEach-Object { "<th>" + (Convert-InlineMarkdown $_.Trim()) + "</th>" }) -join "") + "</tr>")
        $tableHeaderDone = $true
      } else {
        [void]$html.AppendLine("<tr>" + (($cells | ForEach-Object { "<td>" + (Convert-InlineMarkdown $_.Trim()) + "</td>" }) -join "") + "</tr>")
      }
      continue
    }

    if ($line -match '^(#{1,4})\s+(.+)$') {
      Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
      $level = $Matches[1].Length
      $text = $Matches[2].Trim()
      $id = ($text.ToLowerInvariant() -replace '[^a-z0-9]+','-').Trim('-')
      if (-not $id) { $id = [guid]::NewGuid().ToString("N") }
      [void]$html.AppendLine("<h$level id=""$id"">" + (Convert-InlineMarkdown $text) + "</h$level>")
      continue
    }

    if ($line -match '^\s*-\s+(.+)$') {
      if (-not $inUl) {
        Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
        [void]$html.AppendLine("<ul>")
        $inUl = $true
      }
      [void]$html.AppendLine("<li>" + (Convert-InlineMarkdown $Matches[1].Trim()) + "</li>")
      continue
    }

    if ($line -match '^\s*\d+\.\s+(.+)$') {
      if (-not $inOl) {
        Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
        [void]$html.AppendLine("<ol>")
        $inOl = $true
      }
      [void]$html.AppendLine("<li>" + (Convert-InlineMarkdown $Matches[1].Trim()) + "</li>")
      continue
    }

    Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
    [void]$html.AppendLine("<p>" + (Convert-InlineMarkdown $line.Trim()) + "</p>")
  }

  Close-Blocks $html ([ref]$inUl) ([ref]$inOl) ([ref]$inTable)
  if ($inCode) { [void]$html.AppendLine("</code></pre>") }
  return $html.ToString()
}

function Get-RelativeCssPath {
  param([string]$PageFile)
  return "assets/site.css"
}

$kb = Resolve-Path -LiteralPath $KbRoot
$site = Join-Path (Get-Location) $SiteRoot
New-Item -ItemType Directory -Force -Path $site | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $site "pages") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $site "assets") | Out-Null

$indexText = [System.IO.File]::ReadAllText((Join-Path $kb "index.md"), [System.Text.Encoding]::UTF8)
$units = @()
foreach ($line in ($indexText -split "`r?`n")) {
  if ($line -notmatch '^\|\s*(Chapter|Appendix)\s+') { continue }
  $cells = $line.Trim().Trim("|") -split '\|'
  if ($cells.Count -lt 5) { continue }
  $label = $cells[0].Trim()
  $title = $cells[1].Trim()
  $dir = $cells[2].Trim()
  $source = $cells[3].Trim()
  $file = ($dir -replace '[\\/]+','--') + ".html"
  $units += [pscustomobject]@{
    Label = $label
    Title = $title
    Dir = $dir
    Source = $source
    File = $file
  }
}

$css = @'
:root {
  color-scheme: light;
  --bg: #f7f8f5;
  --panel: #ffffff;
  --ink: #1e2522;
  --muted: #64716b;
  --line: #d9ded8;
  --accent: #1f6f5b;
  --accent-2: #8b4a2f;
  --code: #eef3ef;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  background: var(--bg);
  color: var(--ink);
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  line-height: 1.65;
}
a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }
.app-header {
  position: sticky;
  top: 0;
  z-index: 10;
  background: rgba(247, 248, 245, 0.94);
  border-bottom: 1px solid var(--line);
  backdrop-filter: blur(12px);
}
.header-inner {
  max-width: 1120px;
  margin: 0 auto;
  padding: 12px 18px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 14px;
}
.brand { font-weight: 760; letter-spacing: 0; }
.header-links { display: flex; gap: 12px; font-size: 14px; }
.shell {
  max-width: 1120px;
  margin: 0 auto;
  padding: 24px 18px 56px;
}
.hero {
  padding: 10px 0 18px;
  border-bottom: 1px solid var(--line);
  margin-bottom: 22px;
}
.eyebrow {
  color: var(--accent-2);
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
}
h1, h2, h3, h4 {
  line-height: 1.22;
  margin: 1.35em 0 0.45em;
  letter-spacing: 0;
}
h1 { font-size: clamp(30px, 6vw, 52px); margin-top: 0.2em; }
h2 { font-size: 24px; border-top: 1px solid var(--line); padding-top: 20px; }
h3 { font-size: 19px; }
p, li { font-size: 17px; }
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 12px;
}
.unit-card {
  display: block;
  padding: 14px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--panel);
}
.unit-card strong { display: block; color: var(--ink); }
.unit-card span { display: block; color: var(--muted); font-size: 14px; margin-top: 2px; }
.search {
  width: 100%;
  padding: 13px 14px;
  margin: 8px 0 18px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: #fff;
  color: var(--ink);
  font: inherit;
}
.content {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 260px;
  gap: 28px;
  align-items: start;
}
.article {
  background: var(--panel);
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 22px;
  overflow: hidden;
}
.toc {
  position: sticky;
  top: 74px;
  border-left: 2px solid var(--line);
  padding-left: 14px;
  color: var(--muted);
  font-size: 14px;
}
.toc a { display: block; padding: 4px 0; color: var(--muted); }
table {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
  overflow: hidden;
}
th, td {
  border: 1px solid var(--line);
  padding: 9px 10px;
  vertical-align: top;
}
th { background: #edf3ee; text-align: left; }
pre, code {
  background: var(--code);
  border-radius: 6px;
}
code { padding: 1px 5px; }
pre { padding: 12px; overflow-x: auto; }
.page-nav {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  margin-top: 22px;
}
.page-nav a {
  flex: 1;
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 12px;
  background: var(--panel);
}
.page-nav a:last-child { text-align: right; }
.source-link { color: var(--muted); font-size: 14px; }
@media (max-width: 820px) {
  .header-inner { align-items: flex-start; flex-direction: column; }
  .content { display: block; }
  .toc { display: none; }
  .article { padding: 18px; border-left: 0; border-right: 0; border-radius: 0; margin-left: -18px; margin-right: -18px; }
  h1 { font-size: 34px; }
  h2 { font-size: 22px; }
  p, li { font-size: 16px; }
  .page-nav { flex-direction: column; }
  .page-nav a:last-child { text-align: left; }
}
'@
Write-Utf8File -Path (Join-Path $site "assets/site.css") -Content $css

$js = @'
const search = document.querySelector("[data-search]");
const cards = [...document.querySelectorAll("[data-unit-card]")];
if (search) {
  search.addEventListener("input", () => {
    const q = search.value.trim().toLowerCase();
    for (const card of cards) {
      card.style.display = card.textContent.toLowerCase().includes(q) ? "" : "none";
    }
  });
}
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => navigator.serviceWorker.register("./sw.js").catch(() => {}));
}
'@
Write-Utf8File -Path (Join-Path $site "assets/site.js") -Content $js

$pageFiles = @("index.html", "assets/site.css", "assets/site.js", "manifest.webmanifest")

for ($i = 0; $i -lt $units.Count; $i++) {
  $u = $units[$i]
  $unitDir = Join-Path $kb $u.Dir
  $parts = @()
  foreach ($name in @("04-deep-explanation.md", "01-structured-notes.md", "02-concept-bank.md", "02-formula-bank.md", "03-review-tools.md")) {
    $path = Join-Path $unitDir $name
    if (Test-Path -LiteralPath $path) {
      $parts += [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $path), [System.Text.Encoding]::UTF8)
    }
  }
  $md = $parts -join "`r`n`r`n---`r`n`r`n"
  $body = Convert-MarkdownToHtml $md
  $tocLinks = @()
  foreach ($m in [regex]::Matches($body, '<h2 id="([^"]+)">(.+?)</h2>')) {
    $tocLinks += "<a href=""#$($m.Groups[1].Value)"">$($m.Groups[2].Value -replace '<[^>]+>','')</a>"
  }
  $prev = if ($i -gt 0) { $units[$i - 1] } else { $null }
  $next = if ($i -lt $units.Count - 1) { $units[$i + 1] } else { $null }
  $nav = New-Object System.Text.StringBuilder
  [void]$nav.AppendLine('<nav class="page-nav">')
  if ($prev) { [void]$nav.AppendLine("<a href=""$($prev.File)"">&larr; $($prev.Label)<br><strong>$((Encode-Html $prev.Title))</strong></a>") } else { [void]$nav.AppendLine("<span></span>") }
  if ($next) { [void]$nav.AppendLine("<a href=""$($next.File)"">$($next.Label) &rarr;<br><strong>$((Encode-Html $next.Title))</strong></a>") } else { [void]$nav.AppendLine("<span></span>") }
  [void]$nav.AppendLine('</nav>')

  $html = @"
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$((Encode-Html "$($u.Label) - $($u.Title)"))</title>
  <link rel="manifest" href="../manifest.webmanifest">
  <link rel="stylesheet" href="../assets/site.css">
</head>
<body>
  <header class="app-header">
    <div class="header-inner">
      <a class="brand" href="../index.html">Oil 101 KB</a>
      <nav class="header-links">
        <a href="../index.html">All chapters</a>
        <a href="$((Encode-Html $u.Source))">Source</a>
      </nav>
    </div>
  </header>
  <main class="shell">
    <section class="hero">
      <div class="eyebrow">$((Encode-Html $u.Label))</div>
      <h1>$((Encode-Html $u.Title))</h1>
      <div class="source-link">Source: <a href="$((Encode-Html $u.Source))">$((Encode-Html $u.Source))</a></div>
    </section>
    <div class="content">
      <article class="article">
$body
$($nav.ToString())
      </article>
      <aside class="toc">
        <strong>On this page</strong>
        $($tocLinks -join "`n        ")
      </aside>
    </div>
  </main>
</body>
</html>
"@
  Write-Utf8File -Path (Join-Path (Join-Path $site "pages") $u.File) -Content $html
  $pageFiles += "pages/$($u.File)"
}

$cards = New-Object System.Text.StringBuilder
foreach ($u in $units) {
  [void]$cards.AppendLine("<a class=""unit-card"" data-unit-card href=""pages/$($u.File)""><strong>$((Encode-Html "$($u.Label): $($u.Title)"))</strong><span>$((Encode-Html $u.Dir))</span></a>")
}

$indexHtml = @"
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Oil 101 Knowledge Base</title>
  <link rel="manifest" href="manifest.webmanifest">
  <link rel="stylesheet" href="assets/site.css">
</head>
<body>
  <header class="app-header">
    <div class="header-inner">
      <a class="brand" href="index.html">Oil 101 KB</a>
      <nav class="header-links">
        <a href="https://oil101.morgandowney.com/chapters">Source TOC</a>
      </nav>
    </div>
  </header>
  <main class="shell">
    <section class="hero">
      <div class="eyebrow">Mobile deep-reading site</div>
      <h1>Oil 101 深度知识库</h1>
      <p>每章先用中文把核心逻辑、现实推演和关键概念讲透，再附结构化笔记、概念库和复习工具。</p>
    </section>
    <input class="search" data-search placeholder="Search chapters, concepts, or appendices" aria-label="Search chapters">
    <section class="grid">
$($cards.ToString())
    </section>
  </main>
  <script src="assets/site.js"></script>
</body>
</html>
"@
Write-Utf8File -Path (Join-Path $site "index.html") -Content $indexHtml

$manifest = @'
{
  "name": "Oil 101 Knowledge Base",
  "short_name": "Oil101 KB",
  "start_url": "./index.html",
  "display": "standalone",
  "background_color": "#f7f8f5",
  "theme_color": "#1f6f5b"
}
'@
Write-Utf8File -Path (Join-Path $site "manifest.webmanifest") -Content $manifest

$cacheList = ($pageFiles | ForEach-Object { "  './$_'" }) -join ",`n"
$sw = @"
const CACHE_NAME = 'oil101-kb-v1';
const ASSETS = [
$cacheList
];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS)));
});
self.addEventListener('fetch', event => {
  event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request)));
});
"@
Write-Utf8File -Path (Join-Path $site "sw.js") -Content $sw

"Built mobile site with $($units.Count) pages at $site"
