#!/usr/bin/env bash

cd /tmp
wget https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz
tar -zxvf app-agent-linux-amd64.tar.gz
cd app-agent-linux-amd64/
./install.sh

chmod +x /etc/init.d/confd

cd /tmp
rm -rf app-agent-linux-amd64/
rm app-agent-linux-amd64.tar.gz

echo "upgrade confd"
wget https://pek3a.qingstor.com/k8s-qingcloud/k8s/confd/v0.13.10/confd-linux-amd64.tar.gz
tar -O -zxf confd-linux-amd64.tar.gz >/opt/qingcloud/app-agent/bin/confd
chmod +x /opt/qingcloud/app-agent/bin/confd
rm confd-linux-amd64.tar.gz

systemctl enable confd
systemctl disable confd