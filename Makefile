# This makefile is just used for internal developement.
# SHOULD NOT be submitted to upstream!!!

# some default values
ARCH ?= riscv64
CLANG ?= /aosp/common/wangchen/llvm-build/Release+Asserts
T ?= chrome_public_apk

# make clean [ARCH=<xxx>] [T=<xxx>]
# Value of ARCH:
# - riscv64
# - arm64
# - ...
# Value of T:
# e.g.
# - buildtools/third_party/libc++:libc++
# - chrome_public_apk
# - trichrome_webview_apk
.PHONY: clean
clean:
	@echo Start cleaning target: "$(T)"
	autoninja -C out/$(ARCH) -t clean $(T)
	@echo Done!

# make ninja [ARCH=<xxx>] [T=<xxx>] [V=1]
# build target and create log file
# To get more verbose log, add argument "V=1"
.PHONY: ninja
ninja:
	@echo Start building target: "$(T)"
	-cp ./log ./log.bak
ifeq ($(V),1)
	autoninja -d keeprsp -v -C out/$(ARCH) $(T) 2>&1 | tee ./log
else
	autoninja -d keeprsp -C out/$(ARCH) $(T) 2>&1 | tee ./log
endif
	@echo Done!

# make disclean [ARCH=<xxx>]
.PHONY: distclean
distclean:
	rm -rf out/$(ARCH)

# make gn [ARCH=<xxx>] [CLANG=<xxx>]
.PHONY: gn
gn:
	gn gen out/$(ARCH) --args="\
	target_os=\"android\" \
	target_cpu=\"$(ARCH)\" \
	skip_secondary_abi_for_cq=true \
	android_static_analysis=\"off\" \
	clang_base_path=\"$(CLANG)\" \
	android64_ndk_api_level=29"
