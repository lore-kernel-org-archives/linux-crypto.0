Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0905CC4345D
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7CF720829
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgG1HT3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54884 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HT3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtW-0006St-CN; Tue, 28 Jul 2020 17:19:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:26 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:26 +1000
Subject: [v3 PATCH 21/31] crypto: ccp - Remove rfc3686 implementation
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtW-0006St-CN@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementation in ccp is pretty much the same
as the generic rfc3686 wrapper.  So it can simply be removed to
reduce complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccp/ccp-crypto-aes.c |   99 ------------------------------------
 drivers/crypto/ccp/ccp-crypto.h     |    6 --
 2 files changed, 105 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index e6dcd8cedd53e..a45e5c994e381 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -131,78 +131,6 @@ static int ccp_aes_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-static int ccp_aes_rfc3686_complete(struct crypto_async_request *async_req,
-				    int ret)
-{
-	struct skcipher_request *req = skcipher_request_cast(async_req);
-	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
-
-	/* Restore the original pointer */
-	req->iv = rctx->rfc3686_info;
-
-	return ccp_aes_complete(async_req, ret);
-}
-
-static int ccp_aes_rfc3686_setkey(struct crypto_skcipher *tfm, const u8 *key,
-				  unsigned int key_len)
-{
-	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	if (key_len < CTR_RFC3686_NONCE_SIZE)
-		return -EINVAL;
-
-	key_len -= CTR_RFC3686_NONCE_SIZE;
-	memcpy(ctx->u.aes.nonce, key + key_len, CTR_RFC3686_NONCE_SIZE);
-
-	return ccp_aes_setkey(tfm, key, key_len);
-}
-
-static int ccp_aes_rfc3686_crypt(struct skcipher_request *req, bool encrypt)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
-	u8 *iv;
-
-	/* Initialize the CTR block */
-	iv = rctx->rfc3686_iv;
-	memcpy(iv, ctx->u.aes.nonce, CTR_RFC3686_NONCE_SIZE);
-
-	iv += CTR_RFC3686_NONCE_SIZE;
-	memcpy(iv, req->iv, CTR_RFC3686_IV_SIZE);
-
-	iv += CTR_RFC3686_IV_SIZE;
-	*(__be32 *)iv = cpu_to_be32(1);
-
-	/* Point to the new IV */
-	rctx->rfc3686_info = req->iv;
-	req->iv = rctx->rfc3686_iv;
-
-	return ccp_aes_crypt(req, encrypt);
-}
-
-static int ccp_aes_rfc3686_encrypt(struct skcipher_request *req)
-{
-	return ccp_aes_rfc3686_crypt(req, true);
-}
-
-static int ccp_aes_rfc3686_decrypt(struct skcipher_request *req)
-{
-	return ccp_aes_rfc3686_crypt(req, false);
-}
-
-static int ccp_aes_rfc3686_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->complete = ccp_aes_rfc3686_complete;
-	ctx->u.aes.key_len = 0;
-
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct ccp_aes_req_ctx));
-
-	return 0;
-}
-
 static const struct skcipher_alg ccp_aes_defaults = {
 	.setkey			= ccp_aes_setkey,
 	.encrypt		= ccp_aes_encrypt,
@@ -221,24 +149,6 @@ static const struct skcipher_alg ccp_aes_defaults = {
 	.base.cra_module	= THIS_MODULE,
 };
 
-static const struct skcipher_alg ccp_aes_rfc3686_defaults = {
-	.setkey			= ccp_aes_rfc3686_setkey,
-	.encrypt		= ccp_aes_rfc3686_encrypt,
-	.decrypt		= ccp_aes_rfc3686_decrypt,
-	.min_keysize		= AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-	.init			= ccp_aes_rfc3686_init_tfm,
-
-	.base.cra_flags		= CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_ALLOCATES_MEMORY |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize	= CTR_RFC3686_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ccp_ctx),
-	.base.cra_priority	= CCP_CRA_PRIORITY,
-	.base.cra_module	= THIS_MODULE,
-};
-
 struct ccp_aes_def {
 	enum ccp_aes_mode mode;
 	unsigned int version;
@@ -295,15 +205,6 @@ static struct ccp_aes_def aes_algs[] = {
 		.ivsize		= AES_BLOCK_SIZE,
 		.alg_defaults	= &ccp_aes_defaults,
 	},
-	{
-		.mode		= CCP_AES_MODE_CTR,
-		.version	= CCP_VERSION(3, 0),
-		.name		= "rfc3686(ctr(aes))",
-		.driver_name	= "rfc3686-ctr-aes-ccp",
-		.blocksize	= 1,
-		.ivsize		= CTR_RFC3686_IV_SIZE,
-		.alg_defaults	= &ccp_aes_rfc3686_defaults,
-	},
 };
 
 static int ccp_register_aes_alg(struct list_head *head,
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index aed3d2192d013..a837b2a994d9f 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -99,8 +99,6 @@ struct ccp_aes_ctx {
 	unsigned int key_len;
 	u8 key[AES_MAX_KEY_SIZE * 2];
 
-	u8 nonce[CTR_RFC3686_NONCE_SIZE];
-
 	/* CMAC key structures */
 	struct scatterlist k1_sg;
 	struct scatterlist k2_sg;
@@ -116,10 +114,6 @@ struct ccp_aes_req_ctx {
 	struct scatterlist tag_sg;
 	u8 tag[AES_BLOCK_SIZE];
 
-	/* Fields used for RFC3686 requests */
-	u8 *rfc3686_info;
-	u8 rfc3686_iv[AES_BLOCK_SIZE];
-
 	struct ccp_cmd cmd;
 
 	struct skcipher_request fallback_req;	// keep at the end
