#!/bin/bash
# First-time provisioning for hey-lantern on a fresh Pi flash
# Safe to run multiple times (idempotent)

set -e

PI_HOST="${PI_HOST:-hey-lantern.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/pi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Hey Lantern — First-time Setup ==="
echo "Target: $PI_USER@$PI_HOST"
echo ""

# System packages
echo "Installing system packages..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo apt-get update && sudo apt-get install -y \
  python3-pip python3-venv \
  portaudio19-dev libsndfile1 \
  git"

# Python virtualenv
echo "Setting up Python virtualenv..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
  python3 -m venv /home/pi/hey-lantern-env
  /home/pi/hey-lantern-env/bin/pip install --upgrade pip
  /home/pi/hey-lantern-env/bin/pip install \
    pvporcupine \
    anthropic \
    openai \
    sounddevice soundfile numpy \
    RPi.GPIO
"

# Create secrets directory
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mkdir -p /etc/hey-lantern && sudo chown pi:pi /etc/hey-lantern"

# Deploy config files
echo "Deploying config files..."
bash "$SCRIPT_DIR/deploy.sh"

# Enable and start service
echo "Enabling systemd service..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo systemctl enable hey-lantern.service"

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Copy your API keys into /etc/hey-lantern/secrets.env on the Pi"
echo "  2. Verify I2S mic is detected: arecord -l"
echo "  3. Verify audio output: aplay -l"
echo "  4. Start the service: sudo systemctl start hey-lantern"
