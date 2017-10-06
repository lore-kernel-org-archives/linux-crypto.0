From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 15/18] crypto: talitos - DMA map key in setkey()
Date: Fri,  6 Oct 2017 15:05:02 +0200 (CEST)
Message-ID: <5b6f50db4ac06bb900fb6136fc6aa2963c155524.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

dma_map_single() is an heavy operation which doesn't need to
be done at each request as the key doesn't change.

Instead of DMA mapping the key at every request, this patch maps it
once in setkey()

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 56 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 307d534a0f2f..ebfd6d982ed6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -815,6 +815,7 @@ struct talitos_ctx {
 	__be32 desc_hdr_template;
 	u8 key[TALITOS_MAX_KEY_SIZE];
 	u8 iv[TALITOS_MAX_IV_LENGTH];
+	dma_addr_t dma_key;
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
@@ -851,6 +852,7 @@ static int aead_setkey(struct crypto_aead *authenc,
 		       const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = ctx->dev;
 	struct crypto_authenc_keys keys;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
@@ -859,12 +861,17 @@ static int aead_setkey(struct crypto_aead *authenc,
 	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
 		goto badkey;
 
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
 	memcpy(ctx->key, keys.authkey, keys.authkeylen);
 	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
 
 	ctx->keylen = keys.authkeylen + keys.enckeylen;
 	ctx->enckeylen = keys.enckeylen;
 	ctx->authkeylen = keys.authkeylen;
+	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
+				      DMA_TO_DEVICE);
 
 	return 0;
 
@@ -940,14 +947,11 @@ static void ipsec_esp_unmap(struct device *dev,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
 	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
-	struct talitos_ptr *ckey_ptr = &edesc->desc.ptr[is_ipsec_esp ? 3 : 2];
 
 	if (is_ipsec_esp)
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
 					 DMA_FROM_DEVICE);
-	unmap_single_talitos_ptr(dev, ckey_ptr, DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
 			 areq->assoclen);
@@ -976,6 +980,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	struct aead_request *areq = context;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	unsigned int authsize = crypto_aead_authsize(authenc);
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
@@ -996,6 +1001,8 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 		       icvdata, authsize);
 	}
 
+	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
+
 	kfree(edesc);
 
 	aead_request_complete(areq, err);
@@ -1164,8 +1171,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
 
 	/* hmac key */
-	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
-			       DMA_TO_DEVICE);
+	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -1189,9 +1195,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
 
 	/* cipher key */
-	map_single_talitos_ptr(dev, ckey_ptr, ctx->enckeylen,
-			       (char *)&ctx->key + ctx->authkeylen,
-			       DMA_TO_DEVICE);
+	to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
+		       ctx->enckeylen, is_sec1);
 
 	/*
 	 * cipher in
@@ -1481,6 +1486,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct device *dev = ctx->dev;
 	u32 tmp[DES_EXPKEY_WORDS];
 
 	if (keylen > TALITOS_MAX_KEY_SIZE) {
@@ -1495,9 +1501,14 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 		return -EINVAL;
 	}
 
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
 	memcpy(&ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
+	ctx->dma_key = dma_map_single(dev, ctx->key, keylen, DMA_TO_DEVICE);
+
 	return 0;
 }
 
@@ -1508,7 +1519,6 @@ static void common_nonsnoop_unmap(struct device *dev,
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->nbytes, 0);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
@@ -1555,8 +1565,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
 
 	/* cipher key */
-	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-			       (char *)&ctx->key, DMA_TO_DEVICE);
+	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen, is_sec1);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -1666,10 +1675,6 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
 					 DMA_TO_DEVICE);
 
-	if (from_talitos_ptr_len(&edesc->desc.ptr[2], is_sec1))
-		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
-					 DMA_TO_DEVICE);
-
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
@@ -1750,8 +1755,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* HMAC key */
 	if (ctx->keylen)
-		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-				       (char *)&ctx->key, DMA_TO_DEVICE);
+		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
+			       is_sec1);
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -2084,6 +2089,7 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct device *dev = ctx->dev;
 	unsigned int blocksize =
 			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int digestsize = crypto_ahash_digestsize(tfm);
@@ -2106,7 +2112,11 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 		memcpy(ctx->key, hash, digestsize);
 	}
 
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
 	ctx->keylen = keysize;
+	ctx->dma_key = dma_map_single(dev, ctx->key, keysize, DMA_TO_DEVICE);
 
 	return 0;
 }
@@ -2935,6 +2945,15 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void talitos_cra_exit(struct crypto_tfm *tfm)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct device *dev = ctx->dev;
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+}
+
 /*
  * given the alg's descriptor header template, determine whether descriptor
  * type and primary/secondary execution units required match the hw
@@ -3010,6 +3029,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init;
+		alg->cra_exit = talitos_cra_exit;
 		alg->cra_type = &crypto_ablkcipher_type;
 		alg->cra_ablkcipher.setkey = ablkcipher_setkey;
 		alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
@@ -3018,6 +3038,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
+		alg->cra_exit = talitos_cra_exit;
 		t_alg->algt.alg.aead.init = talitos_cra_init_aead;
 		t_alg->algt.alg.aead.setkey = aead_setkey;
 		t_alg->algt.alg.aead.encrypt = aead_encrypt;
@@ -3031,6 +3052,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
+		alg->cra_exit = talitos_cra_exit;
 		alg->cra_type = &crypto_ahash_type;
 		t_alg->algt.alg.hash.init = ahash_init;
 		t_alg->algt.alg.hash.update = ahash_update;
-- 
2.13.3
