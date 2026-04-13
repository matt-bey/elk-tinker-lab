# ADR 001 — Display Selection

**Status:** Decided
**Date:** 2026

## Context

The project started with a Velleman VMP400 3.5" SPI TFT display (ILI9341 controller) connected via GPIO header. It was successfully configured using the `tft35a` device tree overlay and `tasanakorn/rpi-fbcp` framebuffer copy daemon.

## Problem

The SPI TFT approach has fundamental limitations:
- Display lag is inherent — fbcp copies pixels over SPI at ~30-50fps, consuming 15-25% of the Pi Zero W's single core continuously
- Viewing angles are poor (TN panel) — requires near-direct viewing angle
- No audio output — requires a separate audio solution
- The ILI9341 controller is incorrectly labeled as ILI9486 in Velleman's product listing — this caused significant troubleshooting time

## Decision

Replace with **Waveshare 3.5inch HDMI LCD (E), 640×480**. Chosen because:

- True HDMI interface — GPU renders directly to the display with zero framebuffer copy overhead
- IPS panel — wide viewing angles, accurate color
- Physical 3.5mm audio jack — feeds directly into PAM8403 amplifier
- Native 4:3 aspect ratio — authentic NES/CRT proportions with no letterboxing needed
- 640×480 resolution — higher than the standard model's 480×320
- Capacitive touch (unused for this build but no downside)
- Confirmed RetroPie compatible

**Power:** Originally evaluated as USB-C only (which would have consumed the Pi Zero W's single OTG port). Resolved by powering the display via pogo pins from the Pi's 5V GPIO rail — USB-C port left unused.

## Alternatives Rejected

**OSOYOO 3.5" HDMI LCD:** Purchased first by mistake. Lacked an audio output jack and had a 3:2 aspect ratio causing slight horizontal stretching of NES content. Returned.

**Waveshare 3.5" HDMI LCD (standard 480x320 resistive model):** Lower resolution (480×320), 3:2 aspect ratio requires RetroArch letterboxing, RTD2660H scaler adds 1-3 frame latency.

## Tradeoffs Accepted

- Display draws power from Pi's 5V GPIO rail — slightly increases Pi power demand, within budget
