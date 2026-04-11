# Project Conventions

When working in this repository, follow these conventions:

## Creating or editing project files
- Project status must be one of: Active | Paused | Complete | Abandoned
- Always include status as the first line of every project README.md
- Hardware requirements must reference inventory.md — note if items are on-hand or need purchasing
- Config files in projects/<name>/config/ are the source of truth — they deploy to the Pi via deploy.sh

## Architecture decisions
- Project-specific ADRs belong in projects/<name>/adr/ — not in the root /adr/
- Root /adr/ is reserved for decisions that genuinely span multiple projects (rare)
- Project DECISIONS.md is for minor choices that don't warrant a full ADR
- ADR filenames follow the pattern: NNN-short-title.md (e.g., 004-power-supply-choice.md)
- Number ADRs per-project starting from 001

## Scripts
- deploy.sh always uses SSH key authentication (assumes ~/.ssh/pi_key is configured)
- setup.sh must be idempotent — safe to run multiple times on the same device
- Root /scripts/ is for cross-project reusable scripts only

## Inventory
- Update inventory.md when new hardware is acquired
- Mark items as "ordered" vs "on hand" vs "returned/removed"
