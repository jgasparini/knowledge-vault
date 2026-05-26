#!/usr/bin/env bash
# find-missing-pages.sh — find wikilinks that reference non-existent pages
#
# Usage:
#   bash find-missing-pages.sh /path/to/vault/wiki
#
# Always runs across the full wiki. Project scoping is done by the lint skill.
#
# Output (one line per missing page with 2+ references):
#   MISSING <ref_count> [[link-name]]
# Final line:
#   SUMMARY links_checked missing_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki}"

# Wikilinks to always ignore (navigation files, template placeholders)
IGNORE_PATTERN="^(INDEX|QUESTIONS|CHANGELOG|page-name|concept-name|entity-name|source-name|topic-name|link|page|concept|entity)$"

tmplinks=$(mktemp)
tmpout=$(mktemp)

# Extract all [[wikilinks]] from all wiki .md files, strip aliases, count occurrences
grep -roh --include="*.md" -E "\[\[[^]]+\]\]" "$WIKI" 2>/dev/null \
  | sed 's/^[^[]*\[\[//; s/\]\]$//' \
  | sed 's/|.*//' \
  | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
  | sort | uniq -c | sort -rn > "$tmplinks"

total=$(wc -l < "$tmplinks" | tr -d ' ')

while read -r count rawlink; do
  linkname=$(basename "$rawlink")

  # Skip ignored patterns
  if echo "$linkname" | grep -qE "$IGNORE_PATTERN"; then
    continue
  fi

  # Only flag if referenced 2 or more times
  if [ "$count" -lt 2 ]; then
    continue
  fi

  # Check if a file exists anywhere in wiki/ matching this page name
  found=$(find "$WIKI" -name "${linkname}.md" 2>/dev/null | head -1)

  # Also try full path match for links like [[projects/name/_overview]]
  if [ -z "$found" ] && echo "$rawlink" | grep -q "/"; then
    found=$(find "$WIKI" -path "*/${rawlink}.md" 2>/dev/null | head -1)
  fi

  if [ -z "$found" ]; then
    echo "MISSING $count [[$rawlink]]" >> "$tmpout"
  fi

done < "$tmplinks"

cat "$tmpout"
missing_count=$(wc -l < "$tmpout" | tr -d ' ')
rm -f "$tmplinks" "$tmpout"

echo "SUMMARY $total $missing_count"
