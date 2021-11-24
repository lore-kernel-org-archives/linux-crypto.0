Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC2CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Nov 2021 20:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351530AbhKXURd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:17:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:13498 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343502AbhKXUR2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Nov 2021 15:17:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="321601948"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="321601948"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:14:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510015794"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2021 12:14:17 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, bp@suse.de, dave.hansen@linux.intel.com,
        mingo@kernel.org, luto@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
        kumar.n.dwarakanath@intel.com, lalithambika.krishnakumar@intel.com,
        ravi.v.shankar@intel.com, chang.seok.bae@intel.com
Subject: [PATCH v3 04/15] x86/asm: Add a wrapper function for the LOADIWKEY instruction
Date:   Wed, 24 Nov 2021 12:06:49 -0800
Message-Id: <20211124200700.15888-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124200700.15888-1-chang.seok.bae@intel.com>
References: <20211124200700.15888-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Key Locker introduces a CPU-internal wrapping key to encode a user key to a
key handle. Then a key handle is referenced instead of the plain text key.

The new instruction loads an internal wrapping key in the
software-inaccessible CPU state. It operates only in kernel mode.

Define struct iwkey to pass the key value.

The kernel will use this function to load a new key at boot time when the
feature is enabled.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v2:
* Separate out the code as a new patch.
* Improve the usability with the new struct as an argument. (Dan Williams)

Note, Dan wondered if:
  WARN_ON(!irq_fpu_usable());
would be appropriate in the load_xmm_iwkey() function.
---
 arch/x86/include/asm/keylocker.h     | 25 +++++++++++++++++++++
 arch/x86/include/asm/special_insns.h | 33 ++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 arch/x86/include/asm/keylocker.h

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
new file mode 100644
index 000000000000..df84c83228a1
--- /dev/null
+++ b/arch/x86/include/asm/keylocker.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_KEYLOCKER_H
+#define _ASM_KEYLOCKER_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/fpu/types.h>
+
+/**
+ * struct iwkey - A temporary internal wrapping key storage.
+ * @integrity_key:	A 128-bit key to check that key handles have not
+ *			been tampered with.
+ * @encryption_key:	A 256-bit encryption key used in
+ *			wrapping/unwrapping a clear text key.
+ *
+ * This storage should be flushed immediately after loaded.
+ */
+struct iwkey {
+	struct reg_128_bit integrity_key;
+	struct reg_128_bit encryption_key[2];
+};
+
+#endif /*__ASSEMBLY__ */
+#endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 68c257a3de0d..e6469b05facf 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -9,6 +9,7 @@
 #include <asm/processor-flags.h>
 #include <linux/irqflags.h>
 #include <linux/jump_label.h>
+#include <asm/keylocker.h>
 
 /*
  * The compiler should not reorder volatile asm statements with respect to each
@@ -294,6 +295,38 @@ static inline int enqcmds(void __iomem *dst, const void *src)
 	return 0;
 }
 
+
+/**
+ * load_xmm_iwkey - Load a CPU-internal wrapping key
+ * @key:	A struct iwkey pointer.
+ *
+ * Load @key to XMMs then do LOADIWKEY. After this, flush XMM
+ * registers. Caller is responsible for kernel_cpu_begin().
+ */
+static inline void load_xmm_iwkey(struct iwkey *key)
+{
+	struct reg_128_bit zeros = { 0 };
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %1, %%xmm1; movdqu %2, %%xmm2;"
+		      :: "m"(key->integrity_key), "m"(key->encryption_key[0]),
+			 "m"(key->encryption_key[1]));
+
+	/*
+	 * LOADIWKEY %xmm1,%xmm2
+	 *
+	 * EAX and XMM0 are implicit operands. Load a key value
+	 * from XMM0-2 to a software-invisible CPU state. With zero
+	 * in EAX, CPU does not do hardware randomization and the key
+	 * backup is allowed.
+	 *
+	 * This instruction is supported by binutils >= 2.36.
+	 */
+	asm volatile (".byte 0xf3,0x0f,0x38,0xdc,0xd1" :: "a"(0));
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
+		      :: "m"(zeros));
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_SPECIAL_INSNS_H */
-- 
2.17.1

