#!/bin/bash

echo "update and upgrade..."
sudo apt-get update 
sudo apt-get upgrade 

echo "installing squid..."
sudo apt-get install squid
sudo systemctl enable squid

echo "configuretion..."
read -p "Enter port[3218]" port
if [ -z "$port" ]; then
    port="3218"
fi

sudo sed -i "s/http_port 3128/http_port $port transparent/" /etc/squid/squid.conf
sudo sed -i "s/http_access deny all/http_access allow all/" /etc/squid/squid.conf

echo "config firewall..."
sudo ufw allow $port
sudo ufw reload
sudo ufw status

echo "startin service..."
sudo systemctl restart squid
sudo systemctl status squid

echo "create user..."
apt-get install apache2-utils -y
sudo touch /etc/squid/passwd
sudo chown proxy: /etc/squid/passwd

read -p "Enter username:" user
sudo htpasswd /etc/squid/passwd $user

# Adding lines for basic authentication
echo "auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic children 5" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic realm Squid Basic Authentication" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic credentialsttl 2 hours" | sudo tee -a /etc/squid/squid.conf
echo "acl auth_users proxy_auth REQUIRED" | sudo tee -a /etc/squid/squid.conf

read -p "installtion finshed,do you want create website block list(y/n)?" choice

if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
    read -p "Enter the number of websites you want to block (default value = 10): " range

    if [ -z "$range" ]; then
        range=10
    fi

    array_name="block$range"
    declare -a "$array_name"

    echo "Hint ! enter dot(.) befor start of url for example(.yahoo.com) "

    # Get input for the array
    for ((i=0; i<$range; i++)); do
    read -p "Enter website URL for ${array_name}[$i]: " website
    eval "${array_name}[$i]=$website" 
    done

    # Write array members to the file
    for ((i=0; i<$range; i++)); do
        echo "${array_name}[$i]" | sudo tee -a /etc/squid/blocked.acl
    done

    echo "acl blocked_websites dstdomain \"/etc/squid/blocked.acl\"" | sudo tee -a /etc/squid/squid.conf
    echo "http_access deny blocked_websites" | sudo tee -a /etc/squid/squid.conf

    sudo systemctl restart squid
    sudo systemctl status squid

else
    echo "End of program."
fi
