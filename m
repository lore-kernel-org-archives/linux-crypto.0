Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A84BC433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F950207F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgG1HTg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54910 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jtd-0006Ue-HU; Tue, 28 Jul 2020 17:19:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:33 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:33 +1000
Subject: [v3 PATCH 24/31] crypto: ixp4xx - Remove rfc3686 implementation
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jtd-0006Ue-HU@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementation in ixp4xx is pretty much the same
as the generic rfc3686 wrapper.  So it can simply be removed to
reduce complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |   53 -----------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index f478bb0a566af..c93f5db8d0503 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -180,7 +180,6 @@ struct ixp_ctx {
 	int enckey_len;
 	u8 enckey[MAX_KEYLEN];
 	u8 salt[MAX_IVLEN];
-	u8 nonce[CTR_RFC3686_NONCE_SIZE];
 	unsigned salted;
 	atomic_t configuring;
 	struct completion completion;
@@ -848,22 +847,6 @@ static int ablk_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	       ablk_setkey(tfm, key, key_len);
 }
 
-static int ablk_rfc3686_setkey(struct crypto_skcipher *tfm, const u8 *key,
-		unsigned int key_len)
-{
-	struct ixp_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	/* the nonce is stored in bytes at end of key */
-	if (key_len < CTR_RFC3686_NONCE_SIZE)
-		return -EINVAL;
-
-	memcpy(ctx->nonce, key + (key_len - CTR_RFC3686_NONCE_SIZE),
-			CTR_RFC3686_NONCE_SIZE);
-
-	key_len -= CTR_RFC3686_NONCE_SIZE;
-	return ablk_setkey(tfm, key, key_len);
-}
-
 static int ablk_perform(struct skcipher_request *req, int encrypt)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -947,28 +930,6 @@ static int ablk_decrypt(struct skcipher_request *req)
 	return ablk_perform(req, 0);
 }
 
-static int ablk_rfc3686_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct ixp_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u8 iv[CTR_RFC3686_BLOCK_SIZE];
-	u8 *info = req->iv;
-	int ret;
-
-	/* set up counter block */
-        memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
-	memcpy(iv + CTR_RFC3686_NONCE_SIZE, info, CTR_RFC3686_IV_SIZE);
-
-	/* initialize counter portion of counter block */
-	*(__be32 *)(iv + CTR_RFC3686_NONCE_SIZE + CTR_RFC3686_IV_SIZE) =
-		cpu_to_be32(1);
-
-	req->iv = iv;
-	ret = ablk_perform(req, 1);
-	req->iv = info;
-	return ret;
-}
-
 static int aead_perform(struct aead_request *req, int encrypt,
 		int cryptoffset, int eff_cryptlen, u8 *iv)
 {
@@ -1269,20 +1230,6 @@ static struct ixp_alg ixp4xx_algos[] = {
 	},
 	.cfg_enc = CIPH_ENCR | MOD_AES | MOD_CTR,
 	.cfg_dec = CIPH_ENCR | MOD_AES | MOD_CTR,
-}, {
-	.crypto	= {
-		.base.cra_name		= "rfc3686(ctr(aes))",
-		.base.cra_blocksize	= 1,
-
-		.min_keysize		= AES_MIN_KEY_SIZE,
-		.max_keysize		= AES_MAX_KEY_SIZE,
-		.ivsize			= AES_BLOCK_SIZE,
-		.setkey			= ablk_rfc3686_setkey,
-		.encrypt		= ablk_rfc3686_crypt,
-		.decrypt		= ablk_rfc3686_crypt,
-	},
-	.cfg_enc = CIPH_ENCR | MOD_AES | MOD_CTR,
-	.cfg_dec = CIPH_ENCR | MOD_AES | MOD_CTR,
 } };
 
 static struct ixp_aead_alg ixp4xx_aeads[] = {
