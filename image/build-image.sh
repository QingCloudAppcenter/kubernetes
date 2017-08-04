#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

${K8S_HOME}/script/install-pkg.sh
${K8S_HOME}/script/install-qingcloud-agent.sh
${K8S_HOME}/script/update-sysconfig.sh
${K8S_HOME}/script/update-k8s-bin.sh