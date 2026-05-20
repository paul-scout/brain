---
Type: research-signal-verifier-report
Run_ID: research-agent-2026-05-20-0700
Verified_Date: 2026-05-20
Signals_Total: 20
Verified: 7
Unverifizierbar: 3
Rejected: 10
---

## Verifier-Bericht

Dan-Verifier-Check: Source original? Claim spezifisch? Zahl/Datum vorhanden? Why-it-matters konkret? In ~30s verifizierbar?

| SID | Builder SID | Titel | Source | Priority | Ergebnis |
|-----|-------------|-------|--------|----------|----------|
| S1 | github-trending:S1 | HKUDS/CLI-Anything | GitHub | HIGH | ✅ verified — Repo existiert, 37.9k Stars, Agent-native CLI-Claim in Beschreibung |
| S2 | github-trending:S2 | HKUDS/ViMax | GitHub | HIGH | ✅ verified — Repo existiert, 5.6k Stars, agentic video generation in Beschreibung |
| S3 | github-trending:S3 | unslothai/unsloth | GitHub | MEDIUM | ⚠️ unverifizierbar — Repo/Stars OK, aber Builder-Claim nennt künftige Modellnamen; relevance hier unscharf |
| S4 | github-trending:S4 | anthropics/skills | GitHub | HIGH | ✅ verified — Repo existiert, 137k Stars, Public Agent Skills Repository |
| S5 | github-trending:S5 | alirezarezvani/claude-skills | GitHub | MEDIUM | ⚠️ unverifizierbar — Repo/Stars OK, aber 313+ Skills/8 Agents nicht schnell aus Primärquelle geprüft |
| S6 | github-trending:S6 | K-Dense-AI/scientific-agent-skills | GitHub | MEDIUM | ⚠️ unverifizierbar — Repo/Stars OK, konkreter Nutzen/Qualität nicht in 30s prüfbar |
| S7 | github-trending:S7 | BigBodyCobain/Shadowbroker | GitHub | LOW | ❌ rejected — OSINT/Jet/Seismic Aggregation, nicht AI/ML-Core-Signal |
| S8 | github-trending:S8 | tirth8205/code-review-graph | GitHub | HIGH | ✅ verified — Repo existiert, 16.9k Stars, 6.8x/49x Token-Claims in Beschreibung |
| S9 | github-trending:S9 | ZhuLinsen/daily_stock_analysis | GitHub | LOW | ❌ rejected — Trading/Stock-App, nicht AI-Domain-Pilot |
| S10 | github-trending:S10 | Fincept-Corporation/FinceptTerminal | GitHub | LOW | ❌ rejected — Finance-Terminal, nicht AI-Domain-Pilot |
| S11 | github-search:S1 | GammaLabTechnologies/harmonist | GitHub | HIGH | ✅ verified — Repo existiert, 1.8k Stars, 186 agents/zero dependencies in Beschreibung |
| S12 | github-search:S2 | WenyuChiou/awesome-agentic-ai-zh | GitHub | LOW | ❌ rejected — Curated list/roadmap, kein neues Tool/Benchmark |
| S13 | github-search:S3 | opensquilla/opensquilla | GitHub | MEDIUM | ✅ verified — Repo existiert, 1.1k Stars, token-efficient agent claim spezifisch aber ohne Benchmarks |
| S14 | github-search:S4 | jmerelnyc/Photo-agents | GitHub | LOW | ❌ rejected — vager self-evolving claim, keine Zahl außer Stars |
| S15 | github-search:S5 | future-agi/future-agi | GitHub | HIGH | ✅ verified — Repo existiert, 996 Stars, Evals/Tracing/Guardrails-Plattform klar |
| S16 | github-search:S6 | shefyYuri/grok-animus | GitHub | LOW | ❌ rejected — Companion Engine, niedrigere Relevanz für Josts Agentic-Engineering |
| S17 | github-search:S7 | agentic-in/elephant-agent | GitHub | LOW | ❌ rejected — vager personal-model/self-evolving Claim |
| S18 | github-search:S8 | FrankHui/paragents | GitHub | LOW | ❌ rejected — kleines Tool, kein harter Benchmark/Signal über Schwelle |
| S19 | github-search:S9 | smaramwbc/statewave | GitHub | LOW | ❌ rejected — interessantes Memory-Runtime-Signal, aber nur 221 Stars und kein harter Nachweis |
| S20 | github-search:S10 | LYiHub/OpenClaw-AWD-Arena | GitHub | LOW | ❌ rejected — Security Arena; nicht AI-Domain-Digest heute |

## Stable Signal IDs

S1–S20 sind global für diesen Run und ersetzen die lokalen Builder-IDs je Source. Feedback bitte mit `research-agent-2026-05-20-0700:Sx`.

## What I could not verify

- arXiv war im Builder-Run rate-limited/timeout; alle vier arXiv-Pages enthalten 0 Signale.
- HuggingFace Models API lieferte 0 Signale.
- GitHub `stars_today` stammt aus Builder-Scrape/Search-Kontext; GitHub REST API verifiziert Repo, Gesamtstars, Beschreibung und Timestamps, aber nicht zuverlässig `stars_today`.
- Einige Skill-/Awesome-Listen haben hohe Stars, aber keinen atomic, actionablen Claim; deshalb nicht in den Digest.

## Feedback von Jost

[leer — wird in nächster Session ergänzt]
