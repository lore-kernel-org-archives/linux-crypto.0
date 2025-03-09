Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE57022301
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488201; cv=none; b=u8tNhmpAXc+n9wzW8Z7eXRpvkkR1rphW8v7IW6QH/QOkcpsxvtJzqrulMbdQC+MXS3j9At2ifJcfahLg/Z7PiT4oM+h+O8YAVvZPv0P86Ks1BAPcizNY3WcFKdWzxERlr3H75ciag32T7M4rGK27LYWUd1Q+/JzBdmUbGdcSwY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488201; c=relaxed/simple;
	bh=yA1PMgcpyIavX/uDGlsAgc/uw6aPGrEk7H2GHeqglPo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=rUFMhER8/E847N9obGG7F9Fm5vlktw2INbi0OcO7YoqSwjDnGKM7gtlFwbt4GWFtMBLhjm/bGvQdY43ZKU/4sArMaPiijmIMqhZcxLREgq9WvAX/8CSIBCxPIlt1qR1tu1nF6NIGqc9njqr23pbEJ3YY7C/oNErR5i9RZAHQ06o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=STwswDA7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="STwswDA7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vUZ1xah0Y1qdQ3OhSRGhNKU3gwcbkAMcP7wK/CvqsBo=; b=STwswDA7v4JJQRLbyghs6QM4tO
	FcXn7J1hvymF1zh27idSX+KGtS85HunGT0nGHL957aU1O9H2EYb17hcYsO47RNdUnUtNOAlL3YYGS
	KD4v/BfQ3YNcVfZ64GpYk8JQBKIPbDZET5LM3rtrDb3tqLdLf3I1ycCoXpTquEZkjpkBWHnqLHj0Z
	LBRXItJycsF4Pvu5T0kbtZhgxxXq8lEZLpHZT0XXNed5OrKZ+TDl10MBG9lc+qeaoF/AJ8zWhNncU
	IvP5g6F96IkfpIFppR4D777KXZDDfKU4nh1GzOS2VSokU+JoHDi3ORS0IJmxPKzhsUshT8NReFyS7
	iKxlOKyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dG-004zHO-2R;
	Sun, 09 Mar 2025 10:43:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:14 +0800
Date: Sun, 09 Mar 2025 10:43:14 +0800
Message-Id: <efd97117f90d2523a8af9d0f2b4510679708d7d1.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 2/8] crypto: scomp - Remove tfm argument from
 alloc/free_ctx
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The tfm argument is completely unused and meaningless as the
same stream object is identical over all transforms of a given
algorithm.  Remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/842.c                           | 8 ++++----
 crypto/deflate.c                       | 4 ++--
 crypto/lz4.c                           | 8 ++++----
 crypto/lz4hc.c                         | 8 ++++----
 crypto/lzo-rle.c                       | 8 ++++----
 crypto/lzo.c                           | 8 ++++----
 crypto/zstd.c                          | 4 ++--
 drivers/crypto/cavium/zip/zip_crypto.c | 6 +++---
 drivers/crypto/cavium/zip/zip_crypto.h | 6 +++---
 include/crypto/internal/scompress.h    | 8 ++++----
 10 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index e59e54d76960..2238478c3493 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -28,7 +28,7 @@ struct crypto842_ctx {
 	void *wmem;	/* working memory for compress */
 };
 
-static void *crypto842_alloc_ctx(struct crypto_scomp *tfm)
+static void *crypto842_alloc_ctx(void)
 {
 	void *ctx;
 
@@ -43,14 +43,14 @@ static int crypto842_init(struct crypto_tfm *tfm)
 {
 	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->wmem = crypto842_alloc_ctx(NULL);
+	ctx->wmem = crypto842_alloc_ctx();
 	if (IS_ERR(ctx->wmem))
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void crypto842_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void crypto842_free_ctx(void *ctx)
 {
 	kfree(ctx);
 }
@@ -59,7 +59,7 @@ static void crypto842_exit(struct crypto_tfm *tfm)
 {
 	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto842_free_ctx(NULL, ctx->wmem);
+	crypto842_free_ctx(ctx->wmem);
 }
 
 static int crypto842_compress(struct crypto_tfm *tfm,
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 98e8bcb81a6a..1bf7184ad670 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -112,7 +112,7 @@ static int __deflate_init(void *ctx)
 	return ret;
 }
 
-static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
+static void *deflate_alloc_ctx(void)
 {
 	struct deflate_ctx *ctx;
 	int ret;
@@ -143,7 +143,7 @@ static void __deflate_exit(void *ctx)
 	deflate_decomp_exit(ctx);
 }
 
-static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void deflate_free_ctx(void *ctx)
 {
 	__deflate_exit(ctx);
 	kfree_sensitive(ctx);
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 0606f8862e78..e66c6d1ba34f 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -16,7 +16,7 @@ struct lz4_ctx {
 	void *lz4_comp_mem;
 };
 
-static void *lz4_alloc_ctx(struct crypto_scomp *tfm)
+static void *lz4_alloc_ctx(void)
 {
 	void *ctx;
 
@@ -31,14 +31,14 @@ static int lz4_init(struct crypto_tfm *tfm)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lz4_comp_mem = lz4_alloc_ctx(NULL);
+	ctx->lz4_comp_mem = lz4_alloc_ctx();
 	if (IS_ERR(ctx->lz4_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void lz4_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void lz4_free_ctx(void *ctx)
 {
 	vfree(ctx);
 }
@@ -47,7 +47,7 @@ static void lz4_exit(struct crypto_tfm *tfm)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	lz4_free_ctx(NULL, ctx->lz4_comp_mem);
+	lz4_free_ctx(ctx->lz4_comp_mem);
 }
 
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index d7cc94aa2fcf..25a95b65aca5 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -15,7 +15,7 @@ struct lz4hc_ctx {
 	void *lz4hc_comp_mem;
 };
 
-static void *lz4hc_alloc_ctx(struct crypto_scomp *tfm)
+static void *lz4hc_alloc_ctx(void)
 {
 	void *ctx;
 
@@ -30,14 +30,14 @@ static int lz4hc_init(struct crypto_tfm *tfm)
 {
 	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lz4hc_comp_mem = lz4hc_alloc_ctx(NULL);
+	ctx->lz4hc_comp_mem = lz4hc_alloc_ctx();
 	if (IS_ERR(ctx->lz4hc_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void lz4hc_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void lz4hc_free_ctx(void *ctx)
 {
 	vfree(ctx);
 }
@@ -46,7 +46,7 @@ static void lz4hc_exit(struct crypto_tfm *tfm)
 {
 	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	lz4hc_free_ctx(NULL, ctx->lz4hc_comp_mem);
+	lz4hc_free_ctx(ctx->lz4hc_comp_mem);
 }
 
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 0abc2d87f042..6c845e7d32f5 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -15,7 +15,7 @@ struct lzorle_ctx {
 	void *lzorle_comp_mem;
 };
 
-static void *lzorle_alloc_ctx(struct crypto_scomp *tfm)
+static void *lzorle_alloc_ctx(void)
 {
 	void *ctx;
 
@@ -30,14 +30,14 @@ static int lzorle_init(struct crypto_tfm *tfm)
 {
 	struct lzorle_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lzorle_comp_mem = lzorle_alloc_ctx(NULL);
+	ctx->lzorle_comp_mem = lzorle_alloc_ctx();
 	if (IS_ERR(ctx->lzorle_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void lzorle_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void lzorle_free_ctx(void *ctx)
 {
 	kvfree(ctx);
 }
@@ -46,7 +46,7 @@ static void lzorle_exit(struct crypto_tfm *tfm)
 {
 	struct lzorle_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	lzorle_free_ctx(NULL, ctx->lzorle_comp_mem);
+	lzorle_free_ctx(ctx->lzorle_comp_mem);
 }
 
 static int __lzorle_compress(const u8 *src, unsigned int slen,
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 8338851c7406..035d62e2afe0 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -15,7 +15,7 @@ struct lzo_ctx {
 	void *lzo_comp_mem;
 };
 
-static void *lzo_alloc_ctx(struct crypto_scomp *tfm)
+static void *lzo_alloc_ctx(void)
 {
 	void *ctx;
 
@@ -30,14 +30,14 @@ static int lzo_init(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lzo_comp_mem = lzo_alloc_ctx(NULL);
+	ctx->lzo_comp_mem = lzo_alloc_ctx();
 	if (IS_ERR(ctx->lzo_comp_mem))
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void lzo_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void lzo_free_ctx(void *ctx)
 {
 	kvfree(ctx);
 }
@@ -46,7 +46,7 @@ static void lzo_exit(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	lzo_free_ctx(NULL, ctx->lzo_comp_mem);
+	lzo_free_ctx(ctx->lzo_comp_mem);
 }
 
 static int __lzo_compress(const u8 *src, unsigned int slen,
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 154a969c83a8..68a093427944 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -103,7 +103,7 @@ static int __zstd_init(void *ctx)
 	return ret;
 }
 
-static void *zstd_alloc_ctx(struct crypto_scomp *tfm)
+static void *zstd_alloc_ctx(void)
 {
 	int ret;
 	struct zstd_ctx *ctx;
@@ -134,7 +134,7 @@ static void __zstd_exit(void *ctx)
 	zstd_decomp_exit(ctx);
 }
 
-static void zstd_free_ctx(struct crypto_scomp *tfm, void *ctx)
+static void zstd_free_ctx(void *ctx)
 {
 	__zstd_exit(ctx);
 	kfree_sensitive(ctx);
diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
index 1046a746d36f..a9c3efce8f2d 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.c
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -236,7 +236,7 @@ int  zip_comp_decompress(struct crypto_tfm *tfm,
 } /* Legacy compress framework end */
 
 /* SCOMP framework start */
-void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm)
+void *zip_alloc_scomp_ctx_deflate(void)
 {
 	int ret;
 	struct zip_kernel_ctx *zip_ctx;
@@ -255,7 +255,7 @@ void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm)
 	return zip_ctx;
 }
 
-void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm)
+void *zip_alloc_scomp_ctx_lzs(void)
 {
 	int ret;
 	struct zip_kernel_ctx *zip_ctx;
@@ -274,7 +274,7 @@ void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm)
 	return zip_ctx;
 }
 
-void zip_free_scomp_ctx(struct crypto_scomp *tfm, void *ctx)
+void zip_free_scomp_ctx(void *ctx)
 {
 	struct zip_kernel_ctx *zip_ctx = ctx;
 
diff --git a/drivers/crypto/cavium/zip/zip_crypto.h b/drivers/crypto/cavium/zip/zip_crypto.h
index b59ddfcacd34..dbe20bfeb3e9 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.h
+++ b/drivers/crypto/cavium/zip/zip_crypto.h
@@ -67,9 +67,9 @@ int  zip_comp_decompress(struct crypto_tfm *tfm,
 			 const u8 *src, unsigned int slen,
 			 u8 *dst, unsigned int *dlen);
 
-void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm);
-void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm);
-void  zip_free_scomp_ctx(struct crypto_scomp *tfm, void *zip_ctx);
+void *zip_alloc_scomp_ctx_deflate(void);
+void *zip_alloc_scomp_ctx_lzs(void);
+void  zip_free_scomp_ctx(void *zip_ctx);
 int   zip_scomp_compress(struct crypto_scomp *tfm,
 			 const u8 *src, unsigned int slen,
 			 u8 *dst, unsigned int *dlen, void *ctx);
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 07a10fd2d321..6ba9974df7d3 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -31,8 +31,8 @@ struct crypto_scomp {
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
 struct scomp_alg {
-	void *(*alloc_ctx)(struct crypto_scomp *tfm);
-	void (*free_ctx)(struct crypto_scomp *tfm, void *ctx);
+	void *(*alloc_ctx)(void);
+	void (*free_ctx)(void *ctx);
 	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
 			unsigned int slen, u8 *dst, unsigned int *dlen,
 			void *ctx);
@@ -73,13 +73,13 @@ static inline struct scomp_alg *crypto_scomp_alg(struct crypto_scomp *tfm)
 
 static inline void *crypto_scomp_alloc_ctx(struct crypto_scomp *tfm)
 {
-	return crypto_scomp_alg(tfm)->alloc_ctx(tfm);
+	return crypto_scomp_alg(tfm)->alloc_ctx();
 }
 
 static inline void crypto_scomp_free_ctx(struct crypto_scomp *tfm,
 					 void *ctx)
 {
-	return crypto_scomp_alg(tfm)->free_ctx(tfm, ctx);
+	return crypto_scomp_alg(tfm)->free_ctx(ctx);
 }
 
 static inline int crypto_scomp_compress(struct crypto_scomp *tfm,
-- 
2.39.5

