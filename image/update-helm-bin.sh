#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update helm bin"

cd /tmp
wget https://k8s-qingcloud.pek3a.qingstor.com/k8s/helm/v2.9.1/helm-v2.9.1-linux-amd64.tar.gz
tar xzvf helm-v2.9.1-linux-amd64.tar.gz

cp linux-amd64/helm /usr/bin
chmod +x /usr/bin/helm
rm -rf linux-amd64

helm completion bash >/etc/profile.d/helm.sh
source /etc/profile