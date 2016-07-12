From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/30] crypto: chacha20poly1305 - Use skcipher
Date: Tue, 12 Jul 2016 13:17:40 +0800
Message-ID: <E1bMq4i-0007QF-HE@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43153 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbcGLFRo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:44 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4i-0004Zt-Ph
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:40 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts chacha20poly1305 to use the new skcipher
interface as opposed to ablkcipher.

It also fixes a buglet where we may end up with an async poly1305
when the user asks for a async algorithm.  This shouldn't be a
problem yet as there aren't any async implementations of poly1305
out there.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/chacha20poly1305.c |   89 +++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 43 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 7b6b935..e899ef5 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -31,7 +31,7 @@ struct chachapoly_instance_ctx {
 };
 
 struct chachapoly_ctx {
-	struct crypto_ablkcipher *chacha;
+	struct crypto_skcipher *chacha;
 	struct crypto_ahash *poly;
 	/* key bytes we use for the ChaCha20 IV */
 	unsigned int saltlen;
@@ -53,7 +53,7 @@ struct poly_req {
 struct chacha_req {
 	u8 iv[CHACHA20_IV_SIZE];
 	struct scatterlist src[1];
-	struct ablkcipher_request req; /* must be last member */
+	struct skcipher_request req; /* must be last member */
 };
 
 struct chachapoly_req_ctx {
@@ -144,12 +144,12 @@ static int chacha_decrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	ablkcipher_request_set_callback(&creq->req, aead_request_flags(req),
-					chacha_decrypt_done, req);
-	ablkcipher_request_set_tfm(&creq->req, ctx->chacha);
-	ablkcipher_request_set_crypt(&creq->req, src, dst,
-				     rctx->cryptlen, creq->iv);
-	err = crypto_ablkcipher_decrypt(&creq->req);
+	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+				      chacha_decrypt_done, req);
+	skcipher_request_set_tfm(&creq->req, ctx->chacha);
+	skcipher_request_set_crypt(&creq->req, src, dst,
+				   rctx->cryptlen, creq->iv);
+	err = crypto_skcipher_decrypt(&creq->req);
 	if (err)
 		return err;
 
@@ -393,13 +393,13 @@ static int poly_genkey(struct aead_request *req)
 
 	chacha_iv(creq->iv, req, 0);
 
-	ablkcipher_request_set_callback(&creq->req, aead_request_flags(req),
-					poly_genkey_done, req);
-	ablkcipher_request_set_tfm(&creq->req, ctx->chacha);
-	ablkcipher_request_set_crypt(&creq->req, creq->src, creq->src,
-				     POLY1305_KEY_SIZE, creq->iv);
+	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+				      poly_genkey_done, req);
+	skcipher_request_set_tfm(&creq->req, ctx->chacha);
+	skcipher_request_set_crypt(&creq->req, creq->src, creq->src,
+				   POLY1305_KEY_SIZE, creq->iv);
 
-	err = crypto_ablkcipher_decrypt(&creq->req);
+	err = crypto_skcipher_decrypt(&creq->req);
 	if (err)
 		return err;
 
@@ -433,12 +433,12 @@ static int chacha_encrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
 	}
 
-	ablkcipher_request_set_callback(&creq->req, aead_request_flags(req),
-					chacha_encrypt_done, req);
-	ablkcipher_request_set_tfm(&creq->req, ctx->chacha);
-	ablkcipher_request_set_crypt(&creq->req, src, dst,
-				     req->cryptlen, creq->iv);
-	err = crypto_ablkcipher_encrypt(&creq->req);
+	skcipher_request_set_callback(&creq->req, aead_request_flags(req),
+				      chacha_encrypt_done, req);
+	skcipher_request_set_tfm(&creq->req, ctx->chacha);
+	skcipher_request_set_crypt(&creq->req, src, dst,
+				   req->cryptlen, creq->iv);
+	err = crypto_skcipher_encrypt(&creq->req);
 	if (err)
 		return err;
 
@@ -500,13 +500,13 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 	keylen -= ctx->saltlen;
 	memcpy(ctx->salt, key + keylen, ctx->saltlen);
 
-	crypto_ablkcipher_clear_flags(ctx->chacha, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(ctx->chacha, crypto_aead_get_flags(aead) &
-				    CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(ctx->chacha, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctx->chacha, crypto_aead_get_flags(aead) &
+					       CRYPTO_TFM_REQ_MASK);
 
-	err = crypto_ablkcipher_setkey(ctx->chacha, key, keylen);
-	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctx->chacha) &
-			      CRYPTO_TFM_RES_MASK);
+	err = crypto_skcipher_setkey(ctx->chacha, key, keylen);
+	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctx->chacha) &
+				    CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
@@ -524,7 +524,7 @@ static int chachapoly_init(struct crypto_aead *tfm)
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct chachapoly_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
-	struct crypto_ablkcipher *chacha;
+	struct crypto_skcipher *chacha;
 	struct crypto_ahash *poly;
 	unsigned long align;
 
@@ -532,7 +532,7 @@ static int chachapoly_init(struct crypto_aead *tfm)
 	if (IS_ERR(poly))
 		return PTR_ERR(poly);
 
-	chacha = crypto_spawn_skcipher(&ictx->chacha);
+	chacha = crypto_spawn_skcipher2(&ictx->chacha);
 	if (IS_ERR(chacha)) {
 		crypto_free_ahash(poly);
 		return PTR_ERR(chacha);
@@ -548,8 +548,8 @@ static int chachapoly_init(struct crypto_aead *tfm)
 		tfm,
 		align + offsetof(struct chachapoly_req_ctx, u) +
 		max(offsetof(struct chacha_req, req) +
-		    sizeof(struct ablkcipher_request) +
-		    crypto_ablkcipher_reqsize(chacha),
+		    sizeof(struct skcipher_request) +
+		    crypto_skcipher_reqsize(chacha),
 		    offsetof(struct poly_req, req) +
 		    sizeof(struct ahash_request) +
 		    crypto_ahash_reqsize(poly)));
@@ -562,7 +562,7 @@ static void chachapoly_exit(struct crypto_aead *tfm)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->poly);
-	crypto_free_ablkcipher(ctx->chacha);
+	crypto_free_skcipher(ctx->chacha);
 }
 
 static void chachapoly_free(struct aead_instance *inst)
@@ -579,7 +579,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 {
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
-	struct crypto_alg *chacha;
+	struct skcipher_alg *chacha;
 	struct crypto_alg *poly;
 	struct hash_alg_common *poly_hash;
 	struct chachapoly_instance_ctx *ctx;
@@ -605,7 +605,9 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	poly = crypto_find_alg(poly_name, &crypto_ahash_type,
 			       CRYPTO_ALG_TYPE_HASH,
-			       CRYPTO_ALG_TYPE_AHASH_MASK);
+			       CRYPTO_ALG_TYPE_AHASH_MASK |
+			       crypto_requires_sync(algt->type,
+						    algt->mask));
 	if (IS_ERR(poly))
 		return PTR_ERR(poly);
 
@@ -623,20 +625,20 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ctx->chacha, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->chacha, chacha_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher2(&ctx->chacha, chacha_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
 		goto err_drop_poly;
 
-	chacha = crypto_skcipher_spawn_alg(&ctx->chacha);
+	chacha = crypto_spawn_skcipher_alg(&ctx->chacha);
 
 	err = -EINVAL;
 	/* Need 16-byte IV size, including Initial Block Counter value */
-	if (chacha->cra_ablkcipher.ivsize != CHACHA20_IV_SIZE)
+	if (crypto_skcipher_alg_ivsize(chacha) != CHACHA20_IV_SIZE)
 		goto out_drop_chacha;
 	/* Not a stream cipher? */
-	if (chacha->cra_blocksize != 1)
+	if (chacha->base.cra_blocksize != 1)
 		goto out_drop_chacha;
 
 	err = -ENAMETOOLONG;
@@ -645,20 +647,21 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		     poly_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha->cra_driver_name,
+		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
 		     poly->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 
-	inst->alg.base.cra_flags = (chacha->cra_flags | poly->cra_flags) &
+	inst->alg.base.cra_flags = (chacha->base.cra_flags | poly->cra_flags) &
 				   CRYPTO_ALG_ASYNC;
-	inst->alg.base.cra_priority = (chacha->cra_priority +
+	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
-	inst->alg.base.cra_alignmask = chacha->cra_alignmask |
+	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask |
 				       poly->cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
 				     ctx->saltlen;
 	inst->alg.ivsize = ivsize;
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(chacha);
 	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
 	inst->alg.init = chachapoly_init;
 	inst->alg.exit = chachapoly_exit;
