# Hermes Todos — Jost Thedens

## Research Agent aufsetzen (AI Domain)

**Status:** In Bearbeitung
**Session:** 2026-05-07, 14:06 — 16:xx
**Skill:** `/Users/admin/.hermes/skills/automation/research-agent/SKILL.md`
**Cron-Job ID:** `a8859af834b1`

---

### Was wurde gemacht

1. **Skill erstellt** — `research-agent` (Graeme's 6-Step + Indy Dev Dan)
   - Graeme Key's 6-Step Research Agent Loop als Skill gespeichert
   - Indy Dev Dan's Verifier Pattern + Flywheel integriert
   - Erfolgsparameter (KPIs) definiert
   - Cron-Job Prompt mit Dan's Closed-Loop geschärft

2. **Cron-Job erstellt** — `a8859af834b1`
   - **Schedule:** Mo-Fr 07:00 (erste Run: 2026-05-08)
   - **Skills:** `research-agent` + `indy-dev-dan`
   - **Delivery:** Telegram
   - **Domain:** AI/ML Research

3. **Dry Run durchexerziert** (3 Signale gespeichert in gbrain):
   - `research-signal-longseeker-2026-05-07` — HIGH
   - `research-signal-arc-agi-3-2026-05-07` — HIGH
   - `research-signal-spine-eai-privacy-2026-05-07` — MEDIUM

---

### Der Research Agent Loop (6 Steps)

```
1. Pick a domain:     AI, crypto, startups, sales leads, competitors, papers, jobs
2. Give it sources:   X lists, RSS feeds, blogs, GitHub repos, docs, newsletters
3. Define signal:     New tools, benchmarks, launches, funding, tutorials, strange patterns
4. Save the evidence: Links, dates, summaries, claims, why it matters
5. Deliver daily:    Discord, Slack, Notion, email, Obsidian, local markdown
6. Give feedback:     "More like this. This source is noisy. This is useful. This is mid."
```

### Dan's Verifier Pattern (Closed Loop)

```
SCAN → VERIFY (Atomic Claims) → SAVE → DELIVER → FEEDBACK → FLYWHEEL
         ↑
         └─ "What I could not verify" → next cycle anpassen
```

### Verifier Checklist (vor dem Speichern)

- [ ] Original Source verlinkt? (Kein "laut Twitter")
- [ ] Claim spezifisch? ("Mistral-7B outperformet GPT-4" ≠ "neues Modell")
- [ ] Konkrete Zahl/Datum/Benchmark?
- [ ] "Why it matters" — 1 konkreter Satz?
- [ ] Vage Claims → NICHT speichern

---

### gbrain Pages (Dry Run, 07.05.2026)

- `research-signal-longseeker-2026-05-07` — Qwen3-30B-A3B, Context Orchestration
- `research-signal-arc-agi-3-2026-05-07` — Verifier-Driven World Models
- `research-signal-spine-eai-privacy-2026-05-07` — Privacy als Architectural Constraint

---

### Erfolgsparameter (KPIs)

| KPI | Ziel |
|-----|------|
| Signale/Tag | 5-15 |
| Useful-Quote | >70% |
| Delivery Rate | 100% |
| Feedback-Loop-Quote | >50% Tage mit explizitem Feedback |

---

### Nächste Schritte

- [ ] **FIRST RUN prüfen** — Morgen 08.05.2026 07:00 auf Telegram
- [ ] **Feedback geben** — Telegram reply ODER gbrain Tag: `useful`, `noisy`, `mid`
- [ ] **Nach 1 Woche:** KPIs prüfen (Useful-Quote), Sources anpassen
- [ ] **Nach 4 Wochen:** Business KPIs review, gbrain KPI-Dashboard pflegen
- [ ] **Eval:** Domain "Trading" als zweiter Research Agent starten?

---

### Wenn Cron-Job nicht läuft / Fehler

1. `cronjob list` → Job Status prüfen
2. `cronjob run <job_id>` → Manuell triggern zum Testen
3. Skill direkt laden: `skill_view("research-agent")`
4. Bei API-Problemen (arXiv timeout): Skill-Hinweis prüfen, Fallback auf cached Sources

---

## Verwandte Sessions

- `/Users/admin/brain/concepts/hermes-agent-use-cases.md` — Ausgangspunkt (Graeme Key + Nick Spisak + Nathan Wilbanks)

---

## Skill-Referenz

- **Research Agent Skill:** `/Users/admin/.hermes/skills/automation/research-agent/SKILL.md`
- **Indy Dev Dan Skill:** `/Users/admin/.hermes/skills/indy-dev-dan/SKILL.md`
- **Trading OS (Verifier Pattern implementiert):** Skill `trading-operating-system`
