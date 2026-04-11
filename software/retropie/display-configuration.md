# RetroPie Display Configuration

## Overview

RetroPie can output to two types of display in this project:
1. **SPI TFT (Velleman VMP400)** — requires `tft35a` overlay + `fbcp` daemon
2. **HDMI LCD (Waveshare 3.5")** — standard HDMI, no extra software needed

All display settings are controlled via `/boot/config.txt`. Config files live in `projects/mini-crt-arcade/config/` and are deployed via `deploy.sh`.

## SPI TFT Mode

The VMP400 uses an ILI9341 controller over SPI. It requires two things to work:

**1. Device tree overlay** — initializes the display controller at boot:

```ini
dtparam=spi=on
dtoverlay=tft35a:rotate=90
```

The `tft35a.dtbo` overlay file must be present in `/boot/overlays/`. It's not included in standard Pi OS — install from `goodtft/LCD-show`:

```bash
git clone https://github.com/goodtft/LCD-show.git
sudo cp ~/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/tft35a.dtbo
```

**2. fbcp daemon** — copies the GPU framebuffer to the display over SPI:

```bash
sudo systemctl enable fbcp
sudo systemctl start fbcp
```

The virtual HDMI framebuffer (required for fbcp to have something to copy):

```ini
framebuffer_depth=16
framebuffer_ignore_alpha=1
hdmi_force_hotplug=1
hdmi_cvt=320 240 60 1 0 0 0
hdmi_group=2
hdmi_mode=87
```

See [velleman-vmp400-tft.md](../../components/displays/velleman-vmp400-tft.md) for full setup details.

## HDMI Mode

The Waveshare display accepts standard HDMI. Configure the output resolution to match the panel:

```ini
hdmi_force_hotplug=1
hdmi_cvt=480 320 60 6 0 0 0
hdmi_group=2
hdmi_mode=87
hdmi_drive=2
```

Disable fbcp when using HDMI mode — it's not needed and wastes CPU:

```bash
sudo systemctl disable fbcp
```

See [waveshare-35-hdmi.md](../../components/displays/waveshare-35-hdmi.md) for full setup details.

## Switching Between Modes

The `display-switch` script (installed by `setup.sh`) swaps configs and enables/disables fbcp:

```bash
display-switch tft && sudo reboot
display-switch hdmi && sudo reboot
```

## RetroArch Resolution and Aspect Ratio

RetroArch should be configured to match the active display. For the Waveshare 3.5" (480x320, 3:2 aspect):

```
# Force 4:3 aspect ratio to preserve NES proportions
video_aspect_ratio_auto = "false"
video_aspect_ratio = "1.333333"
```

This adds small black bars on the left and right, but preserves the correct proportions for NES/SNES content designed for 4:3 CRT televisions.
