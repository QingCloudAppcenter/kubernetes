#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

cordon_all
clean_pod

systemctl stop kubelet
docker_stop_rm_all
systemctl stop docker
flush_iptables
