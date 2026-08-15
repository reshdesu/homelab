# Homelab Monorepo

Infrastructure-as-Code repository for managing homelab services across multiple nodes.

## Repository Overview

This repository contains configuration files, deployment scripts, reverse proxy definitions, and static dashboard assets for the homelab environment.

```text
homelab/
├── caddy/
│   └── Caddyfile            # Master reverse proxy configuration
├── dashboard/
│   ├── index.html           # Material Design unified homepage
│   ├── styles.css           # Styling tokens and grid layout
│   ├── favicon.png
│   └── logo.png
├── media-server/
│   └── arr-stack/
│       ├── docker-compose.yml # Sonarr, Radarr, Prowlarr, SABnzbd, Plex
│       └── .env.example
├── network/
│   └── dns-stack/
│       ├── docker-compose.yml # Pi-hole, Uptime Kuma, Authelia
│       └── deploy.sh
├── AGENTS.md                # System architectural memory and instructions
└── setup.sh                 # Unified installer script
```

## Architecture and Design Principles

1. **Separation of Code and Data**:
   - The repository contains only configuration files, compose manifests, and scripts.
   - Application data directories (such as `/config` mounts) are stored in an external data directory (`CONFIG_ROOT`, default: `/home/reshdesu/data/config`).
   - Media libraries are mounted separately (`MEDIA_ROOT`, default: `/mnt/media`).

2. **Mesh Networking**:
   - Nodes communicate securely over Tailscale.
   - Tailscale MagicDNS handles host name resolution.

3. **Reverse Proxy & Service Exposure**:
   - Caddy runs on the Media Server node as the primary ingress point.
   - Services with root-path restrictions (such as Pi-hole, Uptime Kuma, and Authelia) are proxied on dedicated ports over HTTPS.

## Installation

### Fresh System Deployment

1. Clone this repository:
   ```bash
   git clone https://github.com/reshdesu/homelab.git
   cd homelab
   ```

2. Run the interactive setup script:
   ```bash
   ./setup.sh
   ```

3. Follow the menu prompt to select the target node role (`Media-Server` or `Network`).

### Manual Node Execution

- **Media Server**:
  ```bash
  cd media-server/arr-stack
  docker compose up -d
  ```

- **Network Node**:
  ```bash
  cd network/dns-stack
  ./deploy.sh
  ```

## Backup and Restoration

Daily backup scripts for application configuration files are scheduled via system cron. Runtime data directories should be backed up independently.
