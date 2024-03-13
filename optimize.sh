#!/bin/bash

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt update
sudo apt upgrade -y

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt autoremove -y

# Clear package cache
echo "Clearing package cache..."
sudo apt clean

# Optimize swap usage
echo "Optimizing swap usage..."
sudo echo 1 > /proc/sys/vm/drop_caches
sudo swapoff -a
sudo swapon -a

# Optimize TCP connections
echo "Optimizing TCP connections..."
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65536
sudo sysctl -w net.core.somaxconn=65536

# enablie IPv6 
echo "Disabling IPv6..."
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0

# Adjust file descriptor limits
echo "Adjusting file descriptor limits..."
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Restart services
echo "Restarting services..."
sudo systemctl restart v2ray
sudo systemctl restart openvpn@server || sudo systemctl restart openvpn-server@server.service
sudo systemctl restart squid

echo "Optimization completed."
