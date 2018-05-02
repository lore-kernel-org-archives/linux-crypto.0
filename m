From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 02/10] crypto: inside-secure - rework cipher functions for future AEAD support
Date: Wed,  2 May 2018 11:57:17 +0200
Message-ID: <20180502095725.31935-3-antoine.tenart@bootlin.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch reworks the Inside Secure cipher functions, to remove all
skcipher specific information and structure from all functions generic
enough to be shared between skcipher and aead algorithms.

This is a cosmetic only patch.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 236 ++++++++++--------
 1 file changed, 129 insertions(+), 107 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index bafb60505fab..a5e904a404d7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -38,18 +38,16 @@ struct safexcel_cipher_req {
 	bool needs_inv;
 };
 
-static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx,
-				  struct crypto_async_request *async,
-				  struct safexcel_command_desc *cdesc,
-				  u32 length)
+static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
+				    struct safexcel_command_desc *cdesc,
+				    u32 length)
 {
-	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_token *token;
 	unsigned offset = 0;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
 		offset = AES_BLOCK_SIZE / sizeof(u32);
-		memcpy(cdesc->control_data.token, req->iv, AES_BLOCK_SIZE);
+		memcpy(cdesc->control_data.token, iv, AES_BLOCK_SIZE);
 
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 	}
@@ -65,8 +63,8 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx,
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
 }
 
-static int safexcel_aes_setkey(struct crypto_skcipher *ctfm, const u8 *key,
-			       unsigned int len)
+static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
+					const u8 *key, unsigned int len)
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -100,11 +98,10 @@ static int safexcel_aes_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 
 static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				    struct crypto_async_request *async,
+				    struct safexcel_cipher_req *sreq,
 				    struct safexcel_command_desc *cdesc)
 {
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	struct skcipher_request *req = skcipher_request_cast(async);
-	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	int ctrl_size;
 
 	if (sreq->direction == SAFEXCEL_ENCRYPT)
@@ -140,9 +137,12 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 
 static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int ring,
 				      struct crypto_async_request *async,
+				      struct scatterlist *src,
+				      struct scatterlist *dst,
+				      unsigned int cryptlen,
+				      struct safexcel_cipher_req *sreq,
 				      bool *should_complete, int *ret)
 {
-	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_result_desc *rdesc;
 	int ndesc = 0;
 
@@ -171,16 +171,16 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
-	if (req->src == req->dst) {
-		dma_unmap_sg(priv->dev, req->src,
-			     sg_nents_for_len(req->src, req->cryptlen),
+	if (src == dst) {
+		dma_unmap_sg(priv->dev, src,
+			     sg_nents_for_len(src, cryptlen),
 			     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, req->src,
-			     sg_nents_for_len(req->src, req->cryptlen),
+		dma_unmap_sg(priv->dev, src,
+			     sg_nents_for_len(src, cryptlen),
 			     DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, req->dst,
-			     sg_nents_for_len(req->dst, req->cryptlen),
+		dma_unmap_sg(priv->dev, dst,
+			     sg_nents_for_len(dst, cryptlen),
 			     DMA_FROM_DEVICE);
 	}
 
@@ -189,39 +189,41 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	return ndesc;
 }
 
-static int safexcel_aes_send(struct crypto_async_request *async,
-			     int ring, struct safexcel_request *request,
-			     int *commands, int *results)
+static int safexcel_aes_send(struct crypto_async_request *base, int ring,
+			     struct safexcel_request *request,
+			     struct safexcel_cipher_req *sreq,
+			     struct scatterlist *src, struct scatterlist *dst,
+			     unsigned int cryptlen, u8 *iv, int *commands,
+			     int *results)
 {
-	struct skcipher_request *req = skcipher_request_cast(async);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct safexcel_command_desc *cdesc;
 	struct safexcel_result_desc *rdesc;
 	struct scatterlist *sg;
-	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = req->cryptlen;
+	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = cryptlen;
 	int i, ret = 0;
 
-	if (req->src == req->dst) {
-		nr_src = dma_map_sg(priv->dev, req->src,
-				    sg_nents_for_len(req->src, req->cryptlen),
+	if (src == dst) {
+		nr_src = dma_map_sg(priv->dev, src,
+				    sg_nents_for_len(src, cryptlen),
 				    DMA_BIDIRECTIONAL);
 		nr_dst = nr_src;
 		if (!nr_src)
 			return -EINVAL;
 	} else {
-		nr_src = dma_map_sg(priv->dev, req->src,
-				    sg_nents_for_len(req->src, req->cryptlen),
+		nr_src = dma_map_sg(priv->dev, src,
+				    sg_nents_for_len(src, cryptlen),
 				    DMA_TO_DEVICE);
 		if (!nr_src)
 			return -EINVAL;
 
-		nr_dst = dma_map_sg(priv->dev, req->dst,
-				    sg_nents_for_len(req->dst, req->cryptlen),
+		nr_dst = dma_map_sg(priv->dev, dst,
+				    sg_nents_for_len(dst, cryptlen),
 				    DMA_FROM_DEVICE);
 		if (!nr_dst) {
-			dma_unmap_sg(priv->dev, req->src,
-				     sg_nents_for_len(req->src, req->cryptlen),
+			dma_unmap_sg(priv->dev, src,
+				     sg_nents_for_len(src, cryptlen),
 				     DMA_TO_DEVICE);
 			return -EINVAL;
 		}
@@ -232,7 +234,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 	spin_lock_bh(&priv->ring[ring].egress_lock);
 
 	/* command descriptors */
-	for_each_sg(req->src, sg, nr_src, i) {
+	for_each_sg(src, sg, nr_src, i) {
 		int len = sg_dma_len(sg);
 
 		/* Do not overflow the request */
@@ -240,7 +242,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 			len = queued;
 
 		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc, !(queued - len),
-					   sg_dma_address(sg), len, req->cryptlen,
+					   sg_dma_address(sg), len, cryptlen,
 					   ctx->base.ctxr_dma);
 		if (IS_ERR(cdesc)) {
 			/* No space left in the command descriptor ring */
@@ -250,8 +252,8 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 		n_cdesc++;
 
 		if (n_cdesc == 1) {
-			safexcel_context_control(ctx, async, cdesc);
-			safexcel_cipher_token(ctx, async, cdesc, req->cryptlen);
+			safexcel_context_control(ctx, base, sreq, cdesc);
+			safexcel_skcipher_token(ctx, iv, cdesc, cryptlen);
 		}
 
 		queued -= len;
@@ -260,7 +262,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 	}
 
 	/* result descriptors */
-	for_each_sg(req->dst, sg, nr_dst, i) {
+	for_each_sg(dst, sg, nr_dst, i) {
 		bool first = !i, last = (i == nr_dst - 1);
 		u32 len = sg_dma_len(sg);
 
@@ -276,7 +278,7 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
-	request->req = &req->base;
+	request->req = base;
 
 	*commands = n_cdesc;
 	*results = n_rdesc;
@@ -291,16 +293,16 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
-	if (req->src == req->dst) {
-		dma_unmap_sg(priv->dev, req->src,
-			     sg_nents_for_len(req->src, req->cryptlen),
+	if (src == dst) {
+		dma_unmap_sg(priv->dev, src,
+			     sg_nents_for_len(src, cryptlen),
 			     DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, req->src,
-			     sg_nents_for_len(req->src, req->cryptlen),
+		dma_unmap_sg(priv->dev, src,
+			     sg_nents_for_len(src, cryptlen),
 			     DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, req->dst,
-			     sg_nents_for_len(req->dst, req->cryptlen),
+		dma_unmap_sg(priv->dev, dst,
+			     sg_nents_for_len(dst, cryptlen),
 			     DMA_FROM_DEVICE);
 	}
 
@@ -309,11 +311,10 @@ static int safexcel_aes_send(struct crypto_async_request *async,
 
 static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 				      int ring,
-				      struct crypto_async_request *async,
+				      struct crypto_async_request *base,
 				      bool *should_complete, int *ret)
 {
-	struct skcipher_request *req = skcipher_request_cast(async);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_result_desc *rdesc;
 	int ndesc = 0, enq_ret;
 
@@ -354,7 +355,7 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	ctx->base.ring = ring;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
-	enq_ret = crypto_enqueue_request(&priv->ring[ring].queue, async);
+	enq_ret = crypto_enqueue_request(&priv->ring[ring].queue, base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 	if (enq_ret != -EINPROGRESS)
@@ -368,9 +369,10 @@ static int safexcel_handle_inv_result(struct safexcel_crypto_priv *priv,
 	return ndesc;
 }
 
-static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
-				  struct crypto_async_request *async,
-				  bool *should_complete, int *ret)
+static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
+					   int ring,
+					   struct crypto_async_request *async,
+					   bool *should_complete, int *ret)
 {
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
@@ -381,24 +383,24 @@ static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int ring,
 		err = safexcel_handle_inv_result(priv, ring, async,
 						 should_complete, ret);
 	} else {
-		err = safexcel_handle_req_result(priv, ring, async,
+		err = safexcel_handle_req_result(priv, ring, async, req->src,
+						 req->dst, req->cryptlen, sreq,
 						 should_complete, ret);
 	}
 
 	return err;
 }
 
-static int safexcel_cipher_send_inv(struct crypto_async_request *async,
+static int safexcel_cipher_send_inv(struct crypto_async_request *base,
 				    int ring, struct safexcel_request *request,
 				    int *commands, int *results)
 {
-	struct skcipher_request *req = skcipher_request_cast(async);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret;
 
-	ret = safexcel_invalidate_cache(async, priv,
-					ctx->base.ctxr_dma, ring, request);
+	ret = safexcel_invalidate_cache(base, priv, ctx->base.ctxr_dma, ring,
+					request);
 	if (unlikely(ret))
 		return ret;
 
@@ -408,9 +410,9 @@ static int safexcel_cipher_send_inv(struct crypto_async_request *async,
 	return 0;
 }
 
-static int safexcel_send(struct crypto_async_request *async,
-			 int ring, struct safexcel_request *request,
-			 int *commands, int *results)
+static int safexcel_skcipher_send(struct crypto_async_request *async, int ring,
+				  struct safexcel_request *request,
+				  int *commands, int *results)
 {
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
@@ -421,59 +423,69 @@ static int safexcel_send(struct crypto_async_request *async,
 	BUG_ON(priv->version == EIP97 && sreq->needs_inv);
 
 	if (sreq->needs_inv)
-		ret = safexcel_cipher_send_inv(async, ring, request,
-					       commands, results);
+		ret = safexcel_cipher_send_inv(async, ring, request, commands,
+					       results);
 	else
-		ret = safexcel_aes_send(async, ring, request,
+		ret = safexcel_aes_send(async, ring, request, sreq, req->src,
+					req->dst, req->cryptlen, req->iv,
 					commands, results);
 	return ret;
 }
 
-static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
+static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
+				    struct crypto_async_request *base,
+				    struct safexcel_cipher_req *sreq,
+				    struct safexcel_inv_result *result)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	SKCIPHER_REQUEST_ON_STACK(req, __crypto_skcipher_cast(tfm));
-	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
-	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
-	memset(req, 0, sizeof(struct skcipher_request));
+	init_completion(&result->completion);
 
-	/* create invalidation request */
-	init_completion(&result.completion);
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      safexcel_inv_complete, &result);
-
-	skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
-	ctx = crypto_tfm_ctx(req->base.tfm);
+	ctx = crypto_tfm_ctx(base->tfm);
 	ctx->base.exit_inv = true;
 	sreq->needs_inv = true;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
-	crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
+	crypto_enqueue_request(&priv->ring[ring].queue, base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 	queue_work(priv->ring[ring].workqueue,
 		   &priv->ring[ring].work_data.work);
 
-	wait_for_completion(&result.completion);
+	wait_for_completion(&result->completion);
 
-	if (result.error) {
+	if (result->error) {
 		dev_warn(priv->dev,
 			"cipher: sync: invalidate: completion error %d\n",
-			 result.error);
-		return result.error;
+			 result->error);
+		return result->error;
 	}
 
 	return 0;
 }
 
-static int safexcel_aes(struct skcipher_request *req,
-			enum safexcel_cipher_direction dir, u32 mode)
+static int safexcel_skcipher_exit_inv(struct crypto_tfm *tfm)
 {
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, __crypto_skcipher_cast(tfm));
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
+	struct safexcel_inv_result result = {};
+
+	memset(req, 0, sizeof(struct skcipher_request));
+
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      safexcel_inv_complete, &result);
+	skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
+
+	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
+}
+
+static int safexcel_aes(struct crypto_async_request *base,
+			struct safexcel_cipher_req *sreq,
+			enum safexcel_cipher_direction dir, u32 mode)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret, ring;
 
@@ -489,7 +501,7 @@ static int safexcel_aes(struct skcipher_request *req,
 	} else {
 		ctx->base.ring = safexcel_select_ring(priv);
 		ctx->base.ctxr = dma_pool_zalloc(priv->context_pool,
-						 EIP197_GFP_FLAGS(req->base),
+						 EIP197_GFP_FLAGS(*base),
 						 &ctx->base.ctxr_dma);
 		if (!ctx->base.ctxr)
 			return -ENOMEM;
@@ -498,7 +510,7 @@ static int safexcel_aes(struct skcipher_request *req,
 	ring = ctx->base.ring;
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
-	ret = crypto_enqueue_request(&priv->ring[ring].queue, &req->base);
+	ret = crypto_enqueue_request(&priv->ring[ring].queue, base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
 
 	queue_work(priv->ring[ring].workqueue,
@@ -509,14 +521,14 @@ static int safexcel_aes(struct skcipher_request *req,
 
 static int safexcel_ecb_aes_encrypt(struct skcipher_request *req)
 {
-	return safexcel_aes(req, SAFEXCEL_ENCRYPT,
-			    CONTEXT_CONTROL_CRYPTO_MODE_ECB);
+	return safexcel_aes(&req->base, skcipher_request_ctx(req),
+			    SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB);
 }
 
 static int safexcel_ecb_aes_decrypt(struct skcipher_request *req)
 {
-	return safexcel_aes(req, SAFEXCEL_DECRYPT,
-			    CONTEXT_CONTROL_CRYPTO_MODE_ECB);
+	return safexcel_aes(&req->base, skcipher_request_ctx(req),
+			    SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_ECB);
 }
 
 static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
@@ -526,34 +538,44 @@ static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
 		container_of(tfm->__crt_alg, struct safexcel_alg_template,
 			     alg.skcipher.base);
 
-	ctx->priv = tmpl->priv;
-	ctx->base.send = safexcel_send;
-	ctx->base.handle_result = safexcel_handle_result;
-
 	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct safexcel_cipher_req));
 
+	ctx->priv = tmpl->priv;
+
+	ctx->base.send = safexcel_skcipher_send;
+	ctx->base.handle_result = safexcel_skcipher_handle_result;
 	return 0;
 }
 
-static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
+static int safexcel_cipher_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
-	int ret;
 
 	memzero_explicit(ctx->key, 8 * sizeof(u32));
 
 	/* context not allocated, skip invalidation */
 	if (!ctx->base.ctxr)
-		return;
+		return -ENOMEM;
 
 	memzero_explicit(ctx->base.ctxr->data, 8 * sizeof(u32));
+	return 0;
+}
+
+static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	int ret;
+
+	if (safexcel_cipher_cra_exit(tfm))
+		return;
 
 	if (priv->version == EIP197) {
-		ret = safexcel_cipher_exit_inv(tfm);
+		ret = safexcel_skcipher_exit_inv(tfm);
 		if (ret)
-			dev_warn(priv->dev, "cipher: invalidation error %d\n", ret);
+			dev_warn(priv->dev, "skcipher: invalidation error %d\n",
+				 ret);
 	} else {
 		dma_pool_free(priv->context_pool, ctx->base.ctxr,
 			      ctx->base.ctxr_dma);
@@ -563,7 +585,7 @@ static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_ecb_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
-		.setkey = safexcel_aes_setkey,
+		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_ecb_aes_encrypt,
 		.decrypt = safexcel_ecb_aes_decrypt,
 		.min_keysize = AES_MIN_KEY_SIZE,
@@ -586,20 +608,20 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
 
 static int safexcel_cbc_aes_encrypt(struct skcipher_request *req)
 {
-	return safexcel_aes(req, SAFEXCEL_ENCRYPT,
-			    CONTEXT_CONTROL_CRYPTO_MODE_CBC);
+	return safexcel_aes(&req->base, skcipher_request_ctx(req),
+			    SAFEXCEL_ENCRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC);
 }
 
 static int safexcel_cbc_aes_decrypt(struct skcipher_request *req)
 {
-	return safexcel_aes(req, SAFEXCEL_DECRYPT,
-			    CONTEXT_CONTROL_CRYPTO_MODE_CBC);
+	return safexcel_aes(&req->base, skcipher_request_ctx(req),
+			    SAFEXCEL_DECRYPT, CONTEXT_CONTROL_CRYPTO_MODE_CBC);
 }
 
 struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
 	.alg.skcipher = {
-		.setkey = safexcel_aes_setkey,
+		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_cbc_aes_encrypt,
 		.decrypt = safexcel_cbc_aes_decrypt,
 		.min_keysize = AES_MIN_KEY_SIZE,
-- 
2.17.0
