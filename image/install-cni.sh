#!/usr/bin/env bash

pushd /tmp
wget -c https://pek3a.qingstor.com/jolestar/k8s/tools/cni-amd64-v0.5.0.tgz 
mkdir -p /opt/cni/bin
tar -zxvf cni-amd64-v0.5.0.tgz -C /opt/cni/bin
rm cni-amd64-v0.5.0.tgz 
popd

cd /opt/cni/bin
wget -c https://github.com/yunify/hostnic-cni/releases/download/v0.3/hostnic.tar.gz
tar -zxvf hostnic.tar.gz
rm hostnic.tar.gz

