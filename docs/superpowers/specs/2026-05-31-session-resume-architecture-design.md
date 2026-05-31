# Session Resume Architecture — Design Spec
*2026-05-31*

## Problem
On session start, Claude silently absorbs the SUMMARY context and waits. Jefferson has to re-orient himself and direct Claude manually. The resume experience is passive.

## Goal
On every session start with an active chat, Claude proactively surfaces what's done, what's pending, and asks which task to tackle — matching Jefferson's directive working style.

## Scope
Single change: `CLAUDE.md` `## Session Management` section. No new files, no infrastructure.

## Behavior

**Trigger:** Every session start where `session.md` contains an active `Chat:` path.

**Steps:**
1. Read `session.md` → get active chat file path
2. Read `## SUMMARY` section of that chat file
3. Output task brief (format below) — no preamble, no filler
4. Wait for response

**Output format:**
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

## What Changes in CLAUDE.md

**Remove:**
> Do not ask for re-briefing; the summary has everything needed to continue cold

**Replace with:**
> Output a task brief on resume: **Resuming** header (chat title), **Done** section (Accomplished + checked Open Items), **Pending** section (unchecked Open Items as numbered list), then ask: "Which would you like to tackle? (1, 2, 3, or something else)" — no preamble, output only the brief and the question.

## What Does NOT Change
- `/save` command format — SUMMARY structure stays identical
- Chat file format — no changes to frontmatter or sections
- `session.md` format — no changes
