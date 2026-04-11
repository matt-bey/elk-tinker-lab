#!/bin/bash
# First-time provisioning for [project-name] on a fresh Pi flash
# Safe to run multiple times (idempotent)
# TODO: Update PI_HOST and provisioning steps for your project

set -e

PI_HOST="${PI_HOST:-raspberrypi.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/pi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== [Project Name] — First-time Setup ==="
echo "Target: $PI_USER@$PI_HOST"
echo ""

# TODO: Install packages
# echo "Installing packages..."
# ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo apt-get update && sudo apt-get install -y [packages]"

# TODO: Configure services, copy files, etc.

# Deploy configs
echo "Deploying config files..."
bash "$SCRIPT_DIR/deploy.sh"

echo ""
echo "=== Setup complete ==="
