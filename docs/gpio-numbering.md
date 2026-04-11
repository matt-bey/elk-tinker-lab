# GPIO Numbering: BCM vs Physical

Raspberry Pi GPIO pins have two numbering schemes that coexist and cause endless confusion. Always clarify which you mean.

## The Two Schemes

### Physical (Board) Numbering

Physical pin numbers refer to the **position on the 40-pin header**, counted left-to-right, top-to-bottom with the header oriented toward you.

- Pin 1 is always 3.3V (top-left when USB ports face away from you)
- Pin 2 is always 5V
- Odd numbers are on the left, even on the right
- Physical numbers don't change across Pi models with 40-pin headers

### BCM Numbering

BCM (Broadcom) numbers refer to the **GPIO channel numbers** in the Broadcom SoC. These are the numbers used in software (`gpio.setup(17, GPIO.OUT)` means BCM 17, not physical pin 17).

BCM 17 = Physical pin 11. BCM 4 = Physical pin 7. There's no simple arithmetic relationship.

## Which to Use

- **Datasheets and product docs** often use BCM
- **Python GPIO libraries** (`RPi.GPIO`, `gpiozero`) default to BCM mode
- **Device tree overlays** in `config.txt` use BCM (e.g., `gpio=17=op`)
- **Physical numbering** is useful when physically tracing wires on a board

**Recommendation:** Use BCM in all code and documentation. When writing wiring instructions, include both: `GPIO 17 (physical pin 11)`.

## Quick Reference: 40-pin Header

```
        3.3V  [ 1][ 2]  5V
  GPIO2 (SDA) [ 3][ 4]  5V
  GPIO3 (SCL) [ 5][ 6]  GND
       GPIO4  [ 7][ 8]  GPIO14 (TXD)
         GND  [ 9][10]  GPIO15 (RXD)
      GPIO17  [11][12]  GPIO18 (PCM_CLK / PWM0)
      GPIO27  [13][14]  GND
      GPIO22  [15][16]  GPIO23
        3.3V  [17][18]  GPIO24
 GPIO10 (MOSI)[19][20]  GND
  GPIO9 (MISO)[21][22]  GPIO25
 GPIO11 (CLK) [23][24]  GPIO8  (CE0)
         GND  [25][26]  GPIO7  (CE1)
  GPIO0 (ID_SD)[27][28] GPIO1  (ID_SC)
       GPIO5  [29][30]  GND
       GPIO6  [31][32]  GPIO12
      GPIO13  [33][34]  GND
      GPIO19  [35][36]  GPIO16
      GPIO26  [37][38]  GPIO20
         GND  [39][40]  GPIO21
```

## Special-Purpose Pins

Some BCM GPIO pins have dedicated hardware functions that can conflict with your use:

| BCM | Function | Notes |
|-----|---------|-------|
| 2, 3 | I2C SDA/SCL | Have pull-up resistors; avoid unless using I2C |
| 7, 8 | SPI CE1, CE0 | SPI chip select lines |
| 9, 10, 11 | SPI MISO, MOSI, CLK | Core SPI pins |
| 14, 15 | UART TXD, RXD | Serial console — may be in use |
| 18 | PWM0 / I2S CLK | Audio — conflicts with I2S DAC use |

## Pi Models

All Pi models from Pi 1B+ onward have the same 40-pin header with the same BCM assignments. The Pi 5 changed some internal details but the 40-pin header pinout is compatible.

The original Pi 1B and Pi Zero (non-W) have different header configurations — not covered here.
