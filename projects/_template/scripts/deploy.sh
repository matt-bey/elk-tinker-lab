#!/bin/bash
# Deploy config files to the target Pi
# Assumes SSH key is configured at ~/.ssh/pi_key
# TODO: Update PI_HOST and config file paths for your project

set -e

PI_HOST="${PI_HOST:-raspberrypi.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/pi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "Deploying configs to $PI_USER@$PI_HOST..."

# TODO: Add scp and ssh commands for your project's config files
# Example:
#   scp -i "$SSH_KEY" "$CONFIG_DIR/myconfig.txt" "$PI_USER@$PI_HOST:/tmp/myconfig.txt"
#   ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo mv /tmp/myconfig.txt /etc/myconfig.txt"

echo "Deploy complete. Reboot if needed."
