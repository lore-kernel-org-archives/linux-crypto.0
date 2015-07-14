From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/5] crypto: ccm - Convert to new AEAD interface
Date: Tue, 14 Jul 2015 16:53:18 +0800
Message-ID: <E1ZEvxm-0005d8-EL@gondolin.me.apana.org.au>
References: <20150714084547.GA21551@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54001 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbGNIxW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 04:53:22 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZEvxn-0000Xi-2q
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2015 18:53:19 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts generic ccm and its associated transforms to
the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |  388 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 224 insertions(+), 164 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index a4d1a5e..b63f96a 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -36,14 +36,20 @@ struct crypto_rfc4309_ctx {
 	u8 nonce[3];
 };
 
+struct crypto_rfc4309_req_ctx {
+	struct scatterlist src[3];
+	struct scatterlist dst[3];
+	struct aead_request subreq;
+};
+
 struct crypto_ccm_req_priv_ctx {
 	u8 odata[16];
 	u8 idata[16];
 	u8 auth_tag[16];
 	u32 ilen;
 	u32 flags;
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
+	struct scatterlist src[3];
+	struct scatterlist dst[3];
 	struct ablkcipher_request abreq;
 };
 
@@ -265,7 +271,7 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	/* format associated data and compute into mac */
 	if (assoclen) {
 		pctx->ilen = format_adata(idata, assoclen);
-		get_data_to_compute(cipher, pctx, req->assoc, req->assoclen);
+		get_data_to_compute(cipher, pctx, req->src, req->assoclen);
 	} else {
 		pctx->ilen = 0;
 	}
@@ -286,7 +292,8 @@ static void crypto_ccm_encrypt_done(struct crypto_async_request *areq, int err)
 	u8 *odata = pctx->odata;
 
 	if (!err)
-		scatterwalk_map_and_copy(odata, req->dst, req->cryptlen,
+		scatterwalk_map_and_copy(odata, req->dst,
+					 req->assoclen + req->cryptlen,
 					 crypto_aead_authsize(aead), 1);
 	aead_request_complete(req, err);
 }
@@ -300,6 +307,41 @@ static inline int crypto_ccm_check_iv(const u8 *iv)
 	return 0;
 }
 
+static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag)
+{
+	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
+	struct scatterlist *sg;
+	u8 *iv = req->iv;
+	int err;
+
+	err = crypto_ccm_check_iv(iv);
+	if (err)
+		return err;
+
+	pctx->flags = aead_request_flags(req);
+
+	 /* Note: rfc 3610 and NIST 800-38C require counter of
+	 * zero to encrypt auth tag.
+	 */
+	memset(iv + 15 - iv[0], 0, iv[0] + 1);
+
+	sg_init_table(pctx->src, 3);
+	sg_set_buf(pctx->src, tag, 16);
+	sg = scatterwalk_ffwd(pctx->src + 1, req->src, req->assoclen);
+	if (sg != pctx->src + 1)
+		sg_chain(pctx->src, 2, sg);
+
+	if (req->src != req->dst) {
+		sg_init_table(pctx->dst, 3);
+		sg_set_buf(pctx->dst, tag, 16);
+		sg = scatterwalk_ffwd(pctx->dst + 1, req->dst, req->assoclen);
+		if (sg != pctx->dst + 1)
+			sg_chain(pctx->dst, 2, sg);
+	}
+
+	return 0;
+}
+
 static int crypto_ccm_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -312,32 +354,17 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	u8 *iv = req->iv;
 	int err;
 
-	err = crypto_ccm_check_iv(iv);
+	err = crypto_ccm_init_crypt(req, odata);
 	if (err)
 		return err;
 
-	pctx->flags = aead_request_flags(req);
-
-	err = crypto_ccm_auth(req, req->src, cryptlen);
+	err = crypto_ccm_auth(req, sg_next(pctx->src), cryptlen);
 	if (err)
 		return err;
 
-	 /* Note: rfc 3610 and NIST 800-38C require counter of
-	 * zero to encrypt auth tag.
-	 */
-	memset(iv + 15 - iv[0], 0, iv[0] + 1);
-
-	sg_init_table(pctx->src, 2);
-	sg_set_buf(pctx->src, odata, 16);
-	scatterwalk_sg_chain(pctx->src, 2, req->src);
-
 	dst = pctx->src;
-	if (req->src != req->dst) {
-		sg_init_table(pctx->dst, 2);
-		sg_set_buf(pctx->dst, odata, 16);
-		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
+	if (req->src != req->dst)
 		dst = pctx->dst;
-	}
 
 	ablkcipher_request_set_tfm(abreq, ctx->ctr);
 	ablkcipher_request_set_callback(abreq, pctx->flags,
@@ -348,7 +375,7 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 		return err;
 
 	/* copy authtag to end of dst */
-	scatterwalk_map_and_copy(odata, req->dst, cryptlen,
+	scatterwalk_map_and_copy(odata, sg_next(dst), cryptlen,
 				 crypto_aead_authsize(aead), 1);
 	return err;
 }
@@ -361,9 +388,14 @@ static void crypto_ccm_decrypt_done(struct crypto_async_request *areq,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen - authsize;
+	struct scatterlist *dst;
+
+	pctx->flags = 0;
+
+	dst = sg_next(req->src == req->dst ? pctx->src : pctx->dst);
 
 	if (!err) {
-		err = crypto_ccm_auth(req, req->dst, cryptlen);
+		err = crypto_ccm_auth(req, dst, cryptlen);
 		if (!err && crypto_memneq(pctx->auth_tag, pctx->odata, authsize))
 			err = -EBADMSG;
 	}
@@ -384,31 +416,18 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	u8 *iv = req->iv;
 	int err;
 
-	if (cryptlen < authsize)
-		return -EINVAL;
 	cryptlen -= authsize;
 
-	err = crypto_ccm_check_iv(iv);
+	err = crypto_ccm_init_crypt(req, authtag);
 	if (err)
 		return err;
 
-	pctx->flags = aead_request_flags(req);
-
-	scatterwalk_map_and_copy(authtag, req->src, cryptlen, authsize, 0);
-
-	memset(iv + 15 - iv[0], 0, iv[0] + 1);
-
-	sg_init_table(pctx->src, 2);
-	sg_set_buf(pctx->src, authtag, 16);
-	scatterwalk_sg_chain(pctx->src, 2, req->src);
+	scatterwalk_map_and_copy(authtag, sg_next(pctx->src), cryptlen,
+				 authsize, 0);
 
 	dst = pctx->src;
-	if (req->src != req->dst) {
-		sg_init_table(pctx->dst, 2);
-		sg_set_buf(pctx->dst, authtag, 16);
-		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
+	if (req->src != req->dst)
 		dst = pctx->dst;
-	}
 
 	ablkcipher_request_set_tfm(abreq, ctx->ctr);
 	ablkcipher_request_set_callback(abreq, pctx->flags,
@@ -418,7 +437,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	err = crypto_ccm_auth(req, req->dst, cryptlen);
+	err = crypto_ccm_auth(req, sg_next(dst), cryptlen);
 	if (err)
 		return err;
 
@@ -429,11 +448,11 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	return err;
 }
 
-static int crypto_ccm_init_tfm(struct crypto_tfm *tfm)
+static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct ccm_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_ccm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct ccm_instance_ctx *ictx = aead_instance_ctx(inst);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_cipher *cipher;
 	struct crypto_ablkcipher *ctr;
 	unsigned long align;
@@ -451,9 +470,10 @@ static int crypto_ccm_init_tfm(struct crypto_tfm *tfm)
 	ctx->cipher = cipher;
 	ctx->ctr = ctr;
 
-	align = crypto_tfm_alg_alignmask(tfm);
+	align = crypto_aead_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+	crypto_aead_set_reqsize(
+		tfm,
 		align + sizeof(struct crypto_ccm_req_priv_ctx) +
 		crypto_ablkcipher_reqsize(ctr));
 
@@ -464,21 +484,31 @@ err_free_cipher:
 	return err;
 }
 
-static void crypto_ccm_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_ccm_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_ccm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_cipher(ctx->cipher);
 	crypto_free_ablkcipher(ctx->ctr);
 }
 
-static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
-						       const char *full_name,
-						       const char *ctr_name,
-						       const char *cipher_name)
+static void crypto_ccm_free(struct aead_instance *inst)
+{
+	struct ccm_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_spawn(&ctx->cipher);
+	crypto_drop_skcipher(&ctx->ctr);
+	kfree(inst);
+}
+
+static int crypto_ccm_create_common(struct crypto_template *tmpl,
+				    struct rtattr **tb,
+				    const char *full_name,
+				    const char *ctr_name,
+				    const char *cipher_name)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_alg *ctr;
 	struct crypto_alg *cipher;
 	struct ccm_instance_ctx *ictx;
@@ -486,15 +516,16 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
+		return -EINVAL;
 
 	cipher = crypto_alg_mod_lookup(cipher_name,  CRYPTO_ALG_TYPE_CIPHER,
 				       CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(cipher))
-		return ERR_CAST(cipher);
+		return PTR_ERR(cipher);
 
 	err = -EINVAL;
 	if (cipher->cra_blocksize != 16)
@@ -505,14 +536,15 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 	if (!inst)
 		goto out_put_cipher;
 
-	ictx = crypto_instance_ctx(inst);
+	ictx = aead_instance_ctx(inst);
 
-	err = crypto_init_spawn(&ictx->cipher, cipher, inst,
+	err = crypto_init_spawn(&ictx->cipher, cipher,
+				aead_crypto_instance(inst),
 				CRYPTO_ALG_TYPE_MASK);
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ictx->ctr, inst);
+	crypto_set_skcipher_spawn(&ictx->ctr, aead_crypto_instance(inst));
 	err = crypto_grab_skcipher(&ictx->ctr, ctr_name, 0,
 				   crypto_requires_sync(algt->type,
 							algt->mask));
@@ -531,33 +563,40 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 		goto err_drop_ctr;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm_base(%s,%s)", ctr->cra_driver_name,
 		     cipher->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_ctr;
 
-	memcpy(inst->alg.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= ctr->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = cipher->cra_priority + ctr->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = cipher->cra_alignmask | ctr->cra_alignmask |
-				  (__alignof__(u32) - 1);
-	inst->alg.cra_type = &crypto_aead_type;
-	inst->alg.cra_aead.ivsize = 16;
-	inst->alg.cra_aead.maxauthsize = 16;
-	inst->alg.cra_ctxsize = sizeof(struct crypto_ccm_ctx);
-	inst->alg.cra_init = crypto_ccm_init_tfm;
-	inst->alg.cra_exit = crypto_ccm_exit_tfm;
-	inst->alg.cra_aead.setkey = crypto_ccm_setkey;
-	inst->alg.cra_aead.setauthsize = crypto_ccm_setauthsize;
-	inst->alg.cra_aead.encrypt = crypto_ccm_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_ccm_decrypt;
+	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
+
+	inst->alg.base.cra_flags = ctr->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
+	inst->alg.base.cra_priority = (cipher->cra_priority +
+				       ctr->cra_priority) / 2;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = cipher->cra_alignmask |
+				       ctr->cra_alignmask |
+				       (__alignof__(u32) - 1);
+	inst->alg.ivsize = 16;
+	inst->alg.maxauthsize = 16;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_ccm_ctx);
+	inst->alg.init = crypto_ccm_init_tfm;
+	inst->alg.exit = crypto_ccm_exit_tfm;
+	inst->alg.setkey = crypto_ccm_setkey;
+	inst->alg.setauthsize = crypto_ccm_setauthsize;
+	inst->alg.encrypt = crypto_ccm_encrypt;
+	inst->alg.decrypt = crypto_ccm_decrypt;
+
+	inst->free = crypto_ccm_free;
+
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_ctr;
 
-out:
+out_put_cipher:
 	crypto_mod_put(cipher);
-	return inst;
+	return err;
 
 err_drop_ctr:
 	crypto_drop_skcipher(&ictx->ctr);
@@ -565,12 +604,10 @@ err_drop_cipher:
 	crypto_drop_spawn(&ictx->cipher);
 err_free_inst:
 	kfree(inst);
-out_put_cipher:
-	inst = ERR_PTR(err);
-	goto out;
+	goto out_put_cipher;
 }
 
-static struct crypto_instance *crypto_ccm_alloc(struct rtattr **tb)
+static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
@@ -578,36 +615,28 @@ static struct crypto_instance *crypto_ccm_alloc(struct rtattr **tb)
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
-		return ERR_CAST(cipher_name);
+		return PTR_ERR(cipher_name);
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm(%s)", cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
-	return crypto_ccm_alloc_common(tb, full_name, ctr_name, cipher_name);
-}
-
-static void crypto_ccm_free(struct crypto_instance *inst)
-{
-	struct ccm_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_spawn(&ctx->cipher);
-	crypto_drop_skcipher(&ctx->ctr);
-	kfree(inst);
+	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
+					cipher_name);
 }
 
 static struct crypto_template crypto_ccm_tmpl = {
 	.name = "ccm",
-	.alloc = crypto_ccm_alloc,
-	.free = crypto_ccm_free,
+	.create = crypto_ccm_create,
 	.module = THIS_MODULE,
 };
 
-static struct crypto_instance *crypto_ccm_base_alloc(struct rtattr **tb)
+static int crypto_ccm_base_create(struct crypto_template *tmpl,
+				  struct rtattr **tb)
 {
 	const char *ctr_name;
 	const char *cipher_name;
@@ -615,23 +644,23 @@ static struct crypto_instance *crypto_ccm_base_alloc(struct rtattr **tb)
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
-		return ERR_CAST(ctr_name);
+		return PTR_ERR(ctr_name);
 
 	cipher_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(cipher_name))
-		return ERR_CAST(cipher_name);
+		return PTR_ERR(cipher_name);
 
 	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm_base(%s,%s)",
 		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
+		return -ENAMETOOLONG;
 
-	return crypto_ccm_alloc_common(tb, full_name, ctr_name, cipher_name);
+	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
+					cipher_name);
 }
 
 static struct crypto_template crypto_ccm_base_tmpl = {
 	.name = "ccm_base",
-	.alloc = crypto_ccm_base_alloc,
-	.free = crypto_ccm_free,
+	.create = crypto_ccm_base_create,
 	.module = THIS_MODULE,
 };
 
@@ -677,10 +706,12 @@ static int crypto_rfc4309_setauthsize(struct crypto_aead *parent,
 
 static struct aead_request *crypto_rfc4309_crypt(struct aead_request *req)
 {
-	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_rfc4309_req_ctx *rctx = aead_request_ctx(req);
+	struct aead_request *subreq = &rctx->subreq;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_rfc4309_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_aead *child = ctx->child;
+	struct scatterlist *sg;
 	u8 *iv = PTR_ALIGN((u8 *)(subreq + 1) + crypto_aead_reqsize(child),
 			   crypto_aead_alignmask(child) + 1);
 
@@ -690,17 +721,38 @@ static struct aead_request *crypto_rfc4309_crypt(struct aead_request *req)
 	memcpy(iv + 1, ctx->nonce, 3);
 	memcpy(iv + 4, req->iv, 8);
 
+	scatterwalk_map_and_copy(iv + 16, req->src, 0, req->assoclen - 8, 0);
+
+	sg_init_table(rctx->src, 3);
+	sg_set_buf(rctx->src, iv + 16, req->assoclen - 8);
+	sg = scatterwalk_ffwd(rctx->src + 1, req->src, req->assoclen);
+	if (sg != rctx->src + 1)
+		sg_chain(rctx->src, 2, sg);
+
+	if (req->src != req->dst) {
+		sg_init_table(rctx->dst, 3);
+		sg_set_buf(rctx->dst, iv + 16, req->assoclen - 8);
+		sg = scatterwalk_ffwd(rctx->dst + 1, req->dst, req->assoclen);
+		if (sg != rctx->dst + 1)
+			sg_chain(rctx->dst, 2, sg);
+	}
+
 	aead_request_set_tfm(subreq, child);
 	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
 				  req->base.data);
-	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, iv);
-	aead_request_set_assoc(subreq, req->assoc, req->assoclen);
+	aead_request_set_crypt(subreq, rctx->src,
+			       req->src == req->dst ? rctx->src : rctx->dst,
+			       req->cryptlen, iv);
+	aead_request_set_ad(subreq, req->assoclen - 8);
 
 	return subreq;
 }
 
 static int crypto_rfc4309_encrypt(struct aead_request *req)
 {
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
 	req = crypto_rfc4309_crypt(req);
 
 	return crypto_aead_encrypt(req);
@@ -708,16 +760,19 @@ static int crypto_rfc4309_encrypt(struct aead_request *req)
 
 static int crypto_rfc4309_decrypt(struct aead_request *req)
 {
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
 	req = crypto_rfc4309_crypt(req);
 
 	return crypto_aead_decrypt(req);
 }
 
-static int crypto_rfc4309_init_tfm(struct crypto_tfm *tfm)
+static int crypto_rfc4309_init_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_aead_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_rfc4309_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aead_instance *inst = aead_alg_instance(tfm);
+	struct crypto_aead_spawn *spawn = aead_instance_ctx(inst);
+	struct crypto_rfc4309_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *aead;
 	unsigned long align;
 
@@ -729,115 +784,120 @@ static int crypto_rfc4309_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-		sizeof(struct aead_request) +
+	crypto_aead_set_reqsize(
+		tfm,
+		sizeof(struct crypto_rfc4309_req_ctx) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
-		align + 16);
+		align + 32);
 
 	return 0;
 }
 
-static void crypto_rfc4309_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_rfc4309_exit_tfm(struct crypto_aead *tfm)
 {
-	struct crypto_rfc4309_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_rfc4309_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
 }
 
-static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
+static void crypto_rfc4309_free(struct aead_instance *inst)
+{
+	crypto_drop_aead(aead_instance_ctx(inst));
+	kfree(inst);
+}
+
+static int crypto_rfc4309_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
-	struct crypto_alg *alg;
+	struct aead_alg *alg;
 	const char *ccm_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
+		return -EINVAL;
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ccm_name))
-		return ERR_CAST(ccm_name);
+		return PTR_ERR(ccm_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	spawn = crypto_instance_ctx(inst);
-	crypto_set_aead_spawn(spawn, inst);
+	spawn = aead_instance_ctx(inst);
+	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
 	err = crypto_grab_aead(spawn, ccm_name, 0,
 			       crypto_requires_sync(algt->type, algt->mask));
 	if (err)
 		goto out_free_inst;
 
-	alg = crypto_aead_spawn_alg(spawn);
+	alg = crypto_spawn_aead_alg(spawn);
 
 	err = -EINVAL;
 
 	/* We only support 16-byte blocks. */
-	if (alg->cra_aead.ivsize != 16)
+	if (crypto_aead_alg_ivsize(alg) != 16)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
-	if (alg->cra_blocksize != 1)
+	if (alg->base.cra_blocksize != 1)
 		goto out_drop_alg;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4309(%s)", alg->cra_name) >= CRYPTO_MAX_ALG_NAME ||
-	    snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc4309(%s)", alg->cra_driver_name) >=
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4309(%s)", alg->base.cra_name) >=
+	    CRYPTO_MAX_ALG_NAME ||
+	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc4309(%s)", alg->base.cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_nivaead_type;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.cra_aead.ivsize = 8;
-	inst->alg.cra_aead.maxauthsize = 16;
+	inst->alg.ivsize = 8;
+	inst->alg.maxauthsize = 16;
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-	inst->alg.cra_init = crypto_rfc4309_init_tfm;
-	inst->alg.cra_exit = crypto_rfc4309_exit_tfm;
+	inst->alg.init = crypto_rfc4309_init_tfm;
+	inst->alg.exit = crypto_rfc4309_exit_tfm;
 
-	inst->alg.cra_aead.setkey = crypto_rfc4309_setkey;
-	inst->alg.cra_aead.setauthsize = crypto_rfc4309_setauthsize;
-	inst->alg.cra_aead.encrypt = crypto_rfc4309_encrypt;
-	inst->alg.cra_aead.decrypt = crypto_rfc4309_decrypt;
+	inst->alg.setkey = crypto_rfc4309_setkey;
+	inst->alg.setauthsize = crypto_rfc4309_setauthsize;
+	inst->alg.encrypt = crypto_rfc4309_encrypt;
+	inst->alg.decrypt = crypto_rfc4309_decrypt;
 
-	inst->alg.cra_aead.geniv = "seqiv";
+	inst->free = crypto_rfc4309_free;
+
+	err = aead_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_alg;
 
 out:
-	return inst;
+	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
 out_free_inst:
 	kfree(inst);
-	inst = ERR_PTR(err);
 	goto out;
 }
 
-static void crypto_rfc4309_free(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
-}
-
 static struct crypto_template crypto_rfc4309_tmpl = {
 	.name = "rfc4309",
-	.alloc = crypto_rfc4309_alloc,
-	.free = crypto_rfc4309_free,
+	.create = crypto_rfc4309_create,
 	.module = THIS_MODULE,
 };
 
