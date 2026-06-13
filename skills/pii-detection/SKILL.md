---
name: pii-detection
description: >
  Scan a file or directory for high-sensitivity personal identifiers (UK National
  Insurance number, US Social Security number, credit/debit card numbers, UK bank
  sort code + account number, IBAN, UK NHS number, passport number) before it is
  committed, ingested, or otherwise processed. Triggers when the user says "scan
  this file for PII", "scan this repo/folder for PII", "check for personal
  information before ingesting", or "PII scan". On any finding, presents the
  pattern name, file, and line number (never the matched value) and asks the user
  to choose: stop, redact and continue, or continue without redacting.
---

# PII Detection

Standalone, portable skill — this directory has no dependency on any other skill
(including secrets-detection) or on project-specific paths. Copy
`skills/pii-detection/` into another repository's `skills/` directory to reuse it
there unchanged.

## What this does

Runs a pattern-based scan for high-sensitivity personal-identifier formats (see
`scripts/patterns.tsv`) against a file or directory, using
`scripts/scan-pii.sh` (macOS/Linux) or `scripts/scan-pii.ps1` (Windows).

This is deliberately narrow: it does **not** flag general personal data (names,
emails, phone numbers, home addresses, dates of birth). Those are expected content
in a personal knowledge vault (e.g. `wiki/areas/people/`). It flags only identifier
formats that should essentially never appear in wiki content, regardless of whose
they are.

## Usage

1. Run the scanner in default (scan) mode against the target path:

   ```bash
   bash skills/pii-detection/scripts/scan-pii.sh <path>
   ```

   ```powershell
   powershell -File skills\pii-detection\scripts\scan-pii.ps1 <path>
   ```

   `<path>` may be a single file or a directory. Directories are scanned
   recursively, excluding `.git/`, `node_modules/`, and binary files.

2. Read the output:
   - Each match is reported as `FINDING <pattern-name> <file>:<line>`. The
     matched value itself is **never** printed.
   - The final line is `SUMMARY <count>`. Exit code is `0` if `<count>` is `0`
     (clean), `1` otherwise.

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
     bash skills/pii-detection/scripts/scan-pii.sh --redact <path>
     ```

     ```powershell
     powershell -File skills\pii-detection\scripts\scan-pii.ps1 -Redact <path>
     ```

     This rewrites each match in place as `[REDACTED:<pattern-name>]`. Re-run
     the scan in default mode to confirm `SUMMARY 0`, then proceed with the
     original task using the redacted file(s).
   - **Continue without redacting** — the user has reviewed the finding(s) and
     judges them false positives or acceptable to leave as-is. Proceed with the
     original task using the file unchanged. No re-scan needed.

A finding never silently passes through — the caller never proceeds without an
explicit user choice — and never silently blocks — the user always sees what was
found and decides what happens next.

## Known limitations

- **High false-positive rate on digit-heavy categories.** There is no checksum
  validation (no Luhn check for card numbers, no modulus-11 check for NHS
  numbers, no full validation of the NI number rules beyond letter/digit shape).
  Any digit sequence matching the shape — a random 16-digit reference number, an
  order ID, a grouped phone number — will be flagged as `credit-card-number` or
  `uk-nhs-number`. This is the main reason "continue without redacting" exists as
  a third option, unlike secrets-detection's two-way choice.
- **Cross-line proximity not detected.** `uk-sort-code-account` only matches when
  the sort code and account number appear on the same line (within 20
  characters of each other). A form where they're in separate table cells or on
  separate lines won't be caught.
- **Passport numbers require a label.** A bare alphanumeric string is too
  generic to flag on its own; `passport-number` requires the word "passport"
  (with or without "no."/"number") nearby.
- **Redaction loses content.** Replacing a match with a placeholder permanently
  removes that text. This is why redaction is always a per-finding-set user
  choice, never automatic.
- **No general PII detection.** Names, emails, phone numbers, home addresses, and
  dates of birth are out of scope — this vault expects that kind of data in
  `wiki/areas/people/` and elsewhere. A source containing a job candidate's home
  address, for example, will not be flagged by this skill.
- **Text content only.** Binary files (images, PDFs, etc.) are skipped, whether
  scanning a single file or a directory.
