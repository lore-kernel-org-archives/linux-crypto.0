From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 09/10] crypto/deflate: support new compression APIs
Date: Tue, 26 Jan 2016 17:15:11 +0900
Message-ID: <1453796112-14273-10-git-send-email-iamjoonsoo.kim@lge.com>
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
 crypto/Kconfig   |   1 +
 crypto/deflate.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 351b859..728f88e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1492,6 +1492,7 @@ config CRYPTO_DEFLATE
 	select CRYPTO_ALGAPI
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select CRYPTO_COMPRESS2
 	help
 	  This is the Deflate algorithm (RFC1951), specified for use in
 	  IPSec with the IPCOMP protocol (RFC3173, RFC2394).
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 95d8d37..1f8f633 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -33,6 +33,8 @@
 #include <linux/mm.h>
 #include <linux/net.h>
 
+#include <crypto/compress.h>
+
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
@@ -101,9 +103,8 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int deflate_init(struct crypto_tfm *tfm)
+static int __deflate_init(void *ctx)
 {
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 	int ret;
 
 	ret = deflate_comp_init(ctx);
@@ -116,19 +117,54 @@ out:
 	return ret;
 }
 
-static void deflate_exit(struct crypto_tfm *tfm)
+static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
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
+static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
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
@@ -153,12 +189,26 @@ out:
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
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
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
@@ -194,6 +244,20 @@ out:
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
+		unsigned int slen, u8 *dst, unsigned int *dlen, void *ctx)
+{
+	return __deflate_decompress(src, slen, dst, dlen, ctx);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -206,14 +270,40 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
+static struct scomp_alg scomp = {
+	.alloc_ctx		= deflate_alloc_ctx,
+	.free_ctx		= deflate_free_ctx,
+	.compress		= deflate_scompress,
+	.decompress		= deflate_sdecompress,
+	.base			= {
+		.cra_name	= "deflate",
+		.cra_driver_name= "deflate-scomp",
+		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS,
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
1.9.1
