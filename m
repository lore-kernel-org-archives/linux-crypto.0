Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB42AC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB6361460
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhENUV4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:16070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233008AbhENUVw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:52 -0400
IronPort-SDR: bWO3tqoUDaz1abDlLVzJ4Na2+9UCw0eKHuNElZj3diDTMlfs8MfLFduT5kB8dYjUqSquPjtAjh
 2W4f//8Cse8w==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921592"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921592"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:37 -0700
IronPort-SDR: PENpovH2k+3B1gl75FEYU68QMWaA7N8r8mm1bAC8cweXNONJq1/xuiTfwhrloOeEexext0cqWC
 E6q6+7iTKxyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147177"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:36 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com,
        linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 06/11] x86/cpu: Add a config option and a chicken bit for Key Locker
Date:   Fri, 14 May 2021 13:15:03 -0700
Message-Id: <20210514201508.27967-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a kernel config option to enable the feature (disabled by default) at
compile-time.

Also, add a new command-line parameter -- 'nokeylocker' to disable the
feature at boot-time.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/x86/Kconfig                                | 14 ++++++++++++++
 arch/x86/kernel/cpu/common.c                    | 16 ++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb89dbdedc46..d0afe36c1802 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3284,6 +3284,8 @@
 
 	nohugevmalloc	[PPC] Disable kernel huge vmalloc mappings.
 
+	nokeylocker	[X86] Disables Key Locker hardware feature.
+
 	nosmt		[KNL,S390] Disable symmetric multithreading (SMT).
 			Equivalent to smt=1.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0045e1b44190..de8eeb705ed8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1885,6 +1885,20 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_KEYLOCKER
+	prompt "Key Locker"
+	def_bool n
+	depends on CPU_SUP_INTEL
+	help
+	  Key Locker is a new security feature to protect data encryption
+	  keys for the Advanced Encryption Standard (AES) algorithm.
+
+	  When enabled, every CPU has a unique internal key to wrap AES
+	  keys in an encoded format.  The internal key is not accessible
+	  to software once loaded.
+
+	  If unsure, say y.
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2e64371acb81..c655cce30c2b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -353,6 +353,22 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 /* These bits should not change their value after CPU init is finished. */
 static const unsigned long cr4_pinned_mask =
 	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
+
+static __init int x86_nokeylocker_setup(char *arg)
+{
+	/* Expect an exact match without trailing characters. */
+	if (strlen(arg))
+		return 0;
+
+	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
+		return 1;
+
+	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
+	pr_info("x86/keylocker: Disabled by kernel command line.\n");
+	return 1;
+}
+__setup("nokeylocker", x86_nokeylocker_setup);
+
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
-- 
2.17.1

