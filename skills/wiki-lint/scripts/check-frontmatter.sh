#!/usr/bin/env bash
# check-frontmatter.sh — validate page frontmatter against meta/CLAUDE.md Section 3
#
# Usage:
#   bash check-frontmatter.sh /path/to/vault/wiki
#
# Scope: only pages whose frontmatter `type:` is one of the seven Section 3 page
# types (source, concept, entity, topic, project, area, person) are validated.
# Pages with no `type:` field (raw sources, web-clip imports with non-schema
# frontmatter) or a `type:` outside this set (e.g. output, query — outputs/
# working docs use an ad-hoc schema, not Section 3) are out of scope and skipped.
#
# Enums and required fields below are hardcoded from meta/CLAUDE.md Section 3
# as of 2026-06-10. If that schema changes, update this script to match.
#
# output (one line per violation):
#   BAD_FRONTMATTER <field> <value> <relative_path>
#   MISSING_FIELD <field> <relative_path>
# Final line:
#   SUMMARY pages_checked violation_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki}"

PAGE_TYPES=" source concept entity topic project area person "
SOURCE_TYPES=" article paper report book-chapter meeting email letter video "
RELIABILITIES=" primary practitioner secondary speculative "
ENTITY_KINDS=" person company tool model paper research-group standard publication "
RELATIONSHIPS=" colleague stakeholder external vendor peer "
DECAY_RATES=" fast slow stable "

# frontmatter <file> — print the lines of YAML frontmatter (between the first
# two '---' lines), or nothing if the file has no frontmatter block.
frontmatter() {
  awk '
    NR==1 { if ($0 != "---") exit; next }
    /^---$/ { exit }
    { print }
  ' "$1"
}

# field_value <frontmatter> <field> — print the value of a top-level field,
# stripped of surrounding whitespace and quotes.
field_value() {
  printf '%s\n' "$1" | grep -m1 "^${2}:" \
    | sed -E "s/^${2}:[[:space:]]*//; s/[[:space:]]*\$//; s/^[\"']//; s/[\"']\$//"
}

# has_field <frontmatter> <field>
has_field() {
  printf '%s\n' "$1" | grep -q "^${2}:"
}

tmpout=$(mktemp)
checked=0

while IFS= read -r page; do
  fm=$(frontmatter "$page")
  [ -z "$fm" ] && continue

  type=$(field_value "$fm" type)

  case "$PAGE_TYPES" in
    *" $type "*) ;;
    *) continue ;;
  esac

  checked=$((checked + 1))
  relpath="${page#"$WIKI/"}"

  case "$type" in
    source)  required="status created tags source-type reliability origin project" ;;
    concept) required="status created updated tags sources" ;;
    entity)  required="entity-kind status created updated tags sources" ;;
    topic)   required="status created updated tags sources" ;;
    project) required="status created updated tags goal deadline stakeholders review-date" ;;
    area)    required="status created updated tags" ;;
    person)  required="status created tags organisation role relationship last-contact" ;;
  esac

  for field in $required; do
    has_field "$fm" "$field" || echo "MISSING_FIELD $field $relpath" >> "$tmpout"
  done

  status=$(field_value "$fm" status)
  case "$type" in
    source)               valid_status=" processed stub " ;;
    concept|entity|topic) valid_status=" stub active evergreen " ;;
    project)              valid_status=" active on-hold complete archived " ;;
    area|person)          valid_status=" active archived " ;;
  esac
  if [ -n "$status" ]; then
    case "$valid_status" in
      *" $status "*) ;;
      *) echo "BAD_FRONTMATTER status $status $relpath" >> "$tmpout" ;;
    esac
  fi

  if [ "$type" = "source" ]; then
    source_type=$(field_value "$fm" source-type)
    if [ -n "$source_type" ]; then
      case "$SOURCE_TYPES" in
        *" $source_type "*) ;;
        *) echo "BAD_FRONTMATTER source-type $source_type $relpath" >> "$tmpout" ;;
      esac
    fi

    reliability=$(field_value "$fm" reliability)
    if [ -n "$reliability" ]; then
      case "$RELIABILITIES" in
        *" $reliability "*) ;;
        *) echo "BAD_FRONTMATTER reliability $reliability $relpath" >> "$tmpout" ;;
      esac
    fi
  fi

  if [ "$type" = "entity" ]; then
    entity_kind=$(field_value "$fm" entity-kind)
    if [ -n "$entity_kind" ]; then
      case "$ENTITY_KINDS" in
        *" $entity_kind "*) ;;
        *) echo "BAD_FRONTMATTER entity-kind $entity_kind $relpath" >> "$tmpout" ;;
      esac
    fi
  fi

  if [ "$type" = "person" ]; then
    relationship=$(field_value "$fm" relationship)
    if [ -n "$relationship" ]; then
      case "$RELATIONSHIPS" in
        *" $relationship "*) ;;
        *) echo "BAD_FRONTMATTER relationship $relationship $relpath" >> "$tmpout" ;;
      esac
    fi
  fi

  if [ "$type" = "topic" ]; then
    decay_rate=$(field_value "$fm" decay-rate)
    if [ -n "$decay_rate" ]; then
      case "$DECAY_RATES" in
        *" $decay_rate "*) ;;
        *) echo "BAD_FRONTMATTER decay-rate $decay_rate $relpath" >> "$tmpout" ;;
      esac
    fi
  fi

done < <(find "$WIKI" -name "*.md" | sort)

cat "$tmpout"
violations=$(wc -l < "$tmpout" | tr -d ' ')
rm -f "$tmpout"

echo "SUMMARY $checked $violations"
