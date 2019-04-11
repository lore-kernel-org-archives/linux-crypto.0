Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8DFC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E962184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfDKIvU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:20 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41268 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfDKIvT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:19 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQU-0003Qg-04
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQT-0006oS-Ol; Thu, 11 Apr 2019 16:51:17 +0800
Subject: [PATCH 20/24] crypto: rockchip - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQT-0006oS-Ol@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:17 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.

It also removes a couple of unnecessary key length checks that
are already performed by the crypto API.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   36 ++++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 02dac6ae7e53..7d02c97be18d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -46,24 +46,36 @@ static int rk_aes_setkey(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
-static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
-			  const u8 *key, unsigned int keylen)
+static int rk_des_setkey(struct crypto_ablkcipher *cipher,
+			 const u8 *key, unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct rk_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 tmp[DES_EXPKEY_WORDS];
 
-	if (keylen != DES_KEY_SIZE && keylen != DES3_EDE_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (!des_ekey(tmp, key) &&
+	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 
-	if (keylen == DES_KEY_SIZE) {
-		if (!des_ekey(tmp, key) &&
-		    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
+	ctx->keylen = keylen;
+	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
+	return 0;
+}
+
+static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
+			  const u8 *key, unsigned int keylen)
+{
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 flags;
+	int err;
+
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
 	}
 
 	ctx->keylen = keylen;
@@ -457,7 +469,7 @@ struct rk_crypto_tmp rk_ecb_des_alg = {
 		.cra_u.ablkcipher	= {
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
-			.setkey		= rk_tdes_setkey,
+			.setkey		= rk_des_setkey,
 			.encrypt	= rk_des_ecb_encrypt,
 			.decrypt	= rk_des_ecb_decrypt,
 		}
@@ -483,7 +495,7 @@ struct rk_crypto_tmp rk_cbc_des_alg = {
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
 			.ivsize		= DES_BLOCK_SIZE,
-			.setkey		= rk_tdes_setkey,
+			.setkey		= rk_des_setkey,
 			.encrypt	= rk_des_cbc_encrypt,
 			.decrypt	= rk_des_cbc_decrypt,
 		}
