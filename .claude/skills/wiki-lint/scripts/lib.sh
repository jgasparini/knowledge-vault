#!/usr/bin/env bash
# lib.sh — shared frontmatter helpers for wiki-lint scripts
#
# Sourced by find-orphans.sh, check-index-drift.sh, and others. Not meant to
# be run directly.

# page_type <file> — print the value of the frontmatter `type:` field, or
# nothing if the file has no frontmatter or no `type:` field.
page_type() {
  awk '
    NR==1 { if ($0 != "---") exit; next }
    /^---$/ { exit }
    /^type:/ {
      sub("^type:[[:space:]]*", "")
      sub("[[:space:]]*$", "")
      sub(/^["'"'"']/, "")
      sub(/["'"'"']$/, "")
      print
      exit
    }
  ' "$1"
}

# is_content_page <file> — true if the file's frontmatter has a `type:` field.
# Raw source files (no frontmatter, or frontmatter without `type:`) are not
# content pages and are excluded here regardless of filename.
is_content_page() {
  [ -n "$(page_type "$1")" ]
}

# is_linkable_page <file> — true if the file is a content page (per
# is_content_page) AND its `type:` is not `output` or `query`. outputs/
# working docs use an ad-hoc schema (see check-frontmatter.sh's scope
# comment) and are not part of the linked wiki structure, so they are
# excluded from orphan and index-drift checks.
is_linkable_page() {
  local type
  type=$(page_type "$1")
  [ -n "$type" ] || return 1
  case "$type" in
    output|query) return 1 ;;
    *) return 0 ;;
  esac
}
