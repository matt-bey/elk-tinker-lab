# Headless Pi Setup

Setting up a Raspberry Pi with SSH and WiFi access, no monitor or keyboard required.

## What You Need

- SD card (8GB minimum, 16GB+ recommended)
- Raspberry Pi Imager (free, from raspberrypi.com)
- Mac or PC
- Your WiFi credentials

## Step 1: Flash the Image

1. Open Raspberry Pi Imager
2. Choose your Pi model and OS (Raspberry Pi OS Lite for headless; RetroPie image for gaming builds)
3. Choose your SD card
4. Click the **gear icon** (Advanced Options) before writing — this is the key step

In Advanced Options:
- ✅ Set hostname: `retropie` (or whatever you want)
- ✅ Enable SSH
- ✅ Set username and password (or use key-based auth)
- ✅ Configure WiFi: enter SSID and password, set country code
- ✅ Set locale/timezone

5. Write the image

Modern Raspberry Pi OS (Bookworm) and the Raspberry Pi Imager handle all of this in the GUI. Older methods (creating `ssh` file and `wpa_supplicant.conf` manually on the boot partition) still work on older images.

## Step 2: First Boot

1. Insert SD card, connect power, wait ~60 seconds for first boot
2. Find the Pi on your network:

```bash
# Try mDNS hostname first
ping retropie.local

# Or scan your network
nmap -sn 192.168.1.0/24 | grep -A2 Raspberry
```

See [scripts/scan-network.sh](../scripts/scan-network.sh) for a handy wrapper.

## Step 3: SSH In

```bash
ssh pi@retropie.local
```

Default password is whatever you set in Imager. If you didn't set one, it's `raspberry` on older images (change this immediately).

## Step 4: Set Up SSH Key Authentication

On your Mac, generate a key if you don't have one:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/pi_key -C "pi key"
```

Copy to the Pi:

```bash
ssh-copy-id -i ~/.ssh/pi_key.pub pi@retropie.local
```

Test it:

```bash
ssh -i ~/.ssh/pi_key pi@retropie.local
```

Add to `~/.ssh/config` on your Mac for convenience:

```
Host retropie
    HostName retropie.local
    User pi
    IdentityFile ~/.ssh/pi_key
```

Then just: `ssh retropie`

## Step 5: Basic Hardening (Optional)

```bash
# Change hostname if you didn't use Imager
sudo raspi-config  # System Options → Hostname

# Disable password auth (after confirming key auth works)
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart ssh

# Update packages
sudo apt-get update && sudo apt-get upgrade -y
```

## Reconnecting After IP Change

If the Pi gets a new IP and mDNS isn't working:

```bash
# Scan for Pi devices on your subnet
bash scripts/scan-network.sh
```

Or check your router's DHCP client list.

## Notes for Buster (older RetroPie images)

Older Buster-based images don't support the Imager Advanced Options. Instead, after writing the image, manually add to the `/boot` partition (before first boot):

```bash
# Enable SSH
touch /Volumes/boot/ssh

# Configure WiFi
cat > /Volumes/boot/wpa_supplicant.conf <<EOF
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="YourSSID"
    psk="YourPassword"
}
EOF
```

Eject and insert into Pi.
