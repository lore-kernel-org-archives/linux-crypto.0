Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0080C34049
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96D5921D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056422;
	bh=+EpoHTgJOzUBG+b206m+PV/9fUxVFmmP+AM25H/RWzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h4/k+VC4VDcnmGiRcXb+3jkshg/2jRdgcHfhszOx1+xijv4td3KXRtOYbkMpqOiw5
	 PgbzPOsvbKY/2DRAAWVejX58OHrMCX4xhZ/Lo+ppXTDmb11ow65alSFwMr0jy8cWmh
	 E7rxzFSfXI57lrTtGL+VlBpvFJi9oS594V4Zphk0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgBRT7b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:31 -0500
Received: from foss.arm.com ([217.140.110.172]:60712 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgBRT73 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EC6931B;
        Tue, 18 Feb 2020 11:59:29 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22BE63F68F;
        Tue, 18 Feb 2020 11:59:28 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        James Morse <james.Morse@arm.com>
Subject: [PATCH 16/18] arm64: sdei: Annotate SDEI entry points using new style annotations
Date:   Tue, 18 Feb 2020 19:58:40 +0000
Message-Id: <20200218195842.34156-17-broonie@kernel.org>
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
with unusual calling conventions.

The SDEI entry points are currently annotated as normal functions but
are called from non-kernel contexts with non-standard calling convention
and should therefore be annotated as such so do so.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: James Morse <james.Morse@arm.com>
---
 arch/arm64/kernel/entry.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7439f29946fb..e5d4e30ee242 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -938,7 +938,7 @@ NOKPROBE(ret_from_fork)
  */
 .ltorg
 .pushsection ".entry.tramp.text", "ax"
-ENTRY(__sdei_asm_entry_trampoline)
+SYM_CODE_START(__sdei_asm_entry_trampoline)
 	mrs	x4, ttbr1_el1
 	tbz	x4, #USER_ASID_BIT, 1f
 
@@ -960,7 +960,7 @@ ENTRY(__sdei_asm_entry_trampoline)
 	ldr	x4, =__sdei_asm_handler
 #endif
 	br	x4
-ENDPROC(__sdei_asm_entry_trampoline)
+SYM_CODE_END(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
 
 /*
@@ -970,14 +970,14 @@ NOKPROBE(__sdei_asm_entry_trampoline)
  * x2: exit_mode
  * x4: struct sdei_registered_event argument from registration time.
  */
-ENTRY(__sdei_asm_exit_trampoline)
+SYM_CODE_START(__sdei_asm_exit_trampoline)
 	ldr	x4, [x4, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
 	cbnz	x4, 1f
 
 	tramp_unmap_kernel	tmp=x4
 
 1:	sdei_handler_exit exit_mode=x2
-ENDPROC(__sdei_asm_exit_trampoline)
+SYM_CODE_END(__sdei_asm_exit_trampoline)
 NOKPROBE(__sdei_asm_exit_trampoline)
 	.ltorg
 .popsection		// .entry.tramp.text
@@ -1003,7 +1003,7 @@ SYM_DATA_END(__sdei_asm_trampoline_next_handler)
  * follow SMC-CC. We save (or retrieve) all the registers as the handler may
  * want them.
  */
-ENTRY(__sdei_asm_handler)
+SYM_CODE_START(__sdei_asm_handler)
 	stp     x2, x3, [x1, #SDEI_EVENT_INTREGS + S_PC]
 	stp     x4, x5, [x1, #SDEI_EVENT_INTREGS + 16 * 2]
 	stp     x6, x7, [x1, #SDEI_EVENT_INTREGS + 16 * 3]
@@ -1086,6 +1086,6 @@ alternative_else_nop_endif
 	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
 	br	x5
 #endif
-ENDPROC(__sdei_asm_handler)
+SYM_CODE_END(__sdei_asm_handler)
 NOKPROBE(__sdei_asm_handler)
 #endif /* CONFIG_ARM_SDE_INTERFACE */
-- 
2.20.1

