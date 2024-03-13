#! /bin/bash

# Stop V2Ray
echo "Stopping V2Ray"
sudo systemctl stop v2ray

# Stop open vpn
echo "Stopping openvpn vpn server ..."
sudo systemctl stop openvpn@server || sudo systemctl stop openvpn-server@server.service

# Stop squid
echo "Stopping squid ..."
sudo systemctl stop squid

echo "Services stopped successfully"
