# News-Briefing Workflow

## Setup
- RSS-Scraper: `~/.openclaw/workspace/ai-news-generator/scripts/`
- Quelldaten: `data/scored/{datum}-rss.json`

## RSS-Quellen
| Quelle | Status | URL |
|--------|--------|-----|
| Spiegel | ✅ läuft | https://www.spiegel.de/schlagzeilen/index.rss |
| Hamburger Morgenpost | ✅ läuft | https://www.mopo.de/feed/ |
| t-online | ❌ RSS broken | braucht neue URL |
| Hamburger Abendblatt | ❌ RSS broken | braucht neue URL |

## Scoring
**Basis:** 6 Punkte

**Positive Faktoren (+1 je):**
- politik: merz, bundestag, regierung, cdu, spd, afd, ampel, koalition, bundeswehr
- wirtschaft: wirtschaft, konjunktur, arbeitsmarkt, inflation, unternehmen, börse, aktien, ipcc, handel
- digital: ki, ai, digital, tech, software, google, meta, apple, microsoft, amazon, elon, startup
- breaking: breaking, news, exklusiv, entscheidung, reform, krise, skandal, protest
- hamburg: hamburg, hamburger, st. pauli, hsv, elbphilharmonie, hafen, schleswig-holstein
- sport: fußball, bundesliga, dfb, champions league, em, wm, st. pauli, hsv, tennis, olympia

**Negative Faktoren (-1 je):**
- promi: promi, vip, schauspieler, sänger, royals, klatsch, trash
- unterhaltung: kino, film, tv, serien, netflix, amazon prime, disney+
- lokal: braunschweig, hannover, dortmund, essen, bremen, köln

## Output-Kategorien
- **WELT**: Internationale News (Iran, Ukraine, Japan, USA, etc.)
- **DEUTSCHLAND**: Bundespolitische News (Merz, Bafög, etc.)
- **HAMBURG**: Lokale News mit Hamburg-Bezug (HSV, HSVH, St. Pauli, etc.)

## Filter
Score >= 5 → lesenswert

## Workflow
```bash
cd ~/.openclaw/workspace/ai-news-generator
node scripts/fetch-rss.js
node scripts/aggregate-and-score.js
```

## Status
- [ ] RSS-URLs für t-online und Abendblatt prüfen
- [ ] HN-Feed integrieren (falls gewünscht)
- [ ] Cron-Job für morgens 7:30
- [ ] Output direkt in Konsole statt JSON

## Offene Todos
- [ ] Mehr Hamburg-Lokalfelder (NDR, Hamburg 1, etc.)
- [ ] Kategorisierung ggf. automatisch via KI
- [ ] **VibeVoice evaluieren** — microsoft/VibeVoice: "Open-Source Frontier Voice AI". Paul-Relevanz: Niedrig–Mittel. Prüfen: Was bietet es das Hermes Voice nicht kann?
- [ ] **free-programming-books** — EbookFoundation/free-programming-books. Paul-Relevanz: Niedrig.

---

## Bundestag Open Data — hib (heute im Bundestag)

**RSS:** https://www.bundestag.de/static/appdata/includes/rss/hib.rss

**Wert:** Ungefilterte Plenarprotokolle + Anfragen. Kein Journalismus, nur Rohmaterial.
- Kategorien: Inneres, Verteidigung, Wirtschaft und Energie, etc.
- Typ: `Antwort` (Regierung) oder `KleineAnfrage` (Opposition)
- 10-20 Einträge pro Sitzungstag

**Weitere RSS-Feeds:**
- hib: https://www.bundestag.de/static/appdata/includes/rss/hib.rss
- Pressemitteilungen: https://www.bundestag.de/static/appdata/includes/rss/pressemitteilungen.rss
- Aktuelle Themen: https://www.bundestag.de/static/appdata/includes/rss/aktuellethemen.rss
- Tagesordnungen: https://www.bundestag.de/static/appdata/includes/rss/tagesordnungen.rss
