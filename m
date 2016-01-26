From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 06/10] crypto/lz4: support new compression APIs
Date: Tue, 26 Jan 2016 17:15:08 +0900
Message-ID: <1453796112-14273-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36541 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbcAZIPy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 03:15:54 -0500
In-Reply-To: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now, new compression APIs are introduced and it has some benefits.
Let's support it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig |  1 +
 crypto/lz4.c   | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b4b485c..72ab0d7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1520,6 +1520,7 @@ config CRYPTO_LZ4
 	select CRYPTO_ALGAPI
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
+	select CRYPTO_COMPRESS2
 	help
 	  This is the LZ4 algorithm.
 
diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..728c6c4 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -24,35 +24,53 @@
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
 
+#include <crypto/compress.h>
+
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
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
 	size_t tmp_len = *dlen;
 	int err;
 
-	err = lz4_compress(src, slen, dst, &tmp_len, ctx->lz4_comp_mem);
+	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
 
 	if (err < 0)
 		return -EINVAL;
@@ -61,8 +79,22 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
+}
+
+static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int err;
 	size_t tmp_len = *dlen;
@@ -76,6 +108,18 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
+static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -89,14 +133,41 @@ static struct crypto_alg alg_lz4 = {
 	.coa_decompress		= lz4_decompress_crypto } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lz4_alloc_ctx,
+	.free_ctx		= lz4_free_ctx,
+	.compress		= lz4_scompress,
+	.decompress		= lz4_sdecompress,
+	.base			= {
+		.cra_name	= "lz4",
+		.cra_driver_name= "lz4-scomp",
+		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS |
+					CRYPTO_SCOMP_DECOMP_NOCTX,
+		.cra_module	= THIS_MODULE,
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
1.9.1
