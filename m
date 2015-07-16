From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: chacha20poly1305 - Convert to new AEAD interface
Date: Thu, 16 Jul 2015 12:35:08 +0800
Message-ID: <20150716043508.GA9441@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Martin Willi <martin@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60242 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbGPEfN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 00:35:13 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc7539 and rfc7539esp to the new AEAD interface.
The test vectors for rfc7539esp have also been updated to include
the IV.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/chacha20poly1305.c |  213 +++++++++++++++++++++++++++-------------------
 crypto/testmgr.h          |   10 +-
 2 files changed, 133 insertions(+), 90 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 7b46ed7..8626093 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -60,12 +60,16 @@ struct chacha_req {
 };
 
 struct chachapoly_req_ctx {
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
 	/* the key we generate for Poly1305 using Chacha20 */
 	u8 key[POLY1305_KEY_SIZE];
 	/* calculated Poly1305 tag */
 	u8 tag[POLY1305_DIGEST_SIZE];
 	/* length of data to en/decrypt, without ICV */
 	unsigned int cryptlen;
+	/* Actual AD, excluding IV */
+	unsigned int assoclen;
 	union {
 		struct poly_req poly;
 		struct chacha_req chacha;
@@ -98,7 +102,9 @@ static int poly_verify_tag(struct aead_request *req)
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	u8 tag[sizeof(rctx->tag)];
 
-	scatterwalk_map_and_copy(tag, req->src, rctx->cryptlen, sizeof(tag), 0);
+	scatterwalk_map_and_copy(tag, req->src,
+				 req->assoclen + rctx->cryptlen,
+				 sizeof(tag), 0);
 	if (crypto_memneq(tag, rctx->tag, sizeof(tag)))
 		return -EBADMSG;
 	return 0;
@@ -108,7 +114,8 @@ static int poly_copy_tag(struct aead_request *req)
 {
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
-	scatterwalk_map_and_copy(rctx->tag, req->dst, rctx->cryptlen,
+	scatterwalk_map_and_copy(rctx->tag, req->dst,
+				 req->assoclen + rctx->cryptlen,
 				 sizeof(rctx->tag), 1);
 	return 0;
 }
@@ -123,14 +130,24 @@ static int chacha_decrypt(struct aead_request *req)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct chacha_req *creq = &rctx->u.chacha;
+	struct scatterlist *src, *dst;
 	int err;
 
 	chacha_iv(creq->iv, req, 1);
 
+	sg_init_table(rctx->src, 2);
+	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst) {
+		sg_init_table(rctx->dst, 2);
+		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
+	}
+
 	ablkcipher_request_set_callback(&creq->req, aead_request_flags(req),
 					chacha_decrypt_done, req);
 	ablkcipher_request_set_tfm(&creq->req, ctx->chacha);
-	ablkcipher_request_set_crypt(&creq->req, req->src, req->dst,
+	ablkcipher_request_set_crypt(&creq->req, src, dst,
 				     rctx->cryptlen, creq->iv);
 	err = crypto_ablkcipher_decrypt(&creq->req);
 	if (err)
@@ -156,14 +173,15 @@ static void poly_tail_done(struct crypto_async_request *areq, int err)
 
 static int poly_tail(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	__le64 len;
 	int err;
 
 	sg_init_table(preq->src, 1);
-	len = cpu_to_le64(req->assoclen);
+	len = cpu_to_le64(rctx->assoclen);
 	memcpy(&preq->tail.assoclen, &len, sizeof(len));
 	len = cpu_to_le64(rctx->cryptlen);
 	memcpy(&preq->tail.cryptlen, &len, sizeof(len));
@@ -228,6 +246,9 @@ static int poly_cipher(struct aead_request *req)
 	if (rctx->cryptlen == req->cryptlen) /* encrypting */
 		crypt = req->dst;
 
+	sg_init_table(rctx->src, 2);
+	crypt = scatterwalk_ffwd(rctx->src, crypt, req->assoclen);
+
 	ahash_request_set_callback(&preq->req, aead_request_flags(req),
 				   poly_cipher_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
@@ -253,7 +274,7 @@ static int poly_adpad(struct aead_request *req)
 	unsigned int padlen, bs = POLY1305_BLOCK_SIZE;
 	int err;
 
-	padlen = (bs - (req->assoclen % bs)) % bs;
+	padlen = (bs - (rctx->assoclen % bs)) % bs;
 	memset(preq->pad, 0, sizeof(preq->pad));
 	sg_init_table(preq->src, 1);
 	sg_set_buf(preq->src, preq->pad, padlen);
@@ -285,7 +306,7 @@ static int poly_ad(struct aead_request *req)
 	ahash_request_set_callback(&preq->req, aead_request_flags(req),
 				   poly_ad_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, req->assoc, NULL, req->assoclen);
+	ahash_request_set_crypt(&preq->req, req->src, NULL, rctx->assoclen);
 
 	err = crypto_ahash_update(&preq->req);
 	if (err)
@@ -351,11 +372,20 @@ static void poly_genkey_done(struct crypto_async_request *areq, int err)
 
 static int poly_genkey(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct chacha_req *creq = &rctx->u.chacha;
 	int err;
 
+	rctx->assoclen = req->assoclen;
+
+	if (crypto_aead_ivsize(tfm) == 8) {
+		if (rctx->assoclen < 8)
+			return -EINVAL;
+		rctx->assoclen -= 8;
+	}
+
 	sg_init_table(creq->src, 1);
 	memset(rctx->key, 0, sizeof(rctx->key));
 	sg_set_buf(creq->src, rctx->key, sizeof(rctx->key));
@@ -385,14 +415,24 @@ static int chacha_encrypt(struct aead_request *req)
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct chacha_req *creq = &rctx->u.chacha;
+	struct scatterlist *src, *dst;
 	int err;
 
 	chacha_iv(creq->iv, req, 1);
 
+	sg_init_table(rctx->src, 2);
+	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst) {
+		sg_init_table(rctx->dst, 2);
+		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
+	}
+
 	ablkcipher_request_set_callback(&creq->req, aead_request_flags(req),
 					chacha_encrypt_done, req);
 	ablkcipher_request_set_tfm(&creq->req, ctx->chacha);
-	ablkcipher_request_set_crypt(&creq->req, req->src, req->dst,
+	ablkcipher_request_set_crypt(&creq->req, src, dst,
 				     req->cryptlen, creq->iv);
 	err = crypto_ablkcipher_encrypt(&creq->req);
 	if (err)
@@ -426,8 +466,6 @@ static int chachapoly_decrypt(struct aead_request *req)
 {
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
-	if (req->cryptlen < POLY1305_DIGEST_SIZE)
-		return -EINVAL;
 	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
 
 	/* decrypt call chain:
@@ -476,11 +514,11 @@ static int chachapoly_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static int chachapoly_init(struct crypto_tfm *tfm)
+static int chachapoly_init(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct chachapoly_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct chachapoly_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct chachapoly_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ablkcipher *chacha;
 	struct crypto_ahash *poly;
 	unsigned long align;
@@ -499,77 +537,88 @@ static int chachapoly_init(struct crypto_tfm *tfm)
 	ctx->poly = poly;
 	ctx->saltlen = ictx->saltlen;
 
-	align = crypto_tfm_alg_alignmask(tfm);
+	align = crypto_aead_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				align + offsetof(struct chachapoly_req_ctx, u) +
-				max(offsetof(struct chacha_req, req) +
-				    sizeof(struct ablkcipher_request) +
-				    crypto_ablkcipher_reqsize(chacha),
-				    offsetof(struct poly_req, req) +
-				    sizeof(struct ahash_request) +
-				    crypto_ahash_reqsize(poly)));
+	crypto_aead_set_reqsize(
+		tfm,
+		align + offsetof(struct chachapoly_req_ctx, u) +
+		max(offsetof(struct chacha_req, req) +
+		    sizeof(struct ablkcipher_request) +
+		    crypto_ablkcipher_reqsize(chacha),
+		    offsetof(struct poly_req, req) +
+		    sizeof(struct ahash_request) +
+		    crypto_ahash_reqsize(poly)));
 
 	return 0;
 }
 
-static void chachapoly_exit(struct crypto_tfm *tfm)
+static void chachapoly_exit(struct crypto_aead *tfm)
 {
-	struct chachapoly_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->poly);
 	crypto_free_ablkcipher(ctx->chacha);
 }
 
-static struct crypto_instance *chachapoly_alloc(struct rtattr **tb,
-						const char *name,
-						unsigned int ivsize)
+static void chachapoly_free(struct aead_instance *inst)
+{
+	struct chachapoly_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->chacha);
+	crypto_drop_ahash(&ctx->poly);
+	kfree(inst);
+}
+
+static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
+			     const char *name, unsigned int ivsize)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_alg *chacha;
 	struct crypto_alg *poly;
-	struct ahash_alg *poly_ahash;
+	struct hash_alg_common *poly_hash;
 	struct chachapoly_instance_ctx *ctx;
 	const char *chacha_name, *poly_name;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
+		return -EINVAL;
 
 	chacha_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(chacha_name))
-		return ERR_CAST(chacha_name);
+		return PTR_ERR(chacha_name);
 	poly_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(poly_name))
-		return ERR_CAST(poly_name);
+		return PTR_ERR(poly_name);
 
 	poly = crypto_find_alg(poly_name, &crypto_ahash_type,
 			       CRYPTO_ALG_TYPE_HASH,
 			       CRYPTO_ALG_TYPE_AHASH_MASK);
 	if (IS_ERR(poly))
-		return ERR_CAST(poly);
+		return PTR_ERR(poly);
 
 	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		goto out_put_poly;
 
-	ctx = crypto_instance_ctx(inst);
+	ctx = aead_instance_ctx(inst);
 	ctx->saltlen = CHACHAPOLY_IV_SIZE - ivsize;
-	poly_ahash = container_of(poly, struct ahash_alg, halg.base);
-	err = crypto_init_ahash_spawn(&ctx->poly, &poly_ahash->halg, inst);
+	poly_hash = __crypto_hash_alg_common(poly);
+	err = crypto_init_ahash_spawn(&ctx->poly, poly_hash,
+				      aead_crypto_instance(inst));
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->chacha, inst);
+	crypto_set_skcipher_spawn(&ctx->chacha, aead_crypto_instance(inst));
 	err = crypto_grab_skcipher(&ctx->chacha, chacha_name, 0,
 				   crypto_requires_sync(algt->type,
 							algt->mask));
@@ -587,37 +636,43 @@ static struct crypto_instance *chachapoly_alloc(struct rtattr **tb,
 		goto out_drop_chacha;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha_name,
 		     poly_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s,%s)", name, chacha->cra_driver_name,
 		     poly->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_chacha;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= (chacha->cra_flags |
-				poly->cra_flags) & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = (chacha->cra_priority +
-				  poly->cra_priority) / 2;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = chacha->cra_alignmask | poly->cra_alignmask;
-	inst->alg.cra_type = &crypto_nivaead_type;
-	inst->alg.cra_aead.ivsize = ivsize;
-	inst->alg.cra_aead.maxauthsize = POLY1305_DIGEST_SIZE;
-	inst->alg.cra_ctxsize = sizeof(struct chachapoly_ctx) + ctx->saltlen;
-	inst->alg.cra_init = chachapoly_init;
-	inst->alg.cra_exit = chachapoly_exit;
-	inst->alg.cra_aead.encrypt = chachapoly_encrypt;
-	inst->alg.cra_aead.decrypt = chachapoly_decrypt;
-	inst->alg.cra_aead.setkey = chachapoly_setkey;
-	inst->alg.cra_aead.setauthsize = chachapoly_setauthsize;
-	inst->alg.cra_aead.geniv = "seqiv";
-
-out:
+	inst->alg.base.cra_flags = (chacha->cra_flags | poly->cra_flags) &
+				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
+	inst->alg.base.cra_priority = (chacha->cra_priority +
+				       poly->cra_priority) / 2;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = chacha->cra_alignmask |
+				       poly->cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
+				     ctx->saltlen;
+	inst->alg.ivsize = ivsize;
+	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
+	inst->alg.init = chachapoly_init;
+	inst->alg.exit = chachapoly_exit;
+	inst->alg.encrypt = chachapoly_encrypt;
+	inst->alg.decrypt = chachapoly_decrypt;
+	inst->alg.setkey = chachapoly_setkey;
+	inst->alg.setauthsize = chachapoly_setauthsize;
+
+	inst->free = chachapoly_free;
+
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_chacha;
+
+out_put_poly:
 	crypto_mod_put(poly);
-	return inst;
+	return err;
 
 out_drop_chacha:
 	crypto_drop_skcipher(&ctx->chacha);
@@ -625,41 +680,28 @@ err_drop_poly:
 	crypto_drop_ahash(&ctx->poly);
 err_free_inst:
 	kfree(inst);
-out_put_poly:
-	inst = ERR_PTR(err);
-	goto out;
-}
-
-static struct crypto_instance *rfc7539_alloc(struct rtattr **tb)
-{
-	return chachapoly_alloc(tb, "rfc7539", 12);
+	goto out_put_poly;
 }
 
-static struct crypto_instance *rfc7539esp_alloc(struct rtattr **tb)
+static int rfc7539_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	return chachapoly_alloc(tb, "rfc7539esp", 8);
+	return chachapoly_create(tmpl, tb, "rfc7539", 12);
 }
 
-static void chachapoly_free(struct crypto_instance *inst)
+static int rfc7539esp_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct chachapoly_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_skcipher(&ctx->chacha);
-	crypto_drop_ahash(&ctx->poly);
-	kfree(inst);
+	return chachapoly_create(tmpl, tb, "rfc7539esp", 8);
 }
 
 static struct crypto_template rfc7539_tmpl = {
 	.name = "rfc7539",
-	.alloc = rfc7539_alloc,
-	.free = chachapoly_free,
+	.create = rfc7539_create,
 	.module = THIS_MODULE,
 };
 
 static struct crypto_template rfc7539esp_tmpl = {
 	.name = "rfc7539esp",
-	.alloc = rfc7539esp_alloc,
-	.free = chachapoly_free,
+	.create = rfc7539esp_create,
 	.module = THIS_MODULE,
 };
 
@@ -690,6 +732,5 @@ module_exit(chacha20poly1305_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("ChaCha20-Poly1305 AEAD");
-MODULE_ALIAS_CRYPTO("chacha20poly1305");
 MODULE_ALIAS_CRYPTO("rfc7539");
 MODULE_ALIAS_CRYPTO("rfc7539esp");
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 3dc1c95..1ae7acd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -23577,8 +23577,9 @@ static struct aead_testvec rfc7539esp_enc_tv_template[] = {
 		.klen	= 36,
 		.iv	= "\x01\x02\x03\x04\x05\x06\x07\x08",
 		.assoc	= "\xf3\x33\x88\x86\x00\x00\x00\x00"
-			  "\x00\x00\x4e\x91",
-		.alen	= 12,
+			  "\x00\x00\x4e\x91\x01\x02\x03\x04"
+			  "\x05\x06\x07\x08",
+		.alen	= 20,
 		.input	= "\x49\x6e\x74\x65\x72\x6e\x65\x74"
 			  "\x2d\x44\x72\x61\x66\x74\x73\x20"
 			  "\x61\x72\x65\x20\x64\x72\x61\x66"
@@ -23664,8 +23665,9 @@ static struct aead_testvec rfc7539esp_dec_tv_template[] = {
 		.klen	= 36,
 		.iv	= "\x01\x02\x03\x04\x05\x06\x07\x08",
 		.assoc	= "\xf3\x33\x88\x86\x00\x00\x00\x00"
-			  "\x00\x00\x4e\x91",
-		.alen	= 12,
+			  "\x00\x00\x4e\x91\x01\x02\x03\x04"
+			  "\x05\x06\x07\x08",
+		.alen	= 20,
 		.input	= "\x64\xa0\x86\x15\x75\x86\x1a\xf4"
 			  "\x60\xf0\x62\xc7\x9b\xe6\x43\xbd"
 			  "\x5e\x80\x5c\xfd\x34\x5c\xf3\x89"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
