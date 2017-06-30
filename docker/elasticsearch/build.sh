#!/bin/bash
docker pull gcr.io/google_containers/elasticsearch:v2.4.1-2
docker tag gcr.io/google_containers/elasticsearch:v2.4.1-2 dockerhub.qingcloud.com/google_containers/elasticsearch:v2.4.1-2
docker push dockerhub.qingcloud.com/google_containers/elasticsearch:v2.4.1-2
