image:
	./scripts/build base
	./scripts/build build
	./scripts/build workstation

.PHONY: image

define build_image
$(1): Dockerfile.$(1)
	docker build \
		-f Dockerfile.$(1) \
		-t swedishembedded/$(1):latest .
.PHONY: $(1)
endef

$(eval $(call build_image,workstation))
