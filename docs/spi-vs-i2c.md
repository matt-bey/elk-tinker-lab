# SPI vs I2C

Two common protocols for connecting breakout boards to a Raspberry Pi. Each has different tradeoffs.

## Quick Summary

| | SPI | I2C |
|--|-----|-----|
| Wires | 4 (MOSI, MISO, CLK, CS) | 2 (SDA, SCL) |
| Speed | Fast (up to 125MHz on Pi) | Slow (100kHz standard, 400kHz fast) |
| Full duplex | Yes | No |
| Multiple devices | One CS pin per device | Up to 127 devices on same 2 wires |
| Pi pins used | 3 shared + 1 per device | 2 shared, always the same 2 |
| Complexity | Higher (4 pins, CS management) | Lower (2 pins, addresses) |

## When to Use SPI

- Displays (TFT LCDs, e-ink) — high bandwidth needed to push pixels
- ADCs (MCP3008) — fast sampling
- High-speed sensors (IMUs at high data rates)
- Anything where throughput matters more than pin count

## When to Use I2C

- Sensors that report infrequently (temperature, humidity, altitude)
- RTCs (real-time clocks)
- Small OLEDs (128x64 is manageable over I2C)
- When you have many devices and few free GPIO pins

## Enabling on Raspberry Pi

### SPI

In `raspi-config` → Interface Options → SPI, or add to `/boot/config.txt`:
```ini
dtparam=spi=on
```

Devices appear as `/dev/spidev0.0` and `/dev/spidev0.1`.

### I2C

In `raspi-config` → Interface Options → I2C, or add to `/boot/config.txt`:
```ini
dtparam=i2c_arm=on
```

Device appears as `/dev/i2c-1`. Scan for connected devices:

```bash
sudo apt-get install i2c-tools
i2cdetect -y 1
```

## Pi GPIO Pins

| Protocol | BCM | Physical | Function |
|----------|-----|---------|---------|
| SPI | 10 | 19 | MOSI |
| SPI | 9 | 21 | MISO |
| SPI | 11 | 23 | CLK |
| SPI | 8 | 24 | CE0 (CS for device 0) |
| SPI | 7 | 26 | CE1 (CS for device 1) |
| I2C | 2 | 3 | SDA |
| I2C | 3 | 5 | SCL |

## Conflicts to Watch For

- **I2C pull-ups:** GPIO 2 and 3 have built-in 1.8kΩ pull-up resistors. Don't drive these pins low unless you specifically want to use I2C.
- **HAT-style displays:** A display that mounts as a HAT covers the full 40-pin header, blocking physical access to all pins while attached. Check the component doc for which SPI CE lines it consumes.
