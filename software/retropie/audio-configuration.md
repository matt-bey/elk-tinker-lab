# RetroPie Audio Configuration

## Audio Options for Pi Zero W

The Pi Zero W has no built-in analog audio output. Options in order of preference for this project:

1. **HDMI display 3.5mm jack** (preferred — see ADR 003)
2. **USB audio DAC** (fallback — uses USB OTG port)
3. **PWM audio via GPIO 18/13** (low quality — avoid)
4. **I2S DAC** (blocked by VMP400 HAT if TFT display is in use)

## Option 1: HDMI Display Audio (Preferred)

When using the Waveshare HDMI display, audio travels over HDMI to the display's internal RTD2660H chip, which outputs it through the physical 3.5mm jack.

Enable HDMI audio in `/boot/config.txt`:

```ini
dtparam=audio=on
hdmi_drive=2
```

`hdmi_drive=2` forces HDMI audio output even when no TV reports audio support. Required for this display.

No ALSA config needed — HDMI audio is the default when `hdmi_drive=2` is set.

Verify ALSA sees the HDMI output:

```bash
aplay -l
# Should show: bcm2835 HDMI as card 0
```

## Option 2: USB Audio DAC (Fallback)

Used during development with TFT display (before HDMI display arrived). Requires a USB hub since the USB DAC and controller both need USB OTG.

```bash
aplay -l    # Confirm USB DAC appears as card 1
```

ALSA config (`/etc/asound.conf`):

```
pcm.!default {
    type hw
    card 1
}
ctl.!default {
    type hw
    card 1
}
```

RetroArch config:

```
audio_device = "hw:1,0"
```

## Volume Control

### Hardware volume
The PAM8403 amplifier has a physical potentiometer — this is the primary volume control.

### Software volume
```bash
alsamixer       # Interactive volume control
# F6 to select audio card
# Arrow keys to adjust level
sudo alsactl store    # Persist setting across reboots
```

### Command-line adjustment
```bash
amixer set Master 80%
```

## Audio Testing

```bash
# List audio devices
aplay -l

# Test HDMI audio (card 0)
aplay -D hw:0,0 /usr/share/sounds/alsa/Front_Center.wav

# Test USB DAC (card 1)
aplay -D hw:1,0 /usr/share/sounds/alsa/Front_Center.wav

# Test with speaker-test
speaker-test -c 2 -t wav
```

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| No audio from HDMI display jack | `hdmi_drive=2` missing | Add to `/boot/config.txt`, reboot |
| RetroArch audio crackling | Buffer too small | Increase `audio_latency` in retroarch.cfg (try 128) |
| ALSA can't find device | Card number changed | Run `aplay -l`, update `/etc/asound.conf` card number |
| Volume doesn't persist | alsactl not run | Run `sudo alsactl store` after setting volume |
