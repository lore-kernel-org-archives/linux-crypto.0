Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A371C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B54161480
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhENUVv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:16070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhENUVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:46 -0400
IronPort-SDR: ozx4UuUzySV8X7Hi3fS3xV0MrOepyt1CV6U9ozjQCq1KVlntSJJ4hphygIJaiO148velbXySms
 n9omXINk4zCw==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921578"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921578"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:33 -0700
IronPort-SDR: R5zDJJEHoqtoSHdw7toPBPOEISIs+NVl/kEYiyfdxsdRKXH1v05oxWYPGjnENsSvTvzFPUZUWJ
 cKIeWMWY1jgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147153"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:33 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 01/11] x86/cpufeature: Enumerate Key Locker feature
Date:   Fri, 14 May 2021 13:14:58 -0700
Message-Id: <20210514201508.27967-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Intel's Key Locker is a new security feature providing a mechanism to
protect data encryption keys when processing the Advanced Encryption
Standard (AES) algorithm.

The feature accompanies new AES instructions as a successor to Intel's AES
New Instructions (AES-NI). It also follows AES-NI's other feature
dependency.

Here add it to enumerate the hardware capability, shown as 'keylocker' in
/proc/cpuinfo.

Define the feature-specific CPUID leaf and bits for the feature enablement.

Add X86_FEATURE_KEYLOCKER to the disabled features mask for the use of
compile-time configuration.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v1:
* Updated the changelog.
---
 arch/x86/include/asm/cpufeatures.h          |  1 +
 arch/x86/include/asm/disabled-features.h    |  8 +++++++-
 arch/x86/include/asm/keylocker.h            | 18 ++++++++++++++++++
 arch/x86/include/uapi/asm/processor-flags.h |  2 ++
 arch/x86/kernel/cpu/cpuid-deps.c            |  1 +
 5 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/keylocker.h

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ac37830ae941..578cf3fe7182 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -359,6 +359,7 @@
 #define X86_FEATURE_AVX512_VPOPCNTDQ	(16*32+14) /* POPCNT for vectors of DW/QW */
 #define X86_FEATURE_LA57		(16*32+16) /* 5-level page tables */
 #define X86_FEATURE_RDPID		(16*32+22) /* RDPID instruction */
+#define X86_FEATURE_KEYLOCKER		(16*32+23) /* Key Locker */
 #define X86_FEATURE_BUS_LOCK_DETECT	(16*32+24) /* Bus Lock detect */
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index b7dd944dc867..96acda147a50 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -44,6 +44,12 @@
 # define DISABLE_OSPKE		(1<<(X86_FEATURE_OSPKE & 31))
 #endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
 
+#ifdef CONFIG_X86_KEYLOCKER
+# define DISABLE_KEYLOCKER	0
+#else
+# define DISABLE_KEYLOCKER	(1<<(X86_FEATURE_KEYLOCKER & 31))
+#endif /* CONFIG_X86_KEYLOCKER */
+
 #ifdef CONFIG_X86_5LEVEL
 # define DISABLE_LA57	0
 #else
@@ -88,7 +94,7 @@
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
-			 DISABLE_ENQCMD)
+			 DISABLE_ENQCMD|DISABLE_KEYLOCKER)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK19	0
diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
new file mode 100644
index 000000000000..0597d6b1cd05
--- /dev/null
+++ b/arch/x86/include/asm/keylocker.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_KEYLOCKER_H
+#define _ASM_KEYLOCKER_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/bits.h>
+
+#define KEYLOCKER_CPUID			0x019
+#define KEYLOCKER_CPUID_EAX_SUPERVISOR	BIT(0)
+#define KEYLOCKER_CPUID_EBX_AESKLE	BIT(0)
+#define KEYLOCKER_CPUID_EBX_WIDE	BIT(2)
+#define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
+#define KEYLOCKER_CPUID_ECX_RAND	BIT(1)
+
+#endif /*__ASSEMBLY__ */
+#endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index bcba3c643e63..b958a95a0908 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -124,6 +124,8 @@
 #define X86_CR4_PCIDE		_BITUL(X86_CR4_PCIDE_BIT)
 #define X86_CR4_OSXSAVE_BIT	18 /* enable xsave and xrestore */
 #define X86_CR4_OSXSAVE		_BITUL(X86_CR4_OSXSAVE_BIT)
+#define X86_CR4_KEYLOCKER_BIT	19 /* enable Key Locker */
+#define X86_CR4_KEYLOCKER	_BITUL(X86_CR4_KEYLOCKER_BIT)
 #define X86_CR4_SMEP_BIT	20 /* enable SMEP support */
 #define X86_CR4_SMEP		_BITUL(X86_CR4_SMEP_BIT)
 #define X86_CR4_SMAP_BIT	21 /* enable SMAP support */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index defda61f372d..ce2020b9ff4d 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -75,6 +75,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
 	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
+	{ X86_FEATURE_KEYLOCKER,		X86_FEATURE_XMM2      },
 	{}
 };
 
-- 
2.17.1

