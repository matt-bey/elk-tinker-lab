# Hardware — Mini CRT Arcade Box

## Bill of Materials

| Component | Details | Status | Source |
|-----------|---------|--------|--------|
| Raspberry Pi Zero W | Main board | ✅ On hand | — |
| Waveshare 3.5inch HDMI LCD (E) | 640×480 capacitive touch IPS, 3.5mm audio; powered via pogo pins from Pi 5V (USB-C also supported) | ✅ On hand | Amazon |
| PAM8403 amplifier board | 5V, 2x3W, volume pot (5-pack) | ⏳ Ordered | Amazon |
| Gikfun 2" 4Ω 3W speakers | Full range (x2) | ⏳ Ordered | Amazon |
| 3.5mm stereo to bare wire connector | Audio in to PAM8403 | ⏳ Ordered | Amazon |
| 22 AWG stranded silicone wire | General wiring | ⏳ Ordered | Amazon |
| Mini-HDMI to HDMI cable | Pi Zero W to display | ⏳ Ordered | Amazon |
| USB NES-style controller | Player input | ✅ On hand | — |
| 5V/2.1A iPad charger | Power supply (v1 only — replaced in v2) | ✅ On hand | — |
| TP4056 + 5V/2A boost combo board | USB-C charge input, Output +/− pads, K point for power button. DWEII or equivalent. | 🛒 To purchase | Amazon |
| Samsung 30Q 18650 cell | 3000mAh, 15A continuous. Avoid Amazon — counterfeits prevalent. | 🛒 To purchase | 18650batterystore.com |
| 18650 battery holder (single cell) | Wire leads to BAT+/BAT− on combo board | 🛒 To purchase | SparkFun PRT-12899 |
| Momentary push button | Wires to K point — toggles boost output on/off | 🛒 To purchase | Amazon |
| Power distribution block, 2-pole 6-position Dupont | Teansic 2×6 or equivalent. One row 5V, one row GND. Distributes to Pi GPIO, PAM8403, cap. | 🛒 To purchase | Amazon |
| Electrolytic capacitor assortment kit | 100µF on hand for first attempt; kit provides 1000µF if reboots persist | 🛒 To purchase | Amazon |
| Velleman VMP400 TFT | Backup/reference display | ✅ On hand | — |
| USB audio DAC | Temporary audio (pre-HDMI display) | ✅ On hand | — |
| Small USB hub | Used with USB DAC temporarily | ✅ On hand | — |

## Power Budget

| Component | Draw |
|-----------|------|
| Pi Zero W under load | ~400mA |
| HDMI display backlight | ~200mA |
| PAM8403 at moderate volume | ~200-300mA |
| USB controller | ~100mA |
| **Total** | **~900-1000mA** |

Supply: 5V/2.1A = 10.5W. Comfortable headroom at typical use.
