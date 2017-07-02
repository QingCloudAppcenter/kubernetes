#!/bin/bash

docker pull gcr.io/google_containers/kibana:v4.6.1-1
docker tag gcr.io/google_containers/kibana:v4.6.1-1 dockerhub.qingcloud.com/google_containers/kibana:v4.6.1-1
docker push dockerhub.qingcloud.com/google_containers/kibana:v4.6.1-1
