#!/usr/bin/env bash
# Official-style Proxmox LXC Creator for Hytale

# UPDATED SOURCE LINK
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/lib/functions.sh)

# If the above still fails, it means curl is failing. 
# We add this check to stop the script if the library isn't loaded.
if [[ -z "$FUNCTIONS_FILE_PATH" ]]; then
  echo "Error: Could not load helper functions. Check your internet connection."
  exit 1
fi

color
header_info
#!/usr/bin/env bash
# Official-style Proxmox LXC Creator for Hytale
#source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/lib/functions.sh)
#color
#header_info

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
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/whitaker2472/hytale/refs/heads/main/install_hytale.sh)"
  msg_ok "Updated Successfully"
  exit
}

start_script

# --- CPU Optimization Section ---
# This runs on the Proxmox Host after the container is created
#msg_info "Optimizing CPU Type to 'host'"
# $CTID is a variable provided by the Proxmox script library
#pct set $CTID --cpuunit 1024 --cpulimit $var_cpu --cpu host
#msg_ok "CPU Optimized for Java Performance"