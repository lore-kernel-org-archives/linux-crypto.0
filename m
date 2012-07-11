From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/14] crypto: add crypto_[un]register_shashes for
 [un]registering multiple shash entries at once
Date: Wed, 11 Jul 2012 14:20:20 +0300
Message-ID: <20120711112020.6875.55703.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40717 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2GKLUX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:23 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add crypto_[un]register_shashes() to allow simplifying init/exit code of shash
crypto modules that register multiple algorithms.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/shash.c                 |   36 ++++++++++++++++++++++++++++++++++++
 include/crypto/internal/hash.h |    2 ++
 2 files changed, 38 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 32067f4..f426330f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -629,6 +629,42 @@ int crypto_unregister_shash(struct shash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_shash);
 
+int crypto_register_shashes(struct shash_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_shash(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_shash(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_shashes);
+
+int crypto_unregister_shashes(struct shash_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = count - 1; i >= 0; --i) {
+		ret = crypto_unregister_shash(&algs[i]);
+		if (ret)
+			pr_err("Failed to unregister %s %s: %d\n",
+			       algs[i].base.cra_driver_name,
+			       algs[i].base.cra_name, ret);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_shashes);
+
 int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 5bfad8c..821eae8 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -83,6 +83,8 @@ struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
+int crypto_register_shashes(struct shash_alg *algs, int count);
+int crypto_unregister_shashes(struct shash_alg *algs, int count);
 int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst);
 void shash_free_instance(struct crypto_instance *inst);
