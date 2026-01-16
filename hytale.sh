#!/usr/bin/env bash
# Source the helper library
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/lib/functions.sh)

# Set the LXC Variables
APP="Hytale"
var_os="debian"
var_version="12"
var_cpu="2"
var_ram="10240"
var_disk="32"
var_unprivileged="1"

# This function is required by the helper library
function update_script() {
    header_info
    msg_info "Updating Hytale Server"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/whitaker2472/hytale/main/hytaleinstall.sh)"
    msg_ok "Updated Successfully"
    exit
}

# 1. Run the Proxmox Branding and Checks
header_info
check_root

# 2. Start the LXC Creation process
# This will ask you for Storage, ID, etc.
start_script

# 3. Post-Creation Optimization (Runs on the Host)
msg_info "Optimizing CPU Type to 'host'"
# $CTID is automatically set by start_script
pct set $CTID -cpu host
msg_ok "CPU Optimized"

# 4. Finish
exit_script