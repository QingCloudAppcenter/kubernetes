#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
apt-get install -y wget jq
wget http://k8s-qingcloud.pek3a.qingstor.com/k8s/release/bin/linux/amd64/kubectl -O /usr/bin/kubectl
wget http://k8s-qingcloud.pek3a.qingstor.com/k8s/release/bin/linux/amd64/kubeadm -O /usr/bin/kubeadm

chmod +x /usr/bin/kubectl
chmod +x /usr/bin/kubeadm



pushd /tmp
wget https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz
tar -zxvf app-agent-linux-amd64.tar.gz
cd app-agent-linux-amd64/
./install.sh
cd ..
rm -rf app-agent-linux-amd64/
rm app-agent-linux-amd64.tar.gz
popd

cp -r confd/* /etc/confd/
cp script/* /usr/bin/
chmod +x /usr/bin/*.sh

cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
EOF

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config