#!/usr/bin/env bash
# check-index-drift.sh — detect pages missing from indexes, and broken index entries
#
# Usage:
#   bash check-index-drift.sh /path/to/vault/wiki
#   bash check-index-drift.sh /path/to/vault/wiki projects/ai-native-engineering
#
# Arguments:
#   $1  Path to the wiki/ directory (required)
#   $2  Optional: relative path to a project folder (e.g. projects/ai-native-engineering)
#       When given, checks the project INDEX.md + root INDEX.md.
#       When omitted, checks all INDEX.md files against all content pages.
#
# Output:
#   NOT_INDEXED <relative_path>        — content file not found in any INDEX.md
#   BROKEN_ENTRY [link] in <index>    — INDEX.md entry with no corresponding file
# Final line:
#   SUMMARY not_indexed_count broken_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki [project/subdir]}"
SCOPE="$2"

NAV_PATTERN="/(INDEX|QUESTIONS|CHANGELOG)\.md$"
IGNORE_LINK="^(INDEX|QUESTIONS|CHANGELOG|page-name|concept-name|entity-name)$"

tmpout=$(mktemp)

# ── Check 1: content pages not found in any INDEX.md ───────────────────────

while IFS= read -r page; do
  pagename=$(basename "$page" .md)

  found=$(grep -rl --include="INDEX.md" \
    -E "\[\[([^]|]*\/)?${pagename}(\|[^]]+)?\]\]" \
    "$WIKI" 2>/dev/null | head -1)

  if [ -z "$found" ]; then
    relpath="${page#"$WIKI/"}"
    echo "NOT_INDEXED $relpath" >> "$tmpout"
  fi

done < <(find "$WIKI" -name "*.md" ! -name "* *" | grep -vE "$NAV_PATTERN" | sort)

# ── Check 2: INDEX.md entries pointing to non-existent files ───────────────

if [ -n "$SCOPE" ]; then
  index_files="$WIKI/$SCOPE/INDEX.md $WIKI/INDEX.md"
else
  index_files=$(find "$WIKI" -name "INDEX.md" | sort)
fi

for indexfile in $index_files; do
  [ -f "$indexfile" ] || continue
  relindex="${indexfile#"$WIKI/"}"

  while IFS= read -r rawlink; do
    linkname=$(basename "$rawlink")

    # Skip navigation and placeholder links
    if echo "$linkname" | grep -qE "$IGNORE_LINK"; then
      continue
    fi

    found=$(find "$WIKI" -name "${linkname}.md" 2>/dev/null | head -1)
    if [ -z "$found" ] && echo "$rawlink" | grep -q "/"; then
      found=$(find "$WIKI" -path "*/${rawlink}.md" 2>/dev/null | head -1)
    fi

    if [ -z "$found" ]; then
      echo "BROKEN_ENTRY [[$rawlink]] in $relindex" >> "$tmpout"
    fi

  done < <(grep -oE "\[\[[^]]+\]\]" "$indexfile" 2>/dev/null \
    | sed 's/\[\[//; s/\]\]//' \
    | sed 's/|.*//' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
done

cat "$tmpout"

not_indexed=$(grep "^NOT_INDEXED" "$tmpout" | wc -l | tr -d ' ')
broken=$(grep "^BROKEN_ENTRY" "$tmpout" | wc -l | tr -d ' ')
rm -f "$tmpout"

echo "SUMMARY $not_indexed $broken"
