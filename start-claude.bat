@echo off
cd /d "%~dp0"
echo.
echo   Syncing...
git pull origin main --quiet 2>nul
cls
claude "Begin the session: if the SessionStart hook gave you a chat picker, output it now verbatim; otherwise read chats/_index.md and build the picker per CLAUDE.md Session Management (up to 10 recent chats most-recent-first, plus 'new', 'quick', and 'more' when there are over 10). Then stop and wait for my choice."
