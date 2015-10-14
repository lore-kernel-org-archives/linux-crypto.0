From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 3/8] crypto/lz4: support contextless compressiona API
Date: Wed, 14 Oct 2015 16:38:19 +0900
Message-ID: <1444808304-29320-4-git-send-email-iamjoonsoo.kim@lge.com>
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
 crypto/lz4.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..9720409 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -23,36 +23,53 @@
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
+#include <crypto/compress.h>
 
 struct lz4_ctx {
 	void *lz4_comp_mem;
 };
 
+static void *lz4_alloc_context(struct crypto_ccomp *tfm)
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
+	ctx->lz4_comp_mem = lz4_alloc_context(NULL);
+	if (IS_ERR(ctx->lz4_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
+static void lz4_free_context(struct crypto_ccomp *tfm, void *ctx)
+{
+	vfree(ctx);
+}
+
 static void lz4_exit(struct crypto_tfm *tfm)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-	vfree(ctx->lz4_comp_mem);
+
+	lz4_free_context(NULL, ctx->lz4_comp_mem);
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
@@ -61,8 +78,16 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
-static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
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
@@ -76,6 +101,12 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -89,14 +120,40 @@ static struct crypto_alg alg_lz4 = {
 	.coa_decompress		= lz4_decompress_crypto } }
 };
 
+static struct ccomp_alg ccomp = {
+	.alloc_context		= lz4_alloc_context,
+	.free_context		= lz4_free_context,
+	.compress		= __lz4_compress_crypto,
+	.decompress		= __lz4_decompress_crypto,
+	.flags			= CCOMP_TYPE_DECOMP_NOCTX,
+	.base			= {
+		.cra_name	= "lz4",
+		.cra_flags	= CRYPTO_ALG_TYPE_CCOMPRESS,
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
+	ret = crypto_register_ccomp(&ccomp);
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
+	crypto_unregister_ccomp(&ccomp);
 }
 
 module_init(lz4_mod_init);
-- 
1.9.1
