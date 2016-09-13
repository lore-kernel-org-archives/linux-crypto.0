From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Tue, 13 Sep 2016 13:49:36 +0100
Message-ID: <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:62118 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754612AbcIMMt6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:49:58 -0400
In-Reply-To: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for lzo compression algorithm

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig |    1 +
 crypto/lzo.c   |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 134 insertions(+), 13 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f553f66..d275591 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1589,6 +1589,7 @@ config CRYPTO_DEFLATE
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	help
diff --git a/crypto/lzo.c b/crypto/lzo.c
index c3f3dd9..6faed95 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -22,40 +22,61 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/lzo.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/scompress.h>
+
+#define LZO_SCRATCH_SIZE	131072
 
 struct lzo_ctx {
 	void *lzo_comp_mem;
 };
 
+static void * __percpu *lzo_src_scratches;
+static void * __percpu *lzo_dst_scratches;
+
+static void *lzo_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL | __GFP_NOWARN);
+	if (!ctx)
+		ctx = vmalloc(LZO1X_MEM_COMPRESS);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
 static int lzo_init(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lzo_comp_mem = kmalloc(LZO1X_MEM_COMPRESS,
-				    GFP_KERNEL | __GFP_NOWARN);
-	if (!ctx->lzo_comp_mem)
-		ctx->lzo_comp_mem = vmalloc(LZO1X_MEM_COMPRESS);
-	if (!ctx->lzo_comp_mem)
+	ctx->lzo_comp_mem = lzo_alloc_ctx(NULL);
+	if (IS_ERR(ctx->lzo_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static void lzo_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	kvfree(ctx);
+}
+
 static void lzo_exit(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	kvfree(ctx->lzo_comp_mem);
+	lzo_free_ctx(NULL, ctx->lzo_comp_mem);
 }
 
-static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int __lzo_compress(const u8 *src, unsigned int slen,
+			  u8 *dst, unsigned int *dlen, void *ctx)
 {
-	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
 	int err;
 
-	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx->lzo_comp_mem);
+	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
 		return -EINVAL;
@@ -64,8 +85,16 @@ static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
+			unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lzo_compress(src, slen, dst, dlen, ctx->lzo_comp_mem);
+}
+
+static int __lzo_decompress(const u8 *src, unsigned int slen,
+			    u8 *dst, unsigned int *dlen)
 {
 	int err;
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
@@ -77,7 +106,56 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 	*dlen = tmp_len;
 	return 0;
+}
 
+static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
+			  unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lzo_decompress(src, slen, dst, dlen);
+}
+
+static int lzo_scomp_comp_decomp(struct crypto_scomp *tfm,
+				 struct scatterlist *src, unsigned int slen,
+				 struct scatterlist *dst, unsigned int *dlen,
+				 void *ctx, int dir)
+{
+	const int cpu = get_cpu();
+	u8 *scratch_src = *per_cpu_ptr(lzo_src_scratches, cpu);
+	u8 *scratch_dst = *per_cpu_ptr(lzo_dst_scratches, cpu);
+	int ret;
+
+	if (slen > LZO_SCRATCH_SIZE || *dlen > LZO_SCRATCH_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	scatterwalk_map_and_copy(scratch_src, src, 0, slen, 0);
+	if (dir)
+		ret = __lzo_compress(scratch_src, slen, scratch_dst, dlen, ctx);
+	else
+		ret = __lzo_decompress(scratch_src, slen, scratch_dst, dlen);
+	if (!ret)
+		scatterwalk_map_and_copy(scratch_dst, dst, 0, *dlen, 1);
+
+out:
+	put_cpu();
+	return ret;
+}
+
+static int lzo_scomp_compress(struct crypto_scomp *tfm,
+			      struct scatterlist *src, unsigned int slen,
+			      struct scatterlist *dst, unsigned int *dlen,
+			      void *ctx)
+{
+	return lzo_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 1);
+}
+
+static int lzo_scomp_decompress(struct crypto_scomp *tfm,
+				struct scatterlist *src, unsigned int slen,
+				struct scatterlist *dst, unsigned int *dlen,
+				void *ctx)
+{
+	return lzo_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 0);
 }
 
 static struct crypto_alg alg = {
@@ -92,14 +170,56 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= lzo_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lzo_alloc_ctx,
+	.free_ctx		= lzo_free_ctx,
+	.compress		= lzo_scomp_compress,
+	.decompress		= lzo_scomp_decompress,
+	.base			= {
+		.cra_name	= "lzo",
+		.cra_driver_name = "lzo-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
 static int __init lzo_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	int ret;
+
+	lzo_src_scratches = crypto_scomp_alloc_scratches(LZO_SCRATCH_SIZE);
+	if (!lzo_src_scratches)
+		return -ENOMEM;
+
+	lzo_dst_scratches = crypto_scomp_alloc_scratches(LZO_SCRATCH_SIZE);
+	if (!lzo_dst_scratches) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ret = crypto_register_alg(&alg);
+	if (ret)
+		goto error;
+
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&alg);
+		goto error;
+	}
+
+	return ret;
+
+error:
+	crypto_scomp_free_scratches(lzo_src_scratches);
+	crypto_scomp_free_scratches(lzo_dst_scratches);
+	return ret;
 }
 
 static void __exit lzo_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
+	crypto_scomp_free_scratches(lzo_src_scratches);
+	crypto_scomp_free_scratches(lzo_dst_scratches);
 }
 
 module_init(lzo_mod_init);
-- 
1.7.4.1
