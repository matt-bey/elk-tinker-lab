# Decisions Log — Hey Lantern

Minor project-specific decisions. For significant architectural decisions, create an ADR in `adr/`.

---

## [2026-04-14] Power architecture — dual-supply (5V DC + 120V mains via TRIAC dimmer)

**Decision:** Dual-supply design. 5V DC for Pi/amp/mic/LEDs; 120V mains dimmed via TRIAC
module for the Edison bulbs. Dimming (not just on/off) is a hard requirement for atmospheric
state lighting.

**Reason:** Authentic Edison filament glow is part of the aesthetic and dimming makes the
assistant states dramatically more immersive. 5V Edison-style bulbs don't exist in a real
base form factor; 12V equivalents exist but add supply complexity (see 5V/12V alternative
below). The existing converted lantern already runs mains. Builder is comfortable with mains
wiring and will follow safe practices.

**Dimming implementation:** RobotDyn AC Light Dimmer Module — TRIAC + zero-crossing detector
with built-in optocoupler isolation. Pi GPIO connects directly to module PWM input. Replaces
the relay + 4N35 approach considered earlier.

**Bulb choice:** Incandescent Edison bulbs dim perfectly across the full range and are the
safest choice for TRIAC compatibility. Dimmable LED filament bulbs also work but vary by
brand — test before final install.

**Safety requirements:**
- All mains wiring: 18 AWG minimum, 300V-rated. The 22 AWG silicone on hand is not mains-rated.
- Mains wiring physically separated from 5V wiring inside the base.
- Insulated terminal blocks (Wago 221 or equivalent) — no bare wire nuts.
- No exposed mains connections. Heat-shrink all terminations.
- Metal enclosure earth-grounded via mains cable ground pin.
- If in doubt at any step, stop and consult before proceeding.

**Alternatives considered:**
- 5V-only: rejected — no authentic filament bulbs at 5V in standard base form
- 5V/12V dual-supply: documented below as a deferred fallback option

---

## [2026-04-14] Deferred alternative — 5V/12V dual-supply (no mains)

**Decision:** Not chosen, but documented as a viable fallback if mains wiring is ever
reconsidered.

**How it would work:**
- Single 12V DC wall adapter as the only mains-connected component (outside the enclosure,
  like a laptop brick)
- 12V → 5V buck converter inside the base for Pi/amp/mic/LEDs
- 12V dimmable LED filament bulbs (common in RV/marine applications, authentic glow, E12/E26
  base available)
- Dimming via logic-level N-channel MOSFET (e.g., IRLZ44N) — Pi GPIO drives the gate
  directly at 3.3V, no optocoupler needed. Simple software PWM.

**Why it's attractive:** No mains voltage inside the enclosure at all. The MOSFET dimming
circuit is simpler and safer than a TRIAC. 12V LED filament bulbs are widely available and
look excellent.

**Why it was deferred:** Requires a separate 12V supply + buck converter, and 12V filament
bulbs are slightly less common than standard 120V versions. Revisit if the mains wiring
approach ever feels like too much complexity inside the enclosure.

---

## [2026-04-16] Software toolchain — uv + flat src/ layout

**Decision:** Python dependencies managed with `uv`. Source files live flat under
`software/src/` — no package nesting. `uv run python src/main.py` is the entry point.

**Reason:** This is an application, not a library. The `src/` subdirectory keeps source
files visually separate from build artifacts without the overhead of a proper package
structure. Avoids the `hey-lantern/hey_lantern` naming collision that a `src/hey_lantern/`
layout would create.

---

## [2026-04-16] POC audio input — USB webcam mic via USB-OTG

**Decision:** Use a USB webcam mic via USB-OTG cable as the microphone for POC testing on
the Pi Zero 2W.

**Reason:** Allows full pipeline testing before the I2S MEMS microphone is purchased and
wired. Pi Zero 2W has no onboard audio; USB audio is class-compliant and requires no driver.
ALSA is configured to use card 0 (the USB device) as the default capture device.

**TTS output for POC:** `TTS_ENABLED=false` in `.env` if no speaker is available — the
pipeline still validates end-to-end with responses printed to console.

**This is POC-only.** Final build uses an I2S MEMS mic (see HARDWARE.md).

---

## [OPEN] Audio output path — USB DAC vs I2S DAC breakout

**Decision:** Not yet made.

**Context:** The PAM8403 amp takes analog input. The Pi Zero 2W has no native analog audio
output, so an intermediate DAC is required. Design constraint: no USB hub — only one USB
device may be used across the entire build.

**Option A — USB audio DAC (already on hand)**
USB OTG → DAC dongle → 3.5mm → PAM8403. Clean bus separation: USB handles audio out,
I2S handles audio in (MEMS mic). No GPIO conflicts. Consumes the Pi Zero 2W's only USB
data port, but nothing else in this build requires USB (WiFi is built-in, mic is I2S,
no keyboard needed — SSH only). Cost: $0.

**Option B — I2S DAC breakout (~$5, e.g., PCM5102A)**
I2S GPIO → DAC breakout → analog → PAM8403. Leaves USB port free. Requires full-duplex
I2S operation (simultaneous input from MEMS mic + output to DAC on the same BCM2835 I2S
interface) — possible but requires careful ALSA configuration. Slightly more complex bring-up.

**Recommendation:** Option A for faster bring-up. Option B if the USB port ends up being
needed for something else, or if full-duplex I2S config proves straightforward on Bookworm.

---

## [2026-04-16] Wake word engine — openWakeWord

**Decision:** openWakeWord. Fully open source (Apache 2.0), runs offline, no account or
API key required.

**POC stand-in:** Pre-trained `hey_jarvis` model. Sufficient to validate the full pipeline
end-to-end without waiting on custom model training.

**Custom wake word plan:** Train a "Hey Lantern" model using openWakeWord's training pipeline
(synthetic TTS data generation + fine-tune). Switch to Picovoice Porcupine only if the custom
model proves unreliable — Porcupine's web console generates a custom `.ppn` in ~5 minutes but
requires a free account and periodic internet check-in.

**Alternatives considered:** Picovoice Porcupine — faster custom keyword bring-up but
proprietary; rejected in favour of keeping the build fully open and offline.

---

## [2026-04-14] Primary compute board — Pi Zero 2W

**Decision:** Pi Zero 2W. On hand, no active project assigned.

**Reason:** The architecture offloads all heavy processing (STT, LLM, TTS) to cloud APIs.
The Pi only runs wake word detection, audio capture/playback, and LED/relay GPIO control.
Wake word engines like Porcupine are designed for microcontrollers and use <5% of a single
core. The Pi Zero 2W (quad-core 1GHz) is significantly more capable than the Pi Zero 1W
that ran a comparable Google AIY Voice Kit pipeline. Pi 4 remains as a fallback if
performance problems emerge in practice.
