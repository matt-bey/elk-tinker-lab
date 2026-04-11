# Pi Project Docs

A personal monorepo for Raspberry Pi and Arduino tinkering projects — a combined knowledge base, config store, and project workspace. Built solo and with my son.

## Active Project

**[Mini CRT Arcade Box](projects/mini-crt-arcade/)** — A desk-sitting retro arcade box styled as a miniature CRT television. Raspberry Pi Zero W running RetroPie with HDMI display and PAM8403 amplifier audio.

## Structure

```
adr/             # Architecture Decision Records — why decisions were made
components/      # Single-component hardware docs (wiring, pinouts, setup)
docs/            # Cross-cutting reference topics
inventory.md     # Workbench hardware inventory
projects/        # All hardware builds
scripts/         # Reusable scripts shared across projects
software/        # OS and software configuration
.claude/         # Claude Code configuration (commands, rules)
```

## Hardware Inventory

See [inventory.md](inventory.md) for what's on the bench — boards, displays, audio, passives, and tools.

## Navigation

- **Starting a new project?** Copy `projects/_template/` and rename it.
- **Looking for component wiring?** Check `components/`.
- **Wondering why a decision was made?** Check `adr/`.
- **Need Pi OS or RetroPie setup steps?** Check `software/`.
- **Cross-cutting topics** (GPIO numbering, SPI vs I2C): check `docs/`.
