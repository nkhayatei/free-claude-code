@echo off
title Free Claude Code - Auto Reinstaller
cd /d "d:\free-claude-code-main"
echo ========================================================
echo       Free Claude Code - Auto Reinstaller & Setup
echo ========================================================
echo.
powershell -ExecutionPolicy Bypass -File "d:\free-claude-code-main\re-install-cloude.ps1"
pause
