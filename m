From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/11] crypto: echainiv - Use common IV generation code
Date: Wed, 27 May 2015 14:37:33 +0800
Message-ID: <E1YxUy5-0006mJ-AA@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60021 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbE0Ghh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:37 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy6-0005cE-2d
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:34 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes use of the new common IV generation code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |  230 ++++--------------------------------------------------
 1 file changed, 18 insertions(+), 212 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 02d0543..0f79fc6 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -18,7 +18,7 @@
  *
  */
 
-#include <crypto/internal/aead.h>
+#include <crypto/internal/geniv.h>
 #include <crypto/null.h>
 #include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
@@ -33,39 +33,15 @@
 
 #define MAX_IV_SIZE 16
 
-struct echainiv_request_ctx {
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
-	struct scatterlist ivbuf[2];
-	struct scatterlist *ivsg;
-	struct aead_givcrypt_request subreq;
-};
-
 struct echainiv_ctx {
-	struct crypto_aead *child;
-	spinlock_t lock;
+	/* aead_geniv_ctx must be first the element */
+	struct aead_geniv_ctx geniv;
 	struct crypto_blkcipher *null;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
 static DEFINE_PER_CPU(u32 [MAX_IV_SIZE / sizeof(u32)], echainiv_iv);
 
-static int echainiv_setkey(struct crypto_aead *tfm,
-			      const u8 *key, unsigned int keylen)
-{
-	struct echainiv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setkey(ctx->child, key, keylen);
-}
-
-static int echainiv_setauthsize(struct crypto_aead *tfm,
-				  unsigned int authsize)
-{
-	struct echainiv_ctx *ctx = crypto_aead_ctx(tfm);
-
-	return crypto_aead_setauthsize(ctx->child, authsize);
-}
-
 /* We don't care if we get preempted and read/write IVs from the next CPU. */
 static void echainiv_read_iv(u8 *dst, unsigned size)
 {
@@ -90,36 +66,6 @@ static void echainiv_write_iv(const u8 *src, unsigned size)
 	}
 }
 
-static void echainiv_encrypt_compat_complete2(struct aead_request *req,
-						 int err)
-{
-	struct echainiv_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_givcrypt_request *subreq = &rctx->subreq;
-	struct crypto_aead *geniv;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (err)
-		goto out;
-
-	geniv = crypto_aead_reqtfm(req);
-	scatterwalk_map_and_copy(subreq->giv, rctx->ivsg, 0,
-				 crypto_aead_ivsize(geniv), 1);
-
-out:
-	kzfree(subreq->giv);
-}
-
-static void echainiv_encrypt_compat_complete(
-	struct crypto_async_request *base, int err)
-{
-	struct aead_request *req = base->data;
-
-	echainiv_encrypt_compat_complete2(req, err);
-	aead_request_complete(req, err);
-}
-
 static void echainiv_encrypt_complete2(struct aead_request *req, int err)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
@@ -154,59 +100,6 @@ static void echainiv_encrypt_complete(struct crypto_async_request *base,
 	aead_request_complete(req, err);
 }
 
-static int echainiv_encrypt_compat(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct echainiv_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_givcrypt_request *subreq = &rctx->subreq;
-	unsigned int ivsize = crypto_aead_ivsize(geniv);
-	crypto_completion_t compl;
-	void *data;
-	u8 *info;
-	__be64 seq;
-	int err;
-
-	if (req->cryptlen < ivsize)
-		return -EINVAL;
-
-	compl = req->base.complete;
-	data = req->base.data;
-
-	rctx->ivsg = scatterwalk_ffwd(rctx->ivbuf, req->dst, req->assoclen);
-	info = PageHighMem(sg_page(rctx->ivsg)) ? NULL : sg_virt(rctx->ivsg);
-
-	if (!info) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
-
-		compl = echainiv_encrypt_compat_complete;
-		data = req;
-	}
-
-	memcpy(&seq, req->iv + ivsize - sizeof(seq), sizeof(seq));
-
-	aead_givcrypt_set_tfm(subreq, ctx->child);
-	aead_givcrypt_set_callback(subreq, req->base.flags,
-				   req->base.complete, req->base.data);
-	aead_givcrypt_set_crypt(subreq,
-				scatterwalk_ffwd(rctx->src, req->src,
-						 req->assoclen + ivsize),
-				scatterwalk_ffwd(rctx->dst, rctx->ivsg,
-						 ivsize),
-				req->cryptlen - ivsize, req->iv);
-	aead_givcrypt_set_assoc(subreq, req->src, req->assoclen);
-	aead_givcrypt_set_giv(subreq, info, be64_to_cpu(seq));
-
-	err = crypto_aead_givencrypt(subreq);
-	if (unlikely(PageHighMem(sg_page(rctx->ivsg))))
-		echainiv_encrypt_compat_complete2(req, err);
-	return err;
-}
-
 static int echainiv_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -221,7 +114,7 @@ static int echainiv_encrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = echainiv_encrypt_complete;
 	data = req;
@@ -264,38 +157,6 @@ static int echainiv_encrypt(struct aead_request *req)
 	return err;
 }
 
-static int echainiv_decrypt_compat(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct echainiv_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_request *subreq = &rctx->subreq.areq;
-	crypto_completion_t compl;
-	void *data;
-	unsigned int ivsize = crypto_aead_ivsize(geniv);
-
-	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
-		return -EINVAL;
-
-	aead_request_set_tfm(subreq, ctx->child);
-
-	compl = req->base.complete;
-	data = req->base.data;
-
-	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq,
-			       scatterwalk_ffwd(rctx->src, req->src,
-						req->assoclen + ivsize),
-			       scatterwalk_ffwd(rctx->dst, req->dst,
-						req->assoclen + ivsize),
-			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_assoc(subreq, req->src, req->assoclen);
-
-	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
-
-	return crypto_aead_decrypt(subreq);
-}
-
 static int echainiv_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -308,7 +169,7 @@ static int echainiv_decrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
 		return -EINVAL;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	aead_request_set_tfm(subreq, ctx->geniv.child);
 
 	compl = req->base.complete;
 	data = req->base.data;
@@ -326,36 +187,13 @@ static int echainiv_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(subreq);
 }
 
-static int echainiv_encrypt_compat_first(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (geniv->encrypt != echainiv_encrypt_compat_first)
-		goto unlock;
-
-	geniv->encrypt = echainiv_encrypt_compat;
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(geniv));
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	if (err)
-		return err;
-
-	return echainiv_encrypt_compat(req);
-}
-
 static int echainiv_encrypt_first(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
 	int err = 0;
 
-	spin_lock_bh(&ctx->lock);
+	spin_lock_bh(&ctx->geniv.lock);
 	if (geniv->encrypt != echainiv_encrypt_first)
 		goto unlock;
 
@@ -364,7 +202,7 @@ static int echainiv_encrypt_first(struct aead_request *req)
 				   crypto_aead_ivsize(geniv));
 
 unlock:
-	spin_unlock_bh(&ctx->lock);
+	spin_unlock_bh(&ctx->geniv.lock);
 
 	if (err)
 		return err;
@@ -372,31 +210,13 @@ unlock:
 	return echainiv_encrypt(req);
 }
 
-static int echainiv_compat_init(struct crypto_tfm *tfm)
-{
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
-	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	crypto_aead_set_reqsize(geniv, sizeof(struct echainiv_request_ctx));
-
-	err = aead_geniv_init(tfm);
-
-	ctx->child = geniv->child;
-	geniv->child = geniv;
-
-	return err;
-}
-
 static int echainiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
 	int err;
 
-	spin_lock_init(&ctx->lock);
+	spin_lock_init(&ctx->geniv.lock);
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
@@ -409,7 +229,7 @@ static int echainiv_init(struct crypto_tfm *tfm)
 	if (err)
 		goto drop_null;
 
-	ctx->child = geniv->child;
+	ctx->geniv.child = geniv->child;
 	geniv->child = geniv;
 
 out:
@@ -420,18 +240,11 @@ drop_null:
 	goto out;
 }
 
-static void echainiv_compat_exit(struct crypto_tfm *tfm)
-{
-	struct echainiv_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_aead(ctx->child);
-}
-
 static void echainiv_exit(struct crypto_tfm *tfm)
 {
 	struct echainiv_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_aead(ctx->child);
+	crypto_free_aead(ctx->geniv.child);
 	crypto_put_default_null_skcipher();
 }
 
@@ -448,17 +261,17 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
+	spawn = aead_instance_ctx(inst);
+	alg = crypto_spawn_aead_alg(spawn);
+
+	if (alg->base.cra_aead.encrypt)
+		goto done;
+
 	err = -EINVAL;
-	if (inst->alg.ivsize < sizeof(u64) ||
-	    inst->alg.ivsize & (sizeof(u32) - 1) ||
+	if (inst->alg.ivsize & (sizeof(u32) - 1) ||
 	    inst->alg.ivsize > MAX_IV_SIZE)
 		goto free_inst;
 
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
-	inst->alg.setkey = echainiv_setkey;
-	inst->alg.setauthsize = echainiv_setauthsize;
 	inst->alg.encrypt = echainiv_encrypt_first;
 	inst->alg.decrypt = echainiv_decrypt;
 
@@ -469,14 +282,7 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_ctxsize = sizeof(struct echainiv_ctx);
 	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
 
-	if (alg->base.cra_aead.encrypt) {
-		inst->alg.encrypt = echainiv_encrypt_compat_first;
-		inst->alg.decrypt = echainiv_decrypt_compat;
-
-		inst->alg.base.cra_init = echainiv_compat_init;
-		inst->alg.base.cra_exit = echainiv_compat_exit;
-	}
-
+done:
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto free_inst;
