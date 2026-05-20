# Agency Pipeline Workflow

**Status:** Vollautomatisch seit 05.05.2026
**Stack:** Postgres 16 (agency_pipeline), httpx + BeautifulSoup, Telegram

## Die 3 Cron-Jobs (Mo-Fr)

```
08:30  CRON A: SCAN
         → auto_scan.py ausführen
         → Postgres: agencies + jobs updaten
         → Telegram: Summary

09:00  CRON B: KONTAKTE SCRAPEN
         → Agencies ohne Kontakt aus Postgres holen
         → Website besuchen (httpx + BeautifulSoup)
         → /team, /kontakt, /impressum, /about scannen
         → Namen + Rollen + E-Mails extrahieren
         → Postgres: contacts-Tabelle
         → Telegram: "X Kontakte gefunden" oder "MANUELL"

10:00  CRON C: OUTREACH + ESKALATION
         → Agencies MIT Kontakt, OHNE Outreach aus Postgres
         → Personalisierte LinkedIn-Nachrichten generieren
         → Fehlende Daten → E-Mail an Jost
         → Telegram: Summary mit allen Drafts
```

## Cron-IDs

| Cron | Job-ID | Schedule |
|------|--------|----------|
| A: Scan + Summary | 1ce8518946ff | 30 8 * * 1-5 |
| B: Kontakt scrape | 51b65c3f7b00 | 0 9 * * 1-5 |
| C: Outreach + Summary | 6c1031572ede | 0 10 * * 1-5 |

## Postgres

- **DB:** agency_pipeline
- **Socket:** /tmp (Postgres.app)
- **Tables:** agencies, contacts, job_postings, outreach_campaigns, outreach_tracking
- **Kein Brightdata nötig** — alles mit httpx + BeautifulSoup

## Telegram

Alle 3 Cron-Jobs liefern an **telegram** (deliver: telegram).
Chat-ID: 8066194988

## Skills

- `agency-pipeline-daily` — CRON A Skill
- `agency-pipeline-cron-b` — CRON B Skill
- `agency-pipeline-cron-c` — CRON C Skill

## Key Rules

1. **KEIN Brightdata** — alles mit httpx + BeautifulSoup
2. **LinkedIn-first** → Website-Scrape → Manuell
3. **DSGVO:** Jeder Kontakt braucht gdpr_legal_basis + data_source_detail
4. Cron-Jobs IMMER auf `deliver: telegram`, NIEMALS `local`
