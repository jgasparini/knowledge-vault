#Requires -Version 5.1
# check-health.ps1 — verify meta/health.md has valid lint-cadence tracking fields
#
# Usage:
#   .\check-health.ps1 C:\path\to\vault\wiki
#
# meta/health.md (a sibling of wiki/) tracks lint cadence: wiki-ingest increments
# ingest-count on each ingest, and wiki-lint resets it and sets last-lint to today's
# date. This check flags drift in that mechanism itself — run it after updating
# meta/health.md at the end of a lint pass.
#
# output (one line per issue):
#   BAD_HEALTH <reason>
# Final line:
#   SUMMARY issue_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')
$healthPath = Join-Path (Split-Path $Wiki -Parent) "meta\health.md"

$results = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path $healthPath)) {
    $results.Add("BAD_HEALTH meta/health.md not found")
} else {
    $content = Get-Content -Path $healthPath -ErrorAction SilentlyContinue

    $ingestLine   = $content | Where-Object { $_ -match '^ingest-count:' } | Select-Object -First 1
    $lastLintLine = $content | Where-Object { $_ -match '^last-lint:' } | Select-Object -First 1

    $ingestCount = if ($ingestLine) { ($ingestLine -replace '^ingest-count:\s*', '').Trim() } else { '' }
    $lastLint    = if ($lastLintLine) { ($lastLintLine -replace '^last-lint:\s*', '').Trim() } else { '' }

    if ($ingestCount -notmatch '^[0-9]+$') {
        $results.Add("BAD_HEALTH ingest-count is not a non-negative integer: '$ingestCount'")
    }

    if (-not $lastLint) {
        $results.Add("BAD_HEALTH last-lint is empty")
    }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $($results.Count)"
