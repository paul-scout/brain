# Hook Budget Audit — 2026-05-12

> **Kontext:** Am 2026-05-06 wurden Claude Code Hooks instrumentiert.
> Wrapper `~/.claude/hooks/_timed.sh` logged nach `~/.claude/logs/hooks.jsonl`.
> Die Datei enthält: `{ts_ns, cmd, dur_ms, exit, stdout_bytes}`.
> Gewrapped: 9 Stop-Hooks + 11 UserPromptSubmit-Hooks.

---

## 1. Aggregation pro Hook

### Stop-Hooks (9 Stück)

Trennen via: `*stop*`, `*verify.py`, `paul-memory-stop`, `learning-detection`, `playbook-stop`, `git-changes-reminder`, `premature-done`, `capture-all-events.*Stop`

Pro Hook erheben:
- `count` — Aufrufe über die Woche
- `p50, p95, p99, avg dur_ms`
- `non-zero exits` (count + Exit-Codes)
- `avg + max stdout_bytes`
- `TOTAL stdout_bytes` → Token-Bloat-Indikator
- `TOTAL dur_ms` → Time-Spender-Indikator

### UserPromptSubmit-Hooks (11 Stück)

Trennen via: `signal-detection`, `smart-skills-activation`, `clear-thinking`, `correction-to-learning`, `quick-save-evening`, `token-warning`, `update-tab-titles`, `pn-context-injection`, `telos-context-loader`, `explicit-rating-capture`, `capture-all-events.*UserPromptSubmit`

Pro Hook erheben:
- `count`
- `p50, p95, p99, avg dur_ms`
- `non-zero exits`
- `avg + max stdout_bytes`
- `TOTAL stdout_bytes`
- `TOTAL dur_ms`

---

## 2. Tier-Klassifikation

| Tier | Kriterium | Aktion |
|------|-----------|--------|
| **Tier 1 SYNC** | p95 < 100ms, exit immer 0, stdout_bytes < 200 | bleibt am Event |
| **Tier 2 GATED** | nur bei bestimmten Contexts sinnvoll | Gating-Logik ergänzen (z.B. nur wenn Daily Note existiert) |
| **Tier 3 ASYNC** | p95 > 200ms ODER stdout_bytes > 1000 ODER unrelated zum User-Output | Daemon via Unix-Socket |
| **Tier KILL** | immer Exit ≠ 0 / hängt / nie genutzt | löschen |

---

## 3. Wide-Event-Insights

- Top-3 Time-Spender (Stop)
- Top-3 Time-Spender (UserPromptSubmit)
- Top-3 Context-Bloat (stdout_bytes total) → Token-Killer im Main-Context
- **Korrelierte Slow-Sessions**: Zeitfenster wo MEHRERE Hooks zusammen > 500ms

---

## 4. Empfehlung — konkret und actionable

### Refactor-Optionen

- **Option A (Parallel + Timeout):** Alle Hooks parallel spawnen, hard timeout 200ms. Minimal-invasiv.
- **Option B (Tier-Split mit Daemon):** Tier-3-Daemon nimmt async Observers, Event returnt in <50ms. Mehr Komplexität.
- **Option C (Radical Reduce):** 60% der Hooks löschen.

**Erwartete Realität:** Mischung aus C (delete für unused) + A (parallel für behaltene).

### Output-Tabellen

[TODO — nach Datenauswertung am 2026-05-12 ausfüllen]

**Tabelle Stop-Hooks**

| Hook | count | p50_ms | p95_ms | p99_ms | avg_ms | errors | avg_b | max_b | total_b | total_ms | Tier |
|------|-------|--------|--------|--------|--------|--------|-------|-------|---------|----------|------|
| ... | | | | | | | | | | | |

**Tabelle UserPromptSubmit-Hooks**

| Hook | count | p50_ms | p95_ms | p99_ms | avg_ms | errors | avg_b | max_b | total_b | total_ms | Tier |
|------|-------|--------|--------|--------|--------|--------|-------|-------|---------|----------|------|

### 3-Schritte-Aktionsplan (nach ROI)

[TODO — nach Datenauswertung am 2026-05-12 ausfüllen]

1. **[HÖCHSTER ROI]:** ...
2. **[MITTLERER ROI]:** ...
3. **[NIEDRIGSTER ROI]:** ...

---

## Bash-Helpers

```bash
# Per-Hook Aggregation mit Bytes
jq -s 'group_by(.cmd) | map({
  cmd: .[0].cmd,
  count: length,
  avg_ms: (map(.dur_ms) | add / length),
  p95_ms: (map(.dur_ms) | sort | .[(length * 0.95 | floor)]),
  avg_bytes: (map(.stdout_bytes // 0) | add / length),
  max_bytes: (map(.stdout_bytes // 0) | max),
  total_bytes: (map(.stdout_bytes // 0) | add),
  total_ms: (map(.dur_ms) | add),
  errors: map(select(.exit != 0)) | length
}) | sort_by(.total_bytes) | reverse' ~/.claude/logs/hooks.jsonl

# Top 5 Context-Bloat
jq -s 'group_by(.cmd) | map({
  cmd: .[0].cmd,
  total_bytes: (map(.stdout_bytes // 0) | add)
}) | sort_by(.total_bytes) | reverse | .[0:5]' ~/.claude/logs/hooks.jsonl

# Top 5 Time-Spender
jq -s 'group_by(.cmd) | map({
  cmd: .[0].cmd,
  total_ms: (map(.dur_ms) | add)
}) | sort_by(.total_ms) | reverse | .[0:5]' ~/.claude/logs/hooks.jsonl

# Error-Hooks
jq 'select(.exit != 0) | .cmd' ~/.claude/logs/hooks.jsonl | sort | uniq -c | sort -rn

# Sample-Größe
wc -l ~/.claude/logs/hooks.jsonl
```

---

## Backup & Rollback

```bash
cp ~/.claude/settings.json.bak-20260506-083017 ~/.claude/settings.json
```

---

## Methodik-Anker

- **Indy Dev Dan:** Big Three, R&D Framework, Anti-Pattern #3 Default-mit-allem, Anti-Pattern #5 No Observability
- **R&D Framework:** Reduce or Delegate
- **Earn Complexity:** Specialize, dann scale
- **Keine Roman-Empfehlung** — Tabellen + Aktion

---

*Hypothese vor Datenauswertung:* `telos-context-loader.ts` und `pn-context-injection.ts` sind Top-Bloat-Quellen.
