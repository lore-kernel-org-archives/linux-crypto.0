From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 3/5] crypto: cryptd: Add support to access underlaying shash
Date: Mon,  3 Aug 2009 15:45:29 +0800
Message-ID: <1249285531-22422-3-git-send-email-ying.huang@intel.com>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
 <1249285531-22422-2-git-send-email-ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZHCHpg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2009 03:45:36 -0400
In-Reply-To: <1249285531-22422-2-git-send-email-ying.huang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptd_alloc_ahash() will allocate a cryptd-ed ahash for specified
algorithm name. The new allocated one is guaranteed to be cryptd-ed
ahash, so the shash underlying can be gotten via cryptd_ahash_child().

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/cryptd.c         |   35 +++++++++++++++++++++++++++++++++++
 include/crypto/cryptd.h |   17 +++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2eb7058..3533582 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -682,6 +682,41 @@ void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
 
+struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_ahash *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm = crypto_alloc_ahash(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_ahash(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return __cryptd_ahash_cast(tfm);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_ahash);
+
+struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm)
+{
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
+
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_ahash_child);
+
+void cryptd_free_ahash(struct cryptd_ahash *tfm)
+{
+	crypto_free_ahash(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(cryptd_free_ahash);
+
 static int __init cryptd_init(void)
 {
 	int err;
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 55fa7bb..2f65a6e 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -7,6 +7,7 @@
 
 #include <linux/crypto.h>
 #include <linux/kernel.h>
+#include <crypto/hash.h>
 
 struct cryptd_ablkcipher {
 	struct crypto_ablkcipher base;
@@ -24,4 +25,20 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher *tfm);
 void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
 
+struct cryptd_ahash {
+	struct crypto_ahash base;
+};
+
+static inline struct cryptd_ahash *__cryptd_ahash_cast(
+	struct crypto_ahash *tfm)
+{
+	return (struct cryptd_ahash *)tfm;
+}
+
+/* alg_name should be algorithm to be cryptd-ed */
+struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask);
+struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
+void cryptd_free_ahash(struct cryptd_ahash *tfm);
+
 #endif
-- 
1.6.3.3

