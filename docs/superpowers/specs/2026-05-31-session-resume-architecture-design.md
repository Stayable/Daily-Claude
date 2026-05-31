# Session Resume Architecture — Design Spec
*2026-05-31*

## Problem
On session start, Claude silently absorbs the SUMMARY context and waits. Jefferson has to re-orient himself and direct Claude manually. The resume experience is passive, and there is no way to skip into a plain conversation without session tracking.

## Goal
On every session start with an active chat, Claude presents a one-line mode selector, then either resumes with a task brief or drops into a clean unlogged conversation — matching Jefferson's directive, low-friction working style.

## Scope
Single change: `CLAUDE.md` `## Session Management` section. No new files, no infrastructure.

## Behavior

**Trigger:** Every session start where `session.md` contains an active `Chat:` path.

### Step 1 — Mode selector (always first)

Output one line:

```
Continue "[chat title]" or start fresh? (↵ to continue, f for fresh)
```

Wait for response.

### Step 2a — Continue (default)

If the user presses Enter or types anything other than `f`:

1. Read `## SUMMARY` from the active chat file
2. Output task brief — no preamble:

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

### Step 2b — Fresh chat (`f`)

If the user types `f` (or `fresh`):

- Do not read the chat file
- Do not load session context
- No session tracking for this conversation — `/save` will not be offered or used
- Output nothing — just proceed as a normal conversation

**Sources for task brief:**
- **Done** = `### Accomplished` bullets + any `[x]` items from `### Open Items`
- **Pending** = `[ ]` items from `### Open Items`, numbered in order

## What Changes in CLAUDE.md

**Remove:**
> On every session start: read `session.md`, then read the `## SUMMARY` section of the chat file it points to — that is your full context
> Do not ask for re-briefing; the summary has everything needed to continue cold

**Replace with:**
> On every session start where `session.md` has an active `Chat:` path:
> 1. Output: `Continue "[chat title]" or start fresh? (↵ to continue, f for fresh)`
> 2. If `f` → proceed as a plain conversation, no session context loaded, no logging
> 3. Otherwise → read `## SUMMARY` from the chat file, then output the task brief (Resuming header, Done section, Pending numbered list) and ask: "Which would you like to tackle?"

## What Does NOT Change
- `/save` command format — SUMMARY structure stays identical
- Chat file format — no changes to frontmatter or sections
- `session.md` format — no changes
- Fresh-chat conversations have no access to prior session context (by design)
