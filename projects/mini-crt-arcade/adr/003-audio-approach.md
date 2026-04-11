# ADR 003 — Audio Approach

**Status:** Decided (partially implemented)
**Date:** 2025

## Context

The Pi Zero W has no analog audio output. Multiple approaches were evaluated.

## Options Evaluated

| Option | Verdict |
|--------|---------|
| PWM audio via GPIO 18/13 | Very low quality, requires RC filter circuit, electrically noisy |
| I2S DAC (MAX98357A) | Good quality, but GPIO 18 (I2S CLK) physically blocked by VMP400 HAT |
| USB audio DAC | Works, confirmed on Buster, but consumes Pi Zero W's single USB port |
| HDMI display 3.5mm jack | Clean line-level, no USB port consumed, feeds PAM8403 directly |

## Decision

Use the 3.5mm audio jack on the Waveshare HDMI display as the audio source. The display receives audio via HDMI from the Pi and outputs it via the physical 3.5mm jack to the PAM8403 amplifier.

**Audio chain:**

```
Pi Zero W → HDMI → Waveshare display → 3.5mm jack → PAM8403 → 2x speakers
```

**PAM8403 power:** 5V from Pi GPIO pins 2/4 and GND from pin 6.

**Volume control:** PAM8403 potentiometer mounted accessibly on the enclosure front panel — also serves as an aesthetic CRT-style knob.

## USB DAC Fallback

A USB audio DAC was used temporarily during development while waiting for the HDMI display. Configuration for Buster in `/etc/asound.conf`:

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

And in RetroArch: `audio_device = "hw:1,0"`

## Status

PAM8403 and speakers ordered. HDMI display in transit. Audio chain not yet fully assembled.
