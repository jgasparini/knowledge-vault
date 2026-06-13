#Requires -Version 5.1
# helpers.ps1 — shared assertion helpers for secrets-detection script fixture tests
#
# Dot-sourced by run.ps1 before each test_*.ps1 file. $global:PassCount and
# $global:FailCount accumulate across every dot-sourced test file.
#
# Standalone copy: this skill has no dependency on wiki-lint's helpers.ps1, so
# the skills/secrets-detection/ directory can be copied into other repos.

$global:PassCount = 0
$global:FailCount = 0

# Assert-LinePresent <expected_substring> <actual_output> <description>
function Assert-LinePresent {
    param(
        [string]$Needle,
        [string]$Haystack,
        [string]$Description
    )

    if ($Haystack.Contains($Needle)) {
        $global:PassCount++
        Write-Output "  PASS: $Description"
    } else {
        $global:FailCount++
        Write-Output "  FAIL: $Description"
        Write-Output "    expected line: $Needle"
        Write-Output "    --- actual output ---"
        ($Haystack -split "`r?`n") | ForEach-Object { Write-Output "    $_" }
    }
}

# Assert-LineAbsent <unexpected_substring> <actual_output> <description>
function Assert-LineAbsent {
    param(
        [string]$Needle,
        [string]$Haystack,
        [string]$Description
    )

    if ($Haystack.Contains($Needle)) {
        $global:FailCount++
        Write-Output "  FAIL: $Description"
        Write-Output "    unexpected match: $Needle"
        Write-Output "    --- actual output ---"
        ($Haystack -split "`r?`n") | ForEach-Object { Write-Output "    $_" }
    } else {
        $global:PassCount++
        Write-Output "  PASS: $Description"
    }
}

# Assert-Equal <expected> <actual> <description>
function Assert-Equal {
    param(
        [string]$Expected,
        [string]$Actual,
        [string]$Description
    )

    if ($Expected -eq $Actual) {
        $global:PassCount++
        Write-Output "  PASS: $Description"
    } else {
        $global:FailCount++
        Write-Output "  FAIL: $Description"
        Write-Output "    expected: $Expected"
        Write-Output "    actual:   $Actual"
    }
}

# Write-TestSummary — print the running PASS/FAIL totals. Does not return a
# value; callers should check $global:FailCount for the exit code.
function Write-TestSummary {
    Write-Output ""
    Write-Output "=== $global:PassCount passed, $global:FailCount failed ==="
}
