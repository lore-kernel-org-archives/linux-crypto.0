From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 34/35] crypto: ahash - Add unaligned handling and default operations
Date: Wed, 15 Jul 2009 15:16:29 +0800
Message-ID: <E1MQyj7-00052e-6H@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48351 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752943AbZGOHgj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:39 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj7-0004x7-Fk
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:29 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Add unaligned handling and default operations

This patch exports the finup operation where available and adds
a default finup operation for ahash.  The operations final, finup
and digest also will now deal with unaligned result pointers by
copying it.  Finally export/import operations are will now be
exported too.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |  204 ++++++++++++++++++++++++++++++++++++++++-
 crypto/shash.c                 |   52 +++++++++-
 include/crypto/hash.h          |   23 +---
 include/crypto/internal/hash.h |    6 +
 4 files changed, 263 insertions(+), 22 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a196055..ac0798d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -24,6 +24,13 @@
 
 #include "internal.h"
 
+struct ahash_request_priv {
+	crypto_completion_t complete;
+	void *data;
+	u8 *result;
+	void *ubuf[] CRYPTO_MINALIGN_ATTR;
+};
+
 static inline struct ahash_alg *crypto_ahash_alg(struct crypto_ahash *hash)
 {
 	return container_of(crypto_hash_alg_common(hash), struct ahash_alg,
@@ -156,7 +163,7 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 	return ret;
 }
 
-static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct ahash_alg *ahash = crypto_ahash_alg(tfm);
@@ -167,6 +174,7 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	return ahash->setkey(tfm, key, keylen);
 }
+EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
 static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 			  unsigned int keylen)
@@ -174,19 +182,209 @@ static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 	return -ENOSYS;
 }
 
+static inline unsigned int ahash_align_buffer_size(unsigned len,
+						   unsigned long mask)
+{
+	return len + (mask & ~(crypto_tfm_ctx_alignment() - 1));
+}
+
+static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
+{
+	struct ahash_request_priv *priv = req->priv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (!err)
+		memcpy(priv->result, req->result,
+		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
+
+	kzfree(priv);
+}
+
+static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
+{
+	struct ahash_request *areq = req->data;
+	struct ahash_request_priv *priv = areq->priv;
+	crypto_completion_t complete = priv->complete;
+	void *data = priv->data;
+
+	ahash_op_unaligned_finish(areq, err);
+
+	complete(data, err);
+}
+
+static int ahash_op_unaligned(struct ahash_request *req,
+			      int (*op)(struct ahash_request *))
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	struct ahash_request_priv *priv;
+	int err;
+
+	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
+		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_ATOMIC : GFP_ATOMIC);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->result = req->result;
+	priv->complete = req->base.complete;
+	priv->data = req->base.data;
+
+	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
+	req->base.complete = ahash_op_unaligned_done;
+	req->base.data = req;
+	req->priv = priv;
+
+	err = op(req);
+	ahash_op_unaligned_finish(req, err);
+
+	return err;
+}
+
+static int crypto_ahash_op(struct ahash_request *req,
+			   int (*op)(struct ahash_request *))
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+
+	if ((unsigned long)req->result & alignmask)
+		return ahash_op_unaligned(req, op);
+
+	return op(req);
+}
+
+int crypto_ahash_final(struct ahash_request *req)
+{
+	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_final);
+
+int crypto_ahash_finup(struct ahash_request *req)
+{
+	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_finup);
+
+int crypto_ahash_digest(struct ahash_request *req)
+{
+	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->digest);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_digest);
+
+static void ahash_def_finup_finish2(struct ahash_request *req, int err)
+{
+	struct ahash_request_priv *priv = req->priv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (!err)
+		memcpy(priv->result, req->result,
+		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
+
+	kzfree(priv);
+}
+
+static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
+{
+	struct ahash_request *areq = req->data;
+	struct ahash_request_priv *priv = areq->priv;
+	crypto_completion_t complete = priv->complete;
+	void *data = priv->data;
+
+	ahash_def_finup_finish2(areq, err);
+
+	complete(data, err);
+}
+
+static int ahash_def_finup_finish1(struct ahash_request *req, int err)
+{
+	if (err)
+		goto out;
+
+	req->base.complete = ahash_def_finup_done2;
+	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_ahash_reqtfm(req)->final(req);
+
+out:
+	ahash_def_finup_finish2(req, err);
+	return err;
+}
+
+static void ahash_def_finup_done1(struct crypto_async_request *req, int err)
+{
+	struct ahash_request *areq = req->data;
+	struct ahash_request_priv *priv = areq->priv;
+	crypto_completion_t complete = priv->complete;
+	void *data = priv->data;
+
+	err = ahash_def_finup_finish1(areq, err);
+
+	complete(data, err);
+}
+
+static int ahash_def_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	struct ahash_request_priv *priv;
+
+	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
+		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_ATOMIC : GFP_ATOMIC);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->result = req->result;
+	priv->complete = req->base.complete;
+	priv->data = req->base.data;
+
+	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
+	req->base.complete = ahash_def_finup_done1;
+	req->base.data = req;
+	req->priv = priv;
+
+	return ahash_def_finup_finish1(req, tfm->update(req));
+}
+
+static int ahash_no_export(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
+static int ahash_no_import(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
+	hash->setkey = ahash_nosetkey;
+	hash->export = ahash_no_export;
+	hash->import = ahash_no_import;
+
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
 
 	hash->init = alg->init;
 	hash->update = alg->update;
-	hash->final  = alg->final;
+	hash->final = alg->final;
+	hash->finup = alg->finup ?: ahash_def_finup;
 	hash->digest = alg->digest;
-	hash->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
+
+	if (alg->setkey)
+		hash->setkey = alg->setkey;
+	if (alg->export)
+		hash->export = alg->export;
+	if (alg->import)
+		hash->import = alg->import;
 
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index 171c8f0..834d9d2 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -235,6 +235,33 @@ static int shash_async_final(struct ahash_request *req)
 	return crypto_shash_final(ahash_request_ctx(req), req->result);
 }
 
+int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
+{
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_hash_walk_last(&walk) ?
+			 crypto_shash_finup(desc, walk.data, nbytes,
+					    req->result) :
+			 crypto_shash_update(desc, walk.data, nbytes);
+
+	return nbytes;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_finup);
+
+static int shash_async_finup(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+	desc->flags = req->base.flags;
+
+	return shash_ahash_finup(req, desc);
+}
+
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct scatterlist *sg = req->src;
@@ -252,8 +279,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
-		      shash_ahash_update(req, desc) ?:
-		      crypto_shash_final(desc, req->result);
+		      shash_ahash_finup(req, desc);
 
 	return err;
 }
@@ -270,6 +296,16 @@ static int shash_async_digest(struct ahash_request *req)
 	return shash_ahash_digest(req, desc);
 }
 
+static int shash_async_export(struct ahash_request *req, void *out)
+{
+	return crypto_shash_export(ahash_request_ctx(req), out);
+}
+
+static int shash_async_import(struct ahash_request *req, const void *in)
+{
+	return crypto_shash_import(ahash_request_ctx(req), in);
+}
+
 static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
 {
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
@@ -280,6 +316,7 @@ static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
 int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
+	struct shash_alg *alg = __crypto_shash_alg(calg);
 	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
@@ -298,9 +335,16 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 
 	crt->init = shash_async_init;
 	crt->update = shash_async_update;
-	crt->final  = shash_async_final;
+	crt->final = shash_async_final;
+	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
-	crt->setkey = shash_async_setkey;
+
+	if (alg->setkey)
+		crt->setkey = shash_async_setkey;
+	if (alg->export)
+		crt->export = shash_async_export;
+	if (alg->setkey)
+		crt->import = shash_async_import;
 
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 45c2bdd..3e89ce1 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -31,6 +31,9 @@ struct ahash_request {
 	struct scatterlist *src;
 	u8 *result;
 
+	/* This field may only be used by the ahash API code. */
+	void *priv;
+
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -175,16 +178,11 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 	return req->__ctx;
 }
 
-static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
-				      const u8 *key, unsigned int keylen)
-{
-	return tfm->setkey(tfm, key, keylen);
-}
-
-static inline int crypto_ahash_digest(struct ahash_request *req)
-{
-	return crypto_ahash_reqtfm(req)->digest(req);
-}
+int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen);
+int crypto_ahash_finup(struct ahash_request *req);
+int crypto_ahash_final(struct ahash_request *req);
+int crypto_ahash_digest(struct ahash_request *req);
 
 static inline int crypto_ahash_export(struct ahash_request *req, void *out)
 {
@@ -206,11 +204,6 @@ static inline int crypto_ahash_update(struct ahash_request *req)
 	return crypto_ahash_reqtfm(req)->update(req);
 }
 
-static inline int crypto_ahash_final(struct ahash_request *req)
-{
-	return crypto_ahash_reqtfm(req)->final(req);
-}
-
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 179dd8f..5bfad8c 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -59,6 +59,11 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 				  struct crypto_hash_walk *walk,
 				  struct scatterlist *sg, unsigned int len);
 
+static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
+{
+	return !(walk->entrylen | walk->total);
+}
+
 int crypto_register_ahash(struct ahash_alg *alg);
 int crypto_unregister_ahash(struct ahash_alg *alg);
 int ahash_register_instance(struct crypto_template *tmpl,
@@ -94,6 +99,7 @@ static inline void crypto_drop_shash(struct crypto_shash_spawn *spawn)
 struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
+int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
 
 int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
