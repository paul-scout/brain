# Agency Pipeline

## Compiled Truth

Systematischer Research & Outreach-Pipeline für deutsche Digital-Agenturen. Ziel: Freelance PM/PO/Scrum Master Einsätze generieren durch proaktive Ansprache von Agenturen mit aktuellen Stellen.

**Status:** Active — Morgen-Workflow läuft
**Letzter Scan:** 2026-04-20 (erster Testlauf)
**Agenturen:** 232 (davon ~225 aktiv)
**Outreach-Texte:** Im Aufbau

---

## Vision

Jost positioniert sich als temporärer Unterstützer für Agenturen, die PM/PO/Scrum Master suchen — ohne sich auf Festanstellung zu bewerben.

**Pitch:** "Ihr sucht eine feste Stelle — kann ich nicht bieten, aber temporär unterstützen."

**Ansprechpartner:** HR (nicht Geschäftsführer)

---

## Setup

**Repo:** `~/Downloads/agency-pipeline/` (Download von Jost, 2026-04-20)
**Stack:** Python 3.12 + uv, SQLite, httpx, BeautifulSoup, Playwright, python-jobspy
**Dashboard:** Port 8050 (`scripts/serve_dashboard.py`)

### Datenbank (agencies.db)

| Tabelle | Rows | Beschreibung |
|---------|------|-------------|
| agencies | 232 | Stammdaten |
| contacts | 106 | Ansprechpartner (aber meist GF, kein HR) |
| job_postings | 1086 | Alle Jobs |
| freelance_portal_jobs | 4+ | Jobs von freelancermap.de (wachsende Tabelle) |

---

## Freelance-Portale

### freelancermap.de (aktiv)
- **Methode:** POST /projekte mit `q=<suchbegriff>` (GET ?query= gibt nur 3 Vorschau)
- **Selektor:** `.project-card` mit `.mg-b-display-m` (Titel index 1, Company index 0)
- **Suchbegriffe:** projektmanager, product owner, scrum master, agile coach, digital transformation, senior projektmanager, it projektleiter
- **Portal-Jobs:** Werden in `freelance_portal_jobs` gespeichert, täglich aktualisiert
- **Export:** `python scripts/export_portal_jobs.py` -> Markdown für Outreach-Datei
- **Status:** Laufend seit 2026-04-27

### freelancer.de (inaktiv)
- Braucht JS-Login, keine öffentlichen Job-Daten ohne Auth
- Playwright-Ansatz möglich, aber niedrige Priorität

---

## Workflow

### Morgen-Routine (10:00 Uhr, Cron)

1. `auto_scan.py`
   - Step 1: Career Pages Scan
   - Step 2: Job Board Scan (LinkedIn)
   - Step 3: Freelance Portal Scan (freelancermap.de, neu seit 2026-04-27)
   - Step 4: Staleness Check
   - Step 5: Score Update
2. `daily_actions.py` — Zusammenfassung (inkl. Portal-Jobs)
3. `export_portal_jobs.py` — Portal-Jobs als Markdown exportieren
4. PM/PO/Scrum Master Jobs filtern
5. HR Kontakte recherchieren
6. Outreach-Texte generieren -> `~/brain/agencies/outreach-YYYY-MM-DD.md`

### Job-Cluster (aus DB)

| Cluster | Titel |
|---------|-------|
| pm_po | Project Manager, Product Owner, Projektleiter |
| agile | Scrum Master, Agile Coach |
| development | Developer (nicht relevant) |

---

## Offene Tasks

- [ ] HR Kontakte für Agenturen mit aktuellen PM/PO Jobs recherchieren
- [ ] Jost-Stil Text-Training (Writing Skill mail fehlt noch)
- [ ] Agentur-Repo vom Download-Ordner in stabile Location verschieben
- [ ] Outreach-Texte Review-Prozess definieren (Chat vs. File vs. Email)
- [x] Freelancermap.de Integration (läuft seit 2026-04-27)

---

## Learnings

- Die DB hat mostly Geschäftsführer-Kontakte — HR/Recruiting Kontakte fehlen
- Agenturen mit aktuellen Jobs: shift (Frankfurt), wiethe, e-pixler, arboro, etc.
- Job-Datum tracken um "aktive" vs "expired" zu unterscheiden

---

## See Also

- `~/brain/agencies/` — Outreach-Texte pro Tag
- `~/brain/projects/agency-pipeline/contacts/` — Erforschte Kontakte (future)

---

## Timeline

- **2026-04-20:** Pipeline entdeckt, Setup begonnen, Morgen-Cron eingerichtet
- **2026-04-20:** 232 Agenturen, 25 PM/PO/Agile Jobs identifiziert
- **2026-04-27:** Freelancermap.de Integration gebaut: POST-Suche, 4 PM-Jobs gefunden (MainHeads, Etengo AG, YER, iBSC), in auto_scan Step 3 integriert