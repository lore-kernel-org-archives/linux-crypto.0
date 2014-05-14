From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 08/11] arm64/crypto: add shared macro to test for NEED_RESCHED
Date: Wed, 14 May 2014 11:17:28 -0700
Message-ID: <1400091451-9117-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:38919 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaENSR7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 14:17:59 -0400
Received: by mail-yk0-f176.google.com with SMTP id q9so1896509ykb.35
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 11:17:59 -0700 (PDT)
In-Reply-To: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the asm macro definition 'b_if_no_resched' that performs a conditional
branch depending on the preempt need_resched state.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index fd3e3924041b..296105fd3021 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -22,6 +22,11 @@
 
 #include <asm/ptrace.h>
 
+#if defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_VOLUNTARY)
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#endif
+
 /*
  * Stack pushing/popping (register pairs only). Equivalent to store decrement
  * before, load increment after.
@@ -146,3 +151,19 @@ lr	.req	x30		// link register
 #endif
 	orr	\rd, \lbits, \hbits, lsl #32
 	.endm
+
+/*
+ * Branch to 'lb' but only if we have not been tagged for preemption.
+ *
+ * Expects current->thread_info in ti, or NULL if running in interrupt
+ * context. reg is a scratch x register.
+ */
+	.macro		b_if_no_resched, ti, reg, lb
+#if defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_VOLUNTARY)
+	cbz		\ti, \lb			/* have thread_info? */
+	ldr		\reg, [\ti, #TI_FLAGS]		/* get flags */
+	tbz		\reg, #TIF_NEED_RESCHED, \lb	/* need rescheduling? */
+#else
+	b		\lb
+#endif
+	.endm
-- 
1.8.3.2
