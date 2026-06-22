#Requires -Version 5.1
# prune-questions.ps1 — flag QUESTIONS.md files with stale or excess closed items
#
# Usage:
#   powershell -File prune-questions.ps1 C:\path\to\vault\wiki [days_threshold]
#   .\prune-questions.ps1 C:\path\to\vault\wiki [30]
#
# Default threshold: 30 days (age measured from *raised YYYY-MM-DD* date).
#
# Output per flagged file:
#   OVERCROWDED <closed_count> <open_count> <relative_path>
#   OLD_CLOSED <old_item_count> <relative_path>
# Final line:
#   SUMMARY <files_checked> <files_flagged>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$WikiPath,
    [Parameter(Position=1)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$DaysThreshold = 30
)

$WikiPath = (Get-Item $WikiPath).FullName.TrimEnd('\', '/')

$today = Get-Date
$filesChecked = 0
$filesFlagged = 0
$results = [System.Collections.Generic.List[string]]::new()

Get-ChildItem -Path $WikiPath -Filter "QUESTIONS.md" -Recurse -ErrorAction SilentlyContinue |
    Sort-Object FullName |
    ForEach-Object {
        $file = $_
        $filesChecked++
        $flagged = $false
        $relPath = ($file.FullName.Substring($WikiPath.Length + 1)) -replace '\\', '/'

        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if (-not $content) { return }

        $lines = $content -split '\r?\n'

        # Count open and closed items
        $openCount = ($lines | Where-Object { $_ -match '^\- \[ \]' } | Measure-Object).Count
        $closedCount = ($lines | Where-Object { $_ -match '^\- \[x\]' } | Measure-Object).Count

        # Check for overcrowding
        if ($closedCount -gt $openCount) {
            $results.Add("OVERCROWDED $closedCount $openCount $relPath")
            $flagged = $true
        }

        # Check for old closed items
        $oldCount = 0
        $lines | Where-Object { $_ -match '^\- \[x\]' } | ForEach-Object {
            if ($_ -match '\*raised\s+(\d{4}-\d{2}-\d{2})\*') {
                $raisedDateStr = $Matches[1]
                try {
                    $raisedDate = [datetime]::ParseExact($raisedDateStr, 'yyyy-MM-dd', $null)
                    $daysOld = ($today - $raisedDate).Days
                    if ($daysOld -ge $DaysThreshold) {
                        $oldCount++
                    }
                }
                catch {
                    # Silently skip invalid dates
                }
            }
        }

        if ($oldCount -gt 0) {
            $results.Add("OLD_CLOSED $oldCount $relPath")
            $flagged = $true
        }

        if ($flagged) { $filesFlagged++ }
    }

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $filesChecked $filesFlagged"
