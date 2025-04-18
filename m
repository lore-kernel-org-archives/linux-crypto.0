Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2223ED5A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945136; cv=none; b=k2n1cOtMbMQzpdZF7107snC6eq9KxaChuUbnuOEtJNoY8Q7fyxnbzIvkHfdyDRbK1W7YAH9z+0fXWr6bEOGREP5ORr+cnruCKjQGoWNV2LQSBWMmXWymw6xFgc/Hlv7BdG4QRilOOFdwrPB1y1WhCxjEo17oM+oEPQiJb7XugPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945136; c=relaxed/simple;
	bh=jhR+Je89EhfwbZ40Tpm/rSQt5AB65HqIdSoFQzMtNtI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Xxt6KnRyY40v3btXEwwYwXBvT+d1WMissFTUmdNQmQFBq1HZkkt1nOY3vW8jiBZUTLw5tUGcr+22QTlO2kOwXymt52xzmNiGPg3ZXNOEIfJ0SUeVdUXUnV4AIYuzTVxQ9kTJXPR5TfhWZv69Z2c0u1w0utjvWcbGArTuReR36/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IV6Sk04P; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IV6Sk04P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1kCKkzYgl0mRUIv1evYQiyqEKWNqAUxY2Josd2EjMvg=; b=IV6Sk04P1vpfMXIv74eRA1SZxS
	pahFJJs09VLMx4wTLIVGVFrfbv27dpNmjreQBdY0fDw9lii/Mfto6amFZOFDjGOQhbR+IoYB7UiA+
	G4inFrce0dg/DbqzmNN5jD+I9dKtSs0VP/95Q8vrg+/oBVyJbKe5lRmYgaz1lU811GW5cQ+QF8Rfm
	fNO9IWMpQBbOitl4ioMfptA3lCsBWUILs/3PtbQ30SoIaQlfxDl6tsbzeKSuCj6zBkjbOB+YJ3ZGs
	28QzYnAjJM0OfPrD6B0p2t3of7SFvap7JHtUth8LUydZ7AYffb7IdX3BGSVTGnndi3AsNQi2gu1Pr
	OH20sp2Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwI-00Ge2q-0y;
	Fri, 18 Apr 2025 10:58:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:50 +0800
Date: Fri, 18 Apr 2025 10:58:50 +0800
Message-Id: <5cfd030b7576246f337ce3c0f92a2405d78ccf0d.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 05/67] crypto: powerpc/ghash - Use API partial block
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
 arch/powerpc/crypto/ghash.c | 81 +++++++++++++------------------------
 1 file changed, 28 insertions(+), 53 deletions(-)

diff --git a/arch/powerpc/crypto/ghash.c b/arch/powerpc/crypto/ghash.c
index 9bb61a843fd3..7308735bdb33 100644
--- a/arch/powerpc/crypto/ghash.c
+++ b/arch/powerpc/crypto/ghash.c
@@ -12,17 +12,16 @@
  */
 
 #include "aesp8-ppc.h"
-#include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
-#include <crypto/b128ops.h>
+#include <crypto/gf128mul.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
-#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
@@ -39,15 +38,12 @@ struct p8_ghash_ctx {
 
 struct p8_ghash_desc_ctx {
 	u64 shash[2];
-	u8 buffer[GHASH_DIGEST_SIZE];
-	int bytes;
 };
 
 static int p8_ghash_init(struct shash_desc *desc)
 {
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	dctx->bytes = 0;
 	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
 	return 0;
 }
@@ -74,27 +70,30 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
 }
 
 static inline void __ghash_block(struct p8_ghash_ctx *ctx,
-				 struct p8_ghash_desc_ctx *dctx)
+				 struct p8_ghash_desc_ctx *dctx,
+				 const u8 *src)
 {
 	if (crypto_simd_usable()) {
 		preempt_disable();
 		pagefault_disable();
 		enable_kernel_vsx();
-		gcm_ghash_p8(dctx->shash, ctx->htable,
-				dctx->buffer, GHASH_DIGEST_SIZE);
+		gcm_ghash_p8(dctx->shash, ctx->htable, src, GHASH_BLOCK_SIZE);
 		disable_kernel_vsx();
 		pagefault_enable();
 		preempt_enable();
 	} else {
-		crypto_xor((u8 *)dctx->shash, dctx->buffer, GHASH_BLOCK_SIZE);
+		crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
 		gf128mul_lle((be128 *)dctx->shash, &ctx->key);
 	}
 }
 
-static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
-				  struct p8_ghash_desc_ctx *dctx,
-				  const u8 *src, unsigned int srclen)
+static inline int __ghash_blocks(struct p8_ghash_ctx *ctx,
+				 struct p8_ghash_desc_ctx *dctx,
+				 const u8 *src, unsigned int srclen)
 {
+	int remain = srclen - round_down(srclen, GHASH_BLOCK_SIZE);
+
+	srclen -= remain;
 	if (crypto_simd_usable()) {
 		preempt_disable();
 		pagefault_disable();
@@ -105,62 +104,38 @@ static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
 		pagefault_enable();
 		preempt_enable();
 	} else {
-		while (srclen >= GHASH_BLOCK_SIZE) {
+		do {
 			crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
 			gf128mul_lle((be128 *)dctx->shash, &ctx->key);
 			srclen -= GHASH_BLOCK_SIZE;
 			src += GHASH_BLOCK_SIZE;
-		}
+		} while (srclen);
 	}
+
+	return remain;
 }
 
 static int p8_ghash_update(struct shash_desc *desc,
 			   const u8 *src, unsigned int srclen)
 {
-	unsigned int len;
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (dctx->bytes) {
-		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
-			memcpy(dctx->buffer + dctx->bytes, src,
-				srclen);
-			dctx->bytes += srclen;
-			return 0;
-		}
-		memcpy(dctx->buffer + dctx->bytes, src,
-			GHASH_DIGEST_SIZE - dctx->bytes);
-
-		__ghash_block(ctx, dctx);
-
-		src += GHASH_DIGEST_SIZE - dctx->bytes;
-		srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
-		dctx->bytes = 0;
-	}
-	len = srclen & ~(GHASH_DIGEST_SIZE - 1);
-	if (len) {
-		__ghash_blocks(ctx, dctx, src, len);
-		src += len;
-		srclen -= len;
-	}
-	if (srclen) {
-		memcpy(dctx->buffer, src, srclen);
-		dctx->bytes = srclen;
-	}
-	return 0;
+	return __ghash_blocks(ctx, dctx, src, srclen);
 }
 
-static int p8_ghash_final(struct shash_desc *desc, u8 *out)
+static int p8_ghash_finup(struct shash_desc *desc, const u8 *src,
+			  unsigned int len, u8 *out)
 {
-	int i;
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (dctx->bytes) {
-		for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
-			dctx->buffer[i] = 0;
-		__ghash_block(ctx, dctx);
-		dctx->bytes = 0;
+	if (len) {
+		u8 buf[GHASH_BLOCK_SIZE] = {};
+
+		memcpy(buf, src, len);
+		__ghash_block(ctx, dctx, buf);
+		memzero_explicit(buf, sizeof(buf));
 	}
 	memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
 	return 0;
@@ -170,14 +145,14 @@ struct shash_alg p8_ghash_alg = {
 	.digestsize = GHASH_DIGEST_SIZE,
 	.init = p8_ghash_init,
 	.update = p8_ghash_update,
-	.final = p8_ghash_final,
+	.finup = p8_ghash_finup,
 	.setkey = p8_ghash_setkey,
-	.descsize = sizeof(struct p8_ghash_desc_ctx)
-		+ sizeof(struct ghash_desc_ctx),
+	.descsize = sizeof(struct p8_ghash_desc_ctx),
 	.base = {
 		 .cra_name = "ghash",
 		 .cra_driver_name = "p8_ghash",
 		 .cra_priority = 1000,
+		 .cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		 .cra_blocksize = GHASH_BLOCK_SIZE,
 		 .cra_ctxsize = sizeof(struct p8_ghash_ctx),
 		 .cra_module = THIS_MODULE,
-- 
2.39.5

