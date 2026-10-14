import os
from pathlib import Path

env_path = Path.home() / ".fcc" / ".env"
lines = []
if env_path.exists():
    lines = [
        line for line in env_path.read_text(encoding="utf-8").splitlines()
        if not any(line.startswith(prefix) for prefix in ("MODEL=", "MODEL_SONNET=", "MODEL_HAIKU="))
    ]

lines.append('MODEL="gemini/models/gemini-2.5-pro"')
lines.append('MODEL_SONNET="gemini/models/gemini-2.5-pro"')
lines.append('MODEL_HAIKU="gemini/models/gemini-2.5-flash"')

env_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
print("SUCCESS: Configured Gemini models successfully!")
