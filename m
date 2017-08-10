From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v4 2/4] crypto: add crypto_(un)register_ahashes()
Date: Thu, 10 Aug 2017 14:53:52 +0200
Message-ID: <01cfbf11707a9907d87c59fb47385c4178a08688.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Cc: Rabin Vincent <rabinv@axis.com>, Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1502368677.git.larper@axis.com>
In-Reply-To: <cover.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rabin Vincent <rabinv@axis.com>

There are already helpers to (un)register multiple normal
and AEAD algos.  Add one for ahashes too.

Signed-off-by: Lars Persson <larper@axis.com>
Signed-off-by: Rabin Vincent <rabinv@axis.com>
---
v4: crypto_register_skciphers was used where crypto_unregister_skciphers
    was intended.

 crypto/ahash.c                 | 29 +++++++++++++++++++++++++++++
 include/crypto/internal/hash.h |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 826cd7ab4d4a..5e8666e6ccae 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -588,6 +588,35 @@ int crypto_unregister_ahash(struct ahash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_ahash);
 
+int crypto_register_ahashes(struct ahash_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_ahash(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_ahash(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_ahashes);
+
+void crypto_unregister_ahashes(struct ahash_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_ahash(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_ahashes);
+
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index f6d9af3efa45..f0b44c16e88f 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -76,6 +76,8 @@ static inline int crypto_ahash_walk_last(struct crypto_hash_walk *walk)
 
 int crypto_register_ahash(struct ahash_alg *alg);
 int crypto_unregister_ahash(struct ahash_alg *alg);
+int crypto_register_ahashes(struct ahash_alg *algs, int count);
+void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_instance(struct crypto_instance *inst);
-- 
2.11.0
