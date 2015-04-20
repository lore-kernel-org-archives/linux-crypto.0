From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/15] crypto: rng - Introduce crypto_rng_generate
Date: Mon, 20 Apr 2015 13:39:04 +0800
Message-ID: <E1Yk4QC-0004pj-MV@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44471 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbbDTFjH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QC-0003Cp-Tm
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:05 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the new top-level function crypto_rng_generate
which generates random numbers with additional input.  It also
extends the mid-level rng_gen_random function to take additional
data as input.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c         |    9 +++++++--
 include/crypto/rng.h |   27 +++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 87fa2f4..4514d37 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -36,6 +36,12 @@ static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_rng, base);
 }
 
+static int generate(struct crypto_rng *tfm, const u8 *src, unsigned int slen,
+		    u8 *dst, unsigned int dlen)
+{
+	return crypto_rng_alg(tfm)->rng_make_random(tfm, dst, dlen);
+}
+
 static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
@@ -59,9 +65,8 @@ static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_rng *rng = __crypto_rng_cast(tfm);
-	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
 
-	rng->generate = alg->rng_make_random;
+	rng->generate = generate;
 	rng->seed = rngapi_reset;
 
 	return 0;
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index f13f3fa..f20f068 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -16,7 +16,9 @@
 #include <linux/crypto.h>
 
 struct crypto_rng {
-	int (*generate)(struct crypto_rng *tfm, u8 *rdata, unsigned int dlen);
+	int (*generate)(struct crypto_rng *tfm,
+			const u8 *src, unsigned int slen,
+			u8 *dst, unsigned int dlen);
 	int (*seed)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
 	struct crypto_tfm base;
 };
@@ -83,6 +85,27 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 }
 
 /**
+ * crypto_rng_generate() - get random number
+ * @tfm: cipher handle
+ * @src: Input buffer holding additional data, may be NULL
+ * @slen: Length of additional data
+ * @dst: output buffer holding the random numbers
+ * @dlen: length of the output buffer
+ *
+ * This function fills the caller-allocated buffer with random
+ * numbers using the random number generator referenced by the
+ * cipher handle.
+ *
+ * Return: 0 function was successful; < 0 if an error occurred
+ */
+static inline int crypto_rng_generate(struct crypto_rng *tfm,
+				      const u8 *src, unsigned int slen,
+				      u8 *dst, unsigned int dlen)
+{
+	return tfm->generate(tfm, src, slen, dst, dlen);
+}
+
+/**
  * crypto_rng_get_bytes() - get random number
  * @tfm: cipher handle
  * @rdata: output buffer holding the random numbers
@@ -96,7 +119,7 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
 				       u8 *rdata, unsigned int dlen)
 {
-	return tfm->generate(tfm, rdata, dlen);
+	return crypto_rng_generate(tfm, NULL, 0, rdata, dlen);
 }
 
 /**
