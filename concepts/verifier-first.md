# Verifier-First Pattern

## Kernprinzip

**Jeder Builder-Output braucht einen Verifier-Agent.** Reviewing ist der teurerer der zwei agentic-coding Constraints — Planning skaliert, Reviewing nicht über Mensch-im-Loop.

> "There are two constraints in agentic coding: planning and reviewing." — Dan

## Die Formel

```
Builder (Opus, 4% Token) + Verifier (GPT-5.5, 23% Token) = 5× Compute auf Validation
```

Das ist kein Bug — das ist die Formel. **Spend tokens to save time.** Engineer-Zeit ist immer der Engpass.

## Architektur

```
Builder Agent ──[Stop-Hook → Unix-Socket]──> Verifier Agent
   ▲                                            │
   └── (nur bei Rule-Violation) ─── prompts ──┘
```

- **Builder**: Primary Agent. Macht die Arbeit.
- **Verifier**: Unprompted, gekickt vom Stop-Hook. Liest Session-File, validiert atomic claims.
- **Kommunikation**: Local Unix-Socket. Kein API-Round-Trip, kein Mensch im Loop.

## Vier Pflicht-Properties eines guten Verifiers

1. **Atomic-Claims-Decomposition** — jeder Prompt in unabhängig prüfbare Wahrheits-Einheiten
2. **Single-Script-Bash-Restriction** — höchste Form von Bash-Lockdown
3. **Non-Promptable by Design** — bei Lücken: System-Prompt verbessern, nicht direkt prompten
4. **"What I could not verify"** — Pflicht-Feld, fließt zurück in System-Prompt (Compounding Flywheel)

## Closed-Loop Checkliste

- [ ] Pre-tool-use Hook (blockt destruktive Commands)
- [ ] Post-tool-use Hook (validiert Output deterministisch)
- [ ] Stop Hook (cleanup, summary)
- [ ] Self-validation im Spec ("verify your work")

## Anti-Pattern Red Flags

- Builder ohne Verifier in Production
- Verifier direkt promptbar
- Generalist-Verifier statt Specialized Stack (SQL, Image, Test, Security)
- "What I could not verify" wird ignoriert
- Keine Atomic-Claims-Decomposition

## Report-Template

```markdown
status: passed/failed/feedback
atomic_claims_total: N
claims_verified: N
claims_failed: N
claims_unverified: N
what_could_you_not_verify: ...
what_do_you_need_from_me_next_time: ...
```

## Konkret für Josts Workflow

1. **Verifier-First Roll-out**: Bei jedem Builder-Output frage zuerst: "Wer validiert das atomar?"
2. **Specialization Stack**: Pro Concern ein Verifier (SQL, Image, Test, Security)
3. **Stop-Hook als Default-Trigger**
4. **Locked Harness für Verifier**

## Cron-Jobs: Besondere Sorgfalt

Cron-Jobs laufen **ohne Mensch-im-Loop** — keine Rückfragemöglichkeit, keine Korrektur im Loop. Deshalb:

- **Output-Verification ist Pflicht**: Cron-Job Output muss automatisch geprüft werden (nicht nur loggen)
- **Checkpoint-Logik**: Bei Fehlern nicht blind weiterlaufen — Exit-Status + Teilergebnisse dokumentieren
- **Deliver-to-User Pattern**: Cron-Output NIE nur intern lassen — Summary an Jost (Telegram/Email), damit er weiß was gelaufen ist
- **Context-Aggregation**: Kein Cron läuft isoliert — jeden Morgen die relevanten Outputs aggregieren und als Chain liefern

```
Cron A (EP-Scan) → Cron B (Qualitäts-Check) → Cron C (Summary an Jost)
                            ↑
                    Verifier-Agent prüft Zwischenergebnis
```**

## Quellen

- EnXKysJNz_8 (GPT-5.5 VERIFIED / Pi Verifier Agent, Mai 2026)
- indy-dev-dan Skill (extended/full-patterns.md)

## Related

[[concepts/hermes-todo-system]] — Hermes Setup & Agentic Engineering
[[skills-conventions/subagent-routing]] — Sub-Agent Konventionen
