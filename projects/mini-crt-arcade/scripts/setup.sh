#!/bin/bash
# First-time provisioning for mini-crt-arcade on a fresh RetroPie (Buster) flash
# Safe to run multiple times (idempotent)

set -e

PI_HOST="${PI_HOST:-retropie.local}"
PI_USER="${PI_USER:-pi}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/elkpi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "=== Mini CRT Arcade Box — First-time Setup ==="
echo "Target: $PI_USER@$PI_HOST"
echo ""

# Install required packages
echo "Installing packages..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "sudo apt-get update && sudo apt-get install -y cmake"

# Install tft35a overlay (for VMP400 TFT support)
echo "Installing tft35a overlay..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
    if [ ! -f /boot/overlays/tft35a.dtbo ]; then
        cd ~ && git clone https://github.com/goodtft/LCD-show.git
        sudo cp ~/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/
        sudo cp ~/LCD-show/usr/tft35a-overlay.dtb /boot/overlays/tft35a.dtbo
        echo 'tft35a overlay installed.'
    else
        echo 'tft35a overlay already present, skipping.'
    fi
"

# Install rpi-fbcp
echo "Installing rpi-fbcp..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
    if ! command -v fbcp &> /dev/null; then
        cd ~ && git clone https://github.com/tasanakorn/rpi-fbcp
        mkdir -p rpi-fbcp/build
        cd rpi-fbcp/build
        cmake ..
        make
        sudo install fbcp /usr/local/bin/fbcp
        echo 'fbcp installed.'
    else
        echo 'fbcp already installed, skipping.'
    fi
"

# Install fbcp systemd service
echo "Installing fbcp systemd service..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
    sudo tee /etc/systemd/system/fbcp.service > /dev/null <<EOF
[Unit]
Description=Framebuffer copy to TFT display
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/fbcp
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    echo 'fbcp service installed.'
"

# Install display-switch script
echo "Installing display-switch script..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
    sudo tee /usr/local/bin/display-switch > /dev/null <<'EOF'
#!/bin/bash
if [ \"\$1\" = \"tft\" ]; then
    sudo cp /boot/config-tft.txt /boot/config.txt
    sudo systemctl enable fbcp
    echo \"Switched to TFT. Reboot to apply.\"
elif [ \"\$1\" = \"hdmi\" ]; then
    sudo cp /boot/config-hdmi.txt /boot/config.txt
    sudo systemctl disable fbcp
    echo \"Switched to HDMI. Reboot to apply.\"
else
    echo \"Usage: display-switch [tft|hdmi]\"
fi
EOF
    sudo chmod +x /usr/local/bin/display-switch
    echo 'display-switch installed.'
"

# Set ALSA volume cap at 70% to limit PAM8403 power draw on battery
# Class D amp power draw scales with signal amplitude — capping software volume
# reduces average current draw from the 18650 cell during normal gameplay.
# Persists across reboots via /var/lib/alsa/asound.state
echo "Setting audio volume cap..."
ssh -i "$SSH_KEY" "$PI_USER@$PI_HOST" "
    amixer -c 0 sset PCM 70% 2>/dev/null || amixer sset PCM 70% 2>/dev/null || echo 'Warning: could not set PCM volume — verify control name with: amixer controls'
    sudo alsactl store
    echo 'Audio volume set to 70% and persisted.'
"

# Deploy configs
echo "Deploying config files..."
bash "$SCRIPT_DIR/deploy.sh"

echo ""
echo "=== Setup complete ==="
echo "The Pi will reboot. After reboot, verify display and audio."
