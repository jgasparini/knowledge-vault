#Requires -Version 5.1
# test_check_frontmatter.ps1 — fixture tests for check-frontmatter.ps1
#
# Fixture:
#   resources/entities/bad-entity.md   <- type: entity, entity-kind: organisation
#                                          (not in the Section 3 enum) -> BAD_FRONTMATTER
#   projects/demo/sources/good-source.md
#                                       <- type: source, all required fields present
#                                          and valid -> no violations
#   projects/demo/sources/missing-field-source.md
#                                       <- type: source, missing `project:` field
#                                          -> MISSING_FIELD
#   areas/demo/outputs/some-output.md  <- type: output (not a Section 3 page type)
#                                          -> out of scope, not counted
#   areas/demo/sources/web-clip.md     <- web-clip frontmatter, no `type:` field
#                                          -> out of scope, not counted
#   INDEX.md                           <- no frontmatter -> out of scope
#
# Vault root contains a space (F1 mandatory case).

$Script = Join-Path $ScriptsDir "check-frontmatter.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\entities") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "projects\demo\sources") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "areas\demo\outputs") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "areas\demo\sources") -Force | Out-Null

Set-Content -Path (Join-Path $wiki "INDEX.md") -Encoding UTF8 -Value @'
# Index
'@

Set-Content -Path (Join-Path $wiki "resources\entities\bad-entity.md") -Encoding UTF8 -Value @'
---
type: entity
entity-kind: organisation
status: active
created: 2026-01-01
updated: 2026-01-01
tags: [test]
sources: []
---

# Bad Entity
'@

Set-Content -Path (Join-Path $wiki "projects\demo\sources\good-source.md") -Encoding UTF8 -Value @'
---
type: source
status: processed
created: 2026-01-01
tags: [test]
source-type: article
reliability: primary
origin: https://example.com
project: demo
---

# Good Source
'@

Set-Content -Path (Join-Path $wiki "projects\demo\sources\missing-field-source.md") -Encoding UTF8 -Value @'
---
type: source
status: processed
created: 2026-01-01
tags: [test]
source-type: article
reliability: primary
origin: https://example.com
---

# Missing Field Source
'@

Set-Content -Path (Join-Path $wiki "areas\demo\outputs\some-output.md") -Encoding UTF8 -Value @'
---
type: output
created: 2026-01-01
---

# Some Output
'@

Set-Content -Path (Join-Path $wiki "areas\demo\sources\web-clip.md") -Encoding UTF8 -Value @'
---
title: Some Article
source: https://example.com
author: Someone
---

# Web Clip
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "BAD_FRONTMATTER entity-kind organisation resources/entities/bad-entity.md" $output `
  "check-frontmatter: flags entity-kind value not in the Section 3 enum (vault path contains a space)"

Assert-LinePresent "MISSING_FIELD project projects/demo/sources/missing-field-source.md" $output `
  "check-frontmatter: flags a required field missing from frontmatter"

Assert-LineAbsent "good-source.md" $output `
  "check-frontmatter: a fully-conformant source page is not flagged"

Assert-LineAbsent "some-output.md" $output `
  "check-frontmatter: type: output pages (outputs/ ad-hoc schema) are out of scope"

Assert-LineAbsent "web-clip.md" $output `
  "check-frontmatter: web-clip frontmatter with no type: field is out of scope"

Assert-LinePresent "SUMMARY 3 2" $output `
  "check-frontmatter: summary counts 3 in-scope pages, 2 violations (vault path contains a space)"

Remove-Item -Recurse -Force $base
