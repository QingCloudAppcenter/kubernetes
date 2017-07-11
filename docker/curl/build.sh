#!/usr/bin/env bash

docker build -t dockerhub.qingcloud.com/qingcloud/curl:edge .
docker push dockerhub.qingcloud.com/qingcloud/curl:edge