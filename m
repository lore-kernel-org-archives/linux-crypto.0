Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0022FF39
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785920; cv=none; b=gAZDQVPm0DJePVCQOHlxW1ad6zV7cZurf8o634n13kksAuXsxZx2bLvE1XTJw3zAqy5cxzqtvu1EBZYo9PB9sw1RLRDA3oZxryEHK7oxz7sjFYtDg/fl3FWFpZAu+MXC/Hj8HQ7+Z7C+dyrEcFhtra3+w4KWH/4KJJCzXOJ4T0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785920; c=relaxed/simple;
	bh=XAzKqH5YIN3Dern6+dJnznYhndmZ1uH8uYyr0+nx+gw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=gGFW+BUIvAa9sOrzwcQ7LOLXdlKJiGieuTuw/J4d5FRfwojPgqXssXInQP6xT4JRH3RSPvEYkdCgObOEMxAa2gyJtvpsHpu+TREVdOXOriGat9Gi44o2SIMehs9z/OBTW0Y0xc8qSaDGfJiSMA4J8Z6DRpUzMRFi5O80hw67PVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mwjpgbz0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mwjpgbz0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QAleyO8uXrPvqOfb28TDZUx+URbdSxIuDT/Ph7RtFd4=; b=mwjpgbz0MRbqRoWglAY26G/gSp
	jh3gc0f9GntA1ToinFuL0MPGXf+WrdOEzL4GEEOO9nyvymkFczJjNmDe8L5shB9R+yjtloX9eJ0a0
	0V3kO54ACJythcqZQqDZ5QZgRcFvua+3qK9Ko7zkmwVqjQqxOzAbchkLMhpkJHWsW2Fl9T4w60yJ2
	B/5a+k8koo+kxnm9vTse3VzhHy6CRWHl7Ea/eoUAQTv5a/AetZ2wqsAt6OlkRh1GhQS8pJnK7l1bp
	mWc/Npbkw+ltWq1pvh6ibotJ68sdOAAmZbYVO6RBIDkCJVxrn0AbHgXEGu99nxd0BfCO4S12vJOQp
	GASFJDRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wWI-00G6Vs-12;
	Wed, 16 Apr 2025 14:45:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:45:14 +0800
Date: Wed, 16 Apr 2025 14:45:14 +0800
Message-Id: <fa6bde74e3b8e57b700fe94b998a4f0b541115e7.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 65/67] crypto: arm64/sm4 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sm4-ce-glue.c | 98 +++++++++++----------------------
 1 file changed, 31 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index f11cf26e5a20..7a60e7b559dc 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -8,19 +8,18 @@
  * Copyright (C) 2022 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
-#include <linux/module.h>
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <linux/cpufeature.h>
 #include <asm/neon.h>
-#include <asm/simd.h>
 #include <crypto/b128ops.h>
-#include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/xts.h>
 #include <crypto/sm4.h>
+#include <crypto/utils.h>
+#include <crypto/xts.h>
+#include <linux/cpufeature.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 #define BYTES2BLKS(nbytes)	((nbytes) >> 4)
 
@@ -64,7 +63,6 @@ struct sm4_mac_tfm_ctx {
 };
 
 struct sm4_mac_desc_ctx {
-	unsigned int len;
 	u8 digest[SM4_BLOCK_SIZE];
 };
 
@@ -591,8 +589,6 @@ static int sm4_mac_init(struct shash_desc *desc)
 	struct sm4_mac_desc_ctx *ctx = shash_desc_ctx(desc);
 
 	memset(ctx->digest, 0, SM4_BLOCK_SIZE);
-	ctx->len = 0;
-
 	return 0;
 }
 
@@ -601,87 +597,50 @@ static int sm4_mac_update(struct shash_desc *desc, const u8 *p,
 {
 	struct sm4_mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct sm4_mac_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int l, nblocks;
+	unsigned int nblocks = len / SM4_BLOCK_SIZE;
 
-	if (len == 0)
-		return 0;
-
-	if (ctx->len || ctx->len + len < SM4_BLOCK_SIZE) {
-		l = min(len, SM4_BLOCK_SIZE - ctx->len);
-
-		crypto_xor(ctx->digest + ctx->len, p, l);
-		ctx->len += l;
-		len -= l;
-		p += l;
-	}
-
-	if (len && (ctx->len % SM4_BLOCK_SIZE) == 0) {
-		kernel_neon_begin();
-
-		if (len < SM4_BLOCK_SIZE && ctx->len == SM4_BLOCK_SIZE) {
-			sm4_ce_crypt_block(tctx->key.rkey_enc,
-					   ctx->digest, ctx->digest);
-			ctx->len = 0;
-		} else {
-			nblocks = len / SM4_BLOCK_SIZE;
-			len %= SM4_BLOCK_SIZE;
-
-			sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, p,
-					  nblocks, (ctx->len == SM4_BLOCK_SIZE),
-					  (len != 0));
-
-			p += nblocks * SM4_BLOCK_SIZE;
-
-			if (len == 0)
-				ctx->len = SM4_BLOCK_SIZE;
-		}
-
-		kernel_neon_end();
-
-		if (len) {
-			crypto_xor(ctx->digest, p, len);
-			ctx->len = len;
-		}
-	}
-
-	return 0;
+	len %= SM4_BLOCK_SIZE;
+	kernel_neon_begin();
+	sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, p,
+			  nblocks, false, true);
+	kernel_neon_end();
+	return len;
 }
 
-static int sm4_cmac_final(struct shash_desc *desc, u8 *out)
+static int sm4_cmac_finup(struct shash_desc *desc, const u8 *src,
+			  unsigned int len, u8 *out)
 {
 	struct sm4_mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct sm4_mac_desc_ctx *ctx = shash_desc_ctx(desc);
 	const u8 *consts = tctx->consts;
 
-	if (ctx->len != SM4_BLOCK_SIZE) {
-		ctx->digest[ctx->len] ^= 0x80;
+	crypto_xor(ctx->digest, src, len);
+	if (len != SM4_BLOCK_SIZE) {
+		ctx->digest[len] ^= 0x80;
 		consts += SM4_BLOCK_SIZE;
 	}
-
 	kernel_neon_begin();
 	sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, consts, 1,
 			  false, true);
 	kernel_neon_end();
-
 	memcpy(out, ctx->digest, SM4_BLOCK_SIZE);
-
 	return 0;
 }
 
-static int sm4_cbcmac_final(struct shash_desc *desc, u8 *out)
+static int sm4_cbcmac_finup(struct shash_desc *desc, const u8 *src,
+			    unsigned int len, u8 *out)
 {
 	struct sm4_mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct sm4_mac_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	if (ctx->len) {
+	if (len) {
+		crypto_xor(ctx->digest, src, len);
 		kernel_neon_begin();
 		sm4_ce_crypt_block(tctx->key.rkey_enc, ctx->digest,
 				   ctx->digest);
 		kernel_neon_end();
 	}
-
 	memcpy(out, ctx->digest, SM4_BLOCK_SIZE);
-
 	return 0;
 }
 
@@ -691,6 +650,8 @@ static struct shash_alg sm4_mac_algs[] = {
 			.cra_name		= "cmac(sm4)",
 			.cra_driver_name	= "cmac-sm4-ce",
 			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						  CRYPTO_AHASH_ALG_FINAL_NONZERO,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_mac_tfm_ctx)
 							+ SM4_BLOCK_SIZE * 2,
@@ -699,7 +660,7 @@ static struct shash_alg sm4_mac_algs[] = {
 		.digestsize	= SM4_BLOCK_SIZE,
 		.init		= sm4_mac_init,
 		.update		= sm4_mac_update,
-		.final		= sm4_cmac_final,
+		.finup		= sm4_cmac_finup,
 		.setkey		= sm4_cmac_setkey,
 		.descsize	= sizeof(struct sm4_mac_desc_ctx),
 	}, {
@@ -707,6 +668,8 @@ static struct shash_alg sm4_mac_algs[] = {
 			.cra_name		= "xcbc(sm4)",
 			.cra_driver_name	= "xcbc-sm4-ce",
 			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						  CRYPTO_AHASH_ALG_FINAL_NONZERO,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_mac_tfm_ctx)
 							+ SM4_BLOCK_SIZE * 2,
@@ -715,7 +678,7 @@ static struct shash_alg sm4_mac_algs[] = {
 		.digestsize	= SM4_BLOCK_SIZE,
 		.init		= sm4_mac_init,
 		.update		= sm4_mac_update,
-		.final		= sm4_cmac_final,
+		.finup		= sm4_cmac_finup,
 		.setkey		= sm4_xcbc_setkey,
 		.descsize	= sizeof(struct sm4_mac_desc_ctx),
 	}, {
@@ -723,6 +686,7 @@ static struct shash_alg sm4_mac_algs[] = {
 			.cra_name		= "cbcmac(sm4)",
 			.cra_driver_name	= "cbcmac-sm4-ce",
 			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 			.cra_blocksize		= SM4_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct sm4_mac_tfm_ctx),
 			.cra_module		= THIS_MODULE,
@@ -730,7 +694,7 @@ static struct shash_alg sm4_mac_algs[] = {
 		.digestsize	= SM4_BLOCK_SIZE,
 		.init		= sm4_mac_init,
 		.update		= sm4_mac_update,
-		.final		= sm4_cbcmac_final,
+		.finup		= sm4_cbcmac_finup,
 		.setkey		= sm4_cbcmac_setkey,
 		.descsize	= sizeof(struct sm4_mac_desc_ctx),
 	}
-- 
2.39.5

