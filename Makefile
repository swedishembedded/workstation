all: base build workstation
push: base/push build/push workstation/push

define define_image
$(1): Dockerfile.$(1) $(2)
	docker build \
		-f Dockerfile.$(1) \
		-t swedishembedded/$(1):latest .
$(1)/push:
	docker push swedishembedded/$(1):latest
.PHONY: $(1) $(1)/push
endef

$(eval $(call define_image,boot))
$(eval $(call define_image,dev,boot))
$(eval $(call define_image,rust,dev))
$(eval $(call define_image,zephyr,rust))
$(eval $(call define_image,workstation,zephyr))

bootstrap: 
