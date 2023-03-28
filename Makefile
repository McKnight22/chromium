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
# FIXME(riscv64-android):
# Before riscv64 introduced into Chromium, every 64-bit ARCH enables its own 32-bit support by default.
# But for RISCV, Android announced only pure 64-bit would be supported.
# So for riscv64, to skip the legacy check logic for its 32-bit ABI, skip_secondary_abi_for_cq is enabled by default.
# Meanwhile, android_static_analysis="off" is mandatory to guarantee disable_android_lint is true to pass gn build.
# For detailed analysis, please refer to https://github.com/aosp-riscv/chromium/issues/5#issuecomment-1486249579.
.PHONY: gn
gn:
	gn gen out/$(ARCH) --args="\
	target_os=\"android\" \
	target_cpu=\"$(ARCH)\" \
	android_static_analysis=\"off\" \
	clang_base_path=\"$(CLANG)\" \
	android64_ndk_api_level=29"
