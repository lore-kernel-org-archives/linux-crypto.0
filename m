From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v7 8/9] crypto: acomp - add support for deflate via scomp
Date: Tue, 13 Sep 2016 13:49:40 +0100
Message-ID: <1473770981-9869-9-git-send-email-giovanni.cabiddu@intel.com>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:6697 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754631AbcIMMt4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:49:56 -0400
In-Reply-To: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for deflate compression algorithm

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig   |    1 +
 crypto/deflate.c |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 157 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ac7b519..7d4808f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1578,6 +1578,7 @@ comment "Compression"
 config CRYPTO_DEFLATE
 	tristate "Deflate compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	help
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 95d8d37..f924031 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -32,16 +32,22 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/net.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/scompress.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
+#define DEFLATE_SCR_SIZE		131072
 
 struct deflate_ctx {
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
 };
 
+static void * __percpu *deflate_src_scratches;
+static void * __percpu *deflate_dst_scratches;
+
 static int deflate_comp_init(struct deflate_ctx *ctx)
 {
 	int ret = 0;
@@ -101,9 +107,8 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int deflate_init(struct crypto_tfm *tfm)
+static int __deflate_init(void *ctx)
 {
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 	int ret;
 
 	ret = deflate_comp_init(ctx);
@@ -116,19 +121,55 @@ out:
 	return ret;
 }
 
-static void deflate_exit(struct crypto_tfm *tfm)
+static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
+{
+	struct deflate_ctx *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __deflate_init(ctx);
+	if (ret) {
+		kfree(ctx);
+		return ERR_PTR(ret);
+	}
+
+	return ctx;
+}
+
+static int deflate_init(struct crypto_tfm *tfm)
 {
 	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	return __deflate_init(ctx);
+}
+
+static void __deflate_exit(void *ctx)
+{
 	deflate_comp_exit(ctx);
 	deflate_decomp_exit(ctx);
 }
 
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	__deflate_exit(ctx);
+	kzfree(ctx);
+}
+
+static void deflate_exit(struct crypto_tfm *tfm)
+{
+	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__deflate_exit(ctx);
+}
+
+static int __deflate_compress(const u8 *src, unsigned int slen,
+			      u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int ret = 0;
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct deflate_ctx *dctx = ctx;
 	struct z_stream_s *stream = &dctx->comp_stream;
 
 	ret = zlib_deflateReset(stream);
@@ -153,12 +194,20 @@ out:
 	return ret;
 }
 
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+
+	return __deflate_compress(src, slen, dst, dlen, dctx);
+}
+
+static int __deflate_decompress(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
 
 	int ret = 0;
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct deflate_ctx *dctx = ctx;
 	struct z_stream_s *stream = &dctx->decomp_stream;
 
 	ret = zlib_inflateReset(stream);
@@ -194,6 +243,61 @@ out:
 	return ret;
 }
 
+static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+
+	return __deflate_decompress(src, slen, dst, dlen, dctx);
+}
+
+static int deflate_scomp_comp_decomp(struct crypto_scomp *tfm,
+				     struct scatterlist *src,
+				     unsigned int slen,
+				     struct scatterlist *dst,
+				     unsigned int *dlen, void *ctx, int dir)
+{
+	const int cpu = get_cpu();
+	u8 *scratch_src = *per_cpu_ptr(deflate_src_scratches, cpu);
+	u8 *scratch_dst = *per_cpu_ptr(deflate_dst_scratches, cpu);
+	int ret;
+
+	if (slen > DEFLATE_SCR_SIZE || *dlen > DEFLATE_SCR_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	scatterwalk_map_and_copy(scratch_src, src, 0, slen, 0);
+	if (dir)
+		ret = __deflate_compress(scratch_src, slen, scratch_dst,
+					 dlen, ctx);
+	else
+		ret = __deflate_decompress(scratch_src, slen, scratch_dst,
+					   dlen, ctx);
+	if (!ret)
+		scatterwalk_map_and_copy(scratch_dst, dst, 0, *dlen, 1);
+
+out:
+	put_cpu();
+	return ret;
+}
+
+static int deflate_scomp_compress(struct crypto_scomp *tfm,
+				  struct scatterlist *src, unsigned int slen,
+				  struct scatterlist *dst, unsigned int *dlen,
+				  void *ctx)
+{
+	return deflate_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 1);
+}
+
+static int deflate_scomp_decompress(struct crypto_scomp *tfm,
+				    struct scatterlist *src, unsigned int slen,
+				    struct scatterlist *dst, unsigned int *dlen,
+				    void *ctx)
+{
+	return deflate_scomp_comp_decomp(tfm, src, slen, dst, dlen, ctx, 0);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -206,14 +310,56 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= deflate_alloc_ctx,
+	.free_ctx		= deflate_free_ctx,
+	.compress		= deflate_scomp_compress,
+	.decompress		= deflate_scomp_decompress,
+	.base			= {
+		.cra_name	= "deflate",
+		.cra_driver_name = "deflate-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
 static int __init deflate_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	int ret;
+
+	deflate_src_scratches = crypto_scomp_alloc_scratches(DEFLATE_SCR_SIZE);
+	if (!deflate_src_scratches)
+		return -ENOMEM;
+
+	deflate_dst_scratches = crypto_scomp_alloc_scratches(DEFLATE_SCR_SIZE);
+	if (!deflate_dst_scratches) {
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
+	crypto_scomp_free_scratches(deflate_src_scratches);
+	crypto_scomp_free_scratches(deflate_dst_scratches);
+	return ret;
 }
 
 static void __exit deflate_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
+	crypto_scomp_free_scratches(deflate_src_scratches);
+	crypto_scomp_free_scratches(deflate_dst_scratches);
 }
 
 module_init(deflate_mod_init);
-- 
1.7.4.1
