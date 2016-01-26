From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 08/10] crypto/842: support new compression APIs
Date: Tue, 26 Jan 2016 17:15:10 +0900
Message-ID: <1453796112-14273-9-git-send-email-iamjoonsoo.kim@lge.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now, new compression APIs are introduced and it has some benefits.
Let's support it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/842.c   | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 crypto/Kconfig |  1 +
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..47cf7e5 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -32,10 +32,46 @@
 #include <linux/crypto.h>
 #include <linux/sw842.h>
 
+#include <crypto/compress.h>
+
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
@@ -45,6 +81,13 @@ static int crypto842_compress(struct crypto_tfm *tfm,
 	return sw842_compress(src, slen, dst, dlen, ctx->wmem);
 }
 
+static int crypto842_scompress(struct crypto_scomp *tfm,
+			      const u8 *src, unsigned int slen,
+			      u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return sw842_compress(src, slen, dst, dlen, ctx);
+}
+
 static int crypto842_decompress(struct crypto_tfm *tfm,
 				const u8 *src, unsigned int slen,
 				u8 *dst, unsigned int *dlen)
@@ -52,27 +95,63 @@ static int crypto842_decompress(struct crypto_tfm *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
+static int crypto842_sdecompress(struct crypto_scomp *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return sw842_decompress(src, slen, dst, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
 	.cra_priority		= 100,
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct crypto842_ctx),
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
+		.cra_driver_name= "842-scomp",
+		.cra_priority	= 100,
+		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS |
+					CRYPTO_SCOMP_DECOMP_NOCTX,
+		.cra_module	= THIS_MODULE,
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
index 2641a60..351b859 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1512,6 +1512,7 @@ config CRYPTO_842
 	select CRYPTO_ALGAPI
 	select 842_COMPRESS
 	select 842_DECOMPRESS
+	select CRYPTO_COMPRESS2
 	help
 	  This is the 842 algorithm.
 
-- 
1.9.1
