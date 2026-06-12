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

. (Join-Path $PSScriptRoot "lib.ps1")

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

$navPattern = [regex]"[/\\](INDEX|QUESTIONS|CHANGELOG)\.md$"

# Load all .md file contents once for efficiency
$allFiles = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue

$fileMap = @{}
foreach ($f in $allFiles) {
    $content = Get-Content -Path $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($content) { $fileMap[$f.FullName] = $content }
}

$contentPages = $allFiles |
    Where-Object { $_.FullName -notmatch $navPattern -and (Test-LinkablePage $_.FullName) } |
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
