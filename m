Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACC5C433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F42E64F6A
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhBCLiw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhBCLiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A882E64F87;
        Wed,  3 Feb 2021 11:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352224;
        bh=9WYGO0Ce/rjFmylFoCfrBQhNHedSfUBNdsArJu9+1tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIqdmmDe0qrxU/y15QirT6ZYI1cZZtdR7zNuR5lKroaK3WjoLpnACsVyWHPqz11JP
         GlMz5Idh5immhWMTIlb4buelqHGwzRDuGBSjhpw+J0mcpeRpqF6eXsEaeg8cgzFwWH
         If/Y3eivAKA1pvFM6htj9PXWQqq2YyvDThRK6CvCPFvzRlJUc/sFEbhObEBzVALsap
         zKzxmsXcbSaI68rRW/bKgKXzAKuy00IeXrON8zRy8zx3Ykz8P4EvVUJWG4+gyQ2oji
         /dC1dqiPu67SftlqUWVhPAyYiCoNolZPIXh2/wqF4+THdHLGtFFB5NNfXNy3Dhvf63
         nzqHdPY73jHVg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 9/9] arm64: assembler: remove conditional NEON yield macros
Date:   Wed,  3 Feb 2021 12:36:26 +0100
Message-Id: <20210203113626.220151-10-ardb@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
References: <20210203113626.220151-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The users of the conditional NEON yield macros have all been switched to
the simplified cond_yield macro, and so the NEON specific ones can be
removed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 70 --------------------
 1 file changed, 70 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 27b1ea721c2d..0bb5829ff06f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -675,76 +675,6 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.endif
 	.endm
 
-/*
- * Check whether to yield to another runnable task from kernel mode NEON code
- * (which runs with preemption disabled).
- *
- * if_will_cond_yield_neon
- *        // pre-yield patchup code
- * do_cond_yield_neon
- *        // post-yield patchup code
- * endif_yield_neon    <label>
- *
- * where <label> is optional, and marks the point where execution will resume
- * after a yield has been performed. If omitted, execution resumes right after
- * the endif_yield_neon invocation. Note that the entire sequence, including
- * the provided patchup code, will be omitted from the image if
- * CONFIG_PREEMPTION is not defined.
- *
- * As a convenience, in the case where no patchup code is required, the above
- * sequence may be abbreviated to
- *
- * cond_yield_neon <label>
- *
- * Note that the patchup code does not support assembler directives that change
- * the output section, any use of such directives is undefined.
- *
- * The yield itself consists of the following:
- * - Check whether the preempt count is exactly 1 and a reschedule is also
- *   needed. If so, calling of preempt_enable() in kernel_neon_end() will
- *   trigger a reschedule. If it is not the case, yielding is pointless.
- * - Disable and re-enable kernel mode NEON, and branch to the yield fixup
- *   code.
- *
- * This macro sequence may clobber all CPU state that is not guaranteed by the
- * AAPCS to be preserved across an ordinary function call.
- */
-
-	.macro		cond_yield_neon, lbl
-	if_will_cond_yield_neon
-	do_cond_yield_neon
-	endif_yield_neon	\lbl
-	.endm
-
-	.macro		if_will_cond_yield_neon
-#ifdef CONFIG_PREEMPTION
-	get_current_task	x0
-	ldr		x0, [x0, #TSK_TI_PREEMPT]
-	sub		x0, x0, #PREEMPT_DISABLE_OFFSET
-	cbz		x0, .Lyield_\@
-	/* fall through to endif_yield_neon */
-	.subsection	1
-.Lyield_\@ :
-#else
-	.section	".discard.cond_yield_neon", "ax"
-#endif
-	.endm
-
-	.macro		do_cond_yield_neon
-	bl		kernel_neon_end
-	bl		kernel_neon_begin
-	.endm
-
-	.macro		endif_yield_neon, lbl
-	.ifnb		\lbl
-	b		\lbl
-	.else
-	b		.Lyield_out_\@
-	.endif
-	.previous
-.Lyield_out_\@ :
-	.endm
-
 	/*
 	 * Check whether preempt-disabled code should yield as soon as it
 	 * is able. This is the case if re-enabling preemption a single
-- 
2.30.0

