#!/usr/bin/env bash
# find-thin-topic-hubs.sh — flag topic hubs that are still status: stub, have
# fewer than 3 sources, and were created N+ days ago (default 30)
#
# Usage:
#   bash find-thin-topic-hubs.sh /path/to/vault/wiki [days_threshold]
#
# Default threshold: 30 days (age measured from the `created` frontmatter date).
#
# Scans wiki/resources/topics/*.md. For each page whose frontmatter `type:` is
# `topic`, read `status`, `created`, and `sources`. A hub is flagged when:
#   - status is `stub`
#   - `sources` has fewer than 3 entries
#   - (today - created) in days >= days_threshold
#
# `sources:` may be an inline array (`sources: []` or `sources: [a, b]`) or a
# multi-line list (`sources:` followed by `  - "[[page]]"` lines); both forms
# are counted.
#
# output (one line per flagged hub):
#   THIN_HUB <sources_count> <days_old> <relative_path>
# Final line:
#   SUMMARY <hubs_checked> <thin_count>
#
# If wiki/resources/topics/ does not exist, output is just `SUMMARY 0 0`.

WIKI="${1:?Usage: $0 /path/to/vault/wiki [days_threshold]}"
while [[ "$WIKI" == */ ]]; do WIKI="${WIKI%/}"; done
THRESHOLD="${2:-30}"

if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "Error: days_threshold must be a non-negative integer" >&2
    exit 1
fi

today=$(date +%s)

# frontmatter <file> — print the lines of YAML frontmatter (between the first
# two '---' lines), or nothing if the file has no frontmatter block.
frontmatter() {
  awk '
    NR==1 { if ($0 != "---") exit; next }
    /^---$/ { exit }
    { print }
  ' "$1"
}

# field_value <frontmatter> <field> — print the value of a top-level scalar
# field, stripped of surrounding whitespace and quotes.
field_value() {
  printf '%s\n' "$1" | grep -m1 "^${2}:" \
    | sed -E "s/^${2}:[[:space:]]*//; s/[[:space:]]*\$//; s/^[\"']//; s/[\"']\$//"
}

# sources_count <frontmatter> — number of entries in the `sources:` field,
# whether inline (`sources: []` / `sources: [a, b]`) or a multi-line list
# (`sources:` followed by `  - item` lines).
sources_count() {
  local fm="$1" inline items
  inline=$(printf '%s\n' "$fm" | grep -m1 "^sources:")
  if [[ "$inline" =~ ^sources:[[:space:]]*\[(.*)\][[:space:]]*$ ]]; then
    items="${BASH_REMATCH[1]}"
    items=$(printf '%s' "$items" | tr -d '[:space:]')
    if [ -z "$items" ]; then
      echo 0
    else
      printf '%s' "$items" | awk -F',' '{print NF}'
    fi
    return
  fi
  printf '%s\n' "$fm" | awk '
    /^sources:[[:space:]]*$/ { found=1; next }
    found && /^[[:space:]]*-[[:space:]]/ { count++; next }
    found { exit }
    END { print count+0 }
  '
}

topics_dir="$WIKI/resources/topics"

hubs_checked=0
thin_count=0
tmpout=$(mktemp)

if [ -d "$topics_dir" ]; then
  while IFS= read -r file; do
    fm=$(frontmatter "$file")
    [ -z "$fm" ] && continue

    type=$(field_value "$fm" type)
    [ "$type" = "topic" ] || continue

    hubs_checked=$((hubs_checked + 1))

    status=$(field_value "$fm" status)
    [ "$status" = "stub" ] || continue

    src_count=$(sources_count "$fm")
    [ "$src_count" -lt 3 ] || continue

    created=$(field_value "$fm" created)
    [ -n "$created" ] || continue

    created_ts=$(date -j -f "%Y-%m-%d" "$created" +%s 2>/dev/null)
    [ -z "$created_ts" ] && created_ts=$(date -d "$created" +%s 2>/dev/null)
    [ -z "$created_ts" ] && continue

    days_old=$(( (today - created_ts) / 86400 ))
    if [ "$days_old" -ge "$THRESHOLD" ]; then
      relpath="${file#"$WIKI/"}"
      echo "THIN_HUB $src_count $days_old $relpath" >> "$tmpout"
      thin_count=$((thin_count + 1))
    fi
  done < <(find "$topics_dir" -name "*.md" | sort)
fi

cat "$tmpout"
rm -f "$tmpout"

echo "SUMMARY $hubs_checked $thin_count"
