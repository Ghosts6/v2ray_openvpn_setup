![baner](https://github.com/Ghosts6/Local-website/blob/main/img/Baner.png)

# 🌎v2ray&openvpn:

This repo include bash files to setup and manage service like v2ray and openvpn 
in this repo we place two setup method and some scripts which you can use them for service
management



# 📖usage:

To using this files, clone the repository using the command: git clone https://github.com/Ghosts6/v2ray_openvpn_setup.git. Ensure executable permissions by running chmod +x filename on the relevant file. Depending on your requirements, execute the desired file by running ./filename. This sequence allows seamless access and execution of the provided files from the repository.

```bash
chmod +x start.sh stop.sh setup.sh status.sh optimize.sh manual_setup.sh
./example.sh
```

# 📱setup.sh: 

With setup.sh, you can easily configure V2Ray, OpenVPN, or both at same time. The script automates the preparation of requirements, configures the necessary firewall rules during setup, and setup will be end by entering some  input such as domain, preferred services, and more, streamlining the service setup process.

setup.sh:
```bash
#!/bin/bash

echo "Updating software..."
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y

echo "Enableing ip forwarding.."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p

echo "Installing firewall..."
sudo apt-get install ufw

echo "Writing firewall rules and enabling firewall...."
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 1000/tcp
sudo ufw allow 443/tcp
sudo ufw allow 1194/udp

sudo ufw enable

echo "Which service do you like to install?"
echo "1. v2ray"
echo "2. openvpnserver"
echo "3. both"

read -p "Enter the number corresponding to your choice: " choice

case $choice in
    1)
        echo "Installing v2ray..."
        sudo apt-get install nginx -y
        sudo apt-get install wget

        read -p "Please enter your domain (example.com): " domain
        sudo sed -i "s/server_name _;/server_name $domain;/g" /etc/nginx/sites-available/default
        systemctl restart nginx
        snap install core
        snap install --classic certbot
        ln -s /snap/bin/certbot /usr/bin/certbot
#       echo "nginx configuretion:"
#       certbot --nginx    #  un commend if you need nginx service also un commend nginx config section too
        echo "v2ray setup..."
        wget --no-check-certificate https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
        bash install-release.sh
        sudo apt-get install uuid -y
        uuid=$(uuid -v 4)
        hex_number=$(openssl rand -hex 4)
        config_file="/usr/local/etc/v2ray/config.json"
        echo "{
          \"log\": {
            \"loglevel\": \"warning\",
            \"access\": \"/var/log/v2ray/access.log\",
            \"error\": \"/var/log/v2ray/error.log\"
          },
          \"inbounds\": [{
            \"port\": 10000,
            \"protocol\": \"vmess\",
            \"settings\": {
              \"clients\": [
                {
                  \"id\": \"$uuid\",
                  \"level\": 1,
                  \"alterId\": 4
                }
              ]
            },
            \"streamSettings\": {
              \"network\": \"ws\",
              \"wsSettings\": {
                \"path\": \"$hex_number\"
              }
            }
          }],
          \"outbounds\": [{
            \"protocol\": \"socks\",
            \"settings\": {
              \"servers\": [{
                \"address\": \"127.0.0.1\",
                \"port\": 9050,
                \"auth\": \"noauth\"
              }]
            }
          },{
            \"protocol\": \"blackhole\",
            \"settings\": {},
            \"tag\": \"blocked\"
          }],
          \"routing\": {
            \"rules\": [
              {
                \"type\": \"field\",
                \"ip\": [\"geoip:private\"],
                \"outboundTag\": \"blocked\"
              }
            ]
          }
        }" | sudo tee "$config_file" > /dev/null

        # nginx config     
#        cat <<EOL | sudo tee -a /etc/nginx/sites-available/default > /dev/null
#location /144c0889 {
#    proxy_redirect off;
#    proxy_pass http://127.0.0.1:10000;
#    proxy_http_version 1.1;
#    proxy_set_header Upgrade \$http_upgrade;
#    proxy_set_header Connection "upgrade";
#    proxy_set_header Host \$http_host;
#    # Show real IP if you enable V2Ray access log
#   proxy_set_header X-Real-IP \$remote_addr;
#    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#}
#EOL
        systemctl enable v2ray
        systemctl start v2ray
        ;;

    2)
        echo "Installing openvpnserver..."
        echo "your ip is ...."
        sudo apt-get install curl && sudo apt-get install wget
        curl ifconfig.me || wget -qO- ifconfig.me
        wget https://git.io/vpn -O openvpn-install.sh
        sudo chmod +x openvpn-install.sh
        echo "please fill data based on your need ..."
        sudo bash openvpn-install.sh
        sudo systemctl start openvpn-server@server.service

        read -p "Do you want to create a new client? (y/n): " answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            sudo bash openvpn-install.sh
        else
            echo "OpenVPN installation completed ."
        fi
        ;;
    3)
        echo "Installing both v2ray and openvpnserver..."
        # Install v2ray (case 1)
        echo "Installing v2ray..."
        sudo apt-get install nginx -y
        sudo apt-get install wget

        read -p "Please enter your domain (example.com): " domain
        sudo sed -i "s/server_name _;/server_name $domain;/g" /etc/nginx/sites-available/default
        systemctl restart nginx
        snap install core
        snap install --classic certbot
        ln -s /snap/bin/certbot /usr/bin/certbot
#       echo "nginx configuretion:"
#       certbot --nginx    #  un commend if you need nginx service also un commend nginx config section too
        echo "v2ray setup..."
        wget --no-check-certificate https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
        bash install-release.sh
        sudo apt-get install uuid -y
        uuid=$(uuid -v 4)
        hex_number=$(openssl rand -hex 4)
        config_file="/usr/local/etc/v2ray/config.json"
        echo "{
          \"log\": {
            \"loglevel\": \"warning\",
            \"access\": \"/var/log/v2ray/access.log\",
            \"error\": \"/var/log/v2ray/error.log\"
          },
          \"inbounds\": [{
            \"port\": 10000,
            \"protocol\": \"vmess\",
            \"settings\": {
              \"clients\": [
                {
                  \"id\": \"$uuid\",
                  \"level\": 1,
                  \"alterId\": 4
                }
              ]
            },
            \"streamSettings\": {
              \"network\": \"ws\",
              \"wsSettings\": {
                \"path\": \"$hex_number\"
              }
            }
          }],
          \"outbounds\": [{
            \"protocol\": \"socks\",
            \"settings\": {
              \"servers\": [{
                \"address\": \"127.0.0.1\",
                \"port\": 9050,
                \"auth\": \"noauth\"
              }]
            }
          },{
            \"protocol\": \"blackhole\",
            \"settings\": {},
            \"tag\": \"blocked\"
          }],
          \"routing\": {
            \"rules\": [
              {
                \"type\": \"field\",
                \"ip\": [\"geoip:private\"],
                \"outboundTag\": \"blocked\"
              }
            ]
          }
        }" | sudo tee "$config_file" > /dev/null

        # nginx config     
#       cat <<EOL | sudo tee -a /etc/nginx/sites-available/default > /dev/null
#location /144c0889 {
#    proxy_redirect off;
#    proxy_pass http://127.0.0.1:10000;
#    proxy_http_version 1.1;
#    proxy_set_header Upgrade \$http_upgrade;
#    proxy_set_header Connection "upgrade";
#    proxy_set_header Host \$http_host;
#    # Show real IP if you enable V2Ray access log
#   proxy_set_header X-Real-IP \$remote_addr;
#    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#}
#EOL
        systemctl enable v2ray
        systemctl start v2ray

        echo "Installing openvpnserver..."
        echo "Your IP is ...."
        sudo apt-get install curl && sudo apt-get install wget
        curl ifconfig.me || wget -qO- ifconfig.me
        wget https://git.io/vpn -O openvpn-install.sh
        sudo chmod +x openvpn-install.sh
        echo "Please fill in data based on your need..."
        sudo bash openvpn-install.sh
        sudo systemctl start openvpn-server@server.service

        read -p "Do you want to create a new client for OpenVPN? (y/n): " answer_openvpn
        if [[ "$answer_openvpn" == "y" || "$answer_openvpn" == "Y" ]]; then
            sudo bash openvpn-install.sh
        else
            echo "OpenVPN installation completed."
        fi
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo "Installation completed."
```
# 🖥️manual_setup.sh:

For pepole who seek configurability and accessibility, our manual_setup.sh script allows you to customize your services. Simply run
./manual_setup.sh to take full control of the configuration process

manual setup:
```bash
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
```

# 🚀scripts:

We offer a suite of bash files to streamline service management. Use start.sh to initiate and enable services, stop.sh to halt services, status.sh to check service status, and optimize.sh to enhance performance. The optimization script updates packages, cleans cache, optimizes ports, and restarts services for an efficient system

# 💻services:

When initiating services using the provided bash file, the selection of services and methods determines their launch configuration. If opting for the setup file, V2Ray starts on port 10000 with the configuration file at /usr/local/etc/v2ray/config.json, while Nginx begins on port 443, using the configuration file at /etc/nginx/sites-available/default. Opting for OpenVPN defaults to port 1194, with the option to customize during setup. The protocol, either UDP or TCP, can also be specified, with the configuration file located at /etc/openvpn/server/server.conf. For manual setup, users have full control over configurations, but it's crucial to configure the firewall settings post-setup.



