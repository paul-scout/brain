---
tags: [macos, openclaw, setup, infrastructure]
created: 2026-04-29
---

# MacBook Clamshell Mode — Openclaw Dauerbetrieb

## Problem
Openclaw MacBook MacBook (Clamshell Mode) so konfigurieren, dass er zugeklappt dauerhaft läuft.

## Setup (per SSH auf dem Openclaw-Mac ausführen)

```bash
# Lid-Close-Sleep komplett deaktivieren (auch ohne externes Display)
sudo pmset -a disablesleep 1

# Alle anderen Sleep-Modi aus
sudo pmset -a sleep 0 disksleep 0 womp 1 tcpkeepalive 1 powernap 0

# Verifizieren
pmset -g | grep -E "disablesleep|sleep|tcpkeepalive"
```

**Entscheidender Schalter:** `disablesleep 1` — ignoriert das Lid-Switch-Signal komplett.

## Voraussetzungen

1. **Netzteil MUSS angeschlossen sein** — ohne Strom geht ein MacBook im Akkubetrieb in Sleep, egal was eingestellt ist
2. **Belüftung beachten** — zugeklappt + Vollbetrieb = Wärmestau. Auf harte Oberfläche stellen, idealerweise hochkant in einen Vertical Stand. Nicht in Schublade oder auf Decke.
3. **Nach macOS-Updates** — `disablesleep` kann nach größeren Updates zurückgesetzt werden. Wenn Mac nach Update plötzlich wieder schläft → Befehl erneut ausführen.

## Rückgängig machen

```bash
sudo pmset -a disablesleep 0
```

## Kurz-Test

Clamshell MacBook zuklappen, 30 Min warten, dann vom Hauptrechner per SSH verbinden. Wenn Verbindung durchgeht → fertig.

## Optional: Caffeinate LaunchDaemon (Doppelabsicherung)

Falls gewünscht als zusätzliche Absicherung — aktuell nicht notwendig wenn `disablesleep 1` greift.
