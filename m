From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/15] crypto: rng - Add multiple algorithm registration interface
Date: Mon, 20 Apr 2015 13:39:09 +0800
Message-ID: <E1Yk4QH-0004qp-Nt@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41148 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbDTFjN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:13 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QI-0003EE-H5
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:10 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helpers that allow the registration and removal
of multiple RNG algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c                  |   29 +++++++++++++++++++++++++++++
 include/crypto/internal/rng.h |    2 ++
 2 files changed, 31 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index a1a5533..e8d175d 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -233,5 +233,34 @@ void crypto_unregister_rng(struct rng_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rng);
 
+int crypto_register_rngs(struct rng_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_rng(algs + i);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_rng(algs + i);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_rngs);
+
+void crypto_unregister_rngs(struct rng_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_rng(algs + i);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index 93d41bc..2c9a865 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -20,6 +20,8 @@ extern const struct crypto_type crypto_rng_type;
 
 int crypto_register_rng(struct rng_alg *alg);
 void crypto_unregister_rng(struct rng_alg *alg);
+int crypto_register_rngs(struct rng_alg *algs, int count);
+void crypto_unregister_rngs(struct rng_alg *algs, int count);
 
 static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 {
