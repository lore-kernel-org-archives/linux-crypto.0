From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v9 6/8] crypto: acomp - add support for 842 via scomp
Date: Thu, 29 Sep 2016 11:19:00 +0100
Message-ID: <1475144342-1157-7-git-send-email-giovanni.cabiddu@intel.com>
References: <1475144342-1157-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37535 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753891AbcI2KTT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2016 06:19:19 -0400
In-Reply-To: <1475144342-1157-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for 842 compression algorithm.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/842.c   | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 crypto/Kconfig |  1 +
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..bc26dc9 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -31,11 +31,46 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/sw842.h>
+#include <crypto/internal/scompress.h>
 
 struct crypto842_ctx {
-	char wmem[SW842_MEM_COMPRESS];	/* working memory for compress */
+	void *wmem;	/* working memory for compress */
 };
 
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
@@ -45,6 +80,13 @@ static int crypto842_compress(struct crypto_tfm *tfm,
 	return sw842_compress(src, slen, dst, dlen, ctx->wmem);
 }
 
+static int crypto842_scompress(struct crypto_scomp *tfm,
+			       const u8 *src, unsigned int slen,
+			       u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return sw842_compress(src, slen, dst, dlen, ctx);
+}
+
 static int crypto842_decompress(struct crypto_tfm *tfm,
 				const u8 *src, unsigned int slen,
 				u8 *dst, unsigned int *dlen)
@@ -52,6 +94,13 @@ static int crypto842_decompress(struct crypto_tfm *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
+static int crypto842_sdecompress(struct crypto_scomp *tfm,
+				 const u8 *src, unsigned int slen,
+				 u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return sw842_decompress(src, slen, dst, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
@@ -59,20 +108,48 @@ static struct crypto_alg alg = {
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
+	.compress		= crypto842_scompress,
+	.decompress		= crypto842_sdecompress,
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
 module_init(crypto842_mod_init);
 
 static void __exit crypto842_mod_exit(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_scomp(&scomp);
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
2.4.11
