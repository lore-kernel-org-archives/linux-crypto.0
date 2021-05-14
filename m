Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6ADC43617
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794276145D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhENUV6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:16073 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233309AbhENUVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:54 -0400
IronPort-SDR: zvnmxi8aJEfgTiTVI1iam1tQnDRGB1WJPS6oBXH/jzjOmPh+eEt9m3CGrAWM9Z/3oddaxRmBty
 5obd3qvTsE/A==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921604"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921604"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:40 -0700
IronPort-SDR: B6O2zx/sWz/6z03jUjwrUDxo3gUUbtiHGVsZFkRbotPsDE0F3uA3phjEV73PJQxCX/pPBuNrLR
 LfxMXQYQnQmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147206"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:40 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com,
        Mark Brown <broonie@kernel.org>, linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 11/11] x86/cpu: Support the hardware randomization option for Key Locker internal key
Date:   Fri, 14 May 2021 13:15:08 -0700
Message-Id: <20210514201508.27967-12-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hardware can load the internal key with randomization. The random.trust_cpu
parameter determines the use of the CPU's random number generator. Take it
to use the CPU's internal key randomization.

The feature's backup mechanism is required to distribute an internal key.
This is the only way to copy it to other CPUs if using hardware
randomization.

This option is disabled when hardware does not support the key backup.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: x86@kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/keylocker.c | 37 ++++++++++++++++++++++++++++++++-----
 drivers/char/random.c       |  6 ++++++
 include/linux/random.h      |  2 ++
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 0f60350944fa..5a784492195b 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -7,6 +7,7 @@
 #include <linux/random.h>
 #include <linux/acpi.h>
 #include <linux/delay.h>
+#include <linux/random.h>
 
 #include <asm/cacheflush.h>
 #include <asm/fpu/api.h>
@@ -15,27 +16,34 @@
 #include <asm/tlbflush.h>
 
 static bool keybackup_available;
+static bool keyhwrand_available;
 
 /* Internal (Wrapping) Key size fits in three 128-bit registers. */
 #define KEYSIZE_128BIT	3
 
 static struct _keydata {
 	bool valid;
+	bool hwrand;
 	struct reg_128_bit value[KEYSIZE_128BIT];
 } keydata;
 
 /**
  * make_keylocker_data() - Generate the internal key.
+ * @use_hwrand:	True if use hardware randomization; otherwise, false.
  *
  * Return:	Nothing
  */
-static void make_keylocker_data(void)
+static void make_keylocker_data(bool use_hwrand)
 {
 	int i;
 
 	for (i = 0; i < KEYSIZE_128BIT; i++)
 		get_random_bytes(&keydata.value[i], sizeof(struct reg_128_bit));
 
+	keydata.hwrand = (use_hwrand && keyhwrand_available && keybackup_available);
+	if (use_hwrand && !keydata.hwrand)
+		pr_warn("x86/keylocker: hardware random key is not fully supported\n");
+
 	keydata.valid = true;
 }
 
@@ -59,6 +67,8 @@ void flush_keylocker_data(void)
 }
 
 #define KEYSRC_SWRAND		0
+#define KEYSRC_HWRAND		BIT(1)
+#define KEYSRC_HWRAND_RETRY	10
 
 /**
  * load_keylocker() - Load the internal key.
@@ -68,8 +78,16 @@ void flush_keylocker_data(void)
 static int load_keylocker(void)
 {
 	struct reg_128_bit zeros = { 0 };
-	u32 keysrc = KEYSRC_SWRAND;
-	int err;
+	int retry, err;
+	u32 keysrc;
+
+	if (keydata.hwrand) {
+		keysrc = KEYSRC_HWRAND;
+		retry = KEYSRC_HWRAND_RETRY;
+	} else {
+		keysrc = KEYSRC_SWRAND;
+		retry = 0;
+	}
 
 	kernel_fpu_begin();
 
@@ -78,13 +96,19 @@ static int load_keylocker(void)
 			 "m"(keydata.value[1]),
 			 "m"(keydata.value[2]));
 
-	err = loadiwkey(keysrc);
+	do {
+		err = loadiwkey(keysrc);
+		retry--;
+	} while (err && retry >= 0);
 
 	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
 		      :: "m"(zeros));
 
 	kernel_fpu_end();
 
+	if (keydata.hwrand)
+		flush_keylocker_data();
+
 	return err;
 }
 
@@ -138,6 +162,7 @@ void setup_keylocker(struct cpuinfo_x86 *c)
 	cr4_set_bits(X86_CR4_KEYLOCKER);
 
 	if (c == &boot_cpu_data) {
+		bool use_hwrand = check_random_trust_cpu();
 		u32 eax, ebx, ecx, edx;
 
 		cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
@@ -156,7 +181,9 @@ void setup_keylocker(struct cpuinfo_x86 *c)
 			goto disable;
 		}
 
-		make_keylocker_data();
+		keyhwrand_available = (ecx & KEYLOCKER_CPUID_ECX_RAND);
+
+		make_keylocker_data(use_hwrand);
 
 		err = load_keylocker();
 		if (err) {
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..a3ece5968497 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -771,6 +771,12 @@ static int __init parse_trust_cpu(char *arg)
 }
 early_param("random.trust_cpu", parse_trust_cpu);
 
+bool check_random_trust_cpu(void)
+{
+	return trust_cpu;
+}
+EXPORT_SYMBOL(check_random_trust_cpu);
+
 static bool crng_init_try_arch(struct crng_state *crng)
 {
 	int		i;
diff --git a/include/linux/random.h b/include/linux/random.h
index f45b8be3e3c4..f08f44988b13 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -158,4 +158,6 @@ static inline bool __init arch_get_random_long_early(unsigned long *v)
 }
 #endif
 
+extern bool check_random_trust_cpu(void);
+
 #endif /* _LINUX_RANDOM_H */
-- 
2.17.1

