**Status:** Active

# Hey Lantern

**Hardware:** Raspberry Pi Zero 2W (primary) / Pi 4 fallback
**Started:** 2026

A 1980s Coleman camp lantern converted into a custom voice assistant. The original propane
fuel tank serves as the electronics enclosure. Say "Hey Lantern" — the Pi wakes, records your
voice, ships audio to cloud STT, sends the transcript to the Claude API, and speaks the
response through small speakers hidden in the propane valve cavity. Activity LEDs in the globe
pulse during listening, processing, and response.

The goal is a functional novelty: a lantern that talks back, with ambient light that reacts
to its state. Not a smart home hub — just a great conversation piece.

## Quick Start (after fresh flash)

```bash
# From repo root on your Mac
bash projects/hey-lantern/scripts/setup.sh
```

## Current Status

- [x] Power architecture decided — dual-supply (5V DC + 120V mains via relay)
- [ ] Hardware acquired and wired on bench (no enclosure yet)
- [ ] Wake word detection running on Pi Zero 2W
- [ ] Cloud STT + Claude API pipeline working end-to-end
- [ ] TTS response playing through speakers
- [ ] Activity LEDs wired and responding to pipeline state
- [ ] Microphone installed in lantern hat
- [ ] Speakers installed in propane valve cavity
- [ ] External WiFi antenna soldered and mounted
- [ ] Full assembly fitted inside lantern base
- [ ] First full demo

## Hardware

See [HARDWARE.md](HARDWARE.md) for full bill of materials and wiring notes.

## Software

See [SOFTWARE.md](SOFTWARE.md) for stack, dependencies, and setup.

## Decisions

See [DECISIONS.md](DECISIONS.md) for minor decisions and open questions.
Architecture-significant decisions get their own ADR in [adr/](adr/).

## Related Projects

- [antique-telephone-ai-operator](../antique-telephone-ai-operator/) — similar Pi 5 + Claude
  API voice pipeline; useful reference for audio and API integration patterns
