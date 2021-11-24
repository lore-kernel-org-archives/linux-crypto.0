Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17B6C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Nov 2021 20:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351551AbhKXURd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:17:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:13501 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235074AbhKXUR2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Nov 2021 15:17:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="321601951"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="321601951"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:14:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510015799"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2021 12:14:18 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, bp@suse.de, dave.hansen@linux.intel.com,
        mingo@kernel.org, luto@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
        kumar.n.dwarakanath@intel.com, lalithambika.krishnakumar@intel.com,
        ravi.v.shankar@intel.com, chang.seok.bae@intel.com
Subject: [PATCH v3 05/15] x86/msr-index: Add MSRs for Key Locker internal wrapping key
Date:   Wed, 24 Nov 2021 12:06:50 -0800
Message-Id: <20211124200700.15888-6-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124200700.15888-1-chang.seok.bae@intel.com>
References: <20211124200700.15888-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CPU state that contains the internal wrapping key is in the same power
domain as the cache. So any sleep state that would invalidate the cache
(like S3) also invalidates the state of the wrapping key.

But, since the state is inaccessible to software, it needs a special
mechanism to save and restore the key during deep sleep.

A set of new MSRs are provided as an abstract interface to save and restore
the wrapping key, and to check the key status.

The wrapping key is saved in a platform-scoped state of non-volatile media.
The backup itself and its path from the CPU are encrypted and integrity
protected.

But this storage's non-volatility is not architecturally guaranteed across
off states, such as S5 and G3.

The MSRs will be used to back up the key for S3/4 sleep states. Then the
kernel code writes one of them to restore the key in each CPU state.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v2:
* Update the changelog. (Dan Williams)
* Rename the MSRs. (Dan Williams)
---
 arch/x86/include/asm/msr-index.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 01e2650b9585..7f11a3b3a75b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -941,4 +941,10 @@
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+/* MSRs for managing an internal wrapping key for Key Locker. */
+#define MSR_IA32_IWKEY_COPY_STATUS		0x00000990
+#define MSR_IA32_IWKEY_BACKUP_STATUS		0x00000991
+#define MSR_IA32_BACKUP_IWKEY_TO_PLATFORM	0x00000d91
+#define MSR_IA32_COPY_IWKEY_TO_LOCAL		0x00000d92
+
 #endif /* _ASM_X86_MSR_INDEX_H */
-- 
2.17.1

