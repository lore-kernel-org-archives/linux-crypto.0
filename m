Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE05C4361B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2498424D45
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgLPRrE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:47:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:21271 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgLPRrD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:47:03 -0500
IronPort-SDR: K3nTCLNCBG9scbCgDKFw1y5zWbWGu3QpoqbYpgrkNNthHxAB5GlG0nmyEJnIE6lmDG2YZ5+Llw
 R/LmIf6ZDhoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171593410"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="171593410"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:10 -0800
IronPort-SDR: CswevTuAltLLcorHxfxDrSrxs6CfJ69SKuDxN29ceLCUBc2xoe1i8kC2+C/TLIABczSY2ppds8
 GLvpNwey9jVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854193"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:10 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH 3/8] x86/msr-index: Add MSRs for Key Locker internal key
Date:   Wed, 16 Dec 2020 09:41:41 -0800
Message-Id: <20201216174146.10446-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216174146.10446-1-chang.seok.bae@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Key Locker internal key in a CPU state can be backed up in a platform
register. The backup can be also copied back to a CPU state. This mechanism
is useful to restore the key (after system sleep).

Add MSRs for the internal key backup, copy, and status check.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/msr-index.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 972a34d93505..c0b9157806f7 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -922,4 +922,10 @@
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+/* MSRs for Key Locker Internal (Wrapping) Key management */
+#define MSR_IA32_COPY_LOCAL_TO_PLATFORM	0x00000d91
+#define MSR_IA32_COPY_PLATFORM_TO_LOCAL	0x00000d92
+#define MSR_IA32_COPY_STATUS		0x00000990
+#define MSR_IA32_IWKEYBACKUP_STATUS	0x00000991
+
 #endif /* _ASM_X86_MSR_INDEX_H */
-- 
2.17.1

