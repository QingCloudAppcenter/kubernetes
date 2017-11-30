#!/usr/bin/env bash

docker pull fluent/fluent-bit:0.12.9
docker tag fluent/fluent-bit:0.12.9 dockerhub.qingcloud.com/fluent/fluent-bit:0.12.9
docker push dockerhub.qingcloud.com/fluent/fluent-bit:0.12.9
