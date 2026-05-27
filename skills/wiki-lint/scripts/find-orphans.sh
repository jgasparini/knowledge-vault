#!/usr/bin/env bash
# find-orphans.sh — find wiki pages with fewer than 2 inbound wikilinks
#
# Usage:
#   bash find-orphans.sh /path/to/vault/wiki
#
# Always runs across the full wiki (inbound links must be checked globally).
# Project scoping is done by the lint skill: run globally, filter results to
# pages listed in the project INDEX.md.
#
# output (one line per orphan):
#   ORPHAN <inbound_count> <relative_path>
# Final line:
#   SUMMARY pages_checked orphan_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki}"

# Files that are never content pages
NAV_PATTERN="/(INDEX|QUESTIONS|CHANGELOG)\.md$"

tmpout=$(mktemp)
total=0

while IFS= read -r page; do
  total=$((total + 1))
  pagename=$(basename "$page" .md)

  # Count distinct OTHER files that contain [[pagename]] (with optional path prefix or alias)
  inbound=$(grep -rl --include="*.md" \
    -E "\[\[([^]|]*\/)?${pagename}(\|[^]]+)?\]\]" \
    "$WIKI" 2>/dev/null \
    | grep -v "^${page}$" \
    | wc -l | tr -d ' ')

  if [ "$inbound" -lt 2 ]; then
    relpath="${page#"$WIKI/"}"
    echo "ORPHAN $inbound $relpath" >> "$tmpout"
  fi

done < <(find "$WIKI" -name "*.md" ! -name "* *" | grep -vE "$NAV_PATTERN" | sort)

cat "$tmpout"
orphan_count=$(wc -l < "$tmpout" | tr -d ' ')
rm -f "$tmpout"

echo "SUMMARY $total $orphan_count"
