#!/bin/bash
# Deploy config files to the Pi Zero W retropie box
# Assumes SSH key is configured at ~/.ssh/elkpi_key

set -e

PI_HOST="${PI_HOST:-retropie.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/elkpi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "Deploying mini-crt-arcade configs to $PI_USER@$PI_HOST..."

# Determine which display config to deploy (pass as first arg to skip prompt)
DISPLAY_MODE="${1:-}"
if [ -z "$DISPLAY_MODE" ]; then
    read -p "Deploy TFT or HDMI display config? [tft/hdmi]: " DISPLAY_MODE
fi
if [ "$DISPLAY_MODE" = "tft" ]; then
    scp -i "$SSH_KEY" "$CONFIG_DIR/boot-config-tft.txt" "$PI_USER@$PI_HOST:/tmp/config.txt"
    ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo cp /tmp/config.txt /boot/config.txt && sudo rm /tmp/config.txt"
    ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo systemctl enable fbcp"
    echo "TFT display config deployed. fbcp service enabled."
elif [ "$DISPLAY_MODE" = "hdmi" ]; then
    scp -i "$SSH_KEY" "$CONFIG_DIR/boot-config-hdmi.txt" "$PI_USER@$PI_HOST:/tmp/config.txt"
    ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo cp /tmp/config.txt /boot/config.txt && sudo rm /tmp/config.txt"
    ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo systemctl disable fbcp"
    echo "HDMI display config deployed. fbcp service disabled."
else
    echo "Unknown display mode. Skipping display config."
fi

# Deploy RetroArch config
scp -i "$SSH_KEY" "$CONFIG_DIR/retroarch.cfg" \
    "$PI_USER@$PI_HOST:/opt/retropie/configs/all/retroarch.cfg"
echo "RetroArch config deployed."

# Deploy NES system overrides (crt-pi shader)
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "mkdir -p /opt/retropie/configs/nes"
scp -i "$SSH_KEY" "$CONFIG_DIR/retroarch-nes.cfg" \
    "$PI_USER@$PI_HOST:/opt/retropie/configs/nes/retroarch.cfg"
echo "NES RetroArch overrides deployed."

# Deploy ALSA audio config
scp -i "$SSH_KEY" "$CONFIG_DIR/asound.conf" "$PI_USER@$PI_HOST:/tmp/asound.conf"
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mv /tmp/asound.conf /etc/asound.conf"
echo "ALSA config deployed."

# Reboot
read -p "Reboot Pi now? [y/N]: " REBOOT
if [ "$REBOOT" = "y" ] || [ "$REBOOT" = "Y" ]; then
    ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo reboot"
    echo "Pi rebooting..."
else
    echo "Skipping reboot. Changes will take effect on next reboot."
fi

echo "Deploy complete."
