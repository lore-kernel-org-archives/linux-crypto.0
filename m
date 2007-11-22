From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/11] [CRYPTO] blkcipher: Add givcipher_alloc_inst/givcipher_free_inst
Date: Thu, 22 Nov 2007 16:48:42 +0800
Message-ID: <E1Iv7jm-00020K-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4678 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751489AbXKVIsw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:52 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7jn-0008CN-Va
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:44 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] blkcipher: Add givcipher_alloc_inst/givcipher_free_inst

This patch creates the infrastructure to help the construction of givcipher
templates that wrap around existing blkcipher/ablkcipher algorithms by adding
an IV generator to them.

It also adds the function crypto_spawn_nivcipher that spawns ablkcipher
objects without the givcrypt method.  This is to be used internally by
the givcipher templates.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   23 +++++---
 crypto/blkcipher.c      |  136 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   16 +++++
 include/linux/crypto.h  |    1 
 4 files changed, 168 insertions(+), 8 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 08eca6d..217919c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -519,14 +519,21 @@ struct crypto_instance *crypto_alloc_instance(const char *name,
 	if (!inst)
 		return ERR_PTR(-ENOMEM);
 
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)", name,
-		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
-
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
-		     name, alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto err_free_inst;
+	if (name) {
+		err = -ENAMETOOLONG;
+		if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+			     name, alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", name, alg->cra_driver_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+	} else {
+		memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+		memcpy(inst->alg.cra_driver_name, alg->cra_driver_name,
+		       CRYPTO_MAX_ALG_NAME);
+	}
 
 	spawn = crypto_instance_ctx(inst);
 	err = crypto_init_spawn(spawn, alg, inst,
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 75c3ab9..bd34643 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -508,5 +508,141 @@ const struct crypto_type crypto_blkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
 
+struct crypto_instance *givcipher_alloc_inst(struct crypto_template *tmpl,
+					     struct rtattr **tb, u32 type,
+					     u32 mask)
+{
+	struct {
+		int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
+		              unsigned int keylen);
+		int (*encrypt)(struct ablkcipher_request *req);
+		int (*decrypt)(struct ablkcipher_request *req);
+
+		unsigned int min_keysize;
+		unsigned int max_keysize;
+		unsigned int ivsize;
+
+		const char *geniv;
+	} balg;
+	const char *name;
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_PTR(PTR_ERR(algt));
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_GIVCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	/* First look for an algorithm with no IV generator. */
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER | type,
+				  CRYPTO_ALG_TYPE_NIVCIPHER_MASK | mask);
+	err = PTR_ERR(alg);
+	if (IS_ERR(alg)) {
+		if (err != -ENOENT)
+			return ERR_PTR(err);
+		alg = NULL;
+	}
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER) {
+		balg.ivsize = alg->cra_blkcipher.ivsize;
+		balg.min_keysize = alg->cra_blkcipher.min_keysize;
+		balg.max_keysize = alg->cra_blkcipher.max_keysize;
+
+		balg.setkey = async_setkey;
+		balg.encrypt = async_encrypt;
+		balg.decrypt = async_decrypt;
+
+		balg.geniv = alg->cra_blkcipher.geniv;
+	} else {
+		balg.ivsize = alg->cra_ablkcipher.ivsize;
+		balg.min_keysize = alg->cra_ablkcipher.min_keysize;
+		balg.max_keysize = alg->cra_ablkcipher.max_keysize;
+
+		balg.setkey = alg->cra_ablkcipher.setkey;
+		balg.encrypt = alg->cra_ablkcipher.encrypt;
+		balg.decrypt = alg->cra_ablkcipher.decrypt;
+
+		balg.geniv = alg->cra_ablkcipher.geniv;
+	}
+
+	inst = ERR_PTR(-EAGAIN);
+
+	if (!balg.ivsize)
+		goto out_put_alg;
+
+	/* Use original name for default IV generator. */
+	name = NULL;
+
+	/*
+	 * This is set unless we're constructing an algorithm with its
+	 * default IV generator.  So check algorithms with IV generators
+	 * too since we may be overriding them.
+	 */
+	if (algt->mask) {
+		struct crypto_alg *giv;
+
+		giv = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER | type,
+					  CRYPTO_ALG_TYPE_BLKCIPHER_MASK |
+					  mask);
+		err = PTR_ERR(giv);
+		if (IS_ERR(giv)) {
+			inst = ERR_PTR(err);
+			if (err != -ENOENT)
+				goto out_put_alg;
+			giv = NULL;
+		}
+
+		if (!alg)
+			alg = giv;
+		else if (giv) {
+			if (giv->cra_priority < alg->cra_priority) {
+				crypto_mod_put(alg);
+				alg = giv;
+			} else
+				crypto_mod_put(giv);
+		}
+
+		name = tmpl->name;
+	} else if (strcmp(tmpl->name, balg.geniv))
+		goto out_put_alg;
+
+	inst = crypto_alloc_instance(name, alg);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER;
+	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_givcipher_type;
+
+	inst->alg.cra_ablkcipher.ivsize = balg.ivsize;
+	inst->alg.cra_ablkcipher.min_keysize = balg.min_keysize;
+	inst->alg.cra_ablkcipher.max_keysize = balg.max_keysize;
+
+	inst->alg.cra_ablkcipher.setkey = balg.setkey;
+	inst->alg.cra_ablkcipher.encrypt = balg.encrypt;
+	inst->alg.cra_ablkcipher.decrypt = balg.decrypt;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+EXPORT_SYMBOL_GPL(givcipher_alloc_inst);
+
+void givcipher_free_inst(struct crypto_instance *inst)
+{
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(givcipher_free_inst);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 7f71c41..bb8a2e8 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -139,6 +139,11 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
 
+struct crypto_instance *givcipher_alloc_inst(struct crypto_template *tmpl,
+					     struct rtattr **tb, u32 type,
+					     u32 mask);
+void givcipher_free_inst(struct crypto_instance *inst);
+
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
 	unsigned long addr = (unsigned long)crypto_tfm_ctx(tfm);
@@ -201,6 +206,17 @@ static inline struct crypto_ablkcipher *crypto_spawn_ablkcipher(
 	return __crypto_ablkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
 }
 
+static inline struct crypto_ablkcipher *crypto_spawn_nivcipher(
+	struct crypto_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
+	u32 mask = (spawn->alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+		   CRYPTO_ALG_TYPE_GIVCIPHER ? CRYPTO_ALG_TYPE_BLKCIPHER_MASK :
+					       CRYPTO_ALG_TYPE_NIVCIPHER_MASK;
+
+	return __crypto_ablkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
+}
+
 static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 95e99f4..cdbd251 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -39,6 +39,7 @@
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
+#define CRYPTO_ALG_TYPE_NIVCIPHER_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
