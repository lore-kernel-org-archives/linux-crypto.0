Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40FC22D7B0
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491649; cv=none; b=mZCAXhwboWgFKeZtgxeu7ENKIc1xyUfD/TawgsYGA9Ukpk6jTVLiZ4QDPm1MijQG0JUu2dpBonIqdTpvbA+dCg4mc1P6PM6ti57Jhs1JiLfioNIeecloHVwU0Hwn6dLaKznUwmrwQEqYMsh3X0IFa+41gX9iFEXVdRaePCq7ZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491649; c=relaxed/simple;
	bh=w39qiOEul2ddBVdmZAnYQUg76NymrJaStQdwgsWncLo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=KcxVibm/bCswFPzDGWmSOi7BWf3j888RbE2bFQSDQFOc2SFQ/adyUjKWQMPLlxOA38wtOgh24E8Y7GKB51Ee2c112I85m8iC+UQ+s2RmfGzYgYmcDqN+xCowUDS9N7stQB2kSoleSTzPU+b1IJdWo+twUkj5dfEm6+ia/BBoL8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iSdS4vFm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iSdS4vFm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z3W2vzwfst1A38uCAe9+WWuz3yXh+wH4Qq0ZeBz5Ixk=; b=iSdS4vFm6JaIZQiYxFzfoh7yTf
	eI1Lx9YUcbLcV+/6PTudspJmSq9iPjFHDiVUnd8nMIpOzbMfBOh8LC+v+LwjrutUgwsBlPd6hNCex
	I8FsqSqsrx7R6//PrXSxZJ+k6HOKDcTBQ2J92UbCNay80F/9ZXbQx2ePuiq6VdP8M4IKhTKycUcGT
	k9ikAbxoVnngqv1fxND/OHFNHv/ZMJhqAQ4oQ97TlfHLHC2bb18Lrb7LW3g1P4kQ5kmI/9cfPEsgd
	dncC5Vd+ojYFuh9Y7M0Ei6bxk4+Mwqc9HIarCq85UpgQcA3Vw9crvP6HQ+YJKnLMC8YLfSq60NNVg
	QbU/hFfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u71-000fNl-2x;
	Thu, 24 Apr 2025 18:47:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:23 +0800
Date: Thu, 24 Apr 2025 18:47:23 +0800
Message-Id: <06a77edd0652369cab289ce01d35362b8fa8710d.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/15] crypto: poly1305 - Make setkey mandatory
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that IPsec has been converted to the setkey interface, remove
support for setting the key through the first two blocks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/poly1305.c | 57 +++++++++--------------------------------------
 1 file changed, 11 insertions(+), 46 deletions(-)

diff --git a/crypto/poly1305.c b/crypto/poly1305.c
index 9c36ff4bd9c4..5fdf36b2e028 100644
--- a/crypto/poly1305.c
+++ b/crypto/poly1305.c
@@ -24,8 +24,7 @@ struct crypto_poly1305_ctx {
 };
 
 struct crypto_poly1305_desc_ctx {
-	struct crypto_poly1305_ctx base;
-	unsigned int keysize;
+	struct poly1305_block_state state;
 };
 
 static int crypto_poly1305_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -64,10 +63,7 @@ static int crypto_poly1305_init(struct shash_desc *desc)
 	struct crypto_poly1305_ctx *ctx;
 
 	ctx = crypto_shash_ctx(tfm);
-	dctx->base = *ctx;
-	dctx->keysize = 0;
-	if (crypto_shash_get_flags(tfm) & CRYPTO_POLY1305_TFM_HAS_KEY)
-		dctx->keysize = POLY1305_KEY_SIZE;
+	dctx->state = ctx->state;
 	return 0;
 }
 
@@ -77,37 +73,10 @@ static inline int crypto_poly1305_update(struct shash_desc *desc,
 {
 	struct crypto_poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	/*
-	 * The key is passed as the first 32 "data" bytes.  The actual
-	 * poly1305_init() can be called only once the full key is available.
-	 */
-	if (dctx->keysize < POLY1305_KEY_SIZE) {
-		if (!dctx->keysize) {
-			if (arch)
-				poly1305_block_init_arch(&dctx->base.state,
-							 src);
-			else
-				poly1305_block_init_generic(&dctx->base.state,
-							    src);
-		}
-		dctx->keysize += POLY1305_BLOCK_SIZE;
-		src += POLY1305_BLOCK_SIZE;
-		srclen -= POLY1305_BLOCK_SIZE;
-		if (srclen < POLY1305_BLOCK_SIZE)
-			return srclen;
-
-		memcpy(&dctx->base.s, src, POLY1305_BLOCK_SIZE);
-		dctx->keysize += POLY1305_BLOCK_SIZE;
-		src += POLY1305_BLOCK_SIZE;
-		srclen -= POLY1305_BLOCK_SIZE;
-		if (srclen < POLY1305_BLOCK_SIZE)
-			return srclen;
-	}
-
 	if (arch)
-		poly1305_blocks_arch(&dctx->base.state, src, srclen, 1);
+		poly1305_blocks_arch(&dctx->state, src, srclen, 1);
 	else
-		poly1305_blocks_generic(&dctx->base.state, src, srclen, 1);
+		poly1305_blocks_generic(&dctx->state, src, srclen, 1);
 
 	return srclen % POLY1305_BLOCK_SIZE;
 }
@@ -127,29 +96,27 @@ static int crypto_poly1305_update_arch(struct shash_desc *desc,
 static inline int crypto_poly1305_finup(struct shash_desc *desc, const u8 *src,
 					unsigned int len, u8 *dst, bool arch)
 {
+	struct crypto_poly1305_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	struct crypto_poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (unlikely(dctx->keysize != POLY1305_KEY_SIZE))
-		return -ENOKEY;
-
 	if (unlikely(len)) {
 		u8 block[POLY1305_BLOCK_SIZE] = {};
 
 		memcpy(block, src, len);
 		block[len] = 1;
 		if (arch)
-			poly1305_blocks_arch(&dctx->base.state, block,
+			poly1305_blocks_arch(&dctx->state, block,
 					     POLY1305_BLOCK_SIZE, 0);
 		else
-			poly1305_blocks_generic(&dctx->base.state, block,
+			poly1305_blocks_generic(&dctx->state, block,
 						POLY1305_BLOCK_SIZE, 0);
 		memzero_explicit(block, sizeof(block));
 	}
 
 	if (arch)
-		poly1305_emit_arch(&dctx->base.state.h, dst, dctx->base.s);
+		poly1305_emit_arch(&dctx->state.h, dst, ctx->s);
 	else
-		poly1305_emit_generic(&dctx->base.state.h, dst, dctx->base.s);
+		poly1305_emit_generic(&dctx->state.h, dst, ctx->s);
 	return 0;
 }
 
@@ -171,8 +138,7 @@ static struct shash_alg poly1305_algs[] = {
 		.base.cra_name		= "poly1305",
 		.base.cra_driver_name	= "poly1305-generic",
 		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct crypto_poly1305_ctx),
 		.base.cra_module	= THIS_MODULE,
@@ -187,8 +153,7 @@ static struct shash_alg poly1305_algs[] = {
 		.base.cra_name		= "poly1305",
 		.base.cra_driver_name	= "poly1305-" __stringify(ARCH),
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					  CRYPTO_ALG_OPTIONAL_KEY,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct crypto_poly1305_ctx),
 		.base.cra_module	= THIS_MODULE,
-- 
2.39.5

