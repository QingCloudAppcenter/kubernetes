#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

set -o errexit
set -o nounset
set -o pipefail

${K8S_HOME}/image/update-pkg.sh
${K8S_HOME}/image/update-qingcloud-agent.sh
${K8S_HOME}/image/update-confd.sh
${K8S_HOME}/image/update-sysconfig.sh
${K8S_HOME}/image/update-sshd-config.sh
${K8S_HOME}/image/update-k8s-bin.sh
${K8S_HOME}/image/update-cni.sh
${K8S_HOME}/image/update-calico.sh
${K8S_HOME}/image/update-logrotate.sh
${K8S_HOME}/image/update-systemd-conf.sh
${K8S_HOME}/image/update-docker-images.sh
${K8S_HOME}/image/update-istio-bin.sh
${K8S_HOME}/image/update-helm-bin.sh
${K8S_HOME}/image/update-storage-clients.sh
${K8S_HOME}/image/update-openpitrix.sh
${K8S_HOME}/image/update-kubesphere.sh
