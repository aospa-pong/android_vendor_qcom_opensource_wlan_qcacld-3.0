KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

# The Make variable $(M) must point to the directory that contains the module
# source code (which includes this Makefile). It can either be an absolute or a
# relative path. If it is a relative path, then it must be relative to the
# kernel source directory (KERNEL_SRC). An absolute path can be obtained very
# easily through $(shell pwd). Generating a path relative to KERNEL_SRC is
# difficult and we accept some outside help by letting the caller override the
# variable $(M). Allowing a relative path for $(M) enables us to have the build
# system put output/object files (.o, .ko.) into a directory different from the
# module source directory.
M ?= $(shell pwd)

ifeq ($(WLAN_ROOT),)
KBUILD_OPTIONS += \
    WLAN_ROOT=vendor/qcom/opensource/wlan/qcacld-3.0/.qca6490 \
    WLAN_COMMON_ROOT=cmn \
    WLAN_COMMON_INC=vendor/qcom/opensource/wlan/qcacld-3.0/cmn \
    WLAN_FW_API=vendor/qcom/opensource/wlan/fw-api \
    CONFIG_QCA_CLD_WLAN=m \
    CONFIG_CNSS_QCA6490=y \
    WLAN_PROFILE=qca6490 \
    DYNAMIC_SINGLE_CHIP=qca6490 \
    MODNAME=qca_cld3_qca6490 \
    DEVNAME=qca6490 \
    BOARD_PLATFORM=taro \
    WLAN_CTRL_NAME=wlan
endif

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 M=$(M) -C $(KERNEL_SRC) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean $(KBUILD_OPTIONS)
