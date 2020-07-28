Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF042C4345B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74F620792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgG1HTW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54860 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:22 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtP-0006RQ-GU; Tue, 28 Jul 2020 17:19:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:19 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:19 +1000
Subject: [v3 PATCH 18/31] crypto: crypto4xx - Remove rfc3686 implementation
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtP-0006RQ-GU@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementation in crypto4xx is pretty much the same
as the generic rfc3686 wrapper.  So it can simply be removed to
reduce complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amcc/crypto4xx_alg.c  |   47 -----------------------------------
 drivers/crypto/amcc/crypto4xx_core.c |   20 --------------
 drivers/crypto/amcc/crypto4xx_core.h |    4 --
 3 files changed, 71 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index f7fc0c4641254..a7c17cdb1deb2 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -202,53 +202,6 @@ int crypto4xx_setkey_aes_ofb(struct crypto_skcipher *cipher,
 				    CRYPTO_FEEDBACK_MODE_64BIT_OFB);
 }
 
-int crypto4xx_setkey_rfc3686(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen)
-{
-	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
-	int rc;
-
-	rc = crypto4xx_setkey_aes(cipher, key, keylen - CTR_RFC3686_NONCE_SIZE,
-		CRYPTO_MODE_CTR, CRYPTO_FEEDBACK_MODE_NO_FB);
-	if (rc)
-		return rc;
-
-	ctx->iv_nonce = cpu_to_le32p((u32 *)&key[keylen -
-						 CTR_RFC3686_NONCE_SIZE]);
-
-	return 0;
-}
-
-int crypto4xx_rfc3686_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
-	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
-	__le32 iv[AES_IV_SIZE / 4] = {
-		ctx->iv_nonce,
-		cpu_to_le32p((u32 *) req->iv),
-		cpu_to_le32p((u32 *) (req->iv + 4)),
-		cpu_to_le32(1) };
-
-	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
-				  req->cryptlen, iv, AES_IV_SIZE,
-				  ctx->sa_out, ctx->sa_len, 0, NULL);
-}
-
-int crypto4xx_rfc3686_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
-	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
-	__le32 iv[AES_IV_SIZE / 4] = {
-		ctx->iv_nonce,
-		cpu_to_le32p((u32 *) req->iv),
-		cpu_to_le32p((u32 *) (req->iv + 4)),
-		cpu_to_le32(1) };
-
-	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
-				  req->cryptlen, iv, AES_IV_SIZE,
-				  ctx->sa_out, ctx->sa_len, 0, NULL);
-}
-
 static int
 crypto4xx_ctr_crypt(struct skcipher_request *req, bool encrypt)
 {
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 981de43ea5e24..2054e216440b5 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1252,26 +1252,6 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
-	{ .type = CRYPTO_ALG_TYPE_SKCIPHER, .u.cipher = {
-		.base = {
-			.cra_name = "rfc3686(ctr(aes))",
-			.cra_driver_name = "rfc3686-ctr-aes-ppc4xx",
-			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
-			.cra_module = THIS_MODULE,
-		},
-		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-		.ivsize	= CTR_RFC3686_IV_SIZE,
-		.setkey = crypto4xx_setkey_rfc3686,
-		.encrypt = crypto4xx_rfc3686_encrypt,
-		.decrypt = crypto4xx_rfc3686_decrypt,
-		.init = crypto4xx_sk_init,
-		.exit = crypto4xx_sk_exit,
-	} },
 	{ .type = CRYPTO_ALG_TYPE_SKCIPHER, .u.cipher = {
 		.base = {
 			.cra_name = "ecb(aes)",
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 6b68413591905..97f625fc5e8b1 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -169,8 +169,6 @@ int crypto4xx_setkey_aes_ecb(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_setkey_aes_ofb(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
-int crypto4xx_setkey_rfc3686(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen);
 int crypto4xx_encrypt_ctr(struct skcipher_request *req);
 int crypto4xx_decrypt_ctr(struct skcipher_request *req);
 int crypto4xx_encrypt_iv_stream(struct skcipher_request *req);
@@ -179,8 +177,6 @@ int crypto4xx_encrypt_iv_block(struct skcipher_request *req);
 int crypto4xx_decrypt_iv_block(struct skcipher_request *req);
 int crypto4xx_encrypt_noiv_block(struct skcipher_request *req);
 int crypto4xx_decrypt_noiv_block(struct skcipher_request *req);
-int crypto4xx_rfc3686_encrypt(struct skcipher_request *req);
-int crypto4xx_rfc3686_decrypt(struct skcipher_request *req);
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
 int crypto4xx_hash_digest(struct ahash_request *req);
 int crypto4xx_hash_final(struct ahash_request *req);
