# Headless Raspberry Pi OS Setup

Setting up Raspberry Pi OS without a monitor or keyboard. See also [docs/headless-pi-setup.md](../../docs/headless-pi-setup.md) for the general guide — this doc covers OS-specific details.

## Raspberry Pi Imager (Recommended)

Use Raspberry Pi Imager for all new setups. The **Advanced Options** (gear icon) lets you pre-configure:
- Hostname
- SSH (enable + key or password)
- WiFi credentials + country code
- Locale and timezone

This is the clean modern path. The manual `ssh` file + `wpa_supplicant.conf` method still works for older Buster images.

## Buster-Specific (Older Images)

After flashing to SD card, mount the `/boot` partition and create:

```bash
# Enable SSH
touch /Volumes/boot/ssh

# WiFi config
cat > /Volumes/boot/wpa_supplicant.conf << 'EOF'
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="YourNetwork"
    psk="YourPassword"
    key_mgmt=WPA-PSK
}
EOF
```

## Finding the Pi on Your Network

```bash
ping retropie.local          # mDNS — works if Bonjour is running
ssh pi@retropie.local        # Direct SSH attempt
bash scripts/scan-network.sh # nmap scan of local subnet
```

## Config File Location by OS Version

| OS | Config path |
|----|------------|
| Buster / Bullseye | `/boot/config.txt` |
| Bookworm | `/boot/firmware/config.txt` |

Always verify before editing — the wrong path will silently do nothing.
