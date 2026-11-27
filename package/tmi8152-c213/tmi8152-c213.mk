################################################################################
#
# tmi8152-c213
#
################################################################################

TMI8152_C213_SITE = $(call github,sstepansky,tmi8152-spi-dev,$(TMI8152_C213_VERSION))
TMI8152_C213_VERSION = 4d5a666b77bc2af57cd00af20a088107c60d017e
TMI8152_C213_LICENSE = GPL-2.0
TMI8152_C213_LICENSE_FILES = LICENSE

# The chip sits on hardware SSI0 (PB27..PB30, function 2), bus 0, CS0,
# exactly like the stock kernel (ssi0-pb-1). The module creates the SPI
# device itself, so no board-file patch is needed.
define TMI8152_C213_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_SPI)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SPI_MASTER)
	$(call KCONFIG_ENABLE_OPT,CONFIG_JZ_SPI)
	$(call KCONFIG_ENABLE_OPT,CONFIG_JZ_SPI0)
	$(call KCONFIG_ENABLE_OPT,CONFIG_JZ_SPI0_PB_1)
	$(call KCONFIG_DISABLE_OPT,CONFIG_JZ_SPI0_PB_0)
	$(call KCONFIG_DISABLE_OPT,CONFIG_JZ_SPI0_PB_2)
	$(call KCONFIG_DISABLE_OPT,CONFIG_JZ_SPI0_PB_3)
endef

$(eval $(kernel-module))
$(eval $(generic-package))
