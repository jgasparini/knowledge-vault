#!/usr/bin/env bash
# test_find_orphans.sh — fixture tests for find-orphans.sh
#
# Fixture: 5 content pages.
#   page-popular  <- linked from page-a and page-b (2 inbound, NOT an orphan)
#   page-single   <- linked from page-a only (1 inbound, ORPHAN 1)
#   page-lonely   <- linked from nowhere (0 inbound, ORPHAN 0)
#   page-a        <- linked from page-b only (1 inbound, ORPHAN 1)
#   page-b        <- linked from nowhere (0 inbound, ORPHAN 0)
# INDEX.md is excluded as a navigation file.
# Vault root contains a space (F1 mandatory case) — this script quotes
# "$WIKI" correctly throughout, so this is expected to PASS.

SCRIPT="$SCRIPTS_DIR/find-orphans.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki"

cat > "$wiki/INDEX.md" <<'EOF'
# Index
EOF

cat > "$wiki/page-a.md" <<'EOF'
# Page A

[[page-popular]] [[page-single]]
EOF

cat > "$wiki/page-b.md" <<'EOF'
# Page B

[[page-popular]] [[page-a]]
EOF

cat > "$wiki/page-popular.md" <<'EOF'
# Page Popular
EOF

cat > "$wiki/page-single.md" <<'EOF'
# Page Single
EOF

cat > "$wiki/page-lonely.md" <<'EOF'
# Page Lonely
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

assert_line_present "SUMMARY 5 4" "$output" \
  "find-orphans: summary counts 5 pages checked, 4 orphans (vault path contains a space)"

rm -rf "$base"
