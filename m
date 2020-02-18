Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F919C34049
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2202464E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582055976;
	bh=3aekFAxZbI4K+U3+bCK6JpmHqD46Z/yonCcxr9hPnz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u9z0MokLgd42Fh3SNQ8ARroMw2rPJDPUpzItAGGU1jcZGKMawGBNoE2t+VOr0g4oC
	 a8LDoLaurU65q6ESIsvyrZQAxT3ABsMmbmjxIrMrp2OttyZ0nVNmnSEeYFcea+bGda
	 69fgER/ZWbVdXGCDB5nsJWPpHUIN0KQ8N6Lbd3JA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBRT7d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:33 -0500
Received: from foss.arm.com ([217.140.110.172]:60732 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgBRT7c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88DEFEC;
        Tue, 18 Feb 2020 11:59:31 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BF623F68F;
        Tue, 18 Feb 2020 11:59:31 -0800 (PST)
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
Subject: [PATCH 17/18] arm64: vdso: Convert to modern assembler annotations
Date:   Tue, 18 Feb 2020 19:58:41 +0000
Message-Id: <20200218195842.34156-18-broonie@kernel.org>
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
with unusual calling conventions. Convert the assembly function in the
arm64 VDSO to the new macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/vdso/sigreturn.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vdso/sigreturn.S b/arch/arm64/kernel/vdso/sigreturn.S
index 0723aa398d6e..12324863d5c2 100644
--- a/arch/arm64/kernel/vdso/sigreturn.S
+++ b/arch/arm64/kernel/vdso/sigreturn.S
@@ -14,7 +14,7 @@
 	.text
 
 	nop
-ENTRY(__kernel_rt_sigreturn)
+SYM_FUNC_START(__kernel_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
 	.cfi_def_cfa	x29, 0
@@ -23,4 +23,4 @@ ENTRY(__kernel_rt_sigreturn)
 	mov	x8, #__NR_rt_sigreturn
 	svc	#0
 	.cfi_endproc
-ENDPROC(__kernel_rt_sigreturn)
+SYM_FUNC_END(__kernel_rt_sigreturn)
-- 
2.20.1

