# WiFi Management with nmcli (Bookworm+)

Raspberry Pi OS Bookworm replaced `dhcpcd` + `wpa_supplicant` with NetworkManager. The command-line tool for managing WiFi is now `nmcli`.

**Note:** This does NOT apply to Buster-based images (including the RetroPie image used in this project). Buster uses `wpa_supplicant` and `wpa_cli` instead. See below.

---

## Bookworm: nmcli

### List available WiFi networks

```bash
nmcli dev wifi list
```

### Connect to a network

```bash
nmcli dev wifi connect "NetworkName" password "YourPassword"
```

### Show current connection status

```bash
nmcli con show --active
nmcli dev status
```

### List saved connections

```bash
nmcli con show
```

### Forget a network

```bash
nmcli con delete "NetworkName"
```

### Reconnect

```bash
nmcli con up "NetworkName"
```

---

## Buster/Bullseye: wpa_supplicant

For older images (including the RetroPie Buster image used in this project).

### Add a new network

```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

Add:

```
network={
    ssid="NewNetwork"
    psk="NewPassword"
    key_mgmt=WPA-PSK
}
```

Reload without rebooting:

```bash
wpa_cli -i wlan0 reconfigure
```

### Check connection status

```bash
iwconfig wlan0
iwgetid                # Shows current SSID
ip addr show wlan0     # Shows IP address
```

---

## Static IP (Optional)

For a Pi that needs a predictable IP address, set a DHCP reservation in your router (preferred) rather than configuring a static IP in the OS. Router-side reservation means the Pi still uses DHCP but always gets the same address, without the risk of IP conflicts.
