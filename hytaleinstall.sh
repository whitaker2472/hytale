#!/usr/bin/env bash

# --- Configuration ---
CTID=$(pvesh get /cluster/nextid)
STORAGE="local-lvm"  # Change this to your storage name if different
DISK_SIZE="32G"
RAM="10240"
CORES="2"
PASSWORD="hytalepassword" # Change this!
HOSTNAME="hytale-server"

echo "--- Creating Hytale LXC (ID: $CTID) ---"

# 1. Download Debian 12 Template if not exists
pveam update
pveam download local debian-12-standard_12.7-1_amd64.tar.zst || true

# 2. Create the Container
pct create $CTID local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname $HOSTNAME \
  --password $PASSWORD \
  --storage $STORAGE \
  --rootfs $STORAGE:$DISK_SIZE \
  --memory $RAM \
  --cores $CORES \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --unprivileged 1 \
  --start 1

echo "--- Optimizing CPU ---"
# Set CPU to host for Java performance
pct set $CTID -cpu host

echo "--- Running Hytale Install Script Inside LXC ---"
# Wait for network to come up inside LXC
sleep 5

# This tells the new container to run your install script
pct exec $CTID -- bash -c "$(curl -fsSL https://raw.githubusercontent.com/whitaker2472/hytale/main/install_hytale.sh)"

echo "--- Setup Complete! ---"
echo "Your Hytale Server is at IP: $(pct exec $CTID -- hostname -I)"