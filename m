From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 23/35] crypto: ahash - Convert to new style algorithms
Date: Wed, 15 Jul 2009 15:16:17 +0800
Message-ID: <E1MQyiv-000513-9K@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53647 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbZGOHQY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiw-0004tN-2x
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:18 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Convert to new style algorithms

This patch converts crypto_ahash to the new style.  The old ahash
algorithm type is retained until the existing ahash implementations
are also converted.  All ahash users will automatically get the
new crypto_ahash type.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   82 +++++++++++++++++++++---------
 crypto/shash.c                 |    8 ---
 include/crypto/hash.h          |  109 +++++++++++++++++++++++++++++------------
 include/crypto/internal/hash.h |   11 +++-
 include/linux/crypto.h         |   29 +---------
 5 files changed, 148 insertions(+), 91 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f347637..8385193 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -24,6 +24,12 @@
 
 #include "internal.h"
 
+static inline struct ahash_alg *crypto_ahash_alg(struct crypto_ahash *hash)
+{
+	return container_of(crypto_hash_alg_common(hash), struct ahash_alg,
+			    halg);
+}
+
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int alignmask = walk->alignmask;
@@ -169,30 +175,11 @@ static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 	return -ENOSYS;
 }
 
-int crypto_ahash_import(struct ahash_request *req, const u8 *in)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ahash_alg *alg = crypto_ahash_alg(tfm);
-
-	memcpy(ahash_request_ctx(req), in, crypto_ahash_reqsize(tfm));
-
-	if (alg->reinit)
-		alg->reinit(req);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_ahash_import);
-
-static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 type,
-					u32 mask)
-{
-	return alg->cra_ctxsize;
-}
-
 static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
-	struct ahash_alg *alg = &tfm->__crt_alg->cra_ahash;
-	struct ahash_tfm *crt   = &tfm->crt_ahash;
+	struct old_ahash_alg *alg = &tfm->__crt_alg->cra_ahash;
+	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
+	struct ahash_alg *nalg = crypto_ahash_alg(crt);
 
 	if (alg->digestsize > PAGE_SIZE / 8)
 		return -EINVAL;
@@ -204,9 +191,42 @@ static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
 	crt->digestsize = alg->digestsize;
 
+	nalg->setkey = alg->setkey;
+	nalg->halg.digestsize = alg->digestsize;
+
 	return 0;
 }
 
+static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(hash);
+	struct old_ahash_alg *oalg = crypto_old_ahash_alg(hash);
+
+	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
+		return crypto_init_shash_ops_async(tfm);
+
+	if (oalg->init)
+		return crypto_init_ahash_ops(tfm, 0, 0);
+
+	hash->init = alg->init;
+	hash->update = alg->update;
+	hash->final  = alg->final;
+	hash->digest = alg->digest;
+	hash->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
+	hash->digestsize = alg->halg.digestsize;
+
+	return 0;
+}
+
+static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
+{
+	if (alg->cra_type == &crypto_ahash_type)
+		return alg->cra_ctxsize;
+
+	return sizeof(struct crypto_shash *);
+}
+
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
@@ -215,17 +235,29 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
 					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "digestsize   : %u\n", alg->cra_ahash.digestsize);
+	seq_printf(m, "digestsize   : %u\n",
+		   __crypto_hash_alg_common(alg)->digestsize);
 }
 
 const struct crypto_type crypto_ahash_type = {
-	.ctxsize = crypto_ahash_ctxsize,
-	.init = crypto_init_ahash_ops,
+	.extsize = crypto_ahash_extsize,
+	.init_tfm = crypto_ahash_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_AHASH_MASK,
+	.type = CRYPTO_ALG_TYPE_AHASH,
+	.tfmsize = offsetof(struct crypto_ahash, base),
 };
 EXPORT_SYMBOL_GPL(crypto_ahash_type);
 
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_ahash_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/shash.c b/crypto/shash.c
index 7063e14..615a5f4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -267,11 +267,11 @@ static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
 	crypto_free_shash(*ctx);
 }
 
-static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
+int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
 	struct shash_alg *alg = __crypto_shash_alg(calg);
-	struct ahash_tfm *crt = &tfm->crt_ahash;
+	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
 
@@ -428,8 +428,6 @@ static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_HASH_MASK:
 		return crypto_init_shash_ops_compat(tfm);
-	case CRYPTO_ALG_TYPE_AHASH_MASK:
-		return crypto_init_shash_ops_async(tfm);
 	}
 
 	return -EINVAL;
@@ -441,8 +439,6 @@ static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_HASH_MASK:
 		return sizeof(struct shash_desc *);
-	case CRYPTO_ALG_TYPE_AHASH_MASK:
-		return sizeof(struct crypto_shash *);
 	}
 
 	return 0;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index fcc02d9..262861d 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -15,6 +15,39 @@
 
 #include <linux/crypto.h>
 
+struct crypto_ahash;
+
+struct hash_alg_common {
+	unsigned int digestsize;
+	unsigned int statesize;
+
+	struct crypto_alg base;
+};
+
+struct ahash_request {
+	struct crypto_async_request base;
+
+	unsigned int nbytes;
+	struct scatterlist *src;
+	u8 *result;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+struct ahash_alg {
+	int (*init)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req);
+	int (*final)(struct ahash_request *req);
+	int (*finup)(struct ahash_request *req);
+	int (*digest)(struct ahash_request *req);
+	int (*export)(struct ahash_request *req, void *out);
+	int (*import)(struct ahash_request *req, const void *in);
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
+		      unsigned int keylen);
+
+	struct hash_alg_common halg;
+};
+
 struct shash_desc {
 	struct crypto_shash *tfm;
 	u32 flags;
@@ -37,6 +70,8 @@ struct shash_alg {
 		      unsigned int keylen);
 
 	unsigned int descsize;
+
+	/* These fields must match hash_alg_common. */
 	unsigned int digestsize;
 	unsigned int statesize;
 
@@ -44,6 +79,18 @@ struct shash_alg {
 };
 
 struct crypto_ahash {
+	int (*init)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req);
+	int (*final)(struct ahash_request *req);
+	int (*finup)(struct ahash_request *req);
+	int (*digest)(struct ahash_request *req);
+	int (*export)(struct ahash_request *req, void *out);
+	int (*import)(struct ahash_request *req, const void *in);
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
+		      unsigned int keylen);
+
+	unsigned int digestsize;
+	unsigned int reqsize;
 	struct crypto_tfm base;
 };
 
@@ -54,19 +101,11 @@ struct crypto_shash {
 
 static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 {
-	return (struct crypto_ahash *)tfm;
+	return container_of(tfm, struct crypto_ahash, base);
 }
 
-static inline struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,
-						      u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_AHASH;
-	mask |= CRYPTO_ALG_TYPE_AHASH_MASK;
-
-	return __crypto_ahash_cast(crypto_alloc_base(alg_name, type, mask));
-}
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
+					u32 mask);
 
 static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 {
@@ -75,7 +114,7 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 
 static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 {
-	crypto_free_tfm(crypto_ahash_tfm(tfm));
+	crypto_destroy_tfm(tfm, crypto_ahash_tfm(tfm));
 }
 
 static inline unsigned int crypto_ahash_alignmask(
@@ -84,14 +123,26 @@ static inline unsigned int crypto_ahash_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));
 }
 
-static inline struct ahash_tfm *crypto_ahash_crt(struct crypto_ahash *tfm)
+static inline struct hash_alg_common *__crypto_hash_alg_common(
+	struct crypto_alg *alg)
 {
-	return &crypto_ahash_tfm(tfm)->crt_ahash;
+	return container_of(alg, struct hash_alg_common, base);
+}
+
+static inline struct hash_alg_common *crypto_hash_alg_common(
+	struct crypto_ahash *tfm)
+{
+	return __crypto_hash_alg_common(crypto_ahash_tfm(tfm)->__crt_alg);
 }
 
 static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 {
-	return crypto_ahash_crt(tfm)->digestsize;
+	return tfm->digestsize;
+}
+
+static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
+{
+	return crypto_hash_alg_common(tfm)->statesize;
 }
 
 static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)
@@ -117,7 +168,7 @@ static inline struct crypto_ahash *crypto_ahash_reqtfm(
 
 static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 {
-	return crypto_ahash_crt(tfm)->reqsize;
+	return tfm->reqsize;
 }
 
 static inline void *ahash_request_ctx(struct ahash_request *req)
@@ -128,41 +179,37 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
 				      const u8 *key, unsigned int keylen)
 {
-	struct ahash_tfm *crt = crypto_ahash_crt(tfm);
-
-	return crt->setkey(tfm, key, keylen);
+	return tfm->setkey(tfm, key, keylen);
 }
 
 static inline int crypto_ahash_digest(struct ahash_request *req)
 {
-	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
-	return crt->digest(req);
+	return crypto_ahash_reqtfm(req)->digest(req);
 }
 
-static inline void crypto_ahash_export(struct ahash_request *req, u8 *out)
+static inline int crypto_ahash_export(struct ahash_request *req, void *out)
 {
-	memcpy(out, ahash_request_ctx(req),
-	       crypto_ahash_reqsize(crypto_ahash_reqtfm(req)));
+	return crypto_ahash_reqtfm(req)->export(req, out);
 }
 
-int crypto_ahash_import(struct ahash_request *req, const u8 *in);
+static inline int crypto_ahash_import(struct ahash_request *req, const void *in)
+{
+	return crypto_ahash_reqtfm(req)->import(req, in);
+}
 
 static inline int crypto_ahash_init(struct ahash_request *req)
 {
-	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
-	return crt->init(req);
+	return crypto_ahash_reqtfm(req)->init(req);
 }
 
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
-	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
-	return crt->update(req);
+	return crypto_ahash_reqtfm(req)->update(req);
 }
 
 static inline int crypto_ahash_final(struct ahash_request *req)
 {
-	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
-	return crt->final(req);
+	return crypto_ahash_reqtfm(req)->final(req);
 }
 
 static inline void ahash_request_set_tfm(struct ahash_request *req,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 5e45818..08bdffa 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -51,6 +51,9 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 				  struct crypto_hash_walk *walk,
 				  struct scatterlist *sg, unsigned int len);
 
+int crypto_register_ahash(struct ahash_alg *alg);
+int crypto_unregister_ahash(struct ahash_alg *alg);
+
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
 int shash_register_instance(struct crypto_template *tmpl,
@@ -66,12 +69,14 @@ struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
 
+int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
-	return crypto_tfm_ctx(&tfm->base);
+	return crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 }
 
-static inline struct ahash_alg *crypto_ahash_alg(
+static inline struct old_ahash_alg *crypto_old_ahash_alg(
 	struct crypto_ahash *tfm)
 {
 	return &crypto_ahash_tfm(tfm)->__crt_alg->cra_ahash;
@@ -80,7 +85,7 @@ static inline struct ahash_alg *crypto_ahash_alg(
 static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 					    unsigned int reqsize)
 {
-	crypto_ahash_crt(tfm)->reqsize = reqsize;
+	tfm->reqsize = reqsize;
 }
 
 static inline int ahash_enqueue_request(struct crypto_queue *queue,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 274f9c7..9e7e9b6 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -120,6 +120,7 @@ struct crypto_rng;
 struct crypto_tfm;
 struct crypto_type;
 struct aead_givcrypt_request;
+struct ahash_request;
 struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
@@ -146,16 +147,6 @@ struct ablkcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-struct ahash_request {
-	struct crypto_async_request base;
-
-	unsigned int nbytes;
-	struct scatterlist *src;
-	u8		   *result;
-
-	void *__ctx[] CRYPTO_MINALIGN_ATTR;
-};
-
 /**
  *	struct aead_request - AEAD request
  *	@base: Common attributes for async crypto requests
@@ -220,7 +211,7 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
 
-struct ahash_alg {
+struct old_ahash_alg {
 	int (*init)(struct ahash_request *req);
 	int (*reinit)(struct ahash_request *req);
 	int (*update)(struct ahash_request *req);
@@ -346,7 +337,7 @@ struct crypto_alg {
 		struct cipher_alg cipher;
 		struct digest_alg digest;
 		struct hash_alg hash;
-		struct ahash_alg ahash;
+		struct old_ahash_alg ahash;
 		struct compress_alg compress;
 		struct rng_alg rng;
 	} cra_u;
@@ -433,18 +424,6 @@ struct hash_tfm {
 	unsigned int digestsize;
 };
 
-struct ahash_tfm {
-	int (*init)(struct ahash_request *req);
-	int (*update)(struct ahash_request *req);
-	int (*final)(struct ahash_request *req);
-	int (*digest)(struct ahash_request *req);
-	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
-			unsigned int keylen);
-
-	unsigned int digestsize;
-	unsigned int reqsize;
-};
