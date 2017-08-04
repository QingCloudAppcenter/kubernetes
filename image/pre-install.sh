#!/usr/bin/env bash

apt-get install -y git wget
git clone https://github.com/QingCloudAppcenter/kubernetes.git /opt/kubernetes
cd /opt/kubernetes/image

./build-image.sh

