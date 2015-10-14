From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 4/8] crypto/deflate: support contextless compression API
Date: Wed, 14 Oct 2015 16:38:20 +0900
Message-ID: <1444808304-29320-5-git-send-email-iamjoonsoo.kim@lge.com>
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
 crypto/deflate.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 10 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 95d8d37..7070438 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/net.h>
+#include <crypto/compress.h>
 
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
@@ -116,19 +116,54 @@ out:
 	return ret;
 }
 
-static void deflate_exit(struct crypto_tfm *tfm)
+static void *deflate_alloc_context(struct crypto_ccomp *tfm)
+{
+	void *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(struct deflate_ctx), GFP_KERNEL);
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
+static void deflate_free_context(struct crypto_ccomp *tfm, void *ctx)
+{
+	__deflate_exit(ctx);
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
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
 	int ret = 0;
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct deflate_ctx *dctx = ctx;
 	struct z_stream_s *stream = &dctx->comp_stream;
 
 	ret = zlib_deflateReset(stream);
@@ -153,12 +188,20 @@ out:
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
@@ -194,6 +237,14 @@ out:
 	return ret;
 }
 
+static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+
+	return __deflate_compress(src, slen, dst, dlen, dctx);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -206,14 +257,39 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
+static struct ccomp_alg ccomp = {
+	.alloc_context		= deflate_alloc_context,
+	.free_context		= deflate_free_context,
+	.compress		= __deflate_compress,
+	.decompress		= __deflate_decompress,
+	.base			= {
+		.cra_name	= "deflate",
+		.cra_flags	= CRYPTO_ALG_TYPE_CCOMPRESS,
+		.cra_module	= THIS_MODULE,
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
+	ret = crypto_register_ccomp(&ccomp);
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
+	crypto_unregister_ccomp(&ccomp);
 }
 
 module_init(deflate_mod_init);
-- 
1.9.1
