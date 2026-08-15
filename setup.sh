#!/bin/bash
# setup.sh - Unified Homelab Installer
# Usage: ./setup.sh

set -e

if command -v whiptail >/dev/null 2>&1 && [ -z "$DISABLE_WHIPTAIL" ]; then
    NODE=$(whiptail --title "Homelab Installer" --menu "Which node are you configuring?" 15 60 2 \
    "Media-Server" "Media Stack, Dashboard, and Global Proxy" \
    "Network" "Core Services (Pi-hole, Kuma, Authelia)" \
    3>&1 1>&2 2>&3)
else
    echo "1) Media Server (Media Stack & Global Proxy)"
    echo "2) Network (Core Services)"
    read -p "Select node (1 or 2): " choice
    case $choice in
        1) NODE="Media-Server" ;;
        2) NODE="Network" ;;
        *) exit 1 ;;
    esac
fi

if [ "$NODE" = "Media-Server" ]; then
    echo "=== Starting automated deployment for Media Server ==="
    cd media-server
    ./setup.sh
    echo "Booting Media Docker Stack..."
    cd arr-stack && docker compose up -d
elif [ "$NODE" = "Network" ]; then
    echo "=== Starting automated deployment for Network ==="
    cd network/dns-stack
    ./deploy.sh
fi

echo "=== Homelab Deployment Complete! ==="
