From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] [CRYPTO] api: Allow multiple frontends per backend
Date: Wed, 24 Jan 2007 21:29:19 +1100
Message-ID: <E1H9fNX-0005nA-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2904 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbXAXK3W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:22 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNY-0005wm-2s
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:20 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNX-0005nA-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:19 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Allow multiple frontends per backend

This patch adds support for multiple frontend types for each backend
algorithm by passing the type and mask through to the backend type
init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |    2 +-
 crypto/api.c            |   25 +++++++++++++------------
 crypto/blkcipher.c      |    5 +++--
 crypto/hash.c           |    5 +++--
 crypto/internal.h       |    3 ++-
 include/crypto/algapi.h |    4 ++--
 6 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -401,7 +401,7 @@ struct crypto_tfm *crypto_spawn_tfm(stru
 	if (unlikely((alg->cra_flags ^ type) & mask))
 		goto out_put_alg;
 
-	tfm = __crypto_alloc_tfm(alg);
+	tfm = __crypto_alloc_tfm(alg, type, mask);
 	if (IS_ERR(tfm))
 		goto out_put_alg;
 
diff --git a/crypto/api.c b/crypto/api.c
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -212,12 +212,12 @@ struct crypto_alg *crypto_alg_mod_lookup
 }
 EXPORT_SYMBOL_GPL(crypto_alg_mod_lookup);
 
-static int crypto_init_ops(struct crypto_tfm *tfm)
+static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
-	const struct crypto_type *type = tfm->__crt_alg->cra_type;
+	const struct crypto_type *type_obj = tfm->__crt_alg->cra_type;
 
-	if (type)
-		return type->init(tfm);
+	if (type_obj)
+		return type_obj->init(tfm, type, mask);
 
 	switch (crypto_tfm_alg_type(tfm)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
@@ -266,14 +266,14 @@ static void crypto_exit_ops(struct crypt
 	}
 }
 
-static unsigned int crypto_ctxsize(struct crypto_alg *alg)
+static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 {
-	const struct crypto_type *type = alg->cra_type;
+	const struct crypto_type *type_obj = alg->cra_type;
 	unsigned int len;
 
 	len = alg->cra_alignmask & ~(crypto_tfm_ctx_alignment() - 1);
-	if (type)
-		return len + type->ctxsize(alg);
+	if (type_obj)
+		return len + type_obj->ctxsize(alg, type, mask);
 
 	switch (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
 	default:
@@ -303,20 +303,21 @@ void crypto_shoot_alg(struct crypto_alg 
 }
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg)
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
+				      u32 mask)
 {
 	struct crypto_tfm *tfm = NULL;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
-	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg);
+	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
 	tfm = kzalloc(tfm_size, GFP_KERNEL);
 	if (tfm == NULL)
 		goto out_err;
 
 	tfm->__crt_alg = alg;
 
-	err = crypto_init_ops(tfm);
+	err = crypto_init_ops(tfm, type, mask);
 	if (err)
 		goto out_free_tfm;
 
@@ -372,7 +373,7 @@ struct crypto_tfm *crypto_alloc_base(con
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg);
+		tfm = __crypto_alloc_tfm(alg, type, mask);
 		if (!IS_ERR(tfm))
 			return tfm;
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -349,7 +349,8 @@ static int setkey(struct crypto_tfm *tfm
 	return cipher->setkey(tfm, key, keylen);
 }
 
-static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg)
+static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg, u32 type,
+					     u32 mask)
 {
 	struct blkcipher_alg *cipher = &alg->cra_blkcipher;
 	unsigned int len = alg->cra_ctxsize;
@@ -362,7 +363,7 @@ static unsigned int crypto_blkcipher_ctx
 	return len;
 }
 
-static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm)
+static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct blkcipher_tfm *crt = &tfm->crt_blkcipher;
 	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
diff --git a/crypto/hash.c b/crypto/hash.c
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -16,12 +16,13 @@
 
 #include "internal.h"
 
-static unsigned int crypto_hash_ctxsize(struct crypto_alg *alg)
+static unsigned int crypto_hash_ctxsize(struct crypto_alg *alg, u32 type,
+					u32 mask)
 {
 	return alg->cra_ctxsize;
 }
 
-static int crypto_init_hash_ops(struct crypto_tfm *tfm)
+static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct hash_tfm *crt = &tfm->crt_hash;
 	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
diff --git a/crypto/internal.h b/crypto/internal.h
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -120,7 +120,8 @@ void crypto_exit_compress_ops(struct cry
 void crypto_larval_error(const char *name, u32 type, u32 mask);
 
 void crypto_shoot_alg(struct crypto_alg *alg);
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg);
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
+				      u32 mask);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -18,8 +18,8 @@ struct module;
 struct seq_file;
 
 struct crypto_type {
-	unsigned int (*ctxsize)(struct crypto_alg *alg);
-	int (*init)(struct crypto_tfm *tfm);
+	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
+	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
 	void (*exit)(struct crypto_tfm *tfm);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 };
