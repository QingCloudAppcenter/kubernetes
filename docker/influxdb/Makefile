# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build the influxdb image for amd64, arm, arm64, ppc64le and s390x
#
# Usage:
# 	[PREFIX=gcr.io/google_containers] [ARCH=amd64] make (build|push)

all: build

VERSION?=v1.3.0
PREFIX?=dockerhub.qingcloud.com/google_containers
ARCH?=amd64


build:
	# Copy the whole directory to a temporary dir and set the base image

	docker build --pull -t $(PREFIX)/heapster-influxdb-$(ARCH):$(VERSION) .

# Should depend on target: ./manifest-tool
push: gcr-login $(addprefix sub-push-,$(ALL_ARCHITECTURES))
#	./manifest-tool push from-args --platforms $(ML_PLATFORMS) --template $(PREFIX)/heapster-influxdb-ARCH:$(VERSION) --target $(PREFIX)/heapster-influxdb:$(VERSION)

sub-push-%:
	$(MAKE) ARCH=$* PREFIX=$(PREFIX) VERSION=$(VERSION) build
	docker push $(PREFIX)/heapster-influxdb-$(ARCH):$(VERSION)

gcr-login:
ifeq ($(findstring gcr.io,$(PREFIX)),gcr.io)
	@echo "If you are pushing to a gcr.io registry, you have to be logged in via 'docker login'; 'gcloud docker push' can't push manifest lists yet."
	@echo "This script is automatically logging you in now."
	gcloud docker -a
endif

# TODO(luxas): As soon as it's working to push fat manifests to gcr.io, reenable this code
#./manifest-tool:
#	curl -sSL https://github.com/luxas/manifest-tool/releases/download/v0.3.0/manifest-tool > manifest-tool
#	chmod +x manifest-tool
