#!/usr/bin/env bash

apt-get install -y git

cd /tmp
wget https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz
tar -zxvf app-agent-linux-amd64.tar.gz
cd app-agent-linux-amd64/
./install.sh

cd /tmp
rm -rf app-agent-linux-amd64/
rm app-agent-linux-amd64.tar.gz
