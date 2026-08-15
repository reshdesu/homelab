# Server Inventory

## Global Network Info
- **Wi-Fi SSID:** `HealB0mbTink`
- **Wi-Fi Password:** `<REDACTED>`
- **User:** `reshdesu` (Passwordless sudo)
- **User Password:** `<REDACTED>`

## Server: Thor (Secondary Node)
- **Hardware:** HP 2000 Notebook PC (AMD E-350, 2.5GB RAM, 100GB HDD)
- **IP Address:** `192.168.1.144` (Dynamic DHCP, Wi-Fi `wlo1`)
- **OS:** Ubuntu Server 24.04
- **Pi-hole UI:** `http://192.168.1.144/admin` (Password: `<REDACTED>`)
- **Quirks:**
  - Physical Wi-Fi button (F-key) can hard-block the radio.
  - Laptop lid suspend permanently disabled (`HandleLidSwitch=ignore` in `logind.conf`).
  - Port 53 freed by disabling `DNSStubListener` in `systemd-resolved`.

## Server: Loki (Primary Node)
- **Hardware:** Compaq CQ58 Notebook PC (AMD C-60, 2GB RAM, 100GB HDD)
- **IP Address:** `192.168.1.151` (Wi-Fi)
- **OS:** Ubuntu Server 24.04
- **Pi-hole UI:** `http://192.168.1.151/admin` (Password: `<REDACTED>`)
- **Quirks:**
  - Laptop lid suspend permanently disabled (`HandleLidSwitch=ignore` and `HandleLidSwitchExternalPower=ignore` in `logind.conf`).
  - Port 53 freed by disabling `DNSStubListener` in `systemd-resolved`.

## Batteries
Both laptops use the exact same standard HP replacement battery: **HP MU06** (Part: `593553-001`).
