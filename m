From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 01/12] crypto: inside-secure - move hash result dma mapping to request
Date: Thu, 15 Mar 2018 16:38:40 +0100
Message-ID: <20180315153851.9958-2-antoine.tenart@bootlin.com>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, igall@marvell.com,
        Antoine Tenart <antoine.tenart@bootlin.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ofer Heifetz <oferh@marvell.com>

In heavy traffic the DMA mapping is overwritten by multiple requests as
the DMA address is stored in a global context. This patch moves this
information to the per-hash request context so that it can't be
overwritten.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: rebased the patch, small fixes, commit message.]
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  7 +------
 drivers/crypto/inside-secure/safexcel.h      |  4 +---
 drivers/crypto/inside-secure/safexcel_hash.c | 17 ++++++++++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 956a37692e42..0c33bdbe48fc 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -538,15 +538,10 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 }
 
 void safexcel_free_context(struct safexcel_crypto_priv *priv,
-			   struct crypto_async_request *req,
-			   int result_sz)
+			   struct crypto_async_request *req)
 {
 	struct safexcel_context *ctx = crypto_tfm_ctx(req->tfm);
 
-	if (ctx->result_dma)
-		dma_unmap_single(priv->dev, ctx->result_dma, result_sz,
-				 DMA_FROM_DEVICE);
-
 	if (ctx->cache) {
 		dma_unmap_single(priv->dev, ctx->cache_dma, ctx->cache_sz,
 				 DMA_TO_DEVICE);
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index caaf6a81b162..4e14c7e730c4 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -580,7 +580,6 @@ struct safexcel_context {
 	bool exit_inv;
 
 	/* Used for ahash requests */
-	dma_addr_t result_dma;
 	void *cache;
 	dma_addr_t cache_dma;
 	unsigned int cache_sz;
@@ -608,8 +607,7 @@ struct safexcel_inv_result {
 void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring);
 void safexcel_complete(struct safexcel_crypto_priv *priv, int ring);
 void safexcel_free_context(struct safexcel_crypto_priv *priv,
-				  struct crypto_async_request *req,
-				  int result_sz);
+				  struct crypto_async_request *req);
 int safexcel_invalidate_cache(struct crypto_async_request *async,
 			      struct safexcel_crypto_priv *priv,
 			      dma_addr_t ctxr_dma, int ring,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a4960a934eef..e33f089185d6 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -34,6 +34,7 @@ struct safexcel_ahash_req {
 	bool needs_inv;
 
 	int nents;
+	dma_addr_t result_dma;
 
 	u8 state_sz;    /* expected sate size, only set once */
 	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)] __aligned(sizeof(u32));
@@ -158,7 +159,13 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 		sreq->nents = 0;
 	}
 
-	safexcel_free_context(priv, async, sreq->state_sz);
+	if (sreq->result_dma) {
+		dma_unmap_single(priv->dev, sreq->result_dma, sreq->state_sz,
+				 DMA_FROM_DEVICE);
+		sreq->result_dma = 0;
+	}
+
+	safexcel_free_context(priv, async);
 
 	cache_len = sreq->len - sreq->processed;
 	if (cache_len)
@@ -291,15 +298,15 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	/* Add the token */
 	safexcel_hash_token(first_cdesc, len, req->state_sz);
 
-	ctx->base.result_dma = dma_map_single(priv->dev, req->state,
-					      req->state_sz, DMA_FROM_DEVICE);
-	if (dma_mapping_error(priv->dev, ctx->base.result_dma)) {
+	req->result_dma = dma_map_single(priv->dev, req->state, req->state_sz,
+					 DMA_FROM_DEVICE);
+	if (dma_mapping_error(priv->dev, req->result_dma)) {
 		ret = -EINVAL;
 		goto cdesc_rollback;
 	}
 
 	/* Add a result descriptor */
-	rdesc = safexcel_add_rdesc(priv, ring, 1, 1, ctx->base.result_dma,
+	rdesc = safexcel_add_rdesc(priv, ring, 1, 1, req->result_dma,
 				   req->state_sz);
 	if (IS_ERR(rdesc)) {
 		ret = PTR_ERR(rdesc);
-- 
2.14.3
