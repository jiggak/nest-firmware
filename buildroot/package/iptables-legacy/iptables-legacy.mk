################################################################################
#
# iptables
#
################################################################################

IPTABLES_LEGACY_VERSION = 1.4.21
IPTABLES_LEGACY_SOURCE = iptables-$(IPTABLES_LEGACY_VERSION).tar.bz2
IPTABLES_LEGACY_SITE = http://ftp.netfilter.org/pub/iptables
IPTABLES_LEGACY_INSTALL_STAGING = YES
IPTABLES_LEGACY_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),libnetfilter_conntrack)
IPTABLES_LEGACY_LICENSE = GPLv2
IPTABLES_LEGACY_LICENSE_FILES = COPYING
# Building static causes ugly warnings on some plugins
IPTABLES_LEGACY_CONF_OPTS = --libexecdir=/usr/lib --with-kernel=$(STAGING_DIR)/usr \
	$(if $(BR2_STATIC_LIBS),,--disable-static)
# Because of iptables-01-fix-static-link.patch
IPTABLES_LEGACY_AUTORECONF = YES

# For connlabel match
ifeq ($(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),y)
IPTABLES_LEGACY_DEPENDENCIES += libnetfilter_conntrack
endif

# For nfnl_osf
ifeq ($(BR2_PACKAGE_LIBNFNETLINK),y)
IPTABLES_LEGACY_DEPENDENCIES += libnfnetlink
endif

define IPTABLES_LEGACY_TARGET_SYMLINK_CREATE
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables-save
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/iptables-restore
endef

define IPTABLES_LEGACY_TARGET_IPV6_SYMLINK_CREATE
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables-save
	ln -sf xtables-multi $(TARGET_DIR)/usr/sbin/ip6tables-restore
endef

IPTABLES_LEGACY_POST_INSTALL_TARGET_HOOKS += IPTABLES_LEGACY_TARGET_SYMLINK_CREATE

IPTABLES_LEGACY_POST_INSTALL_TARGET_HOOKS += IPTABLES_LEGACY_TARGET_IPV6_SYMLINK_CREATE

$(eval $(autotools-package))
