Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2184DC34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E986B21D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056420;
	bh=ysatse66WsEP+APXGdPuRUVO8vuni1I3B4/iyQFpvhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DIsugi8LlhqrkeRt3GTPSfX9ECYyEEpQegHWNibQgljPBiE0mq4rcepoR13d+NpHy
	 Jz+BqCKQv8uHVKq9Bf3+zoQW+xpW8swT4SN548JdpfodiZ3brxN5Uxx3Rypxg/5q8x
	 Kw/yMmgC7Usy6jl1OenxL970Q1jpPXBCUnL1bdkw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgBRT7g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:36 -0500
Received: from foss.arm.com ([217.140.110.172]:60752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgBRT7e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E80C101E;
        Tue, 18 Feb 2020 11:59:34 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94C873F68F;
        Tue, 18 Feb 2020 11:59:33 -0800 (PST)
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
Subject: [PATCH 18/18] arm64: vdso32: Convert to modern assembler annotations
Date:   Tue, 18 Feb 2020 19:58:42 +0000
Message-Id: <20200218195842.34156-19-broonie@kernel.org>
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
with unusual calling conventions. Use these for the compat VDSO,
allowing us to drop the custom ARM_ENTRY() and ARM_ENDPROC() macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/vdso32/sigreturn.S | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/vdso32/sigreturn.S b/arch/arm64/kernel/vdso32/sigreturn.S
index 1a81277c2d09..620524969696 100644
--- a/arch/arm64/kernel/vdso32/sigreturn.S
+++ b/arch/arm64/kernel/vdso32/sigreturn.S
@@ -10,13 +10,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
 
-#define ARM_ENTRY(name)		\
-	ENTRY(name)
-
-#define ARM_ENDPROC(name)	\
-	.type name, %function;	\
-	END(name)
-
 	.text
 
 	.arm
@@ -24,39 +17,39 @@
 	.save {r0-r15}
 	.pad #COMPAT_SIGFRAME_REGS_OFFSET
 	nop
-ARM_ENTRY(__kernel_sigreturn_arm)
+SYM_FUNC_START(__kernel_sigreturn_arm)
 	mov r7, #__NR_compat_sigreturn
 	svc #0
 	.fnend
-ARM_ENDPROC(__kernel_sigreturn_arm)
+SYM_FUNC_END(__kernel_sigreturn_arm)
 
 	.fnstart
 	.save {r0-r15}
 	.pad #COMPAT_RT_SIGFRAME_REGS_OFFSET
 	nop
-ARM_ENTRY(__kernel_rt_sigreturn_arm)
+SYM_FUNC_START(__kernel_rt_sigreturn_arm)
 	mov r7, #__NR_compat_rt_sigreturn
 	svc #0
 	.fnend
-ARM_ENDPROC(__kernel_rt_sigreturn_arm)
+SYM_FUNC_END(__kernel_rt_sigreturn_arm)
 
 	.thumb
 	.fnstart
 	.save {r0-r15}
 	.pad #COMPAT_SIGFRAME_REGS_OFFSET
 	nop
-ARM_ENTRY(__kernel_sigreturn_thumb)
+SYM_FUNC_START(__kernel_sigreturn_thumb)
 	mov r7, #__NR_compat_sigreturn
 	svc #0
 	.fnend
-ARM_ENDPROC(__kernel_sigreturn_thumb)
+SYM_FUNC_END(__kernel_sigreturn_thumb)
 
 	.fnstart
 	.save {r0-r15}
 	.pad #COMPAT_RT_SIGFRAME_REGS_OFFSET
 	nop
-ARM_ENTRY(__kernel_rt_sigreturn_thumb)
+SYM_FUNC_START(__kernel_rt_sigreturn_thumb)
 	mov r7, #__NR_compat_rt_sigreturn
 	svc #0
 	.fnend
-ARM_ENDPROC(__kernel_rt_sigreturn_thumb)
+SYM_FUNC_END(__kernel_rt_sigreturn_thumb)
-- 
2.20.1

