#Requires -Version 5.1
# find-orphans.ps1 — find wiki pages with fewer than 2 inbound wikilinks
#
# Usage:
#   powershell -File find-orphans.ps1 C:\path\to\vault\wiki
#   .\find-orphans.ps1 C:\path\to\vault\wiki
#
# Always runs across the full wiki (inbound links must be checked globally).
#
# output (one line per orphan):
#   ORPHAN <inbound_count> <relative_path>
# Final line:
#   SUMMARY pages_checked orphan_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

$navPattern = [regex]"[/\\](INDEX|QUESTIONS|CHANGELOG)\.md$"

# Test-ContentPage <path> — true if the file's frontmatter has a `type:` field.
# Raw source files (no frontmatter, or frontmatter without `type:`) are not
# content pages and are excluded here regardless of filename.
function Test-ContentPage {
    param([string]$Path)
    $lines = Get-Content -Path $Path -ErrorAction SilentlyContinue
    if (-not $lines -or $lines[0] -ne '---') { return $false }
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq '---') { return $false }
        if ($lines[$i] -match '^type:') { return $true }
    }
    return $false
}

# Load all .md file contents once for efficiency
$allFiles = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue

$fileMap = @{}
foreach ($f in $allFiles) {
    $content = Get-Content -Path $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($content) { $fileMap[$f.FullName] = $content }
}

$contentPages = $allFiles |
    Where-Object { $_.FullName -notmatch $navPattern -and (Test-ContentPage $_.FullName) } |
    Sort-Object FullName

$total = 0
$orphanCount = 0
$results = [System.Collections.Generic.List[string]]::new()

foreach ($page in $contentPages) {
    $total++
    $pagename = [System.IO.Path]::GetFileNameWithoutExtension($page.Name)
    $escaped = [regex]::Escape($pagename)
    $pattern = [regex]"\[\[([^\]|]*/)?${escaped}(\|[^\]]+)?\]\]"

    $inbound = 0
    foreach ($kvp in $fileMap.GetEnumerator()) {
        if ($kvp.Key -eq $page.FullName) { continue }
        if ($pattern.IsMatch($kvp.Value)) { $inbound++ }
    }

    if ($inbound -lt 2) {
        $relpath = ($page.FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'
        $results.Add("ORPHAN $inbound $relpath")
        $orphanCount++
    }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $total $orphanCount"
