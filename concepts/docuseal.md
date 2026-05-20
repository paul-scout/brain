---
title: "DocuSeal — Open Source DocuSign Alternative"
type: concept
tags: [tool, saas, document-signing, pdf, open-source]
created: 2026-05-06
---

# DocuSeal — Open Source DocuSign Alternative

## Was es ist

DocuSeal ist eine Open-Source-Plattform für sichere digitale Dokumentenunterzeichnung und -verarbeitung. PDF-Formulare erstellen, ausfüllen und online unterschreiben lassen — auf jedem Gerät.

**Repo:** https://github.com/docusealco/docuseal
**Live Demo:** https://demo.docuseal.tech
**Website:** https://docuseal.com

## Tech Stack

| Schicht | Technologie |
|---------|------------|
| Backend | Ruby 4.0.1 + Ruby on Rails 7 (Turbo/Hotwire) |
| Frontend | Vue.js 3 + Tailwind CSS + Webpack (Shakapacker) |
| PDF-Verarbeitung | HexaPDF + Pdfium (Binärbibliothek) |
| KI/ML | ONNX Runtime — automatisches Feld erkennen in Dokumenten |
| Datenbank | PostgreSQL (Standard), MySQL/SQLite optional |
| Background Jobs | Sidekiq (Redis) |
| Auth | Devise + devise-two-factor (2FA) |
| Storage | AWS S3, Google Cloud Storage, Azure Blob, lokal |
| Deployment | Docker + Docker Compose (mit Caddy für HTTPS) |

## Features

### Core (Open Source)
- WYSIWYG PDF-Formular-Builder
- 12 Feldtypen: Signature, Date, File, Checkbox, Text, etc.
- Mehrere Unterzeichner pro Dokument
- Automatisierte E-Mails via SMTP
- PDF eSignature (automatisch)
- PDF-Signatur-Verifizierung
- User Management
- Mobile-optimiert
- 7 UI-Sprachen, Signatur in 14 Sprachen
- API + Webhooks
- Deployment in Minuten

### Pro Features (kostenpflichtig)
- Company Logo + White-Label
- User Roles
- Automatisierte Erinnerungen
- SMS-Verifikation (Invitation + Identify)
- Conditional Fields + Formulas
- Bulk Send (CSV, XLSX)
- SSO / SAML
- Template creation via HTML API
- Template via PDF/DOCX + Field Tags API
- Embedded Signing Form (React, Vue, Angular, JavaScript SDKs)
- Embedded Form Builder SDKs

## Architektur-Insights

- **Multi-Stage Docker-Build** — sehr sauber getrennt (Download → Webpack → App)
- **32 Models, 97 Controller** — substantial Rails App
- **ONNX-Modell** für Felderkennung: `/tmp/model.onnx` (704 Int8 quantisiert)
- **Pdfium** als separate Binary für PDF-Rendering
- **MCP-Tokens** in der DB — deutet auf Model Context Protocol Integration hin (KI-Agent-Fähigkeit)
- **Letzte Migration:** April 2026 — aktive Entwicklung

## Deployment

```sh
# Schnellstart (SQLite)
docker run --name docuseal -p 3000:3000 -v.:/data docuseal/docuseal

# Mit PostgreSQL + HTTPS (Caddy)
curl https://raw.githubusercontent.com/docusealco/docuseal/master/docker-compose.yml > docker-compose.yml
sudo HOST=your-domain.com docker compose up
```

## Lizenz

AGPLv3 + Additional Terms (Section 7(b)). Alle Files © 2023-2026 DocuSeal LLC.

## Relevanz für Jost

- **KI-Consulting Pitch-Potenzial:** Dokumentenunterzeichnung ist ein Massen-Use-Case in Banking, Healthcare, Real Estate, eCommerce, KYC
- **Hosting/Beratung** als Service vorstellbar
- **Embedding via SDK** für eigene Produkte denkbar
- Konkurrenz zu PandaDoc, HelloSign, DocuSign — aber Open Source + self-hosted

## Related

[[saas-ideas]], [[tools-for-projects]], [[document-automation]]
