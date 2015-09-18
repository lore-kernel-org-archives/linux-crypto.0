From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 7/8] crypto: qce: replace qce_countsg with sg_nents_len_chained
Date: Fri, 18 Sep 2015 14:57:15 +0200
Message-ID: <1442581036-23789-8-git-send-email-clabbe.montjoie@gmail.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, axboe@fb.com,
	clabbe.montjoie@gmail.com, cristian.stoica@freescale.com,
	dan.j.williams@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The qce driver use a modified version of sg_nents_for_len
called qce_countsg.
This function is now availlable in lib/scatterlist.c

Replace qce_countsg by sg_nents_len_chained

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/qce/ablkcipher.c |  8 ++++----
 drivers/crypto/qce/dma.c        | 19 -------------------
 drivers/crypto/qce/dma.h        |  1 -
 drivers/crypto/qce/sha.c        |  4 ++--
 4 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ad592de..215bbd2 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -80,11 +80,11 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
-				      &rctx->src_chained);
+	rctx->src_nents = sg_nents_len_chained(req->src, req->nbytes,
+					       &rctx->src_chained);
 	if (diff_dst) {
-		rctx->dst_nents = qce_countsg(req->dst, req->nbytes,
-					      &rctx->dst_chained);
+		rctx->dst_nents = sg_nents_len_chained(req->dst, req->nbytes,
+						       &rctx->dst_chained);
 	} else {
 		rctx->dst_nents = rctx->src_nents;
 		rctx->dst_chained = rctx->src_chained;
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 378cb76..c18aaca 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -87,25 +87,6 @@ void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
 		dma_unmap_sg(dev, sg, nents, dir);
 }
 
-int qce_countsg(struct scatterlist *sglist, int nbytes, bool *chained)
-{
-	struct scatterlist *sg = sglist;
-	int nents = 0;
-
-	if (chained)
-		*chained = false;
-
-	while (nbytes > 0 && sg) {
-		nents++;
-		nbytes -= sg->length;
-		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)
-			*chained = true;
-		sg = sg_next(sg);
-	}
-
-	return nents;
-}
-
 struct scatterlist *
 qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
 {
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 65bedb8..4653e2d8 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -49,7 +49,6 @@ int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 		     dma_async_tx_callback cb, void *cb_param);
 void qce_dma_issue_pending(struct qce_dma_data *dma);
 int qce_dma_terminate_all(struct qce_dma_data *dma);
-int qce_countsg(struct scatterlist *sg_list, int nbytes, bool *chained);
 void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
 		 enum dma_data_direction dir, bool chained);
 int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index be2f504..69c9495 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -92,8 +92,8 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
-				      &rctx->src_chained);
+	rctx->src_nents = sg_nents_len_chained(req->src, req->nbytes,
+					       &rctx->src_chained);
 	ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
 			rctx->src_chained);
 	if (ret < 0)
-- 
2.4.6
