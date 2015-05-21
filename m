From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/16] crypto: seqiv - Add support for new AEAD interface
Date: Thu, 21 May 2015 15:11:13 +0800
Message-ID: <E1YvKdN-0005gS-If@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35482 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbbEUHLQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:16 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdN-00031D-Nr
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:14 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the seqiv IV generator to work with the new
AEAD interface where IV generators are just normal AEAD algorithms.

Full backwards compatibility is paramount at this point since
no users have yet switched over to the new interface.  Nor can
they switch to the new interface until IV generation is fully
supported by it.

So this means we are adding two versions of seqiv alongside the
existing one.  The first one is the one that will be used when
the underlying AEAD algorithm has switched over to the new AEAD
interface.  The second one handles the current case where the
underlying AEAD algorithm still uses the old interface.

Both versions export themselves through the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig                 |    1 
 crypto/aead.c                  |  100 ++++++----
 crypto/seqiv.c                 |  386 +++++++++++++++++++++++++++++++++++++++--
 include/crypto/internal/aead.h |    7 
 4 files changed, 443 insertions(+), 51 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index eba55b4..657bb82 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -221,6 +221,7 @@ config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_NULL
 	select CRYPTO_RNG
 	help
 	  This IV generator generates an IV based on a sequence number by
diff --git a/crypto/aead.c b/crypto/aead.c
index d231e28..5fa992a 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -378,15 +378,16 @@ static int crypto_grab_nivaead(struct crypto_aead_spawn *spawn,
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 
-struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-					 struct rtattr **tb, u32 type,
-					 u32 mask)
+struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+				       struct rtattr **tb, u32 type, u32 mask)
 {
 	const char *name;
 	struct crypto_aead_spawn *spawn;
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct aead_instance *inst;
+	struct aead_alg *alg;
+	unsigned int ivsize;
+	unsigned int maxauthsize;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -405,20 +406,28 @@ struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	if (!inst)
 		return ERR_PTR(-ENOMEM);
 
-	spawn = crypto_instance_ctx(inst);
+	spawn = aead_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
 	mask |= crypto_requires_sync(algt->type, algt->mask);
 
-	crypto_set_aead_spawn(spawn, inst);
+	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
 	err = crypto_grab_nivaead(spawn, name, type, mask);
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_aead_spawn_alg(spawn);
+	alg = crypto_spawn_aead_alg(spawn);
+
+	if (alg->base.cra_aead.encrypt) {
+		ivsize = alg->base.cra_aead.ivsize;
+		maxauthsize = alg->base.cra_aead.maxauthsize;
+	} else {
+		ivsize = alg->ivsize;
+		maxauthsize = alg->maxauthsize;
+	}
 
 	err = -EINVAL;
-	if (!alg->cra_aead.ivsize)
+	if (!ivsize)
 		goto err_drop_alg;
 
 	/*
@@ -427,39 +436,56 @@ struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	 * template name and double-check the IV generator.
 	 */
 	if (algt->mask & CRYPTO_ALG_GENIV) {
-		if (strcmp(tmpl->name, alg->cra_aead.geniv))
+		if (!alg->base.cra_aead.encrypt)
+			goto err_drop_alg;
+		if (strcmp(tmpl->name, alg->base.cra_aead.geniv))
 			goto err_drop_alg;
 
-		memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
-		memcpy(inst->alg.cra_driver_name, alg->cra_driver_name,
+		memcpy(inst->alg.base.cra_name, alg->base.cra_name,
 		       CRYPTO_MAX_ALG_NAME);
-	} else {
-		err = -ENAMETOOLONG;
-		if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "%s(%s)", tmpl->name, alg->cra_name) >=
-		    CRYPTO_MAX_ALG_NAME)
-			goto err_drop_alg;
-		if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-			     "%s(%s)", tmpl->name, alg->cra_driver_name) >=
-		    CRYPTO_MAX_ALG_NAME)
-			goto err_drop_alg;
+		memcpy(inst->alg.base.cra_driver_name,
+		       alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME);
+
+		inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					   CRYPTO_ALG_GENIV;
+		inst->alg.base.cra_flags |= alg->base.cra_flags &
+					    CRYPTO_ALG_ASYNC;
+		inst->alg.base.cra_priority = alg->base.cra_priority;
+		inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+		inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+		inst->alg.base.cra_type = &crypto_aead_type;
+
+		inst->alg.base.cra_aead.ivsize = ivsize;
+		inst->alg.base.cra_aead.maxauthsize = maxauthsize;
+
+		inst->alg.base.cra_aead.setkey = alg->base.cra_aead.setkey;
+		inst->alg.base.cra_aead.setauthsize =
+			alg->base.cra_aead.setauthsize;
+		inst->alg.base.cra_aead.encrypt = alg->base.cra_aead.encrypt;
+		inst->alg.base.cra_aead.decrypt = alg->base.cra_aead.decrypt;
+
+		goto out;
 	}
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV;
-	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_aead_type;
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", tmpl->name, alg->base.cra_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_alg;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", tmpl->name, alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_alg;
 
-	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
-	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
-	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
+	inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_AEAD;
+	inst->alg.base.cra_flags |= alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_type = &crypto_new_aead_type;
 
-	inst->alg.cra_aead.setkey = alg->cra_aead.setkey;
-	inst->alg.cra_aead.setauthsize = alg->cra_aead.setauthsize;
-	inst->alg.cra_aead.encrypt = alg->cra_aead.encrypt;
-	inst->alg.cra_aead.decrypt = alg->cra_aead.decrypt;
+	inst->alg.ivsize = ivsize;
+	inst->alg.maxauthsize = maxauthsize;
 
 out:
 	return inst;
@@ -473,9 +499,9 @@ err_free_inst:
 }
 EXPORT_SYMBOL_GPL(aead_geniv_alloc);
 
-void aead_geniv_free(struct crypto_instance *inst)
+void aead_geniv_free(struct aead_instance *inst)
 {
-	crypto_drop_aead(crypto_instance_ctx(inst));
+	crypto_drop_aead(aead_instance_ctx(inst));
 	kfree(inst);
 }
 EXPORT_SYMBOL_GPL(aead_geniv_free);
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 5bbf2e9..27dbab8a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -15,7 +15,9 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/null.h>
 #include <crypto/rng.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -29,6 +31,29 @@ struct seqiv_ctx {
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
+struct seqiv_aead_ctx {
+	struct crypto_aead *child;
+	spinlock_t lock;
+	struct crypto_blkcipher *null;
+	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
+};
+
+static int seqiv_aead_setkey(struct crypto_aead *tfm,
+			     const u8 *key, unsigned int keylen)
+{
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setkey(ctx->child, key, keylen);
+}
+
+static int seqiv_aead_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
 static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
 {
 	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
@@ -81,6 +106,33 @@ static void seqiv_aead_complete(struct crypto_async_request *base, int err)
 	aead_givcrypt_complete(req, err);
 }
 
+static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
+{
+	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_aead *geniv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (err)
+		goto out;
+
+	geniv = crypto_aead_reqtfm(req);
+	memcpy(req->iv, subreq->iv, crypto_aead_ivsize(geniv));
+
+out:
+	kzfree(subreq->iv);
+}
+
+static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
+					int err)
+{
+	struct aead_request *req = base->data;
+
+	seqiv_aead_encrypt_complete2(req, err);
+	aead_request_complete(req, err);
+}
+
 static void seqiv_geniv(struct seqiv_ctx *ctx, u8 *info, u64 seq,
 			unsigned int ivsize)
 {
@@ -186,6 +238,171 @@ static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
 	return err;
 }
 
+static int seqiv_aead_encrypt_compat(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_request *subreq = aead_request_ctx(req);
+	crypto_completion_t compl;
+	void *data;
+	u8 *info;
+	unsigned int ivsize;
+	int err;
+
+	aead_request_set_tfm(subreq, ctx->child);
+
+	compl = req->base.complete;
+	data = req->base.data;
+	info = req->iv;
+
+	ivsize = crypto_aead_ivsize(geniv);
+
+	if (unlikely(!IS_ALIGNED((unsigned long)info,
+				 crypto_aead_alignmask(geniv) + 1))) {
+		info = kmalloc(ivsize, req->base.flags &
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+								  GFP_ATOMIC);
+		if (!info)
+			return -ENOMEM;
+
+		memcpy(info, req->iv, ivsize);
+		compl = seqiv_aead_encrypt_complete;
+		data = req;
+	}
+
+	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       req->cryptlen - ivsize, info);
+	aead_request_set_ad(subreq, req->assoclen, ivsize);
+
+	crypto_xor(info, ctx->salt, ivsize);
+	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
+
+	err = crypto_aead_encrypt(subreq);
+	if (unlikely(info != req->iv))
+		seqiv_aead_encrypt_complete2(req, err);
+	return err;
+}
+
+static int seqiv_aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_request *subreq = aead_request_ctx(req);
+	crypto_completion_t compl;
+	void *data;
+	u8 *info;
+	unsigned int ivsize;
+	int err;
+
+	aead_request_set_tfm(subreq, ctx->child);
+
+	compl = req->base.complete;
+	data = req->base.data;
+	info = req->iv;
+
+	ivsize = crypto_aead_ivsize(geniv);
+
+	if (req->src != req->dst) {
+		struct scatterlist src[2];
+		struct scatterlist dst[2];
+		struct blkcipher_desc desc = {
+			.tfm = ctx->null,
+		};
+
+		err = crypto_blkcipher_encrypt(
+			&desc,
+			scatterwalk_ffwd(dst, req->dst,
+					 req->assoclen + ivsize),
+			scatterwalk_ffwd(src, req->src,
+					 req->assoclen + ivsize),
+			req->cryptlen - ivsize);
+		if (err)
+			return err;
+	}
+
+	if (unlikely(!IS_ALIGNED((unsigned long)info,
+				 crypto_aead_alignmask(geniv) + 1))) {
+		info = kmalloc(ivsize, req->base.flags &
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+								  GFP_ATOMIC);
+		if (!info)
+			return -ENOMEM;
+
+		memcpy(info, req->iv, ivsize);
+		compl = seqiv_aead_encrypt_complete;
+		data = req;
+	}
+
+	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_crypt(subreq, req->dst, req->dst,
+			       req->cryptlen - ivsize, info);
+	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+
+	crypto_xor(info, ctx->salt, ivsize);
+	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
+
+	err = crypto_aead_encrypt(subreq);
+	if (unlikely(info != req->iv))
+		seqiv_aead_encrypt_complete2(req, err);
+	return err;
+}
+
+static int seqiv_aead_decrypt_compat(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_request *subreq = aead_request_ctx(req);
+	crypto_completion_t compl;
+	void *data;
+	unsigned int ivsize;
+
+	aead_request_set_tfm(subreq, ctx->child);
+
+	compl = req->base.complete;
+	data = req->base.data;
+
+	ivsize = crypto_aead_ivsize(geniv);
+
+	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       req->cryptlen - ivsize, req->iv);
+	aead_request_set_ad(subreq, req->assoclen, ivsize);
+
+	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
+
+	return crypto_aead_decrypt(subreq);
+}
+
+static int seqiv_aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	struct aead_request *subreq = aead_request_ctx(req);
+	crypto_completion_t compl;
+	void *data;
+	unsigned int ivsize;
+
+	aead_request_set_tfm(subreq, ctx->child);
+
+	compl = req->base.complete;
+	data = req->base.data;
+
+	ivsize = crypto_aead_ivsize(geniv);
+
+	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_crypt(subreq, req->src, req->dst,
+			       req->cryptlen - ivsize, req->iv);
+	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+
+	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
+	if (req->src != req->dst)
+		scatterwalk_map_and_copy(req->iv, req->dst,
+					 req->assoclen, ivsize, 1);
+
+	return crypto_aead_decrypt(subreq);
+}
+
 static int seqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
@@ -232,6 +449,52 @@ unlock:
 	return seqiv_aead_givencrypt(req);
 }
 
+static int seqiv_aead_encrypt_compat_first(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
+
+	spin_lock_bh(&ctx->lock);
+	if (geniv->encrypt != seqiv_aead_encrypt_compat_first)
+		goto unlock;
+
+	geniv->encrypt = seqiv_aead_encrypt_compat;
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return seqiv_aead_encrypt_compat(req);
+}
+
+static int seqiv_aead_encrypt_first(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
+
+	spin_lock_bh(&ctx->lock);
+	if (geniv->encrypt != seqiv_aead_encrypt_first)
+		goto unlock;
+
+	geniv->encrypt = seqiv_aead_encrypt;
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return seqiv_aead_encrypt(req);
+}
+
 static int seqiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
@@ -244,7 +507,7 @@ static int seqiv_init(struct crypto_tfm *tfm)
 	return skcipher_geniv_init(tfm);
 }
 
-static int seqiv_aead_init(struct crypto_tfm *tfm)
+static int seqiv_old_aead_init(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
@@ -257,6 +520,69 @@ static int seqiv_aead_init(struct crypto_tfm *tfm)
 	return aead_geniv_init(tfm);
 }
 
+static int seqiv_aead_compat_init(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	int err;
+
+	spin_lock_init(&ctx->lock);
+
+	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
+
+	err = aead_geniv_init(tfm);
+
+	ctx->child = geniv->child;
+	geniv->child = geniv;
+
+	return err;
+}
+
+static int seqiv_aead_init(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
+	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
+	int err;
+
+	spin_lock_init(&ctx->lock);
+
+	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
+
+	ctx->null = crypto_get_default_null_skcipher();
+	err = PTR_ERR(ctx->null);
+	if (IS_ERR(ctx->null))
+		goto out;
+
+	err = aead_geniv_init(tfm);
+	if (err)
+		goto drop_null;
+
+	ctx->child = geniv->child;
+	geniv->child = geniv;
+
+out:
+	return err;
+
+drop_null:
+	crypto_put_default_null_skcipher();
+	goto out;
+}
+
+static void seqiv_aead_compat_exit(struct crypto_tfm *tfm)
+{
+	struct seqiv_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+}
+
+static void seqiv_aead_exit(struct crypto_tfm *tfm)
+{
+	struct seqiv_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+	crypto_put_default_null_skcipher();
+}
+
 static struct crypto_template seqiv_tmpl;
 
 static struct crypto_instance *seqiv_ablkcipher_alloc(struct rtattr **tb)
@@ -280,35 +606,76 @@ static struct crypto_instance *seqiv_ablkcipher_alloc(struct rtattr **tb)
 	inst->alg.cra_exit = skcipher_geniv_exit;
 
 	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
+	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
 
 out:
 	return inst;
 }
 
+static struct crypto_instance *seqiv_old_aead_alloc(struct aead_instance *aead)
+{
+	struct crypto_instance *inst = aead_crypto_instance(aead);
+
+	if (inst->alg.cra_aead.ivsize < sizeof(u64)) {
+		aead_geniv_free(aead);
+		return ERR_PTR(-EINVAL);
+	}
+
+	inst->alg.cra_aead.givencrypt = seqiv_aead_givencrypt_first;
+
+	inst->alg.cra_init = seqiv_old_aead_init;
+	inst->alg.cra_exit = aead_geniv_exit;
+
+	inst->alg.cra_ctxsize = inst->alg.cra_aead.ivsize;
+	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
+
+	return inst;
+}
+
 static struct crypto_instance *seqiv_aead_alloc(struct rtattr **tb)
 {
-	struct crypto_instance *inst;
+	struct aead_instance *inst;
+	struct crypto_aead_spawn *spawn;
+	struct aead_alg *alg;
 
 	inst = aead_geniv_alloc(&seqiv_tmpl, tb, 0, 0);
 
 	if (IS_ERR(inst))
 		goto out;
 
-	if (inst->alg.cra_aead.ivsize < sizeof(u64)) {
+	if (inst->alg.base.cra_aead.encrypt)
+		return seqiv_old_aead_alloc(inst);
+
+	if (inst->alg.ivsize < sizeof(u64)) {
 		aead_geniv_free(inst);
 		inst = ERR_PTR(-EINVAL);
 		goto out;
 	}
 
-	inst->alg.cra_aead.givencrypt = seqiv_aead_givencrypt_first;
+	spawn = aead_instance_ctx(inst);
+	alg = crypto_spawn_aead_alg(spawn);
 
-	inst->alg.cra_init = seqiv_aead_init;
-	inst->alg.cra_exit = aead_geniv_exit;
+	inst->alg.setkey = seqiv_aead_setkey;
+	inst->alg.setauthsize = seqiv_aead_setauthsize;
+	inst->alg.encrypt = seqiv_aead_encrypt_first;
+	inst->alg.decrypt = seqiv_aead_decrypt;
 
-	inst->alg.cra_ctxsize = inst->alg.cra_aead.ivsize;
+	inst->alg.base.cra_init = seqiv_aead_init;
+	inst->alg.base.cra_exit = seqiv_aead_exit;
+
+	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
+	inst->alg.base.cra_ctxsize += inst->alg.base.cra_aead.ivsize;
+
+	if (alg->base.cra_aead.encrypt) {
+		inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
+		inst->alg.decrypt = seqiv_aead_decrypt_compat;
+
+		inst->alg.base.cra_init = seqiv_aead_compat_init;
+		inst->alg.base.cra_exit = seqiv_aead_compat_exit;
+	}
 
 out:
-	return inst;
+	return aead_crypto_instance(inst);
 }
 
 static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
@@ -334,7 +701,6 @@ static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
 		goto put_rng;
 
 	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
-	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
 
 out:
 	return inst;
@@ -349,7 +715,7 @@ static void seqiv_free(struct crypto_instance *inst)
 	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
 		skcipher_geniv_free(inst);
 	else
-		aead_geniv_free(inst);
+		aead_geniv_free(aead_instance(inst));
 	crypto_put_default_rng();
 }
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 6cd3151..08f2ca6 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -117,10 +117,9 @@ static inline struct crypto_aead *crypto_spawn_aead(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-					 struct rtattr **tb, u32 type,
-					 u32 mask);
-void aead_geniv_free(struct crypto_instance *inst);
+struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+				       struct rtattr **tb, u32 type, u32 mask);
+void aead_geniv_free(struct aead_instance *inst);
 int aead_geniv_init(struct crypto_tfm *tfm);
 void aead_geniv_exit(struct crypto_tfm *tfm);
 
