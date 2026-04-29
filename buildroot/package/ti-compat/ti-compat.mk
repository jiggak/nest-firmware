TI_COMPAT_VERSION = ol_R5.SP4.01
TI_COMPAT_SITE = https://github.com/TI-OpenLink/compat
TI_COMPAT_SITE_METHOD = git
TI_COMPAT_LICENSE = GPL-2.0

define TI_COMPAT_BUILD_CMDS
	@true
endef

define TI_COMPAT_INSTALL_TARGET_CMDS
	@true
endef

$(eval $(generic-package))