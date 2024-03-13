#!/bin/bash

echo "checking opnVpn status.."
sudo systemctl status openvpn@server || sudo systemctl status openvpn-server@server.service
sudo systemctl is-active openvpn@server
echo "checking v2ray status ..."
sudo systemctl status v2ray
sudo systemctl is-active v2ray
echo "Checking Squid status ..."
sudo systemctl status squid

echo "end of operations"
