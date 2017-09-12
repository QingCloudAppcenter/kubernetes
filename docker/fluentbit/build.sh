#!/usr/bin/env bash

docker pull fluent/fluent-bit:0.12
docker tag fluent/fluent-bit:0.12 dockerhub.qingcloud.com/fluent/fluent-bit:0.12
docker push dockerhub.qingcloud.com/fluent/fluent-bit:0.12