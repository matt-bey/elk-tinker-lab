# Software Setup — Mini CRT Arcade Box

## Base Image

Raspbian Buster (Debian 10) with RetroPie pre-installed.
Pi hostname: `retropie`, user: `pi`

## Display Configuration

Two display modes are maintained. Switch with:

```bash
display-switch tft && sudo reboot
display-switch hdmi && sudo reboot
```

Config files are the source of truth in `config/`. Deploy changes with `scripts/deploy.sh`.

### TFT Mode (Velleman VMP400)

Requires:
- `tft35a.dtbo` in `/boot/overlays/` (from goodtft/LCD-show repo)
- `fbcp` systemd service running
- `boot-config-tft.txt` deployed as `/boot/config.txt`

### HDMI Mode (Waveshare 3.5")

Requires:
- `boot-config-hdmi.txt` deployed as `/boot/config.txt`
- fbcp service disabled

## Audio Configuration

ALSA config at `/etc/asound.conf` routes audio to the correct output device.
RetroArch config sets `audio_device` accordingly.

For USB DAC (temporary): card 1, device 0
For HDMI display audio: HDMI output routed through display's 3.5mm jack

Test audio from command line:

```bash
aplay -l                          # List audio devices
aplay -D hw:1,0 /usr/share/sounds/alsa/Front_Center.wav   # Test USB DAC
```

Adjust volume:

```bash
alsamixer    # F6 to select card, arrow keys to adjust
sudo alsactl store    # Persist volume setting
```

## SSH Access

```bash
ssh -i ~/.ssh/pi_key pi@retropie.local
```

## Provisioning (Fresh Flash)

After flashing a fresh RetroPie image, run from your Mac:

```bash
bash projects/mini-crt-arcade/scripts/setup.sh
```

This installs dependencies, copies config files, and enables required services.

## Deploy Config Changes

After modifying any file in `config/`:

```bash
bash projects/mini-crt-arcade/scripts/deploy.sh
```
