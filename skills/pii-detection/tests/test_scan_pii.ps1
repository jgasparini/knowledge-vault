#Requires -Version 5.1
# test_scan_pii.ps1 — fixture tests for scan-pii.ps1
#
# fixtures/<pattern-name>.txt each contain one fake-but-correctly-shaped
# match for that pattern from patterns.tsv. fixtures/clean.md has no
# matches.
#
# iban.txt legitimately trips more than one pattern (it also matches
# uk-nhs-number) — Assert-LinePresent only checks that the expected
# FINDING is among the output, not that it is the only one.

$Script = Join-Path $ScriptsDir "scan-pii.ps1"
$Fixtures = Join-Path $TestsDir "fixtures"

# --- one FINDING per pattern fixture ---
#
# Each fixture is named "<pattern-name>.txt".

$PatternNames = @(
    "uk-ni-number",
    "us-ssn",
    "credit-card-number",
    "uk-sort-code-account",
    "iban",
    "uk-nhs-number",
    "passport-number"
)

foreach ($pattern in $PatternNames) {
    $fixture = Join-Path $Fixtures "$pattern.txt"
    $output = (& $Script $fixture | Out-String)
    Assert-LinePresent "FINDING $pattern ${fixture}:" $output `
        "scan-pii: $pattern fixture is detected"
}

# --- clean.md has no matches ---

$cleanFixture = Join-Path $Fixtures "clean.md"
$cleanOutput = (& $Script $cleanFixture | Out-String)
$cleanExit = $LASTEXITCODE

Assert-LinePresent "SUMMARY 0" $cleanOutput `
    "scan-pii: clean.md reports SUMMARY 0"

Assert-Equal "0" "$cleanExit" `
    "scan-pii: clean.md exits 0"

# --- directory scan covers every fixture file ---

$dirOutput = (& $Script $Fixtures | Out-String)
$dirExit = $LASTEXITCODE

Assert-LinePresent "SUMMARY 8" $dirOutput `
    "scan-pii: scanning the fixtures directory finds all 8 matches"

Assert-Equal "1" "$dirExit" `
    "scan-pii: scanning a directory with findings exits 1"

# --- redact mode: uk-ni-number fixture ---

$redactTmp = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $redactTmp -Force | Out-Null
$redactTarget = Join-Path $redactTmp "uk-ni-number.txt"
Copy-Item (Join-Path $Fixtures "uk-ni-number.txt") $redactTarget

& $Script -Redact $redactTarget | Out-Null
$redactedContent = Get-Content $redactTarget | Out-String

Assert-LinePresent "[REDACTED:uk-ni-number]" $redactedContent `
    "scan-pii -Redact: uk-ni-number match is replaced with a placeholder"

$rescanOutput = (& $Script $redactTarget | Out-String)
Assert-LinePresent "SUMMARY 0" $rescanOutput `
    "scan-pii -Redact: re-scan of the redacted file is clean"

Remove-Item -Recurse -Force $redactTmp
