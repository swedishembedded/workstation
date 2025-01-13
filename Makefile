all: base build workstation
push: base/push build/push workstation/push

define define_image
$(1): Dockerfile.$(1)
	docker build \
		-f Dockerfile.$(1) \
		-t swedishembedded/$(1):latest .
$(1)/push:
	docker push swedishembedded/$(1):latest
.PHONY: $(1) $(1)/push
endef

$(eval $(call define_image,base))
$(eval $(call define_image,build))
$(eval $(call define_image,workstation))
