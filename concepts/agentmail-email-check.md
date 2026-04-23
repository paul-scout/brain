# agentmail Email Check — Setup & Daily Use

## Problem
Python `agentmail` module nicht systemweit installierbar (PEP 668 protection).

## Solution: uv run

Use `uv run` mit `--with` flag für einmalige Ausführung:

```bash
uv run --with agentmail --with python-dotenv python3 -c "
from agentmail import AgentMail
import os
c = AgentMail(api_key=os.getenv('AGENTMAIL_API_KEY'))
msgs = c.inboxes.messages.list(inbox_id='paul_der_zweite@agentmail.to', limit=5)
for m in msgs.messages:
    print(f'{m.from_}: {m.subject}')
"
```

## HTML Email Content parsen

```python
import re
html = full.html or ''
text = re.sub(r'<[^>]+>', ' ', html)
text = re.sub(r'\s+', ' ', text).strip()
# Dann filtern nach Keywords: BEAT, GUIDance, EPS, ESTIMATE, WHISPER, REVENUE
```

## Daily Routine
- **8:15 Uhr** — Earnings Whispers NL scannen
- EP-Katalysatoren extrahieren (Beat%, Guidance, Earnings-Dates)
- Paul der Erste Nachrichten checken

## Email Inbox
- **Inbox:** paul_der_zweite@agentmail.to
- Paul der Erste: paul_der_erste@agentmail.to

## Status
- ✅ 2026-04-23: Installation behoben, Daily Routine eingerichtet
