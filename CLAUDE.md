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
- On every session start: read `chats/_index.md` and collect all rows where Status = `active`
  - **No active chats** → proceed as a normal conversation, no prompt
  - **One active chat** → output one line: `Continue "[chat title]" or start fresh? (↵ to continue, f for fresh)`
    - `f` → plain conversation, no context loaded, no logging
    - anything else → read `## SUMMARY` from that chat file, show task brief (format below)
  - **Multiple active chats** → output a numbered picker:
    ```
    Active sessions:
    1. [chat title 1]
    2. [chat title 2]
    f. Fresh chat

    Which?
    ```
    - `f` → plain conversation, no context loaded, no logging
    - number → read `## SUMMARY` from that chat file, show task brief (format below)
- **Task brief format** (no preamble — output only this):
  ```
  **Resuming:** [chat title]

  **Done**
  - [Accomplished bullets]
  - [any [x] checked Open Items]

  **Pending**
  1. [unchecked [ ] Open Item 1]
  2. [unchecked [ ] Open Item 2]

  Which would you like to tackle? (1, 2, 3, or something else)
  ```
  - **Done** sources: `### Accomplished` bullets + `[x]` items from `### Open Items`
  - **Pending** sources: `[ ]` items from `### Open Items`, numbered in order
- `session.md` — retained as last-used pointer written by `/save`; not read on session start
- Use `/save` to snapshot progress and auto-commit to git
- Chat files live in `chats/<topic>/<slug>_YYYYMMDD.md`
- `chats/_index.md` is the master list — Status column (`active`) drives session start

## Daily Conversation Purpose
This repo is the home base for my daily working sessions with Claude. Each session may cover:
- Property operations and performance reviews
- Investor communications and reporting
- Legal document drafting and review
- Financial modeling and analysis
- Task management and prioritization
- Procurement and vendor decisions
