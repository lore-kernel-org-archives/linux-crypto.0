From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 12/15] arm64/crypto: add shared macro to test for NEED_RESCHED
Date: Thu,  1 May 2014 17:51:23 +0200
Message-ID: <1398959486-8222-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43561 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEAPvh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:51:37 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so967327wiv.9
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:51:36 -0700 (PDT)
In-Reply-To: <1398959486-8222-1-git-send-email-ard.biesheuvel@linaro.org>
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
