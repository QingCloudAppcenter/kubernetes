#!/bin/bash

docker pull gcr.io/google_containers/kibana:v5.4.0
docker tag gcr.io/google_containers/kibana:v5.4.0 dockerhub.qingcloud.com/google_containers/kibana:v5.4.0
docker push dockerhub.qingcloud.com/google_containers/kibana:v5.4.0
