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

docker pull dockerhub.qingcloud.com/google_containers/pause-amd64:3.1
docker pull dockerhub.qingcloud.com/google_containers/etcd-amd64:3.1.10
docker pull dockerhub.qingcloud.com/google_containers/hyperkube-amd64:${HYPERKUBE_VERSION}
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-kube-dns-amd64:1.14.10
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-sidecar-amd64:1.14.10
docker pull dockerhub.qingcloud.com/google_containers/kube-addon-manager:v8.6
docker pull dockerhub.qingcloud.com/google_containers/kubernetes-dashboard-amd64:v1.8.3
docker pull dockerhub.qingcloud.com/fluent/fluent-bit:0.13.2
docker pull dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.5.3
docker pull dockerhub.qingcloud.com/google_containers/addon-resizer:1.8.1
docker pull dockerhub.qingcloud.com/google_containers/kibana:v5.6.4
docker pull dockerhub.qingcloud.com/google_containers/elasticsearch:v5.6.4
docker pull dockerhub.qingcloud.com/qingcloud/elasticsearch-curator:5.1.1
docker pull dockerhub.qingcloud.com/qingcloud/file-sync:0.7
docker pull dockerhub.qingcloud.com/qingcloud/qingcloud-volume-provisioner:v1.3.1
docker pull dockerhub.qingcloud.com/qingcloud/qingcloud-cloud-controller-manager:v1.1.2
docker pull dockerhub.qingcloud.com/qingcloud/hostnic-cni:v0.8.4
docker pull dockerhub.qingcloud.com/alpine:3.6
docker pull dockerhub.qingcloud.com/qingcloud/go-probe:v1.0
docker pull dockerhub.qingcloud.com/wordpress:4.8-apache
# istio
docker pull docker.io/istio/proxy_init:0.8.0
docker pull docker.io/istio/proxyv2:0.8.0
docker pull docker.io/istio/proxy:0.8.0
docker pull quay.io/coreos/hyperkube:v1.7.6_coreos.0
docker pull prom/statsd-exporter:latest
docker pull docker.io/istio/grafana:0.8.0
docker pull docker.io/istio/mixer:0.8.0
docker pull docker.io/istio/pilot:0.8.0
docker pull docker.io/istio/citadel:0.8.0
docker pull docker.io/istio/servicegraph:0.8.0
docker pull docker.io/istio/sidecar_injector:0.8.0
docker pull jaegertracing/all-in-one:1.5
docker pull dockerhub.qingcloud.com/qingcloud/prometheus:v2.0.0
docker pull dockerhub.qingcloud.com/kubernetes_helm/tiller:v2.9.1
docker pull dockerhub.qingcloud.com/coreos/flannel:v0.10.0-amd64

#openpitrix
docker pull busybox:1.28.4
docker pull openpitrix/openpitrix:v0.1.5
docker pull openpitrix/openpitrix:metadata-v0.1.5
docker pull openpitrix/openpitrix:flyway-v0.1.5
docker pull mysql:5.7.21
docker pull appcelerator/etcd:3.3.3

#kubesphere
docker pull dockerhub.qingcloud.com/kubesphere/ks-console:v0.1
docker pull kubesphere/account:latest
docker pull kubesphere/ks-apiserver:latest
docker pull kubesphere/kubectl:1.0