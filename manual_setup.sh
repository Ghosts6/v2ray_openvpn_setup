#!/bin/bash

echo "Updating software..."
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y

echo "Installing packages..."
sudo apt install -y openvpn v2ray squid

echo "OpenVPN setup: Editing config file..."
sudo nano /etc/openvpn/server.conf

echo "Generate encryption keys..."
sudo openvpn --genkey --secret /etc/openvpn/ta.key
sudo openvpn --genkey --secret /etc/openvpn/ta.key

echo "Starting and enabling OpenVPN..."
sudo systemctl start openvpn@server && sudo systemctl enable openvpn@server

echo "Configuring IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p

echo "Adjusting Firewall Settings for OpenVPN..."
sudo ufw allow 1194/udp
sudo ufw reload

echo "V2Ray setup: Editing config file..."
sudo nano /etc/v2ray/config.json

echo "Starting and enabling V2Ray..."
sudo systemctl start v2ray && sudo systemctl enable v2ray

echo "Adjusting Firewall Settings for V2Ray..."
sudo ufw allow 12345
sudo ufw reload

echo "Script execution completed."
