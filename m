Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C972770B
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088083; cv=none; b=eC0cYM9jvAYPB3beN999u/SmfgXzPzjEGJ5fqTi1VEwW4TuQEQIHh9AtZ5Vn9JWKzZZf9ocMRPVlZMyjP7wksOLGCIWoSkZbmpMxQsILdaNQduEyf9WO17Vuq3hEsaOkGy4Roa2eq7HGVaX3d8F8fDjtQhL+JKr1TVV0ywJzkCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088083; c=relaxed/simple;
	bh=9yGbh7pqhSvNCuuDgKGC9TgfeLft6CJspiGgoWaLsT4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=IG5PiFq8XXrydFQZ8hWreG3pnGsb0vB+aRr1NQ1GCWgGhhSdXcqH1f2AOXM3cXgc4T0KT64aQ4RPojdXt5RrVp9td/acMHyHPWTIm7stScbrptcYD1lVl2HRst8RLXpBzVw2NcYHe7HGF69BshsSwSr6uVncCccTkKzGep0DjUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dwk8sEdN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dwk8sEdN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AZLAlhhbaYYv06HbeaLHLJckUHgbZBhFwJ6yl+6K4gc=; b=dwk8sEdN2gsMQQYRfi42+lGkCW
	W5w2PPQ7N2NmzuDJoOAYOhOGSZr8j8/GIYO23TAwzbDToA/JBnPLSXWjeqd4VRyh2mTIi7HfrEbfn
	zN2JAf95PyVkTqpmWf95ACjz4BACCy4QEgXf7nIAC1GVXKlB3OmllB+FytmsvW+Z8sulVNA9hYdO9
	wYnRC0ocm/pdOrVMt5tC3ologZj9DLf8ey7UUck+KbGpW453vTp6v8zlrbjndRb4Ig9uN3WAOulxR
	sc3Zqd7hcTigFMsTvUpdnsyZA92+fHmf3Whm74x8ZI5RVtSEXWz6Q6PzapTOiemNd+WfqZmMmdo4A
	PoECDIKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgn-006xZV-2f;
	Sun, 16 Mar 2025 09:21:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:17 +0800
Date: Sun, 16 Mar 2025 09:21:17 +0800
Message-Id: <0d0d0d3535c08c0350e993149d0acd32054d47cd.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 07/11] crypto: lzo - drop obsolete 'comp' implementation
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
 crypto/lzo.c | 70 ++++------------------------------------------------
 1 file changed, 5 insertions(+), 65 deletions(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 035d62e2afe0..dfe5a07ca35f 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
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
 
 struct lzo_ctx {
 	void *lzo_comp_mem;
@@ -26,29 +24,11 @@ static void *lzo_alloc_ctx(void)
 	return ctx;
 }
 
-static int lzo_init(struct crypto_tfm *tfm)
-{
-	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->lzo_comp_mem = lzo_alloc_ctx();
-	if (IS_ERR(ctx->lzo_comp_mem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void lzo_free_ctx(void *ctx)
 {
 	kvfree(ctx);
 }
 
-static void lzo_exit(struct crypto_tfm *tfm)
-{
-	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lzo_free_ctx(ctx->lzo_comp_mem);
-}
-
 static int __lzo_compress(const u8 *src, unsigned int slen,
 			  u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -64,14 +44,6 @@ static int __lzo_compress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
-			unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __lzo_compress(src, slen, dst, dlen, ctx->lzo_comp_mem);
-}
-
 static int lzo_scompress(struct crypto_scomp *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen,
 			 void *ctx)
@@ -94,12 +66,6 @@ static int __lzo_decompress(const u8 *src, unsigned int slen,
 	return 0;
 }
 
-static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
-			  unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	return __lzo_decompress(src, slen, dst, dlen);
-}
-
 static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			   unsigned int slen, u8 *dst, unsigned int *dlen,
 			   void *ctx)
@@ -107,19 +73,6 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lzo_decompress(src, slen, dst, dlen);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "lzo",
-	.cra_driver_name	= "lzo-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct lzo_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= lzo_init,
-	.cra_exit		= lzo_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= lzo_compress,
-	.coa_decompress		= lzo_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lzo_alloc_ctx,
 	.free_ctx		= lzo_free_ctx,
@@ -134,24 +87,11 @@ static struct scomp_alg scomp = {
 
 static int __init lzo_mod_init(void)
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
 
 static void __exit lzo_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.5

