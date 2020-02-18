Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBE9C34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 771CF21D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056429;
	bh=6/TbO83axwk3tVqqoaeKsoLA0VXz0VRNJNSKn3RG/So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Lst94tWJdA3sZ65nAegXpT4jKaEf9mIP08qria1qk5eYy1uWuFealzaQETxEHGOzu
	 G/Hf8yYxYkd0IrWWAR/UkVjkQWwltb8uNPMskt+1couEcasNfL/MbwsiP7XPUzjwGz
	 so8HAKskl0hgjy0qsLbuRPXh7YdCQ2Ysf8nRhzuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgBRUHI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:08 -0500
Received: from foss.arm.com ([217.140.110.172]:60660 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgBRT7X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB2D2101E;
        Tue, 18 Feb 2020 11:59:22 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D1873F68F;
        Tue, 18 Feb 2020 11:59:22 -0800 (PST)
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
Subject: [PATCH 13/18] arm64: kvm: Annotate assembly using modern annoations
Date:   Tue, 18 Feb 2020 19:58:37 +0000
Message-Id: <20200218195842.34156-14-broonie@kernel.org>
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
ENDPROC with separate annotations for standard C callable functions,
data and code with different calling conventions.  Update the more
straightforward annotations in the kvm code to the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp-init.S      |  8 ++++----
 arch/arm64/kvm/hyp.S           |  4 ++--
 arch/arm64/kvm/hyp/fpsimd.S    |  8 ++++----
 arch/arm64/kvm/hyp/hyp-entry.S | 15 ++++++++-------
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 160be2b4696d..84f32cf5abc7 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -18,7 +18,7 @@
 
 	.align	11
 
-ENTRY(__kvm_hyp_init)
+SYM_CODE_START(__kvm_hyp_init)
 	ventry	__invalid		// Synchronous EL2t
 	ventry	__invalid		// IRQ EL2t
 	ventry	__invalid		// FIQ EL2t
@@ -117,9 +117,9 @@ CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 
 	/* Hello, World! */
 	eret
-ENDPROC(__kvm_hyp_init)
+SYM_CODE_END(__kvm_hyp_init)
 
-ENTRY(__kvm_handle_stub_hvc)
+SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
 
@@ -158,7 +158,7 @@ reset:
 	ldr	x0, =HVC_STUB_ERR
 	eret
 
-ENDPROC(__kvm_handle_stub_hvc)
+SYM_CODE_END(__kvm_handle_stub_hvc)
 
 	.ltorg
 
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index c0094d520dff..3c79a1124af2 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -28,7 +28,7 @@
  * and is used to implement hyp stubs in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
  */
-ENTRY(__kvm_call_hyp)
+SYM_FUNC_START(__kvm_call_hyp)
 	hvc	#0
 	ret
-ENDPROC(__kvm_call_hyp)
+SYM_FUNC_END(__kvm_call_hyp)
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 78ff53225691..5b8ff517ff10 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -11,12 +11,12 @@
 	.text
 	.pushsection	.hyp.text, "ax"
 
-ENTRY(__fpsimd_save_state)
+SYM_FUNC_START(__fpsimd_save_state)
 	fpsimd_save	x0, 1
 	ret
-ENDPROC(__fpsimd_save_state)
+SYM_FUNC_END(__fpsimd_save_state)
 
-ENTRY(__fpsimd_restore_state)
+SYM_FUNC_START(__fpsimd_restore_state)
 	fpsimd_restore	x0, 1
 	ret
-ENDPROC(__fpsimd_restore_state)
+SYM_FUNC_END(__fpsimd_restore_state)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index ffa68d5713f1..0aea8f9ab23d 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -180,7 +180,7 @@ el2_error:
 	eret
 	sb
 
-ENTRY(__hyp_do_panic)
+SYM_FUNC_START(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
 		      PSR_MODE_EL1h)
 	msr	spsr_el2, lr
@@ -188,18 +188,19 @@ ENTRY(__hyp_do_panic)
 	msr	elr_el2, lr
 	eret
 	sb
-ENDPROC(__hyp_do_panic)
+SYM_FUNC_END(__hyp_do_panic)
 
-ENTRY(__hyp_panic)
+SYM_CODE_START(__hyp_panic)
 	get_host_ctxt x0, x1
 	b	hyp_panic
-ENDPROC(__hyp_panic)
+SYM_CODE_END(__hyp_panic)
 
 .macro invalid_vector	label, target = __hyp_panic
 	.align	2
+SYM_CODE_START(\label)
 \label:
 	b \target
-ENDPROC(\label)
+SYM_CODE_END(\label)
 .endm
 
 	/* None of these should ever happen */
@@ -246,7 +247,7 @@ check_preamble_length 661b, 662b
 check_preamble_length 661b, 662b
 .endm
 
-ENTRY(__kvm_hyp_vector)
+SYM_CODE_START(__kvm_hyp_vector)
 	invalid_vect	el2t_sync_invalid	// Synchronous EL2t
 	invalid_vect	el2t_irq_invalid	// IRQ EL2t
 	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
@@ -266,7 +267,7 @@ ENTRY(__kvm_hyp_vector)
 	valid_vect	el1_irq			// IRQ 32-bit EL1
 	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
 	valid_vect	el1_error		// Error 32-bit EL1
-ENDPROC(__kvm_hyp_vector)
+SYM_CODE_END(__kvm_hyp_vector)
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 .macro hyp_ventry
-- 
2.20.1

