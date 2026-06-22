#Requires -Version 5.1
# test_check_health.ps1 — fixture tests for check-health.ps1
#
# meta/health.md lives alongside wiki/ (i.e. at "$(Split-Path $Wiki -Parent)\meta\health.md").
# Four cases:
#   1. Valid health.md (non-empty last-lint/last-consolidation, integer
#      ingest-count/consolidation-count) -> SUMMARY 0
#   2. Missing health.md -> BAD_HEALTH meta/health.md not found, SUMMARY 1
#   3. Empty last-lint and non-integer ingest-count -> two BAD_HEALTH lines, SUMMARY 2
#   4. Empty last-consolidation and non-integer consolidation-count -> two BAD_HEALTH
#      lines, SUMMARY 2
#
# Vault root contains a space (F1 mandatory case) for all fixtures.

$Script = Join-Path $ScriptsDir "check-health.ps1"

# --- Case 1: valid health.md -----------------------------------------------

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path $wiki -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $base "audit vault\meta") -Force | Out-Null

Set-Content -Path (Join-Path $base "audit vault\meta\health.md") -Encoding UTF8 -Value @'
# Wiki Health

Tracking state for lint cadence and maintenance.

---

ingest-count: 0
last-lint: 2026-06-10
consolidation-count: 0
last-consolidation: 2026-06-10
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "SUMMARY 0" $output `
  "check-health: a valid health.md (integer counts, non-empty dates) passes clean"

Remove-Item -Recurse -Force $base

# --- Case 2: missing health.md ----------------------------------------------

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path $wiki -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $base "audit vault\meta") -Force | Out-Null

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "BAD_HEALTH meta/health.md not found" $output `
  "check-health: flags a missing meta/health.md"

Assert-LinePresent "SUMMARY 1" $output `
  "check-health: summary counts the missing-file issue"

Remove-Item -Recurse -Force $base

# --- Case 3: empty last-lint and non-integer ingest-count -------------------

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path $wiki -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $base "audit vault\meta") -Force | Out-Null

Set-Content -Path (Join-Path $base "audit vault\meta\health.md") -Encoding UTF8 -Value @'
# Wiki Health

Tracking state for lint cadence and maintenance.

---

ingest-count: many
last-lint:
consolidation-count: 0
last-consolidation: 2026-06-10
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "BAD_HEALTH ingest-count is not a non-negative integer: 'many'" $output `
  "check-health: flags a non-integer ingest-count"

Assert-LinePresent "BAD_HEALTH last-lint is empty" $output `
  "check-health: flags an empty last-lint"

Assert-LinePresent "SUMMARY 2" $output `
  "check-health: summary counts both issues (vault path contains a space)"

Remove-Item -Recurse -Force $base

# --- Case 4: empty last-consolidation and non-integer consolidation-count ---

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path $wiki -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $base "audit vault\meta") -Force | Out-Null

Set-Content -Path (Join-Path $base "audit vault\meta\health.md") -Encoding UTF8 -Value @'
# Wiki Health

Tracking state for lint cadence and maintenance.

---

ingest-count: 0
last-lint: 2026-06-10
consolidation-count: many
last-consolidation:
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "BAD_HEALTH consolidation-count is not a non-negative integer: 'many'" $output `
  "check-health: flags a non-integer consolidation-count"

Assert-LinePresent "BAD_HEALTH last-consolidation is empty" $output `
  "check-health: flags an empty last-consolidation"

Assert-LinePresent "SUMMARY 2" $output `
  "check-health: summary counts both consolidation-cadence issues"

Remove-Item -Recurse -Force $base
