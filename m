From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 4/11] crypto: rng - Add multiple algorithm registration interface
Date: Tue, 21 Apr 2015 10:46:40 +0800
Message-ID: <E1YkOCu-0007KN-Pu@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48340 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbDUCqo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:44 -0400
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
index 5e0425a..e98ce1c 100644
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
