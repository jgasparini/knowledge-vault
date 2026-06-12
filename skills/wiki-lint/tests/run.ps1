#Requires -Version 5.1
# run.ps1 — run all wiki-lint script fixture tests (PowerShell port of run.sh)
#
# Usage:
#   powershell -File skills\wiki-lint\tests\run.ps1
#   pwsh skills/wiki-lint/tests/run.ps1
#
# Mirrors run.sh: dot-sources helpers.ps1, then dot-sources every test_*.ps1
# in this directory so each can call Assert-LinePresent / Assert-LineAbsent
# and accumulate into $global:PassCount / $global:FailCount. Exits 1 if any
# assertion failed.
#
# check-enum-drift.sh has no PowerShell mirror (it only compares the bash and
# PowerShell enum tables, and the enum-drift CI job already runs it on
# ubuntu-latest), so there is no test_check_enum_drift.ps1.

$TestsDir = $PSScriptRoot
$ScriptsDir = Join-Path (Split-Path $TestsDir -Parent) "scripts"

. (Join-Path $TestsDir "helpers.ps1")

foreach ($testFile in (Get-ChildItem -Path $TestsDir -Filter "test_*.ps1" | Sort-Object Name)) {
    Write-Output "--- $($testFile.Name) ---"
    . $testFile.FullName
}

Write-TestSummary

if ($global:FailCount -gt 0) {
    exit 1
} else {
    exit 0
}
