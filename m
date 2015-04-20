From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/15] crypto: rng - Convert crypto_rng to new style crypto_type
Date: Mon, 20 Apr 2015 13:39:03 +0800
Message-ID: <E1Yk4QB-0004pS-H8@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33426 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbDTFjG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QB-0003Ch-Rd
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the top-level crypto_rng to the "new" style.
It was the last algorithm type added before we switched over
to the new way of doing things exemplified by shash.

All users will automatically switch over to the new interface.

Note that this patch does not touch the low-level interface to
rng implementations.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c           |   35 +++++++++++++++++++++++------------
 include/crypto/rng.h   |   32 ++++++++++----------------------
 include/linux/crypto.h |   12 ------------
 3 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index e0a25c2..87fa2f4 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -24,11 +24,18 @@
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
 
+#include "internal.h"
+
 static DEFINE_MUTEX(crypto_default_rng_lock);
 struct crypto_rng *crypto_default_rng;
 EXPORT_SYMBOL_GPL(crypto_default_rng);
 static int crypto_default_rng_refcnt;
 
+static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_rng, base);
+}
+
 static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
@@ -49,13 +56,13 @@ static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return err;
 }
 
-static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_rng *rng = __crypto_rng_cast(tfm);
 	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
-	struct rng_tfm *ops = &tfm->crt_rng;
 
-	ops->rng_gen_random = alg->rng_make_random;
-	ops->rng_reset = rngapi_reset;
+	rng->generate = alg->rng_make_random;
+	rng->seed = rngapi_reset;
 
 	return 0;
 }
@@ -92,22 +99,26 @@ static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "seedsize     : %u\n", alg->cra_rng.seedsize);
 }
 
-static unsigned int crypto_rng_ctxsize(struct crypto_alg *alg, u32 type,
-				       u32 mask)
-{
-	return alg->cra_ctxsize;
-}
-
 const struct crypto_type crypto_rng_type = {
-	.ctxsize = crypto_rng_ctxsize,
-	.init = crypto_init_rng_ops,
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_rng_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_rng_show,
 #endif
 	.report = crypto_rng_report,
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_RNG,
+	.tfmsize = offsetof(struct crypto_rng, base),
 };
 EXPORT_SYMBOL_GPL(crypto_rng_type);
 
+struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_rng_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_rng);
+
 int crypto_get_default_rng(void)
 {
 	struct crypto_rng *rng;
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 6e28ea5..f13f3fa 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -15,6 +15,12 @@
 
 #include <linux/crypto.h>
 
+struct crypto_rng {
+	int (*generate)(struct crypto_rng *tfm, u8 *rdata, unsigned int dlen);
+	int (*seed)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
+	struct crypto_tfm base;
+};
+
 extern struct crypto_rng *crypto_default_rng;
 
 int crypto_get_default_rng(void);
@@ -27,11 +33,6 @@ void crypto_put_default_rng(void);
  * CRYPTO_ALG_TYPE_RNG (listed as type "rng" in /proc/crypto)
  */
 
-static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_rng *)tfm;
-}
-
 /**
  * crypto_alloc_rng() -- allocate RNG handle
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -52,15 +53,7 @@ static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-static inline struct crypto_rng *crypto_alloc_rng(const char *alg_name,
-						  u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_RNG;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_rng_cast(crypto_alloc_base(alg_name, type, mask));
-}
+struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
 {
@@ -80,18 +73,13 @@ static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 	return &crypto_rng_tfm(tfm)->__crt_alg->cra_rng;
 }
 
-static inline struct rng_tfm *crypto_rng_crt(struct crypto_rng *tfm)
-{
-	return &crypto_rng_tfm(tfm)->crt_rng;
-}
-
 /**
  * crypto_free_rng() - zeroize and free RNG handle
  * @tfm: cipher handle to be freed
  */
 static inline void crypto_free_rng(struct crypto_rng *tfm)
 {
-	crypto_free_tfm(crypto_rng_tfm(tfm));
+	crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
 }
 
 /**
@@ -108,7 +96,7 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
 				       u8 *rdata, unsigned int dlen)
 {
-	return crypto_rng_crt(tfm)->rng_gen_random(tfm, rdata, dlen);
+	return tfm->generate(tfm, rdata, dlen);
 }
 
 /**
@@ -131,7 +119,7 @@ static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
 static inline int crypto_rng_reset(struct crypto_rng *tfm,
 				   u8 *seed, unsigned int slen)
 {
-	return crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
+	return tfm->seed(tfm, seed, slen);
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 10df5d2..781f7d5 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -655,19 +655,12 @@ struct compress_tfm {
 	                      u8 *dst, unsigned int *dlen);
 };
 
-struct rng_tfm {
-	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
-			      unsigned int dlen);
-	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
-};
-
 #define crt_ablkcipher	crt_u.ablkcipher
 #define crt_aead	crt_u.aead
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
 #define crt_compress	crt_u.compress
-#define crt_rng		crt_u.rng
 
 struct crypto_tfm {
 
@@ -680,7 +673,6 @@ struct crypto_tfm {
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
 		struct compress_tfm compress;
-		struct rng_tfm rng;
 	} crt_u;
 
 	void (*exit)(struct crypto_tfm *tfm);
@@ -714,10 +706,6 @@ struct crypto_hash {
 	struct crypto_tfm base;
 };
 
-struct crypto_rng {
-	struct crypto_tfm base;
-};
-
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
