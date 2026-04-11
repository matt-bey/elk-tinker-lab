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
| Raspberry Pi 5 (8GB) | 1   | [Antique telephone AI operator project](projects/antique-telephone-ai-operator/)                           |

## Microcontrollers

| Board                                     | Qty | Notes                                    |
| ----------------------------------------- | --- | ---------------------------------------- |
| Inland Nano 3.0 (Arduino Nano compatible) | 0   | Pending purchase — Microcenter, ~$4 each |

## Displays

| Component                         | Qty | Notes                                                                      |
| --------------------------------- | --- | -------------------------------------------------------------------------- |
| Velleman VMP400 3.5" SPI TFT      | 1   | ILI9341, GPIO HAT, fully configured with tft35a overlay                    |
| OSOYOO 3.5" HDMI LCD              | 1   | Purchased by mistake — no audio jack, being returned                       |
| Waveshare 3.5" HDMI LCD (480x320) | 1   | In transit — has 3.5mm audio jack, GPIO powered                            |
| 7-Segment Display (1-digit)       | 1   | Miuzei kit                                                                 |
| 7-Segment Display (4-digit)       | 1   | Miuzei kit — commonly paired with 74HC595 shift register for GPIO efficiency |

## Audio

| Component                  | Qty | Notes                                                           |
| -------------------------- | --- | --------------------------------------------------------------- |
| PAM8403 amplifier board    | 5   | 5V, 2x3W, volume potentiometer — ordered                                                   |
| Adafruit PAM8302 amp       | 1   | 2.5W mono Class D; JST-PH input, screw terminal output, SD/mute pin; 3.3–5.5V — Pi-friendly |
| Gikfun 2" 4Ω 3W speakers   | 2   | Full range — ordered                                                                        |
| CQRobot speaker 3W/8Ω     | 1   | 2.54mm Dupont connector — use with PAM8302 or similar amp, not direct GPIO                  |
| USB audio DAC              | 1   | Small USB dongle, confirmed working on Buster                                               |
| 3.5mm stereo to bare wire  | 1   | Ordered                                                                                     |
| Portable Bluetooth speaker | 1   | Unbranded, battery-powered, 3.5mm jack — used for audio testing                             |

## Breakout Boards & Modules

| Component                                   | Qty | Notes                                                                                       |
| ------------------------------------------- | --- | ------------------------------------------------------------------------------------------- |
| Inland/Keyes 37-in-1 Sensor Kit (MC 900852) | 1   | Full module list below                                                                       |
| ADS1115 ADC breakout board                  | 3   | 16-bit, 4-channel, I2C (0x48–0x4B) — for analog sensors from 37-in-1 kit — pending purchase |
| Miuzei breadboard power supply module       | 1   | 5V + 3.3V rail output; USB-A or barrel connector input (Miuzei starter kit)                  |

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

### Resistors (Miuzei kit — 10 each)

| Value  | Value  | Value  | Value  | Value  |
| ------ | ------ | ------ | ------ | ------ |
| 10Ω    | 100Ω   | 220Ω   | 330Ω   | 1KΩ    |
| 2KΩ    | 5.1KΩ  | 10KΩ   | 100KΩ  | 1MΩ    |

### Capacitors (Miuzei kit)

| Component                  | Qty |
| -------------------------- | --- |
| Electrolytic 10µF 50V      | 10  |
| Electrolytic 100µF 50V     | 10  |
| Ceramic 104 (100nF)        | 10  |
| Ceramic 22pF               | 10  |

### Semiconductors & Discrete ICs

| Component                     | Qty | Notes                                                           |
| ----------------------------- | --- | --------------------------------------------------------------- |
| LED assorted (W/Y/B/G/R)      | ~80 | ~50 from Miuzei kit + ~30 misc                                  |
| RGB LED                       | 2   | Miuzei kit                                                      |
| Diode 1N4007                  | 5   | Miuzei kit                                                      |
| Diode 4148                    | 5   | Miuzei kit                                                      |
| NPN Transistor 2N3904/PN2222  | 10  | Miuzei kit (5+5)                                                |
| Photoresistor 5528 (LDR)      | 2   | Miuzei kit — analog, needs ADC on Pi                            |
| Thermistor 103                | 2   | Miuzei kit — analog, needs ADC on Pi                            |
| Tilt Switch SW-520D           | 1   | Miuzei kit                                                      |
| Active buzzer                 | 1   | Miuzei kit (discrete component)                                 |
| Passive buzzer                | 1   | Miuzei kit (discrete component)                                 |
| 4N35 Optocoupler              | 1   | Miuzei kit — isolates Pi GPIO from higher-voltage circuits      |
| 74HC595 Shift Register        | 1   | Miuzei kit — serial-in/parallel-out; pair with 7-seg displays   |

### Buttons & Controls

| Component              | Qty | Notes                         |
| ---------------------- | --- | ----------------------------- |
| Momentary push buttons | ~20 | ~10 misc + 10 from Miuzei kit |
| Potentiometer 10KΩ     | 2   | Miuzei kit                    |

### Breadboards & Headers

| Component                         | Qty | Notes                                                            |
| --------------------------------- | --- | ---------------------------------------------------------------- |
| Breadboard, full size (830-point) | 3   | 2 existing + 1 from Miuzei kit                                   |
| Pin header, 40-pin male (2×20)    | 7   | 2 from Miuzei kit + 5× Schmartboard 920-0197-01 (2.54mm, RoHS)  |

## Wire & Connectors

| Component                     | Qty      | Notes                                                       |
| ----------------------------- | -------- | ----------------------------------------------------------- |
| 22 AWG stranded silicone wire       | 6 spools | White, black, red, blue, yellow, green — ~25 ft each        |
| HDMI cables                         | Several  | Various lengths; micro-HDMI and mini-HDMI adapters included |
| USB OTG adapters                    | ~5       | For Pi Zero boards                                          |
| Portable USB hub                    | 1        | 3-port                                                      |
| Alligator clip leads                | 6        | Wire with alligator clips on both ends                      |
| Jumper wires, assorted              | 65       | Miuzei kit                                                  |
| Jumper wires, solderless (set)      | 140      | Miuzei kit                                                  |
| Female-to-male Dupont wires (20cm)  | 20       | Miuzei kit                                                  |

## Hardware & Fasteners

| Component                   | Qty | Notes                                                                           |
| --------------------------- | --- | ------------------------------------------------------------------------------- |
| M2.5 Nut                    | 25  | Micro Connectors SCW-114PC kit — standard Pi mounting size                      |
| M2.5×6 Standoff (F-F)       | 8   | Brass                                                                           |
| M2.5×10 Standoff (F-F)      | 8   | Brass                                                                           |
| M2.5×15 Standoff (F-F)      | 8   | Brass                                                                           |
| M2.5×20 Standoff (F-F)      | 8   | Brass                                                                           |
| M2.5×6+6 Standoff (M-F)     | 8   | Brass                                                                           |
| M2.5×10+6 Standoff (M-F)    | 8   | Brass                                                                           |
| M2.5×15+6 Standoff (M-F)    | 8   | Brass                                                                           |
| M2.5×20+6 Standoff (M-F)    | 8   | Brass                                                                           |
| M2.5×6 Screw                | 25  |                                                                                 |

## Computers & Admin Machines

| Machine            | Notes                                                                                                                        |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| MacBook            | Primary admin machine — SSH, nmap, Raspberry Pi Imager                                                                       |
| Mini-ITX Desktop   | NVIDIA RTX 3060 12GB, 600W PSU, Ubuntu 24.04 LTS — primary LLM inference machine (Ollama: qwen2.5-coder:14b-instruct-q4_K_M) |
| iPad Air (4th gen) | Son's machine — RDPs to Pi 4 (4GB) for Scratch 3 development                                                                 |

## Tools

| Tool                     | Notes                                           |
| ------------------------ | ----------------------------------------------- |
| WEP 948DQ-III                    | Fume extractor + soldering station (2-in-1)                          |
| Maiyum 63/37 solder wire         | Tin-lead rosin core, 0.6mm, 50g                                      |
| Lead-free solder                 | Rosin core                                                           |
| TOWOT desoldering kit            | Solder wick + no-clean flux paste                                    |
| Multimeter                       | 2 (mine + son's) — nothing fancy, both functional                                           |
| Creality Ender 3 V3 KE           | FDM, 220×220×240mm, direct drive, auto-level, Klipper, WiFi — needs dialing in; plan to upgrade to a higher-tier model |
| iPad charger 5V/2.1A             | Confirmed sufficient for Pi Zero W arcade build                      |
