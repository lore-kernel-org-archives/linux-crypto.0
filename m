Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FC5C43600
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282AA61221
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhENUVy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:16073 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhENUVw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:52 -0400
IronPort-SDR: tIh8XyzJccQjgVYnxFdfnSB+zUZGYJNLr3/kyQphGi7pO7LEEdNhj0QhgGGCd54oYa4E0MKLoI
 mNUrlsFA9Jcg==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921589"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921589"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:36 -0700
IronPort-SDR: fxmkGVWNesbentQ4qBTmI2CcIAe5+kvl6c0wjeqbQjI/mu+qd9YBV5CZ3FDIzHm/1S76LxkQ/+
 CZKX+Z4XIyZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147169"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:36 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 04/11] x86/msr-index: Add MSRs for Key Locker internal key
Date:   Fri, 14 May 2021 13:15:01 -0700
Message-Id: <20210514201508.27967-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210514201508.27967-1-chang.seok.bae@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
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
index 742d89a00721..f8e78782c8f4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -935,4 +935,10 @@
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

