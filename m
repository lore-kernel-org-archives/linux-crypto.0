Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6ECC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D07C2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfDKIvQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:16 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41256 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDKIvQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:16 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQQ-0003Pl-N1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:14 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQQ-0006ny-FS; Thu, 11 Apr 2019 16:51:14 +0800
Subject: [PATCH 17/24] crypto: omap - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQQ-0006ny-FS@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:14 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.

It also removes a couple of unnecessary key length checks that
are already performed by the crypto API.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/omap-des.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 1ba2633e90d6..3d82d18ff810 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -656,9 +656,6 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 
-	if (keylen != DES_KEY_SIZE && keylen != (3*DES_KEY_SIZE))
-		return -EINVAL;
-
 	pr_debug("enter, keylen: %d\n", keylen);
 
 	/* Do we need to test against weak key? */
@@ -678,6 +675,28 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return 0;
 }
 
+static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			   unsigned int keylen)
+{
+	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 flags;
+	int err;
+
+	pr_debug("enter, keylen: %d\n", keylen);
+
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	return 0;
+}
+
 static int omap_des_ecb_encrypt(struct ablkcipher_request *req)
 {
 	return omap_des_crypt(req, FLAGS_ENCRYPT);
@@ -788,7 +807,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_u.ablkcipher = {
 		.min_keysize	= 3*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
-		.setkey		= omap_des_setkey,
+		.setkey		= omap_des3_setkey,
 		.encrypt	= omap_des_ecb_encrypt,
 		.decrypt	= omap_des_ecb_decrypt,
 	}
@@ -811,7 +830,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 		.min_keysize	= 3*DES_KEY_SIZE,
 		.max_keysize	= 3*DES_KEY_SIZE,
 		.ivsize		= DES_BLOCK_SIZE,
-		.setkey		= omap_des_setkey,
+		.setkey		= omap_des3_setkey,
 		.encrypt	= omap_des_cbc_encrypt,
 		.decrypt	= omap_des_cbc_decrypt,
 	}
