#Requires -Version 5.1
# helpers.ps1 — shared assertion helpers for wiki-lint script fixture tests
#
# Dot-sourced by run.ps1 before each test_*.ps1 file. $global:PassCount and
# $global:FailCount accumulate across every dot-sourced test file.

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

# Write-TestSummary — print the running PASS/FAIL totals. Does not return a
# value; callers should check $global:FailCount for the exit code.
function Write-TestSummary {
    Write-Output ""
    Write-Output "=== $global:PassCount passed, $global:FailCount failed ==="
}
