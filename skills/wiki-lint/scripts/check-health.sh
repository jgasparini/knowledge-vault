#!/usr/bin/env bash
# check-health.sh — verify meta/health.md has valid lint-cadence tracking fields
#
# Usage:
#   bash check-health.sh /path/to/vault/wiki
#
# meta/health.md (a sibling of wiki/) tracks lint cadence: wiki-ingest increments
# ingest-count on each ingest, and wiki-lint resets it and sets last-lint to today's
# date. This check flags drift in that mechanism itself — run it after updating
# meta/health.md at the end of a lint pass.
#
# output (one line per issue):
#   BAD_HEALTH <reason>
# Final line:
#   SUMMARY issue_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki}"
HEALTH="$(dirname "$WIKI")/meta/health.md"

tmpout=$(mktemp)

if [ ! -f "$HEALTH" ]; then
  echo "BAD_HEALTH meta/health.md not found" >> "$tmpout"
else
  ingest_count=$(grep -m1 '^ingest-count:' "$HEALTH" | sed -E 's/^ingest-count:[[:space:]]*//')
  last_lint=$(grep -m1 '^last-lint:' "$HEALTH" | sed -E 's/^last-lint:[[:space:]]*//')

  if ! [[ "$ingest_count" =~ ^[0-9]+$ ]]; then
    echo "BAD_HEALTH ingest-count is not a non-negative integer: '$ingest_count'" >> "$tmpout"
  fi

  if [ -z "$last_lint" ]; then
    echo "BAD_HEALTH last-lint is empty" >> "$tmpout"
  fi
fi

cat "$tmpout"
issues=$(wc -l < "$tmpout" | tr -d ' ')
rm -f "$tmpout"

echo "SUMMARY $issues"
