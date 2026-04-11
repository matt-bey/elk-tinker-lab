# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Purpose

A personal monorepo for Raspberry Pi and Arduino tinkering projects. Combines project
workspaces, hardware documentation, configuration files, setup scripts, and architecture
decision records. Built solo and with my son.

Keep this file under 200 lines. Detailed conventions are in .claude/rules/.

## Structure

```
adr/             # Cross-project Architecture Decision Records (currently none)
components/      # Single-component hardware docs (wiring, pinouts, setup)
docs/            # Cross-cutting reference topics (GPIO numbering, SPI vs I2C, etc.)
inventory.md     # Workbench hardware inventory — check here before suggesting purchases
projects/        # All hardware builds — Pi, Arduino, or mixed
  _template/     # Copy this to start a new project
  mini-crt-arcade/  # PRIMARY ACTIVE PROJECT
scripts/         # Reusable scripts shared across multiple projects
software/        # OS and software configuration topics
.claude/
  commands/      # Custom slash commands (/project:new-project, /project:deploy)
  rules/         # Behavioral conventions for working in this repo
```

## Hardware Available

See inventory.md for the full workbench inventory. Key boards:
- Raspberry Pi Zero W — primary tinkering board
- Raspberry Pi Zero 2W — reserved for future projects
- Raspberry Pi 1B+ — available (40-pin header)
- Raspberry Pi 2B — low-stakes tinkering
- Raspberry Pi 4 (4GB) — future dev setup
- MacBook — primary admin machine (SSH, nmap, Raspberry Pi Imager)

## Key Conventions

- Check inventory.md before suggesting component purchases
- All projects live in /projects/ regardless of board (Pi, Arduino, or mixed)
- Config files in projects/<name>/config/ are source of truth — deploy via deploy.sh
- /scripts/ at root is for cross-project reusable scripts only
- Project-specific scripts live in projects/<name>/scripts/
- Individual projects may have their own build systems — this is expected
- ADRs live in projects/<name>/adr/ for project-specific decisions; root /adr/ is for cross-project decisions only
- Project DECISIONS.md is for minor choices that don't warrant a full ADR
- SSH assumes ~/.ssh/pi_key is configured for passwordless Pi access

## No Repo-Level Build System

No CI, no linting, no test suite at the repo level. Individual projects may contain
their own build artifacts (requirements.txt, Makefile, etc.) scoped to that project.

## Commit Style

Use [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): description`

Types for this repo:

| Type      | Use for                                          |
|-----------|--------------------------------------------------|
| `project` | New project or major project milestone           |
| `docs`    | README, ADRs, DECISIONS.md, component docs       |
| `config`  | Pi/Arduino config files                          |
| `hw`      | Wiring diagrams, pinouts, schematic notes        |
| `inv`     | inventory.md updates                             |
| `fix`     | Corrections to docs or configs                   |
| `chore`   | Repo structure, template changes, scripts        |

Scope is optional but helpful: `docs(mini-crt-arcade)`, `config(retropie)`, `hw(pam8403)`.

## Custom Commands

- /project:new-project <name> — scaffold a new project from _template
- /project:deploy <project> — deploy project configs to target device
