Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6A267F47
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945134; cv=none; b=MFA/lpVcrxc+5VfM9XsCZgbAdBvhQHkqayXuy2g3NZt1SjiHokEGLo3hDFxGgWnGS/HNFxZp/TPN8feUMKA1R7HU5HGQRtBY8D9Ch75e1w1+V8uSp6lYaeBah/9imeq5LSo2/sUDkZpyBaaOL9OZNCgDMJOoK8PaV5ln3FXmnqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945134; c=relaxed/simple;
	bh=xRCBjPeEWNSj8qaZObnkAoZdhlp0BFLe1A6A0RMDpX0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=oW2YEKqYla6NyiwwabrR20lBGOArlO88Qju5zwfsnxt0bZmmklTZkgrfeOh3Qj1drkhWXPjXx+vZnAfbx7Rr9oqw/frSKBT4skDt0MTH+oAjZrQnJOmqD8d1N0ojeYVQ0cg0Tr6Xq/i7VuVagVG2aPrhRAGJ6ha89+yTcz8Tb9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eBsYYUqP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eBsYYUqP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7d8z9s2NWVqXoDg2yi3Gb9c4v1eZW5YTUXOvjOowov0=; b=eBsYYUqPDI/sC/kthF4NV8H3u/
	VooW4SYd+0dc8c5544rcT09Gm7AvAbvY4Ft+hX7hTc/Z15D9qFiOE+o7yoUu6FHQM+06Q9C+9VGHC
	Xxd8Z4ZoV0Dn7FEfy+zM5IFyMSxP2sE9BtWacX8k/ZbLOsRWdjWtTDHCEvei5gR0rUx7dGrUDl7ZS
	6TWByeoLgReXO+lewJavmVVgdJyrxrUHMO9dqDRW0dMKybPPZzB0FJiQ09v39nbEC+BU/DfeqkVCU
	dXWc1k9REZXOmFyz9rKn9iB9eHQDL/7lje5aBWt7wvQMfpHiSDrt95/0ljgvSPvdL8/rD81rNssSP
	flt33JCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwF-00Ge2e-3D;
	Fri, 18 Apr 2025 10:58:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:47 +0800
Date: Fri, 18 Apr 2025 10:58:47 +0800
Message-Id: <126dad850cd539475ac83bc210f8effe53c4ce4e.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 04/67] crypto: ghash-generic - Use API partial block
 handling
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

