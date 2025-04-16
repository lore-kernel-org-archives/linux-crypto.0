Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99985158520
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785917; cv=none; b=buW2lCcQEczutG0Bj9tc/Bvjuz7asLHgW0QuwuSJy1MiRKJngFwEJolYkGl+hO3tOTs5gqyw6wopss/pV160POY8eE2IDxdEysL6G3SnsprrWu6hUK1mmmVp6Ex0z+7doVHaDHjXU7fAuEiyn8MnVkOm6OcDdgZRvOtjZkVpdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785917; c=relaxed/simple;
	bh=HfqqVtN7ALkr6leMASfH62frilF1xF/Rg3Og2YXYg7M=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=VM6Xt8EsZ+Qz27Zjox0XJqwRXaxRW+jvwGIy+GCce2jo+9e59HG7055L7Q/suSygZfAIG8DoZ3m/3t+6TQ6IusgprQdQMJU0J9RkqtvlQgF6mIjFtA16ycZNamgqXQhUo0wUw13Pp3Mz1JvKyo0Rg/GyP8aDyciReehLSitv7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HJdOV1hI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HJdOV1hI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i3VhU+8lbuf4q8n2wSSl2qo0ToRnnviqh/r11Tz525A=; b=HJdOV1hI7ow+fZVSj/HAg/2rbc
	m7nnZ4kDNKa7XjJCoZPUHia96btEYBcCApnDt6TrmTr2s+r9PqhR7UjoWBLtjQ7uwDI5oC0KWaCUC
	3C7L5NUJS+sfxtyG+uq1kheJU0lfOhFoH6bX4PonVsaiZbiu5bZ1MtS/5hCN4tWR8wAuDMQ9+1uCm
	URxlW4ssCyh7BY8RkiaG9b4q1xV0SjHQMxpbxdef2mWA7OlYguBpg9xWyPsBUtZXPEBXRXXNCfAMS
	w1OXz7t4i21kyuLhad2xLhh2e+j+fZ1sTBObflI2XlSNxOESQF+Sfnh8L8PTdN3ezqKaRb0OUIiCt
	dZEvWLtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wWF-00G6VU-16;
	Wed, 16 Apr 2025 14:45:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:45:11 +0800
Date: Wed, 16 Apr 2025 14:45:11 +0800
Message-Id: <f2b19334fab589c6b5b8e2a8176e29c50953f013.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 64/67] crypto: arm64/aes - Use API partial block handling
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
 arch/arm64/crypto/aes-glue.c | 122 ++++++++++++-----------------------
 1 file changed, 41 insertions(+), 81 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5ca3b5661749..81560f722b9d 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -5,19 +5,20 @@
  * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/neon.h>
 #include <asm/hwcap.h>
-#include <asm/simd.h>
+#include <asm/neon.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/sha2.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
+#include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include <crypto/xts.h>
+#include <linux/cpufeature.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 #include "aes-ce-setkey.h"
 
@@ -130,7 +131,6 @@ struct mac_tfm_ctx {
 };
 
 struct mac_desc_ctx {
-	unsigned int len;
 	u8 dg[AES_BLOCK_SIZE];
 };
 
@@ -869,109 +869,64 @@ static int mac_init(struct shash_desc *desc)
 	struct mac_desc_ctx *ctx = shash_desc_ctx(desc);
 
 	memset(ctx->dg, 0, AES_BLOCK_SIZE);
-	ctx->len = 0;
-
 	return 0;
 }
 
 static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
-			  u8 dg[], int enc_before, int enc_after)
+			  u8 dg[], int enc_before)
 {
 	int rounds = 6 + ctx->key_length / 4;
+	int rem;
 
-	if (crypto_simd_usable()) {
-		int rem;
-
-		do {
-			kernel_neon_begin();
-			rem = aes_mac_update(in, ctx->key_enc, rounds, blocks,
-					     dg, enc_before, enc_after);
-			kernel_neon_end();
-			in += (blocks - rem) * AES_BLOCK_SIZE;
-			blocks = rem;
-			enc_before = 0;
-		} while (blocks);
-	} else {
-		if (enc_before)
-			aes_encrypt(ctx, dg, dg);
-
-		while (blocks--) {
-			crypto_xor(dg, in, AES_BLOCK_SIZE);
-			in += AES_BLOCK_SIZE;
-
-			if (blocks || enc_after)
-				aes_encrypt(ctx, dg, dg);
-		}
-	}
+	do {
+		kernel_neon_begin();
+		rem = aes_mac_update(in, ctx->key_enc, rounds, blocks,
+				     dg, enc_before, !enc_before);
+		kernel_neon_end();
+		in += (blocks - rem) * AES_BLOCK_SIZE;
+		blocks = rem;
+	} while (blocks);
 }
 
 static int mac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
 {
 	struct mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct mac_desc_ctx *ctx = shash_desc_ctx(desc);
+	int blocks = len / AES_BLOCK_SIZE;
 
-	while (len > 0) {
-		unsigned int l;
-
-		if ((ctx->len % AES_BLOCK_SIZE) == 0 &&
-		    (ctx->len + len) > AES_BLOCK_SIZE) {
-
-			int blocks = len / AES_BLOCK_SIZE;
-
-			len %= AES_BLOCK_SIZE;
-
-			mac_do_update(&tctx->key, p, blocks, ctx->dg,
-				      (ctx->len != 0), (len != 0));
-
-			p += blocks * AES_BLOCK_SIZE;
-
-			if (!len) {
-				ctx->len = AES_BLOCK_SIZE;
-				break;
-			}
-			ctx->len = 0;
-		}
-
-		l = min(len, AES_BLOCK_SIZE - ctx->len);
-
-		if (l <= AES_BLOCK_SIZE) {
-			crypto_xor(ctx->dg + ctx->len, p, l);
-			ctx->len += l;
-			len -= l;
-			p += l;
-		}
-	}
-
-	return 0;
+	len %= AES_BLOCK_SIZE;
+	mac_do_update(&tctx->key, p, blocks, ctx->dg, 0);
+	return len;
 }
 
-static int cbcmac_final(struct shash_desc *desc, u8 *out)
+static int cbcmac_finup(struct shash_desc *desc, const u8 *src,
+			unsigned int len, u8 *out)
 {
 	struct mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct mac_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	mac_do_update(&tctx->key, NULL, 0, ctx->dg, (ctx->len != 0), 0);
-
+	if (len) {
+		crypto_xor(ctx->dg, src, len);
+		mac_do_update(&tctx->key, NULL, 0, ctx->dg, 1);
+	}
 	memcpy(out, ctx->dg, AES_BLOCK_SIZE);
-
 	return 0;
 }
 
-static int cmac_final(struct shash_desc *desc, u8 *out)
+static int cmac_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+		      u8 *out)
 {
 	struct mac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct mac_desc_ctx *ctx = shash_desc_ctx(desc);
 	u8 *consts = tctx->consts;
 
-	if (ctx->len != AES_BLOCK_SIZE) {
-		ctx->dg[ctx->len] ^= 0x80;
+	crypto_xor(ctx->dg, src, len);
+	if (len != AES_BLOCK_SIZE) {
+		ctx->dg[len] ^= 0x80;
 		consts += AES_BLOCK_SIZE;
 	}
-
-	mac_do_update(&tctx->key, consts, 1, ctx->dg, 0, 1);
-
+	mac_do_update(&tctx->key, consts, 1, ctx->dg, 0);
 	memcpy(out, ctx->dg, AES_BLOCK_SIZE);
-
 	return 0;
 }
 
@@ -979,6 +934,8 @@ static struct shash_alg mac_algs[] = { {
 	.base.cra_name		= "cmac(aes)",
 	.base.cra_driver_name	= "cmac-aes-" MODE,
 	.base.cra_priority	= PRIO,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINAL_NONZERO,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct mac_tfm_ctx) +
 				  2 * AES_BLOCK_SIZE,
@@ -987,13 +944,15 @@ static struct shash_alg mac_algs[] = { {
 	.digestsize		= AES_BLOCK_SIZE,
 	.init			= mac_init,
 	.update			= mac_update,
-	.final			= cmac_final,
+	.finup			= cmac_finup,
 	.setkey			= cmac_setkey,
 	.descsize		= sizeof(struct mac_desc_ctx),
 }, {
 	.base.cra_name		= "xcbc(aes)",
 	.base.cra_driver_name	= "xcbc-aes-" MODE,
 	.base.cra_priority	= PRIO,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINAL_NONZERO,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct mac_tfm_ctx) +
 				  2 * AES_BLOCK_SIZE,
@@ -1002,13 +961,14 @@ static struct shash_alg mac_algs[] = { {
 	.digestsize		= AES_BLOCK_SIZE,
 	.init			= mac_init,
 	.update			= mac_update,
-	.final			= cmac_final,
+	.finup			= cmac_finup,
 	.setkey			= xcbc_setkey,
 	.descsize		= sizeof(struct mac_desc_ctx),
 }, {
 	.base.cra_name		= "cbcmac(aes)",
 	.base.cra_driver_name	= "cbcmac-aes-" MODE,
 	.base.cra_priority	= PRIO,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct mac_tfm_ctx),
 	.base.cra_module	= THIS_MODULE,
@@ -1016,7 +976,7 @@ static struct shash_alg mac_algs[] = { {
 	.digestsize		= AES_BLOCK_SIZE,
 	.init			= mac_init,
 	.update			= mac_update,
-	.final			= cbcmac_final,
+	.finup			= cbcmac_finup,
 	.setkey			= cbcmac_setkey,
 	.descsize		= sizeof(struct mac_desc_ctx),
 } };
-- 
2.39.5

