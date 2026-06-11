#Requires -Version 5.1
# find-duplicate-candidates.ps1 — find same-type concept/entity/topic pages
# whose filenames share 2 or more `-`-separated tokens
#
# Usage:
#   powershell -File find-duplicate-candidates.ps1 C:\path\to\vault\wiki
#   .\find-duplicate-candidates.ps1 C:\path\to\vault\wiki
#
# For each of wiki/resources/{concepts,entities,topics} independently: list
# content pages whose frontmatter `type:` matches the directory's expected
# type (concept/entity/topic respectively), tokenize each filename (minus
# .md) on `-` (skipping empty tokens from `--` or leading/trailing `-`), and
# for every pair within that directory whose token-set intersection has 2 or
# more members, emit a CANDIDATE line. Cross-type and cross-directory pairs
# are never compared.
#
# output (one line per candidate pair):
#   CANDIDATE <type> <path-a> <path-b> <shared-tokens-comma-separated>
# <path-a> and <path-b> are paths relative to $Wiki, in sorted order.
# <shared-tokens-comma-separated> lists the intersection in the order tokens
# appear in <path-a>'s filename.
# Final line:
#   SUMMARY pages_checked candidate_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

# Get-PageType <path> — return the frontmatter `type:` value (trimmed of
# whitespace and surrounding single/double quotes), or $null if the file has
# no frontmatter or no `type:` field.
function Get-PageType {
    param([string]$Path)
    $lines = Get-Content -Path $Path -ErrorAction SilentlyContinue
    if (-not $lines -or $lines[0] -ne '---') { return $null }
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq '---') { return $null }
        if ($lines[$i] -match '^type:\s*(.*)$') {
            return $matches[1].Trim().Trim('"').Trim("'")
        }
    }
    return $null
}

$dirTypes = [ordered]@{ concepts = 'concept'; entities = 'entity'; topics = 'topic' }

$results = [System.Collections.Generic.List[string]]::new()
$total = 0
$candidateCount = 0

foreach ($dir in $dirTypes.Keys) {
    $type = $dirTypes[$dir]
    $d = Join-Path (Join-Path $Wiki "resources") $dir
    if (-not (Test-Path $d)) { continue }

    $files = @(Get-ChildItem -Path $d -Filter "*.md" -ErrorAction SilentlyContinue |
        Where-Object { (Get-PageType $_.FullName) -eq $type } |
        Sort-Object FullName)

    $total += $files.Count

    $n = $files.Count
    for ($i = 0; $i -lt $n; $i++) {
        for ($j = $i + 1; $j -lt $n; $j++) {
            $relA = ($files[$i].FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'
            $relB = ($files[$j].FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'

            if ([string]::CompareOrdinal($relA, $relB) -gt 0) {
                $tmp = $relA; $relA = $relB; $relB = $tmp
            }

            $tokensA = @([System.IO.Path]::GetFileNameWithoutExtension($relA) -split '-' | Where-Object { $_ -ne '' })
            $tokensB = @([System.IO.Path]::GetFileNameWithoutExtension($relB) -split '-' | Where-Object { $_ -ne '' })

            $shared = [System.Collections.Generic.List[string]]::new()
            foreach ($t in $tokensA) {
                if ($tokensB -contains $t) { $shared.Add($t) }
            }

            if ($shared.Count -ge 2) {
                $sharedStr = $shared -join ','
                $results.Add("CANDIDATE $type $relA $relB $sharedStr")
                $candidateCount++
            }
        }
    }
}

$results | ForEach-Object { Write-Output $_ }
Write-Output "SUMMARY $total $candidateCount"
