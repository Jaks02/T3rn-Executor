#!/bin/bash

curl -s https://raw.githubusercontent.com/zamzasalim/logo/main/asc.sh | bash
sleep 5

read -p "Enter your PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
  echo "Error updating and upgrading packages. Exiting..."
  exit 1
fi

sudo apt install curl wget tar build-essential jq unzip -y
if [ $? -ne 0 ]; then
  echo "Error installing packages. Exiting..."
  exit 1
fi

sudo systemctl stop executor || true
sudo systemctl disable executor || true
sudo rm -f /etc/systemd/system/executor.service || true
sudo systemctl daemon-reload

if [ -d "executor" ]; then
  rm -rf executor
fi

LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | jq -r .tag_name)
if [ -z "$LATEST_VERSION" ]; then
  echo "Error fetching the latest version. Exiting..."
  exit 1
fi

EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/$LATEST_VERSION/executor-linux-$LATEST_VERSION.tar.gz"
EXECUTOR_FILE="executor-linux-$LATEST_VERSION.tar.gz"

curl -L -o $EXECUTOR_FILE $EXECUTOR_URL
if [ $? -ne 0 ]; then
    echo "Failed to download the Executor binary. Exiting..."
    exit 1
fi

tar -xzvf $EXECUTOR_FILE
rm -rf $EXECUTOR_FILE

sudo tee /etc/systemd/system/executor.service > /dev/null <<EOF
[Unit]
Description=Executor Service
After=network.target

[Service]
User=root
WorkingDirectory=$(pwd)/executor/executor
Environment="NODE_ENV=testnet"
Environment="LOG_LEVEL=debug"
Environment="LOG_PRETTY=false"
Environment="PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL"
Environment="ENABLED_NETWORKS=arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn"
ExecStart=$(pwd)/executor/executor/bin/executor
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
  echo "Error reloading systemd daemon. Exiting..."
  exit 1
fi

sudo systemctl enable executor
if [ $? -ne 0 ]; then
  echo "Error enabling executor service. Exiting..."
  exit 1
fi

sudo systemctl start executor
if [ $? -ne 0 ]; then
  echo "Error starting executor service. Exiting..."
  exit 1
fi

sudo systemctl status executor
