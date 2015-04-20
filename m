From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/15] crypto: rng - Convert low-level crypto_rng to new style
Date: Mon, 20 Apr 2015 13:39:07 +0800
Message-ID: <E1Yk4QF-0004qH-5M@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51975 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbbDTFjL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:11 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QG-0003DS-3L
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:08 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the low-level crypto_rng interface to the
"new" style.

This allows existing implementations to be converted over one-
by-one.  Once that is complete we can then remove the old rng
interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c                  |   56 +++++++++++++++++++++++++++++++++++++-----
 include/crypto/internal/rng.h |    3 ++
 include/crypto/rng.h          |   42 ++++++++++++++++++++++++++++++-
 include/linux/crypto.h        |    6 ++--
 4 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 618fa4d..a1a5533 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -36,10 +36,15 @@ static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_rng, base);
 }
 
+static inline struct old_rng_alg *crypto_old_rng_alg(struct crypto_rng *tfm)
+{
+	return &crypto_rng_tfm(tfm)->__crt_alg->cra_rng;
+}
+
 static int generate(struct crypto_rng *tfm, const u8 *src, unsigned int slen,
 		    u8 *dst, unsigned int dlen)
 {
-	return crypto_rng_alg(tfm)->rng_make_random(tfm, dst, dlen);
+	return crypto_old_rng_alg(tfm)->rng_make_random(tfm, dst, dlen);
 }
 
 static int rngapi_reset(struct crypto_rng *tfm, const u8 *seed,
@@ -58,7 +63,7 @@ static int rngapi_reset(struct crypto_rng *tfm, const u8 *seed,
 		src = buf;
 	}
 
-	err = crypto_rng_alg(tfm)->rng_reset(tfm, src, slen);
+	err = crypto_old_rng_alg(tfm)->rng_reset(tfm, src, slen);
 
 	kfree(buf);
 	return err;
@@ -88,13 +93,31 @@ EXPORT_SYMBOL_GPL(crypto_rng_reset);
 static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_rng *rng = __crypto_rng_cast(tfm);
+	struct rng_alg *alg = crypto_rng_alg(rng);
+	struct old_rng_alg *oalg = crypto_old_rng_alg(rng);
+
+	if (oalg->rng_make_random) {
+		rng->generate = generate;
+		rng->seed = rngapi_reset;
+		rng->seedsize = oalg->seedsize;
+		return 0;
+	}
 
-	rng->generate = generate;
-	rng->seed = rngapi_reset;
+	rng->generate = alg->generate;
+	rng->seed = alg->seed;
+	rng->seedsize = alg->seedsize;
 
 	return 0;
 }
 
+static unsigned int seedsize(struct crypto_alg *alg)
+{
+	struct rng_alg *ralg = container_of(alg, struct rng_alg, base);
+
+	return alg->cra_rng.rng_make_random ?
+	       alg->cra_rng.seedsize : ralg->seedsize;
+}
+
 #ifdef CONFIG_NET
 static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -102,7 +125,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strncpy(rrng.type, "rng", sizeof(rrng.type));
 
-	rrng.seedsize = alg->cra_rng.seedsize;
+	rrng.seedsize = seedsize(alg);
 
 	if (nla_put(skb, CRYPTOCFGA_REPORT_RNG,
 		    sizeof(struct crypto_report_rng), &rrng))
@@ -124,7 +147,7 @@ static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : rng\n");
-	seq_printf(m, "seedsize     : %u\n", alg->cra_rng.seedsize);
+	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
 }
 
 const struct crypto_type crypto_rng_type = {
@@ -189,5 +212,26 @@ void crypto_put_default_rng(void)
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_rng);
 
+int crypto_register_rng(struct rng_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	if (alg->seedsize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	base->cra_type = &crypto_rng_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_rng);
+
+void crypto_unregister_rng(struct rng_alg *alg)
+{
+	crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_rng);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index 8969733..76f3c95 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -18,6 +18,9 @@
 
 extern const struct crypto_type crypto_rng_type;
 
+int crypto_register_rng(struct rng_alg *alg);
+void crypto_unregister_rng(struct rng_alg *alg);
+
 static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 7fca371..133f044 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -15,11 +15,48 @@
 
 #include <linux/crypto.h>
 
+struct crypto_rng;
+
+/**
+ * struct rng_alg - random number generator definition
+ *
+ * @generate:	The function defined by this variable obtains a
+ *		random number. The random number generator transform
+ *		must generate the random number out of the context
+ *		provided with this call, plus any additional data
+ *		if provided to the call.
+ * @seed:	Seed or reseed the random number generator.  With the
+ *		invocation of this function call, the random number
+ *		generator shall become ready fo generation.  If the
+ *		random number generator requires a seed for setting
+ *		up a new state, the seed must be provided by the
+ *		consumer while invoking this function. The required
+ *		size of the seed is defined with @seedsize .
+ * @seedsize:	The seed size required for a random number generator
+ *		initialization defined with this variable. Some
+ *		random number generators does not require a seed
+ *		as the seeding is implemented internally without
+ *		the need of support by the consumer. In this case,
+ *		the seed size is set to zero.
+ * @base:	Common crypto API algorithm data structure.
+ */
+struct rng_alg {
+	int (*generate)(struct crypto_rng *tfm,
+			const u8 *src, unsigned int slen,
+			u8 *dst, unsigned int dlen);
+	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
+
+	unsigned int seedsize;
+
+	struct crypto_alg base;
+};
+
 struct crypto_rng {
 	int (*generate)(struct crypto_rng *tfm,
 			const u8 *src, unsigned int slen,
 			u8 *dst, unsigned int dlen);
 	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
+	unsigned int seedsize;
 	struct crypto_tfm base;
 };
 
@@ -72,7 +109,8 @@ static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
  */
 static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 {
-	return &crypto_rng_tfm(tfm)->__crt_alg->cra_rng;
+	return container_of(crypto_rng_tfm(tfm)->__crt_alg,
+			    struct rng_alg, base);
 }
 
 /**
@@ -156,7 +194,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed,
  */
 static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 {
-	return crypto_rng_alg(tfm)->seedsize;
+	return tfm->seedsize;
 }
 
 #endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 781f7d5..2fa9b05 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -427,7 +427,7 @@ struct compress_alg {
 };
 
 /**
- * struct rng_alg - random number generator definition
+ * struct old_rng_alg - random number generator definition
  * @rng_make_random: The function defined by this variable obtains a random
  *		     number. The random number generator transform must generate
  *		     the random number out of the context provided with this
@@ -445,7 +445,7 @@ struct compress_alg {
  *	      seeding is implemented internally without the need of support by
  *	      the consumer. In this case, the seed size is set to zero.
  */
-struct rng_alg {
+struct old_rng_alg {
 	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
 			       unsigned int dlen);
 	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
@@ -559,7 +559,7 @@ struct crypto_alg {
 		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct compress_alg compress;
-		struct rng_alg rng;
+		struct old_rng_alg rng;
 	} cra_u;
 
 	int (*cra_init)(struct crypto_tfm *tfm);
