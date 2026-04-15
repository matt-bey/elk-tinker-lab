# Hardware — Antique Telephone AI Operator

## Phase 1: Modern Testing Hardware

Components used to validate software logic before integrating with the antique telephone.

| Component | Details | Status | Source |
|---|---|---|---|
| Raspberry Pi 5 (8GB) | Main compute board | ✅ On hand | — |
| USB microphone | Generic USB — development STT input | ✅ On hand | — |
| Speaker / portable Bluetooth speaker | Development audio output | ✅ On hand | — |
| Push buttons (x2) | Simulate crank trigger and hook switch | ✅ On hand (37-in-1 kit) | — |

## Phase 2: Antique Hardware Integration

Replaces the modern stand-ins above. The telephone is a **Kellogg Chicago antique wood wall telephone (early 1900s)**.

### Original Telephone Components

| Component | Details | Status |
|---|---|---|
| Antique wood wall telephone (Kellogg Chicago) | Complete unit — earpiece, carbon microphone, crank, hook switch, ringer | ✅ On hand |
| Earpiece | DC resistance: **63Ω** — coil intact, functional | ✅ Confirmed working |
| Carbon microphone | DC resistance: **~270Ω** in correct wall-mount orientation (reads ~2kΩ inverted — granules are mobile and responsive to gravity) | ✅ Confirmed working |
| Magneto crank | Confirmed **AC output**, ~5V RMS at normal crank speed (range 3–6V depending on speed) | ✅ Measured — working |
| Hook switch | On/off-hook detection | ⏳ Needs wiring inspection |
| Mechanical ringer | Two 800Ω coils in series — **total impedance: 1604Ω**. Three terminals: outer two connect to coils; center terminal is unused center tap between coils (ignore for this project). Clapper responds to crank AC signal — mechanically intact. Requires 90V AC at 20Hz for full bell strike. | ✅ Measured — working |

#### Carbon Microphone Notes

Resistance is orientation-sensitive — must be tested and mounted in correct wall-mount orientation or granules shift and resistance climbs significantly. Granules confirmed mobile. Functional audio test confirmed: audible signal at 5V bias through earpiece with no amplification; signal strength increased meaningfully when series resistor dropped from 1KΩ to 220Ω, confirming element responds correctly to bias current. Expected to perform well at 12V bias with LM386 amplification in final build.

#### Ringer Notes

The clapper visibly moves when driven by the magneto crank (~3mA at 5V) but does not reach the bells — this is a power issue, not mechanical. At 90V/20Hz the coils will see ~56mA, providing sufficient force for full bell strikes. Do not select a ring generator module rated only for standard 600Ω POTS ringers — this ringer is 1604Ω and requires a module specified to deliver adequate current into that load.

### Additional Circuits Required (Planned)

| Component | Details | Status | Source |
|---|---|---|---|
| LM386 audio amplifier circuit | Drives earpiece (63Ω): 20–200× gain, up to 0.5W, 5V supply | 🔲 Planned | — |
| Carbon microphone bias circuit | 12V DC bias from 12V rail (see power architecture below); custom preamp with adjustable bias | 🔲 Planned | — |
| Crank signal conditioning | 4N35 optocoupler + 1N4148 + 1KΩ + 10KΩ pull-up — all parts on hand; handles 3–6V AC input safely | 🔲 Planned | On hand |
| Relay driver circuit | 2N3904 + 1N4007 + 5V relay — switches ring generator output to ringer coil; all parts on hand | 🔲 Planned | On hand |
| Ring generator module | 12V DC in → 90V AC at 20Hz out; must handle 1604Ω load — verify spec before purchasing | 🔲 Planned — needs purchase | See options below |

#### Ring Generator Candidate Modules

| Module | Input | Output | Notes | Link |
|---|---|---|---|---|
| Sandman DSI9P Ring Voltage Booster | 12V DC | **90V AC** | PCB pin module — same form factor as IRM PSUs; confirm 20Hz before ordering; may need to call to order | [sandman.com](https://www.sandman.com/products/dsi9p-ring-voltage-booster-chassis-ring-generator-module) |
| Black Magic Ringing Generator | 12V DC | 86V AC / 20Hz | eBay listing — close to 90V spec | [eBay](https://www.ebay.com/itm/126389641484) |
| PowerDsine PCR-SIN03V12F20-C | 12V DC | 70V AC / 20Hz | Bare PCB telecom module — lower voltage, may produce weaker bell strike | [eBay](https://www.ebay.com/itm/253414551080) |
| Model Railroad Control Systems | 12V DC | 70V AC / 20Hz | Designed for antique telephone bells in model railroad setups — same use case | [modelrailroadcontrolsystems.com](https://www.modelrailroadcontrolsystems.com/ringing-generator-module-and-ringer/) |

**Preferred:** Sandman DSI9P (90V output, correct form factor). Confirm output frequency is 20Hz before purchasing.

#### Sandman DSI9P — Questions Before Ordering (call their office)

The DSI9P is described as a component for their 25-line chassis (DSI9O). Need to confirm it can run standalone before purchasing.

1. Can the DSI9P be powered and used **standalone** with just 12V DC in — no DSI9O chassis required?
2. What is the **pinout** on the bottom pins? Which pins are +12V in, GND, and the two AC output terminals?
3. Is the output frequency fixed at **20Hz**?

Note: the DSI9Q Line Card is a separate product (one per phone line in the chassis) — do **not** order this.

### LM386 Bill of Materials (Planned)

| Component | Value / Details |
|---|---|
| LM386 Audio Amplifier IC | 8-pin DIP | ⚠️ Check on hand |
| Electrolytic capacitor C1 | 10µF — input coupling | ✅ On hand |
| Electrolytic capacitor C2 | 220µF — output coupling | 🔲 Needs purchase |
| Ceramic capacitor C3 | 0.1µF — power supply decoupling | ✅ On hand |
| Potentiometer | 10kΩ — volume control | ✅ On hand |
| 8-pin IC socket | — | 🔲 Needs purchase |

**LM386 key specs:** default gain 20× (26dB), up to 200× with modification; drives 63Ω earpiece comfortably at 5V supply.

**LM386 pin wiring (planned):**
- Pin 6 → +5V (Pi GPIO)
- Pin 4 → GND
- Pin 3 → Audio input (through C1 from Pi audio out)
- Pin 2 → Volume potentiometer wiper
- Pin 5 → Audio output (through C2 to earpiece)

### Crank Signal Conditioning Circuit (Planned)

Handles 3–6V AC from magneto. Full electrical isolation protects Pi GPIO.

```
Crank AC ──┬── 1KΩ ──── 4N35 pin 1 (LED anode)
           │            4N35 pin 2 (LED cathode)
           │                │
           └── 1N4148 ──────┘  ← reverse-parallel, protects LED on negative half-cycle

4N35 pin 4 (emitter) → GND
4N35 pin 5 (collector) ──── 10KΩ pull-up ──── 3.3V
                       └──────────────────────── Pi GPIO (LOW when crank turns)
```

All parts on hand.

## Power Architecture (Phase 2)

### Mains Supply Components (Needs Purchase)

| Component | Details | Status | Source |
|---|---|---|---|
| Mains inlet cable | 3-prong extension cord (cut) — L/N/E feed into box | 🔲 Planned — use spare extension cord | On hand |
| Inline fuse holder + fuses | BOJACK inline screw type, 5×20mm, 250V, 16 AWG leads — 1A fuse; splices into L wire | 🛒 Ordered | Amazon |
| Mean Well IRM-30-5 (or equivalent) | PCB-mount, 5V/6A, mains AC in — powers Pi 5 via GPIO 5V pins | 🛒 Ordered | Amazon |
| Mean Well IRM-30-12 (or equivalent) | PCB-mount, 12V/2.5A, mains AC in — powers ring generator + carbon mic bias | 🛒 Ordered | Amazon |
| Wire nuts | Join +12V rail wires and common GND wires — one nut per rail | ✅ On hand | — |

**Mains wiring:** L and N daisy-chained between both PSU input terminals using stranded silicone wire (on hand). Earth connected to both PSU E terminals. Fuse on L wire before first PSU.

```
Extension cord (L, N, E)
        │
   [Inline fuse — L wire only]
        │
        ├──→ IRM-30-5  L ──┐  N ──┐  E
        │                  │      │
        └──→ IRM-30-12  L ←┘  N ←┘  E
```

### DC Distribution

| Supply | Voltage | Load |
|---|---|---|
| IRM-30-5 | 5V / 5A | Raspberry Pi 5 (USB-C) |
| IRM-30-12 | 12V / 2.5A | Ring generator module, carbon mic bias circuit |

**Common ground:** Pi GND GPIO pin joins the GND wire nut, tying both supply grounds together. Required for relay driver and signal circuits to share a reference.

**12V supply eliminates the DC-DC boost converter** previously planned — the 12V rail provides the bias voltage for the carbon microphone directly.

### Rail Joining (Wire Nuts)

+12V and GND rails are joined with wire nuts (on hand) — no terminal block needed.

```
[+12V wire nut]          [Common GND wire nut]
  IRM-30-12 (+)            IRM-30-12 (−)
  ring generator (+)       ring generator (−)
  carbon mic bias (+)      carbon mic bias (−)
                           Pi GND GPIO pin
```

## Power Budget (Phase 2 Estimate)

| Component | Draw |
|---|---|
| Raspberry Pi 5 under load | ~3,000–5,000mA @ 5V |
| LM386 amplifier (quiescent / full output) | ~4–24mA @ 5V |
| Ring generator module input | ~500–800mA @ 12V (estimate — verify against chosen module) |
| Carbon mic bias circuit | ~10–50mA @ 12V |
| Relay coil (5V relay) | ~50–100mA @ 5V |
| **Total 5V** | **~3,050–5,100mA** |
| **Total 12V** | **~510–850mA** |

## Antique Component Measurements

| Component | Measurement | Notes |
|---|---|---|
| Earpiece | 63Ω DC resistance | Lower than typical POTS-era receivers (200–600Ω); normal for pre-standardization Kellogg design |
| Carbon microphone | ~270Ω (correct orientation) | Orientation-sensitive — granules mobile; must be mounted correctly |
| Magneto crank | ~5V AC RMS at normal speed | Range 3–6V — variability expected from hand crank |
| Ringer coils | 1604Ω total (2× 800Ω in series) | Center tap terminal unused — connect to outer terminals only |
