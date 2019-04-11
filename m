Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19950C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33E521852
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfDKIvY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:24 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41284 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfDKIvY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:24 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQY-0003To-Jo
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQY-0006p6-BG; Thu, 11 Apr 2019 16:51:22 +0800
Subject: [PATCH 24/24] crypto: ux500 - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQY-0006p6-BG@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:22 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.

It also removes the registration of the non-standard des/des3
ablkcipher algorithms.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ux500/cryp/cryp_core.c |   86 ++--------------------------------
 1 file changed, 7 insertions(+), 79 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 3235611928f2..7a93cba0877f 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1019,37 +1019,16 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 *flags = &cipher->base.crt_flags;
-	const u32 *K = (const u32 *)key;
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	int i, ret;
+	u32 flags;
+	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
-	if (keylen != DES3_EDE_KEY_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
-				__func__);
-		return -EINVAL;
-	}
 
-	/* Checking key interdependency for weak key detection. */
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-				!((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-			(*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
-			 __func__);
-		return -EINVAL;
-	}
-	for (i = 0; i < 3; i++) {
-		ret = des_ekey(tmp, key + i*DES_KEY_SIZE);
-		if (unlikely(ret == 0) &&
-		    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
-				 __func__);
-			return -EINVAL;
-		}
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
 	}
 
 	memcpy(ctx->key, key, keylen);
@@ -1219,57 +1198,6 @@ static struct cryp_algo_template cryp_algs[] = {
 	{
 		.algomode = CRYP_ALGO_DES_ECB,
 		.crypto = {
-			.cra_name = "des",
-			.cra_driver_name = "des-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-						CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES_KEY_SIZE,
-					.max_keysize = DES_KEY_SIZE,
-					.setkey = des_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt
-				}
-			}
-		}
-
-	},
-	{
-		.algomode = CRYP_ALGO_TDES_ECB,
-		.crypto = {
-			.cra_name = "des3_ede",
-			.cra_driver_name = "des3_ede-ux500",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-						CRYPTO_ALG_ASYNC,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct cryp_ctx),
-			.cra_alignmask = 3,
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_init = cryp_cra_init,
-			.cra_module = THIS_MODULE,
-			.cra_u = {
-				.ablkcipher = {
-					.min_keysize = DES3_EDE_KEY_SIZE,
-					.max_keysize = DES3_EDE_KEY_SIZE,
-					.setkey = des_ablkcipher_setkey,
-					.encrypt = cryp_blk_encrypt,
-					.decrypt = cryp_blk_decrypt
-				}
-			}
-		}
-	},
-	{
-		.algomode = CRYP_ALGO_DES_ECB,
-		.crypto = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "ecb-des-ux500",
 			.cra_priority = 300,
