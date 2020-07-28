Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5C4C433F1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A584220792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgG1HTc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54894 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtY-0006TY-Ki; Tue, 28 Jul 2020 17:19:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:28 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:28 +1000
Subject: [v3 PATCH 22/31] crypto: chelsio - Remove rfc3686 implementation
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtY-0006TY-Ki@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementation in chelsio is pretty much the same
as the generic rfc3686 wrapper.  So it can simply be removed to
reduce complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/chelsio/chcr_algo.c |  109 +------------------------------------
 1 file changed, 4 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 13b908ea48738..8374be72454db 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -856,9 +856,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 	chcr_req->key_ctx.ctx_hdr = ablkctx->key_ctx_hdr;
 	if ((reqctx->op == CHCR_DECRYPT_OP) &&
 	    (!(get_cryptoalg_subtype(tfm) ==
-	       CRYPTO_ALG_SUB_TYPE_CTR)) &&
-	    (!(get_cryptoalg_subtype(tfm) ==
-	       CRYPTO_ALG_SUB_TYPE_CTR_RFC3686))) {
+	       CRYPTO_ALG_SUB_TYPE_CTR))) {
 		generate_copy_rrkey(ablkctx, &chcr_req->key_ctx);
 	} else {
 		if ((ablkctx->ciph_mode == CHCR_SCMD_CIPHER_MODE_AES_CBC) ||
@@ -988,42 +986,6 @@ static int chcr_aes_ctr_setkey(struct crypto_skcipher *cipher,
 	return err;
 }
 
-static int chcr_aes_rfc3686_setkey(struct crypto_skcipher *cipher,
-				   const u8 *key,
-				   unsigned int keylen)
-{
-	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(cipher));
-	unsigned int ck_size, context_size;
-	u16 alignment = 0;
-	int err;
-
-	if (keylen < CTR_RFC3686_NONCE_SIZE)
-		return -EINVAL;
-	memcpy(ablkctx->nonce, key + (keylen - CTR_RFC3686_NONCE_SIZE),
-	       CTR_RFC3686_NONCE_SIZE);
-
-	keylen -= CTR_RFC3686_NONCE_SIZE;
-	err = chcr_cipher_fallback_setkey(cipher, key, keylen);
-	if (err)
-		goto badkey_err;
-
-	ck_size = chcr_keyctx_ck_size(keylen);
-	alignment = (ck_size == CHCR_KEYCTX_CIPHER_KEY_SIZE_192) ? 8 : 0;
-	memcpy(ablkctx->key, key, keylen);
-	ablkctx->enckey_len = keylen;
-	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD +
-			keylen + alignment) >> 4;
-
-	ablkctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, CHCR_KEYCTX_NO_KEY,
-						0, 0, context_size);
-	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_CTR;
-
-	return 0;
-badkey_err:
-	ablkctx->enckey_len = 0;
-
-	return err;
-}
 static void ctr_add_iv(u8 *dstiv, u8 *srciv, u32 add)
 {
 	unsigned int size = AES_BLOCK_SIZE;
@@ -1107,10 +1069,6 @@ static int chcr_update_cipher_iv(struct skcipher_request *req,
 	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR)
 		ctr_add_iv(iv, req->iv, (reqctx->processed /
 			   AES_BLOCK_SIZE));
-	else if (subtype == CRYPTO_ALG_SUB_TYPE_CTR_RFC3686)
-		*(__be32 *)(reqctx->iv + CTR_RFC3686_NONCE_SIZE +
-			CTR_RFC3686_IV_SIZE) = cpu_to_be32((reqctx->processed /
-						AES_BLOCK_SIZE) + 1);
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_XTS)
 		ret = chcr_update_tweak(req, iv, 0);
 	else if (subtype == CRYPTO_ALG_SUB_TYPE_CBC) {
@@ -1125,11 +1083,6 @@ static int chcr_update_cipher_iv(struct skcipher_request *req,
 
 }
 
-/* We need separate function for final iv because in rfc3686  Initial counter
- * starts from 1 and buffer size of iv is 8 byte only which remains constant
- * for subsequent update requests
- */
-
 static int chcr_final_cipher_iv(struct skcipher_request *req,
 				   struct cpl_fw6_pld *fw6_pld, u8 *iv)
 {
@@ -1313,30 +1266,16 @@ static int process_cipher(struct skcipher_request *req,
 	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR) {
 		bytes = adjust_ctr_overflow(req->iv, bytes);
 	}
-	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR_RFC3686) {
-		memcpy(reqctx->iv, ablkctx->nonce, CTR_RFC3686_NONCE_SIZE);
-		memcpy(reqctx->iv + CTR_RFC3686_NONCE_SIZE, req->iv,
-				CTR_RFC3686_IV_SIZE);
-
-		/* initialize counter portion of counter block */
-		*(__be32 *)(reqctx->iv + CTR_RFC3686_NONCE_SIZE +
-			CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
-		memcpy(reqctx->init_iv, reqctx->iv, IV);
 
-	} else {
+	memcpy(reqctx->iv, req->iv, IV);
+	memcpy(reqctx->init_iv, req->iv, IV);
 
-		memcpy(reqctx->iv, req->iv, IV);
-		memcpy(reqctx->init_iv, req->iv, IV);
-	}
 	if (unlikely(bytes == 0)) {
 		chcr_cipher_dma_unmap(&ULD_CTX(c_ctx(tfm))->lldi.pdev->dev,
 				      req);
 fallback:       atomic_inc(&adap->chcr_stats.fallback);
 		err = chcr_cipher_fallback(ablkctx->sw_cipher, req,
-					   subtype ==
-					   CRYPTO_ALG_SUB_TYPE_CTR_RFC3686 ?
-					   reqctx->iv : req->iv,
-					   op_type);
+					   req->iv, op_type);
 		goto error;
 	}
 	reqctx->op = op_type;
@@ -1486,27 +1425,6 @@ static int chcr_init_tfm(struct crypto_skcipher *tfm)
 	return chcr_device_init(ctx);
 }
 
-static int chcr_rfc3686_init(struct crypto_skcipher *tfm)
-{
-	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct chcr_context *ctx = crypto_skcipher_ctx(tfm);
-	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
-
-	/*RFC3686 initialises IV counter value to 1, rfc3686(ctr(aes))
-	 * cannot be used as fallback in chcr_handle_cipher_response
-	 */
-	ablkctx->sw_cipher = crypto_alloc_skcipher("ctr(aes)", 0,
-				CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ablkctx->sw_cipher)) {
-		pr_err("failed to allocate fallback for %s\n", alg->base.cra_name);
-		return PTR_ERR(ablkctx->sw_cipher);
-	}
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct chcr_skcipher_req_ctx) +
-				    crypto_skcipher_reqsize(ablkctx->sw_cipher));
-	return chcr_device_init(ctx);
-}
-
-
 static void chcr_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct chcr_context *ctx = crypto_skcipher_ctx(tfm);
@@ -3894,25 +3812,6 @@ static struct chcr_alg_template driver_algs[] = {
 			.decrypt		= chcr_aes_decrypt,
 		}
 	},
-	{
-		.type = CRYPTO_ALG_TYPE_SKCIPHER |
-			CRYPTO_ALG_SUB_TYPE_CTR_RFC3686,
-		.is_registered = 0,
-		.alg.skcipher = {
-			.base.cra_name		= "rfc3686(ctr(aes))",
-			.base.cra_driver_name	= "rfc3686-ctr-aes-chcr",
-			.base.cra_blocksize	= 1,
-
-			.init			= chcr_rfc3686_init,
-			.exit			= chcr_exit_tfm,
-			.min_keysize		= AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-			.max_keysize		= AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-			.ivsize			= CTR_RFC3686_IV_SIZE,
-			.setkey			= chcr_aes_rfc3686_setkey,
-			.encrypt		= chcr_aes_encrypt,
-			.decrypt		= chcr_aes_decrypt,
-		}
-	},
 	/* SHA */
 	{
 		.type = CRYPTO_ALG_TYPE_AHASH,
