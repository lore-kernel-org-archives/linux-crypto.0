Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B48E22D7B0
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491651; cv=none; b=kug5WfMhRaORe1UFzqTVUZpStA2zXAuK3NnnkYVjDlUr+JG6b4Rt+eykD7UHfQ/xK41gon5pSURJNtqBhlQaLFxCRUmKwht6ErJ464FnGMl9o9nIVDH/g7YnXwAlpjfnPuX3vjF8tNMD1h72OBVU0FfqaPorsL+BWRPE0KNo7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491651; c=relaxed/simple;
	bh=TdN1ASQ+5tJT/4s35Zlto2UupUyBX21IFUiow77AhWI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bXxWonxmnYx5zRwV3FBnsjbHAydlP1OXXShnxON9CPxLKyajoB4bD8zWU+MTo2kaobZMWW0wBqGeWpxT2j81xJKjLDC32OPY2TRhd8CSer4b+9AyNpNLoTr8Pb2U99QL8b/3axX907cTRTG4twcoG8Qt00ScZE2lFfe1w/22dw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Mu93zsbV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Mu93zsbV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YpLTxnnw/+/57TnZpiX/XQjlZFNLzpA5fAtBF0t/0I8=; b=Mu93zsbVxS9r+HcS/emoX4gHSj
	5csP+GqchYIk6yXrEOk31IQhcnDl0F0LvdDVj6JfDuC+6WGUBj/c/pQAnUGEk3UDJ04iouy+F8Kg/
	NSI7iLDzn3b33kIBvrucNbnIBYI9TmTkIVkiAAfah49q0vPNMG8NJVHpZvSR2w/p1DvHUablsBXCe
	uoUEF17n3V2ziSvMeuAKfzCFk9BZkAyZOsxHnO7rurBOCs+uGGtLYbrBIbaMyE1dy96HEZf0opwc+
	idCR9tJ4fKsie8gJjNrXU1Mv/ZQGNpeCF3f3HH+Uy3/sn/VHkopcqB5/XTAxgjIocdlidqinasoGD
	wVQexQjQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u74-000fOJ-0f;
	Thu, 24 Apr 2025 18:47:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:26 +0800
Date: Thu, 24 Apr 2025 18:47:26 +0800
Message-Id: <81e1f3a513fda4e49f0b10527d3540e205ad375f.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/15] crypto: arm64/polyval - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/polyval-ce-glue.c | 73 ++++++++---------------------
 1 file changed, 20 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
index 0a3b5718df85..c4e653688ea0 100644
--- a/arch/arm64/crypto/polyval-ce-glue.c
+++ b/arch/arm64/crypto/polyval-ce-glue.c
@@ -15,17 +15,15 @@
  * ARMv8 Crypto Extensions instructions to implement the finite field operations.
  */
 
-#include <crypto/algapi.h>
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/polyval.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
+#include <crypto/utils.h>
+#include <linux/cpufeature.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
+#include <linux/string.h>
 
 #define NUM_KEY_POWERS	8
 
@@ -38,7 +36,6 @@ struct polyval_tfm_ctx {
 
 struct polyval_desc_ctx {
 	u8 buffer[POLYVAL_BLOCK_SIZE];
-	u32 bytes;
 };
 
 asmlinkage void pmull_polyval_update(const struct polyval_tfm_ctx *keys,
@@ -48,25 +45,16 @@ asmlinkage void pmull_polyval_mul(u8 *op1, const u8 *op2);
 static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_neon_begin();
-		pmull_polyval_update(keys, in, nblocks, accumulator);
-		kernel_neon_end();
-	} else {
-		polyval_update_non4k(keys->key_powers[NUM_KEY_POWERS-1], in,
-			nblocks, accumulator);
-	}
+	kernel_neon_begin();
+	pmull_polyval_update(keys, in, nblocks, accumulator);
+	kernel_neon_end();
 }
 
 static void internal_polyval_mul(u8 *op1, const u8 *op2)
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_neon_begin();
-		pmull_polyval_mul(op1, op2);
-		kernel_neon_end();
-	} else {
-		polyval_mul_non4k(op1, op2);
-	}
+	kernel_neon_begin();
+	pmull_polyval_mul(op1, op2);
+	kernel_neon_end();
 }
 
 static int polyval_arm64_setkey(struct crypto_shash *tfm,
@@ -103,49 +91,27 @@ static int polyval_arm64_update(struct shash_desc *desc,
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	u8 *pos;
 	unsigned int nblocks;
-	unsigned int n;
 
-	if (dctx->bytes) {
-		n = min(srclen, dctx->bytes);
-		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - dctx->bytes;
-
-		dctx->bytes -= n;
-		srclen -= n;
-
-		while (n--)
-			*pos++ ^= *src++;
-
-		if (!dctx->bytes)
-			internal_polyval_mul(dctx->buffer,
-					    tctx->key_powers[NUM_KEY_POWERS-1]);
-	}
-
-	while (srclen >= POLYVAL_BLOCK_SIZE) {
+	do {
 		/* allow rescheduling every 4K bytes */
 		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
 		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
 		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
 		src += nblocks * POLYVAL_BLOCK_SIZE;
-	}
+	} while (srclen >= POLYVAL_BLOCK_SIZE);
 
-	if (srclen) {
-		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
-		pos = dctx->buffer;
-		while (srclen--)
-			*pos++ ^= *src++;
-	}
-
-	return 0;
+	return srclen;
 }
 
-static int polyval_arm64_final(struct shash_desc *desc, u8 *dst)
+static int polyval_arm64_finup(struct shash_desc *desc, const u8 *src,
+			       unsigned int len, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 
-	if (dctx->bytes) {
+	if (len) {
+		crypto_xor(dctx->buffer, src, len);
 		internal_polyval_mul(dctx->buffer,
 				     tctx->key_powers[NUM_KEY_POWERS-1]);
 	}
@@ -159,13 +125,14 @@ static struct shash_alg polyval_alg = {
 	.digestsize	= POLYVAL_DIGEST_SIZE,
 	.init		= polyval_arm64_init,
 	.update		= polyval_arm64_update,
-	.final		= polyval_arm64_final,
+	.finup		= polyval_arm64_finup,
 	.setkey		= polyval_arm64_setkey,
 	.descsize	= sizeof(struct polyval_desc_ctx),
 	.base		= {
 		.cra_name		= "polyval",
 		.cra_driver_name	= "polyval-ce",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
 		.cra_module		= THIS_MODULE,
-- 
2.39.5

