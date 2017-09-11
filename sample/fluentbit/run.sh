#!/usr/bin/env bash

docker run --network host -v /opt/kubernetes/sample/fluentbit/etc/:/fluent-bit/etc dockerhub.qingcloud.com/fluent/fluent-bit:0.12 /fluent-bit/bin/fluent-bit -c /fluent-bit/etc/fluent-bit.conf