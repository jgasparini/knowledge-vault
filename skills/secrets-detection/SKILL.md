---
name: secrets-detection
description: >
  Scan a file or directory for likely credentials (API keys, tokens, private keys,
  connection strings, generic password/secret assignments) before it is committed,
  ingested, or otherwise processed. Triggers when the user says "scan this file for
  secrets", "scan this repo/folder for secrets", "check for secrets before committing",
  or "secrets scan". On any finding, presents the pattern name, file, and line number
  (never the matched value) and asks the user to choose: stop, or redact and continue.
---

# Secrets Detection

Standalone, portable skill — this directory has no dependency on any other skill or
on project-specific paths. Copy `skills/secrets-detection/` into another repository's
`skills/` directory to reuse it there unchanged.

## What this does

Runs a pattern-based scan for common credential formats (see `scripts/patterns.tsv`)
against a file or directory, using `scripts/scan-secrets.sh` (macOS/Linux) or
`scripts/scan-secrets.ps1` (Windows).

## Usage

1. Run the scanner in default (scan) mode against the target path:

   ```bash
   bash skills/secrets-detection/scripts/scan-secrets.sh <path>
   ```

   ```powershell
   powershell -File skills\secrets-detection\scripts\scan-secrets.ps1 <path>
   ```

   `<path>` may be a single file or a directory. Directories are scanned
   recursively, excluding `.git/`, `node_modules/`, and binary files.

2. Read the output:
   - Each match is reported as `FINDING <pattern-name> <file>:<line>`. The
     matched secret value itself is **never** printed.
   - The final line is `SUMMARY <count>`.
   - Exit code is `0` if `<count>` is `0` (clean), `1` otherwise.

3. If `SUMMARY 0` — clean. Proceed with whatever the caller was about to do
   (commit, ingest, etc.). No further action needed.

4. If there are `FINDING` lines, **stop** before proceeding with the original
   task. Present every finding to the user — pattern name, file, and line
   number, never the matched value — and ask them to choose:

   - **Stop** — do not proceed with the original task (commit, ingest, etc.).
     The file is left unchanged.
   - **Redact and continue** — re-run the scanner with `--redact` (bash) or
     `-Redact` (PowerShell) against the same path:

     ```bash
     bash skills/secrets-detection/scripts/scan-secrets.sh --redact <path>
     ```

     ```powershell
     powershell -File skills\secrets-detection\scripts\scan-secrets.ps1 -Redact <path>
     ```

     This rewrites each match in place as `[REDACTED:<pattern-name>]` (a
     multi-line `private-key-block` match collapses to a single redacted
     line). Re-run the scan in default mode to confirm `SUMMARY 0`, then
     proceed with the original task using the redacted file(s).

A finding never silently passes through — the caller never proceeds without
an explicit user choice — and never silently blocks — the user always sees
what was found and decides what happens next. There is no third option to
proceed with a secret left intact.

## Known limitations

- **Known formats only.** `scripts/patterns.tsv` is a fixed table of named,
  well-known credential shapes (AWS keys, GitHub/Slack/Stripe/Google tokens,
  JWTs, PEM/SSH/PGP private key headers, generic `key = value` assignments,
  URLs with embedded `user:password@`). High-entropy or otherwise-shaped
  secrets that don't match one of these patterns will not be detected. To
  extend coverage, add a row to `patterns.tsv` — both scripts read it at
  runtime, so no code change is needed.
- **False positives on placeholder credentials** (e.g. AWS's published
  example key `AKIAIOSFODNN7EXAMPLE`, or tutorial text like
  `password=changeme123`) will be flagged like real secrets. Redacting these
  loses nothing, but still requires a per-finding user decision.
- **Redaction loses content.** Replacing a match — especially a whole
  `private-key-block` — with a placeholder permanently removes that text. If
  surrounding prose depends on it, the redacted file will read oddly. This is
  why redaction is always a per-finding user choice, never automatic.
- **Text content only.** Binary files (images, PDFs, etc.) are skipped and
  are not inspected, whether scanning a single file or a directory.
