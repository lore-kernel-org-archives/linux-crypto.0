From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 1/9] crypto: introduce decompression API that can be called via sharable tfm object
Date: Fri, 18 Sep 2015 14:19:16 +0900
Message-ID: <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Until now, tfm object embeds (de)compression context in it and
(de)compression in crypto API requires tfm object to use
this context. But, there are some algorithms that doesn't need
such context to operate. Therefore, this patch introduce new crypto
decompression API that calls decompression function via sharable tfm
object. Concurrent calls to decompress_noctx function through sharable
tfm object will be okay because caller don't need any context in tfm and
tfm is only used for fetching function pointer to decompress_noctx
function. This can reduce overhead of maintaining multiple tfm
if decompression doesn't require any context to operate.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/842.c           |  3 ++-
 crypto/compress.c      | 36 ++++++++++++++++++++++++++++++++++++
 crypto/crypto_null.c   |  3 ++-
 crypto/deflate.c       |  3 ++-
 crypto/lz4.c           |  3 ++-
 crypto/lz4hc.c         |  3 ++-
 crypto/lzo.c           |  3 ++-
 include/linux/crypto.h | 20 ++++++++++++++++++++
 8 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..1b6cdab 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -61,7 +61,8 @@ static struct crypto_alg alg = {
 	.cra_module		= THIS_MODULE,
 	.cra_u			= { .compress = {
 	.coa_compress		= crypto842_compress,
-	.coa_decompress		= crypto842_decompress } }
+	.coa_decompress		= crypto842_decompress,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init crypto842_mod_init(void)
diff --git a/crypto/compress.c b/crypto/compress.c
index c33f076..abb36a8 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -33,12 +33,21 @@ static int crypto_decompress(struct crypto_tfm *tfm,
 	                                                   dlen);
 }
 
+static int crypto_decompress_noctx(struct crypto_tfm *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen)
+{
+	return tfm->__crt_alg->cra_compress.coa_decompress_noctx(src, slen,
+								dst, dlen);
+}
+
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops = &tfm->crt_compress;
 
 	ops->cot_compress = crypto_compress;
 	ops->cot_decompress = crypto_decompress;
+	ops->cot_decompress_noctx = NULL;
 
 	return 0;
 }
@@ -46,3 +55,30 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm)
 void crypto_exit_compress_ops(struct crypto_tfm *tfm)
 {
 }
+
+struct crypto_comp *crypto_alloc_comp_noctx(const char *alg_name,
+					u32 type, u32 mask)
+{
+	struct crypto_comp *comp;
+	struct crypto_tfm *tfm;
+	struct compress_tfm *ops;
+
+	comp = crypto_alloc_comp(alg_name, type, mask);
+	if (IS_ERR(comp))
+		return comp;
+
+	tfm = crypto_comp_tfm(comp);
+	if (!tfm->__crt_alg->cra_compress.coa_decompress_noctx) {
+		crypto_free_comp(comp);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ops = &tfm->crt_compress;
+
+	/* Only allow noctx ops to comp_noctx */
+	ops->cot_compress = NULL;
+	ops->cot_decompress = NULL;
+	ops->cot_decompress_noctx = crypto_decompress_noctx;
+
+	return comp;
+}
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 941c9a4..3560b75 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -146,7 +146,8 @@ static struct crypto_alg null_algs[3] = { {
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .compress = {
 	.coa_compress		=	null_compress,
-	.coa_decompress		=	null_compress } }
+	.coa_decompress		=	null_compress,
+	.coa_decompress_noctx	=	NULL } }
 } };
 
 MODULE_ALIAS_CRYPTO("compress_null");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 95d8d37..c0b0a40 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -203,7 +203,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= deflate_exit,
 	.cra_u			= { .compress = {
 	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+	.coa_decompress		= deflate_decompress,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init deflate_mod_init(void)
diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..d38ce2a 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -86,7 +86,8 @@ static struct crypto_alg alg_lz4 = {
 	.cra_exit		= lz4_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
+	.coa_decompress		= lz4_decompress_crypto,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lz4_mod_init(void)
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index a1d3b5b..0cb38a7 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -86,7 +86,8 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_exit		= lz4hc_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4hc_compress_crypto,
-	.coa_decompress		= lz4hc_decompress_crypto } }
+	.coa_decompress		= lz4hc_decompress_crypto,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lz4hc_mod_init(void)
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4b3e925..ec0f7b3 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -89,7 +89,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= lzo_exit,
 	.cra_u			= { .compress = {
 	.coa_compress 		= lzo_compress,
-	.coa_decompress  	= lzo_decompress } }
+	.coa_decompress		= lzo_decompress,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lzo_mod_init(void)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e71cb70..31152b1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -355,6 +355,8 @@ struct compress_alg {
 			    unsigned int slen, u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
+	int (*coa_decompress_noctx)(const u8 *src, unsigned int slen,
+				    u8 *dst, unsigned int *dlen);
 };
 
 
@@ -538,6 +540,9 @@ struct compress_tfm {
 	int (*cot_decompress)(struct crypto_tfm *tfm,
 	                      const u8 *src, unsigned int slen,
 	                      u8 *dst, unsigned int *dlen);
+	int (*cot_decompress_noctx)(struct crypto_tfm *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen);
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
@@ -1836,6 +1841,14 @@ static inline void crypto_free_comp(struct crypto_comp *tfm)
 	crypto_free_tfm(crypto_comp_tfm(tfm));
 }
 
+struct crypto_comp *crypto_alloc_comp_noctx(const char *alg_name,
+					u32 type, u32 mask);
+
+static inline void crypto_free_comp_noctx(struct crypto_comp *tfm)
+{
+	crypto_free_comp(tfm);
+}
+
 static inline int crypto_has_comp(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -1871,5 +1884,12 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline int crypto_comp_decompress_noctx(struct crypto_comp *tfm,
+					const u8 *src, unsigned int slen,
+					u8 *dst, unsigned int *dlen)
+{
+	return crypto_comp_crt(tfm)->cot_decompress_noctx(crypto_comp_tfm(tfm),
+							src, slen, dst, dlen);
+}
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
1.9.1
