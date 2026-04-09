# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

A personal knowledge base documenting Raspberry Pi software programming and hardware integration, gathered through tinkering projects (solo and with my son). This is a docs-only repo — no build system, tests, or linting.

## Structure

```
components/      # Docs for individual breakout boards and peripherals
  displays/
  sensors/
  cameras/
  audio/
  networking/
projects/        # Multi-component builds that reference component docs
software/        # OS config, libraries, and other Pi software topics
```

Component docs cover wiring, pinouts, and setup for a single piece of hardware in isolation. Project docs combine multiple components and can reference component docs rather than repeating wiring details. Software docs cover topics that apply across hardware combinations (e.g., enabling SPI/I2C, Python libraries).
