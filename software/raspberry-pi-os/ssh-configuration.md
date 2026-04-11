# SSH Configuration

## Generating an SSH Key for Pi Access

```bash
# Generate a dedicated key for Pi access
ssh-keygen -t ed25519 -f ~/.ssh/pi_key -C "raspberry pi"
```

## Copying the Key to the Pi

```bash
ssh-copy-id -i ~/.ssh/pi_key.pub pi@retropie.local
```

Or manually:

```bash
# On the Pi
mkdir -p ~/.ssh
echo "YOUR_PUBLIC_KEY_CONTENT" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

## SSH Config on Your Mac

Add to `~/.ssh/config`:

```
Host retropie
    HostName retropie.local
    User pi
    IdentityFile ~/.ssh/pi_key
    ServerAliveInterval 60
```

Then connect with just: `ssh retropie`

The `ServerAliveInterval` prevents disconnection during long operations (like package installs).

## Running Commands Remotely

All deploy and setup scripts use this pattern:

```bash
# Copy a file to the Pi
scp -i ~/.ssh/pi_key localfile.txt pi@retropie.local:/tmp/

# Run a command on the Pi
ssh -i ~/.ssh/pi_key pi@retropie.local "sudo apt-get update"

# Run a multi-line script on the Pi
ssh -i ~/.ssh/pi_key pi@retropie.local << 'EOF'
sudo mv /tmp/config.txt /boot/config.txt
sudo reboot
EOF
```

## Disable Password Auth (Optional Hardening)

After confirming key auth works:

```bash
# On the Pi
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart ssh
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Permission denied (publickey)` | Key not in `authorized_keys` — re-run `ssh-copy-id` |
| `Host key verification failed` | Pi was re-flashed — run `ssh-keygen -R retropie.local` |
| `Connection refused` | SSH not enabled, or Pi still booting |
| `retropie.local` not found | mDNS not working — use IP address or scan with nmap |
