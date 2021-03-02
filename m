Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CFAC433E9
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C821364E09
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhCCB2B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:28:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378846AbhCBJD0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:03:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE96F64F1C;
        Tue,  2 Mar 2021 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675730;
        bh=+8/amx78XnT3phJYFPkWg+4HyRdJSZCf39NO8o5pcWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuP0f6bCYBp6uHUoB85T03BnK7/oBabeY+Z8D7E2gvi6KCrHoI58xxfQZ6Js6JnvL
         eddiEv8HXoW/7VJvWTz8ORGVfCd9WoWJnU42aeyZex/1Wgqj8TNNEdK6DPsVD4OJ0Y
         AqtMW0igUvRqNITSeuOJMzbDMeem3Pi9dCKfstYyRlYknGIeqnghyWhePdwWX5lsAe
         VsNwxBcHp1LVCriEVnpNyl0TTO5/46aPrxFOXWXWXQaZ8Advu7lOSpfNEwI8vJylIU
         pM9k7j4/l0RG2em/VIPY+kt9T9yJIuWiONdkou2CYylkXJrYhOPBjVOznHBbqJuvly
         cSyvrc+KXec2w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 3/9] arm64: fpsimd: run kernel mode NEON with softirqs disabled
Date:   Tue,  2 Mar 2021 10:01:12 +0100
Message-Id: <20210302090118.30666-4-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kernel mode NEON can be used in task or softirq context, but only in
a non-nesting manner, i.e., softirq context is only permitted if the
interrupt was not taken at a point where the kernel was using the NEON
in task context.

This means all users of kernel mode NEON have to be aware of this
limitation, and either need to provide scalar fallbacks that may be much
slower (up to 20x for AES instructions) and potentially less safe, or
use an asynchronous interface that defers processing to a later time
when the NEON is guaranteed to be available.

Given that grabbing and releasing the NEON is cheap, we can relax this
restriction, by increasing the granularity of kernel mode NEON code, and
always disabling softirq processing while the NEON is being used in task
context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-modes.S      |  2 +-
 arch/arm64/crypto/sha1-ce-core.S   |  2 +-
 arch/arm64/crypto/sha2-ce-core.S   |  2 +-
 arch/arm64/crypto/sha3-ce-core.S   |  4 +--
 arch/arm64/crypto/sha512-ce-core.S |  2 +-
 arch/arm64/include/asm/assembler.h | 28 +++++++++++++++-----
 arch/arm64/kernel/asm-offsets.c    |  2 ++
 arch/arm64/kernel/fpsimd.c         |  4 +--
 8 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index bbdb54702aa7..ab6c14ef9f4e 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -700,7 +700,7 @@ AES_FUNC_START(aes_mac_update)
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
-	cond_yield	.Lmacout, x7
+	cond_yield	.Lmacout, x7, x8
 	b		.Lmacloop4x
 .Lmac1x:
 	add		w3, w3, #4
diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 8c02bbc2684e..889ca0f8972b 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -121,7 +121,7 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	add		dgav.4s, dgav.4s, dg0v.4s
 
 	cbz		w2, 2f
-	cond_yield	3f, x5
+	cond_yield	3f, x5, x6
 	b		0b
 
 	/*
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 6cdea7d56059..491179922f49 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -129,7 +129,7 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 
 	/* handled all input blocks? */
 	cbz		w2, 2f
-	cond_yield	3f, x5
+	cond_yield	3f, x5, x6
 	b		0b
 
 	/*
diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 6f5208414fe3..9c77313f5a60 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -184,11 +184,11 @@ SYM_FUNC_START(sha3_ce_transform)
 	eor	 v0.16b,  v0.16b, v31.16b
 
 	cbnz	w8, 3b
-	cond_yield 3f, x8
+	cond_yield 4f, x8, x9
 	cbnz	w2, 0b
 
 	/* save state */
-3:	st1	{ v0.1d- v3.1d}, [x0], #32
+4:	st1	{ v0.1d- v3.1d}, [x0], #32
 	st1	{ v4.1d- v7.1d}, [x0], #32
 	st1	{ v8.1d-v11.1d}, [x0], #32
 	st1	{v12.1d-v15.1d}, [x0], #32
diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index d6e7f6c95fa6..b6a3a36e15f5 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -195,7 +195,7 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 	add		v10.2d, v10.2d, v2.2d
 	add		v11.2d, v11.2d, v3.2d
 
-	cond_yield	3f, x4
+	cond_yield	3f, x4, x5
 	/* handled all input blocks? */
 	cbnz		w2, 0b
 
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 7b076ccd1a54..6ac38f7cf824 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -15,6 +15,7 @@
 #include <asm-generic/export.h>
 
 #include <asm/asm-offsets.h>
+#include <asm/alternative.h>
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
@@ -701,19 +702,32 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 .endm
 
 	/*
-	 * Check whether preempt-disabled code should yield as soon as it
-	 * is able. This is the case if re-enabling preemption a single
-	 * time results in a preempt count of zero, and the TIF_NEED_RESCHED
-	 * flag is set. (Note that the latter is stored negated in the
-	 * top word of the thread_info::preempt_count field)
+	 * Check whether preempt/bh-disabled asm code should yield as soon as
+	 * it is able. This is the case if we are currently running in task
+	 * context, and either a softirq is pending, or the TIF_NEED_RESCHED
+	 * flag is set and re-enabling preemption a single time would result in
+	 * a preempt count of zero. (Note that the TIF_NEED_RESCHED flag is
+	 * stored negated in the top word of the thread_info::preempt_count
+	 * field)
 	 */
-	.macro		cond_yield, lbl:req, tmp:req
-#ifdef CONFIG_PREEMPTION
+	.macro		cond_yield, lbl:req, tmp:req, tmp2:req
 	get_current_task \tmp
 	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
+	/*
+	 * If we are serving a softirq, there is no point in yielding: the
+	 * softirq will not be preempted no matter what we do, so we should
+	 * run to completion as quickly as we can.
+	 */
+	tbnz		\tmp, #SOFTIRQ_SHIFT, .Lnoyield_\@
+#ifdef CONFIG_PREEMPTION
 	sub		\tmp, \tmp, #PREEMPT_DISABLE_OFFSET
 	cbz		\tmp, \lbl
 #endif
+	adr_l		\tmp, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
+	this_cpu_offset	\tmp2
+	ldr		w\tmp, [\tmp, \tmp2]
+	cbnz		w\tmp, \lbl	// yield on pending softirq in task context
+.Lnoyield_\@:
 	.endm
 
 /*
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index a36e2fc330d4..cc7267a24bf7 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -95,6 +95,8 @@ int main(void)
   DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
   BLANK();
   DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
+  DEFINE(SOFTIRQ_SHIFT, SOFTIRQ_SHIFT);
+  DEFINE(IRQ_CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
   BLANK();
   DEFINE(CPU_BOOT_STACK,	offsetof(struct secondary_data, stack));
   DEFINE(CPU_BOOT_TASK,		offsetof(struct secondary_data, task));
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 062b21f30f94..823e3a8a8871 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -180,7 +180,7 @@ static void __get_cpu_fpsimd_context(void)
  */
 static void get_cpu_fpsimd_context(void)
 {
-	preempt_disable();
+	local_bh_disable();
 	__get_cpu_fpsimd_context();
 }
 
@@ -201,7 +201,7 @@ static void __put_cpu_fpsimd_context(void)
 static void put_cpu_fpsimd_context(void)
 {
 	__put_cpu_fpsimd_context();
-	preempt_enable();
+	local_bh_enable();
 }
 
 static bool have_cpu_fpsimd_context(void)
-- 
2.30.1

