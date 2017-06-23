#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

echo "update confd"
rm -rf /etc/confd/conf.d/k8s
rm -rf /etc/confd/templates/k8s
mkdir -p /etc/confd
cp -r ${K8S_HOME}/confd/* /etc/confd/

systemctl restart confd
