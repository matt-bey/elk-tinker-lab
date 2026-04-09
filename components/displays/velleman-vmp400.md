# Velleman VMP400 3.5" SPI Touchscreen — Setup Reference

## Overview

This document covers how to get the Velleman VMP400 3.5" SPI touchscreen working as a display on a Raspberry Pi. It is intended as a reference for future projects.

**Display specs:**
- 3.5" TFT LCD, 320x480 resolution
- SPI interface
- Controller: ILI9341 (despite some documentation incorrectly listing ILI9486)
- Resistive touchscreen (XPT2046 touch controller)
- Connects directly to the 40-pin GPIO header as a HAT

**Tested on:** Raspberry Pi Zero W, Raspbian Buster (Debian 10), kernel 5.10.103+

---

## Key Discovery: Controller is ILI9341, Not ILI9486

The Velleman product page lists the display as ILI9486, but the official VMP400 user manual (v03, January 2020) clearly states ILI9341 in the title. Attempting to use ILI9486-based drivers or fbcp-ili9341 built with `-DILI9486=ON` will result in a black screen. Always use ILI9341-targeted configuration.

---

## How It Works

The VMP400 uses SPI to communicate with the ILI9341 controller. On Linux, the display is not natively recognized as an output device — it requires two components working together:

1. **A device tree overlay (`tft35a`)** — loaded at boot via `/boot/config.txt`. This initializes the ILI9341 controller and sets up the kernel-level SPI driver. Without this, the screen stays white (uninitialized).

2. **`fbcp` (framebuffer copy daemon)** — a userspace process that continuously copies pixels from the GPU framebuffer (`/dev/fb0`) to the display over SPI. Without this running, the screen stays black (initialized but receiving no pixels).

The GPU renders to a virtual HDMI framebuffer. `fbcp` bridges that framebuffer to the physical SPI display.

---

## Pin Layout

The VMP400 uses the following GPIO pins (physical pin numbers):

| Physical Pin | GPIO (BCM) | Function |
|-------------|-----------|----------|
| 18 | GPIO 24 | LCD_RS (Data/Command) |
| 19 | GPIO 10 | SPI0 MOSI |
| 21 | GPIO 9 | SPI0 MISO |
| 22 | GPIO 25 | RST (Reset) |
| 23 | GPIO 11 | SPI0 CLK |
| 24 | GPIO 8 | LCD_CS (Chip Select, CE0) |
| 26 | GPIO 7 | TP_CS (Touch chip select, CE1) |
| 11 | GPIO 17 | TP_IRQ (Touch interrupt) |
| 1, 17 | — | 3.3V power |
| 2, 4 | — | 5V power |
| 6, 9, 14, 20, 25 | — | GND |

Pins not listed above are NC (not connected) and are free for other use.

**Note on I2S audio conflict:** GPIO 18 (physical pin 12) is used by I2S audio. This pin is NOT used by the VMP400, so I2S audio is theoretically compatible — however physical access to pin 12 may be obstructed since the VMP400 HAT covers the full 40-pin header.

---

## Driver Approach

The recommended driver approach uses the **`tft35a` device tree overlay** from the `goodtft/LCD-show` repository, combined with the simpler **`tasanakorn/rpi-fbcp`** framebuffer copy tool.

> **Do not use `juj/fbcp-ili9341`** for this display. While that project supports ILI9341, the VMP400 requires the `tft35a` kernel overlay to initialize the controller first. `juj/fbcp-ili9341` attempts to handle initialization itself and produces a black screen on this hardware.

---

## `/boot/config.txt` Settings

```ini
# SPI and display driver
dtparam=spi=on
dtoverlay=tft35a:rotate=90

# Virtual HDMI framebuffer (required — fbcp copies this to the display)
framebuffer_depth=16
framebuffer_ignore_alpha=1
hdmi_force_hotplug=1
hdmi_cvt=320 240 60 1 0 0 0
hdmi_group=2
hdmi_mode=87
gpu_mem=128

# Audio
dtparam=audio=on

# Pi 4 specific (ignored on other models)
[pi4]
dtoverlay=vc4-fkms-v3d
max_framebuffers=2

[all]
overscan_scale=1
```

**Key settings explained:**

- `dtparam=spi=on` — enables the SPI bus. Without this the display cannot communicate at all.
- `dtoverlay=tft35a:rotate=90` — loads the ILI9341 kernel driver and initializes the controller. The `rotate=90` value may need adjustment depending on enclosure orientation (0, 90, 180, 270 are valid).
- `framebuffer_depth=16` — sets the framebuffer to 16-bit color. fbcp expects this format.
- `framebuffer_ignore_alpha=1` — disables the alpha channel, required for correct color rendering.
- `hdmi_force_hotplug=1` — forces the GPU to initialize even with no HDMI display connected.
- `hdmi_cvt=320 240 60 1 0 0 0` — defines a custom 320x240 virtual display mode.
- `hdmi_group=2` / `hdmi_mode=87` — selects the custom CVT mode defined above.
- `gpu_mem=128` — allocates 128MB to the GPU. The default (64MB) can cause issues with some applications.

---

## Installing the `tft35a` Overlay

The `tft35a.dtbo` overlay file is not included in standard Raspberry Pi OS. It must be copied from the `goodtft/LCD-show` repository:

```bash
cd ~
git clone https://github.com/goodtft/LCD-show.git
sudo cp ~/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/
sudo cp ~/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/tft35a.dtbo
```

Both copy commands are needed — the firmware looks for `.dtbo` extension while some systems look for `.dtb`.

---

## Installing fbcp

Use `tasanakorn/rpi-fbcp`, not the older or alternative versions:

```bash
sudo apt-get update
sudo apt-get install cmake
cd ~
git clone https://github.com/tasanakorn/rpi-fbcp
mkdir rpi-fbcp/build
cd rpi-fbcp/build
cmake ..
make
sudo install fbcp /usr/local/bin/fbcp
```

Test manually (after rebooting with the new `config.txt`):

```bash
sudo fbcp &
```

The display should show framebuffer content. If it stays white, the `tft35a` overlay didn't load — check that both overlay files were copied correctly and SPI is enabled. If it stays black, fbcp isn't running or the framebuffer isn't initialized.

---

## Autostart via systemd

Create `/etc/systemd/system/fbcp.service`:

```ini
[Unit]
Description=Framebuffer copy to TFT display
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/fbcp
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable fbcp
sudo systemctl start fbcp
```

---

## Switching Between TFT and HDMI Output

To use the same Pi with both the VMP400 and a standard HDMI display, maintain two config files and a swap script.

**HDMI config** (`/boot/config-hdmi.txt`) — remove these lines from the TFT config:
```ini
# Remove or comment out:
# framebuffer_depth=16
# framebuffer_ignore_alpha=1
# hdmi_cvt=320 240 60 1 0 0 0
# hdmi_group=2
# hdmi_mode=87
# dtparam=spi=on
# dtoverlay=tft35a:rotate=90
```

**Swap script** (`/usr/local/bin/display-switch`):

```bash
#!/bin/bash
if [ "$1" = "tft" ]; then
    sudo cp /boot/config-tft.txt /boot/config.txt
    sudo systemctl enable fbcp
    echo "Switched to TFT. Reboot to apply."
elif [ "$1" = "hdmi" ]; then
    sudo cp /boot/config-hdmi.txt /boot/config.txt
    sudo systemctl disable fbcp
    echo "Switched to HDMI. Reboot to apply."
else
    echo "Usage: display-switch [tft|hdmi]"
fi
```

```bash
sudo chmod +x /usr/local/bin/display-switch
```

Usage:
```bash
display-switch hdmi && sudo reboot
display-switch tft && sudo reboot
```

---

## Compatibility Notes

### Raspberry Pi OS versions

| OS Version | Config Path | Notes |
|------------|-------------|-------|
| Buster (tested) | `/boot/config.txt` | Works as documented above |
| Bullseye | `/boot/config.txt` | Should work. May need to comment out `dtoverlay=vc4-kms-v3d` if present |
| Bookworm | `/boot/firmware/config.txt` | Config file moved. KMS display stack changes may affect fbcp behavior — test carefully |

On **Bookworm**, the move to the KMS/DRM display stack means `fbcp` may not work correctly out of the box. The framebuffer device (`/dev/fb0`) may behave differently. Research KMS-compatible alternatives to fbcp if issues arise.

### Raspberry Pi models

| Model | Notes |
|-------|-------|
| Pi Zero W (tested) | Works. Single core — fbcp consumes ~15-25% CPU continuously |
| Pi Zero 2W | Should work identically to Pi Zero W. Quad-core gives more headroom for fbcp overhead |
| Pi 1B+ | 40-pin GPIO header — VMP400 HAT fits directly. Should work but untested. Single core like Pi Zero W |
| Pi 4 | 40-pin GPIO header — HAT fits. Config file is at `/boot/config.txt` on Bullseye, `/boot/firmware/config.txt` on Bookworm. Comment out `dtoverlay=vc4-fkms-v3d` or `dtoverlay=vc4-kms-v3d` as these conflict with the legacy framebuffer fbcp relies on |
| Pi 5 | 40-pin GPIO header — HAT fits physically. Pi 5 uses a significantly different display and memory architecture. fbcp compatibility is uncertain — research before attempting |

### Performance

On a Pi Zero W (single core, 1GHz), fbcp running at the 320x240 virtual resolution produces approximately 30-50fps on the display. This is acceptable for video and emulation but may produce visible tearing on fast-moving content. There is no hardware vsync on SPI displays — tearing is a known limitation of the fbcp approach.

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Screen stays white | Controller not initialized | Verify `tft35a.dtbo` is in `/boot/overlays/` and `dtoverlay=tft35a` is in `config.txt`. Reboot. |
| Screen goes black when fbcp starts | fbcp running but framebuffer empty | Confirm `hdmi_force_hotplug=1` and the `hdmi_cvt` block are in `config.txt` and a reboot has occurred |
| Corrupted/striped colors | SPI signal integrity | Not applicable with `tft35a` overlay approach — this was a symptom of the incorrect `fbcp-ili9341` approach |
| Display works but image is upside down | Wrong rotation | Change `rotate=90` to `rotate=270` in the `dtoverlay=tft35a` line and reboot |
| Touch not working | Touch driver not configured | Touch requires additional `xorg` configuration and calibration — not covered here as it was not used in this setup |
| fbcp not starting on boot | systemd service not enabled | Run `sudo systemctl enable fbcp && sudo systemctl start fbcp` |