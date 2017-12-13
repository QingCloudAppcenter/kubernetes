#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update images"

cat << EOF > /etc/docker/daemon.json
{
    "storage-driver": "overlay2"
}
EOF

systemctl restart docker

docker login -u guest -p guest dockerhub.qingcloud.com

docker pull dockerhub.qingcloud.com/google_containers/pause-amd64:3.0
docker pull dockerhub.qingcloud.com/google_containers/etcd-amd64:3.0.17
docker pull dockerhub.qingcloud.com/google_containers/hyperkube-amd64:${HYPERKUBE_VERSION}
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-kube-dns-amd64:1.14.5
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-sidecar-amd64:1.14.5
docker pull dockerhub.qingcloud.com/google_containers/kube-addon-manager:v6.4-beta.2
#docker pull dockerhub.qingcloud.com/coreos/flannel:v0.7.0-amd64
docker pull dockerhub.qingcloud.com/google_containers/kubernetes-dashboard-amd64:v1.6.3
docker pull dockerhub.qingcloud.com/fluent/fluent-bit:0.12.2
docker pull dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.4.3
docker pull dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
docker pull dockerhub.qingcloud.com/google_containers/kibana:v5.4.0
docker pull dockerhub.qingcloud.com/google_containers/elasticsearch:v5.5.1-1
docker pull dockerhub.qingcloud.com/qingcloud/elasticsearch-curator:5.1.1
docker pull dockerhub.qingcloud.com/qingcloud/file-sync:0.7
docker pull dockerhub.qingcloud.com/busybox:1.27.1
docker pull dockerhub.qingcloud.com/qingcloud/qingcloud-volume-provisioner:v1.0
docker pull dockerhub.qingcloud.com/qingcloud/qingcloud-cloud-controller-manager:v1.0
docker pull dockerhub.qingcloud.com/qingcloud/hostnic-cni:v0.8.4
docker pull dockerhub.qingcloud.com/alpine:3.6
# istio
docker pull dockerhub.qingcloud.com/istio/istio-ca:0.3.0
docker pull dockerhub.qingcloud.com/istio/pilot:0.3.0
docker pull dockerhub.qingcloud.com/istio/proxy_debug:0.3.0
docker pull dockerhub.qingcloud.com/istio/mixer:0.3.0
docker pull dockerhub.qingcloud.com/istio/statsd-exporter
