#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

if [ -f "/data/kubernetes/addons/monitor/es-controller.yaml" ]
then
process_es_config
fi