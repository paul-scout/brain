# Agency Pipeline — Stand 2026-04-28

## Status
- **Letzte Verifizierung:** 2026-04-28 — Alle 33 Career-Page-URLs im pm_po Cluster gecheckt
- **Davon 404 → expired:** 3 (Ryze Digital, FORK Junior PM, OPEN Senior PO x2)
- **Verifiziert noch open:** 42 pm_po Jobs

## Workflow: Freelance-Portal-Scan (freelancermap.de)

### Cron: Täglich 10:00 Uhr
1. Scanne freelancermap.de mit Suchbegriffen: projektmanager, product owner, scrum master, agile coach
2. Für jeden neuen Job: **Profile-Fit-Check** vor Speicherung
3. Speichere passende Jobs in `freelance_portal_jobs` (Tabelle)
4. Bewertung: Passt der Job zu Jost?

### Profile-Fit-Check (Jost)
| Kriterium | Wert |
|-----------|------|
| Erfahrung | 21 Jahre Agentur-PM/PO/Scrum |
| Fokus | Digitalagenturen (kein SAP/Specific-Industry) |
| Verfügbarkeit | Sofort, Remote ok |
| Vertragsart | Kein Festanstellungsinteresse |
| Präferenz | E-Commerce, Digital Solutions, CRM-Projekte |

### Skip-Regeln (freelancermap)
- SAP-spezifisch (SAP Utilities, SAP Module) → Skip
- Industrie-beengt (Bergbau, Produktion mit Nische) → Skip
- Unter 6 Monate Dauer → Skip (zu kurz)
- kein Remote / nur vor Ort → Skip (Jost bevorzugt Remote)
- Programming/Development im Titel → Skip

### Suchbegriffe freelancermap
- `projektmanager` → projektmanager
- `product+owner` → product owner
- `scrum+master` → scrum master
- `agile+coach` → agile coach
- `senior+projektmanager` → senior projektmanager
- `digital+projektmanager` → digital projektmanager

---

## Verifizierte offene PM/PO-Jobs (Career Pages, Stand 28.04.2026)

### TOP 5 Agenturen mit Kontakten

#### 1. 711media websolutions — Stuttgart
**Jobs (2):**
- Senior Projektmanager - Digital Solutions → https://www.711media.de/jobs-in-stuttgart/senior-projektmanager-digital-solutions
- Senior Projektmanager E-Commerce → https://www.711media.de/jobs-in-stuttgart/senior-projektmanager-e-commerce

**Job-Fit:** ✅ 21 Jahre Agentur-PM, E-Commerce, Digital Solutions — passt perfekt

**Kontakt:** 
- Jobs-Seite: [Jobs](https://www.711media.de/jobs-in-stuttgart) (+49 711 460 583 00)
- HR/Recruiting: Nicht explizit genannt — allgemeine Kontaktnummer
- LinkedIn: https://www.linkedin.com/company/711media-websolutions-gmbh
- Oliver Storm (Geschäftsführer, in DB)

**Outreach-Kanal:** LinkedIn + Email an jobs@711media.de

---

#### 2. elbkapitäne — Hamburg
**Jobs (3):**
- Senior Project Manager Digital → https://www.elbkapitaene.de/jobs/job-details/2520443
- Project Manager Digital → https://www.elbkapitaene.de/jobs/job-details/2551979
- Technical Project Manager → https://www.elbkapitaene.de/jobs/job-details/2086673

**Job-Fit:** ✅ Passt — Digitalagentur, E-Commerce-Plattformen, agile/hybride Methoden

**Kontakt:**
- jobs@elbkapitaene.de (generisch)
- Carina Schillag — People & Culture Lead (aus HR-Kontakte-Liste)
- LinkedIn: https://www.linkedin.com/company/elbkapitaene
- HR in DB: Keine (nur GF)
- Quelle: hr-contacts-2026-04-27.md

**Outreach-Kanal:** LinkedIn Connection zu Carina Schillag

---

#### 3. FORK UNSTABLE MEDIA — Hamburg
**Jobs (1):**
- Project Manager:in (m/w/d) Digital (Berlin/Köln/München/Hamburg) → https://www.fork.de/jobs/project-managerin-m-w-d-digital

**Job-Fit:** ✅ Passt — 2+ Jahre Agenturerfahrung, agile Methoden, Jira, Kund:innenkommunikation

**Kontakt:**
- **HR: fischerAppelt (Mutter)** — work@fischerappelt.de
- Skadi Hartemink — HR/Recruiting bei fischerAppelt (für FORK zuständig)
- LinkedIn: https://www.linkedin.com/company/fork-unstable-media
- Hinweis: "Unsere Mutter fischerAppelt unterstützt uns bei der Besetzung" — Antwort kommt von fischerAppelt-Adresse

**Outreach-Kanal:** Email an work@fischerappelt.de (HR für FORK)

---

## Weitere verifizierte Agenturen (ohne spezifischen HR-Kontakt)

| Agentur | Stadt | Jobs | Link | Kontakt |
|---------|-------|------|------|---------|
| OPEN (Interlutions) | Köln/Kassel | 2x PM (Zendesk, SugarCRM) | open.de/jobs | Eva Koka (HR BP) — bereits archiviert |
| THE BRETTINGHAMS | Berlin | 1x Product Owner | brettingham.de/jobs/... | Stefanie Buls — jobs@brettingham.de |
| Webneo | Dresden | 2x (Junior PM, PM) | webneo.de/karriere/... | Martin Ritter (GF) — bereits kontaktiert |
| Mindbox | Dresden | 1x Projektmanager | mindbox.jobs.personio.de/job/440847 | jobs@mindbox.de |
| dot.Source | Jena | Projektmanager | dotsource.de/karriere/... | jobs@dotsource.de |
| 4fb | Offenbach | 1x Senior PM | 4fb.de/karriere/senior-project-manager | kontakt@4fb.de |

---

## Freelancermap.de — Letzte Jobs (Stand 27.04.2026)

| Job | Firma | Remote | Dauer | Fit |
|-----|-------|--------|-------|-----|
| Senior Projektmanager RZ Migration / Bank | MainHeads | ✅ | 8 M | ⚠️ Spezifisch (Bank/RZ) |
| Product Owner / Requirements Manager (SekIDP) | iBSC ltd | ✅ 100% | 6 M | ⚠️ IoT/DevOps spezifisch |
| Teilprojektleiter SAP Marktkommunikation | Etengo AG | ✅ | 12 M | ❌ SAP-Utilities spezifisch |
| Teilprojektleiter Marktkommunikation AMS | YER Deutschland | ✅ | 12 M | ❌ SAP-Utilities spezifisch |
| Projektmanager MS Dynamics NAV/D365 | HENNING eXperts | ❌ | 12 M | ❌ M365/NAV spezifisch |
| Projektleiter NOC | NEO Professional | ❌ | 30 M | ❌ NOC/Infrastructure |

**Fazit freelancermap:** Keiner der aktuellen Jobs passt perfekt zu Josts Profil (E-Commerce/Digitalagentur). Wöchentlich weiter scannen.

---

## DB-Status (agencies.db)

| Tabelle | Rows |
|---------|------|
| agencies | 232 |
| contacts | 106 (meist GF, wenig HR) |
| job_postings | ~1086 |
| freelance_portal_jobs | 6 (nur freelancermap) |

---

## Offene Tasks

- [ ] Freelancermap-Workflow scripten (Profile-Fit-Check integrieren)
- [ ] freelancer.de-Scan (Playwright nötig wegen Login)
- [ ] HR-Kontakt für 711media (Recruiting/HR LinkedIn-Suche)
- [ ] Outreach-Texte für TOP 3 generieren (711media, elbkapitäne, FORK)
- [ ] Verification-Step in Outreach-Workflow einbauen (URL-Verifizierung vor Texte-Generierung)

---

*Letzte Aktualisierung: 2026-04-28*
*Gespeichert für GBrain-Pipeline*