Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF64C3404B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F1A222B48
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056437;
	bh=i/rk+ajCdVnD6kEsM9NmAA+PXabLPamz9CGLdNNeYEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=se7fsY/cES1ZiPglJ0kSeopgCDhn5qD4Pj96bSyuMjxQa42Nzm2XsISZe+4HLEhLp
	 3X+46mqxj5tKJ27l0SX0N3xzxB7fr3SvGMAI2oIGMvPip5p0CKhQuoVnY4wrRfp/qt
	 GGKg1Tp89+nxqIHInueJZXu2QJFEL4Wb3Iv1T+H4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRUHQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:16 -0500
Received: from foss.arm.com ([217.140.110.172]:60600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgBRT7Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B29BFEC;
        Tue, 18 Feb 2020 11:59:16 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0ECB3F68F;
        Tue, 18 Feb 2020 11:59:15 -0800 (PST)
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
Subject: [PATCH 10/18] arm64: head: Annotate stext and preserve_boot_args as code
Date:   Tue, 18 Feb 2020 19:58:34 +0000
Message-Id: <20200218195842.34156-11-broonie@kernel.org>
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
with unusual calling conventions.  Neither stext nor preserve_boot_args
is called with the usual AAPCS calling conventions and they should
therefore be annotated as code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/head.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 716c946c98e9..c334863991e7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -105,7 +105,7 @@ pe_header:
 	 *  x24        __primary_switch() .. relocate_kernel()
 	 *                                        current RELR displacement
 	 */
-ENTRY(stext)
+SYM_CODE_START(stext)
 	bl	preserve_boot_args
 	bl	el2_setup			// Drop to EL1, w0=cpu_boot_mode
 	adrp	x23, __PHYS_OFFSET
@@ -120,12 +120,12 @@ ENTRY(stext)
 	 */
 	bl	__cpu_setup			// initialise processor
 	b	__primary_switch
-ENDPROC(stext)
+SYM_CODE_END(stext)
 
 /*
  * Preserve the arguments passed by the bootloader in x0 .. x3
  */
-preserve_boot_args:
+SYM_CODE_START_LOCAL(preserve_boot_args)
 	mov	x21, x0				// x21=FDT
 
 	adr_l	x0, boot_args			// record the contents of
@@ -137,7 +137,7 @@ preserve_boot_args:
 
 	mov	x1, #0x20			// 4 x 8 bytes
 	b	__inval_dcache_area		// tail call
-ENDPROC(preserve_boot_args)
+SYM_CODE_END(preserve_boot_args)
 
 /*
  * Macro to create a table entry to the next page.
-- 
2.20.1

