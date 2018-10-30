#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

apt install nfs-common -y
apt install ceph-common -y

add-apt-repository -y ppa:gluster/glusterfs-3.12
apt-get update
apt-get install glusterfs-client -y