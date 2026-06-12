#Requires -Version 5.1
# check-health.ps1 — verify meta/health.md has valid lint- and consolidation-cadence
# tracking fields
#
# Usage:
#   .\check-health.ps1 C:\path\to\vault\wiki
#
# meta/health.md (a sibling of wiki/) tracks two cadences: wiki-ingest increments
# ingest-count and consolidation-count on each ingest. wiki-lint resets ingest-count
# and sets last-lint to today's date; wiki-consolidate resets consolidation-count and
# sets last-consolidation to today's date. This check flags drift in that mechanism
# itself — run it after updating meta/health.md at the end of a lint pass.
#
# output (one line per issue):
#   BAD_HEALTH <reason>
# Final line:
#   SUMMARY issue_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Get-Item $Wiki).FullName.TrimEnd('\', '/')
$healthPath = Join-Path (Split-Path $Wiki -Parent) "meta\health.md"

$results = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path $healthPath)) {
    $results.Add("BAD_HEALTH meta/health.md not found")
} else {
    $content = Get-Content -Path $healthPath -ErrorAction SilentlyContinue

    $ingestLine         = $content | Where-Object { $_ -match '^ingest-count:' } | Select-Object -First 1
    $lastLintLine       = $content | Where-Object { $_ -match '^last-lint:' } | Select-Object -First 1
    $consolidationLine  = $content | Where-Object { $_ -match '^consolidation-count:' } | Select-Object -First 1
    $lastConsolidationLine = $content | Where-Object { $_ -match '^last-consolidation:' } | Select-Object -First 1

    $ingestCount        = if ($ingestLine) { ($ingestLine -replace '^ingest-count:\s*', '').Trim() } else { '' }
    $lastLint           = if ($lastLintLine) { ($lastLintLine -replace '^last-lint:\s*', '').Trim() } else { '' }
    $consolidationCount = if ($consolidationLine) { ($consolidationLine -replace '^consolidation-count:\s*', '').Trim() } else { '' }
    $lastConsolidation  = if ($lastConsolidationLine) { ($lastConsolidationLine -replace '^last-consolidation:\s*', '').Trim() } else { '' }

    if ($ingestCount -notmatch '^[0-9]+$') {
        $results.Add("BAD_HEALTH ingest-count is not a non-negative integer: '$ingestCount'")
    }

    if (-not $lastLint) {
        $results.Add("BAD_HEALTH last-lint is empty")
    }

    if ($consolidationCount -notmatch '^[0-9]+$') {
        $results.Add("BAD_HEALTH consolidation-count is not a non-negative integer: '$consolidationCount'")
    }

    if (-not $lastConsolidation) {
        $results.Add("BAD_HEALTH last-consolidation is empty")
    }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $($results.Count)"
