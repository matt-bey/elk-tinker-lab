#!/bin/bash
# Deploy config files to hey-lantern Pi.
# Assumes SSH key is configured at ~/.ssh/elkpi_key

set -euo pipefail

PI_HOST="${PI_HOST:-elkpi02.local}"
PI_USER="${PI_USER:-matt}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/elkpi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "Deploying configs to $PI_USER@$PI_HOST..."

ssh_cmd() { ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "$@"; }

# ALSA config (USB webcam mic as default capture device)
scp -i "$SSH_KEY" "$CONFIG_DIR/audio.conf" "$PI_USER@$PI_HOST:/tmp/audio.conf"
ssh_cmd "sudo mv /tmp/audio.conf /etc/asound.conf"

# Systemd service unit
scp -i "$SSH_KEY" "$CONFIG_DIR/hey-lantern.service" "$PI_USER@$PI_HOST:/tmp/hey-lantern.service"
ssh_cmd "sudo mv /tmp/hey-lantern.service /etc/systemd/system/hey-lantern.service && sudo systemctl daemon-reload"

echo "Deploy complete."
