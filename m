From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] crypto: rng - Do not free default RNG when it becomes unused
Date: Sun, 21 Jun 2015 19:11:43 +0800
Message-ID: <E1Z6dA7-0007ph-7C@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47085 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbFULLq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dA7-0000Ep-IG
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:43 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently we free the default RNG when its use count hits zero.
This was OK when the IV generators would latch onto the RNG at
instance creation time and keep it until the instance is torn
down.

Now that IV generators only keep the RNG reference during init
time this scheme causes the default RNG to come and go at a high
frequencey.  This is highly undesirable as we want to keep a single
RNG in use unless the admin wants it to be removed.

This patch changes the scheme so that the system RNG once allocated
is never removed unless a specifically requested.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c                  |   27 +++++++++++++++++++++++----
 include/crypto/internal/rng.h |    9 +++++++++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 1315505..b81cffb 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -155,14 +155,33 @@ EXPORT_SYMBOL_GPL(crypto_get_default_rng);
 void crypto_put_default_rng(void)
 {
 	mutex_lock(&crypto_default_rng_lock);
-	if (!--crypto_default_rng_refcnt) {
-		crypto_free_rng(crypto_default_rng);
-		crypto_default_rng = NULL;
-	}
+	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
 EXPORT_SYMBOL_GPL(crypto_put_default_rng);
 
+#if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
+int crypto_del_default_rng(void)
+{
+	int err = -EBUSY;
+
+	mutex_lock(&crypto_default_rng_lock);
+	if (crypto_default_rng_refcnt)
+		goto out;
+
+	crypto_free_rng(crypto_default_rng);
+	crypto_default_rng = NULL;
+
+	err = 0;
+
+out:
+	mutex_unlock(&crypto_default_rng_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_del_default_rng);
+#endif
+
 int crypto_register_rng(struct rng_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index 263f1a5..a52ef34 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -22,6 +22,15 @@ void crypto_unregister_rng(struct rng_alg *alg);
 int crypto_register_rngs(struct rng_alg *algs, int count);
 void crypto_unregister_rngs(struct rng_alg *algs, int count);
 
+#if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
+int crypto_del_default_rng(void);
+#else
+static inline int crypto_del_default_rng(void)
+{
+	return 0;
+}
+#endif
+
 static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
