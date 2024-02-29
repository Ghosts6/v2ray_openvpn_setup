#! /bin/bash

# Stop V2Ray
echo "Stopping V2Ray"
sudo systemctl stop v2ray

# Stop Squid Proxy
echo "Stopping openvpn vpn server ..."
sudo systemctl stop openvpn@server || sudo systemctl stop openvpn-server@server.service

echo "Services stopped successfully"
