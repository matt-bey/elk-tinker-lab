# PAM8403 Amplifier Board — Setup Reference

## Overview

A small, inexpensive Class D stereo amplifier breakout board built around the PAM8403 IC.

**Specs:**
- Supply voltage: 5V (USB or GPIO pin)
- Output: 2x 3W into 4Ω speakers
- Efficiency: ~90% (Class D — minimal heat)
- SNR: 80dB
- On-board volume potentiometer
- Total harmonic distortion: <0.1% at 1W

**Used in:** [Mini CRT Arcade Box](../../projects/mini-crt-arcade/)

---

## Wiring

### Power (from Pi GPIO header)

| PAM8403 Pin | Pi Physical Pin | Pi GPIO (BCM) | Signal |
|-------------|----------------|---------------|--------|
| VCC (5V) | 2 or 4 | — | 5V |
| GND | 6 | — | GND |

The PAM8403 runs at 5V. Draw is minimal at moderate volume — roughly 200-300mA peak per channel into 4Ω at 3W output, but typical listening levels are well below this.

### Audio Input (from Waveshare display 3.5mm jack)

| PAM8403 | 3.5mm Cable | Signal |
|---------|-------------|--------|
| L+ | Tip (left) | Left audio |
| L− | Sleeve (ground) | Ground |
| R+ | Ring (right) | Right audio |
| R− | Sleeve (ground) | Ground |

The PAM8403 input is differential. Tie the negative inputs (L−, R−) to the cable's ground/sleeve conductor.

### Speaker Outputs

| PAM8403 | Speaker |
|---------|---------|
| L+, L− | Left speaker (4Ω, 3W rated minimum) |
| R+, R− | Right speaker (4Ω, 3W rated minimum) |

Polarity matters for stereo imaging — wire both speakers consistently (+ to +, − to −). Reversing one speaker causes the channels to partially cancel, producing thin-sounding audio.

---

## Volume Potentiometer

The on-board potentiometer attenuates the input signal before amplification. Mount the board so the potentiometer is accessible from outside the enclosure (front panel knob).

In the Mini CRT Arcade build, the pot doubles as a period-correct CRT-style volume knob.

---

## Power Budget Contribution

At typical RetroPie/NES gaming volume levels (~50% of max), the PAM8403 draws approximately 200-400mA from the 5V supply. At full volume with 4Ω speakers, theoretical max is ~1.5A, but thermal limiting and typical content keep real-world draw much lower.

See [pi-power-budgeting.md](../../docs/pi-power-budgeting.md) for full build power budget.

---

## Notes

- **No heatsink required** — Class D efficiency means the IC stays cool at normal listening volumes
- **5V is correct** — do not exceed 5.5V; the IC can be damaged at higher voltages
- **Cheap boards vary** — the 5-packs sold on Amazon are functional but quality control varies; test all 5 before selecting one for the build
- **No pop filter** — there may be a power-on pop through the speakers; this is normal for this IC
