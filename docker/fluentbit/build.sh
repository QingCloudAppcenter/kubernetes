#!/usr/bin/env bash

docker pull fluent/fluent-bit:0.12.2
docker tag fluent/fluent-bit:0.12.2 dockerhub.qingcloud.com/fluent/fluent-bit:0.12.2
docker push dockerhub.qingcloud.com/fluent/fluent-bit:0.12.2
