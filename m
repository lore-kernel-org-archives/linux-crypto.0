From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v5 4/9] crypto: acomp - add support for lzo via scomp
Date: Thu,  2 Jun 2016 13:28:58 +0100
Message-ID: <1464870543-5988-5-git-send-email-giovanni.cabiddu@intel.com>
References: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbcFBM3M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 08:29:12 -0400
In-Reply-To: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implements an scomp backend for the lzo compression algorithm.
This way, lzo is exposed through the acomp api.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/Kconfig |    1 +
 crypto/lzo.c   |   97 +++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 24fef55..08075c1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1513,6 +1513,7 @@ config CRYPTO_DEFLATE
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	help
diff --git a/crypto/lzo.c b/crypto/lzo.c
index c3f3dd9..168df78 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -22,40 +22,55 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/lzo.h>
+#include <crypto/internal/scompress.h>
 
 struct lzo_ctx {
 	void *lzo_comp_mem;
 };
 
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
@@ -64,8 +79,23 @@ static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
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
+static int lzo_scompress(struct crypto_scomp *tfm, const u8 *src,
+			 unsigned int slen, u8 *dst, unsigned int *dlen,
+			 void *ctx)
+{
+	return __lzo_compress(src, slen, dst, dlen, ctx);
+}
+
+static int __lzo_decompress(const u8 *src, unsigned int slen,
+			    u8 *dst, unsigned int *dlen)
 {
 	int err;
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
@@ -77,7 +107,19 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 	*dlen = tmp_len;
 	return 0;
+}
 
+static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
+			  unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lzo_decompress(src, slen, dst, dlen);
+}
+
+static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen,
+			   void *ctx)
+{
+	return __lzo_decompress(src, slen, dst, dlen);
 }
 
 static struct crypto_alg alg = {
@@ -88,18 +130,43 @@ static struct crypto_alg alg = {
 	.cra_init		= lzo_init,
 	.cra_exit		= lzo_exit,
 	.cra_u			= { .compress = {
-	.coa_compress 		= lzo_compress,
-	.coa_decompress  	= lzo_decompress } }
+	.coa_compress		= lzo_compress,
+	.coa_decompress		= lzo_decompress } }
+};
+
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lzo_alloc_ctx,
+	.free_ctx		= lzo_free_ctx,
+	.compress		= lzo_scompress,
+	.decompress		= lzo_sdecompress,
+	.base			= {
+		.cra_name	= "lzo",
+		.cra_driver_name = "lzo-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
 };
 
 static int __init lzo_mod_init(void)
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
 
 static void __exit lzo_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
 }
 
 module_init(lzo_mod_init);
-- 
1.7.4.1
