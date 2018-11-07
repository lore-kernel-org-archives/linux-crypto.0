Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47482 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGTJz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 14:09:55 -0500
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 2/4] arm64: lse: expose dependency on gas via Kconfig
Date: Wed,  7 Nov 2018 09:40:06 +0000
Message-Id: <1541583608-26375-3-git-send-email-vladimir.murzin@arm.com>
In-Reply-To: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
References: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So we can simply hide LSE support if dependency is not satisfied.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/Makefile             | 13 ++-----------
 arch/arm64/include/asm/atomic.h |  2 +-
 arch/arm64/include/asm/lse.h    |  6 +++---
 arch/arm64/kernel/cpufeature.c  |  4 ++--
 5 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 964f682..7978aee 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1072,6 +1072,7 @@ config ARM64_PAN
 config ARM64_LSE_ATOMICS
 	bool "Atomic instructions"
 	default y
+	depends on $(as-instr,.arch_extension lse)
 	help
 	  As part of the Large System Extensions, ARMv8.1 introduces new
 	  atomic instructions that are designed specifically to scale in
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b4e994c..3054757 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -32,15 +32,6 @@ endif
 
 KBUILD_DEFCONFIG := defconfig
 
-# Check for binutils support for specific extensions
-lseinstr := $(call as-instr,.arch_extension lse,-DCONFIG_AS_LSE=1)
-
-ifeq ($(CONFIG_ARM64_LSE_ATOMICS), y)
-  ifeq ($(lseinstr),)
-$(warning LSE atomics not supported by binutils)
-  endif
-endif
-
 ifeq ($(CONFIG_ARM64), y)
 brokengasinst := $(call as-instr,1:\n.inst 0\n.rept . - 1b\n\nnop\n.endr\n,,-DCONFIG_BROKEN_GAS_INST=1)
 
@@ -49,9 +40,9 @@ $(warning Detected assembler with broken .inst; disassembly will be unreliable)
   endif
 endif
 
-KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
+KBUILD_CFLAGS	+= -mgeneral-regs-only $(brokengasinst)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
-KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
+KBUILD_AFLAGS	+= $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
 KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)
diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 9bca54d..9d8d029 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -30,7 +30,7 @@
 
 #define __ARM64_IN_ATOMIC_IMPL
 
-#if defined(CONFIG_ARM64_LSE_ATOMICS) && defined(CONFIG_AS_LSE)
+#ifdef CONFIG_ARM64_LSE_ATOMICS
 #include <asm/atomic_lse.h>
 #else
 #include <asm/atomic_ll_sc.h>
diff --git a/arch/arm64/include/asm/lse.h b/arch/arm64/include/asm/lse.h
index 8262325..1fd31c7 100644
--- a/arch/arm64/include/asm/lse.h
+++ b/arch/arm64/include/asm/lse.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_LSE_H
 #define __ASM_LSE_H
 
-#if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
+#ifdef CONFIG_ARM64_LSE_ATOMICS
 
 #include <linux/compiler_types.h>
 #include <linux/export.h>
@@ -36,7 +36,7 @@
 	ALTERNATIVE(llsc, lse, ARM64_HAS_LSE_ATOMICS)
 
 #endif	/* __ASSEMBLER__ */
-#else	/* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
+#else	/* CONFIG_ARM64_LSE_ATOMICS */
 
 #ifdef __ASSEMBLER__
 
@@ -53,5 +53,5 @@
 #define ARM64_LSE_ATOMIC_INSN(llsc, lse)	llsc
 
 #endif	/* __ASSEMBLER__ */
-#endif	/* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
+#endif	/* CONFIG_ARM64_LSE_ATOMICS */
 #endif	/* __ASM_LSE_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 74e9dcb..46f1bac 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1170,7 +1170,7 @@ static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 		.cpu_enable = cpu_enable_pan,
 	},
 #endif /* CONFIG_ARM64_PAN */
-#if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
+#ifdef CONFIG_ARM64_LSE_ATOMICS
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
@@ -1181,7 +1181,7 @@ static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 2,
 	},
-#endif /* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
+#endif /* CONFIG_ARM64_LSE_ATOMICS */
 	{
 		.desc = "Software prefetching using PRFM",
 		.capability = ARM64_HAS_NO_HW_PREFETCH,
-- 
1.9.1
