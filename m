From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v9 7/8] crypto: acomp - add support for deflate via scomp
Date: Thu, 29 Sep 2016 11:19:01 +0100
Message-ID: <1475144342-1157-8-git-send-email-giovanni.cabiddu@intel.com>
References: <1475144342-1157-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26245 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbcI2KTT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2016 06:19:19 -0400
In-Reply-To: <1475144342-1157-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for deflate compression algorithm.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig   |   1 +
 crypto/deflate.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 102 insertions(+), 10 deletions(-)

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
index 95d8d37..f942cb3 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/net.h>
+#include <crypto/internal/scompress.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
@@ -101,9 +102,8 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int deflate_init(struct crypto_tfm *tfm)
+static int __deflate_init(void *ctx)
 {
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 	int ret;
 
 	ret = deflate_comp_init(ctx);
@@ -116,19 +116,55 @@ out:
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
@@ -153,12 +189,27 @@ out:
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
+static int deflate_scompress(struct crypto_scomp *tfm, const u8 *src,
+			     unsigned int slen, u8 *dst, unsigned int *dlen,
+			     void *ctx)
+{
+	return __deflate_compress(src, slen, dst, dlen, ctx);
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
@@ -194,6 +245,21 @@ out:
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
+static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+			       unsigned int slen, u8 *dst, unsigned int *dlen,
+			       void *ctx)
+{
+	return __deflate_decompress(src, slen, dst, dlen, ctx);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -206,14 +272,39 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= deflate_alloc_ctx,
+	.free_ctx		= deflate_free_ctx,
+	.compress		= deflate_scompress,
+	.decompress		= deflate_sdecompress,
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
+	ret = crypto_register_alg(&alg);
+	if (ret)
+		return ret;
+
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&alg);
+		return ret;
+	}
+
+	return ret;
 }
 
 static void __exit deflate_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
 }
 
 module_init(deflate_mod_init);
-- 
2.4.11
