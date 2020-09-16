Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAD2C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B5021D7D
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600236877;
	bh=oFwRGJjCRrulCBDDrJokTK2CTWnrn6oLnBO3s5RFsms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=y0PbydRWYpJjE4XdRNYVm2TmYPJ8zm76SvpCKGkhXLS70Sgo0buYoq1WRnuBx6mRf
	 g8b0KuTOPfsrOjtk+nj5BqUH1asliM0z9S0wnQVkFb6e/bTj2iqexy8Wo2lLDfMoo+
	 wEI7Dx70RojCSibiMquSJGLoLbmwSxZrK5KJdM0c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgIPGOg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgIPGOe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 02:14:34 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F73208E4;
        Wed, 16 Sep 2020 06:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600236874;
        bh=oFwRGJjCRrulCBDDrJokTK2CTWnrn6oLnBO3s5RFsms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UciQDKtHkb/bz1vo4VmaB1xzXEScVjfS457KpBZCmNI35BuzOf0CYTXKEGmx9hFn6
         F6KDfgeIuAmtu5iU172i07yy70VKo9MnL24EC6TC4/wbUoCluHlbPDjHA+5PptH8Mh
         nvOaeL3HXYjC1ZcFF+mgNpCutFiQplfqUzEaPTYo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>
Subject: [PATCH v2 2/2] crypto: arm/sha512-neon - avoid ADRL pseudo instruction
Date:   Wed, 16 Sep 2020 09:14:18 +0300
Message-Id: <20200916061418.9197-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916061418.9197-1-ardb@kernel.org>
References: <20200916061418.9197-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ADRL pseudo instruction is not an architectural construct, but a
convenience macro that was supported by the ARM proprietary assembler
and adopted by binutils GAS as well, but only when assembling in 32-bit
ARM mode. Therefore, it can only be used in assembler code that is known
to assemble in ARM mode only, but as it turns out, the Clang assembler
does not implement ADRL at all, and so it is better to get rid of it
entirely.

So replace the ADRL instruction with a ADR instruction that refers to
a nearer symbol, and apply the delta explicitly using an additional
instruction.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/sha512-armv4.pl       | 4 ++--
 arch/arm/crypto/sha512-core.S_shipped | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
index 69df68981acd..2fc3516912fa 100644
--- a/arch/arm/crypto/sha512-armv4.pl
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -212,7 +212,6 @@ $code=<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -602,7 +601,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	$len,$inp,$len,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	$Ktbl,K512
+	adr	$Ktbl,.Lsha512_block_data_order
+	sub	$Ktbl,$Ktbl,.Lsha512_block_data_order-K512
 	vldmia	$ctx,{$A-$H}		@ load context
 .Loop_neon:
 ___
diff --git a/arch/arm/crypto/sha512-core.S_shipped b/arch/arm/crypto/sha512-core.S_shipped
index cb147db5cbfe..03014624f2ab 100644
--- a/arch/arm/crypto/sha512-core.S_shipped
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -79,7 +79,6 @@
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -543,7 +542,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	r3,K512
+	adr	r3,.Lsha512_block_data_order
+	sub	r3,r3,.Lsha512_block_data_order-K512
 	vldmia	r0,{d16-d23}		@ load context
 .Loop_neon:
 	vshr.u64	d24,d20,#14	@ 0
-- 
2.17.1

