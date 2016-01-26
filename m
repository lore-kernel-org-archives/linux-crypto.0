From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 05/10] crypto/lzo: support new compression APIs
Date: Tue, 26 Jan 2016 17:15:07 +0900
Message-ID: <1453796112-14273-6-git-send-email-iamjoonsoo.kim@lge.com>
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
 crypto/Kconfig |  1 +
 crypto/lzo.c   | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f22f4e9..b4b485c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1503,6 +1503,7 @@ config CRYPTO_LZO
 	select CRYPTO_ALGAPI
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select CRYPTO_COMPRESS2
 	help
 	  This is the LZO algorithm.
 
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4b3e925..94cd7a4 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -23,39 +23,56 @@
 #include <linux/mm.h>
 #include <linux/lzo.h>
 
+#include <crypto/compress.h>
+
 struct lzo_ctx {
 	void *lzo_comp_mem;
 };
 
+static void *lzo_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = kmalloc(LZO1X_MEM_COMPRESS,
+		    GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
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
-				    GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
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
+			u8 *dst, unsigned int *dlen, void *ctx)
 {
-	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
 	int err;
 
-	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx->lzo_comp_mem);
+	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
 		return -EINVAL;
@@ -64,8 +81,22 @@ static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __lzo_compress(src, slen, dst, dlen, ctx->lzo_comp_mem);
+}
+
+static int lzo_scompress(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return __lzo_compress(src, slen, dst, dlen, ctx);
+}
+
+static int __lzo_decompress(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen)
 {
 	int err;
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
@@ -77,7 +108,18 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 	*dlen = tmp_len;
 	return 0;
+}
+
+static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lzo_decompress(src, slen, dst, dlen);
+}
 
+static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return __lzo_decompress(src, slen, dst, dlen);
 }
 
 static struct crypto_alg alg = {
@@ -92,14 +134,41 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= lzo_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= lzo_alloc_ctx,
+	.free_ctx		= lzo_free_ctx,
+	.compress		= lzo_scompress,
+	.decompress		= lzo_sdecompress,
+	.base			= {
+		.cra_name	= "lzo",
+		.cra_driver_name= "lzo-scomp",
+		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS |
+					CRYPTO_SCOMP_DECOMP_NOCTX,
+		.cra_module	= THIS_MODULE,
+	}
+};
+
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
1.9.1
