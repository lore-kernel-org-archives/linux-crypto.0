From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v7 7/9] crypto: acomp - add support for 842 via scomp
Date: Tue, 13 Sep 2016 13:49:39 +0100
Message-ID: <1473770981-9869-8-git-send-email-giovanni.cabiddu@intel.com>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:29789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755031AbcIMMt6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:49:58 -0400
In-Reply-To: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for 842 compression algorithm

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/842.c   |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 crypto/Kconfig |    1 +
 2 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..d0894e2 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -30,12 +30,53 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <crypto/scatterwalk.h>
 #include <linux/sw842.h>
+#include <crypto/internal/scompress.h>
+
+#define SW842_SCRATCH_SIZE	131072
 
 struct crypto842_ctx {
-	char wmem[SW842_MEM_COMPRESS];	/* working memory for compress */
+	void *wmem;	/* working memory for compress */
 };
 
+static void * __percpu *sw842_src_scratches;
+static void * __percpu *sw842_dst_scratches;
+
+static void *crypto842_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = kmalloc(SW842_MEM_COMPRESS, GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
+static int crypto842_init(struct crypto_tfm *tfm)
+{
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->wmem = crypto842_alloc_ctx(NULL);
+	if (IS_ERR(ctx->wmem))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void crypto842_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	kfree(ctx);
+}
+
+static void crypto842_exit(struct crypto_tfm *tfm)
+{
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto842_free_ctx(NULL, ctx->wmem);
+}
+
 static int crypto842_compress(struct crypto_tfm *tfm,
 			      const u8 *src, unsigned int slen,
 			      u8 *dst, unsigned int *dlen)
@@ -52,6 +93,51 @@ static int crypto842_decompress(struct crypto_tfm *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
+static int sw842_scomp_comp_decomp(struct crypto_scomp *tfm,
+				   struct scatterlist *src, unsigned int slen,
+				   struct scatterlist *dst, unsigned int *dlen,
+				   void *ctx, int dir)
+{
+	const int cpu = get_cpu();
+	u8 *scratch_src = *per_cpu_ptr(sw842_src_scratches, cpu);
+	u8 *scratch_dst = *per_cpu_ptr(sw842_dst_scratches, cpu);
+	int ret;
+
+	if (slen > SW842_SCRATCH_SIZE || *dlen > SW842_SCRATCH_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	scatterwalk_map_and_copy(scratch_src, src, 0, slen, 0);
+	if (dir)
+		ret = sw842_compress(scratch_src, slen, scratch_dst, dlen,
+				     ctx);
+	else
+		ret = sw842_decompress(scratch_src, slen, scratch_dst, dlen);
+	if (!ret)
+		scatterwalk_map_and_copy(scratch_dst, dst, 0, *dlen, 1);
+
+out:
+	put_cpu();
+	return ret;
+}
+
+static int sw842_scomp_compress(struct crypto_scomp *tfm,
+				struct scatterlist *src, unsigned int slen,
+				struct scatterlist *dst, unsigned int *dlen,
+				void *ctx)
+{
+	return sw842_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 1);
+}
+
+static int sw842_scomp_decompress(struct crypto_scomp *tfm,
+				  struct scatterlist *src, unsigned int slen,
+				  struct scatterlist *dst, unsigned int *dlen,
+				  void *ctx)
+{
+	return sw842_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 0);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
@@ -59,20 +145,65 @@ static struct crypto_alg alg = {
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct crypto842_ctx),
 	.cra_module		= THIS_MODULE,
+	.cra_init		= crypto842_init,
+	.cra_exit		= crypto842_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= crypto842_compress,
 	.coa_decompress		= crypto842_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= crypto842_alloc_ctx,
+	.free_ctx		= crypto842_free_ctx,
+	.compress		= sw842_scomp_compress,
+	.decompress		= sw842_scomp_decompress,
+	.base			= {
+		.cra_name	= "842",
+		.cra_driver_name = "842-scomp",
+		.cra_priority	 = 100,
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
 static int __init crypto842_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	int ret;
+
+	sw842_src_scratches = crypto_scomp_alloc_scratches(SW842_SCRATCH_SIZE);
+	if (!sw842_src_scratches)
+		return -ENOMEM;
+
+	sw842_dst_scratches = crypto_scomp_alloc_scratches(SW842_SCRATCH_SIZE);
+	if (!sw842_dst_scratches) {
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
+	crypto_scomp_free_scratches(sw842_src_scratches);
+	crypto_scomp_free_scratches(sw842_dst_scratches);
+	return ret;
 }
 module_init(crypto842_mod_init);
 
 static void __exit crypto842_mod_exit(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
+	crypto_scomp_free_scratches(sw842_src_scratches);
+	crypto_scomp_free_scratches(sw842_dst_scratches);
 }
 module_exit(crypto842_mod_exit);
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4258e85..ac7b519 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1598,6 +1598,7 @@ config CRYPTO_LZO
 config CRYPTO_842
 	tristate "842 compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select 842_COMPRESS
 	select 842_DECOMPRESS
 	help
-- 
1.7.4.1
