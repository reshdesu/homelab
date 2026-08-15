# Homelab Architecture Rules & Context

This file serves as the core brain for this repository. If you are an AI assistant reading this, you are operating within the `homelab` monorepo. Use this knowledge to help the user manage, deploy, and debug their infrastructure.

## Global Network Architecture
- **Tailscale Mesh**: All homelab nodes are connected via Tailscale. 
- **Subnet Routing**: The primary Media Node acts as a Tailscale Subnet Router to route traffic for the local network.
- **Split DNS**: Avoid Split DNS over Tailscale when possible. Rely on Tailscale's MagicDNS combined with Caddy's reverse proxy for external service resolution.

## Server Nodes
The homelab currently consists of two primary nodes:

### 1. Media Server - The Media & Proxy Node
- **Role**: Serves as the primary entry point (Caddy Reverse Proxy), hosts the static Dashboard UI, and runs the Media Stack.
- **Repository Path**: `media-server/`
- **Key Services**:
  - **Caddy** (Global Reverse Proxy): Runs as a systemd service. Configuration is at `caddy/Caddyfile`.
  - **Dashboard**: Static HTML/CSS hosted at `/var/www/dashboard` (source in `dashboard/`).
  - **Arr Stack**: Sonarr, Radarr, Prowlarr, SABnzbd, Plex. (Runs via Docker in `media-server/arr-stack/`).

### 2. Network - The Network Node
- **Role**: Hosts core DNS, SSO, and monitoring services.
- **Repository Path**: `network/`
- **Key Services**:
  - **Pi-hole**: Port 8080.
  - **Uptime Kuma**: Port 3001.
  - **Authelia**: Port 9091.

## Caddy Reverse Proxy & Port Strategy
Because Uptime Kuma, Pi-hole (v6 API), and Authelia do not support sub-directory routing (`/path/`), Caddy on the Media Node is configured to reverse-proxy the Network Node's services onto **dedicated ports** on the Tailscale domain:

- **Dashboard**: `https://<tailscale-domain>/`
- **Pi-hole**: `https://<tailscale-domain>:8081/admin` (Note: Uses 8081 because SABnzbd natively uses 8080 on the Media Node).
- **Uptime Kuma**: `https://<tailscale-domain>:3001`
- **Authelia**: `https://<tailscale-domain>:9091`

## Deployment & Setup
- The master installer script is located at `./setup.sh` at the repository root.
- Running `./setup.sh` opens an interactive UI to deploy either the Media Server or the Network node on a fresh OS installation.
- **Never commit `arr-stack/config`** (live application data) to Git to avoid bloating the repository.
