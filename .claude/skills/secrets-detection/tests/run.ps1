#Requires -Version 5.1
# run.ps1 — run all secrets-detection script fixture tests (PowerShell port of run.sh)
#
# Usage:
#   powershell -File .claude\skills\secrets-detection\tests\run.ps1
#   pwsh .claude/skills/secrets-detection/tests/run.ps1
#
# Mirrors run.sh: dot-sources helpers.ps1, then dot-sources every test_*.ps1
# in this directory so each can call Assert-LinePresent / Assert-LineAbsent
# and accumulate into $global:PassCount / $global:FailCount. Exits 1 if any
# assertion failed.

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
