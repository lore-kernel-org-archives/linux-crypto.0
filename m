From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/4] crypto: sahara: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 13:55:28 +0200
Message-ID: <1443009328-12478-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sahara driver use two dma_map_sg path according to SG are chained
or not.
Since dma_map_sg can handle both case, clean the code with all
references to sg chained.

Thus removing the sahara_sha_unmap_sg function.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sahara.c | 66 ++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cea2411..804c0f5 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -173,7 +173,6 @@ struct sahara_aes_reqctx {
  * @sg_in_idx: number of hw links
  * @in_sg: scatterlist for input data
  * @in_sg_chain: scatterlists for chained input data
- * @in_sg_chained: specifies if chained scatterlists are used or not
  * @total: total number of bytes for transfer
  * @last: is this the last block
  * @first: is this the first block
@@ -191,7 +190,6 @@ struct sahara_sha_reqctx {
 	unsigned int		sg_in_idx;
 	struct scatterlist	*in_sg;
 	struct scatterlist	in_sg_chain[2];
-	bool			in_sg_chained;
 	size_t			total;
 	unsigned int		last;
 	unsigned int		first;
@@ -801,38 +799,19 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 		return -EINVAL;
 	}
 
-	if (rctx->in_sg_chained) {
-		i = start;
-		sg = dev->in_sg;
-		while (sg) {
-			ret = dma_map_sg(dev->device, sg, 1,
-					 DMA_TO_DEVICE);
-			if (!ret)
-				return -EFAULT;
-
-			dev->hw_link[i]->len = sg->length;
-			dev->hw_link[i]->p = sg->dma_address;
+	sg = dev->in_sg;
+	ret = dma_map_sg(dev->device, dev->in_sg, dev->nb_in_sg, DMA_TO_DEVICE);
+	if (!ret)
+		return -EFAULT;
+
+	for (i = start; i < dev->nb_in_sg + start; i++) {
+		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->p = sg->dma_address;
+		if (i == (dev->nb_in_sg + start - 1)) {
+			dev->hw_link[i]->next = 0;
+		} else {
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
-			i += 1;
-		}
-		dev->hw_link[i-1]->next = 0;
-	} else {
-		sg = dev->in_sg;
-		ret = dma_map_sg(dev->device, dev->in_sg, dev->nb_in_sg,
-				 DMA_TO_DEVICE);
-		if (!ret)
-			return -EFAULT;
-
-		for (i = start; i < dev->nb_in_sg + start; i++) {
-			dev->hw_link[i]->len = sg->length;
-			dev->hw_link[i]->p = sg->dma_address;
-			if (i == (dev->nb_in_sg + start - 1)) {
-				dev->hw_link[i]->next = 0;
-			} else {
-				dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
-				sg = sg_next(sg);
-			}
 		}
 	}
 
@@ -980,7 +959,6 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 		rctx->total = req->nbytes + rctx->buf_cnt;
 		rctx->in_sg = rctx->in_sg_chain;
 
-		rctx->in_sg_chained = true;
 		req->src = rctx->in_sg_chain;
 	/* only data from previous operation */
 	} else if (rctx->buf_cnt) {
@@ -991,13 +969,11 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 		/* buf was copied into rembuf above */
 		sg_init_one(rctx->in_sg, rctx->rembuf, rctx->buf_cnt);
 		rctx->total = rctx->buf_cnt;
-		rctx->in_sg_chained = false;
 	/* no data from previous operation */
 	} else {
 		rctx->in_sg = req->src;
 		rctx->total = req->nbytes;
 		req->src = rctx->in_sg;
-		rctx->in_sg_chained = false;
 	}
 
 	/* on next call, we only have the remaining data in the buffer */
@@ -1006,23 +982,6 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 	return -EINPROGRESS;
 }
 
-static void sahara_sha_unmap_sg(struct sahara_dev *dev,
-				struct sahara_sha_reqctx *rctx)
-{
-	struct scatterlist *sg;
-
-	if (rctx->in_sg_chained) {
-		sg = dev->in_sg;
-		while (sg) {
-			dma_unmap_sg(dev->device, sg, 1, DMA_TO_DEVICE);
-			sg = sg_next(sg);
-		}
-	} else {
-		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
-			DMA_TO_DEVICE);
-	}
-}
-
 static int sahara_sha_process(struct ahash_request *req)
 {
 	struct sahara_dev *dev = dev_ptr;
@@ -1062,7 +1021,8 @@ static int sahara_sha_process(struct ahash_request *req)
 	}
 
 	if (rctx->sg_in_idx)
-		sahara_sha_unmap_sg(dev, rctx);
+		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+			     DMA_TO_DEVICE);
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-- 
2.4.9
