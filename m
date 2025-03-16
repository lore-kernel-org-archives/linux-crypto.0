Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166E9D517
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088072; cv=none; b=Woxh9VcprbW85XPLSuqQ4A0YfJB4vVIpGdZZYHFiKbnWgL82KEMvQtn2GyEWOqoRgTbie4zVZv7j7fPbm3PqJQF95i6BcvVOAnh4TdCACpxGNJbN4kvi5zRQzHkxJ3xTxgA3fXOFMMdrNpPIt/gdHqqNXKllOU3Ar5ibElFYWo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088072; c=relaxed/simple;
	bh=OWxwBSs5yrJHFMESk/oWN89hrJqeBHHpgjXAwq8zFmM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=r59QD20jJscz7MG9iiVWVInYJXZj4OdyguL/Y0wRWaCTug9MzMvs7U0LOlPLOcZaiRK+jCRi/EWf+9fxrAKV5kX729PCVh33l8V4YaJMKmIQ76BEYn94EKCXn3q07ol25CVT1WtB5mTsotlqC6R2fieEFDwv/8hSvu4kFLhoDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Gzi6K1mn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Gzi6K1mn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d5d5VAeCgWYD4f2Bh8b3RIyc3Yo5MgtALdWgCZRLegs=; b=Gzi6K1mn/CSTTWxLciOb96QkQS
	kRYecWPY64XinWc8idVd31Xg1r2HOEIH8P9wegfGbhLBGDJ1Dz6eY2Z155p5+cT8H+m3x7iaqa8ZV
	4mzb+53qPs4G/DlIswpajfWci6PkYjn1JtjQ0ugucNAHYJ42GaEfLroB03HI98a6o9wsNRFv1ES4e
	eLT2gT8W2sYAZ9LIzwSjpT6Di+PwhsYZVvtPoOJkFXGRti/I18wZMvhV2lsPQ5I0VUkQNJYnu2FsE
	CjYev6agcoVSEbow0DHKojBgktL9cUcIrbfiNE0mXylMQMtuevyBfQHkPKWww5TQV4KVX3BVpDDX7
	QoNvjBVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgc-006xYL-0y;
	Sun, 16 Mar 2025 09:21:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:06 +0800
Date: Sun, 16 Mar 2025 09:21:06 +0800
Message-Id: <b6e08614af26f82f9bedcb76f28c6c51a7728aee.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 02/11] crypto: 842 - drop obsolete 'comp' implementation
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
 crypto/842.c | 66 ++--------------------------------------------------
 1 file changed, 2 insertions(+), 64 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 2238478c3493..5fb37a925989 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -18,11 +18,10 @@
  * drivers/crypto/nx/nx-842-crypto.c
  */
 
+#include <crypto/internal/scompress.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 #include <linux/sw842.h>
-#include <crypto/internal/scompress.h>
 
 struct crypto842_ctx {
 	void *wmem;	/* working memory for compress */
@@ -39,38 +38,11 @@ static void *crypto842_alloc_ctx(void)
 	return ctx;
 }
 
-static int crypto842_init(struct crypto_tfm *tfm)
-{
-	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->wmem = crypto842_alloc_ctx();
-	if (IS_ERR(ctx->wmem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void crypto842_free_ctx(void *ctx)
 {
 	kfree(ctx);
 }
 
-static void crypto842_exit(struct crypto_tfm *tfm)
-{
-	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto842_free_ctx(ctx->wmem);
-}
-
-static int crypto842_compress(struct crypto_tfm *tfm,
-			      const u8 *src, unsigned int slen,
-			      u8 *dst, unsigned int *dlen)
-{
-	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return sw842_compress(src, slen, dst, dlen, ctx->wmem);
-}
-
 static int crypto842_scompress(struct crypto_scomp *tfm,
 			       const u8 *src, unsigned int slen,
 			       u8 *dst, unsigned int *dlen, void *ctx)
@@ -78,13 +50,6 @@ static int crypto842_scompress(struct crypto_scomp *tfm,
 	return sw842_compress(src, slen, dst, dlen, ctx);
 }
 
-static int crypto842_decompress(struct crypto_tfm *tfm,
-				const u8 *src, unsigned int slen,
-				u8 *dst, unsigned int *dlen)
-{
-	return sw842_decompress(src, slen, dst, dlen);
-}
-
 static int crypto842_sdecompress(struct crypto_scomp *tfm,
 				 const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
@@ -92,20 +57,6 @@ static int crypto842_sdecompress(struct crypto_scomp *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "842",
-	.cra_driver_name	= "842-generic",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct crypto842_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= crypto842_init,
-	.cra_exit		= crypto842_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= crypto842_compress,
-	.coa_decompress		= crypto842_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= crypto842_alloc_ctx,
 	.free_ctx		= crypto842_free_ctx,
@@ -121,25 +72,12 @@ static struct scomp_alg scomp = {
 
 static int __init crypto842_mod_init(void)
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
 subsys_initcall(crypto842_mod_init);
 
 static void __exit crypto842_mod_exit(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 module_exit(crypto842_mod_exit);
-- 
2.39.5

