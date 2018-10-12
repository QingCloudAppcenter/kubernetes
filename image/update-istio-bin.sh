#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update istio bin"

cd /tmp
wget https://k8s-qingcloud.pek3a.qingstor.com/k8s/istio/1.0.2/istio-1.0.2-linux.tar.gz
tar -xvf istio-1.0.2-linux.tar.gz

cp istio-1.0.2/bin/istioctl /usr/bin
chmod +x /usr/bin/istioctl
cp -rf istio-1.0.2 /opt
rm istio-1.0.2

#istioctl completion bash >/etc/profile.d/istioctl.sh
source /etc/profile
