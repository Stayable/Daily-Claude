---
description: Re-show the chat picker mid-session (resume another chat, or start new/quick)
---

Re-display the session picker right now, then act on the reply exactly as on session start.

1. If the current logged chat has unsaved progress, first say one line: `Run /save first if you don't want to lose this session's progress — or reply anyway.` (Skip this for a `quick`/unlogged session.)
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
