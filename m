From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 5/7] crypto: cryptd: Add support to access underlaying shash
Date: Thu, 11 Jun 2009 15:10:34 +0800
Message-ID: <1244704234.5320.128.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759076AbZFKHKf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptd_alloc_ahash() will allocate a cryptd-ed ahash for specified
algorithm name. The new allocated one is guaranteed to be cryptd-ed
ahash, so the shash underlying can be gotten via cryptd_ahash_child().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c         |   35 +++++++++++++++++++++++++++++++++++
 include/crypto/cryptd.h |   17 +++++++++++++++++
 2 files changed, 52 insertions(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -648,6 +648,41 @@ void cryptd_free_ablkcipher(struct crypt
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
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -7,6 +7,7 @@
 
 #include <linux/crypto.h>
 #include <linux/kernel.h>
+#include <crypto/hash.h>
 
 struct cryptd_ablkcipher {
 	struct crypto_ablkcipher base;
@@ -24,4 +25,20 @@ struct cryptd_ablkcipher *cryptd_alloc_a
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


