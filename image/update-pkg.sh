#!/usr/bin/env bash

apt-get update

apt-get install -y ebtables socat jq apt-transport-https bash-completion ntp wget ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get -y install docker-ce

apt-get remove -y network-manager

DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

modprobe ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack_ipv4

# crictl
pushd /tmp
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.12.0/crictl-v1.12.0-linux-amd64.tar.gz
tar xvzf crictl-v1.12.0-linux-amd64.tar.gz
mv crictl /usr/local/bin/
popd