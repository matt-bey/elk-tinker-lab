# Hardware — Hey Lantern

## Enclosure

1980s Coleman camp lantern. The former propane fuel tank (lower metal base) is the primary
electronics bay. The propane valve cavity on the side houses the speakers. The hat provides
mounting points for the microphone.

Approximate internal base dimensions (estimated from photo against tennis ball): ~5–6" diameter,
~4–5" tall. Measure before final component layout.

## Bill of Materials

| Component | Details | Status | Source |
|-----------|---------|--------|--------|
| Raspberry Pi Zero 2W | Primary compute — quad-core, 512MB RAM | On hand (no active project) | — |
| Raspberry Pi 4 (4GB) | Fallback if Zero 2W underperforms | On hand | — |
| I2S MEMS microphone | e.g., Adafruit INMP441 or SPH0645 breakout — I2S GPIO, no ADC needed | Need to purchase | Adafruit / Amazon |
| PAM8403 amplifier board | 5V, 2×3W, stereo — drives speakers | On hand (×5) | — |
| Gikfun 2" 4Ω 3W speakers | Full range, fits in valve cavity | On hand (×2) | — |
| *Option A* USB audio DAC | Small dongle; audio out via USB OTG → 3.5mm → PAM8403 | On hand (×1) | — |
| *Option B* I2S DAC breakout | e.g., PCM5102A; audio out via I2S GPIO → analog → PAM8403; requires full-duplex I2S config with MEMS mic | Need to purchase (~$5) | Amazon |
| RGB LEDs | Activity lights in globe — listen/think/speak states | On hand (Keyes kit #3, discrete RGB LEDs) | — |
| External WiFi antenna | U.FL pigtail + SMA stub — soldered to Pi Zero 2W pads | Need to purchase | Amazon |
| USB-C or micro-USB power supply | 5V/2.5A+ for Pi Zero 2W; 5V/3A for Pi 4 | Verify on hand | — |
| Edison bulbs (×2) | E17 or E12 — match original socket; incandescent or dimmable LED filament, 2200K | Need to purchase | Hardware store / Amazon |
| RobotDyn AC Light Dimmer Module | TRIAC + zero-crossing detection; PWM input from Pi GPIO; built-in optocoupler isolation | Need to purchase (~$5) | Amazon |
| 22 AWG silicone wire | Signal + power runs inside enclosure | On hand (6 colors) | — |
| M2.5 standoffs + screws | Pi mounting inside base | On hand | — |

## Component Placement

```
[Hat]
  └── I2S MEMS microphone — concealed, facing outward for voice pickup

[Glass globe / hood]
  └── RGB LEDs (×2) — activity indicators visible through glass
      States: slow pulse = idle, ramp up on wake, pulse while processing, solid while speaking

[Propane valve cavity]
  └── PAM8403 amplifier + 2× Gikfun speakers
      Existing openings in the cavity act as natural speaker grilles

[Base / fuel tank]
  └── Raspberry Pi Zero 2W — mounted on standoffs
  └── Power entry (USB or barrel jack — replaces original fill valve hole)
  └── WiFi antenna pigtail — U.FL on Pi Zero 2W pads, SMA stub through drilled hole in back
```

## WiFi Antenna

The Pi Zero 2W has unpopulated U.FL antenna pads on the PCB. Solder a U.FL connector,
run a short pigtail to an SMA bulkhead connector, and drill a small hole in the back of the
base to mount it flush — same style as a router antenna. Keeps the metal base from blocking
signal.

**Soldering risk:** The U.FL pads are small (~2mm). Use a fine-tipped iron at ~300°C, liquid
flux, and minimal solder. A magnifying glass or loupe is strongly recommended. Consider
purchasing a spare Pi Zero 2W before attempting — it's cheap insurance.

If switching to Pi 4: use a USB WiFi adapter (e.g., Edimax EW-7811Un) with an external
antenna pigtail instead.

## GPIO Pin Usage (Pi Zero 2W — preliminary)

| GPIO | Function | Notes |
|------|----------|-------|
| GPIO 18 | I2S CLK (BCLK) | MEMS microphone |
| GPIO 19 | I2S FS (LRCLK) | MEMS microphone |
| GPIO 20 | I2S DIN (data in) | MEMS microphone |
| GPIO 21 | I2S DOUT (to amp) | Audio out to PAM8403 — or use PWM/3.5mm depending on amp config |
| GPIO 17 | LED activity — listen | Red channel or dedicated LED |
| GPIO 27 | LED activity — processing | Green channel or dedicated LED |
| GPIO 22 | LED activity — speaking | Blue channel or dedicated LED |
| GPIO 26 | TRIAC dimmer PWM | RobotDyn module PWM input — controls bulb brightness |

*Pin assignments are preliminary — finalize after confirming I2S mic breakout pinout.*

## Power Design (dual-supply)

Two separate supplies share a common ground:

**5V DC rail** — powers Pi, amp, mic, LEDs. Single 5V/2.5A USB-C supply.

| Component | Draw |
|-----------|------|
| Pi Zero 2W under load | ~350mA |
| PAM8403 at moderate volume | ~200mA |
| I2S MEMS mic | ~1mA |
| RGB LEDs (×2 at 20mA each) | ~40mA |
| RobotDyn dimmer module (logic) | ~10mA |
| **Total 5V** | **~600mA** |

A 5V/2A supply is sufficient; 5V/2.5A gives headroom.

**120V AC mains** — powers Edison bulbs only, dimmed by TRIAC module.

The RobotDyn AC Light Dimmer Module sits between mains and the bulb sockets. It contains
a TRIAC, zero-crossing detector, and built-in optocoupler — the Pi GPIO connects directly
to its PWM input with no additional isolation components needed. Dimming is controlled via
software PWM on GPIO 26.

Bulb brightness maps to assistant state:
- Idle: ~20% (dim ambient glow)
- Wake word detected: ramp to 100% over ~0.5s
- Processing: slow pulse at ~80%
- Speaking: 100%
- Return to idle: fade to 20% over ~2s

**Bulb compatibility note:** True incandescent bulbs dim perfectly across the full range.
Dimmable LED filament bulbs work but may have a ~20% minimum threshold and vary by brand —
test before final install. Non-dimmable LED bulbs will not work with a TRIAC dimmer.

All mains wiring must use 18 AWG 300V-rated wire (not the 22 AWG silicone on hand), insulated
terminal blocks (Wago 221 or equivalent), and be physically separated from the 5V wiring.
The metal enclosure must be earth-grounded via the mains cable ground pin.
