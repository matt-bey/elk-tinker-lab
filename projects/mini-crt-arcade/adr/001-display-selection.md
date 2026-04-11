# ADR 001 — Display Selection

**Status:** Decided
**Date:** 2025

## Context

The project started with a Velleman VMP400 3.5" SPI TFT display (ILI9341 controller) connected via GPIO header. It was successfully configured using the `tft35a` device tree overlay and `tasanakorn/rpi-fbcp` framebuffer copy daemon.

## Problem

The SPI TFT approach has fundamental limitations:
- Display lag is inherent — fbcp copies pixels over SPI at ~30-50fps, consuming 15-25% of the Pi Zero W's single core continuously
- Viewing angles are poor (TN panel) — requires near-direct viewing angle
- No audio output — requires a separate audio solution
- The ILI9341 controller is incorrectly labeled as ILI9486 in Velleman's product listing — this caused significant troubleshooting time

## Decision

Replace with **Waveshare 3.5" HDMI LCD (standard 480x320 resistive model)**. Chosen because:

- True HDMI interface — GPU renders directly to the display with zero framebuffer copy overhead
- IPS panel — wide viewing angles, accurate color
- Physical 3.5mm audio jack — feeds directly into PAM8403 amplifier
- Powered via GPIO 26-pin header — no USB port consumed, keeping the Pi Zero W's single OTG port free for the USB controller
- RTD2660H scaler chip — accepts any resolution up to 1080p and scales to panel resolution
- Confirmed RetroPie compatible

## Alternatives Rejected

**OSOYOO 3.5" HDMI LCD:** Purchased first by mistake. Lacked an audio output jack and had a 3:2 aspect ratio causing slight horizontal stretching of NES content. Returned.

**Waveshare 3.5" HDMI LCD (E), 640x480:** Superior resolution and 4:3 aspect ratio (more authentic for NES/CRT aesthetic), but rejected because power is USB-C only — no GPIO power option. Would consume the Pi Zero W's single USB OTG port needed for the controller.

## Tradeoffs Accepted

- The RTD2660H scaler adds a small fixed processing delay (1-3 frames)
- 480x320 resolution is lower than the (E) model's 640x480
- 3:2 aspect ratio introduces slight stretching vs NES's native 4:3 — mitigable with correct RetroArch aspect ratio settings
