#!/usr/bin/env bash
# test_check_enum_drift.sh — fixture tests for check-enum-drift.sh
#
# Fixture: a minimal vault with meta/CLAUDE.md and check-frontmatter.sh/.ps1
# mirrors for the 5 closed enums.
#   source-type, reliability, entity-kind, relationship — all three sources
#     agree (token order differs between sources, exercising the
#     order-independent comparison) -> not flagged
#   decay-rate — check-frontmatter.sh is missing a value present in
#     meta/CLAUDE.md and check-frontmatter.ps1 -> DRIFT
#
# Vault root contains a space, matching the rest of this fixture suite.

SCRIPT="$SCRIPTS_DIR/check-enum-drift.sh"

base=$(mktemp -d)
vault="$base/audit vault"
mkdir -p "$vault/meta" "$vault/.claude/skills/wiki-lint/scripts"

cat > "$vault/meta/CLAUDE.md" <<'EOF'
```yaml
---
type: source
source-type: article|paper|report|book-chapter|meeting|email|letter|video
reliability: primary|practitioner|secondary|speculative
---
```

```yaml
---
type: entity
entity-kind: person|company|tool|model|paper|research-group|standard|publication
---
```

```yaml
---
type: topic
decay-rate: fast|slow|stable
---
```

```yaml
---
type: person
relationship: colleague|stakeholder|external|vendor|peer
---
```
EOF

cat > "$vault/.claude/skills/wiki-lint/scripts/check-frontmatter.sh" <<'EOF'
PAGE_TYPES=" source concept entity topic project area person "
SOURCE_TYPES=" video letter email meeting book-chapter report paper article "
RELIABILITIES=" speculative secondary practitioner primary "
ENTITY_KINDS=" publication standard research-group paper model tool company person "
RELATIONSHIPS=" peer vendor external stakeholder colleague "
DECAY_RATES=" fast slow "
EOF

cat > "$vault/.claude/skills/wiki-lint/scripts/check-frontmatter.ps1" <<'EOF'
$sourceTypes = @('article', 'paper', 'report', 'book-chapter', 'meeting', 'email', 'letter', 'video')
$reliabilities = @('primary', 'practitioner', 'secondary', 'speculative')
$entityKinds = @('person', 'company', 'tool', 'model', 'paper', 'research-group', 'standard', 'publication')
$relationships = @('colleague', 'stakeholder', 'external', 'vendor', 'peer')
$decayRates = @('fast', 'slow', 'stable')
EOF

output=$(bash "$SCRIPT" "$vault")
exit_code=$?

assert_line_absent "DRIFT source-type" "$output" \
  "check-enum-drift: source-type matches across meta/sh/ps1 despite different orderings"

assert_line_absent "DRIFT reliability" "$output" \
  "check-enum-drift: reliability matches across meta/sh/ps1 despite different orderings"

assert_line_absent "DRIFT entity-kind" "$output" \
  "check-enum-drift: entity-kind matches across meta/sh/ps1 despite different orderings"

assert_line_absent "DRIFT relationship" "$output" \
  "check-enum-drift: relationship matches across meta/sh/ps1 despite different orderings"

assert_line_present "DRIFT decay-rate" "$output" \
  "check-enum-drift: flags decay-rate when check-frontmatter.sh is missing a value present in meta/CLAUDE.md and check-frontmatter.ps1"

assert_line_present "SUMMARY 5 1" "$output" \
  "check-enum-drift: summary counts 5 enums checked, 1 drifted"

if [ "$exit_code" -eq 1 ]; then
  PASS_COUNT=$((PASS_COUNT + 1))
  echo "  PASS: check-enum-drift: exits non-zero (1) when drift is found"
else
  FAIL_COUNT=$((FAIL_COUNT + 1))
  echo "  FAIL: check-enum-drift: exits non-zero (1) when drift is found (got $exit_code)"
fi

rm -rf "$base"
