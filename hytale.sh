sudo -u hytale bash <<EOF
cd /opt/hytale
wget -q https://hytale.com/downloads/hytale-downloader.zip
unzip -q hytale-downloader.zip
chmod +x hytale-downloader
EOF

# 5. Set Firewall (UDP for Hytale/QUIC)
if command -v ufw >/dev/null; then
  ufw allow 5520/udp
fi

# 6. Create the Systemd Service
cat <<EOF >/etc/systemd/system/hytale.service
[Unit]
Description=Hytale Dedicated Server
After=network-online.target

[Service]
Type=simple
User=hytale
WorkingDirectory=/opt/hytale
ExecStart=/usr/bin/java -Xmx8G -Xms8G -XX:+UseG1GC -jar HytaleServer.jar --assets Assets.zip
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload