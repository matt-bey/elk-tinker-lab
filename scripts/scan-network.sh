#!/bin/bash
# Scan local network for Raspberry Pi devices
# Uses nmap to find hosts with Raspberry Pi MAC address OUI or hostname

set -e

# Detect local subnet from default route
SUBNET="${1:-$(ip route | awk '/default/ {print $3}' | sed 's/\.[0-9]*$//' 2>/dev/null).0/24}"

# Fallback for macOS (no ip route)
if [ -z "$SUBNET" ] || [ "$SUBNET" = ".0/24" ]; then
    SUBNET="${1:-$(route -n get default 2>/dev/null | awk '/gateway:/ {print $2}' | sed 's/\.[0-9]*$//' 2>/dev/null).0/24}"
fi

# If still empty, use a common default
if [ -z "$SUBNET" ] || [ "$SUBNET" = ".0/24" ]; then
    SUBNET="192.168.1.0/24"
    echo "Warning: Could not detect subnet automatically. Using $SUBNET"
    echo "Override with: $0 192.168.x.0/24"
    echo ""
fi

echo "Scanning $SUBNET for Raspberry Pi devices..."
echo "(This may take 10-30 seconds)"
echo ""

if ! command -v nmap &> /dev/null; then
    echo "Error: nmap is not installed."
    echo "Install with: brew install nmap"
    exit 1
fi

# Scan for hosts and show those with Raspberry Pi OUI (B8:27:EB, DC:A6:32, E4:5F:01)
# or hostname containing 'retropie', 'raspberrypi', 'pi'
nmap -sn "$SUBNET" -oG - 2>/dev/null | \
    awk '/Up$/{print $2}' | \
    while read -r IP; do
        # Try to get hostname and MAC
        INFO=$(nmap -sn "$IP" 2>/dev/null)
        HOSTNAME=$(echo "$INFO" | awk '/Nmap scan report/ {print $5}')
        MAC=$(echo "$INFO" | awk '/MAC Address/ {print $3}')
        OUI=$(echo "$MAC" | cut -d: -f1-3 | tr '[:lower:]' '[:upper:]')

        # Raspberry Pi OUIs
        if echo "$OUI" | grep -qE "B8:27:EB|DC:A6:32|E4:5F:01" 2>/dev/null; then
            echo "  $IP  $HOSTNAME  [Raspberry Pi MAC: $MAC]"
        elif echo "$HOSTNAME" | grep -qiE "retropie|raspberrypi|raspi" 2>/dev/null; then
            echo "  $IP  $HOSTNAME  [Pi hostname]"
        fi
    done

echo ""
echo "Scan complete."
echo "Tip: Try 'ping retropie.local' or 'ping raspberrypi.local' for mDNS lookup."
