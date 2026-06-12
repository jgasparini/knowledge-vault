#Requires -Version 5.1
# test_find_orphans.ps1 — fixture tests for find-orphans.ps1
#
# Fixture: 6 content pages (each has `type:` frontmatter).
#   page-popular  <- linked from page-a and page-b (2 inbound, NOT an orphan)
#   page-single   <- linked from page-a only (1 inbound, ORPHAN 1)
#   page-lonely   <- linked from nowhere (0 inbound, ORPHAN 0)
#   page-a        <- linked from page-b only (1 inbound, ORPHAN 1)
#   page-b        <- linked from nowhere (0 inbound, ORPHAN 0)
#   "page extra"  <- space-named content page (has `type:` frontmatter),
#                     linked from nowhere -> ORPHAN 0, flagged not skipped (#38)
# INDEX.md is excluded as a navigation file.
#
# Also includes two raw sources (no frontmatter) that must be excluded from
# the content-page count entirely, regardless of filename (#38):
#   sources/raw-transcript.md   <- kebab-named raw source
#   sources/raw transcript.md   <- space-named raw source
#
# And one outputs/ working doc (`type: output` frontmatter, 0 inbound links)
# that must also be excluded from the content-page count entirely (R3):
#   outputs/sample-report.md
#
# Vault root contains a space (F1 mandatory case).

$Script = Join-Path $ScriptsDir "find-orphans.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "sources") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "outputs") -Force | Out-Null

Set-Content -Path (Join-Path $wiki "INDEX.md") -Encoding UTF8 -Value @'
# Index
'@

Set-Content -Path (Join-Path $wiki "page-a.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page A

[[page-popular]] [[page-single]]
'@

Set-Content -Path (Join-Path $wiki "page-b.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page B

[[page-popular]] [[page-a]]
'@

Set-Content -Path (Join-Path $wiki "page-popular.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Popular
'@

Set-Content -Path (Join-Path $wiki "page-single.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Single
'@

Set-Content -Path (Join-Path $wiki "page-lonely.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Lonely
'@

Set-Content -Path (Join-Path $wiki "page extra.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Extra

A misnamed (space-containing) content page with no inbound links.
'@

Set-Content -Path (Join-Path $wiki "sources\raw-transcript.md") -Encoding UTF8 -Value @'
Raw transcript text, no frontmatter. Not a content page.
'@

Set-Content -Path (Join-Path $wiki "sources\raw transcript.md") -Encoding UTF8 -Value @'
Raw transcript text with a space in its filename, no frontmatter. Not a content page.
'@

Set-Content -Path (Join-Path $wiki "outputs\sample-report.md") -Encoding UTF8 -Value @'
---
type: output
---

# Sample Report

An outputs/ working doc with no inbound links. Not a linkable content page (R3).
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "ORPHAN 1 page-a.md" $output `
  "find-orphans: page-a has exactly one inbound link (from page-b)"

Assert-LinePresent "ORPHAN 0 page-b.md" $output `
  "find-orphans: page-b has no inbound links"

Assert-LinePresent "ORPHAN 0 page-lonely.md" $output `
  "find-orphans: page-lonely has no inbound links"

Assert-LineAbsent "page-popular.md" $output `
  "find-orphans: page-popular has 2 inbound links and is not flagged"

Assert-LinePresent "ORPHAN 1 page-single.md" $output `
  "find-orphans: page-single has exactly one inbound link"

Assert-LinePresent "ORPHAN 0 page extra.md" $output `
  "find-orphans: a space-named content page with type: frontmatter is flagged, not skipped (#38)"

Assert-LineAbsent "raw-transcript" $output `
  "find-orphans: a kebab-named raw source with no frontmatter is excluded entirely (#38)"

Assert-LineAbsent "raw transcript" $output `
  "find-orphans: a space-named raw source with no frontmatter is excluded entirely (#38)"

Assert-LineAbsent "sample-report" $output `
  "find-orphans: a type: output page with 0 inbound links is excluded entirely, not flagged ORPHAN (R3)"

Assert-LinePresent "SUMMARY 6 5" $output `
  "find-orphans: summary counts 6 content pages checked, 5 orphans (raw sources and outputs/ excluded) (#38, R3)"

Remove-Item -Recurse -Force $base
