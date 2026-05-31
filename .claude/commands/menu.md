---
description: Save the current logged chat, then re-show the session picker (/start)
---

Switch chats from within an ongoing session.

1. **Auto-save first.** If this is a logged chat with new progress since the last save, run the `/save` procedure now (the steps in `.claude/commands/save.md`: rewrite the SUMMARY, update frontmatter + `_index.md`, commit, push). Lead with one line: `Saving before switching…` then continue once it's committed. Skip the save only for a `quick`/unlogged session or when nothing has changed since the last save.
2. **Then run `/start`** — show the session picker and handle the reply exactly as on launch (resume a number, `new`, `quick`, or `more`), per CLAUDE.md → Session Management.

Note: switching here keeps the **current conversation's context** in memory. For a clean slate with no carryover, use `/new-session` instead.
