@echo off
cd /d "%~dp0"
echo.
echo   Syncing...
git pull origin main --quiet 2>nul
cls
claude
