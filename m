Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75067224AFC
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491654; cv=none; b=IduXeP0nOJuxjuf5KBFp8d1zI91HxivoxW04NRqgWsNGmIZIfjGrOFhPxKsaqgyxkIFzAl1UrI2qOxnjWZ4xT8w7x5uD2gR7mzYe4IaRZsy27J7HefssFa618hWCnzSHzsTs2YhtgK4LWoC347kQAeCYKvOsb9qvEJLoNyHdYnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491654; c=relaxed/simple;
	bh=ryUjz9WKwhuukJLUbM6rbeHaEEDl/i+4tBTdsfAsQkA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Vk/78zTO+z9lQN6zKgt7L6q4JDLFPEHFdnM4nZZpkiOZHp11SXjmnCPxdEEwkaVoJ0otR1cIhsKjMwOhi5gpBTZrKF8cxQGrPCVaHEjB3aekRwR04UAqOX9sKBlfmu+MXXGxWTvmCnFAEl592xZEnSA4MGh1AVxjRYf16czpxrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=A+gLkyLh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="A+gLkyLh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mKRM+eCX7VJCL/BRQ7tUyEwPfEIJ9SGQ2na/0ejFxHw=; b=A+gLkyLh8x5y7//dRXKzFqx3U+
	ix6O+2kVN1y/Hq8T1h+R8BHUWdj5mRH1I0+1I4B1TrPbn6lDvem+xhNDztrD0vS4wjlIxJJbqqSQ0
	yyfeJxJWoaasrvKAPb5p3hanL8bb1YT1JWJeTtgOKxsdVLKL+5AY2ZXHTeOL8qnr6MHxLhHhZDCZ2
	88zpQsBKt9zXzFNbzj5uGcrmYlxEWx5/98rPfMYYQLvDQIQlwWbUudcklyo52Bv8FWuMSKb1dstGs
	8lnLhWsm4AuLj5WIxadTDFfvt9vhf/iLR+f9a0bb9BdKOrjfdOSATljPn3Mc8ZE5kgxsqdll36TNj
	uWjcm+QQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u76-000fOV-1f;
	Thu, 24 Apr 2025 18:47:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:28 +0800
Date: Thu, 24 Apr 2025 18:47:28 +0800
Message-Id: <9aa5864c62f4eefc73fb71c9c4acbd6171e3803c.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/15] crypto: x86/polyval - Use API partial block handling
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
 arch/x86/crypto/polyval-clmulni_glue.c | 72 +++++++-------------------
 1 file changed, 20 insertions(+), 52 deletions(-)

diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
index 8fa58b0f3cb3..6b466867f91a 100644
--- a/arch/x86/crypto/polyval-clmulni_glue.c
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -16,16 +16,15 @@
  * operations.
  */
 
-#include <crypto/algapi.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/polyval.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
+#include <crypto/utils.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/cpu_device_id.h>
-#include <asm/simd.h>
+#include <linux/string.h>
 
 #define POLYVAL_ALIGN	16
 #define POLYVAL_ALIGN_ATTR __aligned(POLYVAL_ALIGN)
@@ -42,7 +41,6 @@ struct polyval_tfm_ctx {
 
 struct polyval_desc_ctx {
 	u8 buffer[POLYVAL_BLOCK_SIZE];
-	u32 bytes;
 };
 
 asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
@@ -57,25 +55,16 @@ static inline struct polyval_tfm_ctx *polyval_tfm_ctx(struct crypto_shash *tfm)
 static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_fpu_begin();
-		clmul_polyval_update(keys, in, nblocks, accumulator);
-		kernel_fpu_end();
-	} else {
-		polyval_update_non4k(keys->key_powers[NUM_KEY_POWERS-1], in,
-			nblocks, accumulator);
-	}
+	kernel_fpu_begin();
+	clmul_polyval_update(keys, in, nblocks, accumulator);
+	kernel_fpu_end();
 }
 
 static void internal_polyval_mul(u8 *op1, const u8 *op2)
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_fpu_begin();
-		clmul_polyval_mul(op1, op2);
-		kernel_fpu_end();
-	} else {
-		polyval_mul_non4k(op1, op2);
-	}
+	kernel_fpu_begin();
+	clmul_polyval_mul(op1, op2);
+	kernel_fpu_end();
 }
 
 static int polyval_x86_setkey(struct crypto_shash *tfm,
@@ -112,49 +101,27 @@ static int polyval_x86_update(struct shash_desc *desc,
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
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
 		/* Allow rescheduling every 4K bytes. */
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
 
-static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
+static int polyval_x86_finup(struct shash_desc *desc, const u8 *src,
+			     unsigned int len, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
 
-	if (dctx->bytes) {
+	if (len) {
+		crypto_xor(dctx->buffer, src, len);
 		internal_polyval_mul(dctx->buffer,
 				     tctx->key_powers[NUM_KEY_POWERS-1]);
 	}
@@ -168,13 +135,14 @@ static struct shash_alg polyval_alg = {
 	.digestsize	= POLYVAL_DIGEST_SIZE,
 	.init		= polyval_x86_init,
 	.update		= polyval_x86_update,
-	.final		= polyval_x86_final,
+	.finup		= polyval_x86_finup,
 	.setkey		= polyval_x86_setkey,
 	.descsize	= sizeof(struct polyval_desc_ctx),
 	.base		= {
 		.cra_name		= "polyval",
 		.cra_driver_name	= "polyval-clmulni",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
 		.cra_ctxsize		= POLYVAL_CTX_SIZE,
 		.cra_module		= THIS_MODULE,
-- 
2.39.5

