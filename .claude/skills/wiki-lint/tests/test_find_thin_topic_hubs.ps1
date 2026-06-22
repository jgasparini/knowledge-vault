#Requires -Version 5.1
# test_find_thin_topic_hubs.ps1 — fixture tests for find-thin-topic-hubs.ps1
#
# Fixture: wiki/resources/topics/, four hubs covering each criterion:
#
#   thin-hub.md           status: stub, sources: [] (0 < 3), created 60 days
#                          ago -> THIN_HUB (all three thin-hub criteria met)
#   well-sourced-stub.md  status: stub, sources: 3 entries, created 60 days
#                          ago -> not flagged (sources count not < 3)
#   young-stub.md         status: stub, sources: [], created today
#                          -> not flagged (not yet 30 days old)
#   active-hub.md         status: active, sources: [], created 60 days ago
#                          -> not flagged (not status: stub)
#
# Total topic hubs checked: 4. Total thin: 1.
#
# A second fixture (no wiki/resources/topics/ directory at all) confirms
# SUMMARY 0 0.
#
# Vault root contains a space (F1 mandatory case).

$Script = Join-Path $ScriptsDir "find-thin-topic-hubs.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\topics") -Force | Out-Null

$today = Get-Date -Format "yyyy-MM-dd"
$sixtyDaysAgo = (Get-Date).AddDays(-60).ToString("yyyy-MM-dd")

Set-Content -Path (Join-Path $wiki "resources\topics\thin-hub.md") -Encoding UTF8 -Value @"
---
type: topic
status: stub
created: $sixtyDaysAgo
updated: $sixtyDaysAgo
tags: []
sources: []
---

# Thin Hub

## Overview
A narrow hub that hasn't gained traction.
"@

Set-Content -Path (Join-Path $wiki "resources\topics\well-sourced-stub.md") -Encoding UTF8 -Value @"
---
type: topic
status: stub
created: $sixtyDaysAgo
updated: $sixtyDaysAgo
tags: []
sources:
  - "[[source-a]]"
  - "[[source-b]]"
  - "[[source-c]]"
---

# Well Sourced Stub

## Overview
A stub with enough material to be worth expanding, not merging.
"@

Set-Content -Path (Join-Path $wiki "resources\topics\young-stub.md") -Encoding UTF8 -Value @"
---
type: topic
status: stub
created: $today
updated: $today
tags: []
sources: []
---

# Young Stub

## Overview
A brand-new hub that hasn't had time to gain sources yet.
"@

Set-Content -Path (Join-Path $wiki "resources\topics\active-hub.md") -Encoding UTF8 -Value @"
---
type: topic
status: active
created: $sixtyDaysAgo
updated: $sixtyDaysAgo
tags: []
sources: []
---

# Active Hub

## Overview
An established hub, regardless of its current source count.
"@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "THIN_HUB 0 60 resources/topics/thin-hub.md" $output `
  "find-thin-topic-hubs: flags a stub hub with <3 sources created 60 days ago"

Assert-LineAbsent "well-sourced-stub.md" $output `
  "find-thin-topic-hubs: does not flag a stub hub with 3+ sources"

Assert-LineAbsent "young-stub.md" $output `
  "find-thin-topic-hubs: does not flag a stub hub created less than 30 days ago"

Assert-LineAbsent "active-hub.md" $output `
  "find-thin-topic-hubs: does not flag a non-stub hub regardless of sources/age"

Assert-LinePresent "SUMMARY 4 1" $output `
  "find-thin-topic-hubs: summary counts 4 topic hubs checked, 1 thin (vault path contains a space)"

Remove-Item -Recurse -Force $base

# Second fixture: no wiki/resources/topics/ directory at all.
$base2 = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki2 = Join-Path $base2 "wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki2 "resources\concepts") -Force | Out-Null

$output2 = (& $Script $wiki2 | Out-String)

Assert-LinePresent "SUMMARY 0 0" $output2 `
  "find-thin-topic-hubs: missing wiki/resources/topics/ directory yields SUMMARY 0 0"

Remove-Item -Recurse -Force $base2
