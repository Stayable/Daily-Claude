# Session Resume Architecture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `CLAUDE.md` so every session start reads active chats from `_index.md`, presents the right entry point (none/single/multi), and either resumes with a task brief or drops into a fresh unlogged conversation.

**Architecture:** Single prose instruction change in `CLAUDE.md` `## Session Management` section. `_index.md` becomes the source of truth for active chats. `session.md` is retained as a last-used pointer but no longer drives session start.

**Tech Stack:** Markdown (CLAUDE.md, _index.md)

---

### Task 1: Update CLAUDE.md Session Management

**Files:**
- Modify: `CLAUDE.md:49-54`

- [ ] **Step 1: Replace the Session Management section**

Open `CLAUDE.md`. The current `## Session Management` block (lines 49–54) is:

```markdown
## Session Management
- On every session start: read `session.md`, then read the `## SUMMARY` section of the chat file it points to — that is your full context
- Do not ask for re-briefing; the summary has everything needed to continue cold
- Use `/save` to snapshot progress and auto-commit to git
- Chat files live in `chats/<topic>/<slug>_YYYYMMDD.md`
- `chats/_index.md` is the master list of all chats
```

Replace with:

```markdown
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
```

- [ ] **Step 2: Verify the change**

Read `CLAUDE.md` and confirm:
- The two old lines (`read session.md...` and `Do not ask for re-briefing...`) are gone
- The three paths (no active / one active / multiple active) are present
- Task brief format block is present with Done and Pending sources documented
- `session.md` note retained

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "feat: active session picker and task brief on session start"
```

Expected output: 1 file changed, ~30 insertions(+), 2 deletions(-)
