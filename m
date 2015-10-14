From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 2/8] crypto/lzo: support contextless compression API
Date: Wed, 14 Oct 2015 16:38:18 +0900
Message-ID: <1444808304-29320-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now, contextless compression API is introduced and it can reduce
memory overhead in some cases. All compression algorithm will
support it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig |  1 +
 crypto/lzo.c   | 81 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cfc42e6..d25746f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1494,6 +1494,7 @@ config CRYPTO_DEFLATE
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
+	select CRYPTO_CCOMPRESS
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	help
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4b3e925..a6ae752 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -22,40 +22,56 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/lzo.h>
+#include <crypto/compress.h>
 
 struct lzo_ctx {
 	void *lzo_comp_mem;
 };
 
+static void *lzo_alloc_context(struct crypto_ccomp *tfm)
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
+	ctx->lzo_comp_mem = lzo_alloc_context(NULL);
+	if (IS_ERR(ctx->lzo_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static void lzo_free_context(struct crypto_ccomp *tfm, void *ctx)
+{
+	kvfree(ctx);
+}
+
 static void lzo_exit(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	kvfree(ctx->lzo_comp_mem);
+	lzo_free_context(NULL, ctx->lzo_comp_mem);
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
@@ -64,8 +80,16 @@ static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
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
+static int __lzo_decompress(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int err;
 	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
@@ -77,7 +101,12 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 	*dlen = tmp_len;
 	return 0;
+}
 
+static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lzo_decompress(src, slen, dst, dlen, NULL);
 }
 
 static struct crypto_alg alg = {
@@ -92,14 +121,40 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= lzo_decompress } }
 };
 
+static struct ccomp_alg ccomp = {
+	.alloc_context		= lzo_alloc_context,
+	.free_context		= lzo_free_context,
+	.compress		= __lzo_compress,
+	.decompress		= __lzo_decompress,
+	.flags			= CCOMP_TYPE_DECOMP_NOCTX,
+	.base			= {
+		.cra_name	= "lzo",
+		.cra_flags	= CRYPTO_ALG_TYPE_CCOMPRESS,
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
+	ret = crypto_register_ccomp(&ccomp);
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
+	crypto_unregister_ccomp(&ccomp);
 }
 
 module_init(lzo_mod_init);
-- 
1.9.1
