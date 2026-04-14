#!/bin/bash
# Deploy config files to hey-lantern Pi
# Assumes SSH key is configured at ~/.ssh/pi_key

set -e

PI_HOST="${PI_HOST:-hey-lantern.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/pi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "Deploying configs to $PI_USER@$PI_HOST..."

# Systemd service unit
scp -i "$SSH_KEY" "$CONFIG_DIR/hey-lantern.service" "$PI_USER@$PI_HOST:/tmp/hey-lantern.service"
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mv /tmp/hey-lantern.service /etc/systemd/system/hey-lantern.service && sudo systemctl daemon-reload"

# ALSA config for I2S mic + amp
scp -i "$SSH_KEY" "$CONFIG_DIR/audio.conf" "$PI_USER@$PI_HOST:/tmp/audio.conf"
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mv /tmp/audio.conf /etc/asound.conf"

# Secrets template (does not overwrite existing secrets file)
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mkdir -p /etc/hey-lantern"
scp -i "$SSH_KEY" "$CONFIG_DIR/secrets.env.example" "$PI_USER@$PI_HOST:/tmp/secrets.env.example"
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo cp -n /tmp/secrets.env.example /etc/hey-lantern/secrets.env.example"

echo "Deploy complete."
echo "Note: edit /etc/hey-lantern/secrets.env on the Pi with real API keys if not already done."
