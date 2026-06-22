#!/usr/bin/env bash
# check-enum-drift.sh — verify the 5 closed enums defined in meta/CLAUDE.md
# Section 3 agree with their hardcoded mirrors in check-frontmatter.sh and
# check-frontmatter.ps1
#
# Usage:
#   bash check-enum-drift.sh /path/to/vault
#
# $1 is the vault root (containing meta/CLAUDE.md and .claude/skills/).
#
# For each of source-type, reliability, entity-kind, relationship, and
# decay-rate: compares the pipe-delimited enum in meta/CLAUDE.md's frontmatter
# template against the bash-array mirror in check-frontmatter.sh and the
# PowerShell-array mirror in check-frontmatter.ps1. All three must list the
# same set of values (order-independent). If meta/CLAUDE.md's schema changes,
# update both mirrors to match — this script is the guard that catches it if
# you forget.
#
# output (one line per drifted enum):
#   DRIFT <field> meta="<values>" sh="<values>" ps1="<values>"
# Final line:
#   SUMMARY enum_count drift_count
#
# Exit code: number of drifted enums (0 = all in sync).

VAULT="${1:?Usage: $0 /path/to/vault}"

META="$VAULT/meta/CLAUDE.md"
SH="$VAULT/.claude/skills/wiki-lint/scripts/check-frontmatter.sh"
PS1="$VAULT/.claude/skills/wiki-lint/scripts/check-frontmatter.ps1"

FIELDS=(source-type reliability entity-kind relationship decay-rate)
SH_VARS=(SOURCE_TYPES RELIABILITIES ENTITY_KINDS RELATIONSHIPS DECAY_RATES)
PS_VARS=(sourceTypes reliabilities entityKinds relationships decayRates)

# normalize — read tokens separated by whitespace, commas, pipes, or quotes
# from stdin and print them sorted and space-joined, for order-independent
# comparison across the three different source formats.
normalize() {
  tr "'\",|" '    ' | tr -s '[:space:]' '\n' | sed '/^$/d' | sort | tr '\n' ' ' | sed 's/ $//'
}

meta_values() {
  grep -E "^${1}:.*\|" "$META" | head -1 | sed -E "s/^${1}:[[:space:]]*//" | normalize
}

sh_values() {
  grep -E "^${1}=" "$SH" | head -1 | sed -E "s/^${1}=//" | normalize
}

ps_values() {
  grep -E '^\$'"${1}"' = @\(' "$PS1" | head -1 | sed -E 's/^\$'"${1}"' = @\(//; s/\)$//' | normalize
}

checked=0
drift=0

for i in "${!FIELDS[@]}"; do
  field="${FIELDS[$i]}"
  checked=$((checked + 1))

  meta_val=$(meta_values "$field")
  sh_val=$(sh_values "${SH_VARS[$i]}")
  ps_val=$(ps_values "${PS_VARS[$i]}")

  if [ "$meta_val" != "$sh_val" ] || [ "$meta_val" != "$ps_val" ]; then
    echo "DRIFT $field meta=\"$meta_val\" sh=\"$sh_val\" ps1=\"$ps_val\""
    drift=$((drift + 1))
  fi
done

echo "SUMMARY $checked $drift"
exit $drift
