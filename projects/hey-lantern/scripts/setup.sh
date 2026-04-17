#!/bin/bash
# First-time provisioning for hey-lantern on a fresh Pi flash.
# Safe to run multiple times (idempotent).
# Run deploy-software.sh after this to sync source and install Python deps.

set -euo pipefail

PI_HOST="${PI_HOST:-elkpi02.local}"
PI_USER="${PI_USER:-matt}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/elkpi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Hey Lantern — First-time Setup ==="
echo "Target: $PI_USER@$PI_HOST"
echo ""

ssh_cmd() { ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "$@"; }

# System packages
echo "Installing system packages..."
ssh_cmd "sudo apt-get update && sudo apt-get install -y \
  portaudio19-dev \
  libsndfile1 \
  alsa-utils \
  git"

# Deploy ALSA config and systemd service
echo "Deploying config files..."
bash "$SCRIPT_DIR/deploy.sh"

# Enable service (does not start it — run manually for POC testing)
echo "Enabling systemd service..."
ssh_cmd "sudo systemctl enable hey-lantern.service"

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next: run deploy-software.sh to sync code and install Python deps."
echo ""
echo "To verify the USB mic is detected on the Pi:"
echo "  arecord -l"
echo ""
echo "To run manually (POC):"
echo "  cd ~/hey-lantern && uv run python src/main.py"
