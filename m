Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B12229B13
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785778; cv=none; b=tLV/chOhnbJvU/9Dno0gREMfnTM5TsXREnQjbOVIjNOFEbYpZjC+EzR80uk7n7XYK+Igc2DxAtnZ8BtKkDYL5jhEFdOxqoIYwUt/1Y5CJ65J2VlcrEtfmPXtf3DuEkM/9i8j5ZuJqhhvfWo5h7PGVt756nmvt6elgn8YvTggTOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785778; c=relaxed/simple;
	bh=xRCBjPeEWNSj8qaZObnkAoZdhlp0BFLe1A6A0RMDpX0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Yt2sIN7bOYl8WScctycJBLvJse88D/U5T99dZQlONBtD6B0MhbELF5esd3PG+sJuscZ/SHTC7P82XHa3sPzqOP2xcE/aAZi78KRgVKQUgrbHGwkRu0ZEuHyC/3kA+ZzraoxARpMa547XCTpV3yR1+JxccreGcPH3qgPNGcxkyz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z2Eh45Sm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z2Eh45Sm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7d8z9s2NWVqXoDg2yi3Gb9c4v1eZW5YTUXOvjOowov0=; b=Z2Eh45SmtFrK2Jk2JBM/Xntisi
	Va+fczgI0vWd74wP/B1zVT+kxHG9ygkLCxE2++Vx+phfe3F8uQJu3cn7THHUTm/FfkQJT+4Vw2CsK
	VUzHWg6fuDtHD13TPEQ3Wog0oRadzl9BWWqDipu+JUbPWFX9j6zjxGAleH9UMjR0IcCd8d0c7qCyy
	Ex6yu6q8ykpEp7xS1ghIKGa+3jTvPwkuuwOrzhdp987qOY34JzR1J3xoJwrbqGB2VayINh1+hqQfc
	0ccDF4XQ7GDt0qsOKoZFEZjvc6FjOllH8dSf2xvI8SooPW61nsTgPfHfjrutGqb3dGtNfWOZIVrQV
	dAnqPeMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wU0-00G6H1-0L;
	Wed, 16 Apr 2025 14:42:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:42:52 +0800
Date: Wed, 16 Apr 2025 14:42:52 +0800
Message-Id: <5323accefaa805b6f0c94c330aae7cf0f04eb163.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 04/67] crypto: ghash-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ghash-generic.c | 56 +++++++++++++-----------------------------
 include/crypto/ghash.h |  3 ++-
 2 files changed, 19 insertions(+), 40 deletions(-)

diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index c70d163c1ac9..b5fc20a0dafc 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -34,14 +34,14 @@
  *     (https://csrc.nist.gov/publications/detail/sp/800-38d/final)
  */
 
-#include <crypto/algapi.h>
 #include <crypto/gf128mul.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/hash.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
+#include <crypto/utils.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -82,59 +82,36 @@ static int ghash_update(struct shash_desc *desc,
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *dst = dctx->buffer;
 
-	if (dctx->bytes) {
-		int n = min(srclen, dctx->bytes);
-		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		dctx->bytes -= n;
-		srclen -= n;
-
-		while (n--)
-			*pos++ ^= *src++;
-
-		if (!dctx->bytes)
-			gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-	}
-
-	while (srclen >= GHASH_BLOCK_SIZE) {
+	do {
 		crypto_xor(dst, src, GHASH_BLOCK_SIZE);
 		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
 		src += GHASH_BLOCK_SIZE;
 		srclen -= GHASH_BLOCK_SIZE;
-	}
+	} while (srclen >= GHASH_BLOCK_SIZE);
 
-	if (srclen) {
-		dctx->bytes = GHASH_BLOCK_SIZE - srclen;
-		while (srclen--)
-			*dst++ ^= *src++;
-	}
-
-	return 0;
+	return srclen;
 }
 
-static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+static void ghash_flush(struct shash_desc *desc, const u8 *src,
+			unsigned int len)
 {
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 	u8 *dst = dctx->buffer;
 
-	if (dctx->bytes) {
-		u8 *tmp = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		while (dctx->bytes--)
-			*tmp++ ^= 0;
-
+	if (len) {
+		crypto_xor(dst, src, len);
 		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
 	}
-
-	dctx->bytes = 0;
 }
 
-static int ghash_final(struct shash_desc *desc, u8 *dst)
+static int ghash_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *dst)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *buf = dctx->buffer;
 
-	ghash_flush(ctx, dctx);
+	ghash_flush(desc, src, len);
 	memcpy(dst, buf, GHASH_BLOCK_SIZE);
 
 	return 0;
@@ -151,13 +128,14 @@ static struct shash_alg ghash_alg = {
 	.digestsize	= GHASH_DIGEST_SIZE,
 	.init		= ghash_init,
 	.update		= ghash_update,
-	.final		= ghash_final,
+	.finup		= ghash_finup,
 	.setkey		= ghash_setkey,
 	.descsize	= sizeof(struct ghash_desc_ctx),
 	.base		= {
 		.cra_name		= "ghash",
 		.cra_driver_name	= "ghash-generic",
 		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct ghash_ctx),
 		.cra_module		= THIS_MODULE,
diff --git a/include/crypto/ghash.h b/include/crypto/ghash.h
index f832c9f2aca3..16904f2b5184 100644
--- a/include/crypto/ghash.h
+++ b/include/crypto/ghash.h
@@ -12,13 +12,14 @@
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
 
+struct gf128mul_4k;
+
 struct ghash_ctx {
 	struct gf128mul_4k *gf128;
 };
 
 struct ghash_desc_ctx {
 	u8 buffer[GHASH_BLOCK_SIZE];
-	u32 bytes;
 };
 
 #endif
-- 
2.39.5

