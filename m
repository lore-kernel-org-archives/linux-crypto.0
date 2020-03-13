Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3761FC10DCE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 138AA20746
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCMLDC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 07:03:02 -0400
Received: from verein.lst.de ([213.95.11.211]:41916 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgCMLDC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 07:03:02 -0400
Received: by verein.lst.de (Postfix, from userid 2005)
        id 94A0668C4E; Fri, 13 Mar 2020 12:02:58 +0100 (CET)
From:   Torsten Duwe <duwe@lst.de>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [Patch][Fix] crypto: arm{,64} neon: memzero_explicit aes-cbc key
Message-Id: <20200313110258.94A0668C4E@verein.lst.de>
Date:   Fri, 13 Mar 2020 12:02:58 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Torsten Duwe <duwe@suse.de>

At function exit, do not leave the expanded key in the rk struct
which got allocated on the stack.

Signed-off-by: Torsten Duwe <duwe@suse.de>
---
Another small fix from our FIPS evaluation. I hope you don't mind I merged
arm32 and arm64 into one patch -- this is really simple.
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -138,6 +138,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	kernel_neon_begin();
 	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
 	kernel_neon_end();
+	memzero_explicit(&rk, sizeof(rk));
 
 	return crypto_cipher_setkey(ctx->enc_tfm, in_key, key_len);
 }
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index e3e27349a9fe..c0b980503643 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -151,6 +151,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	kernel_neon_begin();
 	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
 	kernel_neon_end();
+	memzero_explicit(&rk, sizeof(rk));
 
 	return 0;
 }
