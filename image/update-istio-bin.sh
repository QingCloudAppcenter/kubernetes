#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update istio bin"

cd /tmp
wget https://k8s-qingcloud.pek3a.qingstor.com/k8s/istio/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz
tar -xvf istio-${ISTIO_VERSION}-linux.tar.gz

cp istio-${ISTIO_VERSION}/bin/istioctl /usr/bin
chmod +x /usr/bin/istioctl
cp -rf istio-${ISTIO_VERSION} /opt
rm istio-${ISTIO_VERSION}

#istioctl completion bash >/etc/profile.d/istioctl.sh
source /etc/profile
