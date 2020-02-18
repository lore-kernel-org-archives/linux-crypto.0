Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B389FC34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855DF24655
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582055957;
	bh=zb4iwY6aMN2w9/tC7e32I5RSAcmRHaCbshD66uEvf94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cqpKhuwevMgt4s9QwjmaT/F9I6+PsIqqqX32qi+KeVabPN+ohW4rdmiaQSwZNeRDU
	 3gFrgYmSME1Epbc+ZqR1YO/9w3OAOvvY+W6fttvx7ujIS521wLEFY/pQS/oNHF/bAA
	 KhgV5tPYAbMw1WVxv3tIrEbBBSyPVkwQsdxJtBO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgBRT7Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:16 -0500
Received: from foss.arm.com ([217.140.110.172]:60580 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbgBRT7O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0050F31B;
        Tue, 18 Feb 2020 11:59:14 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 766753F68F;
        Tue, 18 Feb 2020 11:59:13 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 09/18] arm64: head.S: Convert to modern annotations for assembly functions
Date:   Tue, 18 Feb 2020 19:58:33 +0000
Message-Id: <20200218195842.34156-10-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In an effort to clarify and simplify the annotation of assembly functions
in the kernel new macros have been introduced. These replace ENTRY and
ENDPROC and also add a new annotation for static functions which previously
had no ENTRY equivalent. Update the annotations in the core kernel code to
the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/head.S | 56 ++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 989b1944cb71..716c946c98e9 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -275,7 +275,7 @@ ENDPROC(preserve_boot_args)
  *   - first few MB of the kernel linear mapping to jump to once the MMU has
  *     been enabled
  */
-__create_page_tables:
+SYM_FUNC_START_LOCAL(__create_page_tables)
 	mov	x28, lr
 
 	/*
@@ -403,7 +403,7 @@ __create_page_tables:
 	bl	__inval_dcache_area
 
 	ret	x28
-ENDPROC(__create_page_tables)
+SYM_FUNC_END(__create_page_tables)
 	.ltorg
 
 /*
@@ -411,7 +411,7 @@ ENDPROC(__create_page_tables)
  *
  *   x0 = __PHYS_OFFSET
  */
-__primary_switched:
+SYM_FUNC_START_LOCAL(__primary_switched)
 	adrp	x4, init_thread_union
 	add	sp, x4, #THREAD_SIZE
 	adr_l	x5, init_task
@@ -456,7 +456,7 @@ __primary_switched:
 	mov	x29, #0
 	mov	x30, #0
 	b	start_kernel
-ENDPROC(__primary_switched)
+SYM_FUNC_END(__primary_switched)
 
 /*
  * end early head section, begin head code that is also used for
@@ -475,7 +475,7 @@ EXPORT_SYMBOL(kimage_vaddr)
  * Returns either BOOT_CPU_MODE_EL1 or BOOT_CPU_MODE_EL2 in w0 if
  * booted in EL1 or EL2 respectively.
  */
-ENTRY(el2_setup)
+SYM_FUNC_START(el2_setup)
 	msr	SPsel, #1			// We want to use SP_EL{1,2}
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
@@ -636,13 +636,13 @@ install_el2_stub:
 	msr	elr_el2, lr
 	mov	w0, #BOOT_CPU_MODE_EL2		// This CPU booted in EL2
 	eret
-ENDPROC(el2_setup)
+SYM_FUNC_END(el2_setup)
 
 /*
  * Sets the __boot_cpu_mode flag depending on the CPU boot mode passed
  * in w0. See arch/arm64/include/asm/virt.h for more info.
  */
-set_cpu_boot_mode_flag:
+SYM_FUNC_START_LOCAL(set_cpu_boot_mode_flag)
 	adr_l	x1, __boot_cpu_mode
 	cmp	w0, #BOOT_CPU_MODE_EL2
 	b.ne	1f
@@ -651,7 +651,7 @@ set_cpu_boot_mode_flag:
 	dmb	sy
 	dc	ivac, x1			// Invalidate potentially stale cache line
 	ret
-ENDPROC(set_cpu_boot_mode_flag)
+SYM_FUNC_END(set_cpu_boot_mode_flag)
 
 /*
  * These values are written with the MMU off, but read with the MMU on.
@@ -683,7 +683,7 @@ ENTRY(__early_cpu_boot_status)
 	 * This provides a "holding pen" for platforms to hold all secondary
 	 * cores are held until we're ready for them to initialise.
 	 */
-ENTRY(secondary_holding_pen)
+SYM_FUNC_START(secondary_holding_pen)
 	bl	el2_setup			// Drop to EL1, w0=cpu_boot_mode
 	bl	set_cpu_boot_mode_flag
 	mrs	x0, mpidr_el1
@@ -695,19 +695,19 @@ pen:	ldr	x4, [x3]
 	b.eq	secondary_startup
 	wfe
 	b	pen
-ENDPROC(secondary_holding_pen)
+SYM_FUNC_END(secondary_holding_pen)
 
 	/*
 	 * Secondary entry point that jumps straight into the kernel. Only to
 	 * be used where CPUs are brought online dynamically by the kernel.
 	 */
-ENTRY(secondary_entry)
+SYM_FUNC_START(secondary_entry)
 	bl	el2_setup			// Drop to EL1
 	bl	set_cpu_boot_mode_flag
 	b	secondary_startup
-ENDPROC(secondary_entry)
+SYM_FUNC_END(secondary_entry)
 
-secondary_startup:
+SYM_FUNC_START_LOCAL(secondary_startup)
 	/*
 	 * Common entry point for secondary CPUs.
 	 */
@@ -717,9 +717,9 @@ secondary_startup:
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
 	br	x8
-ENDPROC(secondary_startup)
+SYM_FUNC_END(secondary_startup)
 
-__secondary_switched:
+SYM_FUNC_START_LOCAL(__secondary_switched)
 	adr_l	x5, vectors
 	msr	vbar_el1, x5
 	isb
@@ -734,13 +734,13 @@ __secondary_switched:
 	mov	x29, #0
 	mov	x30, #0
 	b	secondary_start_kernel
-ENDPROC(__secondary_switched)
+SYM_FUNC_END(__secondary_switched)
 
-__secondary_too_slow:
+SYM_FUNC_START_LOCAL(__secondary_too_slow)
 	wfe
 	wfi
 	b	__secondary_too_slow
-ENDPROC(__secondary_too_slow)
+SYM_FUNC_END(__secondary_too_slow)
 
 /*
  * The booting CPU updates the failed status @__early_cpu_boot_status,
@@ -772,7 +772,7 @@ ENDPROC(__secondary_too_slow)
  * Checks if the selected granule size is supported by the CPU.
  * If it isn't, park the CPU
  */
-ENTRY(__enable_mmu)
+SYM_FUNC_START(__enable_mmu)
 	mrs	x2, ID_AA64MMFR0_EL1
 	ubfx	x2, x2, #ID_AA64MMFR0_TGRAN_SHIFT, 4
 	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
@@ -796,9 +796,9 @@ ENTRY(__enable_mmu)
 	dsb	nsh
 	isb
 	ret
-ENDPROC(__enable_mmu)
+SYM_FUNC_END(__enable_mmu)
 
-ENTRY(__cpu_secondary_check52bitva)
+SYM_FUNC_START(__cpu_secondary_check52bitva)
 #ifdef CONFIG_ARM64_VA_BITS_52
 	ldr_l	x0, vabits_actual
 	cmp	x0, #52
@@ -816,9 +816,9 @@ ENTRY(__cpu_secondary_check52bitva)
 
 #endif
 2:	ret
-ENDPROC(__cpu_secondary_check52bitva)
+SYM_FUNC_END(__cpu_secondary_check52bitva)
 
-__no_granule_support:
+SYM_FUNC_START_LOCAL(__no_granule_support)
 	/* Indicate that this CPU can't boot and is stuck in the kernel */
 	update_early_cpu_boot_status \
 		CPU_STUCK_IN_KERNEL | CPU_STUCK_REASON_NO_GRAN, x1, x2
@@ -826,10 +826,10 @@ __no_granule_support:
 	wfe
 	wfi
 	b	1b
-ENDPROC(__no_granule_support)
+SYM_FUNC_END(__no_granule_support)
 
 #ifdef CONFIG_RELOCATABLE
-__relocate_kernel:
+SYM_FUNC_START_LOCAL(__relocate_kernel)
 	/*
 	 * Iterate over each entry in the relocation table, and apply the
 	 * relocations in place.
@@ -931,10 +931,10 @@ __relocate_kernel:
 #endif
 	ret
 
-ENDPROC(__relocate_kernel)
+SYM_FUNC_END(__relocate_kernel)
 #endif
 
-__primary_switch:
+SYM_FUNC_START_LOCAL(__primary_switch)
 #ifdef CONFIG_RANDOMIZE_BASE
 	mov	x19, x0				// preserve new SCTLR_EL1 value
 	mrs	x20, sctlr_el1			// preserve old SCTLR_EL1 value
@@ -977,4 +977,4 @@ __primary_switch:
 	ldr	x8, =__primary_switched
 	adrp	x0, __PHYS_OFFSET
 	br	x8
-ENDPROC(__primary_switch)
+SYM_FUNC_END(__primary_switch)
-- 
2.20.1

