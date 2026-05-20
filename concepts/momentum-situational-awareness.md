---
slug: momentum-situational-awareness
title: Momentum & Situational Awareness (Kristian Kullamägi)
tags:
  - trading
  - momentum
  - situational-awareness
  - tc2000
  - vcp
  - cup-with-handle
created: 2026-05-04
---

# Momentum & Situational Awareness

## 1. Was ist Momentum?

**Momentum = Speed/Velocity of a Move**

Wie schnell bewegt sich eine Aktie?
- Gemessen durch **Rate of Change (ROC)** = Ratio von zwei Preisen
- Kann sein: **Price/Moving Average** ODER **Price Today/Price N Days Ago**

## 2. Time Periods für Momentum

| Zeitraum | Trading Days | Momentum-Typ |
|---|---|---|
| 25 Tage | 1 Monat | Short-term |
| 63 Tage | 3 Monate (Quarter) | Intermediate |
| 126 Tage | 6 Monate | Long-term |

> **Wichtig:** Über 6 Monate hinaus verpasst man meist den Move!

## 3. TC2000 Formulas

### Relative Momentum (Ranking)
```
C/avgC25      → 1-month momentum
C/avgC63      → 3-month momentum (quarter)
C/avgC126     → 6-month momentum
```

### Offset Momentum (für VCP/Cup-with-Handle)
```
C25/avgC126.25   → 6-month momentum, offset by 1 month
C50/avgC126.50   → 6-month momentum, offset by 2 months
```

### Absolute Momentum (Threshold-based)
```
C/C25 >= 1.20           → Stock up 20%+ in 1 month
avgC7/avgC65 >= 1.05    → Momentum still active
```

## Relative vs. Absolute Momentum

### Relative Momentum
- Ranking von Stocks nach Momentum
- **Problem:** Zeigt nicht, ob Stock noch IN Momentum ist
- Kann extended Stocks enthalten die bereits reversed sind

### Absolute Momentum
- Threshold-based: Nur Stocks die bestimmte Kriterien erfüllen
- Zeigt wo Momentum startete und wo es endete
- Beispiel: `C/C25 >= 1.20` = nur Stocks mit 20%+ in 1 Monat

> *"Absolute momentum tells you where momentum started and ended on a stock"*

## Offset Momentum für VCP/Cup-with-Handle

**Problem:** Short-term momentum zeigt oft extended Stocks

**Lösung:** Offset by 1-2 Monate

```
C25/avgC126.25  → Welcher Stock war vor 1 Monat #1 by 6-month momentum?
C50/avgC126.50  → Welcher Stock war vor 2 Monaten #1?
```

**Vorteil:** Findet Stocks die:
- Großen Move gemacht haben
- Jetzt Base/Consolidation bilden
- VCP oder Cup-with-Handle Pattern zeigen

## Watchlist Creation Workflow

### Schritt 1: Multi-Timeframe Ranking
- Sort by 25-day momentum → Top 25 stocks
- Sort by 63-day momentum → Top 25 stocks
- Sort by 126-day momentum → Top 25 stocks
- **Offset Momentum (empfohlen):** C25/avgC126.25

### Schritt 2: Combine into Watchlist
- Flag all symbols → Copy to "Momentum 25" watchlist
- Ergibt ca. 50-75 Stocks

### Schritt 3: Daily Review
- Welche setzen up?
- Suche nach Pause in Momentum (2-3 Tage sideways)
- Entry auf Breakout

## Trading Applications

### 1. Anticipation Setup (Primary Use)
- Stock mit Momentum
- 2-3 Tage Pause/Sideways
- Entry auf Breakout

### 2. VCP/Cup-with-Handle
- Use 6-month momentum offset by 1-2 months
- Stock hat Big Move gemacht
- Bildet jetzt längere Consolidation
- Breakout = Multi-leg potential

### 3. Mean Reversion
- Gleiche Watchlist nutzbar
- Orderly Pullback auf Support
- Entry auf Bounce

## Sector Insights

> *"By the time you know a sector has momentum, you're too late!"*

**90% der Momentum-Stocks kommen aus:**
- Technology
- Healthcare
- Consumer Discretionary

**Pradeep's View:** Sector-Analyse ist meist nutzlos, weil:
- Wenn Sector als #1 ranked ist, sind Stocks bereits extended
- Besser: Momentum Burst am START des Moves finden

## Situational Awareness (SA)

**Essentiell für Momentum Trading!**

Auch IBD und Mark Minervini nutzen SA:
- **IBD:** "M" in CANSLIM = Market Direction
- **Minervini:** Tradet nur wenn Markt-Momentum stimmt
- **Kristian Kullamägi (Kacher Kula):** 10-day > 20-day MA

> *"You cannot escape SA if you want to do any kind of trading"*

## Momentum Burst Connection

```
Momentum Burst → Relative Momentum → Absolute Momentum
```

- **Momentum Burst** ist der START
- Führt zu hohem Relative Momentum Ranking
- Wird messbar durch Absolute Momentum

> *"Focus on Momentum Burst to find stocks at the START of momentum phase"*
