Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FEFC34026
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A31D62067D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056453;
	bh=Gp+ot2WK5J41nqOMbT9JYhikYsmpsq0FDINwNHnYPRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=msbeRYzxHXlikgvaRo1ZKLd8EivF/JC8YHZKnSXQyK9tkXfGCSTgTNmE3Eb34b2Pc
	 opO9yRDNTSzHUHOFsDO2g1B/eiZJCQTJDa7P2UOcybn7x3FluVlNVvI0UODdAtZqEP
	 cmecd8Ncu+rQv8M/QOFXBGwBwbnGrBnryMue8Lhk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgBRUHc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:32 -0500
Received: from foss.arm.com ([217.140.110.172]:60462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgBRT7B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9733331B;
        Tue, 18 Feb 2020 11:59:00 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 199473F68F;
        Tue, 18 Feb 2020 11:58:59 -0800 (PST)
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
Subject: [PATCH 03/18] arm64: entry: Annotate vector table and handlers as code
Date:   Tue, 18 Feb 2020 19:58:27 +0000
Message-Id: <20200218195842.34156-4-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In an effort to clarify and simplify the annotation of assembly
functions new macros have been introduced. These replace ENTRY and
ENDPROC with two different annotations for normal functions and those
with unusual calling conventions. The vector table and handlers aren't
normal C style code so should be annotated as CODE.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry.S | 76 +++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 9461d812ae27..1454f3ea2e2e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -465,7 +465,7 @@ alternative_endif
 	.pushsection ".entry.text", "ax"
 
 	.align	11
-ENTRY(vectors)
+SYM_CODE_START(vectors)
 	kernel_ventry	1, sync_invalid			// Synchronous EL1t
 	kernel_ventry	1, irq_invalid			// IRQ EL1t
 	kernel_ventry	1, fiq_invalid			// FIQ EL1t
@@ -492,7 +492,7 @@ ENTRY(vectors)
 	kernel_ventry	0, fiq_invalid, 32		// FIQ 32-bit EL0
 	kernel_ventry	0, error_invalid, 32		// Error 32-bit EL0
 #endif
-END(vectors)
+SYM_CODE_END(vectors)
 
 #ifdef CONFIG_VMAP_STACK
 	/*
@@ -534,57 +534,57 @@ __bad_stack:
 	ASM_BUG()
 	.endm
 
-el0_sync_invalid:
+SYM_CODE_START_LOCAL(el0_sync_invalid)
 	inv_entry 0, BAD_SYNC
-ENDPROC(el0_sync_invalid)
+SYM_CODE_END(el0_sync_invalid)
 
-el0_irq_invalid:
+SYM_CODE_START_LOCAL(el0_irq_invalid)
 	inv_entry 0, BAD_IRQ
-ENDPROC(el0_irq_invalid)
+SYM_CODE_END(el0_irq_invalid)
 
-el0_fiq_invalid:
+SYM_CODE_START_LOCAL(el0_fiq_invalid)
 	inv_entry 0, BAD_FIQ
-ENDPROC(el0_fiq_invalid)
+SYM_CODE_END(el0_fiq_invalid)
 
-el0_error_invalid:
+SYM_CODE_START_LOCAL(el0_error_invalid)
 	inv_entry 0, BAD_ERROR
-ENDPROC(el0_error_invalid)
+SYM_CODE_END(el0_error_invalid)
 
 #ifdef CONFIG_COMPAT
-el0_fiq_invalid_compat:
+SYM_CODE_START_LOCAL(el0_fiq_invalid_compat)
 	inv_entry 0, BAD_FIQ, 32
-ENDPROC(el0_fiq_invalid_compat)
+SYM_CODE_END(el0_fiq_invalid_compat)
 #endif
 
-el1_sync_invalid:
+SYM_CODE_START_LOCAL(el1_sync_invalid)
 	inv_entry 1, BAD_SYNC
-ENDPROC(el1_sync_invalid)
+SYM_CODE_END(el1_sync_invalid)
 
-el1_irq_invalid:
+SYM_CODE_START_LOCAL(el1_irq_invalid)
 	inv_entry 1, BAD_IRQ
-ENDPROC(el1_irq_invalid)
+SYM_CODE_END(el1_irq_invalid)
 
-el1_fiq_invalid:
+SYM_CODE_START_LOCAL(el1_fiq_invalid)
 	inv_entry 1, BAD_FIQ
-ENDPROC(el1_fiq_invalid)
+SYM_CODE_END(el1_fiq_invalid)
 
-el1_error_invalid:
+SYM_CODE_START_LOCAL(el1_error_invalid)
 	inv_entry 1, BAD_ERROR
-ENDPROC(el1_error_invalid)
+SYM_CODE_END(el1_error_invalid)
 
 /*
  * EL1 mode handlers.
  */
 	.align	6
-el1_sync:
+SYM_CODE_START_LOCAL_NOALIGN(el1_sync)
 	kernel_entry 1
 	mov	x0, sp
 	bl	el1_sync_handler
 	kernel_exit 1
-ENDPROC(el1_sync)
+SYM_CODE_END(el1_sync)
 
 	.align	6
-el1_irq:
+SYM_CODE_START_LOCAL_NOALIGN(el1_irq)
 	kernel_entry 1
 	gic_prio_irq_setup pmr=x20, tmp=x1
 	enable_da_f
@@ -639,42 +639,42 @@ alternative_else_nop_endif
 #endif
 
 	kernel_exit 1
-ENDPROC(el1_irq)
+SYM_CODE_END(el1_irq)
 
 /*
  * EL0 mode handlers.
  */
 	.align	6
-el0_sync:
+SYM_CODE_START_LOCAL_NOALIGN(el0_sync)
 	kernel_entry 0
 	mov	x0, sp
 	bl	el0_sync_handler
 	b	ret_to_user
-ENDPROC(el0_sync)
+SYM_CODE_END(el0_sync)
 
 #ifdef CONFIG_COMPAT
 	.align	6
-el0_sync_compat:
+SYM_CODE_START_LOCAL_NOALIGN(el0_sync_compat)
 	kernel_entry 0, 32
 	mov	x0, sp
 	bl	el0_sync_compat_handler
 	b	ret_to_user
-ENDPROC(el0_sync_compat)
+SYM_CODE_END(el0_sync_compat)
 
 	.align	6
-el0_irq_compat:
+SYM_CODE_START_LOCAL_NOALIGN(el0_irq_compat)
 	kernel_entry 0, 32
 	b	el0_irq_naked
-ENDPROC(el0_irq_compat)
+SYM_CODE_END(el0_irq_compat)
 
-el0_error_compat:
+SYM_CODE_START_LOCAL_NOALIGN(el0_error_compat)
 	kernel_entry 0, 32
 	b	el0_error_naked
-ENDPROC(el0_error_compat)
+SYM_CODE_END(el0_error_compat)
 #endif
 
 	.align	6
-el0_irq:
+SYM_CODE_START_LOCAL_NOALIGN(el0_irq)
 	kernel_entry 0
 el0_irq_naked:
 	gic_prio_irq_setup pmr=x20, tmp=x0
@@ -696,9 +696,9 @@ el0_irq_naked:
 	bl	trace_hardirqs_on
 #endif
 	b	ret_to_user
-ENDPROC(el0_irq)
+SYM_CODE_END(el0_irq)
 
-el1_error:
+SYM_CODE_START_LOCAL(el1_error)
 	kernel_entry 1
 	mrs	x1, esr_el1
 	gic_prio_kentry_setup tmp=x2
@@ -706,9 +706,9 @@ el1_error:
 	mov	x0, sp
 	bl	do_serror
 	kernel_exit 1
-ENDPROC(el1_error)
+SYM_CODE_END(el1_error)
 
-el0_error:
+SYM_CODE_START_LOCAL(el0_error)
 	kernel_entry 0
 el0_error_naked:
 	mrs	x25, esr_el1
@@ -720,7 +720,7 @@ el0_error_naked:
 	bl	do_serror
 	enable_da_f
 	b	ret_to_user
-ENDPROC(el0_error)
+SYM_CODE_END(el0_error)
 
 /*
  * Ok, we need to do extra processing, enter the slow path.
-- 
2.20.1

