Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D017FAC2
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116241; cv=none; b=AMw91gQgnjUve3xpzGpSPvHIIG7cskneKoTUzIUdhzUF6RzQohmnp4Xbx0N/YakCOQVk5FTQLvCYe6UW8YTjzflcHSGU0JU79dYwCNZf3isxMadctn5P05OheWqLOa2KEm8NgvapurQctEJOYwXDDBCJ8tfc3unwc5NEvLYBQj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116241; c=relaxed/simple;
	bh=8QDdo3tonlTSur/bVevrx3rFlx7xfamv/9H8hTX5gKc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Zzz0xZIdFCZD67ykkJa/735kZ0c6SQ4d9oi4hod1h+N+0XdPwsYusCiK71N3fHdNuoZhe9IwiBlrgnw8nftamplnmDm2S9VKEx7lfFFZcz1+v/AMtHD7SGywfAu2UM5766ZQwAUqwvjEc/tNganm9TFOy2yLRUfTvBy/IYd8kuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iwHvzxcG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iwHvzxcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qaIj+ZcBl/cU0Sg+Bo5053DJynhFBXA+5ndSeoJA92E=; b=iwHvzxcGNCrJfEgQovANjTBagO
	aD0p6AMZAMYf1+3GNxtRutw11D8N3GYqH/wsToFI+mLuTkfMjS10AIj2RrWdXCZnh+UaeHViatd8M
	dMkzMaNAApQrzbC6OCUOHiSmEcjxrV3W7VgXWKtgP6yL4ApYcTY6R6+PBG2qQAnyvBAVrx4/J9ues
	3478yQ7tVIg+axcJ9eBDfrkg9jGSt7VkMwrbCaqHq9flMq7VRgQk1uV1n37+pHX33iylJQ9fFDsZ0
	SmKdaivKplejkXpnSiV0tfO+BfonU6eFFZN/dBNjsQ4LlHuooGpiDdTIwQJk8ezP8iIZqMmgWci2u
	4wA6osEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEik0-005g4H-0D;
	Tue, 13 May 2025 14:03:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:48 +0800
Date: Tue, 13 May 2025 14:03:48 +0800
Message-Id: <1a9548c383795a025076de7f6ee4fc465c287369.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 01/11] crypto: aspeed/hash - Remove purely software hmac
 implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The hmac implementation in aspeed simply duplicates what the new
ahash hmac template already does, namely construct ipad and opad
by hand and then adding them to the hash before feeding it to the
engine.

Remove them and just use the generic ahash hmac template.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 335 -----------------------
 drivers/crypto/aspeed/aspeed-hace.h      |  10 -
 2 files changed, 345 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 0b6e49c06eff..0bcec2d40ed6 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -5,7 +5,6 @@
 
 #include "aspeed-hace.h"
 #include <crypto/engine.h>
-#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
@@ -338,70 +337,6 @@ static int aspeed_hace_ahash_trigger(struct aspeed_hace_dev *hace_dev,
 	return -EINPROGRESS;
 }
 
-/*
- * HMAC resume aims to do the second pass produces
- * the final HMAC code derived from the inner hash
- * result and the outer key.
- */
-static int aspeed_ahash_hmac_resume(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-	int rc = 0;
-
-	AHASH_DBG(hace_dev, "\n");
-
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
-	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-			 rctx->block_size * 2, DMA_TO_DEVICE);
-
-	/* o key pad + hash sum 1 */
-	memcpy(rctx->buffer, bctx->opad, rctx->block_size);
-	memcpy(rctx->buffer + rctx->block_size, rctx->digest, rctx->digsize);
-
-	rctx->bufcnt = rctx->block_size + rctx->digsize;
-	rctx->digcnt[0] = rctx->block_size + rctx->digsize;
-
-	aspeed_ahash_fill_padding(hace_dev, rctx);
-	memcpy(rctx->digest, rctx->sha_iv, rctx->ivsize);
-
-	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
-					       SHA512_DIGEST_SIZE,
-					       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
-		rc = -ENOMEM;
-		goto end;
-	}
-
-	rctx->buffer_dma_addr = dma_map_single(hace_dev->dev, rctx->buffer,
-					       rctx->block_size * 2,
-					       DMA_TO_DEVICE);
-	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
-		rc = -ENOMEM;
-		goto free_rctx_digest;
-	}
-
-	hash_engine->src_dma = rctx->buffer_dma_addr;
-	hash_engine->src_length = rctx->bufcnt;
-	hash_engine->digest_dma = rctx->digest_dma_addr;
-
-	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
-
-free_rctx_digest:
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-end:
-	return rc;
-}
-
 static int aspeed_ahash_req_final(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
@@ -437,10 +372,6 @@ static int aspeed_ahash_req_final(struct aspeed_hace_dev *hace_dev)
 	hash_engine->src_length = rctx->bufcnt;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
-	if (rctx->flags & SHA_FLAGS_HMAC)
-		return aspeed_hace_ahash_trigger(hace_dev,
-						 aspeed_ahash_hmac_resume);
-
 	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
 
 free_rctx_digest:
@@ -609,16 +540,6 @@ static int aspeed_sham_update(struct ahash_request *req)
 	return aspeed_hace_hash_handle_queue(hace_dev, req);
 }
 
-static int aspeed_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
-				    const u8 *data, unsigned int len, u8 *out)
-{
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, data, len, out);
-}
-
 static int aspeed_sham_final(struct ahash_request *req)
 {
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
@@ -664,7 +585,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
 
 	AHASH_DBG(hace_dev, "%s: digest size:%d\n",
 		  crypto_tfm_alg_name(&tfm->base),
@@ -732,14 +652,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 	rctx->digcnt[0] = 0;
 	rctx->digcnt[1] = 0;
 
-	/* HMAC init */
-	if (tctx->flags & SHA_FLAGS_HMAC) {
-		rctx->digcnt[0] = rctx->block_size;
-		rctx->bufcnt = rctx->block_size;
-		memcpy(rctx->buffer, bctx->ipad, rctx->block_size);
-		rctx->flags |= SHA_FLAGS_HMAC;
-	}
-
 	return 0;
 }
 
@@ -748,43 +660,6 @@ static int aspeed_sham_digest(struct ahash_request *req)
 	return aspeed_sham_init(req) ? : aspeed_sham_finup(req);
 }
 
-static int aspeed_sham_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-	int ds = crypto_shash_digestsize(bctx->shash);
-	int bs = crypto_shash_blocksize(bctx->shash);
-	int err = 0;
-	int i;
-
-	AHASH_DBG(hace_dev, "%s: keylen:%d\n", crypto_tfm_alg_name(&tfm->base),
-		  keylen);
-
-	if (keylen > bs) {
-		err = aspeed_sham_shash_digest(bctx->shash,
-					       crypto_shash_get_flags(bctx->shash),
-					       key, keylen, bctx->ipad);
-		if (err)
-			return err;
-		keylen = ds;
-
-	} else {
-		memcpy(bctx->ipad, key, keylen);
-	}
-
-	memset(bctx->ipad + keylen, 0, bs - keylen);
-	memcpy(bctx->opad, bctx->ipad, bs);
-
-	for (i = 0; i < bs; i++) {
-		bctx->ipad[i] ^= HMAC_IPAD_VALUE;
-		bctx->opad[i] ^= HMAC_OPAD_VALUE;
-	}
-
-	return err;
-}
-
 static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
 {
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
@@ -793,43 +668,13 @@ static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
 
 	ast_alg = container_of(alg, struct aspeed_hace_alg, alg.ahash.base);
 	tctx->hace_dev = ast_alg->hace_dev;
-	tctx->flags = 0;
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct aspeed_sham_reqctx));
 
-	if (ast_alg->alg_base) {
-		/* hmac related */
-		struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-
-		tctx->flags |= SHA_FLAGS_HMAC;
-		bctx->shash = crypto_alloc_shash(ast_alg->alg_base, 0,
-						 CRYPTO_ALG_NEED_FALLBACK);
-		if (IS_ERR(bctx->shash)) {
-			dev_warn(ast_alg->hace_dev->dev,
-				 "base driver '%s' could not be loaded.\n",
-				 ast_alg->alg_base);
-			return PTR_ERR(bctx->shash);
-		}
-	}
-
 	return 0;
 }
 
-static void aspeed_sham_cra_exit(struct crypto_tfm *tfm)
-{
-	struct aspeed_sham_ctx *tctx = crypto_tfm_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-
-	AHASH_DBG(hace_dev, "%s\n", crypto_tfm_alg_name(tfm));
-
-	if (tctx->flags & SHA_FLAGS_HMAC) {
-		struct aspeed_sha_hmac_ctx *bctx = tctx->base;
-
-		crypto_free_shash(bctx->shash);
-	}
-}
-
 static int aspeed_sham_export(struct ahash_request *req, void *out)
 {
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
@@ -873,7 +718,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
 					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -905,7 +749,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
 					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -937,112 +780,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
 					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha1",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA1_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha1)",
-					.cra_driver_name	= "aspeed-hmac-sha1",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA1_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha224",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha224)",
-					.cra_driver_name	= "aspeed-hmac-sha224",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA224_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha256",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha256)",
-					.cra_driver_name	= "aspeed-hmac-sha256",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA256_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -1077,7 +814,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
 					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
@@ -1109,77 +845,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_alignmask		= 0,
 					.cra_module		= THIS_MODULE,
 					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha384",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha384)",
-					.cra_driver_name	= "aspeed-hmac-sha384",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA384_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
-				}
-			}
-		},
-		.alg.ahash.op = {
-			.do_one_request = aspeed_ahash_do_one,
-		},
-	},
-	{
-		.alg_base = "sha512",
-		.alg.ahash.base = {
-			.init	= aspeed_sham_init,
-			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
-			.finup	= aspeed_sham_finup,
-			.digest	= aspeed_sham_digest,
-			.setkey	= aspeed_sham_setkey,
-			.export	= aspeed_sham_export,
-			.import	= aspeed_sham_import,
-			.halg = {
-				.digestsize = SHA512_DIGEST_SIZE,
-				.statesize = sizeof(struct aspeed_sham_reqctx),
-				.base = {
-					.cra_name		= "hmac(sha512)",
-					.cra_driver_name	= "aspeed-hmac-sha512",
-					.cra_priority		= 300,
-					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
-								  CRYPTO_ALG_ASYNC |
-								  CRYPTO_ALG_KERN_DRIVER_ONLY,
-					.cra_blocksize		= SHA512_BLOCK_SIZE,
-					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx) +
-								sizeof(struct aspeed_sha_hmac_ctx),
-					.cra_alignmask		= 0,
-					.cra_module		= THIS_MODULE,
-					.cra_init		= aspeed_sham_cra_init,
-					.cra_exit		= aspeed_sham_cra_exit,
 				}
 			}
 		},
diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index 68f70e01fccb..7ff1798bc198 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -119,7 +119,6 @@
 #define SHA_FLAGS_SHA512		BIT(4)
 #define SHA_FLAGS_SHA512_224		BIT(5)
 #define SHA_FLAGS_SHA512_256		BIT(6)
-#define SHA_FLAGS_HMAC			BIT(8)
 #define SHA_FLAGS_FINUP			BIT(9)
 #define SHA_FLAGS_MASK			(0xff)
 
@@ -161,17 +160,8 @@ struct aspeed_engine_hash {
 	aspeed_hace_fn_t		dma_prepare;
 };
 
-struct aspeed_sha_hmac_ctx {
-	struct crypto_shash *shash;
-	u8 ipad[SHA512_BLOCK_SIZE];
-	u8 opad[SHA512_BLOCK_SIZE];
-};
-
 struct aspeed_sham_ctx {
 	struct aspeed_hace_dev		*hace_dev;
-	unsigned long			flags;	/* hmac flag */
-
-	struct aspeed_sha_hmac_ctx	base[];
 };
 
 struct aspeed_sham_reqctx {
-- 
2.39.5

