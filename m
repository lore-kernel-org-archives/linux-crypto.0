From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] crypto: picoxcell - Convert to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:19 +0800
Message-ID: <E1ZKkWd-0004Bp-Fy@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
Cc: Jamie Iles <jamie@jamieiles.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47516 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbbG3JxZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts picoxcell to the new AEAD interface.  IV
generation has been removed since it's equivalent to a software
implementation.

As picoxcell cannot handle SG lists longer than 16 elements,
this patch has made the software fallback mandatory.  If an SG
list comes in that exceeds the limit, we will simply use the
fallback.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |  678 +++++++++++++++++---------------------
 1 file changed, 311 insertions(+), 367 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 4f56f36..e0f0c34 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -99,11 +99,16 @@ struct spacc_req {
 	dma_addr_t			src_addr, dst_addr;
 	struct spacc_ddt		*src_ddt, *dst_ddt;
 	void				(*complete)(struct spacc_req *req);
+};
 
-	/* AEAD specific bits. */
-	u8				*giv;
-	size_t				giv_len;
-	dma_addr_t			giv_pa;
+struct spacc_aead {
+	unsigned long			ctrl_default;
+	unsigned long			type;
+	struct aead_alg			alg;
+	struct spacc_engine		*engine;
+	struct list_head		entry;
+	int				key_offs;
+	int				iv_offs;
 };
 
 struct spacc_engine {
@@ -121,6 +126,9 @@ struct spacc_engine {
 	struct spacc_alg		*algs;
 	unsigned			num_algs;
 	struct list_head		registered_algs;
+	struct spacc_aead		*aeads;
+	unsigned			num_aeads;
+	struct list_head		registered_aeads;
 	size_t				cipher_pg_sz;
 	size_t				hash_pg_sz;
 	const char			*name;
@@ -174,8 +182,6 @@ struct spacc_aead_ctx {
 	u8				cipher_key_len;
 	u8				hash_key_len;
 	struct crypto_aead		*sw_cipher;
-	size_t				auth_size;
-	u8				salt[AES_BLOCK_SIZE];
 };
 
 static int spacc_ablk_submit(struct spacc_req *req);
@@ -185,6 +191,11 @@ static inline struct spacc_alg *to_spacc_alg(struct crypto_alg *alg)
 	return alg ? container_of(alg, struct spacc_alg, alg) : NULL;
 }
 
+static inline struct spacc_aead *to_spacc_aead(struct aead_alg *alg)
+{
+	return container_of(alg, struct spacc_aead, alg);
+}
+
 static inline int spacc_fifo_cmd_full(struct spacc_engine *engine)
 {
 	u32 fifo_stat = readl(engine->regs + SPA_FIFO_STAT_REG_OFFSET);
@@ -310,120 +321,117 @@ out:
 	return NULL;
 }
 
-static int spacc_aead_make_ddts(struct spacc_req *req, u8 *giv)
+static int spacc_aead_make_ddts(struct aead_request *areq)
 {
-	struct aead_request *areq = container_of(req->req, struct aead_request,
-						 base);
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct spacc_req *req = aead_request_ctx(areq);
 	struct spacc_engine *engine = req->engine;
 	struct spacc_ddt *src_ddt, *dst_ddt;
-	unsigned ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(areq));
-	unsigned nents = sg_count(areq->src, areq->cryptlen);
 	unsigned total;
-	dma_addr_t iv_addr;
+	unsigned int src_nents, dst_nents;
 	struct scatterlist *cur;
-	int i, dst_ents, src_ents, assoc_ents;
-	u8 *iv = giv ? giv : areq->iv;
+	int i, dst_ents, src_ents;
+
+	total = areq->assoclen + areq->cryptlen;
+	if (req->is_encrypt)
+		total += crypto_aead_authsize(aead);
+
+	src_nents = sg_count(areq->src, total);
+	if (src_nents + 1 > MAX_DDT_LEN)
+		return -E2BIG;
+
+	dst_nents = 0;
+	if (areq->src != areq->dst) {
+		dst_nents = sg_count(areq->dst, total);
+		if (src_nents + 1 > MAX_DDT_LEN)
+			return -E2BIG;
+	}
 
 	src_ddt = dma_pool_alloc(engine->req_pool, GFP_ATOMIC, &req->src_addr);
 	if (!src_ddt)
-		return -ENOMEM;
+		goto err;
 
 	dst_ddt = dma_pool_alloc(engine->req_pool, GFP_ATOMIC, &req->dst_addr);
-	if (!dst_ddt) {
-		dma_pool_free(engine->req_pool, src_ddt, req->src_addr);
-		return -ENOMEM;
-	}
+	if (!dst_ddt)
+		goto err_free_src;
 
 	req->src_ddt = src_ddt;
 	req->dst_ddt = dst_ddt;
 
-	assoc_ents = dma_map_sg(engine->dev, areq->assoc,
-		sg_count(areq->assoc, areq->assoclen), DMA_TO_DEVICE);
-	if (areq->src != areq->dst) {
-		src_ents = dma_map_sg(engine->dev, areq->src, nents,
+	if (dst_nents) {
+		src_ents = dma_map_sg(engine->dev, areq->src, src_nents,
 				      DMA_TO_DEVICE);
-		dst_ents = dma_map_sg(engine->dev, areq->dst, nents,
+		if (!src_ents)
+			goto err_free_dst;
+
+		dst_ents = dma_map_sg(engine->dev, areq->dst, dst_nents,
 				      DMA_FROM_DEVICE);
+
+		if (!dst_ents) {
+			dma_unmap_sg(engine->dev, areq->src, src_nents,
+				     DMA_TO_DEVICE);
+			goto err_free_dst;
+		}
 	} else {
-		src_ents = dma_map_sg(engine->dev, areq->src, nents,
+		src_ents = dma_map_sg(engine->dev, areq->src, src_nents,
 				      DMA_BIDIRECTIONAL);
-		dst_ents = 0;
+		if (!src_ents)
+			goto err_free_dst;
+		dst_ents = src_ents;
 	}
 
 	/*
-	 * Map the IV/GIV. For the GIV it needs to be bidirectional as it is
-	 * formed by the crypto block and sent as the ESP IV for IPSEC.
+	 * Now map in the payload for the source and destination and terminate
+	 * with the NULL pointers.
 	 */
-	iv_addr = dma_map_single(engine->dev, iv, ivsize,
-				 giv ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-	req->giv_pa = iv_addr;
+	for_each_sg(areq->src, cur, src_ents, i)
+		ddt_set(src_ddt++, sg_dma_address(cur), sg_dma_len(cur));
 
-	/*
-	 * Map the associated data. For decryption we don't copy the
-	 * associated data.
-	 */
-	total = areq->assoclen;
-	for_each_sg(areq->assoc, cur, assoc_ents, i) {
+	/* For decryption we need to skip the associated data. */
+	total = req->is_encrypt ? 0 : areq->assoclen;
+	for_each_sg(areq->dst, cur, dst_ents, i) {
 		unsigned len = sg_dma_len(cur);
 
-		if (len > total)
-			len = total;
-
-		total -= len;
+		if (len <= total) {
+			total -= len;
+			continue;
+		}
 
-		ddt_set(src_ddt++, sg_dma_address(cur), len);
-		if (req->is_encrypt)
-			ddt_set(dst_ddt++, sg_dma_address(cur), len);
+		ddt_set(dst_ddt++, sg_dma_address(cur) + total, len - total);
 	}
-	ddt_set(src_ddt++, iv_addr, ivsize);
-
-	if (giv || req->is_encrypt)
-		ddt_set(dst_ddt++, iv_addr, ivsize);
-
-	/*
-	 * Now map in the payload for the source and destination and terminate
-	 * with the NULL pointers.
-	 */
-	for_each_sg(areq->src, cur, src_ents, i) {
-		ddt_set(src_ddt++, sg_dma_address(cur), sg_dma_len(cur));
-		if (areq->src == areq->dst)
-			ddt_set(dst_ddt++, sg_dma_address(cur),
-				sg_dma_len(cur));
-	}
-
-	for_each_sg(areq->dst, cur, dst_ents, i)
-		ddt_set(dst_ddt++, sg_dma_address(cur),
-			sg_dma_len(cur));
 
 	ddt_set(src_ddt, 0, 0);
 	ddt_set(dst_ddt, 0, 0);
 
 	return 0;
+
+err_free_dst:
+	dma_pool_free(engine->req_pool, dst_ddt, req->dst_addr);
+err_free_src:
+	dma_pool_free(engine->req_pool, src_ddt, req->src_addr);
+err:
+	return -ENOMEM;
 }
 
 static void spacc_aead_free_ddts(struct spacc_req *req)
 {
 	struct aead_request *areq = container_of(req->req, struct aead_request,
 						 base);
-	struct spacc_alg *alg = to_spacc_alg(req->req->tfm->__crt_alg);
-	struct spacc_ablk_ctx *aead_ctx = crypto_tfm_ctx(req->req->tfm);
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	unsigned total = areq->assoclen + areq->cryptlen +
+			 (req->is_encrypt ? crypto_aead_authsize(aead) : 0);
+	struct spacc_aead_ctx *aead_ctx = crypto_aead_ctx(aead);
 	struct spacc_engine *engine = aead_ctx->generic.engine;
-	unsigned ivsize = alg->alg.cra_aead.ivsize;
-	unsigned nents = sg_count(areq->src, areq->cryptlen);
+	unsigned nents = sg_count(areq->src, total);
 
 	if (areq->src != areq->dst) {
 		dma_unmap_sg(engine->dev, areq->src, nents, DMA_TO_DEVICE);
 		dma_unmap_sg(engine->dev, areq->dst,
-			     sg_count(areq->dst, areq->cryptlen),
+			     sg_count(areq->dst, total),
 			     DMA_FROM_DEVICE);
 	} else
 		dma_unmap_sg(engine->dev, areq->src, nents, DMA_BIDIRECTIONAL);
 
-	dma_unmap_sg(engine->dev, areq->assoc,
-		     sg_count(areq->assoc, areq->assoclen), DMA_TO_DEVICE);
-
-	dma_unmap_single(engine->dev, req->giv_pa, ivsize, DMA_BIDIRECTIONAL);
-
 	dma_pool_free(engine->req_pool, req->src_ddt, req->src_addr);
 	dma_pool_free(engine->req_pool, req->dst_ddt, req->dst_addr);
 }
@@ -438,65 +446,22 @@ static void spacc_free_ddt(struct spacc_req *req, struct spacc_ddt *ddt,
 	dma_pool_free(req->engine->req_pool, ddt, ddt_addr);
 }
 
-/*
- * Set key for a DES operation in an AEAD cipher. This also performs weak key
- * checking if required.
- */
-static int spacc_aead_des_setkey(struct crypto_aead *aead, const u8 *key,
-				 unsigned int len)
-{
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (unlikely(!des_ekey(tmp, key)) &&
-	    (crypto_aead_get_flags(aead)) & CRYPTO_TFM_REQ_WEAK_KEY) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
-
-	memcpy(ctx->cipher_key, key, len);
-	ctx->cipher_key_len = len;
-
-	return 0;
-}
-
-/* Set the key for the AES block cipher component of the AEAD transform. */
-static int spacc_aead_aes_setkey(struct crypto_aead *aead, const u8 *key,
-				 unsigned int len)
-{
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	/*
-	 * IPSec engine only supports 128 and 256 bit AES keys. If we get a
-	 * request for any other size (192 bits) then we need to do a software
-	 * fallback.
-	 */
-	if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256) {
-		/*
-		 * Set the fallback transform to use the same request flags as
-		 * the hardware transform.
-		 */
-		ctx->sw_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-		ctx->sw_cipher->base.crt_flags |=
-			tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
-		return crypto_aead_setkey(ctx->sw_cipher, key, len);
-	}
-
-	memcpy(ctx->cipher_key, key, len);
-	ctx->cipher_key_len = len;
-
-	return 0;
-}
-
 static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct spacc_alg *alg = to_spacc_alg(tfm->base.__crt_alg);
 	struct crypto_authenc_keys keys;
-	int err = -EINVAL;
+	int err;
+
+	crypto_aead_clear_flags(ctx->sw_cipher, CRYPTO_TFM_REQ_MASK);
+	crypto_aead_set_flags(ctx->sw_cipher, crypto_aead_get_flags(tfm) &
+					      CRYPTO_TFM_REQ_MASK);
+	err = crypto_aead_setkey(ctx->sw_cipher, key, keylen);
+	crypto_aead_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
+	crypto_aead_set_flags(tfm, crypto_aead_get_flags(ctx->sw_cipher) &
+				   CRYPTO_TFM_RES_MASK);
+	if (err)
+		return err;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto badkey;
@@ -507,14 +472,8 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->hash_ctx))
 		goto badkey;
 
-	if ((alg->ctrl_default & SPACC_CRYPTO_ALG_MASK) ==
-	    SPA_CTRL_CIPH_ALG_AES)
-		err = spacc_aead_aes_setkey(tfm, keys.enckey, keys.enckeylen);
-	else
-		err = spacc_aead_des_setkey(tfm, keys.enckey, keys.enckeylen);
-
-	if (err)
-		goto badkey;
+	memcpy(ctx->cipher_key, keys.enckey, keys.enckeylen);
+	ctx->cipher_key_len = keys.enckeylen;
 
 	memcpy(ctx->hash_ctx, keys.authkey, keys.authkeylen);
 	ctx->hash_key_len = keys.authkeylen;
@@ -531,9 +490,7 @@ static int spacc_aead_setauthsize(struct crypto_aead *tfm,
 {
 	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(crypto_aead_tfm(tfm));
 
-	ctx->auth_size = authsize;
-
-	return 0;
+	return crypto_aead_setauthsize(ctx->sw_cipher, authsize);
 }
 
 /*
@@ -541,15 +498,13 @@ static int spacc_aead_setauthsize(struct crypto_aead *tfm,
  * be completed in hardware because the hardware may not support certain key
  * sizes. In these cases we need to complete the request in software.
  */
-static int spacc_aead_need_fallback(struct spacc_req *req)
+static int spacc_aead_need_fallback(struct aead_request *aead_req)
 {
-	struct aead_request *aead_req;
-	struct crypto_tfm *tfm = req->req->tfm;
-	struct crypto_alg *alg = req->req->tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct spacc_aead *spacc_alg = to_spacc_aead(alg);
+	struct spacc_aead_ctx *ctx = crypto_aead_ctx(aead);
 
-	aead_req = container_of(req->req, struct aead_request, base);
 	/*
 	 * If we have a non-supported key-length, then we need to do a
 	 * software fallback.
@@ -568,22 +523,17 @@ static int spacc_aead_do_fallback(struct aead_request *req, unsigned alg_type,
 {
 	struct crypto_tfm *old_tfm = crypto_aead_tfm(crypto_aead_reqtfm(req));
 	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(old_tfm);
-	int err;
+	struct aead_request *subreq = aead_request_ctx(req);
 
-	if (ctx->sw_cipher) {
-		/*
-		 * Change the request to use the software fallback transform,
-		 * and once the ciphering has completed, put the old transform
-		 * back into the request.
-		 */
-		aead_request_set_tfm(req, ctx->sw_cipher);
-		err = is_encrypt ? crypto_aead_encrypt(req) :
-		    crypto_aead_decrypt(req);
-		aead_request_set_tfm(req, __crypto_aead_cast(old_tfm));
-	} else
-		err = -EINVAL;
+	aead_request_set_tfm(subreq, ctx->sw_cipher);
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
 
-	return err;
+	return is_encrypt ? crypto_aead_encrypt(subreq) :
+			    crypto_aead_decrypt(subreq);
 }
 
 static void spacc_aead_complete(struct spacc_req *req)
@@ -594,18 +544,19 @@ static void spacc_aead_complete(struct spacc_req *req)
 
 static int spacc_aead_submit(struct spacc_req *req)
 {
-	struct crypto_tfm *tfm = req->req->tfm;
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = req->req->tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
-	struct spacc_engine *engine = ctx->generic.engine;
-	u32 ctrl, proc_len, assoc_len;
 	struct aead_request *aead_req =
 		container_of(req->req, struct aead_request, base);
+	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	struct spacc_aead_ctx *ctx = crypto_aead_ctx(aead);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct spacc_aead *spacc_alg = to_spacc_aead(alg);
+	struct spacc_engine *engine = ctx->generic.engine;
+	u32 ctrl, proc_len, assoc_len;
 
 	req->result = -EINPROGRESS;
 	req->ctx_id = spacc_load_ctx(&ctx->generic, ctx->cipher_key,
-		ctx->cipher_key_len, aead_req->iv, alg->cra_aead.ivsize,
+		ctx->cipher_key_len, aead_req->iv, crypto_aead_ivsize(aead),
 		ctx->hash_ctx, ctx->hash_key_len);
 
 	/* Set the source and destination DDT pointers. */
@@ -617,25 +568,15 @@ static int spacc_aead_submit(struct spacc_req *req)
 	proc_len = aead_req->cryptlen + assoc_len;
 
 	/*
-	 * If we aren't generating an IV, then we need to include the IV in the
-	 * associated data so that it is included in the hash.
-	 */
-	if (!req->giv) {
-		assoc_len += crypto_aead_ivsize(crypto_aead_reqtfm(aead_req));
-		proc_len += crypto_aead_ivsize(crypto_aead_reqtfm(aead_req));
-	} else
-		proc_len += req->giv_len;
-
-	/*
 	 * If we are decrypting, we need to take the length of the ICV out of
 	 * the processing length.
 	 */
 	if (!req->is_encrypt)
-		proc_len -= ctx->auth_size;
+		proc_len -= authsize;
 
 	writel(proc_len, engine->regs + SPA_PROC_LEN_REG_OFFSET);
 	writel(assoc_len, engine->regs + SPA_AAD_LEN_REG_OFFSET);
-	writel(ctx->auth_size, engine->regs + SPA_ICV_LEN_REG_OFFSET);
+	writel(authsize, engine->regs + SPA_ICV_LEN_REG_OFFSET);
 	writel(0, engine->regs + SPA_ICV_OFFSET_REG_OFFSET);
 	writel(0, engine->regs + SPA_AUX_INFO_REG_OFFSET);
 
@@ -674,32 +615,29 @@ static void spacc_push(struct spacc_engine *engine)
 /*
  * Setup an AEAD request for processing. This will configure the engine, load
  * the context and then start the packet processing.
- *
- * @giv Pointer to destination address for a generated IV. If the
- *	request does not need to generate an IV then this should be set to NULL.
  */
-static int spacc_aead_setup(struct aead_request *req, u8 *giv,
+static int spacc_aead_setup(struct aead_request *req,
 			    unsigned alg_type, bool is_encrypt)
 {
-	struct crypto_alg *alg = req->base.tfm->__crt_alg;
-	struct spacc_engine *engine = to_spacc_alg(alg)->engine;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct spacc_engine *engine = to_spacc_aead(alg)->engine;
 	struct spacc_req *dev_req = aead_request_ctx(req);
-	int err = -EINPROGRESS;
+	int err;
 	unsigned long flags;
-	unsigned ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
 
-	dev_req->giv		= giv;
-	dev_req->giv_len	= ivsize;
 	dev_req->req		= &req->base;
 	dev_req->is_encrypt	= is_encrypt;
 	dev_req->result		= -EBUSY;
 	dev_req->engine		= engine;
 	dev_req->complete	= spacc_aead_complete;
 
-	if (unlikely(spacc_aead_need_fallback(dev_req)))
+	if (unlikely(spacc_aead_need_fallback(req) ||
+		     ((err = spacc_aead_make_ddts(req)) == -E2BIG)))
 		return spacc_aead_do_fallback(req, alg_type, is_encrypt);
 
-	spacc_aead_make_ddts(dev_req, dev_req->giv);
+	if (err)
+		goto out;
 
 	err = -EINPROGRESS;
 	spin_lock_irqsave(&engine->hw_lock, flags);
@@ -728,70 +666,44 @@ out:
 static int spacc_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct spacc_alg *alg = to_spacc_alg(tfm->__crt_alg);
+	struct spacc_aead *alg = to_spacc_aead(crypto_aead_alg(aead));
 
-	return spacc_aead_setup(req, NULL, alg->type, 1);
-}
-
-static int spacc_aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	struct crypto_aead *tfm = aead_givcrypt_reqtfm(req);
-	struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	size_t ivsize = crypto_aead_ivsize(tfm);
-	struct spacc_alg *alg = to_spacc_alg(tfm->base.__crt_alg);
-	unsigned len;
-	__be64 seq;
-
-	memcpy(req->areq.iv, ctx->salt, ivsize);
-	len = ivsize;
-	if (ivsize > sizeof(u64)) {
-		memset(req->giv, 0, ivsize - sizeof(u64));
-		len = sizeof(u64);
-	}
-	seq = cpu_to_be64(req->seq);
-	memcpy(req->giv + ivsize - len, &seq, len);
-
-	return spacc_aead_setup(&req->areq, req->giv, alg->type, 1);
+	return spacc_aead_setup(req, alg->type, 1);
 }
 
 static int spacc_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct spacc_alg *alg = to_spacc_alg(tfm->__crt_alg);
+	struct spacc_aead  *alg = to_spacc_aead(crypto_aead_alg(aead));
 
-	return spacc_aead_setup(req, NULL, alg->type, 0);
+	return spacc_aead_setup(req, alg->type, 0);
 }
 
 /*
  * Initialise a new AEAD context. This is responsible for allocating the
  * fallback cipher and initialising the context.
  */
-static int spacc_aead_cra_init(struct crypto_tfm *tfm)
+static int spacc_aead_cra_init(struct crypto_aead *tfm)
 {
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
+	struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct spacc_aead *spacc_alg = to_spacc_aead(alg);
 	struct spacc_engine *engine = spacc_alg->engine;
 
 	ctx->generic.flags = spacc_alg->type;
 	ctx->generic.engine = engine;
-	ctx->sw_cipher = crypto_alloc_aead(alg->cra_name, 0,
-					   CRYPTO_ALG_ASYNC |
+	ctx->sw_cipher = crypto_alloc_aead(alg->base.cra_name, 0,
 					   CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->sw_cipher)) {
-		dev_warn(engine->dev, "failed to allocate fallback for %s\n",
-			 alg->cra_name);
-		ctx->sw_cipher = NULL;
-	}
+	if (IS_ERR(ctx->sw_cipher))
+		return PTR_ERR(ctx->sw_cipher);
 	ctx->generic.key_offs = spacc_alg->key_offs;
 	ctx->generic.iv_offs = spacc_alg->iv_offs;
 
-	get_random_bytes(ctx->salt, sizeof(ctx->salt));
-
-	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
-				sizeof(struct spacc_req));
+	crypto_aead_set_reqsize(
+		tfm,
+		max(sizeof(struct spacc_req),
+		    sizeof(struct aead_request) +
+		    crypto_aead_reqsize(ctx->sw_cipher)));
 
 	return 0;
 }
@@ -800,13 +712,11 @@ static int spacc_aead_cra_init(struct crypto_tfm *tfm)
  * Destructor for an AEAD context. This is called when the transform is freed
  * and must free the fallback cipher.
  */
-static void spacc_aead_cra_exit(struct crypto_tfm *tfm)
+static void spacc_aead_cra_exit(struct crypto_aead *tfm)
 {
-	struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
-	if (ctx->sw_cipher)
-		crypto_free_aead(ctx->sw_cipher);
-	ctx->sw_cipher = NULL;
+	crypto_free_aead(ctx->sw_cipher);
 }
 
 /*
@@ -1458,180 +1368,188 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.cra_exit = spacc_ablk_cra_exit,
 		},
 	},
+};
+
+static struct spacc_aead ipsec_engine_aeads[] = {
 	{
-		.ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_CBC |
-				SPA_CTRL_HASH_ALG_SHA | SPA_CTRL_HASH_MODE_HMAC,
+		.ctrl_default = SPA_CTRL_CIPH_ALG_AES |
+				SPA_CTRL_CIPH_MODE_CBC |
+				SPA_CTRL_HASH_ALG_SHA |
+				SPA_CTRL_HASH_MODE_HMAC,
 		.key_offs = 0,
 		.iv_offs = AES_MAX_KEY_SIZE,
 		.alg = {
-			.cra_name = "authenc(hmac(sha1),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA1_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 	{
-		.ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_CBC |
+		.ctrl_default = SPA_CTRL_CIPH_ALG_AES |
+				SPA_CTRL_CIPH_MODE_CBC |
 				SPA_CTRL_HASH_ALG_SHA256 |
 				SPA_CTRL_HASH_MODE_HMAC,
 		.key_offs = 0,
 		.iv_offs = AES_MAX_KEY_SIZE,
 		.alg = {
-			.cra_name = "authenc(hmac(sha256),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = SHA256_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 	{
 		.key_offs = 0,
 		.iv_offs = AES_MAX_KEY_SIZE,
-		.ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_CBC |
-				SPA_CTRL_HASH_ALG_MD5 | SPA_CTRL_HASH_MODE_HMAC,
+		.ctrl_default = SPA_CTRL_CIPH_ALG_AES |
+				SPA_CTRL_CIPH_MODE_CBC |
+				SPA_CTRL_HASH_ALG_MD5 |
+				SPA_CTRL_HASH_MODE_HMAC,
 		.alg = {
-			.cra_name = "authenc(hmac(md5),cbc(aes))",
-			.cra_driver_name = "authenc-hmac-md5-cbc-aes-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = AES_BLOCK_SIZE,
-				.maxauthsize = MD5_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 	{
 		.key_offs = DES_BLOCK_SIZE,
 		.iv_offs = 0,
-		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_CBC |
-				SPA_CTRL_HASH_ALG_SHA | SPA_CTRL_HASH_MODE_HMAC,
+		.ctrl_default = SPA_CTRL_CIPH_ALG_DES |
+				SPA_CTRL_CIPH_MODE_CBC |
+				SPA_CTRL_HASH_ALG_SHA |
+				SPA_CTRL_HASH_MODE_HMAC,
 		.alg = {
-			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA1_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-3des-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 	{
 		.key_offs = DES_BLOCK_SIZE,
 		.iv_offs = 0,
-		.ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_CBC |
+		.ctrl_default = SPA_CTRL_CIPH_ALG_AES |
+				SPA_CTRL_CIPH_MODE_CBC |
 				SPA_CTRL_HASH_ALG_SHA256 |
 				SPA_CTRL_HASH_MODE_HMAC,
 		.alg = {
-			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = SHA256_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-3des-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 	{
 		.key_offs = DES_BLOCK_SIZE,
 		.iv_offs = 0,
-		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_CBC |
-				SPA_CTRL_HASH_ALG_MD5 | SPA_CTRL_HASH_MODE_HMAC,
+		.ctrl_default = SPA_CTRL_CIPH_ALG_DES |
+				SPA_CTRL_CIPH_MODE_CBC |
+				SPA_CTRL_HASH_ALG_MD5 |
+				SPA_CTRL_HASH_MODE_HMAC,
 		.alg = {
-			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-			.cra_driver_name = "authenc-hmac-md5-cbc-3des-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_aead_ctx),
-			.cra_type = &crypto_aead_type,
-			.cra_module = THIS_MODULE,
-			.cra_aead = {
-				.setkey = spacc_aead_setkey,
-				.setauthsize = spacc_aead_setauthsize,
-				.encrypt = spacc_aead_encrypt,
-				.decrypt = spacc_aead_decrypt,
-				.givencrypt = spacc_aead_givencrypt,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-				.maxauthsize = MD5_DIGEST_SIZE,
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-3des-picoxcell",
+				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct spacc_aead_ctx),
+				.cra_module = THIS_MODULE,
 			},
-			.cra_init = spacc_aead_cra_init,
-			.cra_exit = spacc_aead_cra_exit,
+			.setkey = spacc_aead_setkey,
+			.setauthsize = spacc_aead_setauthsize,
+			.encrypt = spacc_aead_encrypt,
+			.decrypt = spacc_aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			.init = spacc_aead_cra_init,
+			.exit = spacc_aead_cra_exit,
 		},
 	},
 };
@@ -1707,6 +1625,8 @@ static int spacc_probe(struct platform_device *pdev)
 		engine->fifo_sz		= SPACC_CRYPTO_IPSEC_FIFO_SZ;
 		engine->algs		= ipsec_engine_algs;
 		engine->num_algs	= ARRAY_SIZE(ipsec_engine_algs);
+		engine->aeads		= ipsec_engine_aeads;
+		engine->num_aeads	= ARRAY_SIZE(ipsec_engine_aeads);
 	} else if (spacc_is_compatible(pdev, "picochip,spacc-l2")) {
 		engine->max_ctxs	= SPACC_CRYPTO_L2_MAX_CTXS;
 		engine->cipher_pg_sz	= SPACC_CRYPTO_L2_CIPHER_PG_SZ;
@@ -1815,17 +1735,41 @@ static int spacc_probe(struct platform_device *pdev)
 				engine->algs[i].alg.cra_name);
 	}
 
+	INIT_LIST_HEAD(&engine->registered_aeads);
+	for (i = 0; i < engine->num_aeads; ++i) {
+		engine->aeads[i].engine = engine;
+		engine->aeads[i].alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
+		err = crypto_register_aead(&engine->aeads[i].alg);
+		if (!err) {
+			list_add_tail(&engine->aeads[i].entry,
+				      &engine->registered_aeads);
+			ret = 0;
+		}
+		if (err)
+			dev_err(engine->dev, "failed to register alg \"%s\"\n",
+				engine->aeads[i].alg.base.cra_name);
+		else
+			dev_dbg(engine->dev, "registered alg \"%s\"\n",
+				engine->aeads[i].alg.base.cra_name);
+	}
+
 	return ret;
 }
 
 static int spacc_remove(struct platform_device *pdev)
 {
+	struct spacc_aead *aead, *an;
 	struct spacc_alg *alg, *next;
 	struct spacc_engine *engine = platform_get_drvdata(pdev);
 
 	del_timer_sync(&engine->packet_timeout);
 	device_remove_file(&pdev->dev, &dev_attr_stat_irq_thresh);
 
+	list_for_each_entry_safe(aead, an, &engine->registered_aeads, entry) {
+		list_del(&aead->entry);
+		crypto_unregister_aead(&aead->alg);
+	}
+
 	list_for_each_entry_safe(alg, next, &engine->registered_algs, entry) {
 		list_del(&alg->entry);
 		crypto_unregister_alg(&alg->alg);
