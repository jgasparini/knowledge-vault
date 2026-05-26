#Requires -Version 5.1
# check-index-drift.ps1 — detect pages missing from indexes, and broken index entries
#
# Usage:
#   .\check-index-drift.ps1 C:\path\to\vault\wiki
#   .\check-index-drift.ps1 C:\path\to\vault\wiki projects/ai-native-engineering
#
# Arguments:
#   $Wiki   Path to the wiki/ directory (required)
#   $Scope  Optional: relative path to a project folder (e.g. projects/ai-native-engineering)
#           When given, checks the project INDEX.md + root INDEX.md.
#           When omitted, checks all INDEX.md files against all content pages.
#
# Output:
#   NOT_INDEXED <relative_path>        — content file not found in any INDEX.md
#   BROKEN_ENTRY [link] in <index>    — INDEX.md entry with no corresponding file
# Final line:
#   SUMMARY not_indexed_count broken_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki,
    [Parameter(Mandatory=$false, Position=1)]
    [string]$Scope = ""
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

$navPattern = [regex]"[/\\](INDEX|QUESTIONS|CHANGELOG)\.md$"
$ignoreLink = [regex]"^(INDEX|QUESTIONS|CHANGELOG|page-name|concept-name|entity-name)$"
$linkRegex  = [regex]"\[\[([^\]]+)\]\]"

$results = [System.Collections.Generic.List[string]]::new()

# Pre-load all INDEX.md files
$allIndexFiles = Get-ChildItem -Path $Wiki -Recurse -Filter "INDEX.md" -ErrorAction SilentlyContinue

# ── Check 1: content pages not found in any INDEX.md ────────────────────────

$contentPages = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch ' ' -and $_.FullName -notmatch $navPattern } |
    Sort-Object FullName

foreach ($page in $contentPages) {
    $pagename = [System.IO.Path]::GetFileNameWithoutExtension($page.Name)
    $escaped  = [regex]::Escape($pagename)
    $pattern  = [regex]"\[\[([^\]|]*/)?${escaped}(\|[^\]]+)?\]\]"

    $found = $false
    foreach ($idx in $allIndexFiles) {
        $content = Get-Content -Path $idx.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($content -and $pattern.IsMatch($content)) {
            $found = $true
            break
        }
    }

    if (-not $found) {
        $relpath = ($page.FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'
        $results.Add("NOT_INDEXED $relpath")
    }
}

# ── Check 2: INDEX.md entries pointing to non-existent files ────────────────

if ($Scope) {
    $scopeNorm = $Scope -replace '/', '\'
    $checkIndexPaths = @(
        (Join-Path (Join-Path $Wiki $scopeNorm) "INDEX.md"),
        (Join-Path $Wiki "INDEX.md")
    )
    $checkIndexFiles = $checkIndexPaths | Where-Object { Test-Path $_ }
} else {
    $checkIndexFiles = $allIndexFiles | Select-Object -ExpandProperty FullName | Sort-Object
}

foreach ($indexfile in $checkIndexFiles) {
    if (-not (Test-Path $indexfile)) { continue }
    $relindex = ($indexfile.Substring($Wiki.Length + 1)) -replace '\\', '/'
    $content  = Get-Content -Path $indexfile -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($m in $linkRegex.Matches($content)) {
        $rawlink  = ($m.Groups[1].Value -replace '\|.*$', '').Trim()
        $linkname = $rawlink -replace '^.*[/\\]', ''
        if (-not $linkname) { $linkname = $rawlink }

        if ($ignoreLink.IsMatch($linkname)) { continue }

        $found = Get-ChildItem -Path $Wiki -Recurse -Filter "${linkname}.md" -ErrorAction SilentlyContinue |
            Select-Object -First 1

        if (-not $found -and ($rawlink -match '[/\\]')) {
            $rawlinkFixed = $rawlink -replace '/', '\'
            $found = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -like "*\${rawlinkFixed}.md" } |
                Select-Object -First 1
        }

        if (-not $found) {
            $results.Add("BROKEN_ENTRY [[$rawlink]] in $relindex")
        }
    }
}

$results | ForEach-Object { Write-Output $_ }

$notIndexed = @($results | Where-Object { $_ -match '^NOT_INDEXED' }).Count
$broken     = @($results | Where-Object { $_ -match '^BROKEN_ENTRY' }).Count

Write-Output "SUMMARY $notIndexed $broken"
