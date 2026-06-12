#Requires -Version 5.1
# find-thin-topic-hubs.ps1 — flag topic hubs that are still status: stub, have
# fewer than 3 sources, and were created N+ days ago (default 30)
#
# Usage:
#   powershell -File find-thin-topic-hubs.ps1 C:\path\to\vault\wiki [days_threshold]
#   .\find-thin-topic-hubs.ps1 C:\path\to\vault\wiki [30]
#
# Default threshold: 30 days (age measured from the `created` frontmatter date).
#
# Scans wiki/resources/topics/*.md. For each page whose frontmatter `type:` is
# `topic`, read `status`, `created`, and `sources`. A hub is flagged when:
#   - status is `stub`
#   - `sources` has fewer than 3 entries
#   - (today - created) in days >= days_threshold
#
# `sources:` may be an inline array (`sources: []` or `sources: [a, b]`) or a
# multi-line list (`sources:` followed by `  - "[[page]]"` lines); both forms
# are counted.
#
# output (one line per flagged hub):
#   THIN_HUB <sources_count> <days_old> <relative_path>
# Final line:
#   SUMMARY <hubs_checked> <thin_count>
#
# If wiki/resources/topics/ does not exist, output is just `SUMMARY 0 0`.

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki,
    [Parameter(Position=1)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$DaysThreshold = 30
)

$Wiki = (Get-Item $Wiki).FullName.TrimEnd('\', '/')

$today = Get-Date

# Get-Frontmatter <path> — return frontmatter lines (between the first two
# '---' lines) as a string array, or $null if the file has no frontmatter.
function Get-Frontmatter {
    param([string]$Path)
    $lines = Get-Content -Path $Path -ErrorAction SilentlyContinue
    if (-not $lines -or $lines[0] -ne '---') { return $null }
    $fm = [System.Collections.Generic.List[string]]::new()
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq '---') { return $fm }
        $fm.Add($lines[$i])
    }
    return $null
}

# Get-FieldValue <frontmatter lines> <field> — trimmed value of a top-level
# scalar field, or $null if absent.
function Get-FieldValue {
    param([string[]]$Lines, [string]$Field)
    foreach ($line in $Lines) {
        if ($line -match "^${Field}:\s*(.*)$") {
            return $matches[1].Trim().Trim('"').Trim("'")
        }
    }
    return $null
}

# Get-SourcesCount <frontmatter lines> — number of entries in `sources:`,
# whether inline (`sources: []` / `sources: [a, b]`) or a multi-line list.
function Get-SourcesCount {
    param([string[]]$Lines)
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -match '^sources:\s*\[(.*)\]\s*$') {
            $items = $matches[1] -replace '\s', ''
            if ($items -eq '') { return 0 }
            return ($items -split ',').Count
        }
        if ($Lines[$i] -match '^sources:\s*$') {
            $count = 0
            for ($j = $i + 1; $j -lt $Lines.Count; $j++) {
                if ($Lines[$j] -match '^\s*-\s') { $count++ }
                else { break }
            }
            return $count
        }
    }
    return 0
}

$topicsDir = Join-Path (Join-Path $Wiki "resources") "topics"

$results = [System.Collections.Generic.List[string]]::new()
$hubsChecked = 0
$thinCount = 0

if (Test-Path $topicsDir) {
    Get-ChildItem -Path $topicsDir -Filter "*.md" -ErrorAction SilentlyContinue |
        Sort-Object FullName |
        ForEach-Object {
            $file = $_
            $fm = Get-Frontmatter $file.FullName
            if (-not $fm) { return }

            $type = Get-FieldValue $fm "type"
            if ($type -ne "topic") { return }

            $hubsChecked++

            $status = Get-FieldValue $fm "status"
            if ($status -ne "stub") { return }

            $srcCount = Get-SourcesCount $fm
            if ($srcCount -ge 3) { return }

            $created = Get-FieldValue $fm "created"
            if (-not $created) { return }

            try {
                $createdDate = [datetime]::ParseExact($created, 'yyyy-MM-dd', $null)
            } catch {
                return
            }

            $daysOld = [math]::Floor(($today - $createdDate).TotalDays)
            if ($daysOld -ge $DaysThreshold) {
                $relPath = ($file.FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'
                $results.Add("THIN_HUB $srcCount $daysOld $relPath")
                $thinCount++
            }
        }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $hubsChecked $thinCount"
