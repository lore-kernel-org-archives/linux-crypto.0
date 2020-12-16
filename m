Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03191C2BBD4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D0824CED
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgLPRqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:46:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:21280 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgLPRqw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:46:52 -0500
IronPort-SDR: LvBIZcwP+fGV2WTPHVekXzDDYRnHu3QtS4F9v/C5WFwonf3rTGVz8eHJcJSggUGV8YWmv2WotB
 pNwVr1wB6CMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171593400"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="171593400"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:09 -0800
IronPort-SDR: Z3R3Ty3wnnDIkHCQLlHTencVqCPO5gmKwByNJ/BrboFvD9zXayDzafsfVGBqZD8Qka3XtQqu3m
 palQHDgtu0OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854185"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:09 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH 2/8] x86/cpu: Load Key Locker internal key at boot-time
Date:   Wed, 16 Dec 2020 09:41:40 -0800
Message-Id: <20201216174146.10446-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Internal (Wrapping) Key is a new entity of Intel Key Locker feature. This
internal key is loaded in a software-inaccessible CPU state and used to
encode a data encryption key.

The kernel makes random data and loads it as the internal key in each CPU.
The data need to be invalidated as soon as the load is done.

The BIOS may disable the feature. Check the dynamic CPUID bit
(KEYLOCKER_CPUID_EBX_AESKLE) at first.

Add byte code for LOADIWKEY -- an instruction to load the internal key, in
the 'x86-opcode-map.txt' file to avoid objtool's misinterpretation.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/keylocker.h      | 11 +++++
 arch/x86/kernel/Makefile              |  1 +
 arch/x86/kernel/cpu/common.c          | 38 +++++++++++++-
 arch/x86/kernel/keylocker.c           | 71 +++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  2 +
 arch/x86/lib/x86-opcode-map.txt       |  2 +-
 tools/arch/x86/lib/x86-opcode-map.txt |  2 +-
 7 files changed, 124 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/keylocker.c

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 2fe13c21c63f..daf0734a4095 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -14,5 +14,16 @@
 #define KEYLOCKER_CPUID_EBX_BACKUP     BIT(4)
 #define KEYLOCKER_CPUID_ECX_RAND       BIT(1)
 
+bool check_keylocker_readiness(void);
+
+bool load_keylocker(void);
+
+void make_keylocker_data(void);
+#ifdef CONFIG_X86_KEYLOCKER
+void invalidate_keylocker_data(void);
+#else
+#define invalidate_keylocker_data() do { } while (0)
+#endif
+
 #endif /*__ASSEMBLY__ */
 #endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 68608bd892c0..085dbf49b3b9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -145,6 +145,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
 obj-$(CONFIG_X86_UMIP)			+= umip.o
+obj-$(CONFIG_X86_KEYLOCKER)		+= keylocker.o
 
 obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35ad8480c464..d675075848bb 100644
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
@@ -459,6 +461,39 @@ static __init int x86_nofsgsbase_setup(char *arg)
 }
 __setup("nofsgsbase", x86_nofsgsbase_setup);
 
+static __always_inline void setup_keylocker(struct cpuinfo_x86 *c)
+{
+	bool keyloaded;
+
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
+		goto out;
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+
+	if (c == &boot_cpu_data) {
+		if (!check_keylocker_readiness())
+			goto disable_keylocker;
+
+		make_keylocker_data();
+	}
+
+	keyloaded = load_keylocker();
+	if (!keyloaded) {
+		pr_err_once("x86/keylocker: Failed to load internal key\n");
+		goto disable_keylocker;
+	}
+
+	pr_info_once("x86/keylocker: Activated\n");
+	return;
+
+disable_keylocker:
+	clear_cpu_cap(c, X86_FEATURE_KEYLOCKER);
+	pr_info_once("x86/keylocker: Disabled\n");
+out:
+	/* Make sure the feature disabled for kexec-reboot. */
+	cr4_clear_bits(X86_CR4_KEYLOCKER);
+}
+
 /*
  * Protection Keys are not available in 32-bit mode.
  */
@@ -1554,10 +1589,11 @@ static void identify_cpu(struct cpuinfo_x86 *c)
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
index 000000000000..e455d806b80c
--- /dev/null
+++ b/arch/x86/kernel/keylocker.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Key Locker feature check and support the internal key
+ */
+
+#include <linux/random.h>
+
+#include <asm/keylocker.h>
+#include <asm/fpu/types.h>
+#include <asm/fpu/api.h>
+
+bool check_keylocker_readiness(void)
+{
+	u32 eax, ebx, ecx, edx;
+
+	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	/* BIOS may not enable it on some systems. */
+	if (!(ebx & KEYLOCKER_CPUID_EBX_AESKLE)) {
+		pr_debug("x86/keylocker: not fully enabled\n");
+		return false;
+	}
+
+	return true;
+}
+
+/* Load Internal (Wrapping) Key */
+#define LOADIWKEY		".byte 0xf3,0x0f,0x38,0xdc,0xd1"
+#define LOADIWKEY_NUM_OPERANDS	3
+
+static struct key {
+	struct reg_128_bit value[LOADIWKEY_NUM_OPERANDS];
+} keydata;
+
+void make_keylocker_data(void)
+{
+	int i;
+
+	for (i = 0; i < LOADIWKEY_NUM_OPERANDS; i++)
+		get_random_bytes(&keydata.value[i], sizeof(struct reg_128_bit));
+}
+
+void invalidate_keylocker_data(void)
+{
+	memset(&keydata.value, 0, sizeof(struct reg_128_bit) * LOADIWKEY_NUM_OPERANDS);
+}
+
+#define USE_SWKEY	0
+
+bool load_keylocker(void)
+{
+	struct reg_128_bit zeros = { 0 };
+	u32 keysrc = USE_SWKEY;
+	bool err = true;
+
+	kernel_fpu_begin();
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %1, %%xmm1; movdqu %2, %%xmm2;"
+		      :: "m"(keydata.value[0]),
+			 "m"(keydata.value[1]),
+			 "m"(keydata.value[2]));
+
+	asm volatile (LOADIWKEY CC_SET(z) : CC_OUT(z) (err) : "a"(keysrc));
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
+		      :: "m"(zeros));
+
+	kernel_fpu_end();
+
+	return err ? false : true;
+}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index de776b2e6046..a01edf46d4c7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -81,6 +81,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/hw_irq.h>
 #include <asm/stackprotector.h>
+#include <asm/keylocker.h>
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
@@ -1423,6 +1424,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	nmi_selftest();
 	impress_friends();
 	mtrr_aps_init();
+	invalidate_keylocker_data();
 }
 
 static int __initdata setup_possible_cpus = -1;
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index ec31f5b60323..3e241cddfc86 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -795,7 +795,7 @@ cc: sha256msg1 Vdq,Wdq | vrsqrt28ps/d Vx,Wx (66),(ev)
 cd: sha256msg2 Vdq,Wdq | vrsqrt28ss/d Vx,Hx,Wx (66),(ev)
 cf: vgf2p8mulb Vx,Wx (66)
 db: VAESIMC Vdq,Wdq (66),(v1)
-dc: vaesenc Vx,Hx,Wx (66)
+dc: vaesenc Vx,Hx,Wx (66) | loadiwkey Vx,Hx (F3)
 dd: vaesenclast Vx,Hx,Wx (66)
 de: vaesdec Vx,Hx,Wx (66)
 df: vaesdeclast Vx,Hx,Wx (66)
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index ec31f5b60323..3e241cddfc86 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -795,7 +795,7 @@ cc: sha256msg1 Vdq,Wdq | vrsqrt28ps/d Vx,Wx (66),(ev)
 cd: sha256msg2 Vdq,Wdq | vrsqrt28ss/d Vx,Hx,Wx (66),(ev)
 cf: vgf2p8mulb Vx,Wx (66)
 db: VAESIMC Vdq,Wdq (66),(v1)
-dc: vaesenc Vx,Hx,Wx (66)
+dc: vaesenc Vx,Hx,Wx (66) | loadiwkey Vx,Hx (F3)
 dd: vaesenclast Vx,Hx,Wx (66)
 de: vaesdec Vx,Hx,Wx (66)
 df: vaesdeclast Vx,Hx,Wx (66)
-- 
2.17.1

