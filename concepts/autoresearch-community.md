---
title: "Awesome Autoresearch — Community Guide"
type: concept
tags: [ai-agents, autonomous-research, llm, self-improvement]
created: 2026-05-06
---

# Awesome Autoresearch — Community Guide

## Overview

Quelle: [github.com/alvinreal/awesome-autoresearch](https://github.com/alvinreal/awesome-autoresearch) — 1.1k Stars, 12 Contributors, CC0-1.0.

Curated Index von autonomen Improvement-Loops, Research Agents und Descendants inspiriert von karpathy/autoresearch.

## Kernpattern

> **Metrik definieren → Loop: Code generieren → Testen → Keep/Revert → Iterieren**

> *"If you can measure it, you can optimize it."* —通用pattern

## Kategorien

### 🛠️ General-Purpose Descendants (23 Projekte)

| Projekt | Focus |
|--------|-------|
| `kayba-ai/recursive-improve` | Keep-or-revert mit Failure-Pattern-Analyse |
| `auditgoenka/autoresearch` | Claude Code Skill,通用化 |
| `gemini-autoresearch` | Gemini CLI, 1M token context, --yolo headless |
| `james-s-tayler/lazy-developer` | Multi-Goal via GOAL.md |
| `gepa-ai/gepa` | **ICLR 2026 Oral** — Reflective Prompt Evolution, schlägt RL (GRPO) |
| `MrTsepa/autoevolve` | Self-Play mit Elo/Bradley-Terry |
| `ShengranHu/ADAS` | **ICLR 2025** — Meta-Agents die neue Agent-Architekturen erfinden |

### 🔬 Research-Agent Systems (19 Projekte)

| Projekt | Focus |
|--------|-------|
| `SakanaAI/AI-Scientist` | Auto-Discovery: Idee → Paper |
| `HKUDS/AI-Researcher` | **NeurIPS 2025**: Hypothesis → Manuscript → Peer Review |
| `Human-Agent-Society/CORAL` | **arXiv:2604.01658**: Multi-Agent Evolution, SOTA auf 10 Tasks |
| `AgentRxiv` | Autonome Labore teilen Preprint-Server |
| `WecoAI/aideml` | Tree-search ML Engineering, Cloud Platform |

### 💻 Platform Ports & Hardware (10)

| Port | Platform |
|------|----------|
| `autoresearch-macos` | Apple Silicon / MPS |
| `autoresearch-mlx` | MLX-native, kein PyTorch/CUDA |
| `autoresearch-win-rtx` | Windows RTX consumer NVIDIA |
| `n-autoresearch` | Multi-GPU, crash recovery |
| `autoresearch-webgpu` | **Komplett im Browser** |
| Colab/Kaggle T4 | Free GPU, zero setup |

### 🎯 Domain-Specific Adaptations

| Domain | Projekt | Metrik |
|--------|---------|--------|
| **Trading** | `atlas-gic` | Sharpe Ratio statt Loss |
| **Genealogy** | `autoresearch-genealogy` | Familienhistorie verifizieren |
| **GPU Kernels** | `autokernel` | Benchmark-Scores |
| **Sudoku** | `autoresearch-sudoku` | Rust Solver, schlägt humanaus |
| **Spring Boot** | `autospec` | 119 → 950 Zeilen in 5 Zyklen |

### 📈 Notable Use Cases

- **Shopify Liquid** — Tobi Lütke: parse/render speedups + allocation reductions
- **Tennis XGBoost** — inkl. Reward Hacking writeup (lehrreich!)
- **Vesuvius Challenge** — Ancient scroll ink detection
- **Baseball Biomechanics** — Pitch velocity prediction

## Bewertung

Das Pattern ist **universell anwendbar** — jede Domäne mit messbarer Metrik. Besonders spannend für:
- Josts Trading (Sharpe Ratio als Fitness-Function)
- KI-Consulting (Prompt-Optimierung)
- Agency Pipeline (Outreach-Scoring)

## Related

[[trading-system]] — Trading-Setup mit messbaren Metriken
[[claude-code-cost-optimization-via-model-routing]] — Routing-Optimierung als messbare Metrik
