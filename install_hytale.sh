#!/usr/bin/env bash
# Hytale Internal Installation Script
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/lib/functions.sh)

msg_info "Installing Java 25 & Dependencies"
$STD apt-get update
$STD apt-get install -y wget apt-transport-https gnupg unzip
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - &>/dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/adoptium.list
$STD apt-get update
$STD apt-get install -y temurin-25-jdk
msg_ok "Java 25 Installed"

msg_info "Setting up Hytale User"
useradd -m -s /bin/bash hytale
mkdir -p /opt/hytale
chown -R hytale:hytale /opt/hytale
msg_ok "Environment Ready"

msg_info "Downloading Hytale CLI"
sudo -u hytale bash <<EOF
cd /opt/hytale
wget -q https://hytale.com/downloads/hytale-downloader.zip
unzip -q hytale-downloader.zip
chmod +x hytale-downloader
EOF
msg_ok "CLI Ready"

# This triggers the downloader automatically and waits for user auth
msg_info "Starting Hytale Downloader"
echo -e "\n\e[33m--- ACTION REQUIRED ---\e[0m"
echo -e "The Hytale Downloader will now start. Follow the on-screen instructions"
echo -e "to visit the Hytale website and authorize this server."
echo -e "\e[33m-----------------------\e[0m\n"
sleep 3
sudo -u hytale /opt/hytale/hytale-downloader

msg_info "Creating Systemd Service"
cat <<EOF >/etc/systemd/system/hytale.service
[Unit]
Description=Hytale Dedicated Server
After=network-online.target

[Service]
Type=simple
User=hytale
WorkingDirectory=/opt/hytale
# Uses 4GB RAM by default, optimized for LXC
ExecStart=/usr/bin/java -Xmx8G -Xms8G -XX:+UseG1GC -jar HytaleServer.jar --assets Assets.zip
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q hytale
msg_ok "Service Created"

motd_ssh
customize
cleanup_lxc