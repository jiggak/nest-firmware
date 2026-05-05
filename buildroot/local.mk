LINUX_OVERRIDE_SRCDIR = ../linux/linux

# Kernel panics early when built with GCC 4.9, lying robot said:
#   Alignment fault caused by GCC 4.9 generating unaligned memory accesses
#   incompatible with Linux 2.6.37
# KCFLAGS="-mno-unaligned-access -fno-strict-aliasing"
#
# Modules failed to load with error:
#   cfg80211: relocation out of range, section 3 reloc 0 sym 'rtnl_lock'
# Lying robot says:
#   Forces GCC to generate indirect calls via registers
#   Avoid R_ARM_CALL range limits
# Long calls helped for a bit, but once initramfs image got larger (~10MB)
# relocation error came back. Not needed with initrd image, or root fs in flash.
# KCFLAGS="-mlong-calls"
LINUX_CFLAGS += -mno-unaligned-access -fno-strict-aliasing