From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 1/8] crypto: support (de)compression API that doesn't require tfm object
Date: Thu, 20 Aug 2015 15:34:57 +0900
Message-ID: <1440052504-15442-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34649 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbbHTGfY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 02:35:24 -0400
In-Reply-To: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Until now, tfm object embeds (de)compression context in it and
(de)compression in crypto API requires tfm object to use
this context. But, there are some algorithms that doesn't need
such context to operate. Therefore, this patch introduce new crypto
compression API that call (de)compression function via crypto_alg,
instead of tfm object. crypto_alg is required to get appropriate
(de)compression function pointer. This can reduce overhead of
maintaining multiple tfm if (de)compression doesn't require
any context to operate.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/842.c           |  4 +++-
 crypto/compress.c      | 20 ++++++++++++++++++++
 crypto/crypto_null.c   |  4 +++-
 crypto/deflate.c       |  4 +++-
 crypto/lz4.c           |  4 +++-
 crypto/lz4hc.c         |  4 +++-
 crypto/lzo.c           |  4 +++-
 include/linux/crypto.h | 31 +++++++++++++++++++++++++++++++
 8 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..b6503ea 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -61,7 +61,9 @@ static struct crypto_alg alg = {
 	.cra_module		= THIS_MODULE,
 	.cra_u			= { .compress = {
 	.coa_compress		= crypto842_compress,
-	.coa_decompress		= crypto842_decompress } }
+	.coa_decompress		= crypto842_decompress,
+	.coa_compress_noctx	= NULL,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init crypto842_mod_init(void)
diff --git a/crypto/compress.c b/crypto/compress.c
index c33f076..f27eee0 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -33,6 +33,26 @@ static int crypto_decompress(struct crypto_tfm *tfm,
 	                                                   dlen);
 }
 
+struct crypto_alg *crypto_get_comp(const char *alg_name, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_COMPRESS;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	alg = crypto_alg_mod_lookup(alg_name, type, mask);
+	if (!IS_ERR(alg))
+		return alg;
+
+	return NULL;
+}
+
+void crypto_put_comp(struct crypto_alg *alg)
+{
+	crypto_mod_put(alg);
+}
+
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops = &tfm->crt_compress;
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 941c9a4..e397d1c 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -146,7 +146,9 @@ static struct crypto_alg null_algs[3] = { {
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .compress = {
 	.coa_compress		=	null_compress,
-	.coa_decompress		=	null_compress } }
+	.coa_decompress		=	null_compress,
+	.coa_compress_noctx	=	NULL,
+	.coa_decompress_noctx	=	NULL } }
 } };
 
 MODULE_ALIAS_CRYPTO("compress_null");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 95d8d37..dee4daf 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -203,7 +203,9 @@ static struct crypto_alg alg = {
 	.cra_exit		= deflate_exit,
 	.cra_u			= { .compress = {
 	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+	.coa_decompress		= deflate_decompress,
+	.coa_compress_noctx	= NULL,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init deflate_mod_init(void)
diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..1848435 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -86,7 +86,9 @@ static struct crypto_alg alg_lz4 = {
 	.cra_exit		= lz4_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
+	.coa_decompress		= lz4_decompress_crypto,
+	.coa_compress_noctx	= NULL,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lz4_mod_init(void)
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index a1d3b5b..bcf0baa 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -86,7 +86,9 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_exit		= lz4hc_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4hc_compress_crypto,
-	.coa_decompress		= lz4hc_decompress_crypto } }
+	.coa_decompress		= lz4hc_decompress_crypto,
+	.coa_compress_noctx	= NULL,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lz4hc_mod_init(void)
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4b3e925..9ca516b 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -89,7 +89,9 @@ static struct crypto_alg alg = {
 	.cra_exit		= lzo_exit,
 	.cra_u			= { .compress = {
 	.coa_compress 		= lzo_compress,
-	.coa_decompress  	= lzo_decompress } }
+	.coa_decompress		= lzo_decompress,
+	.coa_compress_noctx	= NULL,
+	.coa_decompress_noctx	= NULL } }
 };
 
 static int __init lzo_mod_init(void)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 81ef938..9e68eb0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -405,6 +405,10 @@ struct compress_alg {
 			    unsigned int slen, u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
+	int (*coa_compress_noctx)(const u8 *src, unsigned int slen,
+				  u8 *dst, unsigned int *dlen);
+	int (*coa_decompress_noctx)(const u8 *src, unsigned int slen,
+				    u8 *dst, unsigned int *dlen);
 };
 
 
@@ -1888,6 +1892,9 @@ static inline void crypto_free_comp(struct crypto_comp *tfm)
 	crypto_free_tfm(crypto_comp_tfm(tfm));
 }
 
+struct crypto_alg *crypto_get_comp(const char *alg_name, u32 type, u32 mask);
+void crypto_put_comp(struct crypto_alg *alg);
+
 static inline int crypto_has_comp(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
@@ -1923,5 +1930,29 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline int crypto_has_compress_noctx(struct crypto_alg *alg)
+{
+	return !!alg->cra_compress.coa_compress_noctx;
+}
+
+static inline int crypto_has_decompress_noctx(struct crypto_alg *alg)
+{
+	return !!alg->cra_compress.coa_decompress_noctx;
+}
+
+static inline int crypto_comp_compress_noctx(struct crypto_alg *alg,
+					const u8 *src, unsigned int slen,
+					u8 *dst, unsigned int *dlen)
+{
+	return alg->cra_compress.coa_compress_noctx(src, slen, dst, dlen);
+}
+
+static inline int crypto_comp_decompress_noctx(struct crypto_alg *alg,
+					const u8 *src, unsigned int slen,
+					u8 *dst, unsigned int *dlen)
+{
+	return alg->cra_compress.coa_decompress_noctx(src, slen, dst, dlen);
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
1.9.1
