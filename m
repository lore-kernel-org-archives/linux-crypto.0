Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CA8C4332B
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA9764E34
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhBCLh0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234347AbhBCLhX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2292364F6A;
        Wed,  3 Feb 2021 11:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352203;
        bh=Xc42wbe+fvjMDLso7dVj/MJDqK9qPTmqNYGr08Z/sw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJUqzRNao28ge92zSxTOSRmt1sP3jV+1lcSkdVXRjk3Oq2dwbCITthYFAMK+KQUqp
         ZvRdBX9nvSo9ml+dt12FRdkDBOZSGYKdvBR2jnNBDokCpkK4QStuor4FTk661TiKCE
         TTZj6xKk1tEX51ToFCwLElD9gt4aLz8t2YpaBtHzRVZT8jjKgnDLD2Tj+5tH6dL9Gp
         Go+xCDSwnYyCmE9/94Du7QPt7VK4Y+jkJa7QYnCCyt7ziUjw8ZwAQW2XR+5G/rVkaU
         BfJYrJjq2e/YCfJpcbWbrjHKzImaIgVvFGRTIt+R9RNS74Tkyd9xGAndbwIFGZA/Zy
         uqF85HUlkWMng==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 1/9] arm64: assembler: add cond_yield macro
Date:   Wed,  3 Feb 2021 12:36:18 +0100
Message-Id: <20210203113626.220151-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
References: <20210203113626.220151-1-ardb@kernel.org>
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
index bf125c591116..27b1ea721c2d 100644
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
+	sub		\tmp, \tmp, #PREEMPT_DISABLE_OFFSET
+	cbz		\tmp, \lbl
+#endif
+	.endm
+
 /*
  * This macro emits a program property note section identifying
  * architecture features which require special handling, mainly for
-- 
2.30.0

