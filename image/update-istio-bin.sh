#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update istio bin"

cd /tmp
wget https://k8s-qingcloud.pek3a.qingstor.com/k8s/istio/0.7.1/istioctl
cp istioctl /usr/bin
chmod +x /usr/bin/istioctl
rm istioctl

istioctl completion bash >/etc/profile.d/istioctl.sh
source /etc/profile