Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E66EC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 11:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A84206DB
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 11:39:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZCA/8iI/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfKNLjs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 06:39:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56067 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfKNLjs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 06:39:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so5316620wmb.5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Nov 2019 03:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3gelj9qdDNDBR/8sWiskUXGG62BLdPFzPtC83zX5fGw=;
        b=ZCA/8iI/FfXHF+6Hl15En9MvxRoNbeDLGG4VU2VaPnr/cwNeQ6ctSeSZefO7UWWX+P
         fmocJk5+Pvy5Z0XI82uVEjqUHHhNQzX1HB/UZUC5Us7URuz4ARcIw2NEM/POqpBgGkUu
         CDHedaKQJWj/3TPNA30TLIUX5xOL3Z689JL7BH9YMTemAdpAvQPdHETszMDTgqWwFoIX
         G1DP2vyoBBOcjkz4JFBCBQzHF4c/Mw6n/AszBQV1vpw6HOF6uY+N38htXNOCNADvX+4u
         NyYTX/w0JCl8F0YkZyIK9aocO8odvIg8LxB+oFM67aV1zEvWCxi1XUcSTKRgg1LCL69N
         fU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3gelj9qdDNDBR/8sWiskUXGG62BLdPFzPtC83zX5fGw=;
        b=BU8RAAQPHy/nip1kfCJsEWs15cbyzXPlrEShkW6L6alBKOUMZ+PPMUii19421i6i77
         ZY5L65++aXE7KAVRJgS41oqLQxehpZEoNAJHvF2lnCN3r87mw9Jli6PzuLOZaXm5KdyH
         vRIF00UifvBoKZzDg6WEoyyMQBA1nMFRRYzDnnoYek64JKABwW/1w4fmM3hwhpdJr/3Q
         TZrZ3LjwWgmTKPpYWoX6ratJh/zhRd2EOEaNuKVtLpbVJjY26HAYyQOSPqJXbpDLPGkI
         mbQ7NXkqtGO98PJcuNRrF5Ut+L868CDTfY7SGI5KSe6qiFn9J2yVuDjy0JaHIJ1oFIgS
         WxeA==
X-Gm-Message-State: APjAAAWCMbO9E1mJjr8zKTqr11nKgb7V7NGU4ofj/iWbKGeTM2FAQKNk
        Fv1eVwTKxGqa/MnXdLQGLuQCaGNOldHCOA==
X-Google-Smtp-Source: APXvYqzFF0ioUi9PPgaGYbAcePMR+FjuxnyKvcEg818ssGQZtWN5iOzb7+6p49n24pg0ByzftEOXfg==
X-Received: by 2002:a1c:998f:: with SMTP id b137mr7775184wme.104.1573731585285;
        Thu, 14 Nov 2019 03:39:45 -0800 (PST)
Received: from localhost.localdomain (184.red-37-158-56.dynamicip.rima-tde.net. [37.158.56.184])
        by smtp.gmail.com with ESMTPSA id u1sm5421745wmc.3.2019.11.14.03.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 03:39:44 -0800 (PST)
From:   richard.henderson@linaro.org
To:     linux-arm-kernel@lists.infradead.org
Cc:     mark.rutland@arm.com, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v7] arm64: Implement archrandom.h for ARMv8.5-RNG
Date:   Thu, 14 Nov 2019 12:39:32 +0100
Message-Id: <20191114113932.26186-1-richard.henderson@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

Expose the ID_AA64ISAR0.RNDR field to userspace, as the RNG system
registers are always available at EL0.

Implement arch_get_random_seed_long using RNDR.  Given that the
TRNG is likely to be a shared resource between cores, and VMs,
do not explicitly force re-seeding with RNDRRS.

Within arch_get_random_seed_long, use arm64_const_caps_ready to
notice when we're being called before system capabilities are
finalized, e.g. within rand_initialize().  In that case, use
this_cpu_has_cap to test support on the boot cpu.

After arm64_const_caps_ready is set, the static_branch'es resolve
to nops or unconditional branches based on the whole system state.

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
v6: Drop arch_get_random_long, use RNDR in arch_get_random_seed_long,
    do not use RNDRRS at all (Ard).
    Drop the pr_warn mis-communication (Mark).
    Use ARM64_CPUCAP_SYSTEM_FEATURE for feature detection (Mark).
    Move arch_get_random_seed_long back inline using ALTERNATIVE_CB.
v7: Drop ALTERNATIVE_CB, use only static_branch_likely
    and __cpus_have_const_cap.
    Split RANDOM_TRUST_CPU change to a separate patch.
---
 Documentation/arm64/cpu-feature-registers.rst |  2 +
 arch/arm64/include/asm/archrandom.h           | 29 +++++++++++
 arch/arm64/include/asm/cpucaps.h              |  3 +-
 arch/arm64/include/asm/sysreg.h               |  4 ++
 arch/arm64/kernel/cpufeature.c                | 13 +++++
 arch/arm64/kernel/random.c                    | 49 +++++++++++++++++++
 arch/arm64/Kconfig                            | 12 +++++
 arch/arm64/kernel/Makefile                    |  1 +
 8 files changed, 112 insertions(+), 1 deletion(-)
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
index 000000000000..9b940d976e70
--- /dev/null
+++ b/arch/arm64/include/asm/archrandom.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARCHRANDOM_H
+#define _ASM_ARCHRANDOM_H
+
+#ifdef CONFIG_ARCH_RANDOM
+
+static inline bool __must_check arch_get_random_long(unsigned long *v)
+{
+	return false;
+}
+
+static inline bool __must_check arch_get_random_int(unsigned int *v)
+{
+	return false;
+}
+
+bool __must_check arch_get_random_seed_long(unsigned long *v);
+
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
+{
+	unsigned long val;
+	bool ok = arch_get_random_seed_long(&val);
+
+	*v = val;
+	return ok;
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
index 80f459ad0190..8c3be148c3a2 100644
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
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
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
index 000000000000..4af105be5c9a
--- /dev/null
+++ b/arch/arm64/kernel/random.c
@@ -0,0 +1,49 @@
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
+static bool arm64_rndr(unsigned long *v)
+{
+	bool ok;
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
+	return ok;
+}
+
+bool arch_get_random_seed_long(unsigned long *v)
+{
+	bool ok;
+
+	if (static_branch_likely(&arm64_const_caps_ready)) {
+		if (__cpus_have_const_cap(ARM64_HAS_RNG))
+			return arm64_rndr(v);
+		return false;
+	}
+
+	/*
+	 * Before const_caps_ready, check the current cpu.
+	 * This will generally be the boot cpu for rand_initialize().
+	 */
+	preempt_disable_notrace();
+	ok = this_cpu_has_cap(ARM64_HAS_RNG) && arm64_rndr(v);
+	preempt_enable_notrace();
+
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
-- 
2.17.1

