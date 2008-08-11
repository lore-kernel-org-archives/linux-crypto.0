From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: expand crypto lib api to include rng allocation
Date: Mon, 11 Aug 2008 09:37:37 -0400
Message-ID: <20080811133737.GA6225@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3384 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYHKNhx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2008 09:37:53 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey-
	Patch to expand the linux crypto api to allow for the registration and
allocation of various random number generators.  Tested successfully by me.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 crypto/Makefile         |    2 -
 crypto/prng.c           |   94 ++++++++++++++++++++++++++++++++++++++----------
 crypto/rngapi.c         |   77 +++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h |    1 
 include/crypto/rng.h    |   63 ++++++++++++++++++++++++++++++++
 include/linux/crypto.h  |   28 +++++++++++++-
 6 files changed, 244 insertions(+), 21 deletions(-)


diff --git a/crypto/Makefile b/crypto/Makefile
index 74dc264..4800a9d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-objs := api.o cipher.o digest.o compress.o
+crypto-objs := api.o cipher.o digest.o compress.o rngapi.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
diff --git a/crypto/prng.c b/crypto/prng.c
index d860a3a..b203093 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -21,17 +21,16 @@
 #include <linux/fs.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
 #include <linux/highmem.h>
 #include <linux/moduleparam.h>
 #include <linux/jiffies.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
+#include <crypto/rng.h>
+#include <crypto/algapi.h>
 #include "prng.h"
 
-#define TEST_PRNG_ON_START 0
-
 #define DEFAULT_PRNG_KEY "0123456789abcdef"
 #define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
@@ -360,31 +359,90 @@ out:
 }
 EXPORT_SYMBOL_GPL(reset_prng_context);
 
-/* Module initalization */
-static int __init prng_mod_init(void)
+ static int cprng_init(struct crypto_tfm *tfm)
 {
+	struct rng_tfm *ctx = crypto_rng_crt(crypto_rng_cast(tfm));
 
-#if TEST_PRNG_ON_START
-	int i;
-	unsigned char tmpbuf[DEFAULT_BLK_SZ];
+	ctx->ctx_data = alloc_prng_context();
+
+	if (!ctx->ctx_data)
+		return -ENOMEM;
+
+	/*
+	 * This tells useers how much data to pass in for
+	 * reseeding when calling rng_reset
+	 */
+	ctx->seedsize = DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ;
+
+	return 0;
+}
+
+static void cprng_exit(struct crypto_tfm *tfm)
+{
+	struct rng_tfm *ctx = crypto_rng_crt(crypto_rng_cast(tfm));
+
+	if (ctx->ctx_data)
+		free_prng_context(ctx->ctx_data);
+}
+
+ static int cprng_get_random(struct crypto_tfm *tfm, u8 *rdata,
+				unsigned int dlen)
+{
+	struct rng_tfm *ctx = crypto_rng_crt(crypto_rng_cast(tfm));
+	struct prng_context *prng = ctx->ctx_data;
+
+	return get_prng_bytes(rdata, dlen, prng);
+}
 
-	struct prng_context *ctx = alloc_prng_context();
-	if (ctx == NULL)
+static int cprng_reset(struct crypto_tfm *tfm,
+		u8 *seed, unsigned int slen)
+{
+	struct rng_tfm *ctx = crypto_rng_crt(crypto_rng_cast(tfm));
+	struct prng_context *prng = ctx->ctx_data;
+	u8 *key = seed + DEFAULT_PRNG_KSZ;
+
+	if (slen < ctx->seedsize)
+		return -EINVAL;
+
+	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, NULL);
+
+	if (prng->flags & PRNG_NEED_RESET)
 		return -EFAULT;
-	for (i = 0; i < 512; i++) {
-		if (get_prng_bytes(tmpbuf, DEFAULT_BLK_SZ, ctx) < 0) {
-			free_prng_context(ctx);
-			return -EFAULT;
-		}
-	}
-	free_prng_context(ctx);
-#endif
+	return 0;
+}
+
+static struct crypto_alg rng_alg = {
+	.cra_name               = "ansi_cprng",
+	.cra_priority           = 100,
+	.cra_flags              = CRYPTO_ALG_TYPE_RNG,
+	.cra_ctxsize            = 0,
+	.cra_type		= &crypto_rng_type,
+	.cra_module             = THIS_MODULE,
+	.cra_list               = LIST_HEAD_INIT(rng_alg.cra_list),
+	.cra_init               = cprng_init,
+	.cra_exit               = cprng_exit,
+	.cra_u                  = { .rng = {
+	.rng_make_random        = cprng_get_random,
+	.rng_reset		= cprng_reset } }
 
+};
+
+
+/* Module initalization */
+static int __init prng_mod_init(void)
+{
+	int ret = 0;
+	ret = crypto_register_alg(&rng_alg);
+
+	if (ret)
+		goto out;
+out:
 	return 0;
 }
 
 static void __exit prng_mod_fini(void)
 {
+	crypto_unregister_alg(&rng_alg);
 	return;
 }
 
diff --git a/crypto/rngapi.c b/crypto/rngapi.c
new file mode 100644
index 0000000..fc26bbd
--- /dev/null
+++ b/crypto/rngapi.c
@@ -0,0 +1,77 @@
+/*
+ * Cryptographic API.
+ *
+ * RNG operations.
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <linux/types.h>
+#include <crypto/rng.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include "internal.h"
+
+static int crypto_gen_rng_data(struct crypto_tfm *tfm,
+				u8 *rdata, unsigned int dlen)
+{
+	return tfm->__crt_alg->cra_rng.rng_make_random(tfm, rdata, dlen);
+}
+
+static int crypto_rng_reset(struct crypto_tfm *tfm,
+			u8 *seed, unsigned int slen)
+{
+	if (!tfm->__crt_alg->cra_rng.rng_reset)
+		return -ENOTSUPP;
+
+	return tfm->__crt_alg->cra_rng.rng_reset(tfm, seed, slen);
+}
+
+static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct rng_tfm *ops = &tfm->crt_rng;
+
+	ops->rng_gen_random = crypto_gen_rng_data;
+	ops->rng_reset = crypto_rng_reset;
+
+	return 0;
+}
+
+static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_printf(m, "type         : rng\n");
+}
+
+static unsigned int crypto_rng_ctxsize(struct crypto_alg *alg, u32 type,
+					u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+const struct crypto_type crypto_rng_type = {
+	.ctxsize = crypto_rng_ctxsize,
+	.init = crypto_init_rng_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_rng_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_rng_type);
+
+
+struct crypto_rng *crypto_alloc_rng(const char *alg_name)
+{
+	u32 type, mask;
+
+	mask = CRYPTO_ALG_TYPE_MASK;
+	type = CRYPTO_ALG_TYPE_RNG;
+
+	return __crypto_rng_cast(crypto_alloc_base(alg_name, type, mask));
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_rng);
+
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 60d06e7..8ce33ea 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -98,6 +98,7 @@ extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
+extern const struct crypto_type crypto_rng_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
new file mode 100644
index 0000000..a1fca87
--- /dev/null
+++ b/include/crypto/rng.h
@@ -0,0 +1,63 @@
+/*
+ * RNG: Random Number Generator  algorithms under the crypto API
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_RNG_H
+#define _CRYPTO_RNG_H
+
+#include <linux/crypto.h>
+
+struct crypto_rng *crypto_alloc_rng(const char *alg_name);
+
+static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_rng *)tfm;
+}
+
+static inline struct crypto_rng *crypto_rng_cast(struct crypto_tfm *tfm)
+{
+	BUG_ON((crypto_tfm_alg_type(tfm) ^ CRYPTO_ALG_TYPE_RNG) &
+	       CRYPTO_ALG_TYPE_MASK);
+	return __crypto_rng_cast(tfm);
+}
+
+struct crypto_rng *crypto_alloc_rng(const char *alg_name);
+
+static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
+{
+	return &tfm->base;
+}
+
+static inline struct rng_tfm *crypto_rng_crt(struct crypto_rng *tfm)
+{
+	return &crypto_rng_tfm(tfm)->crt_rng;
+}
+
+static inline void crypto_free_rng(struct crypto_rng *tfm)
+{
+	crypto_free_tfm(crypto_rng_tfm(tfm));
+}
+
+static inline int crypto_get_random_bytes(struct crypto_rng *tfm,
+					  u8 *rdata, unsigned int dlen)
+{
+	return crypto_rng_crt(tfm)->rng_gen_random(crypto_rng_tfm(tfm),
+						rdata, dlen);
+}
+
+static inline int crypto_reset_rng(struct crypto_rng *tfm,
+				u8 *seed, unsigned int slen)
+{
+	return crypto_rng_crt(tfm)->rng_reset(crypto_rng_tfm(tfm),
+					seed, slen);
+}
+
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 81d994a..598894f 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -38,7 +38,7 @@
 #define CRYPTO_ALG_TYPE_DIGEST		0x00000008
 #define CRYPTO_ALG_TYPE_HASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
-
+#define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
@@ -298,6 +298,14 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+struct rng_alg {
+	int (*rng_make_random)(struct crypto_tfm *tfm, u8 *rdata,
+			unsigned int dlen);
+	int (*rng_reset)(struct crypto_tfm *tfm, u8 *seed,
+			unsigned int slen);
+};
+
+
 #define cra_ablkcipher	cra_u.ablkcipher
 #define cra_aead	cra_u.aead
 #define cra_blkcipher	cra_u.blkcipher
@@ -306,6 +314,7 @@ struct compress_alg {
 #define cra_hash	cra_u.hash
 #define cra_ahash	cra_u.ahash
 #define cra_compress	cra_u.compress
+#define cra_rng		cra_u.rng
 
 struct crypto_alg {
 	struct list_head cra_list;
@@ -333,6 +342,7 @@ struct crypto_alg {
 		struct hash_alg hash;
 		struct ahash_alg ahash;
 		struct compress_alg compress;
+		struct rng_alg rng;
 	} cra_u;
 
 	int (*cra_init)(struct crypto_tfm *tfm);
@@ -438,6 +448,15 @@ struct compress_tfm {
 	                      u8 *dst, unsigned int *dlen);
 };
 
+struct rng_tfm {
+	int (*rng_gen_random)(struct crypto_tfm *tfm, u8 *rdata,
+				unsigned int dlen);
+	int (*rng_reset)(struct crypto_tfm *tfm, u8 *seed,
+			unsigned int slen);
+	void *ctx_data;
+	size_t seedsize;
+};
+
 #define crt_ablkcipher	crt_u.ablkcipher
 #define crt_aead	crt_u.aead
 #define crt_blkcipher	crt_u.blkcipher
@@ -445,6 +464,7 @@ struct compress_tfm {
 #define crt_hash	crt_u.hash
 #define crt_ahash	crt_u.ahash
 #define crt_compress	crt_u.compress
+#define crt_rng		crt_u.rng
 
 struct crypto_tfm {
 
@@ -458,6 +478,7 @@ struct crypto_tfm {
 		struct hash_tfm hash;
 		struct ahash_tfm ahash;
 		struct compress_tfm compress;
+		struct rng_tfm rng;
 	} crt_u;
 	
 	struct crypto_alg *__crt_alg;
@@ -489,6 +510,10 @@ struct crypto_hash {
 	struct crypto_tfm base;
 };
 
+struct crypto_rng {
+	struct crypto_tfm base;
+};
+
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
@@ -1313,6 +1338,5 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 	return crypto_comp_crt(tfm)->cot_decompress(crypto_comp_tfm(tfm),
 						    src, slen, dst, dlen);
 }
