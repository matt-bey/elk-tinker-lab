# ADR 004 — Power Supply v2: Battery + Parallel Distribution

**Status:** In Progress (sourcing components)
**Date:** 2026

## Context

The v1 prototype runs off a 5V/2.1A iPad charger plugged into the Pi's micro USB port. The PAM8403
amplifier is powered from Pi GPIO pins 2/4, meaning the amp draws current through the Pi's PCB.

Two problems with the current approach:

1. **Reboots on amp power toggle:** The PAM8403's potentiometer has a built-in on/off switch. When
   it is switched back on, the amp's bulk capacitors draw an inrush current spike. Because this
   current travels through the Pi's PCB traces, it causes the 5V rail at the Pi to droop enough
   to trigger an undervoltage reset.

2. **No battery / portability:** The system is permanently tethered to a wall outlet. A v2
   enclosure should support battery-powered operation.

## Decision

Replace the wall charger with a **TP4056 + boost combo board** (DWEII or equivalent) paired with
an **18650 lithium cell**, and redesign power distribution so the Pi and PAM8403 are fed in
**parallel** from a common 5V bus rather than the amp being powered through the Pi.

The design is intentionally simple (KISS): one USB-C port on the combo board serves as the charge
port. When the battery needs charging, plug it in and charge; unplug to play. No dual-power
pass-through is required at this stage — see Future Enhancements below.

### Why TP4056 + boost combo board (not IP5306)

The IP5306 is the IC used inside most consumer USB power banks and was the original choice for this
ADR. However, bare IP5306 breakout modules do not exist as a commodity product in the US market —
what gets listed on Amazon and AliExpress as "IP5306 modules" are either TP4056 boards with
misleading descriptions, or full power-bank PCBs not suited for embedded use.

The TP4056 + 5V boost combo board is the readily available, well-documented alternative:

- TP4056 IC handles LiPo cell charging via USB-C input (~1A charge current)
- Onboard boost converter steps 3.7V cell voltage → regulated 5V/2A output
- Built-in battery protection: overcharge, overdischarge, overcurrent cutoff
- **K point (External Key Pad):** solder pad that wires to an external momentary button for
  system on/off — pressing momentarily toggles the boost output
- Auto-shutoff at <50mA load (Pi Zero W at idle draws ~100–150mA, sufficient to hold it awake)
- 5V output available via solder pads (Output +/−) or optional USB-A socket

The board's USB-A socket and Output +/− solder pads expose the same 5V rail. For this build,
wire directly to the Output pads — no USB connectors inside the enclosure.

### Why 18650 cell (not flat LiPo pouch)

The core constraint is cell current: the boost converter must step 3.7V → 5V, and at ~85%
efficiency, peak gaming load (~900–1000mA at 5V) requires ~1.6A continuously from the cell.
Any battery whose protection circuit trips below that draw will cut out mid-game.

Flat LiPo pouches were thoroughly evaluated and ruled out on this basis:

- **Amazon pouches:** universally limited to 1.5A protection circuits — insufficient, no margin
- **Adafruit 2000mAh (#2011):** confirmed 500mA max discharge (DigiKey datasheet) — disqualified
  at 3× under the required draw
- **SparkFun 2Ah (PRT-13855):** overcurrent trip current unpublished; unacceptable uncertainty
  for a known 1.6A load
- **HobbyKing Turnigy 2000mAh 1S:** rated 1C = 2A max — only 25% margin, and requires connector
  adaptation (JST-SYP → solder pads)
- **Phone batteries:** use flat LiPo cells and handle 2–4A easily, but are not usable here —
  their BMS PCB expects multi-pin communication with the phone's PMIC (thermistor, fuel gauge
  lines); a TP4056 won't send those signals, and no phone battery is sold as a bare cell without
  the phone-specific BMS attached

The conclusion: **flat pouch protection circuits on any hobbyist-accessible product top out well
below what this load requires.** The constraint is not the cell chemistry (phones prove pouches
handle high current), it is that no commodity flat pouch with appropriate current ratings is
available without either an incompatible BMS or inadequate protection.

18650 cylindrical cells sidestep this entirely. **Samsung 30Q** (3000mAh, 15A continuous) from
18650batterystore.com is the recommended cell — 9× headroom over peak draw, genuine cell,
domestically shipped. Avoid Amazon for 18650 cells — counterfeits are prevalent.

### How the boost converter works

The onboard boost converter uses a switching circuit to step the cell's 3.7V up to 5V:

1. **Store:** switch closes, current flows through an inductor, building a magnetic field
2. **Release:** switch opens, the inductor collapses its field and generates a voltage spike
   that, added to the battery voltage, exceeds 5V — a diode routes this to the output capacitor
   and load

A feedback loop adjusts the duty cycle to hold the output at exactly 5V as the cell discharges
from 4.2V (full) down to ~3.0V (cutoff). Efficiency is approximately 85%.

### Wiring

```
                     USB-C (built into combo board)
                              │
                              ▼
                  ┌─────────────────────┐
                  │  TP4056 + boost     │
                  │   combo board       │
                  │                     │
                  │  BAT+ ─────────────────────────► 18650 cell +
                  │  BAT- ─────────────────────────► 18650 cell -
                  │                     │
                  │  K point ──────────────────────► [momentary button] ──► GND
                  │                     │
                  │  Output + ──────────────────────────────────────────┐
                  │  Output - (GND) ────────────────────────────────┐   │
                  └─────────────────────┘                           │   │
                                                                     │   │
                                                                   GND  5V BUS
                                                                     │   ├──► [100µF cap] ──► GND
                                                                     │   ├──► Pi GPIO pin 2/4
                                                                     │   └──► PAM8403 VCC
                                                                     │
                                                          Pi GPIO pin 6, PAM8403 GND
```

**5V bus** is not a purchased component — it is the wiring junction where the Output + pad,
Pi GPIO pin 2 (or 4), and PAM8403 VCC all meet. A 2-pin screw terminal block or a small
perfboard pad serves as the physical junction point.

### Parallel power distribution

Both the Pi and amp are fed directly from the combo board's 5V output:

```
Output + ──► 5V bus ──┬──► Pi GPIO pin 2 (or 4)
                       │        (powers Pi + display via shared Pi rail)
                       │
                       └──► PAM8403 VCC
                                 (direct, independent of Pi PCB)

Output − ────────────┬──► Pi GPIO pin 6
                      └──► PAM8403 GND
```

The Pi and display share the GPIO 5V rail as before. The only change from v1 is:
- PAM8403 moves off GPIO and onto a direct bus tap
- Power enters Pi via GPIO 5V pin instead of micro USB

**Why GPIO instead of micro USB for Pi input:** GPIO pins 2/4 are directly tied to the Pi's 5V
rail. Feeding 5V here powers the Pi identically to micro USB without cutting cables.

**Note:** Powering via GPIO bypasses the Pi's onboard polyfuse. The combo board's built-in
protection handles overcurrent in its place.

### Transient suppression capacitor

Even with parallel distribution, the amp's power-on inrush still hits the shared 5V bus. A
100µF capacitor placed across the 5V/GND lines close to the Pi's GPIO header acts as a local
charge reservoir, absorbing fast transients.

- Start with **100µF 50V electrolytic** (already on hand)
- Upgrade to **1000µF 10V** if reboots persist

## Components Required

| Component | Notes | Status |
|-----------|-------|--------|
| TP4056 + 5V/2A boost combo board | USB-C input, Output +/− solder pads, K point pad. DWEII listing on Amazon confirmed. | To purchase |
| Samsung 30Q 18650 cell | 3000mAh, 15A continuous discharge. Buy from 18650batterystore.com — avoid Amazon counterfeits. | To purchase |
| 18650 battery holder (single cell) | Wire leads to BAT+/BAT− pads on combo board | To purchase |
| Momentary push button | Wires to K point — toggles boost output on/off | To purchase |
| Power distribution block, 2-pole 6-position Dupont (×1) | 2-pole = one screw terminal row for 5V, one for GND. Dupont header outputs to Pi GPIO, PAM8403, and cap legs. e.g. Teansic 2x6 position block (pack of 5 — spares useful for future builds) | To purchase |
| Electrolytic capacitor assortment kit | 100µF already on hand for first attempt; buy a mixed kit to have 1000µF ready to swap in if reboots persist. Cap connects across 5V/GND rails via short Dupont jumper wires plugged into spare pins on the distribution block — no perfboard needed. Cap + leg to top row (5V), − leg (shorter lead, striped side) to bottom row (GND). | To purchase |

## Power Budget

| Component | 5V draw |
|-----------|---------|
| Pi Zero W under load | ~400mA |
| Waveshare HDMI display | ~200mA |
| PAM8403 at moderate volume (software-capped) | ~200–300mA |
| USB controller | ~100mA |
| **Total at 5V** | **~900–1000mA** |

**Battery current (at 3.7V, 85% boost efficiency):**
~1000mA × (5 / 3.7) / 0.85 ≈ **~1.6A from cell** at peak load

Samsung 30Q rated at 15A continuous — 9× headroom over peak draw.

**Estimated runtime (Samsung 30Q, 3000mAh):** ~1.5–2 hrs at peak load; ~2.5–3 hrs light use

## Alternatives Considered

| Option | Verdict |
|--------|---------|
| Continue with wall charger (iPad charger) | No battery, no portability — fine for v1, not for v2 |
| IP5306 bare breakout module | Original choice. Confirmed unavailable as commodity product in US market — doesn't exist as a standalone breakout board |
| PiSugar 3 | Purpose-built for Pi Zero W, clean integration. Rejected: connects via pogo pins on the back of the Pi Zero W, which is already occupied by the Waveshare display |
| Flat LiPo pouch (any hobbyist source) | Fully evaluated: Amazon (≤1.5A), Adafruit #2011 (500mA confirmed), SparkFun PRT-13855 (unspecified), HobbyKing Turnigy 2000mAh 1S (2A, 25% margin only). All ruled out — no commodity flat pouch with adequate current rating exists without an incompatible BMS or insufficient protection circuit. Cell chemistry is fine (phones use flat pouches at 2–4A), but maker-accessible products don't expose it usably. |
| Phone battery (flat LiPo pouch, bare cell) | High current capable, but BMS PCB requires multi-pin communication with phone PMIC — TP4056 won't satisfy it. Not sold as bare cells. |

## Future Enhancements

### Dual power: wall DC + battery (pass-through / always-on)

The current design requires charging the battery before play. A future enhancement would add
a direct 5V DC input path (second USB-C port or barrel jack) that powers the system from the
wall while the battery charges, using **Schottky diode OR-ing** to merge the two sources:

```
Boost output → [D1 SS14] ──┐
                             ├──► 5V bus
Direct 5V in → [D2 SS14] ──┘
```

Each SS14 drops ~0.25V; the Pi would see ~4.75V, within operating spec. The direct port would
require a USB-C breakout with 5.1kΩ CC1/CC2 pull-down resistors for charger compatibility.

This was explicitly deferred in favor of the simpler single-port design.
