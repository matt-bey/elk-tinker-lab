# xrdp on Raspberry Pi OS Trixie

Setting up RDP access to a Pi 4 running Trixie (Debian 13). Trixie's full migration to
Wayland breaks the standard xrdp approach — this doc covers what fails and the working
configuration using Xfce4.

**Use case:** Headless Pi 4 with RDP from iPad (Windows App / Microsoft Remote Desktop)
and Mac, plus VS Code Remote SSH from Mac.

---

## Why the Standard Approach Fails

The usual advice — install xrdp, switch lightdm to X11, configure `startwm.sh` to launch
the desktop — breaks on Trixie because Raspberry Pi Desktop (RPD) has fully migrated to
**Wayland/labwc**. The RPD components (`lxpanel-pi`, `wf-panel-pi`, `pcmanfm-pi`) are now
built against Wayland libraries. Running them under X11 causes:

- Immediate SIGSEGV in the window manager
- Fatal X IO errors in `~/.cache/lxsession/rpd-x/run.log`
- `wf-panel-pi` leaking into the X11 xrdp session and crashing it

**Confirm Wayland linkage:**
```bash
ldd /usr/bin/lxpanel-pi | grep -i wayland
```

**Solution:** Use Xfce4 for xrdp sessions. It is pure X11, has no Wayland dependencies,
and works reliably with xrdp on Trixie.

---

## Working Configuration

### 1. Install xrdp and Xfce4

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y xrdp xfce4 xfce4-goodies
sudo systemctl enable xrdp
sudo systemctl start xrdp
```

### 2. Configure startwm.sh

Edit `/etc/xrdp/startwm.sh`. Replace the final two `exec` lines with:

```bash
exec dbus-launch --exit-with-session startxfce4
```

The end of the file should look like:
```sh
if test -r /etc/profile; then
    . /etc/profile
fi

if test -r ~/.profile; then
    . ~/.profile
fi

exec dbus-launch --exit-with-session startxfce4
```

`dbus-launch` is required because xrdp creates an isolated X session that bypasses normal
login machinery — D-Bus is not started automatically. Without it, Xfce4 starts but
components can't communicate (black screen or broken session).

### 3. Disable Auto-Login

```bash
sudo raspi-config
# System Options → Boot / Auto Login → Desktop (not Desktop Autologin)
```

**This is critical.** Trixie defaults to auto-login for the primary user. When the user
is already in a local desktop session, xrdp cannot create a new session for the same user
— the result is a black screen with no error message.

### 4. Restart xrdp

```bash
sudo systemctl restart xrdp
```

### 5. Connect

- **Host:** `hostname.local` or IP address
- **Username / Password:** the Pi user credentials

Xfce4 takes a few seconds to fully render on first connect.

---

## VS Code Remote (Mac)

1. Install the **Remote - SSH** extension in VS Code
2. Ensure `~/.ssh/config` has an entry for the Pi (see [ssh-configuration.md](ssh-configuration.md))
3. `Cmd+Shift+P` → `Remote-SSH: Connect to Host` → select the Pi
4. VS Code installs its server component automatically on first connect (~1 min)

---

## GPIO Libraries on Trixie

`pigpio` is not available in the Trixie apt repos. Use `lgpio` as the gpiozero backend:

```bash
sudo apt install -y python3-gpiozero python3-lgpio
echo "GPIOZERO_PIN_FACTORY=lgpio" | sudo tee /etc/environment
```

This covers LEDs, buttons, and basic motors. Only consider building pigpio from source if
you need precise hardware PWM for servos.

**Quick test (blink LED on GPIO 17):**
```python
from gpiozero import LED
from time import sleep

led = LED(17)

while True:
    led.on()
    sleep(1)
    led.off()
    sleep(1)
```

---

## Scratch 3

Not installed by default in this RDP/Xfce4 setup:

```bash
sudo apt install -y scratch3
```

Scratch 3 on Raspberry Pi OS includes built-in GPIO extensions (GPIO and Simple
Electronics). Access them via the blue extension button (bottom-left) in Scratch 3.

---

## Trixie-Specific Changes Summary

| Area | Trixie Change |
|------|--------------|
| Desktop compositor | labwc (Wayland) is the default — RPD components are Wayland-only |
| xrdp compatibility | RPD desktop crashes under X11 — use Xfce4 instead |
| Auto-login | Enabled by default — breaks xrdp (must disable) |
| GPIO daemon | `pigpio` not in apt repos — use `lgpio` as gpiozero backend |
| First-boot config | cloud-init replaces `firstrun.sh` — always use Raspberry Pi Imager settings |
| Wayland options | `raspi-config → A6` offers X11, Wayfire, labwc (labwc is default; Wayfire deprecated) |

---

## Black Screen Debugging

A black screen after xrdp login has multiple causes on Trixie:

1. **Auto-login enabled** (most common) — disable in raspi-config
2. **Wayland component leak** — ensure `startwm.sh` launches Xfce4, not RPD
3. **Missing D-Bus session** — ensure `dbus-launch --exit-with-session` is in `startwm.sh`
4. **Stale xrdp session** — kill lingering sessions and restart xrdp

```bash
# xrdp service log
sudo journalctl -u xrdp -n 50

# Session manager log
cat /var/log/xrdp-sesman.log | tail -30

# Desktop session errors
cat ~/.xsession-errors | tail -40

# lxsession log (if you tried RPD X11 session)
cat ~/.cache/lxsession/rpd-x/run.log
```
