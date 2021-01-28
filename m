Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42ECFC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FB264DD8
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhA1NHY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhA1NHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 08:07:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F0764DDD;
        Thu, 28 Jan 2021 13:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611839202;
        bh=r/Ns1W+DufnkR/AI4Ek7TWkmmUH/izqWzKydAUbFutI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDdH+RJPhMcBwtNS7QN7GrRc2/CnjOmoJsz7k4CQe9smEI1tMazhUJ1yaQxrdk03t
         TN+h9R0mR1Llmr1sWO/aiBcjlpV3dQsaDgq4Sh2yn/IC+fVEJbyjDyVICx6ONwbwMj
         LJ+xfl3ZcV4WmCbuEeYFr6IO9wpM7HpwulQMUZmOgLzYDh5d6lcxN1vmTFrbG6W8xy
         Tz1AGIxJAki4vjVyt2IfiSJZYPv1lQQ43+QAjtB9UIQtFz0HMccsIyYTSvo3m5b648
         cFtpRcH3piNvEkTQDKdKv0oKGJCqqLaRpSUSu1z9EjnUOJhzZB5N0OTdKFTaszY7hX
         utQKeErSvP90Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/9] arm64: assembler: add cond_yield macro
Date:   Thu, 28 Jan 2021 14:06:17 +0100
Message-Id: <20210128130625.54076-2-ardb@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128130625.54076-1-ardb@kernel.org>
References: <20210128130625.54076-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a macro cond_yield that branches to a specified label when called if
the TIF_NEED_RESCHED flag is set and decreasing the preempt count would
make the task preemptible again, resulting in a schedule to occur. This
can be used by kernel mode SIMD code that keeps a lot of state in SIMD
registers, which would make chunking the input in order to perform the
cond_resched() check from C code disproportionately costly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index bf125c591116..5f977a7c6b43 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -745,6 +745,22 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 .Lyield_out_\@ :
 	.endm
 
+	/*
+	 * Check whether preempt-disabled code should yield as soon as it
+	 * is able. This is the case if re-enabling preemption a single
+	 * time results in a preempt count of zero, and the TIF_NEED_RESCHED
+	 * flag is set. (Note that the latter is stored negated in the
+	 * top word of the thread_info::preempt_count field)
+	 */
+	.macro		cond_yield, lbl:req, tmp:req
+#ifdef CONFIG_PREEMPTION
+	get_current_task \tmp
+	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
+	cmp		\tmp, #PREEMPT_DISABLE_OFFSET
+	beq		\lbl
+#endif
+	.endm
+
 /*
  * This macro emits a program property note section identifying
  * architecture features which require special handling, mainly for
-- 
2.29.2

