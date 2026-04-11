# USB Audio DAC (Generic Dongle) — Setup Reference

## Overview

A generic USB audio dongle that presents as a standard USB audio class device. No drivers required on Linux — plug-and-play on Raspberry Pi OS.

**Tested on:** Raspberry Pi Zero W, Raspbian Buster (Debian 10)

**Status in active project:** Temporary solution, superseded by Waveshare HDMI display's 3.5mm jack. See [ADR 003](../../adr/003-audio-approach.md).

---

## Why USB DAC Was Used

The Pi Zero W has no analog audio output. During development, while waiting for the Waveshare HDMI display, the USB DAC provided audio through the Pi's single USB OTG port (via a USB hub).

---

## Configuration

### Find the device number

```bash
aplay -l
```

The USB DAC typically appears as card 1 (card 0 is the onboard bcm2835). Confirm the card number before editing config files.

### ALSA config (`/etc/asound.conf`)

```
pcm.!default {
    type hw
    card 1
}

ctl.!default {
    type hw
    card 1
}
```

Replace `card 1` with the actual card number from `aplay -l` if different.

### RetroArch

In `/opt/retropie/configs/all/retroarch.cfg`:

```
audio_device = "hw:1,0"
```

### Test

```bash
aplay -D hw:1,0 /usr/share/sounds/alsa/Front_Center.wav
```

### Volume adjustment

```bash
alsamixer    # Press F6 to select the USB DAC card
sudo alsactl store    # Persist the volume level across reboots
```

---

## Limitations

- Consumes the Pi Zero W's single USB OTG port (required a USB hub alongside the controller)
- The hub introduces an extra failure point and draws additional power
- Audio quality is fine for retro game audio but this is not a high-fidelity setup

---

## Notes

- The card number can change if the USB hub topology changes — always verify with `aplay -l` after hardware changes
- On Buster, this works without any additional driver installation
- If the dongle disappears from `aplay -l` after reboot, check USB hub power — unpowered hubs on Pi Zero W can be unreliable
