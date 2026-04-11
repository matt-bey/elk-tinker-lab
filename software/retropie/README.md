# RetroPie

RetroPie turns a Raspberry Pi into a retro gaming console. It bundles EmulationStation (frontend) with RetroArch (emulator framework) and a large collection of emulator cores.

## Docs in This Section

- [display-configuration.md](display-configuration.md) — configuring display output for SPI TFT and HDMI displays
- [audio-configuration.md](audio-configuration.md) — routing audio to USB DAC, HDMI, or PWM

## Version Used

RetroPie on Raspbian Buster (Debian 10). Most of these notes apply to other versions but paths and some behaviors may differ.

## Key Paths on the Pi

| Path | Purpose |
|------|---------|
| `/boot/config.txt` | Boot-time hardware configuration |
| `/opt/retropie/configs/all/retroarch.cfg` | Global RetroArch settings |
| `/opt/retropie/configs/<system>/retroarch.cfg` | Per-system RetroArch overrides |
| `/home/pi/RetroPie/roms/` | ROM files, organized by system |
| `/etc/asound.conf` | ALSA audio routing |

## SSH Access

```bash
ssh -i ~/.ssh/pi_key pi@retropie.local
```

RetroPie enables SSH by default.
