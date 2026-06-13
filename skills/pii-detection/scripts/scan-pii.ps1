#Requires -Version 5.1
# scan-pii.ps1 — pattern-based PII scanner (Windows)
#
# Usage:
#   powershell -File scan-pii.ps1 <path>
#   powershell -File scan-pii.ps1 -Redact <path>
#
# <path> may be a file or a directory. Mirrors scan-pii.sh: emits
# "FINDING <pattern-name> <file>:<line>" per match, never the matched value,
# then "SUMMARY <count>". Exit 0 if count is 0 (scan mode) or the redact
# rewrite succeeded (redact mode); exit 1 otherwise.

param(
    [switch]$Redact,
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PatternsFile = Join-Path $ScriptDir "patterns.tsv"

function Test-BinaryFile {
    param([string]$FilePath)

    $stream = [System.IO.File]::OpenRead($FilePath)
    try {
        $buffer = New-Object byte[] 8192
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        for ($i = 0; $i -lt $bytesRead; $i++) {
            if ($buffer[$i] -eq 0) {
                return $true
            }
        }
        return $false
    } finally {
        $stream.Close()
    }
}

if (Test-Path -LiteralPath $Path -PathType Leaf) {
    if (Test-BinaryFile $Path) {
        $Files = @()
    } else {
        $Files = @($Path)
    }
} elseif (Test-Path -LiteralPath $Path -PathType Container) {
    $Files = @(Get-ChildItem -LiteralPath $Path -Recurse -File -Force |
        Where-Object {
            $_.FullName -notmatch '[\\/]\.git[\\/]' -and
            $_.FullName -notmatch '[\\/]node_modules[\\/]'
        } |
        Where-Object { -not (Test-BinaryFile $_.FullName) } |
        ForEach-Object { $_.FullName })
} else {
    Write-Error "scan-pii: ${Path}: no such file or directory"
    exit 1
}

$PatternNames = @()
$PatternRegexes = @()
foreach ($line in Get-Content -LiteralPath $PatternsFile) {
    if ($line -eq "" -or $line.StartsWith("#")) { continue }
    $parts = $line -split "`t"
    if ($parts.Length -lt 2) { continue }
    $PatternNames += $parts[0]
    $PatternRegexes += $parts[1]
}

# Every pattern in patterns.tsv is single-line, so redaction is a plain
# per-pattern -creplace substitution — no multi-line block handling needed
# (unlike secrets-detection's private-key-block).
function Invoke-Redaction {
    param([string]$FilePath)

    $content = @(Get-Content -LiteralPath $FilePath)

    for ($i = 0; $i -lt $PatternNames.Length; $i++) {
        $name = $PatternNames[$i]
        $regex = $PatternRegexes[$i]
        $content = @($content | ForEach-Object { $_ -creplace $regex, "[REDACTED:$name]" })
    }

    Set-Content -LiteralPath $FilePath -Value $content -Encoding UTF8 -ErrorAction Stop
}

$FindingsCount = 0
foreach ($file in $Files) {
    $lines = @(Get-Content -LiteralPath $file)
    for ($i = 0; $i -lt $PatternNames.Length; $i++) {
        $name = $PatternNames[$i]
        $regex = $PatternRegexes[$i]
        for ($lineNo = 0; $lineNo -lt $lines.Length; $lineNo++) {
            if ($lines[$lineNo] -cmatch $regex) {
                Write-Output "FINDING $name ${file}:$($lineNo + 1)"
                $FindingsCount++
            }
        }
    }
}

$RedactError = $false
if ($Redact -and $FindingsCount -gt 0) {
    foreach ($file in $Files) {
        try {
            Invoke-Redaction -FilePath $file
        } catch {
            $RedactError = $true
        }
    }
}

Write-Output "SUMMARY $FindingsCount"

if ($Redact) {
    if ($RedactError) { exit 1 } else { exit 0 }
}

if ($FindingsCount -gt 0) { exit 1 }
exit 0
