LINUX_OVERRIDE_SRCDIR = ../linux

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
# KCFLAGS="-mlong-calls"
LINUX_CFLAGS += -mno-unaligned-access -fno-strict-aliasing