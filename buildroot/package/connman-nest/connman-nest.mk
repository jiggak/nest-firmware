CONNMAN_NEST_VERSION = ba669b5831fd37dd868237c13db163256d1b0c52
CONNMAN_NEST_SITE = https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/connman
CONNMAN_NEST_SITE_METHOD = git
CONNMAN_NEST_DEPENDENCIES = libglib2 dbus iptables-legacy readline
CONNMAN_NEST_INSTALL_STAGING = YES
CONNMAN_NEST_LICENSE = GPLv2
CONNMAN_NEST_LICENSE_FILES = COPYING
CONNMAN_NEST_CONF_OPTS += \
	--with-dbusconfdir=/etc \
	--enable-sleep \
	--disable-loopback \
	--disable-bluetooth \
	--disable-ofono \
	--disable-dundee \
	--disable-pacrunner \
	--disable-neard \
	--disable-wispr \
	--disable-tools

define CONNMAN_NEST_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D \
		$(BR2_EXTERNAL_NEST_PATH)/package/connman-nest/S45connman \
		$(TARGET_DIR)/etc/init.d/S45connman

	$(INSTALL) -m 0644 -D \
		$(BR2_EXTERNAL_NEST_PATH)/package/connman-nest/main.conf \
		$(TARGET_DIR)/etc/connman/main.conf
endef

define CONNMAN_NEST_INSTALL_CM
	$(INSTALL) -m 0755 -D $(@D)/client/connmanctl $(TARGET_DIR)/usr/bin/connmanctl
endef

CONNMAN_NEST_POST_INSTALL_TARGET_HOOKS += CONNMAN_NEST_INSTALL_CM

$(eval $(autotools-package))
