@echo off
cd /d "d:\free-claude-code-main"
start "" /b "d:\free-claude-code-main\.venv\Scripts\python.exe" -c "import free_claude_code.cli.entrypoints as e; e.serve()"
exit
