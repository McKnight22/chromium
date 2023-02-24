# This makefile is just used for internal developement.
# SHOULD NOT be submitted to upstream!!!

# make clean T=<xxx>
# <xxx> e.g. 
# buildtools/third_party/libc++:libc++
# chrome_public_apk
clean:
	@echo Start cleaning target: "$(T)"
	autoninja -v -C out/riscv64 -t clean $(T)
	@echo Done!

# make ninja T=<xxx>
# build target and create log file
ninja:
	@echo Start building target: "$(T)"
	-cp ./log ./log.bak
	autoninja -v -C out/riscv64 $(T) 2>&1 | tee ./log
	@echo Done!

distclean:
	rm -rf out/riscv64

gn:
	gn gen out/riscv64 --args="\
	target_os=\"android\" \
	target_cpu=\"riscv64\" \
	skip_secondary_abi_for_cq=true \
	android_static_analysis=\"off\" \
	clang_use_chrome_plugins=false \
	clang_base_path=\"/aosp/common/wangchen/llvm-build/Release+Asserts\" \
	clang_use_chrome_plugins=false \
	default_min_sdk_version=10000"

