# Waveshare 3.5" HDMI LCD (480x320) — Setup Reference

## Overview

**Display specs:**
- 3.5" IPS LCD, 480x320 resolution
- HDMI interface (RTD2660H scaler chip)
- 3.5mm audio output jack (HDMI audio passthrough)
- Resistive touchscreen (not used in this project)
- Powered via 26-pin GPIO header — no USB power required
- Physical size: ~86mm x 56mm

**Tested on:** Raspberry Pi Zero W, RetroPie (Buster)

**Project:** [Mini CRT Arcade Box](../../projects/mini-crt-arcade/)

---

## Why This Display

The RTD2660H scaler accepts HDMI input at any resolution up to 1080p and scales it to the 480x320 panel. This means the Pi's GPU renders normally to a virtual framebuffer — no fbcp daemon required, no SPI overhead, no CPU load from pixel copying.

The 3.5mm audio jack carries HDMI audio from the Pi and outputs it as a line-level analog signal — feeding the PAM8403 amplifier directly.

The 26-pin GPIO header powers the display at 5V from pins 2/4, freeing the Pi Zero W's single USB OTG port for the game controller.

See [ADR 001](../../adr/001-display-selection.md) for the full decision rationale.

---

## Connections

### HDMI
Standard mini-HDMI (Pi Zero W) to full-size HDMI (display). Carries both video and audio.

### GPIO Power
The display draws power from the Pi's 26-pin GPIO header:

| Physical Pin | Signal | Purpose |
|-------------|--------|---------|
| 2 or 4 | 5V | Display power |
| 6 | GND | Ground |

The display's 26-pin connector provides only power pins — it does not use SPI, I2C, or any other data signals. GPIO pins are free for other use.

### Audio Out
3.5mm stereo jack on the display body → 3.5mm to bare wire cable → PAM8403 amplifier input.

---

## `/boot/config.txt` Settings

```ini
# HDMI display (Waveshare 3.5" 480x320)
hdmi_force_hotplug=1
hdmi_cvt=480 320 60 6 0 0 0
hdmi_group=2
hdmi_mode=87
gpu_mem=128

# Audio via HDMI (routed through display's 3.5mm jack)
dtparam=audio=on
hdmi_drive=2

[pi4]
dtoverlay=vc4-fkms-v3d
max_framebuffers=2

[all]
overscan_scale=1
```

**Key settings:**
- `hdmi_force_hotplug=1` — forces HDMI output even if the display's hotplug detection is unreliable
- `hdmi_cvt=480 320 60 6 0 0 0` — defines a custom 480x320 @ 60Hz mode
- `hdmi_group=2` / `hdmi_mode=87` — selects the custom CVT mode above
- `hdmi_drive=2` — enables audio over HDMI (required for 3.5mm audio jack to carry sound)

---

## RetroArch Display Settings

For correct aspect ratio (NES games are 4:3, display is 3:2):

```
video_aspect_ratio_auto = "false"
video_aspect_ratio = "1.333333"
video_scale_integer = "false"
```

This letterboxes NES content with small black bars on the sides rather than stretching it horizontally.

---

## Audio Chain

```
Pi Zero W
  └── HDMI ──► Waveshare display (RTD2660H)
                  └── 3.5mm jack ──► PAM8403 amplifier
                                        ├── Left speaker
                                        └── Right speaker
```

Set ALSA output to HDMI:

```bash
# In /etc/asound.conf — no custom routing needed, HDMI is default when hdmi_drive=2
# Verify with:
aplay -l    # Should show bcm2835 HDMI as card 0
```

---

## Compatibility Notes

| Pi Model | Notes |
|----------|-------|
| Pi Zero W (tested) | Works as documented. Mini-HDMI adapter required. |
| Pi Zero 2W | Should work identically. Same mini-HDMI port. |
| Pi 1B+ / 2B | Full-size HDMI port — no adapter needed. Should work. |
| Pi 4 | Full-size HDMI port. Config path on Bookworm: `/boot/firmware/config.txt`. |

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Black screen | No HDMI signal reaching display | Verify `hdmi_force_hotplug=1` in config.txt and reboot |
| Wrong resolution / stretched image | Custom mode not applied | Confirm `hdmi_cvt` and `hdmi_mode=87` are present |
| No audio from 3.5mm jack | HDMI audio not enabled | Verify `hdmi_drive=2` in config.txt |
| Display not powering on | GPIO power not connected | Check 5V and GND pins on 26-pin header |
| Image too dark/washed out | Backlight or brightness | Adjust in-display OSD (small buttons on PCB edge) |
