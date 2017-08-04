From: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH v3 2/4] crypto: add crypto_(un)register_ahashes()
Date: Fri,  4 Aug 2017 09:18:46 +0200
Message-ID: <88d84f7cbf8d2e462db06a68db92ed60758078ae.1501830919.git.larper@axis.com>
References: <cover.1501830919.git.larper@axis.com>
Cc: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>, Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1501830919.git.larper-VrBV9hrLPhE@public.gmane.org>
In-Reply-To: <cover.1501830919.git.larper-VrBV9hrLPhE@public.gmane.org>
References: <cover.1501830919.git.larper-VrBV9hrLPhE@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>

There are already helpers to (un)register multiple normal
and AEAD algos.  Add one for ahashes too.

Signed-off-by: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
---
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
