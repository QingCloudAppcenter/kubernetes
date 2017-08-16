#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

set -o errexit
set -o nounset
set -o pipefail

source ${K8S_HOME}/image/update-pkg.sh
source ${K8S_HOME}/image/update-qingcloud-agent.sh
source ${K8S_HOME}/image/update-confd.sh
source ${K8S_HOME}/image/update-sysconfig.sh
source ${K8S_HOME}/image/update-sshd-config.sh
source ${K8S_HOME}/image/update-k8s-bin.sh
source ${K8S_HOME}/image/update-cni.sh
source ${K8S_HOME}/image/update-logrotate.sh
source ${K8S_HOME}/image/update-systemd-conf.sh
source ${K8S_HOME}/image/pull-docker-images.sh