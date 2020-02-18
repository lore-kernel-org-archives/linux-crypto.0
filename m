Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55100C34026
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26C0B22B48
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056442;
	bh=zZsWoqdIHZcdkei7cGgwl7Fy8uvN9auYb1rafXaZqDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=x4cpS1N19GTBsqF7+cKQeEYm6kZHhyYH+QGxJVSbidRYmBTn1uN3TybpqHNxno48r
	 66bRyEo2pyfh+AlUbT2MBW42tI6NBuE41whoHfBp/zNxzDnLR1fibl5G2DKTZKzrrt
	 9V5D3ZssCERKtr3awa5gTW+riCuYvrikgPqlwjbs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgBRUHU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:20 -0500
Received: from foss.arm.com ([217.140.110.172]:60504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgBRT7F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13FF231B;
        Tue, 18 Feb 2020 11:59:05 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89F933F68F;
        Tue, 18 Feb 2020 11:59:04 -0800 (PST)
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
Subject: [PATCH 05/18] arm64: entry: Additional annotation conversions for entry.S
Date:   Tue, 18 Feb 2020 19:58:29 +0000
Message-Id: <20200218195842.34156-6-broonie@kernel.org>
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
data and code with different calling conventions.  Update the
remaining annotations in the entry.S code to the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/entry.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index d535cb8a7413..fbf69fe94412 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -832,7 +832,7 @@ alternative_else_nop_endif
 	.endm
 
 	.align	11
-ENTRY(tramp_vectors)
+SYM_CODE_START_NOALIGN(tramp_vectors)
 	.space	0x400
 
 	tramp_ventry
@@ -844,15 +844,15 @@ ENTRY(tramp_vectors)
 	tramp_ventry	32
 	tramp_ventry	32
 	tramp_ventry	32
-END(tramp_vectors)
+SYM_CODE_END(tramp_vectors)
 
-ENTRY(tramp_exit_native)
+SYM_CODE_START(tramp_exit_native)
 	tramp_exit
-END(tramp_exit_native)
+SYM_CODE_END(tramp_exit_native)
 
-ENTRY(tramp_exit_compat)
+SYM_CODE_START(tramp_exit_compat)
 	tramp_exit	32
-END(tramp_exit_compat)
+SYM_CODE_END(tramp_exit_compat)
 
 	.ltorg
 	.popsection				// .entry.tramp.text
@@ -874,7 +874,7 @@ __entry_tramp_data_start:
  * Previous and next are guaranteed not to be the same.
  *
  */
-ENTRY(cpu_switch_to)
+SYM_FUNC_START(cpu_switch_to)
 	mov	x10, #THREAD_CPU_CONTEXT
 	add	x8, x0, x10
 	mov	x9, sp
@@ -896,7 +896,7 @@ ENTRY(cpu_switch_to)
 	mov	sp, x9
 	msr	sp_el0, x1
 	ret
-ENDPROC(cpu_switch_to)
+SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
 
 /*
-- 
2.20.1

