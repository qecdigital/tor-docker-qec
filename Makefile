PROJECT_NAME ?= tor-docker-qec
VERSION ?= $(strip $(shell cat VERSION))
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))
DOCKER_IMAGE ?= ebissbort/tor-docker-qec
DOCKER_TAG ?= beta-latest
GIT_HASH ?= $(shell git log --format="%h" -n 1)

# Build Docker image
build: docker_build docker_tag output

# Build and push Docker image
release: docker_tag docker_push output

default: build

docker_build:
	@docker build \
		--compress \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		--build-arg VERSION=$(VERSION) \
		--tag $(DOCKER_IMAGE):$(VERSION) .

buildx:
	# TODO: Copy logic from docker file

docker_tag:
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):$(DOCKER_TAG)

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):$(VERSION)

run:
	@echo 'Starting container $(DOCKER_IMAGE):$(DOCKER_TAG)'
	@docker run --net=host -i $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: release output run docker_build docker_push default build buildx
