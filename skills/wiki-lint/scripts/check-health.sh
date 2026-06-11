#!/usr/bin/env bash
# check-health.sh — verify meta/health.md has valid lint- and consolidation-cadence
# tracking fields
#
# Usage:
#   bash check-health.sh /path/to/vault/wiki
#
# meta/health.md (a sibling of wiki/) tracks two cadences: wiki-ingest increments
# ingest-count and consolidation-count on each ingest. wiki-lint resets ingest-count
# and sets last-lint to today's date; wiki-consolidate resets consolidation-count and
# sets last-consolidation to today's date. This check flags drift in that mechanism
# itself — run it after updating meta/health.md at the end of a lint pass.
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
  consolidation_count=$(grep -m1 '^consolidation-count:' "$HEALTH" | sed -E 's/^consolidation-count:[[:space:]]*//')
  last_consolidation=$(grep -m1 '^last-consolidation:' "$HEALTH" | sed -E 's/^last-consolidation:[[:space:]]*//')

  if ! [[ "$ingest_count" =~ ^[0-9]+$ ]]; then
    echo "BAD_HEALTH ingest-count is not a non-negative integer: '$ingest_count'" >> "$tmpout"
  fi

  if [ -z "$last_lint" ]; then
    echo "BAD_HEALTH last-lint is empty" >> "$tmpout"
  fi

  if ! [[ "$consolidation_count" =~ ^[0-9]+$ ]]; then
    echo "BAD_HEALTH consolidation-count is not a non-negative integer: '$consolidation_count'" >> "$tmpout"
  fi

  if [ -z "$last_consolidation" ]; then
    echo "BAD_HEALTH last-consolidation is empty" >> "$tmpout"
  fi
fi

cat "$tmpout"
issues=$(wc -l < "$tmpout" | tr -d ' ')
rm -f "$tmpout"

echo "SUMMARY $issues"
