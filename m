From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/35] crypto: shash - Make descsize a run-time attribute
Date: Wed, 15 Jul 2009 15:16:04 +0800
Message-ID: <E1MQyii-0004zE-C7@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53624 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607AbZGOHQH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyii-0004q0-Vk
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:05 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Make descsize a run-time attribute

This patch changes descsize to a run-time attribute so that
implementations can change it in their init functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |   39 ++++++++++++++++++++++++++++-----------
 include/crypto/hash.h          |    3 ++-
 include/crypto/internal/hash.h |    2 +-
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 131e14d..d8e0f8f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -300,14 +300,16 @@ static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 static int shash_compat_setkey(struct crypto_hash *tfm, const u8 *key,
 			       unsigned int keylen)
 {
-	struct shash_desc *desc = crypto_hash_ctx(tfm);
+	struct shash_desc **descp = crypto_hash_ctx(tfm);
+	struct shash_desc *desc = *descp;
 
 	return crypto_shash_setkey(desc->tfm, key, keylen);
 }
 
 static int shash_compat_init(struct hash_desc *hdesc)
 {
-	struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
+	struct shash_desc *desc = *descp;
 
 	desc->flags = hdesc->flags;
 
@@ -317,7 +319,8 @@ static int shash_compat_init(struct hash_desc *hdesc)
 static int shash_compat_update(struct hash_desc *hdesc, struct scatterlist *sg,
 			       unsigned int len)
 {
-	struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
+	struct shash_desc *desc = *descp;
 	struct crypto_hash_walk walk;
 	int nbytes;
 
@@ -330,7 +333,9 @@ static int shash_compat_update(struct hash_desc *hdesc, struct scatterlist *sg,
 
 static int shash_compat_final(struct hash_desc *hdesc, u8 *out)
 {
-	return crypto_shash_final(crypto_hash_ctx(hdesc->tfm), out);
+	struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
+
+	return crypto_shash_final(*descp, out);
 }
 
 static int shash_compat_digest(struct hash_desc *hdesc, struct scatterlist *sg,
@@ -340,7 +345,8 @@ static int shash_compat_digest(struct hash_desc *hdesc, struct scatterlist *sg,
 	int err;
 
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
-		struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+		struct shash_desc **descp = crypto_hash_ctx(hdesc->tfm);
+		struct shash_desc *desc = *descp;
 		void *data;
 
 		desc->flags = hdesc->flags;
@@ -368,9 +374,11 @@ out:
 
 static void crypto_exit_shash_ops_compat(struct crypto_tfm *tfm)
 {
-	struct shash_desc *desc= crypto_tfm_ctx(tfm);
+	struct shash_desc **descp = crypto_tfm_ctx(tfm);
+	struct shash_desc *desc = *descp;
 
 	crypto_free_shash(desc->tfm);
+	kzfree(desc);
 }
 
 static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
@@ -378,8 +386,9 @@ static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
 	struct hash_tfm *crt = &tfm->crt_hash;
 	struct crypto_alg *calg = tfm->__crt_alg;
 	struct shash_alg *alg = __crypto_shash_alg(calg);
-	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct shash_desc **descp = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
+	struct shash_desc *desc;
 
 	if (!crypto_mod_get(calg))
 		return -EAGAIN;
@@ -390,6 +399,14 @@ static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
 		return PTR_ERR(shash);
 	}
 
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(shash),
+		       GFP_KERNEL);
+	if (!desc) {
+		crypto_free_shash(shash);
+		return -ENOMEM;
+	}
+
+	*descp = desc;
 	desc->tfm = shash;
 	tfm->exit = crypto_exit_shash_ops_compat;
 
@@ -419,11 +436,9 @@ static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 					 u32 mask)
 {
-	struct shash_alg *salg = __crypto_shash_alg(alg);
-
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_HASH_MASK:
-		return sizeof(struct shash_desc) + salg->descsize;
+		return sizeof(struct shash_desc *);
 	case CRYPTO_ALG_TYPE_AHASH_MASK:
 		return sizeof(struct crypto_shash *);
 	}
@@ -434,6 +449,9 @@ static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
 				 const struct crypto_type *frontend)
 {
+	struct crypto_shash *hash = __crypto_shash_cast(tfm);
+
+	hash->descsize = crypto_shash_alg(hash)->descsize;
 	return 0;
 }
 
@@ -452,7 +470,6 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "type         : shash\n");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
-	seq_printf(m, "descsize     : %u\n", salg->descsize);
 }
 
 static const struct crypto_type crypto_shash_type = {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f74214a..fcc02d9 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -48,6 +48,7 @@ struct crypto_ahash {
 };
 
 struct crypto_shash {
+	unsigned int descsize;
 	struct crypto_tfm base;
 };
 
@@ -275,7 +276,7 @@ static inline void crypto_shash_clear_flags(struct crypto_shash *tfm, u32 flags)
 
 static inline unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
 {
-	return crypto_shash_alg(tfm)->descsize;
+	return tfm->descsize;
 }
 
 static inline void *shash_desc_ctx(struct shash_desc *desc)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 069b93e..2d1b10f 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -135,7 +135,7 @@ static inline void *crypto_shash_ctx_aligned(struct crypto_shash *tfm)
 
 static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 {
-	return (struct crypto_shash *)tfm;
+	return container_of(tfm, struct crypto_shash, base);
 }
 
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
