From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/35] crypto: hmac - Switch to shash
Date: Wed, 15 Jul 2009 15:16:06 +0800
Message-ID: <E1MQyik-0004zW-HA@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53628 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752616AbZGOHQJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyil-0004qh-3Q
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:07 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hmac - Switch to shash

This patch changes hmac to the new shash interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/hmac.c |  271 ++++++++++++++++++++++++----------------------------------
 1 file changed, 114 insertions(+), 157 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 0ad39c3..e373427 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -27,7 +27,7 @@
 #include <linux/string.h>
 
 struct hmac_ctx {
-	struct crypto_hash *child;
+	struct shash_desc *desc;
 };
 
 static inline void *align_ptr(void *p, unsigned int align)
@@ -35,57 +35,33 @@ static inline void *align_ptr(void *p, unsigned int align)
 	return (void *)ALIGN((unsigned long)p, align);
 }
 
-static inline struct hmac_ctx *hmac_ctx(struct crypto_hash *tfm)
+static inline struct hmac_ctx *hmac_ctx(struct crypto_shash *tfm)
 {
-	return align_ptr(crypto_hash_ctx_aligned(tfm) +
-			 crypto_hash_blocksize(tfm) * 2 +
-			 crypto_hash_digestsize(tfm), sizeof(void *));
+	return align_ptr(crypto_shash_ctx_aligned(tfm) +
+			 crypto_shash_blocksize(tfm) * 2 +
+			 crypto_shash_digestsize(tfm),
+			 crypto_tfm_ctx_alignment());
 }
 
-static int hmac_setkey(struct crypto_hash *parent,
+static int hmac_setkey(struct crypto_shash *parent,
 		       const u8 *inkey, unsigned int keylen)
 {
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *ipad = crypto_hash_ctx_aligned(parent);
+	int bs = crypto_shash_blocksize(parent);
+	int ds = crypto_shash_digestsize(parent);
+	char *ipad = crypto_shash_ctx_aligned(parent);
 	char *opad = ipad + bs;
 	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds, sizeof(void *));
-	struct crypto_hash *tfm = ctx->child;
+	struct hmac_ctx *ctx = align_ptr(digest + ds,
+					 crypto_tfm_ctx_alignment());
 	unsigned int i;
 
 	if (keylen > bs) {
-		struct hash_desc desc;
-		struct scatterlist tmp;
-		int tmplen;
 		int err;
 
-		desc.tfm = tfm;
-		desc.flags = crypto_hash_get_flags(parent);
-		desc.flags &= CRYPTO_TFM_REQ_MAY_SLEEP;
+		ctx->desc->flags = crypto_shash_get_flags(parent) &
+				   CRYPTO_TFM_REQ_MAY_SLEEP;
 
-		err = crypto_hash_init(&desc);
-		if (err)
-			return err;
-
-		tmplen = bs * 2 + ds;
-		sg_init_one(&tmp, ipad, tmplen);
-
-		for (; keylen > tmplen; inkey += tmplen, keylen -= tmplen) {
-			memcpy(ipad, inkey, tmplen);
-			err = crypto_hash_update(&desc, &tmp, tmplen);
-			if (err)
-				return err;
-		}
-
-		if (keylen) {
-			memcpy(ipad, inkey, keylen);
-			err = crypto_hash_update(&desc, &tmp, keylen);
-			if (err)
-				return err;
-		}
-
-		err = crypto_hash_final(&desc, digest);
+		err = crypto_shash_digest(ctx->desc, inkey, keylen, digest);
 		if (err)
 			return err;
 
@@ -105,181 +81,162 @@ static int hmac_setkey(struct crypto_hash *parent,
 	return 0;
 }
 
-static int hmac_init(struct hash_desc *pdesc)
+static int hmac_init(struct shash_desc *pdesc)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *ipad = crypto_hash_ctx_aligned(parent);
-	struct hmac_ctx *ctx = align_ptr(ipad + bs * 2 + ds, sizeof(void *));
-	struct hash_desc desc;
-	struct scatterlist tmp;
-	int err;
-
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	sg_init_one(&tmp, ipad, bs);
-
-	err = crypto_hash_init(&desc);
-	if (unlikely(err))
-		return err;
-
-	return crypto_hash_update(&desc, &tmp, bs);
+	struct crypto_shash *parent = pdesc->tfm;
+	int bs = crypto_shash_blocksize(parent);
+	int ds = crypto_shash_digestsize(parent);
+	char *ipad = crypto_shash_ctx_aligned(parent);
+	struct hmac_ctx *ctx = align_ptr(ipad + bs * 2 + ds,
+					 crypto_tfm_ctx_alignment());
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
+
+	desc->tfm = ctx->desc->tfm;
+	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_shash_init(desc) ?:
+	       crypto_shash_update(desc, ipad, bs);
 }
 
-static int hmac_update(struct hash_desc *pdesc,
-		       struct scatterlist *sg, unsigned int nbytes)
+static int hmac_update(struct shash_desc *pdesc,
+		       const u8 *data, unsigned int nbytes)
 {
-	struct hmac_ctx *ctx = hmac_ctx(pdesc->tfm);
-	struct hash_desc desc;
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_hash_update(&desc, sg, nbytes);
+	return crypto_shash_update(desc, data, nbytes);
 }
 
-static int hmac_final(struct hash_desc *pdesc, u8 *out)
+static int hmac_final(struct shash_desc *pdesc, u8 *out)
 {
-	struct crypto_hash *parent = pdesc->tfm;
-	int bs = crypto_hash_blocksize(parent);
-	int ds = crypto_hash_digestsize(parent);
-	char *opad = crypto_hash_ctx_aligned(parent) + bs;
+	struct crypto_shash *parent = pdesc->tfm;
+	int bs = crypto_shash_blocksize(parent);
+	int ds = crypto_shash_digestsize(parent);
+	char *opad = crypto_shash_ctx_aligned(parent) + bs;
 	char *digest = opad + bs;
-	struct hmac_ctx *ctx = align_ptr(digest + ds, sizeof(void *));
-	struct hash_desc desc;
-	struct scatterlist tmp;
-	int err;
-
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	sg_init_one(&tmp, opad, bs + ds);
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	err = crypto_hash_final(&desc, digest);
-	if (unlikely(err))
-		return err;
+	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_hash_digest(&desc, &tmp, bs + ds, out);
+	return crypto_shash_final(desc, digest) ?:
+	       crypto_shash_digest(desc, opad, bs + ds, out);
 }
 
-static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
-		       unsigned int nbytes, u8 *out)
+static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
+		      unsigned int nbytes, u8 *out)
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
 
-	desc.tfm = ctx->child;
-	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	sg_init_table(sg1, 2);
-	sg_set_buf(sg1, ipad, bs);
-	scatterwalk_sg_chain(sg1, 2, sg);
+	struct crypto_shash *parent = pdesc->tfm;
+	int bs = crypto_shash_blocksize(parent);
+	int ds = crypto_shash_digestsize(parent);
+	char *opad = crypto_shash_ctx_aligned(parent) + bs;
+	char *digest = opad + bs;
+	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
-	sg_init_table(sg2, 1);
-	sg_set_buf(sg2, opad, bs + ds);
+	desc->flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = crypto_hash_digest(&desc, sg1, nbytes + bs, digest);
-	if (unlikely(err))
-		return err;
-
-	return crypto_hash_digest(&desc, sg2, bs + ds, out);
+	return crypto_shash_finup(desc, data, nbytes, digest) ?:
+	       crypto_shash_digest(desc, opad, bs + ds, out);
 }
 
 static int hmac_init_tfm(struct crypto_tfm *tfm)
 {
-	struct crypto_hash *hash;
+	struct crypto_shash *parent = __crypto_shash_cast(tfm);
+	struct crypto_shash *hash;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
-	struct hmac_ctx *ctx = hmac_ctx(__crypto_hash_cast(tfm));
+	struct crypto_shash_spawn *spawn = crypto_instance_ctx(inst);
+	struct hmac_ctx *ctx = hmac_ctx(parent);
 
-	hash = crypto_spawn_hash(spawn);
+	hash = crypto_spawn_shash(spawn);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	ctx->child = hash;
+	parent->descsize = sizeof(struct shash_desc) +
+			   crypto_shash_descsize(hash);
+
+	ctx->desc = kmalloc(parent->descsize, GFP_KERNEL);
+	if (!ctx->desc) {
+		crypto_free_shash(hash);
+		return -ENOMEM;
+	}
+
+	ctx->desc->tfm = hash;
 	return 0;
 }
 
 static void hmac_exit_tfm(struct crypto_tfm *tfm)
 {
-	struct hmac_ctx *ctx = hmac_ctx(__crypto_hash_cast(tfm));
-	crypto_free_hash(ctx->child);
+	struct hmac_ctx *ctx = hmac_ctx(__crypto_shash_cast(tfm));
+	crypto_free_shash(ctx->desc->tfm);
+	kzfree(ctx->desc);
 }
 
-static void hmac_free(struct crypto_instance *inst)
+static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(inst);
-}
-
-static struct crypto_instance *hmac_alloc(struct rtattr **tb)
-{
-	struct crypto_instance *inst;
+	struct shash_instance *inst;
 	struct crypto_alg *alg;
+	struct shash_alg *salg;
 	int err;
 	int ds;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
 	if (err)
-		return ERR_PTR(err);
-
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_HASH_MASK);
-	if (IS_ERR(alg))
-		return ERR_CAST(alg);
-
-	inst = ERR_PTR(-EINVAL);
-	ds = alg->cra_type == &crypto_hash_type ?
-	     alg->cra_hash.digestsize :
-	     alg->cra_type ?
-	     __crypto_shash_alg(alg)->digestsize :
-	     alg->cra_digest.dia_digestsize;
+		return err;
+
+	salg = shash_attr_alg(tb[1], 0, 0);
+	if (IS_ERR(salg))
+		return PTR_ERR(salg);
+
+	err = -EINVAL;
+	ds = salg->digestsize;
+	alg = &salg->base;
 	if (ds > alg->cra_blocksize)
 		goto out_put_alg;
 
-	inst = crypto_alloc_instance("hmac", alg);
+	inst = shash_alloc_instance("hmac", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_HASH;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_hash_type;
+	err = crypto_init_shash_spawn(shash_instance_ctx(inst), salg,
+				      shash_crypto_instance(inst));
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.base.cra_priority = alg->cra_priority;
+	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
-	inst->alg.cra_hash.digestsize = ds;
+	inst->alg.digestsize = ds;
 
-	inst->alg.cra_ctxsize = sizeof(struct hmac_ctx) +
-				ALIGN(inst->alg.cra_blocksize * 2 + ds,
-				      sizeof(void *));
+	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) +
+				     ALIGN(alg->cra_blocksize * 2 + ds,
+					   crypto_tfm_ctx_alignment());
 
-	inst->alg.cra_init = hmac_init_tfm;
-	inst->alg.cra_exit = hmac_exit_tfm;
+	inst->alg.base.cra_init = hmac_init_tfm;
+	inst->alg.base.cra_exit = hmac_exit_tfm;
 
-	inst->alg.cra_hash.init = hmac_init;
-	inst->alg.cra_hash.update = hmac_update;
-	inst->alg.cra_hash.final = hmac_final;
-	inst->alg.cra_hash.digest = hmac_digest;
-	inst->alg.cra_hash.setkey = hmac_setkey;
+	inst->alg.init = hmac_init;
+	inst->alg.update = hmac_update;
+	inst->alg.final = hmac_final;
+	inst->alg.finup = hmac_finup;
+	inst->alg.setkey = hmac_setkey;
+
+	err = shash_register_instance(tmpl, inst);
+	if (err) {
+out_free_inst:
+		shash_free_instance(shash_crypto_instance(inst));
+	}
 
 out_put_alg:
 	crypto_mod_put(alg);
-	return inst;
+	return err;
 }
 
 static struct crypto_template hmac_tmpl = {
 	.name = "hmac",
-	.alloc = hmac_alloc,
-	.free = hmac_free,
+	.create = hmac_create,
+	.free = shash_free_instance,
 	.module = THIS_MODULE,
 };
 
