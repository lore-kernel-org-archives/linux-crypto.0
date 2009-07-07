From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 3/3] crypto: hmac - convert to ahash
Date: Tue, 7 Jul 2009 09:26:58 +0200
Message-ID: <20090707072658.GF20288@secunet.com>
References: <20090707072343.GC20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36496 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZGGHYT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 03:24:19 -0400
Content-Disposition: inline
In-Reply-To: <20090707072343.GC20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This converts hmac to the new ahash frontend.
Also the hashing of the ipaded and opaded key is done now with the
setkey function, this saves some bytes of hashing on each request.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/hmac.c |  471 +++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 340 insertions(+), 131 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 0ad39c3..c3b2c76 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -18,6 +18,7 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
+#include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -27,192 +28,400 @@
 #include <linux/string.h>
 
 struct hmac_ctx {
-	struct crypto_hash *child;
+	struct crypto_ahash *child;
+	struct ahash_request *ipad_req;
+	struct ahash_request *opad_req;
+	unsigned int reqoff;
 };
 
-static inline void *align_ptr(void *p, unsigned int align)
+struct hmac_request_ctx {
+	struct scatterlist sg;
+	char tail[];
+};
+
+struct hmac_setkey_result {
+	int err;
+	struct completion completion;
+};
+
+static inline struct hmac_ctx *hmac_ctx(struct crypto_ahash *tfm)
 {
-	return (void *)ALIGN((unsigned long)p, align);
+	return PTR_ALIGN((void *)crypto_ahash_ctx_aligned(tfm) +
+			 	 crypto_ahash_blocksize(tfm) * 2 +
+			 	 crypto_ahash_digestsize(tfm),
+			 	 crypto_ahash_alignmask(tfm) + 1);
 }
 
-static inline struct hmac_ctx *hmac_ctx(struct crypto_hash *tfm)
+static int hmac_hash_pad(struct ahash_request *req,
+			 struct hmac_setkey_result *result, u8 *out)
 {
-	return align_ptr(crypto_hash_ctx_aligned(tfm) +
-			 crypto_hash_blocksize(tfm) * 2 +
-			 crypto_hash_digestsize(tfm), sizeof(void *));
+	int err;
+
+	err = crypto_ahash_init(req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		err = wait_for_completion_interruptible(&result->completion);
+		if (!err)
+			err = result->err;
+	}
+
+	if (err)
+		goto out;
+
+	err = crypto_ahash_update(req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		err = wait_for_completion_interruptible(&result->completion);
+		if (!err)
+			err = result->err;
+	}
+
+	if (err)
+		goto out;
+
+	crypto_ahash_export(req, out);
+
+out:
+	return err;
 }
 
-static int hmac_setkey(struct crypto_hash *parent,
+static void hmac_setkey_done(struct crypto_async_request *req, int err)
+{
+	struct hmac_setkey_result *result = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	result->err = err;
+	complete(&result->completion);
+}
+
+static int hmac_setkey(struct crypto_ahash *parent,
 		       const u8 *inkey, unsigned int keylen)
 {
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *ipad = crypto_hash_ctx_aligned(parent);
-	char *opad = ipad + bs;
-	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds, sizeof(void *));
-	struct crypto_hash *tfm = ctx->child;
-	unsigned int i;
+	int err, i;
+	int bs = crypto_ahash_blocksize(parent);
+	int ds = crypto_ahash_digestsize(parent);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct {
+		u8 ipad[bs];
+		u8 opad[bs];
+		u8 digest[ds];
+		struct hmac_setkey_result result;
+		struct scatterlist sg;
+		struct ahash_request req;
 
-	if (keylen > bs) {
-		struct hash_desc desc;
-		struct scatterlist tmp;
-		int tmplen;
-		int err;
+	} *data;
 
-		desc.tfm = tfm;
-		desc.flags = crypto_hash_get_flags(parent);
-		desc.flags &= CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = -ENOMEM;
+	data = kzalloc(sizeof(*data) + crypto_ahash_reqsize(parent) +
+		       bs * 2 + ds, GFP_KERNEL);
 
-		err = crypto_hash_init(&desc);
-		if (err)
-			return err;
+	if (!data)
+		goto out;
 
-		tmplen = bs * 2 + ds;
-		sg_init_one(&tmp, ipad, tmplen);
+	init_completion(&data->result.completion);
 
-		for (; keylen > tmplen; inkey += tmplen, keylen -= tmplen) {
-			memcpy(ipad, inkey, tmplen);
-			err = crypto_hash_update(&desc, &tmp, tmplen);
-			if (err)
-				return err;
-		}
+	ahash_request_set_tfm(&data->req, ctx->child);
+	ahash_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   hmac_setkey_done, &data->result);
 
-		if (keylen) {
-			memcpy(ipad, inkey, keylen);
-			err = crypto_hash_update(&desc, &tmp, keylen);
-			if (err)
-				return err;
+	if (keylen > bs) {
+		sg_init_one(&data->sg, inkey, keylen);
+
+		ahash_request_set_crypt(&data->req, &data->sg,
+					data->digest, keylen);
+
+		err = crypto_ahash_digest(&data->req);
+		if (err == -EINPROGRESS || err == -EBUSY) {
+			err = wait_for_completion_interruptible(
+				&data->result.completion);
+			if (!err)
+				err = data->result.err;
 		}
 
-		err = crypto_hash_final(&desc, digest);
 		if (err)
-			return err;
+			goto out_free;
 
-		inkey = digest;
+		inkey = data->digest;
 		keylen = ds;
 	}
 
-	memcpy(ipad, inkey, keylen);
-	memset(ipad + keylen, 0, bs - keylen);
-	memcpy(opad, ipad, bs);
+	memcpy(data->ipad, inkey, keylen);
+	memset(data->ipad + keylen, 0, bs - keylen);
+	memcpy(data->opad, data->ipad, bs);
 
 	for (i = 0; i < bs; i++) {
-		ipad[i] ^= 0x36;
-		opad[i] ^= 0x5c;
+		data->ipad[i] ^= 0x36;
+		data->opad[i] ^= 0x5c;
 	}
 
-	return 0;
+	err = -ENOMEM;
+	ctx->ipad_req = kmalloc(crypto_ahash_reqsize(ctx->child), GFP_KERNEL);
+	if (!ctx->ipad_req)
+		goto out_free;
+	ctx->opad_req = kmalloc(crypto_ahash_reqsize(ctx->child), GFP_KERNEL);
+	if (!ctx->opad_req)
+		goto out_free;
+
+	sg_init_one(&data->sg, data->ipad, bs);
+
+	ahash_request_set_crypt(&data->req, &data->sg, data->digest, bs);
+
+	err = hmac_hash_pad(&data->req, &data->result, (u8 *)ctx->ipad_req);
+	if (err)
+		goto out_free;
+
+	sg_init_one(&data->sg, data->opad, bs);
+
+	ahash_request_set_crypt(&data->req, &data->sg, data->digest, bs);
+
+	err = hmac_hash_pad(&data->req, &data->result, (u8 *)ctx->opad_req);
+
+out_free:
+	kfree(data);
+out:
+	return err;
 }
 
-static int hmac_init(struct hash_desc *pdesc)
+static int hmac_init(struct ahash_request *req)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *ipad = crypto_hash_ctx_aligned(parent);
-	struct hmac_ctx *ctx = align_ptr(ipad + bs * 2 + ds, sizeof(void *));
-	struct hash_desc desc;
-	struct scatterlist tmp;
-	int err;
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	sg_init_one(&tmp, ipad, bs);
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
 
-	err = crypto_hash_init(&desc);
+	if (!ctx->ipad_req)
+		return -EINVAL;
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, req->src, digest, req->nbytes);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           req->base.complete, req->base.data);
+
+	return crypto_ahash_import(creq, (u8 *)ctx->ipad_req);
+}
+
+static int hmac_update(struct ahash_request *req)
+{
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
+
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, req->src, digest, req->nbytes);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           req->base.complete, req->base.data);
+
+	return crypto_ahash_update(creq);
+}
+
+static void hmac_final_done(struct crypto_async_request *base, int err)
+{
+	struct ahash_request *req = base->data;
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
+	int ds = crypto_ahash_digestsize(parent);
+
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
+
+	if (err)
+		goto out;
+
+	err =  -EINVAL;
+	if (!ctx->opad_req)
+		goto out;
+
+	sg_init_one(&reqctx->sg, digest, ds);
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, &reqctx->sg, req->result, ds);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           req->base.complete, req->base.data);
+
+	err = crypto_ahash_import(creq, (u8 *)ctx->opad_req);
 	if (unlikely(err))
-		return err;
+		goto out;
 
-	return crypto_hash_update(&desc, &tmp, bs);
+	err = crypto_ahash_finup(creq);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	ahash_request_complete(req, err);
 }
 
-static int hmac_update(struct hash_desc *pdesc,
-		       struct scatterlist *sg, unsigned int nbytes)
+static int hmac_final(struct ahash_request *req)
 {
-	struct hmac_ctx *ctx = hmac_ctx(pdesc->tfm);
-	struct hash_desc desc;
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
+	int ds = crypto_ahash_digestsize(parent);
+	int err = -EINVAL;
+
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
+
+	if (!ctx->opad_req)
+		goto out;
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, req->src, digest, req->nbytes);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           hmac_final_done, req);
+
+	err = crypto_ahash_final(creq);
+	if (err)
+		goto out;
+
+	sg_init_one(&reqctx->sg, digest, ds);
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_crypt(creq, &reqctx->sg, req->result, ds);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           req->base.complete, req->base.data);
+
+	err = crypto_ahash_import(creq, (u8 *)ctx->opad_req);
+	if (unlikely(err))
+		goto out;
 
-	return crypto_hash_update(&desc, sg, nbytes);
+	err = crypto_ahash_finup(creq);
+
+out:
+	return err;
 }
 
-static int hmac_final(struct hash_desc *pdesc, u8 *out)
+static int hmac_finup(struct ahash_request *req)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *opad = crypto_hash_ctx_aligned(parent) + bs;
-	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds, sizeof(void *));
-	struct hash_desc desc;
-	struct scatterlist tmp;
-	int err;
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
+	int ds = crypto_ahash_digestsize(parent);
+	int err = -EINVAL;
+
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
+
+	if (!ctx->opad_req)
+		goto out;
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, req->src, digest, req->nbytes);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           hmac_final_done, req);
+
+	err = crypto_ahash_finup(creq);
+	if (err)
+		goto out;
+
+	sg_init_one(&reqctx->sg, digest, ds);
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	sg_init_one(&tmp, opad, bs + ds);
+	ahash_request_set_crypt(creq, &reqctx->sg, req->result, ds);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           req->base.complete, req->base.data);
 
-	err = crypto_hash_final(&desc, digest);
+	err = crypto_ahash_import(creq, (u8 *)ctx->opad_req);
 	if (unlikely(err))
-		return err;
+		goto out;
 
-	return crypto_hash_digest(&desc, &tmp, bs + ds, out);
+	err = crypto_ahash_finup(creq);
+
+out:
+	return err;
 }
 
-static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
-		       unsigned int nbytes, u8 *out)
+static int hmac_digest(struct ahash_request *req)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *ipad = crypto_hash_ctx_aligned(parent);
-	char *opad = ipad + bs;
-	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds, sizeof(void *));
-	struct hash_desc desc;
-	struct scatterlist sg1[2];
-	struct scatterlist sg2[1];
-	int err;
+	struct crypto_ahash *parent = crypto_ahash_reqtfm(req);
+	struct hmac_ctx *ctx = crypto_ahash_ctx(parent);
+	struct hmac_request_ctx *reqctx = ahash_request_ctx(req);
+	struct ahash_request *creq = (void *)(reqctx->tail + ctx->reqoff);
+	int ds = crypto_ahash_digestsize(parent);
+	int err = -EINVAL;
+
+	u8 *digest = PTR_ALIGN((u8 *)reqctx->tail,
+			       crypto_ahash_alignmask(parent) + 1);
+
+	if (!ctx->ipad_req || !ctx->opad_req)
+		goto out;
+
+	ahash_request_set_tfm(creq, ctx->child);
+	ahash_request_set_crypt(creq, req->src, digest, req->nbytes);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           hmac_final_done, req);
+
+	err = crypto_ahash_import(creq, (u8 *)ctx->ipad_req);
+	if (unlikely(err))
+		goto out;
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_ahash_finup(creq);
+	if (err)
+		goto out;
 
-	sg_init_table(sg1, 2);
-	sg_set_buf(sg1, ipad, bs);
-	scatterwalk_sg_chain(sg1, 2, sg);
+	sg_init_one(&reqctx->sg, digest, ds);
 
-	sg_init_table(sg2, 1);
-	sg_set_buf(sg2, opad, bs + ds);
+	ahash_request_set_crypt(creq, &reqctx->sg, req->result, ds);
+	ahash_request_set_callback(creq, ahash_request_flags(req) &
+					 CRYPTO_TFM_REQ_MAY_SLEEP,
+			           hmac_final_done, req);
 
-	err = crypto_hash_digest(&desc, sg1, nbytes + bs, digest);
+	err = crypto_ahash_import(creq, (u8 *)ctx->opad_req);
 	if (unlikely(err))
-		return err;
+		goto out;
+
+	err = crypto_ahash_finup(creq);
 
-	return crypto_hash_digest(&desc, sg2, bs + ds, out);
+out:
+	return err;
 }
 
 static int hmac_init_tfm(struct crypto_tfm *tfm)
 {
-	struct crypto_hash *hash;
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_ahash *ahash;
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
 	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct hmac_ctx *ctx = hmac_ctx(__crypto_hash_cast(tfm));
+	struct hmac_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	hash = crypto_spawn_hash(spawn);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
+	ahash = crypto_spawn_ahash(spawn);
+	if (IS_ERR(ahash))
+		return PTR_ERR(ahash);
+
+	ctx->child = ahash;
+
+	ctx->reqoff = ALIGN(crypto_ahash_digestsize(ahash),
+			    crypto_ahash_alignmask(ahash) + 1);
+
+	tfm->crt_ahash.reqsize = sizeof(struct ahash_request) +
+				 sizeof(struct hmac_request_ctx) +
+				 ctx->reqoff + crypto_ahash_reqsize(ahash);
 
-	ctx->child = hash;
 	return 0;
 }
 
 static void hmac_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct hmac_ctx *ctx = hmac_ctx(__crypto_hash_cast(tfm));
-	crypto_free_hash(ctx->child);
+	struct hmac_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kfree(ctx->ipad_req);
+	kfree(ctx->opad_req);
+	crypto_free_ahash(ctx->child);
 }
 
 static void hmac_free(struct crypto_instance *inst)
@@ -233,7 +442,7 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 		return ERR_PTR(err);
 
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_HASH_MASK);
+				  CRYPTO_ALG_TYPE_AHASH_MASK);
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
@@ -250,26 +459,26 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_HASH;
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AHASH;
+	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
 	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_hash_type;
+	inst->alg.cra_type = &crypto_ahash_type;
 
-	inst->alg.cra_hash.digestsize = ds;
+	inst->alg.cra_ahash.digestsize = ds;
 
-	inst->alg.cra_ctxsize = sizeof(struct hmac_ctx) +
-				ALIGN(inst->alg.cra_blocksize * 2 + ds,
-				      sizeof(void *));
+	inst->alg.cra_ctxsize = sizeof(struct hmac_ctx);
 
 	inst->alg.cra_init = hmac_init_tfm;
 	inst->alg.cra_exit = hmac_exit_tfm;
 
-	inst->alg.cra_hash.init = hmac_init;
-	inst->alg.cra_hash.update = hmac_update;
-	inst->alg.cra_hash.final = hmac_final;
-	inst->alg.cra_hash.digest = hmac_digest;
-	inst->alg.cra_hash.setkey = hmac_setkey;
+	inst->alg.cra_ahash.init = hmac_init;
+	inst->alg.cra_ahash.update = hmac_update;
+	inst->alg.cra_ahash.final = hmac_final;
+	inst->alg.cra_ahash.finup = hmac_finup;
+	inst->alg.cra_ahash.digest = hmac_digest;
+	inst->alg.cra_ahash.setkey = hmac_setkey;
 
 out_put_alg:
 	crypto_mod_put(alg);
-- 
1.5.4.2

