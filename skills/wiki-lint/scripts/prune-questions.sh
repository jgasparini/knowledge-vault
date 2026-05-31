#!/usr/bin/env bash
# prune-questions.sh — flag QUESTIONS.md files with stale or excess closed items
#
# Usage:
#   bash prune-questions.sh /path/to/vault/wiki [days_threshold]
#
# Default threshold: 30 days (age measured from *raised YYYY-MM-DD* date).
#
# Output per flagged file:
#   OVERCROWDED <closed_count> <open_count> <relative_path>
#   OLD_CLOSED  <old_item_count> <relative_path>
# Final line:
#   SUMMARY <files_checked> <files_flagged>

WIKI="${1:?Usage: $0 /path/to/vault/wiki [days_threshold]}"
WIKI="${WIKI%/}"
THRESHOLD="${2:-30}"

if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "Error: days_threshold must be a non-negative integer" >&2
    exit 1
fi

today=$(date +%s)

files_checked=0
files_flagged=0

while IFS= read -r file; do
    files_checked=$((files_checked + 1))
    flagged=0
    relpath="${file#"$WIKI/"}"

    open_count=$(grep -c '^- \[ \]' "$file" 2>/dev/null); open_count=${open_count:-0}
    closed_count=$(grep -c '^- \[x\]' "$file" 2>/dev/null); closed_count=${closed_count:-0}

    if [ "$closed_count" -gt "$open_count" ]; then
        echo "OVERCROWDED $closed_count $open_count $relpath"
        flagged=1
    fi

    old_count=0
    while IFS= read -r line; do
        if [[ "$line" =~ \*raised[[:space:]]([0-9]{4}-[0-9]{2}-[0-9]{2})\* ]]; then
            raised_date="${BASH_REMATCH[1]}"
            raised_ts=$(date -j -f "%Y-%m-%d" "$raised_date" +%s 2>/dev/null)
            [ -z "$raised_ts" ] && raised_ts=$(date -d "$raised_date" +%s 2>/dev/null)
            if [ -n "$raised_ts" ]; then
                days_old=$(( (today - raised_ts) / 86400 ))
                if [ "$days_old" -ge "$THRESHOLD" ]; then
                    old_count=$((old_count + 1))
                fi
            fi
        fi
    done < <(grep '^- \[x\]' "$file" 2>/dev/null)

    if [ "$old_count" -gt 0 ]; then
        echo "OLD_CLOSED $old_count $relpath"
        flagged=1
    fi

    files_flagged=$((files_flagged + flagged))
done < <(find "$WIKI" -name "QUESTIONS.md" | sort)

echo "SUMMARY $files_checked $files_flagged"
