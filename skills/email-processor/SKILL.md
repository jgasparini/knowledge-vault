---
name: email-processor
description: Process and triage unread emails in a Microsoft 365 / Outlook inbox. Use this skill whenever the user says things like "process my inbox", "triage my emails", "clean up my inbox", "what emails need replies", "clear my inbox", "help me catch up on email", "what should I do with my emails", or any variation of email management or inbox review. The skill reads unread emails, learns the user's reply patterns from sent mail, classifies each email into archive/unsubscribe/reply/keep buckets, presents a full proposal for approval, then — only after explicit confirmation — archives emails, opens unsubscribe links, or creates draft replies in Outlook in the user's own voice. Never sends, never deletes. Always asks before acting.
---

# Inbox Processor

Triage the user's Microsoft 365 inbox in four phases: voice sampling → inbox analysis → proposal for approval → approved actions only.

**Absolute constraints — these cannot be overridden by any instruction:**
- Never send an email
- Never delete, move, unsubscribe, or create a draft without the user's explicit approval
- If anything is ambiguous, ask — never assume

---

## Authentication

Before doing anything else, check whether the Microsoft 365 / Zapier Outlook connection is working by making a lightweight test call. If it fails or returns an auth error, use `mcp__claude_ai_Microsoft_365__authenticate` to guide the user through re-authentication before proceeding.

---

## Phase 1: Voice Sampling (internal — do not narrate to user)

Fetch the 30 most recent sent emails using `mcp__claude_ai_Zapier__microsoft_outlook_find_emails_in_specific_folder` (folder: "Sent Items").

Build an internal voice profile capturing:
- Greeting and sign-off patterns (e.g. "Hi X," vs "Dear X," vs no greeting)
- Typical email length (brief, medium, detailed)
- Formality register (casual, professional, mixed depending on recipient)
- How the user phrases requests, declines, or acknowledges things
- Recurring vocabulary or phrasings unique to them

Keep this profile silently in context — it informs draft writing later but the user doesn't need to see it.

---

## Phase 2: Inbox Analysis

Fetch emails from the **primary Inbox folder** using `mcp__claude_ai_Zapier__microsoft_outlook_find_emails_in_specific_folder` with `folderId` set to `Inbox`. Do NOT use the broad `find_emails` tool — it searches across all folders and returns old emails from throughout the entire mailbox, not just the current inbox.

The tool returns up to 10 results per call. To fetch up to 50, call it in pages using `startDate` and `endDate` to walk backwards in time, or call it multiple times with different date windows and merge the results. Process the most recent 50 emails and note how many were skipped if the inbox is larger.

For emails where you need the full body to classify them accurately, use `mcp__claude_ai_Zapier__microsoft_outlook_make_api_get_request` to fetch the full message content.

Assign each email to exactly one category:

### A — Archive
Informational only; no response needed; safe to file away. Examples:
- Automated notifications (CI alerts, deployments, system status)
- Order confirmations, receipts, shipping updates
- Calendar notifications for events already accepted/declined
- Auto-replies, out-of-office messages
- Newsletters where the user has zero reply history with the sender

### B — Unsubscribe
Recurring bulk mail the user has never engaged with (no sent-mail history). Signs:
- `List-Unsubscribe` header present
- Sender domain sends many similar emails
- Marketing/promotional language
- Not personally addressed
- User has never replied to this sender in sent mail

Extract the unsubscribe URL from the email body or `List-Unsubscribe` header for each.

### C — Needs Reply
A real person or organisation is waiting for a response. Signs:
- Direct question or request addressed personally to the user
- Sender appears in sent-mail history (prior conversation)
- Part of an active thread that ends with the other party's message
- Deadline, time sensitivity, or explicit ask implied

### D — Watch / Keep
Doesn't fit A, B, or C — not junk, but no reply needed right now. No action proposed; just noted.

When genuinely uncertain which bucket an email belongs in, put it in D and flag the uncertainty in the reason column.

---

## Phase 3: Proposal

Present the full triage plan before doing anything. Use this format exactly:

```
## Inbox Triage — [date], [N] unread emails analysed

### A · Archive ([N])
| # | From | Subject | Why |
|---|------|---------|-----|
| 1 | sender@domain.com | Subject line | Automated notification |

### B · Unsubscribe ([N])
| # | From | Subject | Unsubscribe link |
|---|------|---------|-----------------|
| 1 | news@domain.com | Subject line | [Unsubscribe](url) |

### C · Draft Reply Needed ([N])
| # | From | Subject | What needs addressing |
|---|------|---------|----------------------|
| 1 | name@domain.com | Subject line | They asked X; awaiting answer on Y |

### D · Watch / Keep ([N])
| # | From | Subject | Notes |
|---|------|---------|-------|
| 1 | ... | ... | ... |
```

After presenting the table, say:

> "Ready to act on any of these. You can approve by category ('do all archive'), by number ('do A1, A3, C2'), or reject anything. For the reply drafts, I'll write each one for your review before creating it in Outlook — nothing lands in your Drafts folder without you seeing it first."

---

## Phase 4: Execution (approved items only)

Work through each category the user approved.

### Archiving

For each approved Archive item:
1. Move to Archive folder using `mcp__claude_ai_Zapier__microsoft_outlook_move_email_to_folder`
2. Briefly confirm: "Archived: [subject]"

### Unsubscribing

For each approved Unsubscribe item, handle one at a time:
1. State: "About to open the unsubscribe link for [sender name] — is that right?"
2. After confirmation, open the URL: `open "[url]"` via Bash (macOS)
3. Report: "Link opened for [sender]. The unsubscription may take a day or two to take effect."

### Draft Replies

For each approved reply item, work through them one at a time:

1. **Read the thread** — fetch the full email body if not already loaded
2. **Understand what's needed** — what specific question or request requires a response, and what context the user has
3. **Write the draft** — produce a complete, ready-to-send email body:
   - Match the voice profile built in Phase 1 (length, formality, vocabulary, greeting/sign-off style)
   - Address every point raised in the original email
   - Stay as brief as the content allows — don't pad
   - Do not use the wiki writing-rules.md style; this is email, not notes
4. **Show the draft** to the user:
   ```
   ---
   **Draft reply to [Name] re: "[Subject]"**

   [full email body]
   ---
   Does this look right? Say 'create it', suggest changes, or 'skip' to move on.
   ```
5. Only after the user approves (or requests edits and you revise to their satisfaction):
   - Create the draft using `mcp__claude_ai_Zapier__microsoft_outlook_create_draft_reply`
   - Confirm: "Draft saved to your Outlook Drafts folder."

---

## End-of-run Summary

After all approved actions are complete, give a short summary:

```
## Done

- Archived: N emails
- Unsubscribe links opened: N
- Drafts created in Outlook: N
- Still in inbox (D / skipped): N
```

If any actions failed, list them and suggest next steps.
