#!/usr/bin/env bash
# Official-style Proxmox LXC Creator for Hytale
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/lib/functions.sh)
color
header_info

# Default Settings
var_os="debian"
var_version="12"
var_cpu="2"
var_ram="10240"
var_disk="32"
var_unprivileged="1"

# Container description
APP="Hytale-Server"

function update_script() {
  header_info
  msg_info "Updating Hytale Server"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/YOUR_REPO/main/install_hytale.sh)"
  msg_ok "Updated Successfully"
  exit
}

start_script

# --- CPU Optimization Section ---
# This runs on the Proxmox Host after the container is created
msg_info "Optimizing CPU Type to 'host'"
# $CTID is a variable provided by the Proxmox script library
pct set $CTID --cpuunit 1024 --cpulimit $var_cpu --cpu host
msg_ok "CPU Optimized for Java Performance"