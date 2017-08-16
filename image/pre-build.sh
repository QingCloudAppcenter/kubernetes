#!/usr/bin/env bash

apt-get install -y git
git clone https://github.com/QingCloudAppcenter/kubernetes.git /opt/kubernetes
cd /opt/kubernetes/image

build.sh

