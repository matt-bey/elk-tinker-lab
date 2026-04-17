#!/bin/bash
# Deploy hey-lantern software to Pi for testing.
# Usage: ./deploy-software.sh [user@host]
# Default target: matt@elkpi02.local

set -euo pipefail

TARGET="${1:-matt@elkpi02.local}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/elkpi_key}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_DIR="$SCRIPT_DIR/../software"
REMOTE_DIR="~/hey-lantern"

ssh_cmd() { ssh -i "$SSH_KEY" "$TARGET" "$@"; }

echo "→ Deploying to $TARGET:$REMOTE_DIR"

# Sync source files — excludes build artifacts and .env (never overwrite Pi secrets)
rsync -az --delete \
  --exclude='.venv/' \
  --exclude='__pycache__/' \
  --exclude='*.pyc' \
  --exclude='.env' \
  --exclude='dist/' \
  --exclude='build/' \
  -e "ssh -i $SSH_KEY" \
  "$SOFTWARE_DIR/" \
  "$TARGET:$REMOTE_DIR/"

# Install uv on Pi if missing
ssh_cmd '[ -f "$HOME/.local/bin/uv" ] || curl -LsSf https://astral.sh/uv/install.sh | sh'

# Install Python dependencies
ssh_cmd "cd $REMOTE_DIR && \$HOME/.local/bin/uv sync"

# Copy .env on first deploy — never overwrites an existing one
if [ -f "$SOFTWARE_DIR/.env" ]; then
  if ! ssh_cmd "test -f $REMOTE_DIR/.env"; then
    echo "→ Copying .env to Pi (first deploy only)"
    scp -i "$SSH_KEY" "$SOFTWARE_DIR/.env" "$TARGET:$REMOTE_DIR/.env"
  fi
else
  if ! ssh_cmd "test -f $REMOTE_DIR/.env"; then
    echo "⚠  No .env found locally or on Pi."
    echo "   Create $REMOTE_DIR/.env on the Pi (see .env.example)."
  fi
fi

echo ""
echo "Done. Note: portaudio must be installed on the Pi for sounddevice to work:"
echo "  sudo apt-get install -y portaudio19-dev libsndfile1"
echo ""
echo "To run:"
echo "  ssh -i $SSH_KEY $TARGET"
echo "  cd $REMOTE_DIR && uv run python src/main.py"
