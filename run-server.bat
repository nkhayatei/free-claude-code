@echo off
title Free Claude Code Server
cd /d "d:\free-claude-code-main"
echo Starting Free Claude Code Server on port 8082...
echo Admin UI: http://127.0.0.1:8082/admin
echo.
.venv\Scripts\python.exe -c "import free_claude_code.cli.entrypoints as e; e.serve()"
pause
