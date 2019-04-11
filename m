Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D976C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D392184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfDKIvR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:17 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41260 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfDKIvR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQR-0003Q7-Q7
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:15 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQR-0006o8-Iz; Thu, 11 Apr 2019 16:51:15 +0800
Subject: [PATCH 18/24] crypto: picoxcell - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQR-0006o8-Iz@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:15 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.

It also removes an unnecessary key length checks that are already
performed by the crypto API.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 1b3acdeffede..975582b82a23 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -753,11 +753,6 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 tmp[DES_EXPKEY_WORDS];
 
-	if (len > DES3_EDE_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
 	if (unlikely(!des_ekey(tmp, key)) &&
 	    (crypto_ablkcipher_get_flags(cipher) &
 	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
@@ -772,6 +767,30 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 }
 
 /*
+ * Set the 3DES key for a block cipher transform. This also performs weak key
+ * checking if the transform has requested it.
+ */
+static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			     unsigned int len)
+{
+	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 flags;
+	int err;
+
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
+
+	memcpy(ctx->key, key, len);
+	ctx->key_len = len;
+
+	return 0;
+}
+
+/*
  * Set the key for an AES block cipher. Some key lengths are not supported in
  * hardware so this must also check whether a fallback is needed.
  */
@@ -1353,7 +1372,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_module = THIS_MODULE,
 			.cra_ablkcipher = {
-				.setkey = spacc_des_setkey,
+				.setkey = spacc_des3_setkey,
 				.encrypt = spacc_ablk_encrypt,
 				.decrypt = spacc_ablk_decrypt,
 				.min_keysize = DES3_EDE_KEY_SIZE,
@@ -1380,7 +1399,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_type = &crypto_ablkcipher_type,
 			.cra_module = THIS_MODULE,
 			.cra_ablkcipher = {
-				.setkey = spacc_des_setkey,
+				.setkey = spacc_des3_setkey,
 				.encrypt = spacc_ablk_encrypt,
 				.decrypt = spacc_ablk_decrypt,
 				.min_keysize = DES3_EDE_KEY_SIZE,
