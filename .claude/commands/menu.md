---
description: Re-show the chat picker mid-session (resume another chat, or start new/quick)
---

Re-display the session picker right now, then act on the reply exactly as on session start.

1. **Auto-save first.** If this is a logged chat with new progress since the last save, run the `/save` procedure now (the steps in `.claude/commands/save.md`: rewrite the SUMMARY, update frontmatter + `_index.md`, commit, push). Lead with one line: `Saving before switching…` then proceed once it's committed. Skip the save only for a `quick`/unlogged session or when nothing has changed since the last save.
2. Read `chats/_index.md` and reverse the rows so they're most-recent-first.
3. Output the picker, then STOP and wait — no other tools first:
   ```
   Recent chats:
   1. [title]  (topic, date)
   ...
   new.   Start a new chat (logged)
   quick. Just chat - nothing logged
   more.  Show the next 10        ← only if there are over 10
   ```
   Show up to 10 (page 1). If over 10, add the `more` line and paginate per CLAUDE.md (continued numbering: 11–20, 21–30, …).
4. On reply, follow the **Session Management** rules in `CLAUDE.md`: a number resumes that chat (mark active in `_index.md`, update `session.md`, show the task brief), `new` runs the new-chat flow, `quick` is unlogged, `more` shows the next page.

Note: switching here keeps the **current conversation's context** in memory. For a clean slate with no carryover, use `/new-session` instead.
