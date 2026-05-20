---
title: Hermes Gateway LaunchDaemon auf macOS
type: permanent-note
tags:
  - hermes
  - macos
  - launchd
  - operations
created: 2026-05-18
updated: 2026-05-18
---

# Hermes Gateway LaunchDaemon auf macOS

## Kontext

Hermes Gateway soll auf Josts Mac dauerhaft headless/SSH-tauglich laufen. Ein normaler macOS LaunchAgent unter `~/Library/LaunchAgents` ist dafür ungeeignet, weil er an die `gui/<uid>`-Domain und damit an eine Desktop-/Login-Session gebunden ist.

In SSH-/Background-Sessions zeigte sich:

```bash
launchctl print gui/501/ai.hermes.gateway
# Could not print domain: 125: Domain does not support specified action
```

Der richtige Ansatz ist ein systemweiter LaunchDaemon unter:

```text
/Library/LaunchDaemons/ai.hermes.gateway.plist
```

Der Daemon läuft als User `admin`, nutzt `HERMES_HOME=/Users/admin/.hermes` und startet den Gateway dauerhaft unabhängig von GUI-Login oder SSH-Logout.

## Finaler Zustand am 2026-05-18

Verifiziert:

```text
sudo launchctl print system/ai.hermes.gateway | grep -E 'state =|pid =|username ='
state = running
username = admin
pid = 21473
```

```text
hermes cron status
✓ Gateway is running — cron jobs will fire automatically
PID: 21473
11 active job(s)
Next run: 2026-05-19T07:00:00+02:00
```

```text
pgrep -af 'hermes.*gateway'
21473
```

Alter LaunchAgent wurde deaktiviert:

```bash
launchctl bootout "gui/$(id -u)/ai.hermes.gateway" 2>/dev/null || true
mv /Users/admin/Library/LaunchAgents/ai.hermes.gateway.plist /Users/admin/Library/LaunchAgents/ai.hermes.gateway.plist.disabled 2>/dev/null || true
```

## Warum LaunchDaemon statt LaunchAgent

- LaunchAgent: läuft in `gui/<uid>`, braucht Desktop-/Login-Session.
- SSH-Session auf diesem Mac landet in `user/501` / Background; `gui/501` ist dort nicht zuverlässig ansprechbar.
- LaunchDaemon: läuft in `system`, startet ab Boot und ist unabhängig von GUI-Login.
- Mit `UserName=admin` laufen Prozesse trotzdem als normaler User und verwenden `/Users/admin/.hermes`.

## Robuste Erstellung mit PlistBuddy

Lange Heredocs/Pastes wurden in der SSH-Shell mehrfach beschädigt. Robuster ist der Aufbau mit kurzen `/usr/libexec/PlistBuddy`-Kommandos.

### 1. Alte/kaputte plist löschen und neue initialisieren

```bash
sudo rm -f /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Clear dict" /Library/LaunchDaemons/ai.hermes.gateway.plist
```

### 2. Basis-Felder setzen

```bash
sudo /usr/libexec/PlistBuddy -c "Add :Label string ai.hermes.gateway" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :UserName string admin" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :GroupName string staff" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :WorkingDirectory string /Users/admin/.hermes/hermes-agent" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :RunAtLoad bool true" /Library/LaunchDaemons/ai.hermes.gateway.plist
```

### 3. ProgramArguments setzen

```bash
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments array" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:0 string /Users/admin/.hermes/hermes-agent/venv/bin/python" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:1 string -m" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:2 string hermes_cli.main" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:3 string gateway" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:4 string run" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:5 string --replace" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments:6 string --accept-hooks" /Library/LaunchDaemons/ai.hermes.gateway.plist
```

### 4. EnvironmentVariables setzen

```bash
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:HOME string /Users/admin" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:HERMES_HOME string /Users/admin/.hermes" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:VIRTUAL_ENV string /Users/admin/.hermes/hermes-agent/venv" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:HERMES_ACCEPT_HOOKS string 1" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables:PATH string /Users/admin/.hermes/hermes-agent/venv/bin:/Users/admin/.local/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin" /Library/LaunchDaemons/ai.hermes.gateway.plist
```

### 5. KeepAlive und Logs setzen

```bash
sudo /usr/libexec/PlistBuddy -c "Add :KeepAlive dict" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :KeepAlive:SuccessfulExit bool false" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :StandardOutPath string /Users/admin/.hermes/logs/gateway.log" /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo /usr/libexec/PlistBuddy -c "Add :StandardErrorPath string /Users/admin/.hermes/logs/gateway.error.log" /Library/LaunchDaemons/ai.hermes.gateway.plist
```

### 6. Rechte setzen und validieren

```bash
sudo chown root:wheel /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo chmod 644 /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo plutil -lint /Library/LaunchDaemons/ai.hermes.gateway.plist
```

Erwartung:

```text
/Library/LaunchDaemons/ai.hermes.gateway.plist: OK
```

### 7. Laden und starten

```bash
sudo launchctl bootout system/ai.hermes.gateway 2>/dev/null || true
sudo launchctl bootstrap system /Library/LaunchDaemons/ai.hermes.gateway.plist
sudo launchctl enable system/ai.hermes.gateway
sudo launchctl kickstart -k system/ai.hermes.gateway
```

### 8. Verifikation

```bash
sudo launchctl print system/ai.hermes.gateway | grep -E 'state =|pid =|username ='
hermes cron status
pgrep -af 'hermes.*gateway'
```

Erwartung:

```text
state = running
username = admin
pid = <pid>

✓ Gateway is running — cron jobs will fire automatically

pgrep zeigt genau einen Gateway-Prozess
```

## Betrieb

Restart:

```bash
sudo launchctl kickstart -k system/ai.hermes.gateway
```

Stop:

```bash
sudo launchctl bootout system/ai.hermes.gateway
```

Status:

```bash
sudo launchctl print system/ai.hermes.gateway | grep -E 'state =|pid =|username ='
hermes cron status
pgrep -af 'hermes.*gateway'
```

## Hinweis zu `hermes gateway status`

`hermes gateway status` kann weiterhin den alten LaunchAgent-Pfad unter `~/Library/LaunchAgents` prüfen und dadurch irreführend melden, dass der Service nicht geladen sei. Für diese headless/SSH-Installation sind die maßgeblichen Checks:

```bash
sudo launchctl print system/ai.hermes.gateway
hermes cron status
pgrep -af 'hermes.*gateway'
```

## Verwandt

- [[hermes-agent]]
- [[gbrain]]
