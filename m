Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB2DC4332D
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB02A2242A
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLaRZT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgLaRZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B6A224B0;
        Thu, 31 Dec 2020 17:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435458;
        bh=fKXmKV7pdES/OQRIcaMDkJbEJVlbbOHwf4jakfmXbDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QopIQTLpit1qnAsn7GhhtK/76reefE38uMsASl86aFttrM/VitDeK64Jjl27QnuKH
         w0cRBtZOhSJkpg1Rm1msv1DJPgxj0XgW4NwRI5cQ30s/1ASHWAKDvIbbocV6UI8QlP
         KGKBfPiH1v00DhHVtibqxR3zIQ4jDZHSrhhHHJomQd98urrf8BvD3Q/HmbJYS4+vRF
         sljm4HcVt5thSNtOXpNoHQo+8TNuuu3Ry2cdyL6C29MI4mWnu35+Z2xPdixUygjHck
         B2zigR/b5s0EXKyBECZRbaZlw/WJrXt5R5Y7TfPnyM+3cbTOBtp4J2Y/yR+T2u60BE
         VF5O5FX2wjunw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 12/21] crypto: x86/des - drop CTR mode implementation
Date:   Thu, 31 Dec 2020 18:23:28 +0100
Message-Id: <20201231172337.23073-13-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DES or Triple DES in counter mode is never used in the kernel, so there
is no point in keeping an accelerated implementation around.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/des3_ede_glue.c | 104 --------------------
 crypto/Kconfig                  |   1 +
 2 files changed, 1 insertion(+), 104 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 89830e531350..e7cb68a3db3b 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -6,8 +6,6 @@
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
 #include <crypto/algapi.h>
@@ -253,94 +251,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static void ctr_crypt_final(struct des3_ede_x86_ctx *ctx,
-			    struct skcipher_walk *walk)
-{
-	u8 *ctrblk = walk->iv;
-	u8 keystream[DES3_EDE_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	des3_ede_enc_blk(ctx, keystream, ctrblk);
-	crypto_xor_cpy(dst, keystream, src, nbytes);
-
-	crypto_inc(ctrblk, DES3_EDE_BLOCK_SIZE);
-}
-
-static unsigned int __ctr_crypt(struct des3_ede_x86_ctx *ctx,
-				struct skcipher_walk *walk)
-{
-	unsigned int bsize = DES3_EDE_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	__be64 *src = (__be64 *)walk->src.virt.addr;
-	__be64 *dst = (__be64 *)walk->dst.virt.addr;
-	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
-	__be64 ctrblocks[3];
-
-	/* Process four block batch */
-	if (nbytes >= bsize * 3) {
-		do {
-			/* create ctrblks for parallel encrypt */
-			ctrblocks[0] = cpu_to_be64(ctrblk++);
-			ctrblocks[1] = cpu_to_be64(ctrblk++);
-			ctrblocks[2] = cpu_to_be64(ctrblk++);
-
-			des3_ede_enc_blk_3way(ctx, (u8 *)ctrblocks,
-					      (u8 *)ctrblocks);
-
-			dst[0] = src[0] ^ ctrblocks[0];
-			dst[1] = src[1] ^ ctrblocks[1];
-			dst[2] = src[2] ^ ctrblocks[2];
-
-			src += 3;
-			dst += 3;
-		} while ((nbytes -= bsize * 3) >= bsize * 3);
-
-		if (nbytes < bsize)
-			goto done;
-	}
-
-	/* Handle leftovers */
-	do {
-		ctrblocks[0] = cpu_to_be64(ctrblk++);
-
-		des3_ede_enc_blk(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
-
-		dst[0] = src[0] ^ ctrblocks[0];
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
-	struct des3_ede_x86_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) >= DES3_EDE_BLOCK_SIZE) {
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
 static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 			       unsigned int keylen)
 {
@@ -428,20 +338,6 @@ static struct skcipher_alg des3_ede_skciphers[] = {
 		.setkey			= des3_ede_x86_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(des3_ede)",
-		.base.cra_driver_name	= "ctr-des3_ede-asm",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct des3_ede_x86_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= DES3_EDE_KEY_SIZE,
-		.max_keysize		= DES3_EDE_KEY_SIZE,
-		.ivsize			= DES3_EDE_BLOCK_SIZE,
-		.chunksize		= DES3_EDE_BLOCK_SIZE,
-		.setkey			= des3_ede_x86_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	}
 };
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 606f94079f05..5e820a57d138 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1427,6 +1427,7 @@ config CRYPTO_DES3_EDE_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
+	imply CRYPTO_CTR
 	help
 	  Triple DES EDE (FIPS 46-3) algorithm.
 
-- 
2.17.1

