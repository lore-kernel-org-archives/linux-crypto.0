From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v4 4/4] crypto: inside-secure - do not use areq->result for partial results
Date: Mon, 11 Dec 2017 12:10:58 +0100
Message-ID: <20171211111058.8878-5-antoine.tenart@free-electrons.com>
References: <20171211111058.8878-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58929 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdLKLPE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:15:04 -0500
In-Reply-To: <20171211111058.8878-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patches update the SafeXcel driver to stop using the crypto
ahash_request result field for partial results (i.e. on updates).
Instead the driver local safexcel_ahash_req state field is used, and
only on final operations the ahash_request result buffer is updated.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 55ff8a340b11..0c5a5820b06e 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -35,7 +35,7 @@ struct safexcel_ahash_req {
 	bool needs_inv;
 
 	u8 state_sz;    /* expected sate size, only set once */
-	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)];
+	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)] __aligned(sizeof(u32));
 
 	u64 len;
 	u64 processed;
@@ -128,7 +128,7 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	struct ahash_request *areq = ahash_request_cast(async);
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
 	struct safexcel_ahash_req *sreq = ahash_request_ctx(areq);
-	int cache_len, result_sz = sreq->state_sz;
+	int cache_len;
 
 	*ret = 0;
 
@@ -149,8 +149,8 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
 
 	if (sreq->finish)
-		result_sz = crypto_ahash_digestsize(ahash);
-	memcpy(sreq->state, areq->result, result_sz);
+		memcpy(areq->result, sreq->state,
+		       crypto_ahash_digestsize(ahash));
 
 	dma_unmap_sg(priv->dev, areq->src,
 		     sg_nents_for_len(areq->src, areq->nbytes), DMA_TO_DEVICE);
@@ -274,7 +274,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	/* Add the token */
 	safexcel_hash_token(first_cdesc, len, req->state_sz);
 
-	ctx->base.result_dma = dma_map_single(priv->dev, areq->result,
+	ctx->base.result_dma = dma_map_single(priv->dev, req->state,
 					      req->state_sz, DMA_FROM_DEVICE);
 	if (dma_mapping_error(priv->dev, ctx->base.result_dma)) {
 		ret = -EINVAL;
-- 
2.14.3
