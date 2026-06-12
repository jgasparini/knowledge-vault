#Requires -Version 5.1
# test_prune_questions.ps1 — fixture tests for prune-questions.ps1
#
# Fixture: two QUESTIONS.md files.
#   projects/fresh/QUESTIONS.md — 2 open, 1 closed, closed item raised
#     today (0 days old) -> not flagged at all.
#   projects/old/QUESTIONS.md   — 1 open, 3 closed (overcrowded), all 3
#     closed items raised 2000-01-01 (always >30 days old) -> OVERCROWDED
#     and OLD_CLOSED.
#
# Dates are computed at test-run time so this stays correct regardless
# of when the suite runs. Vault root contains a space (F1 mandatory case).

$Script = Join-Path $ScriptsDir "prune-questions.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "projects\fresh") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "projects\old") -Force | Out-Null

$today = Get-Date -Format "yyyy-MM-dd"
$oldDate = "2000-01-01"

Set-Content -Path (Join-Path $wiki "projects\fresh\QUESTIONS.md") -Encoding UTF8 -Value @"
# Questions

- [ ] Open question one *raised $today*
- [ ] Open question two *raised $today*
- [x] Closed question *raised $today*
"@

Set-Content -Path (Join-Path $wiki "projects\old\QUESTIONS.md") -Encoding UTF8 -Value @"
# Questions

- [ ] Open question *raised $today*
- [x] Closed question one *raised $oldDate*
- [x] Closed question two *raised $oldDate*
- [x] Closed question three *raised $oldDate*
"@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "OVERCROWDED 3 1 projects/old/QUESTIONS.md" $output `
  "prune-questions: flags a file with more closed than open items"

Assert-LinePresent "OLD_CLOSED 3 projects/old/QUESTIONS.md" $output `
  "prune-questions: flags closed items raised more than 30 days ago"

Assert-LineAbsent "projects/fresh/QUESTIONS.md" $output `
  "prune-questions: does not flag a file with fresh items and more open than closed"

Assert-LinePresent "SUMMARY 2 1" $output `
  "prune-questions: summary counts 2 files checked, 1 flagged (vault path contains a space)"

Remove-Item -Recurse -Force $base
