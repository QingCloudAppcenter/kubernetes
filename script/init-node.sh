#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir
systemctl start docker

#auto upgrade, just for test
#TODO remove for production
echo "update git"
cd ${K8S_HOME}
git pull origin master
${K8S_HOME}/image/update-confd.sh
${K8S_HOME}/image/update-bin.sh
${K8S_HOME}/image/pull-images.sh
