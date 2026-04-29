TI_WL12XX_COMPAT_VERSION = ol_R5.SP4.01
TI_WL12XX_COMPAT_SITE = https://github.com/TI-OpenLink/compat-wireless
TI_WL12XX_COMPAT_SITE_METHOD = git
TI_WL12XX_COMPAT_LICENSE = GPL-2.0
TI_WL12XX_COMPAT_DEPENDENCIES = linux ti-wl12xx-driver ti-compat

# TI_WL12XX_COMPAT_EXTRA_CFLAGS = -mlong-calls -mno-unaligned-access -fno-strict-aliasing
TI_WL12XX_COMPAT_EXTRA_CFLAGS = -mno-unaligned-access -fno-strict-aliasing

define TI_WL12XX_COMPAT_CONFIGURE_CMDS
	cd $(@D) && \
		GIT_TREE=$(BUILD_DIR)/ti-wl12xx-driver-$(TI_WL12XX_COMPAT_VERSION) \
		GIT_COMPAT_TREE=$(BUILD_DIR)/ti-compat-$(TI_WL12XX_COMPAT_VERSION) \
		./scripts/admin-refresh.sh
	cd $(@D) && ./scripts/driver-select wl12xx
endef

define TI_WL12XX_COMPAT_BUILD_CMDS
	$(MAKE) -C $(@D) \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		KLIB_BUILD=$(LINUX_DIR) \
		EXTRA_CFLAGS="$(TI_WL12XX_COMPAT_EXTRA_CFLAGS)" \
		KLIB=$(TARGET_DIR)
endef

define TI_WL12XX_COMPAT_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		KLIB_BUILD=$(LINUX_DIR) \
		KLIB=$(TARGET_DIR) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		EXTRA_CFLAGS="$(TI_WL12XX_COMPAT_EXTRA_CFLAGS)" \
		install-modules
endef

$(eval $(generic-package))