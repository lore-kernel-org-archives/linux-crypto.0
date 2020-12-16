Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C46C0018C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6CB24CEE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgLPRqv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:46:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:21277 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgLPRqv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:46:51 -0500
IronPort-SDR: FHCNSNE+EbSxvLK81ZjDgvPD40DAJBsx3JcAA/ak3+AGx6Bl37qNo0r2Me1uuPNUdg+3WTolAI
 XkXZyl1dlKQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171593386"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="171593386"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:08 -0800
IronPort-SDR: vc/gIUBXwr+CriwiA/LGCx4DIQieb5+v7dbpC2fRljcRg+wxfdMrtM8XuvCifKgpZLYhKgqEuM
 MfVCquXvf66A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854176"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:08 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH 1/8] x86/cpufeature: Enumerate Key Locker feature
Date:   Wed, 16 Dec 2020 09:41:39 -0800
Message-Id: <20201216174146.10446-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Intel's Key Locker is a new security feature providing a mechanism to
protect a data encryption key when processing the Advanced Encryption
Standard algorithm.

Here we add it to the kernel/user ABI by enumerating the hardware
capability. E.g., /proc/cpuinfo: keylocker.

Also, define the feature-specific CPUID leaf and bits for the feature
enablement.

Key Locker is on the disabled list, which is useful for compile-time
configuration later.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/cpufeatures.h          |  1 +
 arch/x86/include/asm/disabled-features.h    |  8 +++++++-
 arch/x86/include/asm/keylocker.h            | 18 ++++++++++++++++++
 arch/x86/include/uapi/asm/processor-flags.h |  2 ++
 arch/x86/kernel/cpu/cpuid-deps.c            |  1 +
 5 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/keylocker.h

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dad350d42ecf..8f2f050023b7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -352,6 +352,7 @@
 #define X86_FEATURE_AVX512_VPOPCNTDQ	(16*32+14) /* POPCNT for vectors of DW/QW */
 #define X86_FEATURE_LA57		(16*32+16) /* 5-level page tables */
 #define X86_FEATURE_RDPID		(16*32+22) /* RDPID instruction */
+#define X86_FEATURE_KEYLOCKER		(16*32+23) /* Key Locker */
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
 #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 5861d34f9771..0ac9414da242 100644
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
@@ -82,7 +88,7 @@
 #define DISABLED_MASK14	0
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
-			 DISABLE_ENQCMD)
+			 DISABLE_ENQCMD|DISABLE_KEYLOCKER)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
new file mode 100644
index 000000000000..2fe13c21c63f
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
+#define KEYLOCKER_CPUID                0x019
+#define KEYLOCKER_CPUID_EAX_SUPERVISOR BIT(0)
+#define KEYLOCKER_CPUID_EBX_AESKLE     BIT(0)
+#define KEYLOCKER_CPUID_EBX_WIDE       BIT(2)
+#define KEYLOCKER_CPUID_EBX_BACKUP     BIT(4)
+#define KEYLOCKER_CPUID_ECX_RAND       BIT(1)
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
index d502241995a3..b8edcb91fe4f 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -71,6 +71,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
+	{ X86_FEATURE_KEYLOCKER,		X86_FEATURE_XMM2      },
 	{}
 };
 
-- 
2.17.1

