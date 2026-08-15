#!/bin/bash
# setup.sh - Unified Homelab Installer
# Usage: ./setup.sh

set -e

if command -v whiptail >/dev/null 2>&1 && [ -z "$DISABLE_WHIPTAIL" ]; then
    NODE=$(whiptail --title "Homelab Installer" --menu "Which node are you configuring?" 15 60 2 \
    "Media-Node" "Media Stack, Dashboard, and Global Proxy" \
    "Network-Node" "Core Services (Pi-hole, Kuma, Authelia)" \
    3>&1 1>&2 2>&3)
else
    echo "1) Media Node (Media Stack & Global Proxy)"
    echo "2) Network Node (Core Services)"
    read -p "Select node (1 or 2): " choice
    case $choice in
        1) NODE="Media-Node" ;;
        2) NODE="Network-Node" ;;
        *) exit 1 ;;
    esac
fi

if [ "$NODE" = "Media-Node" ]; then
    echo "=== Starting automated deployment for Media Node ==="
    cd media-services
    ./setup.sh
    echo "🚀 Booting Media Docker Stack..."
    cd arr-stack && docker compose up -d
elif [ "$NODE" = "Network-Node" ]; then
    echo "=== Starting automated deployment for Network Node ==="
    cd network-services/dns-stack
    ./deploy.sh
fi

echo "=== Homelab Deployment Complete! ==="
