#Requires -Version 5.1
# lib.ps1 — shared frontmatter helpers for wiki-lint scripts
#
# Dot-sourced by find-orphans.ps1, check-index-drift.ps1, and others. Not
# meant to be run directly.

# Get-PageType <path> — return the value of the frontmatter `type:` field, or
# $null if the file has no frontmatter or no `type:` field.
function Get-PageType {
    param([string]$Path)
    $lines = Get-Content -Path $Path -ErrorAction SilentlyContinue
    if (-not $lines -or $lines[0] -ne '---') { return $null }
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq '---') { return $null }
        if ($lines[$i] -match '^type:\s*(.*)$') {
            return $Matches[1].Trim().Trim('"').Trim("'")
        }
    }
    return $null
}

# Test-ContentPage <path> — true if the file's frontmatter has a `type:` field.
# Raw source files (no frontmatter, or frontmatter without `type:`) are not
# content pages and are excluded here regardless of filename.
function Test-ContentPage {
    param([string]$Path)
    return [bool](Get-PageType -Path $Path)
}

# Test-LinkablePage <path> — true if the file is a content page (per
# Test-ContentPage) AND its `type:` is not `output` or `query`. outputs/
# working docs use an ad-hoc schema (see check-frontmatter.ps1's scope
# comment) and are not part of the linked wiki structure, so they are
# excluded from orphan and index-drift checks.
function Test-LinkablePage {
    param([string]$Path)
    $type = Get-PageType -Path $Path
    if (-not $type) { return $false }
    return ($type -ne 'output' -and $type -ne 'query')
}
