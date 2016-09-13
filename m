From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v7 6/9] crypto: acomp - add support for lz4hc via scomp
Date: Tue, 13 Sep 2016 13:49:38 +0100
Message-ID: <1473770981-9869-7-git-send-email-giovanni.cabiddu@intel.com>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:62118 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbcIMMuA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:50:00 -0400
In-Reply-To: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for lz4hc compression algorithm

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig |    1 +
 crypto/lz4hc.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 138 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e95cbbd..4258e85 100644
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
index a1d3b5b..d509901 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -22,37 +22,59 @@
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/scompress.h>
+
+#define LZ4HC_SCRATCH_SIZE	131072
 
 struct lz4hc_ctx {
 	void *lz4hc_comp_mem;
 };
 
+static void * __percpu *lz4hc_src_scratches;
+static void * __percpu *lz4hc_dst_scratches;
+
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
@@ -61,8 +83,18 @@ static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
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
@@ -76,6 +108,59 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				   unsigned int slen, u8 *dst,
+				   unsigned int *dlen)
+{
+	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
+static int lz4hc_scomp_comp_decomp(struct crypto_scomp *tfm,
+				   struct scatterlist *src, unsigned int slen,
+				   struct scatterlist *dst, unsigned int *dlen,
+				   void *ctx, int dir)
+{
+	const int cpu = get_cpu();
+	u8 *scratch_src = *per_cpu_ptr(lz4hc_src_scratches, cpu);
+	u8 *scratch_dst = *per_cpu_ptr(lz4hc_dst_scratches, cpu);
+	int ret;
+
+	if (slen > LZ4HC_SCRATCH_SIZE || *dlen > LZ4HC_SCRATCH_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	scatterwalk_map_and_copy(scratch_src, src, 0, slen, 0);
+	if (dir)
+		ret = __lz4hc_compress_crypto(scratch_src, slen, scratch_dst,
+					      dlen, ctx);
+	else
+		ret = __lz4hc_decompress_crypto(scratch_src, slen, scratch_dst,
+						dlen, NULL);
+	if (!ret)
+		scatterwalk_map_and_copy(scratch_dst, dst, 0, *dlen, 1);
+
+out:
+	put_cpu();
+	return ret;
+}
+
+static int lz4hc_scomp_compress(struct crypto_scomp *tfm,
+				struct scatterlist *src, unsigned int slen,
+				struct scatterlist *dst, unsigned int *dlen,
+				void *ctx)
+{
+	return lz4hc_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 1);
+}
+
+static int lz4hc_scomp_decompress(struct crypto_scomp *tfm,
+				  struct scatterlist *src, unsigned int slen,
+				  struct scatterlist *dst, unsigned int *dlen,
+				  void *ctx)
+{
+	return lz4hc_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 0);
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -89,14 +174,56 @@ static struct crypto_alg alg_lz4hc = {
 	.coa_decompress		= lz4hc_decompress_crypto } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lz4hc_alloc_ctx,
+	.free_ctx		= lz4hc_free_ctx,
+	.compress		= lz4hc_scomp_compress,
+	.decompress		= lz4hc_scomp_decompress,
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
+	lz4hc_src_scratches = crypto_scomp_alloc_scratches(LZ4HC_SCRATCH_SIZE);
+	if (!lz4hc_src_scratches)
+		return -ENOMEM;
+
+	lz4hc_dst_scratches = crypto_scomp_alloc_scratches(LZ4HC_SCRATCH_SIZE);
+	if (!lz4hc_dst_scratches) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ret = crypto_register_alg(&alg_lz4hc);
+	if (ret)
+		goto error;
+
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&alg_lz4hc);
+		goto error;
+	}
+
+	return ret;
+
+error:
+	crypto_scomp_free_scratches(lz4hc_src_scratches);
+	crypto_scomp_free_scratches(lz4hc_dst_scratches);
+	return ret;
 }
 
 static void __exit lz4hc_mod_fini(void)
 {
 	crypto_unregister_alg(&alg_lz4hc);
+	crypto_unregister_scomp(&scomp);
+	crypto_scomp_free_scratches(lz4hc_src_scratches);
+	crypto_scomp_free_scratches(lz4hc_dst_scratches);
 }
 
 module_init(lz4hc_mod_init);
-- 
1.7.4.1
