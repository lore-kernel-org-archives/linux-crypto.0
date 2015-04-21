From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/11] crypto: rng - Add crypto_rng_set_entropy
Date: Tue, 21 Apr 2015 10:46:39 +0800
Message-ID: <E1YkOCt-0007K6-LM@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33086 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbDUCqm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the function crypto_rng_set_entropy.  It is only
meant to be used by testmgr when testing RNG implementations by
providing fixed entropy data in order to verify test vectors.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/rng.h |    6 ++++++
 include/crypto/rng.h          |    4 ++++
 2 files changed, 10 insertions(+)

diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index 76f3c95..93d41bc 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -26,4 +26,10 @@ static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline void crypto_rng_set_entropy(struct crypto_rng *tfm,
+					  const u8 *data, unsigned int len)
+{
+	crypto_rng_alg(tfm)->set_ent(tfm, data, len);
+}
+
 #endif
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 133f044..cc22e52 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -32,6 +32,8 @@ struct crypto_rng;
  *		up a new state, the seed must be provided by the
  *		consumer while invoking this function. The required
  *		size of the seed is defined with @seedsize .
+ * @set_ent:	Set entropy that would otherwise be obtained from
+ *		entropy source.  Internal use only.
  * @seedsize:	The seed size required for a random number generator
  *		initialization defined with this variable. Some
  *		random number generators does not require a seed
@@ -45,6 +47,8 @@ struct rng_alg {
 			const u8 *src, unsigned int slen,
 			u8 *dst, unsigned int dlen);
 	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
+	void (*set_ent)(struct crypto_rng *tfm, const u8 *data,
+			unsigned int len);
 
 	unsigned int seedsize;
 
