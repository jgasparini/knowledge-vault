#!/usr/bin/env bash
# test_check_frontmatter.sh — fixture tests for check-frontmatter.sh
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
# Vault root contains a space (F1 mandatory case) — this script quotes
# "$WIKI" correctly throughout, so this is expected to PASS.

SCRIPT="$SCRIPTS_DIR/check-frontmatter.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/resources/entities" "$wiki/projects/demo/sources" "$wiki/areas/demo/outputs" "$wiki/areas/demo/sources"

cat > "$wiki/INDEX.md" <<'EOF'
# Index
EOF

cat > "$wiki/resources/entities/bad-entity.md" <<'EOF'
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
EOF

cat > "$wiki/projects/demo/sources/good-source.md" <<'EOF'
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
EOF

cat > "$wiki/projects/demo/sources/missing-field-source.md" <<'EOF'
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
EOF

cat > "$wiki/areas/demo/outputs/some-output.md" <<'EOF'
---
type: output
created: 2026-01-01
---

# Some Output
EOF

cat > "$wiki/areas/demo/sources/web-clip.md" <<'EOF'
---
title: Some Article
source: https://example.com
author: Someone
---

# Web Clip
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "BAD_FRONTMATTER entity-kind organisation resources/entities/bad-entity.md" "$output" \
  "check-frontmatter: flags entity-kind value not in the Section 3 enum (vault path contains a space)"

assert_line_present "MISSING_FIELD project projects/demo/sources/missing-field-source.md" "$output" \
  "check-frontmatter: flags a required field missing from frontmatter"

assert_line_absent "good-source.md" "$output" \
  "check-frontmatter: a fully-conformant source page is not flagged"

assert_line_absent "some-output.md" "$output" \
  "check-frontmatter: type: output pages (outputs/ ad-hoc schema) are out of scope"

assert_line_absent "web-clip.md" "$output" \
  "check-frontmatter: web-clip frontmatter with no type: field is out of scope"

assert_line_present "SUMMARY 3 2" "$output" \
  "check-frontmatter: summary counts 3 in-scope pages, 2 violations (vault path contains a space)"

rm -rf "$base"
