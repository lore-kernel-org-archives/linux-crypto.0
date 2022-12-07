Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064DAC352A1
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 10:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLGKj4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 05:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGKjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 05:39:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A361C7
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 02:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EAE3612B7
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 10:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D7C433D6;
        Wed,  7 Dec 2022 10:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670409591;
        bh=2VxWbj18Yrpe5S7MdQii2REpX63Y+WQlZ1akSuKTbsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVF2ccOkl1oWPKUYKUT0n+Lbqym3Fcte8F6bZY3OEhjj4bdd+Nz1n6oX89rVJ42cc
         gRhqKmHQTwZCSCp02c0AmIvkvCcmWr1Ui5+LnBCV2bxCEZmngtZCHdvU13kzIFhamk
         Vj6yO7H2kUG51JrbSUQWWsW1biCMsi+QR0HOvnQdYpj+S1EF2fMQpQe/tXXAfcQaVC
         EWkoIgt+Uf99nVWjfj+qf044i+XQSQXbMZcObE8c4Vy26dGcENxPunubyeTFKA/u4A
         vYBLHL6vC+ZH5jjxrw8n07NChOrA8S3InGcMluDJhjCEls8LxnKuvucFnvELXizCPD
         IgA4u8iqGOfbw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/2] ARM: vfp: Manipulate VFP state with softirqs disabled
Date:   Wed,  7 Dec 2022 11:39:35 +0100
Message-Id: <20221207103936.2198407-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207103936.2198407-1-ardb@kernel.org>
References: <20221207103936.2198407-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6070; i=ardb@kernel.org; h=from:subject; bh=2VxWbj18Yrpe5S7MdQii2REpX63Y+WQlZ1akSuKTbsc=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjkG1loJrT1eQlQs9RmMXqtJx12VX/eg+OQ017OEbd WD3YbwCJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5BtZQAKCRDDTyI5ktmPJF9lC/ 93/RQWHZSrUxfwec+zQAO2jz0rzX9AmfnV049ZoosEOyUQ6n0hrbuTvTIrkACzZTbUGnClyUDRM0EA /4BlywjCB5MgFD9p+mqhDaorYnPeNo/suji5V33iT/OfWNNJ0uRiSIf9baFFHt4wkBeNZ9LfcbFwGR 3hUIzKqZV46lX3vLajyRyfKmj4L87jzy5aJJh6UWaeEBv95hOu0s8aaKlzrBHkabQL/msgqr2Nvhfu HpwX3UHF34cYeh4Gtg3Huk63shYAARkZyyOy00bDYS195igGirVg645/NtVBPCu4VfMpCzG4SzWfVY ltW3RQ1OWaJrDRbbBdvlEbZ2oN2tLjDYY/aLdGKUbc5AZew5hAkwHLqpWDiD7S+pkS9+LBZcvt8Moj hS03VwDUavqUSNcMbpK5Nh0n10Fm/cTz6/FiY0YNAvwHktk/zyo3cZMHCoxB9Ymd4ysvvVlrnm4EFP 5fdaUpUF3A2DgmPBm5fhKUNj9n2jUyqQQ6m0VrRzbH84s=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In a subsequent patch, we will relax the kernel mode NEON policy, and
permit kernel mode NEON to be used not only from task context, as is
permitted today, but also from softirq context.

Given that softirqs may trigger over the back of any IRQ unless they are
explicitly disabled, we need to address the resulting races in the VFP
state handling, by disabling softirq processing in two distinct but
related cases:
- kernel mode NEON will leave the FPU disabled after it completes, so
  any kernel code sequence that enables the FPU and subsequently accesses
  its registers needs to disable softirqs until it completes;
- kernel_neon_begin() will preserve the userland VFP state in memory,
  and if it interrupts the ordinary VFP state preserve sequence, the
  latter will resume execution with the VFP registers corrupted, and
  happily save them to memory.

Given that disabling softirqs also disables preemption, we can replace
the existing preempt_disable/enable occurrences in the VFP state
handling asm code with new macros that dis/enable softirqs instead.
In the VFP state handling C code, add local_bh_disable/enable() calls
in those places where the VFP state is preserved.

One thing to keep in mind is that, once we allow NEON use in softirq
context, the result of any such interruption is that the FPEXC_EN bit in
the FPEXC register will be cleared, and vfp_current_hw_state[cpu] will
be NULL. This means that any sequence that [conditionally] clears
FPEXC_EN and/or sets vfp_current_hw_state[cpu] to NULL does not need to
run with softirqs disabled, as the result will be the same. Furthermore,
the handling of THREAD_NOTIFY_SWITCH is guaranteed to run with IRQs
disabled, and so it does not need protection from softirq interruptions
either.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/assembler.h | 19 ++++++++++++-------
 arch/arm/kernel/asm-offsets.c    |  1 +
 arch/arm/vfp/entry.S             |  4 ++--
 arch/arm/vfp/vfphw.S             |  4 ++--
 arch/arm/vfp/vfpmodule.c         |  8 +++++++-
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 90fbe4a3f9c8472f..df999b75c0e25b01 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -236,21 +236,26 @@ THUMB(	fpreg	.req	r7	)
 	sub	\tmp, \tmp, #1			@ decrement it
 	str	\tmp, [\ti, #TI_PREEMPT]
 	.endm
-
-	.macro	dec_preempt_count_ti, ti, tmp
-	get_thread_info \ti
-	dec_preempt_count \ti, \tmp
-	.endm
 #else
 	.macro	inc_preempt_count, ti, tmp
 	.endm
 
 	.macro	dec_preempt_count, ti, tmp
 	.endm
+#endif
+
+	.macro	local_bh_disable, ti, tmp
+	ldr	\tmp, [\ti, #TI_PREEMPT]
+	add	\tmp, \tmp, #SOFTIRQ_DISABLE_OFFSET
+	str	\tmp, [\ti, #TI_PREEMPT]
+	.endm
 
-	.macro	dec_preempt_count_ti, ti, tmp
+	.macro	local_bh_enable_ti, ti, tmp
+	get_thread_info \ti
+	ldr	\tmp, [\ti, #TI_PREEMPT]
+	sub	\tmp, \tmp, #SOFTIRQ_DISABLE_OFFSET
+	str	\tmp, [\ti, #TI_PREEMPT]
 	.endm
-#endif
 
 #define USERL(l, x...)				\
 9999:	x;					\
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 2c8d76fd7c66298a..38121c59cbc26cdd 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -56,6 +56,7 @@ int main(void)
   DEFINE(VFP_CPU,		offsetof(union vfp_state, hard.cpu));
 #endif
 #endif
+  DEFINE(SOFTIRQ_DISABLE_OFFSET,SOFTIRQ_DISABLE_OFFSET);
 #ifdef CONFIG_ARM_THUMBEE
   DEFINE(TI_THUMBEE_STATE,	offsetof(struct thread_info, thumbee_state));
 #endif
diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 27b0a1f27fbdf392..9a89264cdcc0b46e 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -22,7 +22,7 @@
 @  IRQs enabled.
 @
 ENTRY(do_vfp)
-	inc_preempt_count r10, r4
+	local_bh_disable r10, r4
  	ldr	r4, .LCvfp
 	ldr	r11, [r10, #TI_CPU]	@ CPU number
 	add	r10, r10, #TI_VFPSTATE	@ r10 = workspace
@@ -30,7 +30,7 @@ ENTRY(do_vfp)
 ENDPROC(do_vfp)
 
 ENTRY(vfp_null_entry)
-	dec_preempt_count_ti r10, r4
+	local_bh_enable_ti r10, r4
 	ret	lr
 ENDPROC(vfp_null_entry)
 
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 6f7926c9c1790f66..26c4f61ecfa39638 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -175,7 +175,7 @@ vfp_hw_state_valid:
 					@ else it's one 32-bit instruction, so
 					@ always subtract 4 from the following
 					@ instruction address.
-	dec_preempt_count_ti r10, r4
+	local_bh_enable_ti r10, r4
 	ret	r9			@ we think we have handled things
 
 
@@ -200,7 +200,7 @@ skip:
 	@ not recognised by VFP
 
 	DBGSTR	"not VFP"
-	dec_preempt_count_ti r10, r4
+	local_bh_enable_ti r10, r4
 	ret	lr
 
 process_exception:
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2cb355c1b5b71694..8f5bc672b4aac04a 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -416,7 +416,7 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
 	if (exceptions)
 		vfp_raise_exceptions(exceptions, trigger, orig_fpscr, regs);
  exit:
-	preempt_enable();
+	local_bh_enable();
 }
 
 static void vfp_enable(void *unused)
@@ -517,6 +517,8 @@ void vfp_sync_hwstate(struct thread_info *thread)
 {
 	unsigned int cpu = get_cpu();
 
+	local_bh_disable();
+
 	if (vfp_state_in_hw(cpu, thread)) {
 		u32 fpexc = fmrx(FPEXC);
 
@@ -528,6 +530,7 @@ void vfp_sync_hwstate(struct thread_info *thread)
 		fmxr(FPEXC, fpexc);
 	}
 
+	local_bh_enable();
 	put_cpu();
 }
 
@@ -717,6 +720,8 @@ void kernel_neon_begin(void)
 	unsigned int cpu;
 	u32 fpexc;
 
+	local_bh_disable();
+
 	/*
 	 * Kernel mode NEON is only allowed outside of interrupt context
 	 * with preemption disabled. This will make sure that the kernel
@@ -739,6 +744,7 @@ void kernel_neon_begin(void)
 		vfp_save_state(vfp_current_hw_state[cpu], fpexc);
 #endif
 	vfp_current_hw_state[cpu] = NULL;
+	local_bh_enable();
 }
 EXPORT_SYMBOL(kernel_neon_begin);
 
-- 
2.35.1

