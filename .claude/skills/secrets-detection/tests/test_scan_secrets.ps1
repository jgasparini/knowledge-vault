#Requires -Version 5.1
# test_scan_secrets.ps1 — fixture tests for scan-secrets.ps1
#
# fixtures/<pattern-name>.* each contain one fake-but-correctly-shaped match
# for that pattern from patterns.tsv. fixtures/clean.md has no matches.
#
# Some fixtures legitimately trip more than one pattern (e.g.
# aws-secret-access-key.txt also matches generic-credential-assignment) —
# Assert-LinePresent only checks that the expected FINDING is among the
# output, not that it is the only one.

$Script = Join-Path $ScriptsDir "scan-secrets.ps1"
$Fixtures = Join-Path $TestsDir "fixtures"

# --- one FINDING per pattern fixture ---
#
# Each fixture is named "<pattern-name>.txt".

$PatternNames = @(
    "private-key-block",
    "aws-access-key-id",
    "aws-secret-access-key",
    "jwt",
    "github-token",
    "github-fine-grained-pat",
    "slack-token",
    "slack-webhook-url",
    "google-api-key",
    "stripe-live-key",
    "connection-string-credential",
    "generic-credential-assignment"
)

foreach ($pattern in $PatternNames) {
    $fixture = Join-Path $Fixtures "$pattern.txt"
    $output = (& $Script $fixture | Out-String)
    Assert-LinePresent "FINDING $pattern ${fixture}:" $output `
        "scan-secrets: $pattern fixture is detected"
}

# --- clean.md has no matches ---

$cleanFixture = Join-Path $Fixtures "clean.md"
$cleanOutput = (& $Script $cleanFixture | Out-String)
$cleanExit = $LASTEXITCODE

Assert-LinePresent "SUMMARY 0" $cleanOutput `
    "scan-secrets: clean.md reports SUMMARY 0"

Assert-Equal "0" "$cleanExit" `
    "scan-secrets: clean.md exits 0"

# --- directory scan covers every fixture file ---

$dirOutput = (& $Script $Fixtures | Out-String)
$dirExit = $LASTEXITCODE

Assert-LinePresent "SUMMARY 14" $dirOutput `
    "scan-secrets: scanning the fixtures directory finds all 14 matches"

Assert-Equal "1" "$dirExit" `
    "scan-secrets: scanning a directory with findings exits 1"

# --- redact mode: simple single-line pattern ---

$redactTmp = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $redactTmp -Force | Out-Null
$redactTarget = Join-Path $redactTmp "aws-access-key-id.txt"
Copy-Item (Join-Path $Fixtures "aws-access-key-id.txt") $redactTarget

& $Script -Redact $redactTarget | Out-Null
$redactedContent = Get-Content $redactTarget | Out-String

Assert-LinePresent "[REDACTED:aws-access-key-id]" $redactedContent `
    "scan-secrets -Redact: aws-access-key-id match is replaced with a placeholder"

$rescanOutput = (& $Script $redactTarget | Out-String)
Assert-LinePresent "SUMMARY 0" $rescanOutput `
    "scan-secrets -Redact: re-scan of the redacted file is clean"

Remove-Item -Recurse -Force $redactTmp

# --- redact mode: private-key-block collapses to a single line ---

$pkTmp = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $pkTmp -Force | Out-Null
$pkTarget = Join-Path $pkTmp "private-key-block.txt"
Copy-Item (Join-Path $Fixtures "private-key-block.txt") $pkTarget

& $Script -Redact $pkTarget | Out-Null
$pkLines = @(Get-Content $pkTarget)
$pkRedactedContent = $pkLines | Out-String

Assert-LinePresent "[REDACTED:private-key-block]" $pkRedactedContent `
    "scan-secrets -Redact: private-key-block is replaced with a placeholder"

Assert-Equal "3" "$($pkLines.Length)" `
    "scan-secrets -Redact: the 4-line BEGIN/END block collapses to 1 line (6 -> 3 lines total)"

$pkRescanOutput = (& $Script $pkTarget | Out-String)
Assert-LinePresent "SUMMARY 0" $pkRescanOutput `
    "scan-secrets -Redact: re-scan of the redacted private key file is clean"

Remove-Item -Recurse -Force $pkTmp
