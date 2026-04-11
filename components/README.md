# Components

Single-component hardware documentation — wiring, pinouts, setup steps, and known quirks for individual breakout boards and peripherals.

Each document covers one piece of hardware in isolation. Project docs reference these rather than repeating wiring details.

## Subdirectories

- [displays/](displays/) — LCD and HDMI screens
- [audio/](audio/) — amplifiers, DACs, speakers
- [sensors/](sensors/) — temperature, distance, motion, etc.
- [cameras/](cameras/) — Pi Camera and USB webcams
- [networking/](networking/) — WiFi, Ethernet, and LoRa modules

## Adding a component doc

Name the file descriptively: `manufacturer-model-shortname.md`. Include:
- Brief overview and specs
- Pin/wiring table
- Step-by-step setup
- Known issues or gotchas
- Which Pi OS versions/models it has been tested on
