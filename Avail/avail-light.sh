#!/bin/bash

echo -e "\033[0;35m"
echo " __      _______ _   _ _   _  ____  _____  ______  _____  ";
echo " \ \    / /_   _| \ | | \ | |/ __ \|  __ \|  ____|/ ____| ";
echo "  \ \  / /  | | |  \| |  \| | |  | | |  | | |__  | (___   ";
echo "   \ \/ /   | | |     |     | |  | | |  | |  __|  \___ \  ";
echo "    \  /   _| |_| |\  | |\  | |__| | |__| | |____ ____) | ";
echo "     \/   |_____|_| \_|_| \_|\____/|_____/|______|_____/    ";
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install make clang pkg-config libssl-dev build-essential

# download binary
echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
mkdir -p ${HOME}/avail-light
cd avail-light
wget https://github.com/availproject/avail-light/releases/download/v1.7.5/avail-light-linux-amd64.tar.gz
tar -xvzf avail-light-linux-amd64.tar.gz
cp avail-light-linux-amd64 avail-light

# create service
sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit] 
Description=Avail Light Client
After=network.target
StartLimitIntervalSec=0
[Service] 
User=root 
ExecStart=/root/avail-light/avail-light --network goldberg
Restart=always 
RestartSec=120
[Install] 
WantedBy=multi-user.target

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# start service
sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl restart availightd

echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running service:: journalctl -f -u availightd.service'
echo -e "Check the node is running: sudo systemctl status availightd.service"
echo -e "Stop your avail node: sudo systemctl stop availightd.service"
echo -e "Start your avail node: sudo systemctl start availightd.service"
