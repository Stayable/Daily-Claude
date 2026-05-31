---
description: Open a fresh Claude in a new window — a clean run of start-claude.bat
allowed-tools: Bash(*), mcp__*
---

Start a brand-new Claude session in a separate terminal window, leaving the current conversation running untouched.

A new session is simply a fresh run of `start-claude.bat` — same Daily-Claude repo, same `CLAUDE.md` and chats, clean context. That launcher runs `claude "/start"`, so the new window opens its own `/start` picker where the user can resume a chat or pick `new`/`quick`.

Steps:
1. Launch a new window running the launcher from the repo root. Run this PowerShell command:
   ```powershell
   Start-Process -FilePath "start-claude.bat" -WorkingDirectory $PWD
   ```
2. Reply with one line: `New Claude window opening — pick a chat there. This window stays as-is.`

Do not clear or alter the current conversation. If `Start-Process` fails (e.g. headless), tell the user to double-click `start-claude.bat` themselves.
