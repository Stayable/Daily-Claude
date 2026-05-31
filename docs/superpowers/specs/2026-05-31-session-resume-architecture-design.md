# Session Resume Architecture — Design Spec
*2026-05-31*

## Problem
On session start, Claude silently absorbs the SUMMARY context and waits. Jefferson has to re-orient himself and direct Claude manually. There is no way to skip into a plain conversation, and the flow doesn't account for multiple active chats.

## Goal
On every session start, Claude reads active chats from `_index.md` and presents the right entry point — a picker if multiple sessions exist, a single-chat mode selector if only one, or nothing if there's nothing active. Always gives the option to start fresh with no logging.

## Scope
Single change: `CLAUDE.md` `## Session Management` section. No new files, no infrastructure.

## Behavior

**Trigger:** Every session start.

### Step 1 — Read active chats

Read `chats/_index.md`. Collect all rows where status = `active`.

---

### Path A — No active chats

Proceed as a normal conversation. No prompt, no session context.

---

### Path B — One active chat

Output one line:

```
Continue "[chat title]" or start fresh? (↵ to continue, f for fresh)
```

- **f** → fresh chat (see Step 3b)
- **↵ / anything else** → load that chat and show task brief (see Step 2)

---

### Path C — Multiple active chats

Output a numbered picker:

```
Active sessions:
1. [chat title 1]
2. [chat title 2]
f. Fresh chat

Which?
```

- **f** → fresh chat (see Step 3b)
- **number** → load that chat and show task brief (see Step 2)

---

### Step 2 — Task brief (after a chat is selected)

1. Read `## SUMMARY` from the selected chat file
2. Output:

```
**Resuming:** [chat title]

**Done**
- [Accomplished bullets]
- [Any checked [x] Open Items]

**Pending**
1. [Unchecked [ ] Open Item 1]
2. [Unchecked [ ] Open Item 2]
...

Which would you like to tackle? (1, 2, 3, or something else)
```

**Sources:**
- **Done** = `### Accomplished` bullets + any `[x]` items from `### Open Items`
- **Pending** = `[ ]` items from `### Open Items`, numbered in order

---

### Step 3b — Fresh chat

- Do not load any chat file
- Do not load session context
- No session tracking for this conversation — `/save` will not be offered or used
- Output nothing — proceed as a normal conversation

---

## Role of session.md

`session.md` is retained as a "last used" pointer (written by `/save`). It is no longer the driver of session start — `_index.md` is. `session.md` may be used in the future for quick-resume without reading the full index.

## What Changes in CLAUDE.md

**Remove:**
> On every session start: read `session.md`, then read the `## SUMMARY` section of the chat file it points to — that is your full context
> Do not ask for re-briefing; the summary has everything needed to continue cold

**Replace with:**
> On every session start: read `chats/_index.md` and collect all active chats.
> - No active chats → proceed normally
> - One active chat → output `Continue "[title]" or start fresh? (↵ / f)`
> - Multiple active chats → output numbered picker + `f. Fresh chat`
> After a chat is selected, read its `## SUMMARY` and output the task brief (Resuming header, Done section, Pending numbered list), then ask: "Which would you like to tackle?"
> If `f` → no context loaded, no logging, proceed as plain conversation.

## What Does NOT Change
- `/save` command format — SUMMARY structure stays identical
- Chat file format — no changes to frontmatter or sections
- `session.md` format — still written by `/save` as last-used pointer
- `_index.md` format — status column already exists; `active` is the trigger
