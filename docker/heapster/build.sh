#!/bin/bash
docker pull gcr.io/google_containers/heapster-amd64:v1.4.3
docker tag gcr.io/google_containers/heapster-amd64:v1.4.3 dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.4.3
docker push dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.4.3


docker pull gcr.io/google_containers/addon-resizer:1.7
docker tag gcr.io/google_containers/addon-resizer:1.7 dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
docker push dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
