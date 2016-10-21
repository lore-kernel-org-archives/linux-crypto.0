From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v10 5/8] crypto: acomp - add support for lz4hc via scomp
Date: Fri, 21 Oct 2016 13:19:51 +0100
Message-ID: <1477052394-19826-6-git-send-email-giovanni.cabiddu@intel.com>
References: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932713AbcJUMUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 08:20:14 -0400
In-Reply-To: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for lz4hc compression algorithm.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig |  1 +
 crypto/lz4hc.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index acbcd32..a1819e7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1615,6 +1615,7 @@ config CRYPTO_LZ4
 config CRYPTO_LZ4HC
 	tristate "LZ4HC compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select LZ4HC_COMPRESS
 	select LZ4_DECOMPRESS
 	help
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index a1d3b5b..75ffc4a 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -22,37 +22,53 @@
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
+#include <crypto/internal/scompress.h>
 
 struct lz4hc_ctx {
 	void *lz4hc_comp_mem;
 };
 
+static void *lz4hc_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
 static int lz4hc_init(struct crypto_tfm *tfm)
 {
 	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lz4hc_comp_mem = vmalloc(LZ4HC_MEM_COMPRESS);
-	if (!ctx->lz4hc_comp_mem)
+	ctx->lz4hc_comp_mem = lz4hc_alloc_ctx(NULL);
+	if (IS_ERR(ctx->lz4hc_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static void lz4hc_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	vfree(ctx);
+}
+
 static void lz4hc_exit(struct crypto_tfm *tfm)
 {
 	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	vfree(ctx->lz4hc_comp_mem);
+	lz4hc_free_ctx(NULL, ctx->lz4hc_comp_mem);
 }
 
-static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
+				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
 	size_t tmp_len = *dlen;
 	int err;
 
-	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx->lz4hc_comp_mem);
+	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
 
 	if (err < 0)
 		return -EINVAL;
@@ -61,8 +77,25 @@ static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int lz4hc_scompress(struct crypto_scomp *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen,
+			   void *ctx)
+{
+	return __lz4hc_compress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				 unsigned int slen, u8 *dst,
+				 unsigned int *dlen)
+{
+	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lz4hc_compress_crypto(src, slen, dst, dlen,
+					ctx->lz4hc_comp_mem);
+}
+
+static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
+				     u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int err;
 	size_t tmp_len = *dlen;
@@ -76,6 +109,20 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+			     unsigned int slen, u8 *dst, unsigned int *dlen,
+			     void *ctx)
+{
+	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
+static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				   unsigned int slen, u8 *dst,
+				   unsigned int *dlen)
+{
+	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -89,14 +136,39 @@ static struct crypto_alg alg_lz4hc = {
 	.coa_decompress		= lz4hc_decompress_crypto } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lz4hc_alloc_ctx,
+	.free_ctx		= lz4hc_free_ctx,
+	.compress		= lz4hc_scompress,
+	.decompress		= lz4hc_sdecompress,
+	.base			= {
+		.cra_name	= "lz4hc",
+		.cra_driver_name = "lz4hc-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
 static int __init lz4hc_mod_init(void)
 {
-	return crypto_register_alg(&alg_lz4hc);
+	int ret;
+
+	ret = crypto_register_alg(&alg_lz4hc);
+	if (ret)
+		return ret;
+
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&alg_lz4hc);
+		return ret;
+	}
+
+	return ret;
 }
 
 static void __exit lz4hc_mod_fini(void)
 {
 	crypto_unregister_alg(&alg_lz4hc);
+	crypto_unregister_scomp(&scomp);
 }
 
 module_init(lz4hc_mod_init);
-- 
2.4.11
