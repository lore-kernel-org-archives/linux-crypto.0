Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECB8C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 18:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35AD23DE3
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 18:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbgLJSN0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 13:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404103AbgLJSMs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 13:12:48 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Greear <greearb@candelatech.com>
Subject: [RFC PATCH 1/3] ARM: vfp: allow kernel mode NEON in softirq context
Date:   Thu, 10 Dec 2020 19:11:56 +0100
Message-Id: <20201210181158.28960-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210181158.28960-1-ardb@kernel.org>
References: <20201210181158.28960-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow kernel mode NEON to be used in softirq context as well as process
context. To avoid nested use of the NEON, which would require the kernel
mode process context NEON state to be preserved while the NEON is used in
softirq context, turn off softirq processing when enabling kernel mode NEON.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/simd.h | 12 ++++++++++++
 arch/arm/vfp/vfpmodule.c    | 11 +++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/simd.h b/arch/arm/include/asm/simd.h
new file mode 100644
index 000000000000..0f44f0d9df4a
--- /dev/null
+++ b/arch/arm/include/asm/simd.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/hardirq.h>
+
+/*
+ * may_use_simd - whether it is allowable at this time to issue SIMD
+ *                instructions or access the SIMD register file
+ */
+static __must_check inline bool may_use_simd(void)
+{
+	return !in_irq() && !irqs_disabled() && !in_nmi();
+}
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index c3b6451c18bd..849703571ffa 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -21,6 +21,7 @@
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
+#include <asm/simd.h>
 #include <asm/system_info.h>
 #include <asm/thread_notify.h>
 #include <asm/traps.h>
@@ -719,12 +720,13 @@ void kernel_neon_begin(void)
 	u32 fpexc;
 
 	/*
-	 * Kernel mode NEON is only allowed outside of interrupt context
-	 * with preemption disabled. This will make sure that the kernel
-	 * mode NEON register contents never need to be preserved.
+	 * Kernel mode NEON is only allowed outside of hard interrupt context
+	 * with preemption and softirq processing disabled. This ensures that
+	 * the kernel mode NEON register contents never need to be preserved.
 	 */
-	BUG_ON(in_interrupt());
+	BUG_ON(!may_use_simd());
 	cpu = get_cpu();
+	local_bh_disable();
 
 	fpexc = fmrx(FPEXC) | FPEXC_EN;
 	fmxr(FPEXC, fpexc);
@@ -747,6 +749,7 @@ void kernel_neon_end(void)
 {
 	/* Disable the NEON/VFP unit. */
 	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+	local_bh_enable();
 	put_cpu();
 }
 EXPORT_SYMBOL(kernel_neon_end);
-- 
2.17.1

