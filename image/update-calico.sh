#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

CALICO_VERSION=
CALICO_CNI_PLUGIN_VERSION=v3.1.3
CALICOCTL_VERSION=v3.1.3

mkdir -p /opt/cni/bin

wget -N -P /usr/local/bin/ https://github.com/projectcalico/calicoctl/releases/download/${CALICOCTL_VERSION}/calicoctl
chmod +x /usr/local/bin/calicoctl

wget -N -P /opt/cni/bin https://github.com/projectcalico/cni-plugin/releases/download/${CALICO_CNI_PLUGIN_VERSION}/calico
wget -N -P /opt/cni/bin https://github.com/projectcalico/cni-plugin/releases/download/${CALICO_CNI_PLUGIN_VERSION}/calico-ipam
chmod +x /opt/cni/bin/calico /opt/cni/bin/calico-ipam



