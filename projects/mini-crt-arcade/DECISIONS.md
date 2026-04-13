# Decisions Log — Mini CRT Arcade Box

Minor project-specific decisions. Major decisions are in `/adr/`.

---

## 2025 — Power supply: iPad charger

**Decision:** Use a 5V/2.1A iPad charger as the power supply.
**Reason:** Already on hand, confirmed 2.1A is sufficient headroom for the full build (~1A typical draw). No purchase needed.
**Alternatives considered:** Dedicated 3A Pi PSU — overkill for Pi Zero W; USB power bank — adds a charging dependency.

---

## 2025 — Cardboard enclosure for v1

**Decision:** Build the v1 enclosure from cardboard.
**Reason:** Fast to iterate, zero cost, no special tools, good enough to test the CRT aesthetic. A 3D-printed v2 enclosure can be designed once the internal layout is proven.
**Alternatives considered:** 3D printed immediately — requires designing before knowing final component layout.

---

## 2025 — USB NES-style controller for player input

**Decision:** Use a USB NES-style gamepad plugged in from the side.
**Reason:** Built-in controls required components that don't exist in the hobbyist market (see ADR 002). USB controller is zero-config and equivalent gameplay experience.

---

## 2025 — RetroArch aspect ratio: force 4:3

**Decision:** Configure RetroArch to force 4:3 aspect ratio.
**Reason:** NES games were designed for 4:3 TVs. The Waveshare (E) display is native 4:3 (640×480), so no letterboxing occurs — this setting simply locks the correct ratio and prevents any accidental stretch if resolution changes.
