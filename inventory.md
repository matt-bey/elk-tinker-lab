# Workbench Inventory

Last updated: 2026-04-11

This inventory helps Claude Code suggest components already on hand before recommending purchases.
Mark quantities as approximate when unsure. Update when items are acquired or significantly depleted.

---

## Processor Boards

| Board                | Qty | Notes                                                                                                      |
| -------------------- | --- | ---------------------------------------------------------------------------------------------------------- |
| Raspberry Pi Zero W  | 2   | #1: mini-CRT arcade project; #2: Google AIY Voice Kit with voice bonnet (unused — plan to restore for son) |
| Raspberry Pi 1B+     | 1   | Available, 40-pin GPIO header                                                                              |
| Raspberry Pi 2B      | 1   | Low-stakes tinkering, running Bookworm                                                                     |
| Raspberry Pi 4 (4GB) | 1   | Son's dev/experimentation machine — GPIO breakout board attached, RDP from iPad Air (4th gen), Scratch 3   |
| Raspberry Pi 4 (2GB) | 1   | Recalbox OS — NES, SNES, Genesis, N64 game library                                                         |
| Raspberry Pi 5 (8GB) | 1   | Antique phone AI operator project                                                                          |

## Microcontrollers

| Board                                     | Qty | Notes                                    |
| ----------------------------------------- | --- | ---------------------------------------- |
| Inland Nano 3.0 (Arduino Nano compatible) | 0   | Pending purchase — Microcenter, ~$4 each |

## Displays

| Component                         | Qty | Notes                                                   |
| --------------------------------- | --- | ------------------------------------------------------- |
| Velleman VMP400 3.5" SPI TFT      | 1   | ILI9341, GPIO HAT, fully configured with tft35a overlay |
| OSOYOO 3.5" HDMI LCD              | 1   | Purchased by mistake — no audio jack, being returned    |
| Waveshare 3.5" HDMI LCD (480x320) | 1   | In transit — has 3.5mm audio jack, GPIO powered         |

## Audio

| Component                  | Qty | Notes                                                           |
| -------------------------- | --- | --------------------------------------------------------------- |
| PAM8403 amplifier board    | 5   | 5V, 2x3W, volume potentiometer — ordered                        |
| Gikfun 2" 4Ω 3W speakers   | 2   | Full range — ordered                                            |
| USB audio DAC              | 1   | Small USB dongle, confirmed working on Buster                   |
| 3.5mm stereo to bare wire  | 1   | Ordered                                                         |
| Portable Bluetooth speaker | 1   | Unbranded, battery-powered, 3.5mm jack — used for audio testing |

## Breakout Boards & Modules

| Component                                   | Qty | Notes                                                                                       |
| ------------------------------------------- | --- | ------------------------------------------------------------------------------------------- |
| Inland/Keyes 37-in-1 Sensor Kit (MC 900852) | 1   | Full module list below                                                                      |
| ADS1115 ADC breakout board                  | 3   | 16-bit, 4-channel, I2C (0x48–0x4B) — for analog sensors from 37-in-1 kit — pending purchase |

### Keyes 37-in-1 Sensor Kit Modules

| #   | Module                              | Pi Notes                                                               |
| --- | ----------------------------------- | ---------------------------------------------------------------------- |
| 1   | 18B20 Temperature Sensor            | 1-Wire protocol                                                        |
| 2   | 3W LED Module                       |                                                                        |
| 3   | 5MM RGB LED Module                  |                                                                        |
| 4   | 5V Relay                            | 5V logic signal — use level shifter or optocoupler from Pi's 3.3V GPIO |
| 5   | ADXL345 Three-Axis Accelerometer    | SPI or I2C — good fit for Pi I2C bus                                   |
| 6   | Active Buzzer Module                |                                                                        |
| 7   | Analog Alcohol Sensor               | Analog output — needs ADC (e.g. MCP3008)                               |
| 8   | Button Sensor                       |                                                                        |
| 9   | Capacitive Touch Sensor             |                                                                        |
| 10  | Crash Sensor                        |                                                                        |
| 11  | DHT11 Temperature & Humidity Sensor | Pi-friendly — good Python library support                              |
| 12  | Digital IR Receiver Module          |                                                                        |
| 13  | Digital IR Transmitter Module       |                                                                        |
| 14  | Digital Tilt Sensor                 |                                                                        |
| 15  | Double-Color LED Module             |                                                                        |
| 16  | Hall Magnetic Sensor                |                                                                        |
| 17  | Joystick Module                     | Analog — needs ADC for Pi                                              |
| 18  | Knock Sensor Module                 |                                                                        |
| 19  | LM35 Temperature Sensor             | Analog output — needs ADC                                              |
| 20  | Laser Head Sensor Module            |                                                                        |
| 21  | Line Tracking Module                |                                                                        |
| 22  | MQ-2 Gas Sensor                     | Pi-friendly — good Python library support                              |
| 23  | Magical Light Cup Sensor            |                                                                        |
| 24  | Microphone Sound Sensor             | Analog — needs ADC for Pi                                              |
| 25  | Obstacle Avoidance Sensor           |                                                                        |
| 26  | PIR Motion Sensor                   | Pi-friendly — straightforward GPIO                                     |
| 27  | Passive Buzzer Module               |                                                                        |
| 28  | Photo Interrupter Module            |                                                                        |
| 29  | Photoresistor Sensor                | Analog — needs ADC                                                     |
| 30  | Potentiometer Module                | Analog — needs ADC                                                     |
| 31  | Pulse Rate Monitor                  | Analog — needs ADC                                                     |
| 32  | RGB LED Module                      |                                                                        |
| 33  | Reed Switch                         |                                                                        |
| 34  | Rotary Encoder Module               | Pi-friendly — straightforward GPIO                                     |
| 35  | TEMT6000 Light Sensor               | Analog — needs ADC                                                     |
| 36  | Thermistor Sensor                   | Analog — needs ADC                                                     |
| 37  | Ultrasonic Sensor                   | Pi-friendly — good Python library support                              |

## Passive Components

| Component               | Qty  | Notes          |
| ----------------------- | ---- | -------------- |
| Resistors (assorted)    | ~200 | Various values |
| LEDs (assorted)         | ~30  | Various colors |
| Momentary push buttons  | ~10  | Various sizes  |
| Breadboards (full size) | 2    |                |
| Dupont wires M-M        | ~40  |                |
| Dupont wires M-F        | ~40  |                |

## Wire & Connectors

| Component                     | Qty      | Notes                                                       |
| ----------------------------- | -------- | ----------------------------------------------------------- |
| 22 AWG stranded silicone wire | 6 spools | White, black, red, blue, yellow, green — ~25 ft each        |
| HDMI cables                   | Several  | Various lengths; micro-HDMI and mini-HDMI adapters included |
| USB OTG adapters              | ~5       | For Pi Zero boards                                          |
| Portable USB hub              | 1        | 3-port                                                      |

## Tools

| Tool                     | Notes                                                                                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| WEP 948DQ-III            | Fume extractor + soldering station (2-in-1) — replaced old wood-burning multi-tool                                           |
| Maiyum 63/37 solder wire | Tin-lead rosin core, 0.6mm, 50g                                                                                              |
| Lead-free solder         | Rosin core                                                                                                                   |
| TOWOT desoldering kit    | Solder wick + no-clean flux paste                                                                                            |
| MacBook                  | Primary admin machine — SSH, nmap, Raspberry Pi Imager                                                                       |
| Mini-ITX Desktop         | NVIDIA RTX 3060 12GB, 600W PSU, Ubuntu 24.04 LTS — primary LLM inference machine (Ollama: qwen2.5-coder:14b-instruct-q4_K_M) |
| iPad Air (4th gen)       | Son's machine — RDPs to Pi 4 (4GB) for Scratch 3 development                                                                 |
| iPad charger 5V/2.1A     | Confirmed sufficient for Pi Zero W arcade build                                                                              |
