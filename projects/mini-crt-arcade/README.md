# Mini CRT Arcade Box

**Status:** Active
**Hardware:** Raspberry Pi Zero W
**Started:** 2025

A desk-sitting retro arcade box styled to look like a miniature CRT television. Runs RetroPie on a Pi Zero W. Display and audio connect via HDMI. USB controller plugs into the side for gameplay.

## Quick Start (after fresh RetroPie flash)

```bash
# From repo root on your Mac
bash projects/mini-crt-arcade/scripts/setup.sh
```

Then reboot the Pi. See SOFTWARE.md for full details.

## Current Status

- ✅ Pi Zero W running RetroPie with NES ROMs
- ✅ Waveshare 3.5inch HDMI LCD (E) — 640×480, HDMI audio, powered via pogo pins
- ✅ PAM8403 amplifier + 2x speakers wired and working
- ✅ Full audio chain: Pi → HDMI → display 3.5mm → PAM8403 → speakers
- ✅ v1 cardboard enclosure — prototype self-contained and working
- ✅ Velleman VMP400 TFT retained as backup display
- ✅ SD card backup taken

## Hardware

See [HARDWARE.md](HARDWARE.md) for full bill of materials.

## References

- [Velleman VMP400 setup](../../components/displays/velleman-vmp400-tft.md)
- [Waveshare HDMI display setup](../../components/displays/waveshare-35-hdmi.md)
- [PAM8403 wiring](../../components/audio/pam8403-amplifier.md)
- [ADR 001 — Display selection](adr/001-display-selection.md)
- [ADR 002 — Abandoned GPIO controls](adr/002-abandoned-gpio-controls.md)
- [ADR 003 — Audio approach](adr/003-audio-approach.md)
