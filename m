Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4685C221FCC
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491656; cv=none; b=r2GV/j8OLGQ88w3EmZrT3mplZLYvBGwh4Kw9qbpCjHmpnuc7hwTAPZZ0GtOqzZ01uuNN6vrYwy+pcrTxruMYNoOxTI2fsYDV95HIwn7akpz1kDY1ELiBUVZ7ci53OJhv/VsHP9HlK+mfENXXKNlYpcNcWdNUnu1IDpFwbLim9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491656; c=relaxed/simple;
	bh=1pfPyVZVRvHXTMzpTjLn7qatF+RMJ1aGTlpkru9PJk4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=k8u1Fr7yzgYpqYU0VeZ0rQOjRwlYF7g3YsuQE5VwJevlzznzAydBAAqffFEgxzvjHYuQfJmsBPAYw2xXukeA/t5dnHXlyx67ju05gp9fVvWTkwfyWe2yg2RsGaXL8RXVONXIfD4YlaMYTO3+3O21pHGU3yE+LUaTgux9mMfFJ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NPbnS3/y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NPbnS3/y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QcTf8gBn5TASfxlGhLjJaS9cqJZGrJ005HS2C+MIj9g=; b=NPbnS3/ymNfSiE46tx6hAHs3XQ
	fMqqklWxMo5DwsaHkf3Bywv7dhMtbN+K5WkWhIz4hUusqWBP3p3Q/IzQX6vw8ei6Ad0hT9GiGl7TP
	toDhYLwkq9KQCPlY9AhEZRshVCMDCc54n9MgEwmweC5ZvadoH88oXFv8GLw5B3Rg2MdlkYxTYq5qu
	iMcDK7Ga54BXprINQL+2onxFaKFORA6ERYEHuWTF+br7CuYZTowzjGtmQKb8PrXx96Ur6RL0IL1oV
	GiPj6tFQWyyjGnpEWxum1ueSOvfHBtNhKX1QVeRIEL0ML/Urba2DkiojwuqOBvTG8k57UmRNKFJVj
	fvuKV6iw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u78-000fOg-2g;
	Thu, 24 Apr 2025 18:47:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:30 +0800
Date: Thu, 24 Apr 2025 18:47:30 +0800
Message-Id: <18dd6ca13b6924cd28be515dc49d18edf8c85664.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/15] crypto: polyval-generic - Use API partial block
 handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

The accelerated export format on x86/arm64 is easier to use so
switch the generic polyval algorithm to use that format instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/polyval-generic.c | 120 +++++++++++++--------------------------
 include/crypto/polyval.h |   8 ---
 2 files changed, 40 insertions(+), 88 deletions(-)

diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
index 4f98910bcdb5..ffd174e75420 100644
--- a/crypto/polyval-generic.c
+++ b/crypto/polyval-generic.c
@@ -44,15 +44,15 @@
  *
  */
 
-#include <linux/unaligned.h>
-#include <crypto/algapi.h>
 #include <crypto/gf128mul.h>
-#include <crypto/polyval.h>
 #include <crypto/internal/hash.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
+#include <crypto/polyval.h>
+#include <crypto/utils.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 struct polyval_tfm_ctx {
 	struct gf128mul_4k *gf128;
@@ -63,7 +63,6 @@ struct polyval_desc_ctx {
 		u8 buffer[POLYVAL_BLOCK_SIZE];
 		be128 buffer128;
 	};
-	u32 bytes;
 };
 
 static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
@@ -76,46 +75,6 @@ static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
 	put_unaligned(swab64(b), (u64 *)&dst[0]);
 }
 
-/*
- * Performs multiplication in the POLYVAL field using the GHASH field as a
- * subroutine.  This function is used as a fallback for hardware accelerated
- * implementations when simd registers are unavailable.
- *
- * Note: This function is not used for polyval-generic, instead we use the 4k
- * lookup table implementation for finite field multiplication.
- */
-void polyval_mul_non4k(u8 *op1, const u8 *op2)
-{
-	be128 a, b;
-
-	// Assume one argument is in Montgomery form and one is not.
-	copy_and_reverse((u8 *)&a, op1);
-	copy_and_reverse((u8 *)&b, op2);
-	gf128mul_x_lle(&a, &a);
-	gf128mul_lle(&a, &b);
-	copy_and_reverse(op1, (u8 *)&a);
-}
-EXPORT_SYMBOL_GPL(polyval_mul_non4k);
-
-/*
- * Perform a POLYVAL update using non4k multiplication.  This function is used
- * as a fallback for hardware accelerated implementations when simd registers
- * are unavailable.
- *
- * Note: This function is not used for polyval-generic, instead we use the 4k
- * lookup table implementation of finite field multiplication.
- */
-void polyval_update_non4k(const u8 *key, const u8 *in,
-			  size_t nblocks, u8 *accumulator)
-{
-	while (nblocks--) {
-		crypto_xor(accumulator, in, POLYVAL_BLOCK_SIZE);
-		polyval_mul_non4k(accumulator, key);
-		in += POLYVAL_BLOCK_SIZE;
-	}
-}
-EXPORT_SYMBOL_GPL(polyval_update_non4k);
-
 static int polyval_setkey(struct crypto_shash *tfm,
 			  const u8 *key, unsigned int keylen)
 {
@@ -154,56 +113,53 @@ static int polyval_update(struct shash_desc *desc,
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	u8 *pos;
 	u8 tmp[POLYVAL_BLOCK_SIZE];
-	int n;
 
-	if (dctx->bytes) {
-		n = min(srclen, dctx->bytes);
-		pos = dctx->buffer + dctx->bytes - 1;
-
-		dctx->bytes -= n;
-		srclen -= n;
-
-		while (n--)
-			*pos-- ^= *src++;
-
-		if (!dctx->bytes)
-			gf128mul_4k_lle(&dctx->buffer128, ctx->gf128);
-	}
-
-	while (srclen >= POLYVAL_BLOCK_SIZE) {
+	do {
 		copy_and_reverse(tmp, src);
 		crypto_xor(dctx->buffer, tmp, POLYVAL_BLOCK_SIZE);
 		gf128mul_4k_lle(&dctx->buffer128, ctx->gf128);
 		src += POLYVAL_BLOCK_SIZE;
 		srclen -= POLYVAL_BLOCK_SIZE;
-	}
+	} while (srclen >= POLYVAL_BLOCK_SIZE);
 
-	if (srclen) {
-		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
-		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - 1;
-		while (srclen--)
-			*pos-- ^= *src++;
-	}
-
-	return 0;
+	return srclen;
 }
 
-static int polyval_final(struct shash_desc *desc, u8 *dst)
+static int polyval_finup(struct shash_desc *desc, const u8 *src,
+			 unsigned int len, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
 
-	if (dctx->bytes)
-		gf128mul_4k_lle(&dctx->buffer128, ctx->gf128);
+	if (len) {
+		u8 tmp[POLYVAL_BLOCK_SIZE] = {};
+
+		memcpy(tmp, src, len);
+		polyval_update(desc, tmp, POLYVAL_BLOCK_SIZE);
+	}
 	copy_and_reverse(dst, dctx->buffer);
 	return 0;
 }
 
-static void polyval_exit_tfm(struct crypto_tfm *tfm)
+static int polyval_export(struct shash_desc *desc, void *out)
 {
-	struct polyval_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	copy_and_reverse(out, dctx->buffer);
+	return 0;
+}
+
+static int polyval_import(struct shash_desc *desc, const void *in)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	copy_and_reverse(dctx->buffer, in);
+	return 0;
+}
+
+static void polyval_exit_tfm(struct crypto_shash *tfm)
+{
+	struct polyval_tfm_ctx *ctx = crypto_shash_ctx(tfm);
 
 	gf128mul_free_4k(ctx->gf128);
 }
@@ -212,17 +168,21 @@ static struct shash_alg polyval_alg = {
 	.digestsize	= POLYVAL_DIGEST_SIZE,
 	.init		= polyval_init,
 	.update		= polyval_update,
-	.final		= polyval_final,
+	.finup		= polyval_finup,
 	.setkey		= polyval_setkey,
+	.export		= polyval_export,
+	.import		= polyval_import,
+	.exit_tfm	= polyval_exit_tfm,
+	.statesize	= sizeof(struct polyval_desc_ctx),
 	.descsize	= sizeof(struct polyval_desc_ctx),
 	.base		= {
 		.cra_name		= "polyval",
 		.cra_driver_name	= "polyval-generic",
 		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
 		.cra_module		= THIS_MODULE,
-		.cra_exit		= polyval_exit_tfm,
 	},
 };
 
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index 1d630f371f77..d2e63743e592 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -8,15 +8,7 @@
 #ifndef _CRYPTO_POLYVAL_H
 #define _CRYPTO_POLYVAL_H
 
-#include <linux/types.h>
-#include <linux/crypto.h>
-
 #define POLYVAL_BLOCK_SIZE	16
 #define POLYVAL_DIGEST_SIZE	16
 
-void polyval_mul_non4k(u8 *op1, const u8 *op2);
-
-void polyval_update_non4k(const u8 *key, const u8 *in,
-			  size_t nblocks, u8 *accumulator);
-
 #endif
-- 
2.39.5

