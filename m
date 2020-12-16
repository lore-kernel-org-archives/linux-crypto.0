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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5B2C3526A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7A224CEE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgLPRq4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:46:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:47854 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgLPRqz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:46:55 -0500
IronPort-SDR: LY3Z26DK1FEwhmp7xe5AgpmZ7IxPalVshEHuLct1huOWi/OA39vsKt7bFxTJ+/hEjmGoqnB7Ao
 akO6lDjzZuXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="174334339"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="174334339"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:15 -0800
IronPort-SDR: 1Dtyu2ObXKQBTf8yYOrEa7eV6kN2H6QsYiIwMmQ3HxM5mLcAEkcXVp4P+UIVEKVrXVBV0OOifT
 BJ9ZIa7bAARw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854238"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:14 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com,
        Mark Brown <broonie@kernel.org>, linux-doc@vger.kernel.org
Subject: [RFC PATCH 8/8] x86/cpu: Support the hardware randomization option for Key Locker internal key
Date:   Wed, 16 Dec 2020 09:41:46 -0800
Message-Id: <20201216174146.10446-9-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hardware can load the internal key with randomization. random.trust_cpu
determines the use of the CPU's random number generator. Take the parameter
to use the CPU's internal key randomization.

The backup mechanism is required to distribute the key. It is the only
way to copy the (unknown) key value to other CPUs.

This randomization option is disabled when hardware does not support the
key backup.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: x86@kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/keylocker.h |  2 +-
 arch/x86/kernel/cpu/common.c     |  3 ++-
 arch/x86/kernel/keylocker.c      | 31 ++++++++++++++++++++++++++++---
 drivers/char/random.c            |  6 ++++++
 include/linux/random.h           |  2 ++
 5 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 722574c305c2..a6774ced916a 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -19,7 +19,7 @@ bool check_keylocker_readiness(void);
 
 bool load_keylocker(void);
 
-void make_keylocker_data(void);
+void make_keylocker_data(bool use_hwrand);
 #ifdef CONFIG_X86_KEYLOCKER
 void invalidate_keylocker_data(void);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ba5bd79fbac2..48881d8ea559 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -485,12 +485,13 @@ static __always_inline void setup_keylocker(struct cpuinfo_x86 *c)
 	cr4_set_bits(X86_CR4_KEYLOCKER);
 
 	if (c == &boot_cpu_data) {
+		bool use_hwrand = check_random_trust_cpu();
 		bool keyloaded;
 
 		if (!check_keylocker_readiness())
 			goto disable_keylocker;
 
-		make_keylocker_data();
+		make_keylocker_data(use_hwrand);
 
 		keyloaded = load_keylocker();
 		if (!keyloaded) {
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 229875ac80d5..e77e4c3d785e 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -13,6 +13,7 @@
 #include <asm/fpu/api.h>
 
 static bool keybackup_available;
+static bool keyhwrand_available;
 
 bool check_keylocker_readiness(void)
 {
@@ -33,25 +34,33 @@ bool check_keylocker_readiness(void)
 		pr_debug("x86/keylocker: no key backup support with possible S3/4\n");
 		return false;
 	}
+
+	keyhwrand_available = (ecx & KEYLOCKER_CPUID_ECX_RAND);
 	return true;
 }
 
 /* Load Internal (Wrapping) Key */
 #define LOADIWKEY		".byte 0xf3,0x0f,0x38,0xdc,0xd1"
 #define LOADIWKEY_NUM_OPERANDS	3
+#define LOADIWKEY_HWRAND_RETRY	10
 
 static struct key {
 	bool valid;
+	bool hwrand;
 	struct reg_128_bit value[LOADIWKEY_NUM_OPERANDS];
 } keydata;
 
-void make_keylocker_data(void)
+void make_keylocker_data(bool use_hwrand)
 {
 	int i;
 
 	for (i = 0; i < LOADIWKEY_NUM_OPERANDS; i++)
 		get_random_bytes(&keydata.value[i], sizeof(struct reg_128_bit));
 
+	keydata.hwrand = (use_hwrand && keyhwrand_available && keybackup_available);
+	if (use_hwrand && !keydata.hwrand)
+		pr_warn("x86/keylocker: hardware random key not fully supported\n");
+
 	keydata.valid = true;
 }
 
@@ -63,12 +72,22 @@ void invalidate_keylocker_data(void)
 }
 
 #define USE_SWKEY	0
+#define USE_HWRANDKEY	BIT(1)
 
 bool load_keylocker(void)
 {
 	struct reg_128_bit zeros = { 0 };
-	u32 keysrc = USE_SWKEY;
 	bool err = true;
+	u32 keysrc;
+	int retry;
+
+	if (keydata.hwrand) {
+		keysrc = USE_HWRANDKEY;
+		retry = LOADIWKEY_HWRAND_RETRY;
+	} else {
+		keysrc = USE_SWKEY;
+		retry = 0;
+	}
 
 	kernel_fpu_begin();
 
@@ -77,13 +96,19 @@ bool load_keylocker(void)
 			 "m"(keydata.value[1]),
 			 "m"(keydata.value[2]));
 
-	asm volatile (LOADIWKEY CC_SET(z) : CC_OUT(z) (err) : "a"(keysrc));
+	do {
+		asm volatile (LOADIWKEY CC_SET(z) : CC_OUT(z) (err) : "a"(keysrc));
+		retry--;
+	} while (err && retry >= 0);
 
 	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
 		      :: "m"(zeros));
 
 	kernel_fpu_end();
 
+	if (keydata.hwrand)
+		invalidate_keylocker_data();
+
 	return err ? false : true;
 }
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2a41b21623ae..3ee0d659ab2a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -781,6 +781,12 @@ static int __init parse_trust_cpu(char *arg)
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

