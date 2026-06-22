#Requires -Version 5.1
# test_check_index_drift.ps1 — fixture tests for check-index-drift.ps1
#
# Fixture:
#   wiki/INDEX.md links to:
#     - [[projects/demo/_overview]]        (exists -> not broken)
#     - [[resources/concepts/page-good]]   (exists -> not broken)
#     - [[resources/concepts/page-missing]] (does not exist -> BROKEN_ENTRY)
#   wiki/resources/concepts/page-orphan.md (type: frontmatter) exists but is
#   referenced by no INDEX.md -> NOT_INDEXED
#   wiki/resources/concepts/"page extra.md" is a space-named content page
#   (type: frontmatter), referenced by no INDEX.md -> NOT_INDEXED, flagged
#   not skipped for having a space in its filename (#38)
#   wiki/projects/demo/sources/ contains two raw sources (no frontmatter), one
#   kebab-named and one space-named -> excluded from Check 1 entirely (#38)
#   wiki/outputs/sample-query.md (`type: query` frontmatter), referenced by no
#   INDEX.md -> excluded from Check 1 entirely, not NOT_INDEXED (R3)
#
# Vault root contains a space (F1, audit finding, fixed by #31). All checks
# below — including BROKEN_ENTRY and SUMMARY — must pass with a
# space-containing vault path.

$Script = Join-Path $ScriptsDir "check-index-drift.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\concepts") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "projects\demo\sources") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "outputs") -Force | Out-Null

Set-Content -Path (Join-Path $wiki "INDEX.md") -Encoding UTF8 -Value @'
# Index

- [[projects/demo/_overview]]
- [[resources/concepts/page-good]]
- [[resources/concepts/page-missing]]
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\page-good.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Good

Content.
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\page-orphan.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Orphan

Not referenced from any INDEX.md.
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\page extra.md") -Encoding UTF8 -Value @'
---
type: concept
---

# Page Extra

A misnamed (space-containing) content page, not referenced from any INDEX.md.
'@

Set-Content -Path (Join-Path $wiki "projects\demo\_overview.md") -Encoding UTF8 -Value @'
---
type: project
---

# Demo Project

Overview content.
'@

Set-Content -Path (Join-Path $wiki "projects\demo\sources\raw-transcript.md") -Encoding UTF8 -Value @'
Raw transcript text, no frontmatter. Not a content page.
'@

Set-Content -Path (Join-Path $wiki "projects\demo\sources\raw transcript.md") -Encoding UTF8 -Value @'
Raw transcript text with a space in its filename, no frontmatter. Not a content page.
'@

Set-Content -Path (Join-Path $wiki "outputs\sample-query.md") -Encoding UTF8 -Value @'
---
type: query
---

# Sample Query

An outputs/ working doc, referenced by no INDEX.md. Not a linkable content
page, so not NOT_INDEXED (R3).
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "NOT_INDEXED resources/concepts/page-orphan.md" $output `
  "check-index-drift: flags a content page not referenced by any INDEX.md"

Assert-LinePresent "NOT_INDEXED resources/concepts/page extra.md" $output `
  "check-index-drift: a space-named content page with type: frontmatter is flagged, not skipped (#38)"

Assert-LineAbsent "raw-transcript" $output `
  "check-index-drift: a kebab-named raw source with no frontmatter is excluded entirely (#38)"

Assert-LineAbsent "raw transcript" $output `
  "check-index-drift: a space-named raw source with no frontmatter is excluded entirely (#38)"

Assert-LineAbsent "sample-query" $output `
  "check-index-drift: a type: query page referenced by no INDEX.md is excluded entirely, not flagged NOT_INDEXED (R3)"

Assert-LinePresent "BROKEN_ENTRY [[resources/concepts/page-missing]] in INDEX.md" $output `
  "check-index-drift: flags an INDEX.md entry with no matching file (vault path contains a space)"

Assert-LinePresent "SUMMARY 2 1" $output `
  "check-index-drift: summary counts both NOT_INDEXED findings and the BROKEN_ENTRY (vault path contains a space, outputs/ excluded) (R3)"

Remove-Item -Recurse -Force $base
