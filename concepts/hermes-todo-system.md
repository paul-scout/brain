---
title: "Hermes Todo-System"
created: 2026-05-05
tags: [hermes, todos, system, convention]
---

# Hermes Todo-System

## Konvention

**Persistenter Speicherort:** `/Users/admin/brain/projects/hermes-todos.md`

> ⚠️ **Immer absoluten Pfad verwenden — KEIN ~**

## Workflow

1. **Am Session-ENDE:** Hermes fragt "Soll ich To-Dos aktualisieren?"
2. **Wenn Jost "To-Dos" sagt (Start):** Sofort /Users/admin/brain/projects/hermes-todos.md lesen
3. **Neue Todos:** In `Aktive Todos` oben eintragen
4. **Erledigte Todos:** Nach unten in `Erledigte Todos` Tabelle verschieben
5. **Review:** Jost kann die Datei direkt in Obsidian bearbeiten

## Warum nicht Session-Todos?

Session-Todos (`/todo`) sind nur innerhalb einer Session sichtbar. Die Brain-Datei ist persistent und wird bei jeder Session geladen.

## Format für neue Todos

```markdown
| Prio | Todo | Deadline | Beschreibung |
|------|------|----------|--------------|
| 🔴 | Titel | YYYY-MM-DD | Kurzbeschreibung |
```

**Prio:** 🔴 hoch / 🟡 mittel / 🟢 niedrig

> Deadline und Beschreibung sind optional aber empfohlen.

## Datei

`/Users/admin/brain/projects/hermes-todos.md`

## Verknüpfungen

- Hermes Todos: [[hermes-todos]]
- Brain Hub: [[brain]]
