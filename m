Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC63249E5
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088081; cv=none; b=IxRNWagFRu1BPggLB++t58BxA1gx+QpxJAsiiJtHI0/YUTPNtJl5j2hTpmAhTe8Dq4Nb2taxH9cTBot4wqC0ffJ068yGZzgLjvzxVV3rqZ4EFpwcovJypgiM+E3Ej07caO03IShUMK5pJelpdvClLuZDBVEtQ2IH2pqBD+pogeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088081; c=relaxed/simple;
	bh=JfD3mETw+9k+MzrwdltGhr+3yNquSUqi0vGXbr1cNtU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=p5IMdiSJuKsfuKWgUqr1jOYtwAVaas/Q6R15vcD7rayIq79FslDk/OdYNUy7taFSXuVfmCx7XANYhJ1mvv96fEXllTzgRCkgrY0NFpUkz0+7UpMQGMY61KVdqEkTqhdTpA1y5gp9XDcHOJ2ePEmRCZZOR0MBtzktrDyebT2CGyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mRe033wV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mRe033wV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2mfij2NPdvG3NDjvch7/zZ7PYqwG1Jxyu8Z1MZIC9MA=; b=mRe033wV8ZjI9xFrMSwx8FnG8R
	Jmb0hpNqgxtIuskZKPj3B9H4Uevl63r8azBzW/jYKfRaagZ/iSyrLAXQkXf8xJiTHWkA13udYNRal
	wwqbmwsxzshz/uucgEWha5AetiJLIuhLM6nj6igrdgGmTgMcDcNjAzMxmG0fkAZMDRHDLqvSNVgZV
	NljXFsj6n4jKrXUBK1o4K6qYyg5P5jAfbTmZvcs12QwTB551t5Xj/TSYMHjox5YwX/0oJ9SUDjLmP
	0GIhasBM9DOPf2Lbivif/8wlSCr1XLbW5+LqDqv5hWFOQ0TqVRmW7WKpr5gkfhuIo/Fx5lMQEecfL
	peqkKakg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgl-006xZ9-1b;
	Sun, 16 Mar 2025 09:21:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:15 +0800
Date: Sun, 16 Mar 2025 09:21:15 +0800
Message-Id: <5f907db401131a2ad0931d13a93b9deeabf5ecea.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/11] crypto: lzo-rle - drop obsolete 'comp' implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The 'comp' API is obsolete and will be removed, so remove this comp
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lzo-rle.c | 70 ++++--------------------------------------------
 1 file changed, 5 insertions(+), 65 deletions(-)

diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 6c845e7d32f5..b1350ae278b8 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -3,13 +3,11 @@
  * Cryptographic API.
  */
 
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/crypto.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-#include <linux/lzo.h>
 #include <crypto/internal/scompress.h>
+#include <linux/init.h>
+#include <linux/lzo.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 
 struct lzorle_ctx {
 	void *lzorle_comp_mem;
@@ -26,29 +24,11 @@ static void *lzorle_alloc_ctx(void)
 	return ctx;
 }
 
-static int lzorle_init(struct crypto_tfm *tfm)
-{
-	struct lzorle_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->lzorle_comp_mem = lzorle_alloc_ctx();
-	if (IS_ERR(ctx->lzorle_comp_mem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void lzorle_free_ctx(void *ctx)
 {
 	kvfree(ctx);
 }
 
-static void lzorle_exit(struct crypto_tfm *tfm)
-{
-	struct lzorle_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lzorle_free_ctx(ctx->lzorle_comp_mem);
-}
-
 static int __lzorle_compress(const u8 *src, unsigned int slen,
 			  u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -64,14 +44,6 @@ static int __lzorle_compress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int lzorle_compress(struct crypto_tfm *tfm, const u8 *src,
-			unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct lzorle_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __lzorle_compress(src, slen, dst, dlen, ctx->lzorle_comp_mem);
-}
-
 static int lzorle_scompress(struct crypto_scomp *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen,
 			 void *ctx)
@@ -94,12 +66,6 @@ static int __lzorle_decompress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int lzorle_decompress(struct crypto_tfm *tfm, const u8 *src,
-			  unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	return __lzorle_decompress(src, slen, dst, dlen);
-}
-
 static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			   unsigned int slen, u8 *dst, unsigned int *dlen,
 			   void *ctx)
@@ -107,19 +73,6 @@ static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lzorle_decompress(src, slen, dst, dlen);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "lzo-rle",
-	.cra_driver_name	= "lzo-rle-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct lzorle_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= lzorle_init,
-	.cra_exit		= lzorle_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= lzorle_compress,
-	.coa_decompress		= lzorle_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lzorle_alloc_ctx,
 	.free_ctx		= lzorle_free_ctx,
@@ -134,24 +87,11 @@ static struct scomp_alg scomp = {
 
 static int __init lzorle_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit lzorle_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

