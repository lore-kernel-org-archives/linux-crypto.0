Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011F0C4332E
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B44223E8
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLaRZV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgLaRZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB7E224B2;
        Thu, 31 Dec 2020 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435461;
        bh=Tp36mZIS84xfM5CYG/KD99bEcfDFJ5aHV/dLNt3SrXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyQbR3pcNWtR/mUaRR8b+oDxqXZvkY3vdBGK/qdFQcR3z+DSkUjX4QJTs5tSbTi2Y
         HeN1qkS1zTC4XvRC6Am1QcZS9QoqBFysUbZOjzupv2NPYBOaXdcas9VC+o39h8Kzpe
         2Wz1tL8iel2zsm3GmSnaSQZ+11p87LgF/cd1WOvspUbfUSwM/fkd9Wa1C58KFgxyE3
         7Q1ug/GUxK/bY+OtOgIAAAvQgogZgXZC1bDA/rAvqS9XG6dtl1WQaO95AbzkEH4qZ/
         c9I4w/RbUTG42Y2fB1+mvK4MZ2bLmIakUuvotOUdujiL57C9BAY3zToY39va0dXXwv
         r6rIj4jzc2IHg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/21] crypto: x86/blowfish - drop CTR mode implementation
Date:   Thu, 31 Dec 2020 18:23:29 +0100
Message-Id: <20201231172337.23073-14-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Blowfish in counter mode is never used in the kernel, so there
is no point in keeping an accelerated implementation around.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/blowfish_glue.c | 107 --------------------
 crypto/Kconfig                  |   1 +
 2 files changed, 1 insertion(+), 107 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index cedfdba69ce3..a880e0b1c255 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -6,8 +6,6 @@
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
 #include <crypto/algapi.h>
@@ -247,97 +245,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_crypt_final(struct bf_ctx *ctx, struct skcipher_walk *walk)
-{
-	u8 *ctrblk = walk->iv;
-	u8 keystream[BF_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	blowfish_enc_blk(ctx, keystream, ctrblk);
-	crypto_xor_cpy(dst, keystream, src, nbytes);
-
-	crypto_inc(ctrblk, BF_BLOCK_SIZE);
-}
-
-static unsigned int __ctr_crypt(struct bf_ctx *ctx, struct skcipher_walk *walk)
-{
-	unsigned int bsize = BF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u64 *src = (u64 *)walk->src.virt.addr;
-	u64 *dst = (u64 *)walk->dst.virt.addr;
-	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
-	__be64 ctrblocks[4];
-
-	/* Process four block batch */
-	if (nbytes >= bsize * 4) {
-		do {
-			if (dst != src) {
-				dst[0] = src[0];
-				dst[1] = src[1];
-				dst[2] = src[2];
-				dst[3] = src[3];
-			}
-
-			/* create ctrblks for parallel encrypt */
-			ctrblocks[0] = cpu_to_be64(ctrblk++);
-			ctrblocks[1] = cpu_to_be64(ctrblk++);
-			ctrblocks[2] = cpu_to_be64(ctrblk++);
-			ctrblocks[3] = cpu_to_be64(ctrblk++);
-
-			blowfish_enc_blk_xor_4way(ctx, (u8 *)dst,
-						  (u8 *)ctrblocks);
-
-			src += 4;
-			dst += 4;
-		} while ((nbytes -= bsize * 4) >= bsize * 4);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	do {
-		if (dst != src)
-			*dst = *src;
-
-		ctrblocks[0] = cpu_to_be64(ctrblk++);
-
-		blowfish_enc_blk_xor(ctx, (u8 *)dst, (u8 *)ctrblocks);
-
-		src += 1;
-		dst += 1;
-	} while ((nbytes -= bsize) >= bsize);
-
-done:
-	*(__be64 *)walk->iv = cpu_to_be64(ctrblk);
-	return nbytes;
-}
-
-static int ctr_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct bf_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) >= BF_BLOCK_SIZE) {
-		nbytes = __ctr_crypt(ctx, &walk);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	if (nbytes) {
-		ctr_crypt_final(ctx, &walk);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
-}
-
 static struct crypto_alg bf_cipher_alg = {
 	.cra_name		= "blowfish",
 	.cra_driver_name	= "blowfish-asm",
@@ -384,20 +291,6 @@ static struct skcipher_alg bf_skcipher_algs[] = {
 		.setkey			= blowfish_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(blowfish)",
-		.base.cra_driver_name	= "ctr-blowfish-asm",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct bf_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= BF_MIN_KEY_SIZE,
-		.max_keysize		= BF_MAX_KEY_SIZE,
-		.ivsize			= BF_BLOCK_SIZE,
-		.chunksize		= BF_BLOCK_SIZE,
-		.setkey			= blowfish_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5e820a57d138..24c0e001d06d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1255,6 +1255,7 @@ config CRYPTO_BLOWFISH_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_BLOWFISH_COMMON
+	imply CRYPTO_CTR
 	help
 	  Blowfish cipher algorithm (x86_64), by Bruce Schneier.
 
-- 
2.17.1

