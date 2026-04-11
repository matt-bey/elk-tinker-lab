# Projects

All hardware builds live here — Raspberry Pi, Arduino, or mixed. One directory per project.

## Active Projects

| Project | Board | Status |
|---------|-------|--------|
| [mini-crt-arcade](mini-crt-arcade/) | Pi Zero W | Active |

## Starting a New Project

Copy `_template/` and rename it:

```bash
cp -r projects/_template projects/my-new-project
```

Or use the Claude command: `/project:new-project my-new-project`

## Conventions

- Each project directory is self-contained: docs, configs, and scripts all live inside it
- `config/` holds files that deploy to the target device — edit here, deploy via `scripts/deploy.sh`
- `scripts/deploy.sh` deploys configs via SSH; `scripts/setup.sh` provisions a fresh device
- See `.claude/rules/project-conventions.md` for full conventions
