Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05494C34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3FF521D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056440;
	bh=2VGJrBUUJ34uyvAPaWD0iBj3zeGKVnl//pNG9gyRMFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=M6lxxkHDWxEBMbM5ga7399bW7oZnQkmoBiunTwAs6m6xPLQJ6AU+xpWXxQ4F7eVtL
	 J6Q20nbwkySkuk8I4KAQLc6O20MS7okiNV6HKDK2Enje7ERZu1pwJRFcuWlNk1pPGG
	 hPmCaH6l4Qq9kthhDKR/DTAtNgOuetsk8b+eHlNw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgBRUHT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:19 -0500
Received: from foss.arm.com ([217.140.110.172]:60524 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgBRT7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B5C5FEC;
        Tue, 18 Feb 2020 11:59:07 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1D9C3F68F;
        Tue, 18 Feb 2020 11:59:06 -0800 (PST)
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
Subject: [PATCH 06/18] arm64: entry-ftrace.S: Convert to modern annotations for assembly functions
Date:   Tue, 18 Feb 2020 19:58:30 +0000
Message-Id: <20200218195842.34156-7-broonie@kernel.org>
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
 arch/arm64/kernel/entry-ftrace.S | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index 7d02f9966d34..3d32b6d325d7 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -91,11 +91,11 @@ ENTRY(ftrace_common)
 	ldr_l	x2, function_trace_op		// op
 	mov	x3, sp				// regs
 
-GLOBAL(ftrace_call)
+SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	bl	ftrace_stub
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-GLOBAL(ftrace_graph_call)		// ftrace_graph_caller();
+SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
 	nop				// If enabled, this will be replaced
 					// "b ftrace_graph_caller"
 #endif
@@ -218,7 +218,7 @@ ENDPROC(ftrace_graph_caller)
  *     - tracer function to probe instrumented function's entry,
  *     - ftrace_graph_caller to set up an exit hook
  */
-ENTRY(_mcount)
+SYM_FUNC_START(_mcount)
 	mcount_enter
 
 	ldr_l	x2, ftrace_trace_function
@@ -242,7 +242,7 @@ skip_ftrace_call:			// }
 	b.ne	ftrace_graph_caller	//     ftrace_graph_caller();
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 	mcount_exit
-ENDPROC(_mcount)
+SYM_FUNC_END(_mcount)
 EXPORT_SYMBOL(_mcount)
 NOKPROBE(_mcount)
 
@@ -253,9 +253,9 @@ NOKPROBE(_mcount)
  * and later on, NOP to branch to ftrace_caller() when enabled or branch to
  * NOP when disabled per-function base.
  */
-ENTRY(_mcount)
+SYM_FUNC_START(_mcount)
 	ret
-ENDPROC(_mcount)
+SYM_FUNC_END(_mcount)
 EXPORT_SYMBOL(_mcount)
 NOKPROBE(_mcount)
 
@@ -268,24 +268,24 @@ NOKPROBE(_mcount)
  *     - tracer function to probe instrumented function's entry,
  *     - ftrace_graph_caller to set up an exit hook
  */
-ENTRY(ftrace_caller)
+SYM_FUNC_START(ftrace_caller)
 	mcount_enter
 
 	mcount_get_pc0	x0		//     function's pc
 	mcount_get_lr	x1		//     function's lr
 
-GLOBAL(ftrace_call)			// tracer(pc, lr);
+SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)	// tracer(pc, lr);
 	nop				// This will be replaced with "bl xxx"
 					// where xxx can be any kind of tracer.
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-GLOBAL(ftrace_graph_call)		// ftrace_graph_caller();
+SYM_INNER_LABEL(ftrace_graph_call)		// ftrace_graph_caller();
 	nop				// If enabled, this will be replaced
 					// "b ftrace_graph_caller"
 #endif
 
 	mcount_exit
-ENDPROC(ftrace_caller)
+SYM_FUNC_END(ftrace_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -298,20 +298,20 @@ ENDPROC(ftrace_caller)
  * the call stack in order to intercept instrumented function's return path
  * and run return_to_handler() later on its exit.
  */
-ENTRY(ftrace_graph_caller)
+SYM_FUNC_START(ftrace_graph_caller)
 	mcount_get_pc		  x0	//     function's pc
 	mcount_get_lr_addr	  x1	//     pointer to function's saved lr
 	mcount_get_parent_fp	  x2	//     parent's fp
 	bl	prepare_ftrace_return	// prepare_ftrace_return(pc, &lr, fp)
 
 	mcount_exit
-ENDPROC(ftrace_graph_caller)
+SYM_FUNC_END(ftrace_graph_caller)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
-ENTRY(ftrace_stub)
+SYM_FUNC_START(ftrace_stub)
 	ret
-ENDPROC(ftrace_stub)
+SYM_FUNC_END(ftrace_stub)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
-- 
2.20.1

