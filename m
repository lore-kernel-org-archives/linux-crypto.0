From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/7] [CRYPTO] api: Add crypto_comp and crypto_has_*
Date: Sat, 02 Sep 2006 21:06:50 +1000
Message-ID: <E1GJTKs-0001Fi-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43024 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751060AbWIBLGr
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:47 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add crypto_comp and crypto_has_*

This patch adds the crypto_comp type to complete the compile-time checking
conversion.  The functions crypto_has_alg and crypto_has_cipher, etc. are
also added to replace crypto_alg_available.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c           |   14 +++++++
 include/linux/crypto.h |   90 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -482,3 +482,17 @@ int crypto_alg_available(const char *nam
 EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 EXPORT_SYMBOL_GPL(crypto_free_tfm);
 EXPORT_SYMBOL_GPL(crypto_alg_available);
+
+int crypto_has_alg(const char *name, u32 type, u32 mask)
+{
+	int ret = 0;
+	struct crypto_alg *alg = crypto_alg_mod_lookup(name, type, mask);
+	
+	if (!IS_ERR(alg)) {
+		crypto_mod_put(alg);
+		ret = 1;
+	}
+	
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_has_alg);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -236,11 +236,17 @@ int crypto_unregister_alg(struct crypto_
  */
 #ifdef CONFIG_CRYPTO
 int crypto_alg_available(const char *name, u32 flags);
+int crypto_has_alg(const char *name, u32 type, u32 mask);
 #else
 static inline int crypto_alg_available(const char *name, u32 flags)
 {
 	return 0;
 }
+
+static inline int crypto_has_alg(const char *name, u32 type, u32 mask)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -329,6 +335,7 @@ struct crypto_tfm {
 };
 
 #define crypto_cipher crypto_tfm
+#define crypto_comp crypto_tfm
 
 struct crypto_blkcipher {
 	struct crypto_tfm base;
@@ -485,6 +492,15 @@ static inline void crypto_free_blkcipher
 	crypto_free_tfm(crypto_blkcipher_tfm(tfm));
 }
 
+static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
 static inline const char *crypto_blkcipher_name(struct crypto_blkcipher *tfm)
 {
 	return crypto_tfm_alg_name(crypto_blkcipher_tfm(tfm));
@@ -620,6 +636,15 @@ static inline void crypto_free_cipher(st
 	crypto_free_tfm(crypto_cipher_tfm(tfm));
 }
 
+static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
 static inline struct cipher_tfm *crypto_cipher_crt(struct crypto_cipher *tfm)
 {
 	return &crypto_cipher_tfm(tfm)->crt_cipher;
@@ -718,6 +743,15 @@ static inline void crypto_free_hash(stru
 	crypto_free_tfm(crypto_hash_tfm(tfm));
 }
 
+static inline int crypto_has_hash(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_HASH;
+	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
 static inline struct hash_tfm *crypto_hash_crt(struct crypto_hash *tfm)
 {
 	return &crypto_hash_tfm(tfm)->crt_hash;
@@ -853,20 +887,64 @@ static inline void crypto_cipher_get_iv(
 	memcpy(dst, tfm->crt_cipher.cit_iv, len);
 }
 
-static inline int crypto_comp_compress(struct crypto_tfm *tfm,
+static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_comp *)tfm;
+}
+
+static inline struct crypto_comp *crypto_comp_cast(struct crypto_tfm *tfm)
+{
+	BUG_ON((crypto_tfm_alg_type(tfm) ^ CRYPTO_ALG_TYPE_COMPRESS) &
+	       CRYPTO_ALG_TYPE_MASK);
+	return __crypto_comp_cast(tfm);
+}
+
+static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
+						    u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_COMPRESS;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_comp_tfm(struct crypto_comp *tfm)
+{
+	return tfm;
+}
+
+static inline void crypto_free_comp(struct crypto_comp *tfm)
+{
+	crypto_free_tfm(crypto_comp_tfm(tfm));
+}
+
+static inline int crypto_has_comp(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_COMPRESS;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
+static inline struct compress_tfm *crypto_comp_crt(struct crypto_comp *tfm)
+{
+	return &crypto_comp_tfm(tfm)->crt_compress;
+}
+
+static inline int crypto_comp_compress(struct crypto_comp *tfm,
                                        const u8 *src, unsigned int slen,
                                        u8 *dst, unsigned int *dlen)
 {
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_COMPRESS);
-	return tfm->crt_compress.cot_compress(tfm, src, slen, dst, dlen);
+	return crypto_comp_crt(tfm)->cot_compress(tfm, src, slen, dst, dlen);
 }
 
-static inline int crypto_comp_decompress(struct crypto_tfm *tfm,
+static inline int crypto_comp_decompress(struct crypto_comp *tfm,
                                          const u8 *src, unsigned int slen,
                                          u8 *dst, unsigned int *dlen)
 {
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_COMPRESS);
-	return tfm->crt_compress.cot_decompress(tfm, src, slen, dst, dlen);
+	return crypto_comp_crt(tfm)->cot_decompress(tfm, src, slen, dst, dlen);
 }
 
 #endif	/* _LINUX_CRYPTO_H */

-- 
VGER BF report: H 0
