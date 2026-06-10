#Requires -Version 5.1
# check-frontmatter.ps1 — validate page frontmatter against meta/CLAUDE.md Section 3
#
# Usage:
#   powershell -File check-frontmatter.ps1 C:\path\to\vault\wiki
#   .\check-frontmatter.ps1 C:\path\to\vault\wiki
#
# Scope: only pages whose frontmatter `type:` is one of the seven Section 3 page
# types (source, concept, entity, topic, project, area, person) are validated.
# Pages with no `type:` field (raw sources, web-clip imports with non-schema
# frontmatter) or a `type:` outside this set (e.g. output, query — outputs/
# working docs use an ad-hoc schema, not Section 3) are out of scope and skipped.
#
# Enums and required fields below are hardcoded from meta/CLAUDE.md Section 3
# as of 2026-06-10. If that schema changes, update this script to match.
#
# output (one line per violation):
#   BAD_FRONTMATTER <field> <value> <relative_path>
#   MISSING_FIELD <field> <relative_path>
# Final line:
#   SUMMARY pages_checked violation_count

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Wiki
)

$Wiki = (Resolve-Path $Wiki).Path.TrimEnd('\', '/')

$pageTypes = @('source', 'concept', 'entity', 'topic', 'project', 'area', 'person')
$sourceTypes = @('article', 'paper', 'report', 'book-chapter', 'meeting', 'email', 'letter', 'video')
$reliabilities = @('primary', 'practitioner', 'secondary', 'speculative')
$entityKinds = @('person', 'company', 'tool', 'model', 'paper', 'research-group', 'standard', 'publication')
$relationships = @('colleague', 'stakeholder', 'external', 'vendor', 'peer')
$decayRates = @('fast', 'slow', 'stable')

$requiredFields = @{
    source  = @('status', 'created', 'tags', 'source-type', 'reliability', 'origin', 'project')
    concept = @('status', 'created', 'updated', 'tags', 'sources')
    entity  = @('entity-kind', 'status', 'created', 'updated', 'tags', 'sources')
    topic   = @('status', 'created', 'updated', 'tags', 'sources')
    project = @('status', 'created', 'updated', 'tags', 'goal', 'deadline', 'stakeholders', 'review-date')
    area    = @('status', 'created', 'updated', 'tags')
    person  = @('status', 'created', 'tags', 'organisation', 'role', 'relationship', 'last-contact')
}

$validStatus = @{
    source  = @('processed', 'stub')
    concept = @('stub', 'active', 'evergreen')
    entity  = @('stub', 'active', 'evergreen')
    topic   = @('stub', 'active', 'evergreen')
    project = @('active', 'on-hold', 'complete', 'archived')
    area    = @('active', 'archived')
    person  = @('active', 'archived')
}

# Get-Frontmatter <lines> — return the lines of YAML frontmatter (between the
# first two '---' lines), or $null if the file has no frontmatter block.
function Get-Frontmatter {
    param([string[]]$Lines)

    if ($Lines.Count -eq 0 -or $Lines[0] -ne '---') { return $null }

    $end = -1
    for ($i = 1; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -eq '---') { $end = $i; break }
    }
    if ($end -eq -1) { return $null }

    return $Lines[1..($end - 1)]
}

# Get-FieldValue <fmLines> <field> — value of a top-level field, stripped of
# surrounding whitespace and quotes. $null if the field is absent.
function Get-FieldValue {
    param([string[]]$FmLines, [string]$Field)

    $pattern = [regex]("^" + [regex]::Escape($Field) + ":\s*(.*)$")
    foreach ($line in $FmLines) {
        $m = $pattern.Match($line)
        if ($m.Success) {
            return $m.Groups[1].Value.Trim().Trim('"').Trim("'")
        }
    }
    return $null
}

# Test-HasField <fmLines> <field>
function Test-HasField {
    param([string[]]$FmLines, [string]$Field)

    $pattern = [regex]("^" + [regex]::Escape($Field) + ":")
    foreach ($line in $FmLines) {
        if ($pattern.IsMatch($line)) { return $true }
    }
    return $false
}

$results = [System.Collections.Generic.List[string]]::new()
$checked = 0

$allFiles = Get-ChildItem -Path $Wiki -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
    Sort-Object FullName

foreach ($page in $allFiles) {
    $raw = Get-Content -Path $page.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $raw) { continue }
    $content = $raw -split "`r?`n"

    $fm = Get-Frontmatter -Lines $content
    if (-not $fm) { continue }

    $type = Get-FieldValue -FmLines $fm -Field 'type'
    if (-not $type -or $pageTypes -notcontains $type) { continue }

    $checked++
    $relpath = ($page.FullName.Substring($Wiki.Length + 1)) -replace '\\', '/'

    foreach ($field in $requiredFields[$type]) {
        if (-not (Test-HasField -FmLines $fm -Field $field)) {
            $results.Add("MISSING_FIELD $field $relpath")
        }
    }

    $status = Get-FieldValue -FmLines $fm -Field 'status'
    if ($status -and ($validStatus[$type] -notcontains $status)) {
        $results.Add("BAD_FRONTMATTER status $status $relpath")
    }

    if ($type -eq 'source') {
        $sourceType = Get-FieldValue -FmLines $fm -Field 'source-type'
        if ($sourceType -and ($sourceTypes -notcontains $sourceType)) {
            $results.Add("BAD_FRONTMATTER source-type $sourceType $relpath")
        }

        $reliability = Get-FieldValue -FmLines $fm -Field 'reliability'
        if ($reliability -and ($reliabilities -notcontains $reliability)) {
            $results.Add("BAD_FRONTMATTER reliability $reliability $relpath")
        }
    }

    if ($type -eq 'entity') {
        $entityKind = Get-FieldValue -FmLines $fm -Field 'entity-kind'
        if ($entityKind -and ($entityKinds -notcontains $entityKind)) {
            $results.Add("BAD_FRONTMATTER entity-kind $entityKind $relpath")
        }
    }

    if ($type -eq 'person') {
        $relationship = Get-FieldValue -FmLines $fm -Field 'relationship'
        if ($relationship -and ($relationships -notcontains $relationship)) {
            $results.Add("BAD_FRONTMATTER relationship $relationship $relpath")
        }
    }

    if ($type -eq 'topic') {
        $decayRate = Get-FieldValue -FmLines $fm -Field 'decay-rate'
        if ($decayRate -and ($decayRates -notcontains $decayRate)) {
            $results.Add("BAD_FRONTMATTER decay-rate $decayRate $relpath")
        }
    }
}

$results | ForEach-Object { Write-Output $_ }

Write-Output "SUMMARY $checked $($results.Count)"
