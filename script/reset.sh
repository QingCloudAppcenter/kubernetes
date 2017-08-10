#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

systemctl stop kubelet

echo "Unmounting directories in /data/var/lib/kubelet..."
cat /proc/mounts | awk '{print $2}' | grep '/data/var/lib/kubelet' | xargs umount

echo "clean config"
unlink /etc/kubernetes
rm ${NODE_INIT_LOCK}
rm -f /data/kubernetes/*.conf
rm -rf /data/kubernetes/addons
rm -rf /data/kubernetes/manifests
rm -rf /data/kubernetes/pki

echo "stop all container"
docker ps -a | grep 'k8s_' | awk '{print $1}' | xargs docker rm --force --volumes

rm -rf /data/etcd

rm -rf /data/var/lib/kubelet/*

echo "flush iptables"
iptables --flush -t nat
iptables --flush

rm -rf /etc/cni
systemctl restart confd
