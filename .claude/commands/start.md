---
description: Show the session picker (used by start-claude.bat on launch)
---

Begin the session. If the SessionStart hook gave you a chat picker, output it now verbatim (including the Commands line). Otherwise read `chats/_index.md` and build the picker per **CLAUDE.md → Session Management**: up to 10 recent chats most-recent-first, plus `new`, `quick`, and `more` when there are over 10, ending with the command guide line.

Then STOP and wait for the user's choice — do nothing else first.
