From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/2] x86/centaur: merge 32 & 64 bit version
Date: Sat, 14 Mar 2009 12:24:02 +0100
Message-ID: <1237029843-28076-2-git-send-email-sebastian@breakpoint.cc>
References: <49B83002.9040705@tobiasvolk.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	mail@tobiasvolk.de,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60027 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbZCNLYI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Mar 2009 07:24:08 -0400
In-Reply-To: <49B83002.9040705@tobiasvolk.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

there should be no difference, except
* the 64bit variant now also initializes the padlock unit.
* ->c_early_init() is executed again from ->c_init()
* the 64bit fixups made into 32bit path.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/Kconfig.cpu             |   17 +----------------
 arch/x86/kernel/cpu/Makefile     |    3 +--
 arch/x86/kernel/cpu/centaur.c    |   30 +++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/centaur_64.c |   37 -------------------------------------
 4 files changed, 27 insertions(+), 60 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/centaur_64.c

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index a95eaf0..924e156 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -456,24 +456,9 @@ config CPU_SUP_AMD
 
 	  If unsure, say N.
 
-config CPU_SUP_CENTAUR_32
+config CPU_SUP_CENTAUR
 	default y
 	bool "Support Centaur processors" if PROCESSOR_SELECT
-	depends on !64BIT
-	---help---
-	  This enables detection, tunings and quirks for Centaur processors
-
-	  You need this enabled if you want your kernel to run on a
-	  Centaur CPU. Disabling this option on other types of CPUs
-	  makes the kernel a tiny bit smaller. Disabling it on a Centaur
-	  CPU might render the kernel unbootable.
-
-	  If unsure, say N.
-
-config CPU_SUP_CENTAUR_64
-	default y
-	bool "Support Centaur processors" if PROCESSOR_SELECT
-	depends on 64BIT
 	---help---
 	  This enables detection, tunings and quirks for Centaur processors
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 24733b4..3efcb2b 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -19,8 +19,7 @@ obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
 obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
-obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
-obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
+obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 983e083..946814a 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -276,7 +276,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		 */
 		c->x86_capability[5] = cpuid_edx(0xC0000001);
 	}
-
+#ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
 	if (c->x86_model >= 6 && c->x86_model <= 9) {
 		rdmsr(MSR_VIA_FCR, lo, hi);
@@ -288,6 +288,11 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	/* Before Nehemiah, the C3's had 3dNOW! */
 	if (c->x86_model >= 6 && c->x86_model < 9)
 		set_cpu_cap(c, X86_FEATURE_3DNOW);
+#endif
+	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	}
 
 	display_cacheinfo(c);
 }
@@ -316,16 +321,25 @@ enum {
 static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
+#ifdef CONFIG_X86_32
 	case 5:
 		/* Emulate MTRRs using Centaur's MCR. */
 		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
 		break;
+#endif
+	case 6:
+		if (c->x86_model >= 0xf)
+			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		break;
 	}
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
+#endif
 }
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
-
+#ifdef CONFIG_X86_32
 	char *name;
 	u32  fcr_set = 0;
 	u32  fcr_clr = 0;
@@ -337,8 +351,10 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
 	 */
 	clear_cpu_cap(c, 0*32+31);
-
+#endif
+	early_init_centaur(c);
 	switch (c->x86) {
+#ifdef CONFIG_X86_32
 	case 5:
 		switch (c->x86_model) {
 		case 4:
@@ -442,16 +458,20 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 		}
 		sprintf(c->x86_model_id, "WinChip %s", name);
 		break;
-
+#endif
 	case 6:
 		init_c3(c);
 		break;
 	}
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+#endif
 }
 
 static unsigned int __cpuinit
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
+#ifdef CONFIG_X86_32
 	/* VIA C3 CPUs (670-68F) need further shifting. */
 	if ((c->x86 == 6) && ((c->x86_model == 7) || (c->x86_model == 8)))
 		size >>= 8;
@@ -464,7 +484,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	if ((c->x86 == 6) && (c->x86_model == 9) &&
 				(c->x86_mask == 1) && (size == 65))
 		size -= 1;
-
+#endif
 	return size;
 }
 
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
deleted file mode 100644
index 51b09c4..0000000
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ /dev/null
@@ -1,37 +0,0 @@
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/cpufeature.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
-{
-	if (c->x86 == 0x6 && c->x86_model >= 0xf)
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-}
-
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
-{
-	early_init_centaur(c);
-
-	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	}
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-}
-
-static const struct cpu_dev centaur_cpu_dev __cpuinitconst = {
-	.c_vendor	= "Centaur",
-	.c_ident	= { "CentaurHauls" },
-	.c_early_init	= early_init_centaur,
-	.c_init		= init_centaur,
-	.c_x86_vendor	= X86_VENDOR_CENTAUR,
-};
-
-cpu_dev_register(centaur_cpu_dev);
