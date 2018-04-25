#!/bin/bash
docker pull gcr.io/google_containers/heapster-amd64:v1.5.1
docker tag gcr.io/google_containers/heapster-amd64:v1.5.1 dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.5.1
docker push dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.4.3


docker pull gcr.io/google_containers/addon-resizer:1.7
docker tag gcr.io/google_containers/addon-resizer:1.7 dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
docker push dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
