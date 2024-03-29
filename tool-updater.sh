#!/usr/bin/env bash

# Variables
INSTALL=/opt/tools
mkdir $INSTALL

# Update entire system
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt -y full-upgrade && sudo apt -y autoremove

# Install go packages
GO111MODULE=on go get -u github.com/ffuf/ffuf
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx

# Remove go directory from tools to prevent overwrite conflict
rm -rf $INSTALL/go

# Move tools to install directory
mv ~/go $INSTALL
