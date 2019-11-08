Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CF9C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 073F021924
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VApYMUem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKHN6I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 08:58:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34920 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKHN6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 08:58:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id 8so6347883wmo.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 05:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JSAj4UNo0s82HmpusaFb1MeLYC6KSj4Gfcm2JWdZruY=;
        b=VApYMUem9Xf0wySwNgd66vSAONXOk1yoCTbm8VDjS231bOPuhPmiURr/fJRfNHjvT6
         +3eV2H5mfxKsOo6hz7+eWf0x1s8T5gbceca95xNCt7htp/H0biWFFMpypk5PnTih9nCq
         UWXLt9GzG8zwnMP8Cf58wCZ49f39wXOfEVv7SqdtIW4RrmYrqrNJGstPL1St+QilG13R
         umIFrjGjZH0ZjLny894A2ukD+r8hqm4yB81XKwoezGLgm20V+WoI1GuAZnK95QRh7EW8
         ofdQKXKKepu0jGgHi3ybfpZ1EjPmBuNXBl/tK/W0vj5jQ8dkfL0Dmd8mEn2rQ0rDHU6r
         +dKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JSAj4UNo0s82HmpusaFb1MeLYC6KSj4Gfcm2JWdZruY=;
        b=kFxaJM5VtZFsToLGM+kK1ROTSV/nC4nUFdQDI1MwZdOTxB7+1LJon//pi8baqJ7m3l
         wlTsOiaDL9olncMuEnpTuHVkC9P6EdWQ+ckEN6jdpeuyAZW4DSXSEAP7E/u3VKRui96A
         ujlX478OJi93dHvYl2we9TaQlG7GIAjtKUCP3gRLK3sX+Re8jbOhTuWxBxZyl5JvP8OD
         d+D4XffFr2B1uaTA+BPohkdYVcUgXaQZlIOyHczfog/jgY5eJ2Zhjit2395fH4UutQMX
         OFZWnFThetqTzoHklAKuMrGW8bZxPs4jSUUBYrkQ0kviiTGhhRW26hnwJoxiSWdGiTJg
         KFiw==
X-Gm-Message-State: APjAAAXlgleR7XwwOlOj34iCeK++ZwZ/MsLaurPuBdagcAPWFwpy7Vpa
        N9IeahXvsM3I4vPVZvKjYcuNIQ==
X-Google-Smtp-Source: APXvYqx6XBBxmte3zBY1ph01QlPtKhucaziETvnwxHuyUBTcyOPLP/tAEMJ84xYxZxJsVJ+105eyOA==
X-Received: by 2002:a1c:9ccd:: with SMTP id f196mr8422699wme.152.1573221484456;
        Fri, 08 Nov 2019 05:58:04 -0800 (PST)
Received: from localhost.localdomain (212.red-213-99-162.dynamicip.rima-tde.net. [213.99.162.212])
        by smtp.gmail.com with ESMTPSA id a16sm9022470wmd.11.2019.11.08.05.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 05:58:03 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, mark.rutland@arm.com,
        ard.biesheuvel@linaro.org,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5] arm64: Implement archrandom.h for ARMv8.5-RNG
Date:   Fri,  8 Nov 2019 14:57:51 +0100
Message-Id: <20191108135751.3218-1-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

Expose the ID_AA64ISAR0.RNDR field to userspace, as the
RNG system registers are always available at EL0.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
v2: Use __mrs_s and fix missing cc clobber (Mark),
    Log rng failures with pr_warn (Mark),
    Use __must_check; put RNDR in arch_get_random_long and RNDRRS
    in arch_get_random_seed_long (Ard),
    Use ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE, and check this_cpu_has_cap
    when reading random data.  Move everything out of line, now that
    there are 5 other function calls involved, and to unify the rate
    limiting on the pr_warn.
v3: Keep arch_get_random{,_seed}_long in sync.
v4: Use __cpus_have_const_cap before falling back to this_cpu_has_cap.
v5: Improve commentary; fix some checkpatch warnings.
---
 Documentation/arm64/cpu-feature-registers.rst |  2 +
 arch/arm64/include/asm/archrandom.h           | 35 ++++++++
 arch/arm64/include/asm/cpucaps.h              |  3 +-
 arch/arm64/include/asm/sysreg.h               |  4 +
 arch/arm64/kernel/cpufeature.c                | 13 +++
 arch/arm64/kernel/random.c                    | 82 +++++++++++++++++++
 arch/arm64/Kconfig                            | 12 +++
 arch/arm64/kernel/Makefile                    |  1 +
 drivers/char/Kconfig                          |  4 +-
 9 files changed, 153 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/archrandom.h
 create mode 100644 arch/arm64/kernel/random.c

diff --git a/Documentation/arm64/cpu-feature-registers.rst b/Documentation/arm64/cpu-feature-registers.rst
index 2955287e9acc..78d6f5c6e824 100644
--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -117,6 +117,8 @@ infrastructure:
      +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
      +------------------------------+---------+---------+
+     | RNDR                         | [63-60] |    y    |
+     +------------------------------+---------+---------+
      | TS                           | [55-52] |    y    |
      +------------------------------+---------+---------+
      | FHM                          | [51-48] |    y    |
diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
new file mode 100644
index 000000000000..e796a6de7421
--- /dev/null
+++ b/arch/arm64/include/asm/archrandom.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARCHRANDOM_H
+#define _ASM_ARCHRANDOM_H
+
+#ifdef CONFIG_ARCH_RANDOM
+
+bool __must_check arch_get_random_long(unsigned long *v);
+bool __must_check arch_get_random_seed_long(unsigned long *v);
+
+static inline bool __must_check arch_get_random_int(unsigned int *v)
+{
+	unsigned long val;
+
+	if (arch_get_random_long(&val)) {
+		*v = val;
+		return true;
+	}
+
+	return false;
+}
+
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
+{
+	unsigned long val;
+
+	if (arch_get_random_seed_long(&val)) {
+		*v = val;
+		return true;
+	}
+
+	return false;
+}
+
+#endif /* CONFIG_ARCH_RANDOM */
+#endif /* _ASM_ARCHRANDOM_H */
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index ac1dbca3d0cd..1dd7644bc59a 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -54,7 +54,8 @@
 #define ARM64_WORKAROUND_1463225		44
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
+#define ARM64_HAS_RNG				47
 
-#define ARM64_NCAPS				47
+#define ARM64_NCAPS				48
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6e919fafb43d..5e718f279469 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -365,6 +365,9 @@
 #define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
 #define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
 
+#define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
+#define SYS_RNDRRS_EL0			sys_reg(3, 3, 2, 4, 1)
+
 #define SYS_PMCR_EL0			sys_reg(3, 3, 9, 12, 0)
 #define SYS_PMCNTENSET_EL0		sys_reg(3, 3, 9, 12, 1)
 #define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
@@ -539,6 +542,7 @@
 			 ENDIAN_SET_EL1 | SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_RNDR_SHIFT		60
 #define ID_AA64ISAR0_TS_SHIFT		52
 #define ID_AA64ISAR0_FHM_SHIFT		48
 #define ID_AA64ISAR0_DP_SHIFT		44
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 80f459ad0190..456d5c461cbf 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -119,6 +119,7 @@ static void cpu_enable_cnp(struct arm64_cpu_capabilities const *cap);
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_RNDR_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_TS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_FHM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_DP_SHIFT, 4, 0),
@@ -1565,6 +1566,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
 	},
+#endif
+#ifdef CONFIG_ARCH_RANDOM
+	{
+		.desc = "Random Number Generator",
+		.capability = ARM64_HAS_RNG,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64ISAR0_EL1,
+		.field_pos = ID_AA64ISAR0_RNDR_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = 1,
+	},
 #endif
 	{},
 };
diff --git a/arch/arm64/kernel/random.c b/arch/arm64/kernel/random.c
new file mode 100644
index 000000000000..e7ff29dd637c
--- /dev/null
+++ b/arch/arm64/kernel/random.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Random number generation using ARMv8.5-RNG.
+ */
+
+#include <linux/random.h>
+#include <linux/ratelimit.h>
+#include <linux/printk.h>
+#include <linux/preempt.h>
+#include <asm/cpufeature.h>
+
+static inline bool has_random(void)
+{
+	/*
+	 * We "have" RNG if either
+	 * (1) every cpu in the system has RNG, or
+	 * (2) in a non-preemptible context, current cpu has RNG.
+	 *
+	 * Case 1 is the expected case when RNG is deployed, but
+	 * case 2 is present as a backup.  Case 2 has two effects:
+	 * (A) rand_initialize() is able to use the instructions
+	 * when present in the boot cpu, which happens before
+	 * secondary cpus are enabled and before features are
+	 * resolved for the full system.
+	 * (B) add_interrupt_randomness() is able to use the
+	 * instructions when present on the current cpu, in case
+	 * some big/little system only has RNG on big cpus.
+	 *
+	 * We can use __cpus_have_const_cap because we then fall
+	 * back to checking the current cpu.
+	 */
+	return __cpus_have_const_cap(ARM64_HAS_RNG) ||
+	       (!preemptible() && this_cpu_has_cap(ARM64_HAS_RNG));
+}
+
+bool arch_get_random_long(unsigned long *v)
+{
+	bool ok;
+
+	if (!has_random())
+		return false;
+
+	/*
+	 * Reads of RNDR set PSTATE.NZCV to 0b0000 on success,
+	 * and set PSTATE.NZCV to 0b0100 otherwise.
+	 */
+	asm volatile(
+		__mrs_s("%0", SYS_RNDR_EL0) "\n"
+	"	cset %w1, ne\n"
+	: "=r"(*v), "=r"(ok)
+	:
+	: "cc");
+
+	if (unlikely(!ok))
+		pr_warn_ratelimited("cpu%d: sys_rndr failed\n",
+				    read_cpuid_id());
+	return ok;
+}
+
+bool arch_get_random_seed_long(unsigned long *v)
+{
+	bool ok;
+
+	if (!has_random())
+		return false;
+
+	/*
+	 * Reads of RNDRRS set PSTATE.NZCV to 0b0000 on success,
+	 * and set PSTATE.NZCV to 0b0100 otherwise.
+	 */
+	asm volatile(
+		__mrs_s("%0", SYS_RNDRRS_EL0) "\n"
+	"	cset %w1, ne\n"
+	: "=r"(*v), "=r"(ok)
+	:
+	: "cc");
+
+	if (unlikely(!ok))
+		pr_warn_ratelimited("cpu%d: sys_rndrrs failed\n",
+				    read_cpuid_id());
+	return ok;
+}
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3f047afb982c..5bc88601f07b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1438,6 +1438,18 @@ config ARM64_PTR_AUTH
 
 endmenu
 
+menu "ARMv8.5 architectural features"
+
+config ARCH_RANDOM
+	bool "Enable support for random number generation"
+	default y
+	help
+	  Random number generation (part of the ARMv8.5 Extensions)
+	  provides a high bandwidth, cryptographically secure
+	  hardware random number generator.
+
+endmenu
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 478491f07b4f..a47c2b984da7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_CRASH_CORE)		+= crash_core.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
 obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
+obj-$(CONFIG_ARCH_RANDOM)		+= random.o
 
 obj-y					+= vdso/ probes/
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32/
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index df0fc997dc3e..f26a0a8cc0d0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -539,7 +539,7 @@ endmenu
 
 config RANDOM_TRUST_CPU
 	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
-	depends on X86 || S390 || PPC
+	depends on X86 || S390 || PPC || ARM64
 	default n
 	help
 	Assume that CPU manufacturer (e.g., Intel or AMD for RDSEED or
@@ -559,4 +559,4 @@ config RANDOM_TRUST_BOOTLOADER
 	device randomness. Say Y here to assume the entropy provided by the
 	booloader is trustworthy so it will be added to the kernel's entropy
 	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool.
\ No newline at end of file
+	only mixes the entropy pool.
-- 
2.17.1

