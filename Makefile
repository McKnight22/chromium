# This makefile is just used for internal developement.
# SHOULD NOT be submitted to upstream!!!

# some default values
BUILD ?= riscv64
CLANG ?= /aosp/common/wangchen/llvm-build/Release+Asserts
T ?= chrome_public_apk

# make clean [BUILD=<xxx>] [T=<xxx>]
# <xxx> e.g. 
# buildtools/third_party/libc++:libc++
# chrome_public_apk
.PHONY: clean
clean:
	@echo Start cleaning target: "$(T)"
	autoninja -C out/$(BUILD) -t clean $(T)
	@echo Done!

# make ninja [BUILD=<xxx>] [T=<xxx>] [V=1]
# build target and create log file
# To get more verbose log, add argument "V=1"
.PHONY: ninja
ninja:
	@echo Start building target: "$(T)"
	-cp ./log ./log.bak
ifeq ($(V),1)
	autoninja -d keeprsp -v -C out/$(BUILD) $(T) 2>&1 | tee ./log
else
	autoninja -d keeprsp -C out/$(BUILD) $(T) 2>&1 | tee ./log
endif
	@echo Done!

# make disclean [BUILD=<xxx>]
.PHONY: distclean
distclean:
	rm -rf out/$(BUILD)

# make gn [BUILD=<xxx>] [CLANG=<xxx>]
# FIXME:
# "clang_use_chrome_plugins=false" may not be required when we are using
# clang for Chrome built by ourselves.
.PHONY: gn
gn:
	gn gen out/$(BUILD) --args="\
	target_os=\"android\" \
	target_cpu=\"riscv64\" \
	skip_secondary_abi_for_cq=true \
	android_static_analysis=\"off\" \
	clang_base_path=\"$(CLANG)\" \
	clang_use_chrome_plugins=false \
	android64_ndk_api_level=29"
