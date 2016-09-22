From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v8 4/8] crypto: acomp - add support for lz4 via scomp
Date: Thu, 22 Sep 2016 23:44:17 +0100
Message-ID: <1474584261-25776-5-git-send-email-giovanni.cabiddu@intel.com>
References: <1474584261-25776-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15348 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933567AbcIVWok (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 18:44:40 -0400
In-Reply-To: <1474584261-25776-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for lz4 compression algorithm

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig |  1 +
 crypto/lz4.c   | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index d275591..e95cbbd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1606,6 +1606,7 @@ config CRYPTO_842
 config CRYPTO_LZ4
 	tristate "LZ4 compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
 	help
diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..99c1b2c 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -23,36 +23,53 @@
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
+#include <crypto/internal/scompress.h>
 
 struct lz4_ctx {
 	void *lz4_comp_mem;
 };
 
+static void *lz4_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
 static int lz4_init(struct crypto_tfm *tfm)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lz4_comp_mem = vmalloc(LZ4_MEM_COMPRESS);
-	if (!ctx->lz4_comp_mem)
+	ctx->lz4_comp_mem = lz4_alloc_ctx(NULL);
+	if (IS_ERR(ctx->lz4_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static void lz4_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	vfree(ctx);
+}
+
 static void lz4_exit(struct crypto_tfm *tfm)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-	vfree(ctx->lz4_comp_mem);
+
+	lz4_free_ctx(NULL, ctx->lz4_comp_mem);
 }
 
-static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
+				 u8 *dst, unsigned int *dlen, void *ctx)
 {
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
 	size_t tmp_len = *dlen;
 	int err;
 
-	err = lz4_compress(src, slen, dst, &tmp_len, ctx->lz4_comp_mem);
+	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
 
 	if (err < 0)
 		return -EINVAL;
@@ -61,8 +78,23 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
+			 unsigned int slen, u8 *dst, unsigned int *dlen,
+			 void *ctx)
+{
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			       unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
+}
+
+static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
+				   u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int err;
 	size_t tmp_len = *dlen;
@@ -76,6 +108,20 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen,
+			   void *ctx)
+{
+	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
+static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				 unsigned int slen, u8 *dst,
+				 unsigned int *dlen)
+{
+	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -89,14 +135,39 @@ static struct crypto_alg alg_lz4 = {
 	.coa_decompress		= lz4_decompress_crypto } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lz4_alloc_ctx,
+	.free_ctx		= lz4_free_ctx,
+	.compress		= lz4_scompress,
+	.decompress		= lz4_sdecompress,
+	.base			= {
+		.cra_name	= "lz4",
+		.cra_driver_name = "lz4-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
 static int __init lz4_mod_init(void)
 {
-	return crypto_register_alg(&alg_lz4);
+	int ret;
+
+	ret = crypto_register_alg(&alg_lz4);
+	if (ret)
+		return ret;
+
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&alg_lz4);
+		return ret;
+	}
+
+	return ret;
 }
 
 static void __exit lz4_mod_fini(void)
 {
 	crypto_unregister_alg(&alg_lz4);
+	crypto_unregister_scomp(&scomp);
 }
 
 module_init(lz4_mod_init);
-- 
2.4.11
