#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update istio bin"

cd /tmp
wget https://k8s-qingcloud.pek3a.qingstor.com/k8s/istio/0.8.0/istio-0.8.0-linux.tar.gz
tar -xvf istio-0.8.0-linux.tar.gz

cp istio-0.8.0/bin/istioctl /usr/bin
chmod +x /usr/bin/istioctl
cp -rf istio-0.8.0 /opt
rm istio-0.8.0

istioctl completion bash >/etc/profile.d/istioctl.sh
source /etc/profile