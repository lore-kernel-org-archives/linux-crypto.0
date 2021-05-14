Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCF8C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827836145D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhENUVy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:16070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhENUVu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:50 -0400
IronPort-SDR: ZiXSCo9IxpOaeQk2YHoSI+e7bDjjDbyePm9AUBTOaIFUs46MOmEw0YvWrApe634cffn5gsr8Mw
 9jrCxi9oxr+g==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921587"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921587"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:36 -0700
IronPort-SDR: WkWppAfQtuJhmG2mbvn8VBYSCiDVNLoAVIrCEgrTcFdHwLOLftwmn4yZUeVcwRREMMG1yp8Da6
 MoVyoQVt1Y/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147162"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:34 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 03/11] x86/cpu: Load Key Locker internal key at boot-time
Date:   Fri, 14 May 2021 13:15:00 -0700
Message-Id: <20210514201508.27967-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Internal (Wrapping) Key is a new entity of Intel Key Locker feature. This
internal key is loaded in a software-inaccessible CPU state and used to
encode a data encryption key.

The kernel makes random data and loads it as the internal key in each CPU.
The data need to be flushed as soon as the load is done.

System firmware may disable the feature. Check the dynamic CPUID bit
(KEYLOCKER_CPUID_EBX_AESKLE) at first.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v1:
* Added to flush cache line when removing an internal key value. Also,
  renamed the helper.
* Reorganized the helper functions.
* Changed to reference boot CPU's feature flag consistently, and to update
  it if the feature is disabled.
* Refactored LOADIWKEY instruction in a new helper.
* Added function descriptions.
---
 arch/x86/include/asm/keylocker.h     |   9 ++
 arch/x86/include/asm/special_insns.h |  36 ++++++++
 arch/x86/kernel/Makefile             |   1 +
 arch/x86/kernel/cpu/common.c         |   5 +-
 arch/x86/kernel/keylocker.c          | 125 +++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            |   2 +
 6 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/keylocker.c

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 0597d6b1cd05..870832f007ec 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/processor.h>
 #include <linux/bits.h>
 
 #define KEYLOCKER_CPUID			0x019
@@ -14,5 +15,13 @@
 #define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
 #define KEYLOCKER_CPUID_ECX_RAND	BIT(1)
 
+#ifdef CONFIG_X86_KEYLOCKER
+void setup_keylocker(struct cpuinfo_x86 *c);
+void flush_keylocker_data(void);
+#else
+#define setup_keylocker(c) do { } while (0)
+#define flush_keylocker_data() do { } while (0)
+#endif
+
 #endif /*__ASSEMBLY__ */
 #endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2acd6cb62328..0511b2d72ab8 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -306,6 +306,42 @@ static inline int enqcmds(void __iomem *dst, const void *src)
 	return 0;
 }
 
+/**
+ * loadiwkey() - Load CPU-internal wrapping key
+ * @keyconf:	Indicate the key source and the key backup allowance.
+ *
+ * The key value is presumed in XMM0-2 registers. So make sure the states
+ * are available before calling this.
+ *
+ * If bit 0 of @keyconf is set, key backup is not permitted. If bit 1 is
+ * set, a hardware-randomized key is loaded.
+ *
+ * Returns:	-EAGAIN if hardware randomization fails; otherwise, 0.
+ *
+ */
+static inline int __must_check loadiwkey(u32 keyconf)
+{
+	int zf;
+
+	/*
+	 * LOADIWKEY %xmm1,%xmm2
+	 *
+	 * EAX and XMM0 are implicit operands. Load key value from XMM0-2
+	 * to software-invisible CPU state.
+	 *
+	 * This instruction is supported by binutils >= 2.36.
+	 */
+	asm volatile (".byte 0xf3,0x0f,0x38,0xdc,0xd1"
+		      CC_SET(z)
+		      : CC_OUT(z) (zf)
+		      : "a"(keyconf));
+
+	/* Hardware randomization failure is indicated via EFLAGS.ZF=1. */
+	if (zf)
+		return -EAGAIN;
+	return 0;
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_SPECIAL_INSNS_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0704c2a94272..5662876e175b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -143,6 +143,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
 obj-$(CONFIG_X86_UMIP)			+= umip.o
+obj-$(CONFIG_X86_KEYLOCKER)		+= keylocker.o
 
 obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a1b756c49a93..2e64371acb81 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -57,6 +57,8 @@
 #include <asm/microcode_intel.h>
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
+#include <asm/keylocker.h>
+
 #include <asm/uv/uv.h>
 
 #include "cpu.h"
@@ -1555,10 +1557,11 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
-	/* Set up SMEP/SMAP/UMIP */
+	/* Setup various Intel-specific CPU security features */
 	setup_smep(c);
 	setup_smap(c);
 	setup_umip(c);
+	setup_keylocker(c);
 
 	/* Enable FSGSBASE instructions if available. */
 	if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
new file mode 100644
index 000000000000..d590815de508
--- /dev/null
+++ b/arch/x86/kernel/keylocker.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Setup Key Locker feature and support the internal key management.
+ */
+
+#include <linux/random.h>
+
+#include <asm/cacheflush.h>
+#include <asm/fpu/api.h>
+#include <asm/fpu/types.h>
+#include <asm/keylocker.h>
+#include <asm/tlbflush.h>
+
+/* Internal (Wrapping) Key size fits in three 128-bit registers. */
+#define KEYSIZE_128BIT	3
+
+static struct _keydata {
+	struct reg_128_bit value[KEYSIZE_128BIT];
+} keydata;
+
+/**
+ * make_keylocker_data() - Generate the internal key.
+ *
+ * Return:	Nothing
+ */
+static void make_keylocker_data(void)
+{
+	int i;
+
+	for (i = 0; i < KEYSIZE_128BIT; i++)
+		get_random_bytes(&keydata.value[i], sizeof(struct reg_128_bit));
+}
+
+/**
+ * flush_keylocker_data() - Flush the internal key in memory.
+ *
+ * Returns:	Nothing
+ */
+void flush_keylocker_data(void)
+{
+	unsigned int size = sizeof(struct reg_128_bit) * KEYSIZE_128BIT;
+	void *keyaddr = &keydata.value;
+
+	if (!boot_cpu_has(X86_FEATURE_KEYLOCKER))
+		return;
+
+	memset(keyaddr, 0, size);
+	clflush_cache_range(keyaddr, size);
+}
+
+#define KEYSRC_SWRAND		0
+
+/**
+ * load_keylocker() - Load the internal key.
+ *
+ * Returns:	-EAGAIN if hardware randomization fails; otherwise, 0.
+ */
+static int load_keylocker(void)
+{
+	struct reg_128_bit zeros = { 0 };
+	u32 keysrc = KEYSRC_SWRAND;
+	int err;
+
+	kernel_fpu_begin();
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %1, %%xmm1; movdqu %2, %%xmm2;"
+		      :: "m"(keydata.value[0]),
+			 "m"(keydata.value[1]),
+			 "m"(keydata.value[2]));
+
+	err = loadiwkey(keysrc);
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
+		      :: "m"(zeros));
+
+	kernel_fpu_end();
+
+	return err;
+}
+
+/**
+ * setup_keylocker() - Enable the feature if supported.
+ * @c:		A pointer to struct cpuinfo_x86
+ *
+ * Returns:	Nothing
+ */
+void setup_keylocker(struct cpuinfo_x86 *c)
+{
+	int err;
+
+	if (!boot_cpu_has(X86_FEATURE_KEYLOCKER))
+		goto out;
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+
+	if (c == &boot_cpu_data) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+		/* BIOS may not enable it on some systems. */
+		if (!(ebx & KEYLOCKER_CPUID_EBX_AESKLE)) {
+			pr_debug("x86/keylocker: not fully supported.\n");
+			goto disable;
+		}
+
+		make_keylocker_data();
+	}
+
+	err = load_keylocker();
+	if (err) {
+		pr_err_once("x86/keylocker: Failed to load internal key (rc: %d).\n", err);
+		goto disable;
+	}
+
+	pr_info_once("x86/keylocker: Enabled.\n");
+	return;
+
+disable:
+	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
+	pr_info_once("x86/keylocker: Disabled.\n");
+out:
+	/* Make sure the feature disabled for kexec-reboot. */
+	cr4_clear_bits(X86_CR4_KEYLOCKER);
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0ad5214f598a..0266d70a44be 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -82,6 +82,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/hw_irq.h>
 #include <asm/stackprotector.h>
+#include <asm/keylocker.h>
 
 #ifdef CONFIG_ACPI_CPPC_LIB
 #include <acpi/cppc_acpi.h>
@@ -1429,6 +1430,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	nmi_selftest();
 	impress_friends();
 	mtrr_aps_init();
+	flush_keylocker_data();
 }
 
 static int __initdata setup_possible_cpus = -1;
-- 
2.17.1

