#!/usr/bin/env bash

docker build -t dockerhub.qingcloud.com/qingcloud/elasticsearch-curator:5.1.1 .
docker push dockerhub.qingcloud.com/qingcloud/elasticsearch-curator:5.1.1