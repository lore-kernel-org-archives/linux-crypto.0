From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 1/2] crypto: inside-secure - avoid unmapping DMA memory that was not mapped
Date: Tue, 26 Dec 2017 17:21:16 +0100
Message-ID: <20171226162117.4885-2-antoine.tenart@free-electrons.com>
References: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53370 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdLZQfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 11:35:04 -0500
In-Reply-To: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a parameter in the SafeXcel ahash request structure to
keep track of the number of SG entries mapped. This allows not to call
dma_unmap_sg() when dma_map_sg() wasn't called in the first place. This
also removes a warning when the debugging of the DMA-API is enabled in
the kernel configuration: "DMA-API: device driver tries to free DMA
memory it has not allocated".

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d94614afc53d..fbc03d6e7db7 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -33,6 +33,8 @@ struct safexcel_ahash_req {
 	bool hmac;
 	bool needs_inv;
 
+	int nents;
+
 	u8 state_sz;    /* expected sate size, only set once */
 	u32 state[SHA256_DIGEST_SIZE / sizeof(u32)] __aligned(sizeof(u32));
 
@@ -151,8 +153,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 		memcpy(areq->result, sreq->state,
 		       crypto_ahash_digestsize(ahash));
 
-	dma_unmap_sg(priv->dev, areq->src,
-		     sg_nents_for_len(areq->src, areq->nbytes), DMA_TO_DEVICE);
+	if (sreq->nents) {
+		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
+		sreq->nents = 0;
+	}
 
 	safexcel_free_context(priv, async, sreq->state_sz);
 
@@ -177,7 +181,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	struct safexcel_command_desc *cdesc, *first_cdesc = NULL;
 	struct safexcel_result_desc *rdesc;
 	struct scatterlist *sg;
-	int i, nents, queued, len, cache_len, extra, n_cdesc = 0, ret = 0;
+	int i, queued, len, cache_len, extra, n_cdesc = 0, ret = 0;
 
 	queued = len = req->len - req->processed;
 	if (queued < crypto_ahash_blocksize(ahash))
@@ -233,15 +237,15 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	}
 
 	/* Now handle the current ahash request buffer(s) */
-	nents = dma_map_sg(priv->dev, areq->src,
-		       sg_nents_for_len(areq->src, areq->nbytes),
-		       DMA_TO_DEVICE);
-	if (!nents) {
+	req->nents = dma_map_sg(priv->dev, areq->src,
+				sg_nents_for_len(areq->src, areq->nbytes),
+				DMA_TO_DEVICE);
+	if (!req->nents) {
 		ret = -ENOMEM;
 		goto cdesc_rollback;
 	}
 
-	for_each_sg(areq->src, sg, nents, i) {
+	for_each_sg(areq->src, sg, req->nents, i) {
 		int sglen = sg_dma_len(sg);
 
 		/* Do not overflow the request */
-- 
2.14.3
