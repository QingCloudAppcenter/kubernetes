#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "/data/kubernetes/env.sh"

echo "update git"
cd ${K8S_HOME}
git pull origin master

echo "stop service"
systemctl stop kubelet

${K8S_HOME}/image/update-confd.sh

${K8S_HOME}/image/update-bin.sh

${K8S_HOME}/image/update-cni.sh

${K8S_HOME}/image/update-logrotate.sh

${K8S_HOME}/image/pull-images.sh

if [ "${HOST_ROLE}" = "master" ]; then
    ${K8S_HOME}/script/update-manifests.sh
fi

systemctl start kubelet
