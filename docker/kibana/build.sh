#!/bin/bash

docker pull docker.elastic.co/kibana/kibana:5.5.1
docker tag docker.elastic.co/kibana/kibana:5.5.1 dockerhub.qingcloud.com/elastic/kibana:5.5.1
docker push dockerhub.qingcloud.com/elastic/kibana:5.5.1

