# Pi Power Budgeting

How to calculate whether your power supply can handle your build.

## Rule of Thumb

**For a Pi Zero W build:** A quality 5V/2A supply (10W) covers almost everything a Pi Zero W can do. The Pi itself maxes out around 500mA under heavy load; the rest goes to peripherals.

**For a Pi 4 build:** Use a 5V/3A supply minimum. The Pi 4 alone can draw up to 1.25A under full CPU/GPU load.

## Component Current Draw Reference

These are typical operating values — peaks can be higher during startup or heavy load.

| Component | Typical Draw | Notes |
|-----------|-------------|-------|
| Pi Zero W (idle) | 80-120mA | WiFi off |
| Pi Zero W (loaded) | 350-500mA | WiFi active, CPU busy |
| Pi Zero 2W (loaded) | 400-600mA | Quad-core, more headroom |
| Pi 1B+ (loaded) | 300-500mA | |
| Pi 2B (loaded) | 400-600mA | |
| Pi 4 (loaded) | 750-1250mA | Depends on peripherals |
| SPI TFT (VMP400) | ~20-50mA | Display only, no backlight current via GPIO |
| HDMI LCD (Waveshare 3.5") | 150-250mA | Backlight included, powered from GPIO |
| PAM8403 amp (moderate vol) | 200-400mA | Into 4Ω speakers at ~50% volume |
| USB keyboard/mouse | 100-200mA | |
| USB NES controller | 50-100mA | |
| USB audio DAC | 30-50mA | |
| USB hub (unpowered) | 100mA base | Plus whatever devices are attached |

## Calculating Your Build

1. Sum the typical draw of all components
2. Add ~20% margin for startup spikes and variance
3. Ensure your supply's rated current meets or exceeds the total

**Example:** 1000mA total × 1.2 = 1200mA minimum supply. A 2A supply has comfortable headroom.

## Voltage Drop

Long or thin wires between the supply and the Pi can cause voltage drop under load, triggering the Pi's under-voltage warning (lightning bolt icon on desktop). Use short, thick cables and quality USB cables — not the thin charging-only type.

## USB Power Supply Quality

Not all 5V/2A supplies are equal. Cheap phone chargers may not deliver their rated current cleanly. Signs of a poor supply:
- Pi reboots or throttles under load
- Lightning bolt appears in top-right corner of desktop
- WiFi drops intermittently

An iPad charger (Apple or genuine replacement) is generally reliable and delivers clean 5V/2.1A.

## Powered vs Unpowered USB Hubs

An unpowered USB hub draws all its port power from the host (the Pi). On a Pi Zero W, this means all USB devices on the hub must fit within the Pi's available USB current budget (~500mA after the Pi itself). A powered hub has its own supply and removes this constraint.
