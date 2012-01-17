From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] crypto: Add bulk algorithm registration interface
Date: Tue, 17 Jan 2012 23:34:26 +0000
Message-ID: <1326843266-16782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Cc: linux-crypto@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49536 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229Ab2AQXei (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jan 2012 18:34:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hardware crypto engines frequently need to register a selection of
different algorithms with the core. Simplify their code slightly,
especially the error handling, by providing functions to register a
number of algorithms in a single call.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 crypto/algapi.c        |   35 +++++++++++++++++++++++++++++++++++
 include/linux/crypto.h |    2 ++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9d4a9fe..056571b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -405,6 +405,41 @@ int crypto_unregister_alg(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_alg);
 
+int crypto_register_algs(struct crypto_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_alg(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_alg(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_algs);
+
+int crypto_unregister_algs(struct crypto_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_unregister_alg(&algs[i]);
+		if (ret)
+			pr_err("Failed to unregister %s %s: %d\n",
+			       algs[i].cra_driver_name, algs[i].cra_name, ret);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_algs);
+
 int crypto_register_template(struct crypto_template *tmpl)
 {
 	struct crypto_template *q;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a8fa654..48ce547 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -314,6 +314,8 @@ struct crypto_alg {
  */
 int crypto_register_alg(struct crypto_alg *alg);
 int crypto_unregister_alg(struct crypto_alg *alg);
+int crypto_register_algs(struct crypto_alg *algs, int count);
+int crypto_unregister_algs(struct crypto_alg *algs, int count);
 
 /*
  * Algorithm query interface.
-- 
1.7.7.3
