#!/bin/bash
# setup.sh - Unified Homelab Installer
# Usage: ./setup.sh

set -e

if command -v whiptail >/dev/null 2>&1 && [ -z "$DISABLE_WHIPTAIL" ]; then
    NODE=$(whiptail --title "Homelab Installer" --menu "Which node are you configuring?" 15 60 2 \
    "Odin" "Media Stack, Dashboard, and Global Proxy" \
    "Loki" "Core Services (Pi-hole, Kuma, Authelia)" \
    3>&1 1>&2 2>&3)
else
    echo "1) Odin (Media Stack & Global Proxy)"
    echo "2) Loki (Core Services)"
    read -p "Select node (1 or 2): " choice
    case $choice in
        1) NODE="Odin" ;;
        2) NODE="Loki" ;;
        *) exit 1 ;;
    esac
fi

if [ "$NODE" = "Odin" ]; then
    echo "=== Starting automated deployment for Odin ==="
    cd media-services
    ./setup.sh
    echo "🚀 Booting Odin Docker Stack..."
    cd arr-stack && docker compose up -d
elif [ "$NODE" = "Loki" ]; then
    echo "=== Starting automated deployment for Loki ==="
    cd core-services/dns-stack
    ./deploy.sh
fi

echo "=== Homelab Deployment Complete! ==="
