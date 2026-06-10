#!/usr/bin/env bash
# test_find_orphans.sh — fixture tests for find-orphans.sh
#
# Fixture: 6 content pages (each has `type:` frontmatter).
#   page-popular  <- linked from page-a and page-b (2 inbound, NOT an orphan)
#   page-single   <- linked from page-a only (1 inbound, ORPHAN 1)
#   page-lonely   <- linked from nowhere (0 inbound, ORPHAN 0)
#   page-a        <- linked from page-b only (1 inbound, ORPHAN 1)
#   page-b        <- linked from nowhere (0 inbound, ORPHAN 0)
#   "page extra"  <- space-named content page (has `type:` frontmatter),
#                     linked from nowhere -> ORPHAN 0, flagged not skipped (#38)
# INDEX.md is excluded as a navigation file.
#
# Also includes two raw sources (no frontmatter) that must be excluded from
# the content-page count entirely, regardless of filename (#38):
#   sources/raw-transcript.md   <- kebab-named raw source
#   sources/raw transcript.md   <- space-named raw source
#
# Vault root contains a space (F1 mandatory case) — this script quotes
# "$WIKI" correctly throughout, so this is expected to PASS.

SCRIPT="$SCRIPTS_DIR/find-orphans.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/sources"

cat > "$wiki/INDEX.md" <<'EOF'
# Index
EOF

cat > "$wiki/page-a.md" <<'EOF'
---
type: concept
---

# Page A

[[page-popular]] [[page-single]]
EOF

cat > "$wiki/page-b.md" <<'EOF'
---
type: concept
---

# Page B

[[page-popular]] [[page-a]]
EOF

cat > "$wiki/page-popular.md" <<'EOF'
---
type: concept
---

# Page Popular
EOF

cat > "$wiki/page-single.md" <<'EOF'
---
type: concept
---

# Page Single
EOF

cat > "$wiki/page-lonely.md" <<'EOF'
---
type: concept
---

# Page Lonely
EOF

cat > "$wiki/page extra.md" <<'EOF'
---
type: concept
---

# Page Extra

A misnamed (space-containing) content page with no inbound links.
EOF

cat > "$wiki/sources/raw-transcript.md" <<'EOF'
Raw transcript text, no frontmatter. Not a content page.
EOF

cat > "$wiki/sources/raw transcript.md" <<'EOF'
Raw transcript text with a space in its filename, no frontmatter. Not a content page.
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "ORPHAN 1 page-a.md" "$output" \
  "find-orphans: page-a has exactly one inbound link (from page-b)"

assert_line_present "ORPHAN 0 page-b.md" "$output" \
  "find-orphans: page-b has no inbound links"

assert_line_present "ORPHAN 0 page-lonely.md" "$output" \
  "find-orphans: page-lonely has no inbound links"

assert_line_absent "page-popular.md" "$output" \
  "find-orphans: page-popular has 2 inbound links and is not flagged"

assert_line_present "ORPHAN 1 page-single.md" "$output" \
  "find-orphans: page-single has exactly one inbound link"

assert_line_present "ORPHAN 0 page extra.md" "$output" \
  "find-orphans: a space-named content page with type: frontmatter is flagged, not skipped (#38)"

assert_line_absent "raw-transcript" "$output" \
  "find-orphans: a kebab-named raw source with no frontmatter is excluded entirely (#38)"

assert_line_absent "raw transcript" "$output" \
  "find-orphans: a space-named raw source with no frontmatter is excluded entirely (#38)"

assert_line_present "SUMMARY 6 5" "$output" \
  "find-orphans: summary counts 6 content pages checked, 5 orphans (raw sources excluded) (#38)"

rm -rf "$base"
