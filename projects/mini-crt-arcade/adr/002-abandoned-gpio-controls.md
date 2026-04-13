# ADR 002 — Abandoned: Built-in GPIO Arcade Controls

**Status:** Abandoned
**Date:** 2026

## Context

The original vision included built-in arcade-style controls mounted on the enclosure — a joystick and buttons wired to GPIO pins via the `mk_arcade_joystick_rpi` kernel module. The intended layout mirrored an NES controller: Up, Down, Left, Right, Start, Select, A, B mapped to GPIO 4, 17, 27, 22, 10, 9, 25, 24 respectively.

## What Was Explored

**mk_arcade_joystick_rpi kernel module:** Maps GPIO pins to a virtual gamepad. Works well in principle and is well documented for RetroPie. The software side was straightforward.

**Full arcade joystick (Adafruit product 480, Sanwa-style):** 75mm mounting plate — too large for a miniature enclosure.

**Analog thumb joystick (Adafruit P512 / Keyes clone):** Analog output requires MCP3008 ADC chip via SPI. Adds hardware and software complexity with no gameplay benefit — NES games use binary directional input, not analog.

**Mini digital joystick:** Searched extensively. Genuine miniature digital microswitch joysticks are not available as hobbyist components. Mass-produced mini arcade toys use proprietary injection-molded parts not sold separately.

**D-pad module:** No commercially available standalone d-pad module exists in the hobbyist market.

**Harvesting NES controller PCB:** NES controllers use a serial shift register protocol, not simple switches. Reading the PCB output requires implementing the NES serial protocol in software. Using the physical buttons by harvesting the PCB would require a USB hub, consuming the Pi Zero W's single USB port.

## Why Digital Joystick Is Correct for NES

Classic arcade joysticks and NES controllers are purely digital — four microswitches, one per direction, open or closed. Analog input offers zero advantage for NES games which were designed for binary directional input.

## Decision

Abandon built-in controls for v1. Use a USB NES-style controller plugged into the side of the enclosure.

Reasons:
- Miniature digital joystick components do not exist as purchasable hobbyist parts
- USB controller works immediately with zero configuration
- Keeps the build moving — controls were becoming a blocker
- The gameplay experience with a USB controller is equivalent or better
- Built-in controls remain a potential v2 feature

## Status

Permanently abandoned for v1. If revisited for v2, the most promising paths are: a PSP replacement d-pad PCB wired to GPIO (small, digital, authentic feel), or a custom 3D-printed mount for whatever small joystick can be sourced.
