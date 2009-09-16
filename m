From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/3] add RNG api calls to set common flags
Date: Wed, 16 Sep 2009 12:11:16 -0400
Message-ID: <20090916161116.GD11163@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jarod@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43870 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbZIPQLU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 12:11:20 -0400
Content-Disposition: inline
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

patch 1/3: Add flags infrastructure to rng api

This patch adds api calls for get/set flags calls to the crypto rng api. This
api allows algorithm implementations to register calls to respond to flag
settings that are global and common to all rng's.  If a given algorithm has no
external flags that it needs to respond to, it can opt to not register any
calls, and as a result a default handler will be registered for each which
universally returns EOPNOTSUPPORT.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 crypto/rng.c           |   13 +++++++++++++
 include/crypto/rng.h   |   21 +++++++++++++++++++++
 include/linux/crypto.h |    9 +++++++++
 3 files changed, 43 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index ba05e73..98f10b1 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -46,6 +46,17 @@ static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return err;
 }
 
+static int rngapi_set_flags(struct crypto_rng *tfm, u8 flags)
+{
+	return -EOPNOTSUPP;
+}
+  
+static int rngapi_get_flags(struct crypto_rng *tfm, u8 *flags)
+{
+	return -EOPNOTSUPP;
+}
+  
+
 static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
@@ -53,6 +64,8 @@ static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 
 	ops->rng_gen_random = alg->rng_make_random;
 	ops->rng_reset = rngapi_reset;
+	ops->rng_set_flags = alg->rng_set_flags ? : rngapi_set_flags;
+	ops->rng_get_flags = alg->rng_get_flags ? : rngapi_get_flags;
 
 	return 0;
 }
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index c93f9b9..a639955 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -15,6 +15,17 @@
 
 #include <linux/crypto.h>
 
+/*
+ * RNG behavioral flags
+ * CRYPTO_RNG_TEST_MODE
+ *   places the RNG into a test mode for various certification tests.  Some
+ *   RNG's (most notably Deterministic RNGs) Can have internal tests which are 
+ *   required in normal operation mode, but affect the deterministic output 
+ *   of the RNG which throws some test vectors off, as they may not account for
+ *   these tests.  This flag allows us to disable the internal tests of an RNG.
+ */
+#define CRYPTO_RNG_TEST_MODE  0x01
+
 extern struct crypto_rng *crypto_default_rng;
 
 int crypto_get_default_rng(void);
@@ -72,4 +83,14 @@ static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 	return crypto_rng_alg(tfm)->seedsize;
 }
 
+static inline int crypto_rng_set_flags(struct crypto_rng *tfm, u8 flags)
+{
+	return crypto_rng_alg(tfm)->rng_set_flags(tfm, flags);
+}
+
+static inline int crypto_rng_get_flags(struct crypto_rng *tfm, u8 *flags)
+{
+	return crypto_rng_alg(tfm)->rng_get_flags(tfm, flags);
+}
+
 #endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fd92988..6af8d2f 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -285,6 +285,10 @@ struct rng_alg {
 			       unsigned int dlen);
 	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
 
+	int (*rng_set_flags)(struct crypto_rng *tfm, u8 flags);
+ 
+	int (*rng_get_flags)(struct crypto_rng *tfm, u8 *flags);
+
 	unsigned int seedsize;
 };
 
@@ -421,6 +425,11 @@ struct rng_tfm {
 	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
 			      unsigned int dlen);
 	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
+
+	int (*rng_set_flags)(struct crypto_rng *tfm, u8 flags);
+ 
+	int (*rng_get_flags)(struct crypto_rng *tfm, u8 *flags);
+ 
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
