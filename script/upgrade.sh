#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

if [ $ENV_ENABLE_HOSTNIC == "false" ]; then
    cp -r /data/kubernetes/addons/hostnic  /tmp/hostnic/
    rm -r /data/kubernetes/addons/hostnic/*
    mykubectl delete -f /tmp/hostnic/qingcloud-hostnic-cni.yaml
    mykubectl delete -f /tmp/hostnic/qingcloud-hostnic-sa.yaml
fi

${K8S_HOME}/script/reload-env.sh
