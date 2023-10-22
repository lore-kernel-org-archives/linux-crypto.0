Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B518C25B41
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjJVITB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjJVISv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA80D6
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E216C433CC
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962727;
        bh=lPPbYdbgfbrKCmPW4nPEZ82xkcPLGV4O1S80gtxQjyY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sd7ohR2WSW6S7WS3R0eCP+i7ycUf40DYiIVa+XPL0RZyFhRr5eleXwQpXyLtetlp1
         yOu6AANCTGrtZigsB/nwrx+G79dXoPONxbXZwzalf+oghh+clBNeYWQS9FpTcxc6/I
         7D8n9c40RZDh9FWOh7Rfph0vVT4UcxfrzFJjr+dPm1RtE2a517NSuLvnPqxNy/mLfa
         4/RN+ouXC6eAeBrr4dpp3mWAErv/+HpeX19KZ9ihHGqdME2PXBPl+C5NQxodmbtNFC
         UP2LFEnEwVImn+YfvpKqlfYN8xEZMUbobGLxjXKxIBqNu97sZjpn+X3F6JySXaI1HM
         IBuOqJa+FcZdA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 16/30] crypto: authencesn - stop using alignmask of ahash
Date:   Sun, 22 Oct 2023 01:10:46 -0700
Message-ID: <20231022081100.123613-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the alignmask for ahash and shash algorithms is always 0,
simplify the code in authenc accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authencesn.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 60e9568f023f6..2cc933e2f7901 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -80,25 +80,22 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	err = crypto_skcipher_setkey(enc, keys.enckey, keys.enckeylen);
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
 
 static int crypto_authenc_esn_genicv_tail(struct aead_request *req,
 					  unsigned int flags)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_ahash *auth = ctx->auth;
-	u8 *hash = PTR_ALIGN((u8 *)areq_ctx->tail,
-			     crypto_ahash_alignmask(auth) + 1);
+	u8 *hash = areq_ctx->tail;
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 
 	/* Move high-order bits of sequence number back. */
 	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
 	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
 	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
@@ -115,22 +112,21 @@ static void authenc_esn_geniv_ahash_done(void *data, int err)
 	aead_request_complete(req, err);
 }
 
 static int crypto_authenc_esn_genicv(struct aead_request *req,
 				     unsigned int flags)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct crypto_ahash *auth = ctx->auth;
-	u8 *hash = PTR_ALIGN((u8 *)areq_ctx->tail,
-			     crypto_ahash_alignmask(auth) + 1);
+	u8 *hash = areq_ctx->tail;
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 
 	if (!authsize)
 		return 0;
 
@@ -217,22 +213,21 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 					   unsigned int flags)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
 						  ctx->reqoff);
 	struct crypto_ahash *auth = ctx->auth;
-	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
-			      crypto_ahash_alignmask(auth) + 1);
+	u8 *ohash = areq_ctx->tail;
 	unsigned int cryptlen = req->cryptlen - authsize;
 	unsigned int assoclen = req->assoclen;
 	struct scatterlist *dst = req->dst;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	u32 tmp[2];
 
 	if (!authsize)
 		goto decrypt;
 
 	/* Move high-order bits of sequence number back. */
@@ -265,22 +260,21 @@ static void authenc_esn_verify_ahash_done(void *data, int err)
 }
 
 static int crypto_authenc_esn_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ctx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
 	struct crypto_ahash *auth = ctx->auth;
-	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
-			      crypto_ahash_alignmask(auth) + 1);
+	u8 *ohash = areq_ctx->tail;
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 	int err;
 
 	cryptlen -= authsize;
 
 	if (req->src != dst) {
@@ -337,22 +331,21 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 
 	null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_skcipher;
 
 	ctx->auth = auth;
 	ctx->enc = enc;
 	ctx->null = null;
 
-	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth),
-			    crypto_ahash_alignmask(auth) + 1);
+	ctx->reqoff = 2 * crypto_ahash_digestsize(auth);
 
 	crypto_aead_set_reqsize(
 		tfm,
 		sizeof(struct authenc_esn_request_ctx) +
 		ctx->reqoff +
 		max_t(unsigned int,
 		      crypto_ahash_reqsize(auth) +
 		      sizeof(struct ahash_request),
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(enc)));
@@ -424,22 +417,21 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_driver_name,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
-	inst->alg.base.cra_alignmask = auth_base->cra_alignmask |
-				       enc->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = enc->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_esn_ctx);
 
 	inst->alg.ivsize = enc->ivsize;
 	inst->alg.chunksize = enc->chunksize;
 	inst->alg.maxauthsize = auth->digestsize;
 
 	inst->alg.init = crypto_authenc_esn_init_tfm;
 	inst->alg.exit = crypto_authenc_esn_exit_tfm;
 
 	inst->alg.setkey = crypto_authenc_esn_setkey;
-- 
2.42.0

