# Raspberry Pi OS

Configuration and setup guides for Raspberry Pi OS (formerly Raspbian).

## Docs in This Section

- [headless-setup.md](headless-setup.md) — first boot with SSH and WiFi, no monitor required
- [ssh-configuration.md](ssh-configuration.md) — SSH keys, config file, hardening
- [wifi-nmcli.md](wifi-nmcli.md) — managing WiFi connections with nmcli (Bookworm+)
- [trixie-xrdp-setup.md](trixie-xrdp-setup.md) — xrdp + Xfce4 on Trixie (Wayland gotchas, working config)

## OS Versions

| Version | Debian Base | Config File Path | Notes |
|---------|------------|-----------------|-------|
| Buster | Debian 10 | `/boot/config.txt` | Used in mini-crt-arcade project |
| Bullseye | Debian 11 | `/boot/config.txt` | Transitional |
| Bookworm | Debian 12 | `/boot/firmware/config.txt` | NetworkManager replaces dhcpcd |
| Trixie | Debian 13 | `/boot/firmware/config.txt` | Full Wayland/labwc desktop. xrdp requires Xfce4. pigpio not in repos. |

The config file path change in Bookworm is a common gotcha — always check which OS version you're on before editing boot config.
