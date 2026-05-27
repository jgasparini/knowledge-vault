#Requires -Version 5.1
# find-missing-pages.ps1 — find wikilinks that reference non-existent pages
#
# Usage:
#   powershell -File find-missing-pages.ps1 C:\path\to\vault\wiki
#   .\find-missing-pages.ps1 C:\path\to\vault\wiki
#
# Always runs across the full wiki. Project scoping is done by the lint skill.
#
# output (one line per missing page with 2+ references):
#   MISSING <ref_count> [[link-name]]
# Final line:
#   SUMMARY links_checked missing_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

$ignorePattern = [regex]"^(INDEX|QUESTIONS|CHANGELOG|page-name|concept-name|entity-name|source-name|topic-name|link|page|concept|entity)$"
$linkRegex     = [regex]"\[\[([^\]]+)\]\]"

# Count wikilink occurrences across all .md files
$linkCounts = @{}

$allFiles = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue
foreach ($f in $allFiles) {
    $content = Get-Content -Path $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($m in $linkRegex.Matches($content)) {
        $rawlink = ($m.Groups[1].Value -replace '\|.*$', '').Trim()
        if ($linkCounts.ContainsKey($rawlink)) {
            $linkCounts[$rawlink]++
        } else {
            $linkCounts[$rawlink] = 1
        }
    }
}

$total        = $linkCounts.Count
$missingCount = 0
$results      = [System.Collections.Generic.List[string]]::new()

foreach ($kvp in ($linkCounts.GetEnumerator() | Sort-Object Value -Descending)) {
    $rawlink = $kvp.Key
    $count   = $kvp.Value

    if ($count -lt 2) { continue }

    $linkname = $rawlink -replace '^.*[/\\]', ''
    if (-not $linkname) { $linkname = $rawlink }

    if ($ignorePattern.IsMatch($linkname)) { continue }

    $found = Get-ChildItem -Path $Wiki -Recurse -Filter "${linkname}.md" -ErrorAction SilentlyContinue |
        Select-Object -First 1

    # Also try full path match for links like [[projects/name/_overview]]
    if (-not $found -and ($rawlink -match '[/\\]')) {
        $rawlinkFixed = $rawlink -replace '/', '\'
        $found = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -like "*\${rawlinkFixed}.md" } |
            Select-Object -First 1
    }

    if (-not $found) {
        $results.Add("MISSING $count [[$rawlink]]")
        $missingCount++
    }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $total $missingCount"
