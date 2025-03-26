all: boot dev rust zephyr workstation
push: boot/push dev/push rust/push zephyr/push workstation/push
nocache: boot/nocache dev/nocache rust/nocache zephyr/nocache workstation/nocache

define define_image
$(1): Dockerfile.$(1) $(2)
	docker build \
		-f Dockerfile.$(1) \
		-t swedishembedded/$(1):latest .

$(1)/nocache: Dockerfile.$(1) $(2)
	docker build --no-cache \
		-f Dockerfile.$(1) \
		-t swedishembedded/$(1):latest .

$(1)/push:
	docker push swedishembedded/$(1):latest

.PHONY: $(1) $(1)/push $(1)/nocache
endef

$(eval $(call define_image,boot))
$(eval $(call define_image,dev,boot))
$(eval $(call define_image,rust,dev))
$(eval $(call define_image,zephyr,rust))
$(eval $(call define_image,workstation,zephyr))

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all        - Build all images"
	@echo "  push       - Push all images to Docker Hub"
	@echo "  nocache    - Build all images without using cache"
	@echo "  boot       - Build boot image"
	@echo "  dev        - Build dev image"
	@echo "  rust       - Build rust image"
	@echo "  zephyr     - Build zephyr image"
	@echo "  workstation - Build workstation image"
	@echo ""
	@echo "  <image>/nocache - Build specific image without using cache"
	@echo "  <image>/push   - Push specific image to Docker Hub"
	@echo ""
	@echo "Examples:"
	@echo "  make boot             - Build boot image"
	@echo "  make boot/nocache     - Build boot image without using cache"
	@echo "  make nocache          - Build all images without using cache"

bootstrap: 
