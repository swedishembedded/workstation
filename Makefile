# ==============================================================================
# Swedish Embedded Workstation - Build System
# ==============================================================================
# Build individual images:
#   make boot          - Build boot image
#   make dev           - Build dev image
#   make rust          - Build rust image
#   make zephyr        - Build zephyr image
#   make workstation   - Build workstation image
#
# Build all images sequentially:
#   make all
#
# Build all images in parallel (requires BuildKit):
#   make bake
#
# Build without cache:
#   make boot/nocache
#   make nocache       - Build all without cache
#
# Push images:
#   make boot/push
#   make push          - Push all images
# ==============================================================================

.PHONY: all push nocache bake help

# ==============================================================================
# Configuration
# ==============================================================================
DOCKER       ?= docker
DOCKERFILE   := Dockerfile
BAKE_FILE    := docker-bake.hcl
IMG_NS       ?= swedishembedded
PLATFORMS    ?= linux/amd64
VERSION      := $(shell cat VERSION | tr -d '\n' | tr -d ' ')

# All image targets
TARGETS := boot dev rust zephyr workstation

# Ubuntu versions
UBUNTU_VERSIONS := 22 24 25

# ==============================================================================
# Default Targets
# ==============================================================================
all: $(TARGETS)

push: $(addsuffix /push,$(TARGETS))

nocache: $(addsuffix /nocache,$(TARGETS))

# ==============================================================================
# Parallel Build with BuildKit
# ==============================================================================
bake:
	@echo "Building all images in parallel with BuildKit..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS)

bake/load:
	@echo "Building and loading all images in parallel with BuildKit..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--load

bake/push:
	@echo "Building and pushing all images in parallel with BuildKit..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--push

# ==============================================================================
# Ubuntu Version-Specific Builds
# ==============================================================================
bake/ubuntu22:
	@echo "Building all Ubuntu 22.04 images with version $(VERSION)+ubuntu22.04..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--set=*.args.VERSION=$(VERSION) \
		ubuntu22

bake/ubuntu24:
	@echo "Building all Ubuntu 24.04 images with version $(VERSION)+ubuntu24.04..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--set=*.args.VERSION=$(VERSION) \
		ubuntu24

bake/ubuntu25:
	@echo "Building all Ubuntu 25.04 images with version $(VERSION)+ubuntu25.04..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--set=*.args.VERSION=$(VERSION) \
		ubuntu25

bake/all-ubuntu:
	@echo "Building all images for all Ubuntu versions..."
	@echo "  Ubuntu 22.04: $(VERSION)+ubuntu22.04"
	@echo "  Ubuntu 24.04: $(VERSION)+ubuntu24.04"
	@echo "  Ubuntu 25.04: $(VERSION)+ubuntu25.04"
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		all-ubuntu

bake/ubuntu22/push:
	@echo "Building and pushing all Ubuntu 22.04 images..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--push \
		ubuntu22

bake/ubuntu24/push:
	@echo "Building and pushing all Ubuntu 24.04 images..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--push \
		ubuntu24

bake/ubuntu25/push:
	@echo "Building and pushing all Ubuntu 25.04 images..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--push \
		ubuntu25

bake/all-ubuntu/push:
	@echo "Building and pushing all images for all Ubuntu versions..."
	$(DOCKER) buildx bake \
		--file $(BAKE_FILE) \
		--set=*.platform=$(PLATFORMS) \
		--push \
		all-ubuntu

# ==============================================================================
# Individual Image Targets
# ==============================================================================
define build_target
$(1): $(DOCKERFILE)
	@echo "Building $(1) image..."
	$(DOCKER) build \
		--target $(1) \
		-f $(DOCKERFILE) \
		-t $(IMG_NS)/$(1):latest \
		.

$(1)/nocache: $(DOCKERFILE)
	@echo "Building $(1) image without cache..."
	$(DOCKER) build \
		--no-cache \
		--target $(1) \
		-f $(DOCKERFILE) \
		-t $(IMG_NS)/$(1):latest \
		.

$(1)/push:
	@echo "Pushing $(1) image..."
	$(DOCKER) push $(IMG_NS)/$(1):latest

$(1)/pull:
	@echo "Pulling $(1) image..."
	$(DOCKER) pull $(IMG_NS)/$(1):latest

.PHONY: $(1) $(1)/nocache $(1)/push $(1)/pull
endef

# Generate targets for each image
$(foreach t,$(TARGETS),$(eval $(call build_target,$(t))))

# ==============================================================================
# Multi-platform Targets
# ==============================================================================
buildx/%:
	@echo "Building $* for multiple platforms..."
	$(DOCKER) buildx build \
		--platform $(PLATFORMS) \
		--target $* \
		-f $(DOCKERFILE) \
		-t $(IMG_NS)/$*:latest \
		.

buildx/%/push:
	@echo "Building and pushing $* for multiple platforms..."
	$(DOCKER) buildx build \
		--platform $(PLATFORMS) \
		--target $* \
		-f $(DOCKERFILE) \
		-t $(IMG_NS)/$*:latest \
		--push \
		.

# ==============================================================================
# Utility Targets
# ==============================================================================
version:
	@echo "Current version: $(VERSION)"
	@echo "Ubuntu 22.04: $(VERSION)+ubuntu22.04"
	@echo "Ubuntu 24.04: $(VERSION)+ubuntu24.04"
	@echo "Ubuntu 25.04: $(VERSION)+ubuntu25.04"

clean:
	@echo "Cleaning up Docker build cache..."
	$(DOCKER) builder prune -f

clean/all:
	@echo "Cleaning up all Docker build cache (including dangling images)..."
	$(DOCKER) builder prune -af

inspect/%:
	@echo "Inspecting $* image..."
	$(DOCKER) image inspect $(IMG_NS)/$*:latest

shell/%:
	@echo "Starting interactive shell in $* image..."
	$(DOCKER) run --rm -it $(IMG_NS)/$*:latest /bin/bash

# Ubuntu version-specific inspect/shell
inspect/%/ubuntu22:
	@echo "Inspecting $* Ubuntu 22.04 image..."
	$(DOCKER) image inspect $(IMG_NS)/$*:ubuntu22.04

inspect/%/ubuntu24:
	@echo "Inspecting $* Ubuntu 24.04 image..."
	$(DOCKER) image inspect $(IMG_NS)/$*:ubuntu24.04

inspect/%/ubuntu25:
	@echo "Inspecting $* Ubuntu 25.04 image..."
	$(DOCKER) image inspect $(IMG_NS)/$*:ubuntu25.04

shell/%/ubuntu22:
	@echo "Starting interactive shell in $* Ubuntu 22.04 image..."
	$(DOCKER) run --rm -it $(IMG_NS)/$*:ubuntu22.04 /bin/bash

shell/%/ubuntu24:
	@echo "Starting interactive shell in $* Ubuntu 24.04 image..."
	$(DOCKER) run --rm -it $(IMG_NS)/$*:ubuntu24.04 /bin/bash

shell/%/ubuntu25:
	@echo "Starting interactive shell in $* Ubuntu 25.04 image..."
	$(DOCKER) run --rm -it $(IMG_NS)/$*:ubuntu25.04 /bin/bash

# ==============================================================================
# Help
# ==============================================================================
help:
	@echo "Swedish Embedded Workstation - Build System"
	@echo ""
	@echo "Current version: $(VERSION)"
	@echo ""
	@echo "Available targets:"
	@echo "  all                    - Build all images sequentially"
	@echo "  bake                   - Build all images in parallel (BuildKit)"
	@echo "  bake/load              - Build and load all images in parallel"
	@echo "  bake/push              - Build and push all images in parallel"
	@echo "  push                   - Push all images to registry"
	@echo "  nocache                - Build all images without cache"
	@echo ""
	@echo "Ubuntu version-specific builds:"
	@echo "  bake/ubuntu22          - Build all Ubuntu 22.04 images ($(VERSION)+ubuntu22.04)"
	@echo "  bake/ubuntu24          - Build all Ubuntu 24.04 images ($(VERSION)+ubuntu24.04)"
	@echo "  bake/ubuntu25          - Build all Ubuntu 25.04 images ($(VERSION)+ubuntu25.04)"
	@echo "  bake/all-ubuntu        - Build for all Ubuntu versions in parallel"
	@echo "  bake/ubuntu22/push     - Build and push Ubuntu 22.04 images"
	@echo "  bake/ubuntu24/push     - Build and push Ubuntu 24.04 images"
	@echo "  bake/ubuntu25/push     - Build and push Ubuntu 25.04 images"
	@echo "  bake/all-ubuntu/push   - Build and push all Ubuntu versions"
	@echo ""
	@echo "Individual image targets:"
	@echo "  boot                   - Build boot image"
	@echo "  dev                    - Build dev image"
	@echo "  rust                   - Build rust image"
	@echo "  zephyr                 - Build zephyr image"
	@echo "  workstation            - Build workstation image"
	@echo ""
	@echo "Per-image targets:"
	@echo "  <image>/nocache        - Build image without cache"
	@echo "  <image>/push           - Push image to registry"
	@echo "  <image>/pull           - Pull image from registry"
	@echo ""
	@echo "Multi-platform targets:"
	@echo "  buildx/<image>         - Build image for multiple platforms"
	@echo "  buildx/<image>/push    - Build and push for multiple platforms"
	@echo ""
	@echo "Utility targets:"
	@echo "  version                - Show current version"
	@echo "  clean                  - Clean Docker build cache"
	@echo "  clean/all              - Clean all Docker build cache"
	@echo "  inspect/<image>        - Inspect image metadata"
	@echo "  shell/<image>          - Start interactive shell in image"
	@echo "  inspect/<image>/ubuntu22 - Inspect Ubuntu 22.04 image"
	@echo "  shell/<image>/ubuntu22   - Shell in Ubuntu 22.04 image"
	@echo ""
	@echo "Configuration:"
	@echo "  DOCKER                 - Docker command (default: docker)"
	@echo "  IMG_NS                 - Image namespace (default: swedishembedded)"
	@echo "  PLATFORMS              - Target platforms (default: linux/amd64)"
	@echo "  VERSION                - Version from VERSION file (current: $(VERSION))"
	@echo ""
	@echo "Examples:"
	@echo "  make boot                              - Build boot image"
	@echo "  make bake                              - Build all images in parallel"
	@echo "  make bake/all-ubuntu                   - Build all Ubuntu versions"
	@echo "  make bake/ubuntu22/push                - Build and push Ubuntu 22.04"
	@echo "  make bake/ubuntu24/push                - Build and push Ubuntu 24.04"
	@echo "  make PLATFORMS=linux/amd64,linux/arm64 bake/all-ubuntu/push"
	@echo "  make shell/workstation/ubuntu22        - Shell in Ubuntu 22.04 workstation"

bootstrap:
	@echo "Bootstrap target is deprecated. Use 'make bake' instead."
