# Daily Claude — Jefferson Labonggomez

## Who I Am
- **Name:** Jefferson Labonggomez
- **Email:** jefferson@rise8companies.com
- **Company:** RISE8 Companies — vertically integrated real estate investment and operations firm, Boca Raton, FL
- **Brand:** Stayable — extended-stay hotel brand (8 Florida properties)

## Properties & IDs
| Property | ID |
|---|---|
| Lakeland | 4645 |
| Kissimmee East | 2295 |
| Jacksonville West | 6802 |
| Jacksonville North | 812 |
| Kissimmee West | 5399 |
| St. Augustine | 2535 |
| Davenport | 44199 |
| Orlando OBT | 8700 |

## How I Work With Claude
- Be direct. No preamble, no filler.
- Execute obvious next steps; report after, not before.
- If context is missing, ask one focused question — never a list.
- Match my energy: short, directive, dense.
- Numbers that are bad — say they're bad. Plans with flaws — name them.
- Never fabricate facts, figures, dates, or approvals.

## Output Defaults
- **Documents:** Word (letters, memos, legal, investor materials)
- **Financials:** Excel — investment-banking formatting (dark headers, clean grid)
- **Decks:** PowerPoint
- **Executed docs:** PDF
- **File naming:** `Title_PropertyID_MMDDYY` (e.g., `InvestorLetter_6802_050326`)
- **Final outputs:** save to OneDrive `/outputs` folder

## Systems I Use
- **Smartsheet** — task management (Action Items Staging Sheet ID: 1981210199805828)
- **Ramp** — company spend and card management
- **Microsoft 365** — Outlook, SharePoint, Teams

## Standing Rules
- Any financial spreadsheet → investment-banking formatting automatically
- Legal documents → flag the county jurisdiction (Duval, Osceola, St. Johns, Orange, Palm Beach, Alachua, Polk)
- Property-specific output → include property ID in filename
- Outgoing letters on RISE8 letterhead → read `rise8-letter` skill first
- Document signing → read `sign-document` skill first

## Session Management
The launcher (`start-claude.bat`) opens Claude Code directly. A SessionStart hook reads `chats/_index.md` and hands you a picker: up to 10 recent chats (most-recent-first) plus `new`, `quick`, and — when there are more than 10 — `more`. **Your first output is that picker, verbatim — then stop and wait for the reply. Run no tools first.**

### When the user replies
- **A number** → resume that chat:
  1. Read `chats/_index.md`. The picker is ordered most-recent-first (the index appends new chats at the bottom, so reverse it). Map the number to that chat's file path.
  2. In `_index.md`, set the chosen row's Status to `active` and every other row's Status to `closed`.
  3. Overwrite `session.md` with the pointer block (format below).
  4. Read the chat file's `## SUMMARY` and output the task brief (format below). Wait for the reply before doing anything else.
- **`new`** → start a new chat:
  1. Ask one line: `What do you want to work on?` (their answer is the title/purpose).
  2. Pick the best-fit topic from `operations, investor-comms, legal, financial, procurement` — only ask if genuinely ambiguous.
  3. Build the slug: title lowercased, non-alphanumerics → hyphens, trimmed. File path: `chats/<topic>/<slug>_YYYYMMDD.md`. Create the folder if missing. Write the new-chat template (below) into it.
  4. In `_index.md`, set every existing row's Status to `closed`, then append: `| [<title>](chats/<topic>/<slug>_YYYYMMDD.md) | <topic> | <YYYY-MM-DD> | active |`
  5. Overwrite `session.md` with the pointer block (below), then proceed with the conversation.
- **`quick`** → casual, unlogged chat. Just talk. Create no chat file, touch neither `_index.md` nor `session.md`, and `/save` does not apply. Say one line so it's clear nothing's being saved (e.g. `Off the record — nothing here gets logged. What's up?`), then proceed.
- **`more`** → next page of chats. Read `chats/_index.md`, reverse the rows (most-recent-first), and show the next 10 with **continued numbering** (page 2 = 11–20, page 3 = 21–30, …). Keep offering `new`, `quick`, and `more` (until the list is exhausted), then wait. A number always maps to its absolute position in the most-recent-first order, regardless of page.
- **Anything else** → ask: `Type a number to resume a chat, 'more' for older chats, 'new' to start a logged one, or 'quick' to just talk.`

### New-chat template
```
---
topic: <topic>
created: <YYYY-MM-DD>
last_saved: never
status: active
---

# <title>
**Purpose:** <title>

---

## SUMMARY
*No save yet — use /save to snapshot this conversation.*

## Open Items
- [ ] (none yet)

## Next Steps
Start the conversation.
```

### `session.md` pointer block
```
# Active Session
Chat: <chats/topic/slug_YYYYMMDD.md>
Resumed: <YYYY-MM-DD HH:mm>

Read the SUMMARY section of the chat file above before your first response.
```

- **Task brief format:**
  - No preamble — output only the block below, then wait for reply before doing anything else
  ```
  **Resuming:** [chat title]  ·  [last saved date]

  **Decisions**
  - [Key Decisions bullets]

  **Done**
  - [Accomplished bullets]
  - [any [x] checked Open Items]

  **Pending**
  1. [unchecked [ ] Open Item 1]
  2. [unchecked [ ] Open Item 2]

  **Next:** [Next Steps line]

  Which would you like to tackle? (1, 2, 3, or something else)
  ```
  - **Decisions** source: `### Key Decisions` bullets (omit the section if empty/absent)
  - **Done** sources: `### Accomplished` bullets + `[x]` (lowercase x) items from `### Open Items`
  - **Pending** sources: `[ ]` items from `### Open Items`, numbered in order
  - **Next** source: the `### Next Steps` line (omit if absent)
- `session.md` — the active-chat pointer; you write it on resume/new, `/save` reads it to find the chat file
- Use `/save` to snapshot progress and auto-commit to git
- Mid-session: `/menu` re-shows the picker in this window (resume/switch; context carries over). `/new-session` opens a fresh Claude in a new window — a clean run of `start-claude.bat` (same repo, clean context).
- Chat files live in `chats/<topic>/<slug>_YYYYMMDD.md`
- `chats/_index.md` is the master list of all chats

## Daily Conversation Purpose
This repo is the home base for my daily working sessions with Claude. Each session may cover:
- Property operations and performance reviews
- Investor communications and reporting
- Legal document drafting and review
- Financial modeling and analysis
- Task management and prioritization
- Procurement and vendor decisions
