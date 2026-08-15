#!/bin/bash

# Deploy the stack
echo "🚀 Bringing up the Core Network Stack..."
docker compose up -d

# Wait for Uptime Kuma to generate its initial SQLite database
# Wait for Uptime Kuma to generate its initial SQLite database
echo "⏳ Waiting for Uptime Kuma to initialize (this may take up to 60s on Loki)..."
for i in {1..15}; do
    if docker exec uptime-kuma curl -s -f http://localhost:3001/ > /dev/null; then
        echo "✅ Database initialized and app is running!"
        break
    fi
    echo "Waiting 5s..."
    sleep 5
done

# Automatically inject the Disable Auth flag into the database
echo "💉 Injecting Zero-Touch SSO configuration into Uptime Kuma..."
docker exec uptime-kuma sqlite3 data/kuma.db "INSERT INTO setting (key, value, type) VALUES ('disableAuth', 'true', 'boolean') ON CONFLICT(key) DO UPDATE SET value='true';"
docker exec uptime-kuma sqlite3 data/kuma.db "INSERT INTO user (username, password) VALUES ('admin', 'disabled') ON CONFLICT(username) DO NOTHING;"

# Restart to apply the injection
echo "🔄 Restarting Uptime Kuma to apply zero-touch settings..."
docker compose restart uptime-kuma

echo "✅ Deployment Complete! The stack is fully automated and protected by Authelia."
