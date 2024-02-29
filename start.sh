#!/bin/bash

echo "Starting services..."

# Update and upgrade packages
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y

# Start V2Ray
echo "Starting V2Ray..."
sudo systemctl start v2ray

# Start openVpn
echo "Starting Squid vpn server..."
sudo systemctl start openvpn@server || sudo systemctl start openvpn-server@server.service

# Enable services to start on boot
echo "Enabling services to start on boot..."
sudo systemctl enable v2ray
sudo systemctl enable openvpn@server 

echo "Services started and enabled successfully!"
