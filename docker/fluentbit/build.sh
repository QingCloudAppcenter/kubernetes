#!/usr/bin/env bash

docker pull fluent/fluent-bit:0.12.14
docker tag fluent/fluent-bit:0.12.14 dockerhub.qingcloud.com/fluent/fluent-bit:0.12.14
docker push dockerhub.qingcloud.com/fluent/fluent-bit:0.12.14
