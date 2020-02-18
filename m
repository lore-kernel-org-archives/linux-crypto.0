Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B766C3404B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267CB2465D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582055951;
	bh=cq1/WyEK6G9FtWLN34MWhUx8seO8mDcFqp1C6P6AjXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Hi162F//FD4Corpa9C+PcpQSVZou+oIAh+n6E65XyRKtf+OWZRtdlyGE2MCfDGDGR
	 jbugozgQQg5NKy9pMKLcVfINPJWp/+q6XmvYv8t7V7eXLQaAIH8dWHNfABzI+gUvOr
	 irK+QxMuoGphj6zyOXpQZth4uG3eT57m7kOr/OZg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgBRT7K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:10 -0500
Received: from foss.arm.com ([217.140.110.172]:60542 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgBRT7J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819B131B;
        Tue, 18 Feb 2020 11:59:09 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05B5B3F68F;
        Tue, 18 Feb 2020 11:59:08 -0800 (PST)
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
Subject: [PATCH 07/18] arm64: ftrace: Correct annotation of ftrace_caller assembly
Date:   Tue, 18 Feb 2020 19:58:31 +0000
Message-Id: <20200218195842.34156-8-broonie@kernel.org>
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

The patchable function entry versions of ftrace_*_caller don't follow the
usual AAPCS rules, pushing things onto the stack which they don't clean up,
and therefore should be annotated as code rather than functions.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry-ftrace.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index 3d32b6d325d7..baf5a20a5566 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -75,17 +75,17 @@
 	add	x29, sp, #S_STACKFRAME
 	.endm
 
-ENTRY(ftrace_regs_caller)
+SYM_CODE_START(ftrace_regs_caller)
 	ftrace_regs_entry	1
 	b	ftrace_common
-ENDPROC(ftrace_regs_caller)
+SYM_CODE_END(ftrace_regs_caller)
 
-ENTRY(ftrace_caller)
+SYM_CODE_START(ftrace_caller)
 	ftrace_regs_entry	0
 	b	ftrace_common
-ENDPROC(ftrace_caller)
+SYM_CODE_END(ftrace_caller)
 
-ENTRY(ftrace_common)
+SYM_CODE_START(ftrace_common)
 	sub	x0, x30, #AARCH64_INSN_SIZE	// ip (callsite's BL insn)
 	mov	x1, x9				// parent_ip (callsite's LR)
 	ldr_l	x2, function_trace_op		// op
@@ -122,17 +122,17 @@ ftrace_common_return:
 	add	sp, sp, #S_FRAME_SIZE + 16
 
 	ret	x9
-ENDPROC(ftrace_common)
+SYM_CODE_END(ftrace_common)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-ENTRY(ftrace_graph_caller)
+SYM_CODE_START(ftrace_graph_caller)
 	ldr	x0, [sp, #S_PC]
 	sub	x0, x0, #AARCH64_INSN_SIZE	// ip (callsite's BL insn)
 	add	x1, sp, #S_LR			// parent_ip (callsite's LR)
 	ldr	x2, [sp, #S_FRAME_SIZE]	   	// parent fp (callsite's FP)
 	bl	prepare_ftrace_return
 	b	ftrace_common_return
-ENDPROC(ftrace_graph_caller)
+SYM_CODE_END(ftrace_graph_caller)
 #endif
 
 #else /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
-- 
2.20.1

