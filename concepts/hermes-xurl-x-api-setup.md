---
title: Hermes + X API via xurl Skill
type: reference
created: 2026-05-20
updated: 2026-05-20
tags:
  - hermes
  - x-api
  - xurl
  - social-media
source: https://x.com/XDevelopers/status/2056871280599847054
---

# Hermes + X API via xurl Skill

Quelle: X Developers / @XDevelopers
Post/Artikel: https://x.com/XDevelopers/status/2056871280599847054
Artikel-URL: https://x.com/XDevelopers/article/2056871280599847054
Zeitpunkt: 20.05.2026, 00:55
Abruf: 20.05.2026

## Kurzfassung

X Developers beschreibt offiziell, wie Hermes Agent mit dem `xurl` Skill an die X API angebunden wird. Ergebnis: Hermes kann in natürlicher Sprache auf X arbeiten — Posts lesen/suchen, posten, Bookmarks ziehen, Listen verwalten, antworten, liken/reposten und Medien posten — sofern `xurl` lokal installiert und per X Developer App OAuth 2.0 authentifiziert ist.

Wichtig: Hermes selbst braucht einen Modellprovider. Der Artikel empfiehlt für dieses Setup xAI Grok OAuth über eine aktive SuperGrok Subscription. `xurl` ist davon getrennt: Es braucht zusätzlich eine X Developer App mit OAuth-2.0-Credentials.

## Relevanz für Jost

- Direkt relevant für Social-Media-/X-Workflows aus Hermes heraus.
- Offizieller X-Developer-Post validiert den Hermes-`xurl`-Ansatz.
- Auf diesem Mac war beim Abruf `xurl` noch nicht im PATH (`xurl: command not found`). Falls Jost das nutzen will, muss `xurl` installiert und authentifiziert werden.
- Für Agentenbetrieb wichtig: Keine Secrets in Hermes/Chat posten; X Client ID/Secret manuell im Terminal registrieren.
- Aktueller Stand Jost: Er hat einen API Key für Grok. Plan-/Rechtestufe ist noch unklar. Vermutung: Der Key kann eher als Hermes-Modellprovider dienen, ersetzt aber nicht automatisch die X-API-/`xurl`-OAuth-Einrichtung für Lesen/Schreiben auf X.

## Voraussetzungen laut Artikel

- macOS oder Linux
- Terminal (iTerm2, Ghostty, Terminal.app etc.)
- Aktive SuperGrok Subscription: https://x.ai/grok
- Optionaler Fallback: xAI API Key nur falls OAuth/Tier-Restriktionen auftreten
- X Developer App mit OAuth-2.0-Credentials: https://console.x.com bzw. https://developer.x.com/en/portal/dashboard

## Setup-Schritte

### 1. Hermes installieren

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

Danach `hermes` ausführen, um Installation und Setup Wizard zu starten.

### 2. Hermes Setup Wizard ausführen

Wizard erneut starten mit:

```bash
hermes setup
```

Empfohlener Modus:

```text
Quick setup — provider, model & messaging (recommended)
```

Provider laut Artikel:

```text
xAI Grok OAuth (SuperGrok Subscription)
```

Ablauf:

1. Hermes öffnet https://accounts.x.ai
2. Mit dem X Account anmelden, der an SuperGrok hängt
3. Berechtigungen genehmigen
4. Hermes speichert Tokens in `~/.hermes/auth.json`
5. Tokens werden automatisch refreshed

Default-Modell laut Beispiel:

```text
grok-4.3
```

Messaging optional:

```text
Connect a messaging platform? Telegram, Discord etc.
```

Kann übersprungen und später mit `hermes setup gateway` nachgeholt werden.

Nützliche Hermes-Kommandos nach Setup:

```bash
hermes setup            # Setup erneut öffnen
hermes setup model      # Provider/Modell ändern
hermes setup gateway    # Telegram/Discord etc. konfigurieren
hermes model            # Modell wechseln
hermes doctor           # Diagnose
hermes config           # Config ansehen
hermes config edit      # Config bearbeiten
hermes auth add xai-oauth
hermes auth list
hermes auth logout xai-oauth
```

### 3. xurl installieren

`xurl` ist eine separate CLI für die X API. Hermes nutzt sie über den `xurl` Skill.

Optionen:

```bash
# Shell script, ohne sudo, nach ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/xdevplatform/xurl/main/install.sh | bash

# Homebrew macOS
brew install --cask xdevplatform/tap/xurl

# npm
npm install -g @xdevplatform/xurl

# Go
go install github.com/xdevplatform/xurl@latest
```

Falls Shell Script genutzt wurde, ggf. PATH ergänzen:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verifizieren:

```bash
xurl --help
```

### 4. xurl mit X API authentifizieren

Wichtig: Dieser Schritt muss direkt im Terminal passieren, nicht indem Secrets in Hermes/Chat eingefügt werden.

X Developer App:

1. Zu https://developer.x.com/en/portal/dashboard gehen
2. Neue App erstellen oder bestehende App verwenden
3. In den User Authentication Settings Redirect URI setzen auf:

```text
http://localhost:8080/callback
```

4. Client ID und Client Secret kopieren

App lokal in xurl registrieren:

```bash
xurl auth apps add my-app \
  --client-id YOUR_CLIENT_ID \
  --client-secret YOUR_CLIENT_SECRET
```

OAuth starten:

```bash
xurl auth oauth2 --app my-app
```

Das öffnet den Browser. X App mit dem X Account autorisieren.

Wichtig: `--app my-app` beibehalten. Ohne `--app` kann der Token in einem Default-Profil statt in der App mit Client Credentials landen; spätere API Calls können dann mit 401 fehlschlagen.

Falls ein bestimmter Username verknüpft werden muss:

```bash
xurl auth oauth2 --app my-app YOUR_USERNAME
```

Default-App setzen und prüfen:

```bash
xurl auth default my-app
xurl auth status
xurl whoami
```

`xurl whoami` sollte den X Username ausgeben.

### 5. Hermes starten

```bash
hermes
```

In Hermes:

```text
/help
```

Der `/xurl` Skill sollte in der Liste sichtbar sein.

### 6. xurl Skill in Hermes nutzen

In Hermes:

```text
/xurl
```

Der Skill prüft, ob `xurl` installiert und authentifiziert ist.

Beispiele natürlicher Sprache bzw. Skill-Kommandos:

```text
post "Hello from Hermes"
get all of my bookmarks
search for posts about Hermes AI
look up @elonmusk
reply to post 2047107136023650625 with 'great thread'
quote post 2047107136023650625 with my thoughts
like post 2047107136023650625
unbookmark 2047107136023650625
show my latest timeline
post this image with the caption 'sunset'
```

Hermes übersetzt das in `xurl`-Kommandos, führt sie aus und fasst JSON lesbar zusammen.

## Fähigkeiten des xurl Skills / X API über Hermes

- Posten
- Antworten
- Zitieren
- Löschen eigener Posts
- Posts lesen
- Posts suchen
- Nutzerprofile nachschlagen
- Home Timeline anzeigen
- Mentions anzeigen
- Liken / Unliken
- Reposten / Undo Repost
- Bookmarks erstellen, entfernen und listen
- Following / Followers lesen
- Folgen / Entfolgen
- Blockieren / Entblockieren
- Muten / Unmuten
- DMs senden und lesen
- Medien uploaden und posten
- Raw API v2 Requests ausführen

## Konfiguration und Pfade

Hermes-Konfigurationsordner:

```text
~/.hermes/
```

Wichtige Dateien/Ordner:

```text
~/.hermes/config.yaml   # Hauptkonfiguration: Provider, Modell, Agent-Verhalten
~/.hermes/auth.json     # OAuth Tokens, z.B. xAI Grok OAuth; automatisch verwaltet
~/.hermes/.env          # API Keys, z.B. XAI_API_KEY
~/.hermes/cron/         # Scheduled Tasks
~/.hermes/sessions/     # Session-History
~/.hermes/logs/         # Logs
```

## Troubleshooting aus dem Artikel

### `xurl: command not found` in Hermes

- Sicherstellen, dass `xurl` im PATH liegt.
- Bei Shell-Script-Install ggf. `~/.local/bin` in PATH aufnehmen und Hermes neu starten.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### OAuth Flow schließt nicht ab

- Redirect URI in der X Developer App exakt prüfen:

```text
http://localhost:8080/callback
```

- Sicherstellen, dass während `xurl auth oauth2 --app my-app` nichts anderes Port 8080 blockiert.

### OAuth erfolgreich, aber API Calls liefern 401

Wahrscheinlich wurde der OAuth Token nicht mit der App gespeichert, die Client Credentials hat.

Fix:

```bash
xurl auth oauth2 --app my-app
xurl auth default my-app
xurl auth status
```

### API Key enthält Nicht-ASCII-Zeichen

Kann beim Kopieren aus PDFs/Rich-Text passieren. Hermes warnt und entfernt ggf. Zeichen; falls Auth weiter fehlschlägt, Key direkt aus Provider-Dashboard neu kopieren.

### `xurl auth status` zeigt keine aktive Session

```bash
xurl auth oauth2 --app my-app
xurl auth default my-app
```

## Sicherheitsnotizen

- Keine Client Secrets, Tokens oder API Keys in Chat/Hermes einfügen.
- Keine `~/.xurl` Inhalte lesen, kopieren oder in Agentenkontext bringen.
- `xurl auth apps add ... --client-id ... --client-secret ...` sollte Jost selbst lokal ausführen.
- Schreibaktionen auf X (Post, Reply, Like, Repost, DM, Follow, Delete) immer bewusst bestätigen.

## Lokaler Status beim Abruf

Am 20.05.2026 wurde geprüft:

```bash
xurl --help >/tmp/xurl_help.txt 2>&1; xurl auth status
```

Ergebnis:

```text
xurl: command not found
```

Das heißt: Der offizielle Workflow ist dokumentiert, aber auf diesem Mac war `xurl` zu diesem Zeitpunkt noch nicht installiert/verfügbar.

## Original-Artikelinhalt in Stichpunkten

- Hermes ist ein Open-Source AI Agent von Nous Research, der im Terminal läuft.
- Hermes kommt mit einem Skill namens `xurl`.
- `xurl` lässt Hermes auf Wunsch des Nutzers X lesen und schreiben: posten, suchen, Bookmarks holen, Listen managen etc.
- Guide deckt ab: Hermes installieren, Provider verbinden, xurl installieren, X API authentifizieren, Hermes und xurl gemeinsam nutzen.
- Für Modellprovider wird im Artikel xAI Grok OAuth mit SuperGrok Subscription empfohlen.
- `xurl` bleibt separate CLI und braucht X Developer App OAuth 2.0.
- Hermes kann Social-Media-Aktionen conversational verketten: suchen, zusammenfassen, Antwort entwerfen, posten.

## Links

- X Post: https://x.com/XDevelopers/status/2056871280599847054
- X Artikel: https://x.com/XDevelopers/article/2056871280599847054
- Hermes GitHub Installer: https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh
- Hermes Docs: https://hermes-agent.nousresearch.com/docs
- xurl GitHub: https://github.com/xdevplatform/xurl
- X Developer Portal: https://developer.x.com/en/portal/dashboard
- X Developer Console: https://console.x.com/
- xAI Grok: https://x.ai/grok
- xAI Accounts: https://accounts.x.ai/

## Verknüpfte Themen

- [[hermes-agent]]
- [[x-api]]
- [[social-media-automation]]
