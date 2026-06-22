#Requires -Version 5.1
# test_find_missing_pages.ps1 — fixture tests for find-missing-pages.ps1
#
# Fixture: two pages each link to [[existing-page]] (which exists) and
# [[ghost-page]] (which doesn't). Both links are referenced twice, so
# both clear the >=2 references threshold; only ghost-page is MISSING.
# Vault root contains a space (F1 mandatory case) — this script handles
# that correctly, so this is expected to PASS.

$Script = Join-Path $ScriptsDir "find-missing-pages.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path $wiki -Force | Out-Null

Set-Content -Path (Join-Path $wiki "page-a.md") -Encoding UTF8 -Value @'
# Page A

See [[existing-page]] and [[ghost-page]].
'@

Set-Content -Path (Join-Path $wiki "page-b.md") -Encoding UTF8 -Value @'
# Page B

Also [[existing-page]] and [[ghost-page]] again.
'@

Set-Content -Path (Join-Path $wiki "existing-page.md") -Encoding UTF8 -Value @'
# Existing Page
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "MISSING 2 [[ghost-page]]" $output `
  "find-missing-pages: flags a link referenced twice with no matching file"

Assert-LineAbsent "[[existing-page]]" $output `
  "find-missing-pages: does not flag a link that has a matching file"

Assert-LinePresent "SUMMARY 2 1" $output `
  "find-missing-pages: summary counts 2 unique links, 1 missing (vault path contains a space)"

Remove-Item -Recurse -Force $base
