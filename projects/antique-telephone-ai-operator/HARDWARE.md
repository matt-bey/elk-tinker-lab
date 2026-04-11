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
| Antique wood wall telephone (Kellogg Chicago) | Complete unit — earpiece, carbon microphone, crank, hook switch, ringer | ✅ On hand — condition/viability unverified; requires testing |
| Earpiece | Impedance likely 200–600Ω; requires 1–10mW, 1–3V RMS | Needs impedance measurement |
| Carbon microphone | Requires 6–12V DC bias voltage | Needs viability testing |
| Crank mechanism | Rotary — detection via rotary encoder or Hall-effect magnetic sensor | Needs wiring inspection |
| Hook switch | On/off-hook detection | Needs wiring inspection |
| Mechanical ringer | Original bell — may be driven via relay/solenoid | Needs viability testing |

### Additional Circuits Required (Planned)

| Component | Details | Status | Source |
|---|---|---|---|
| LM386 audio amplifier circuit | Drives earpiece: 20–200× gain, up to 0.5W into 8Ω, 5V supply | 🔲 Planned | — |
| Carbon microphone bias circuit | 6–12V DC bias; custom preamp with adjustable bias | 🔲 Planned | — |
| Voltage detection circuit | Crank and hook switch signal conditioning | 🔲 Planned | — |
| Relay / transistor switching | Ringer control output | 🔲 Planned | — |
| DC-DC converter | Generate 6–12V bias rail from Pi 5V supply | 🔲 Planned | — |

### LM386 Bill of Materials (Planned)

| Component | Value / Details |
|---|---|
| LM386 Audio Amplifier IC | 8-pin DIP |
| Electrolytic capacitor C1 | 10µF — input coupling |
| Electrolytic capacitor C2 | 220µF — output coupling |
| Ceramic capacitor C3 | 0.1µF — power supply decoupling |
| Potentiometer | 10kΩ — volume control |
| 8-pin IC socket | — |

**LM386 key specs:** default gain 20× (26dB), up to 200× with modification; up to 0.5W into 8Ω; 5V supply from Pi GPIO.

**LM386 pin wiring (planned):**
- Pin 6 → +5V (Pi GPIO)
- Pin 4 → GND
- Pin 3 → Audio input (through C1 from Pi audio out)
- Pin 2 → Volume potentiometer wiper
- Pin 5 → Audio output (through C2 to earpiece)

## Power Budget (Phase 2 Estimate)

| Component | Draw |
|---|---|
| Raspberry Pi 5 under load | ~3,000–5,000mA |
| LM386 amplifier (quiescent / full output) | ~4–24mA |
| Carbon mic bias circuit | ~10–50mA (estimate) |
| Relay / ringer circuit | ~50–100mA (estimate) |
| **Total** | **~3,100–5,200mA** |

Supply: Pi 5 official 27W (5V/5A) USB-C PSU recommended. Bias voltage for carbon mic requires a small DC-DC boost converter off the 5V rail.

## Antique Component Notes

The original telephone components are on hand but their condition and electrical viability are unknown. Before building interface circuits, the following should be measured:

- Earpiece DC resistance (expected 200–600Ω)
- Carbon microphone resistance and bias response
- Crank output (AC/DC voltage, frequency at normal crank speed)
- Hook switch continuity and contact condition
- Ringer coil resistance and operating voltage
