From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/7] crypto: qce replace qce_countsg with sg_nents_for_len2
Date: Thu, 10 Sep 2015 15:21:41 +0200
Message-ID: <1441891302-12014-7-git-send-email-clabbe.montjoie@gmail.com>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/qce/ablkcipher.c |  4 ++--
 drivers/crypto/qce/dma.c        | 19 -------------------
 drivers/crypto/qce/dma.h        |  1 -
 drivers/crypto/qce/sha.c        |  2 +-
 4 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ad592de..0c589e7 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -80,10 +80,10 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
+	rctx->src_nents = sg_nents_for_len2(req->src, req->nbytes,
 				      &rctx->src_chained);
 	if (diff_dst) {
-		rctx->dst_nents = qce_countsg(req->dst, req->nbytes,
+		rctx->dst_nents = sg_nents_for_len2(req->dst, req->nbytes,
 					      &rctx->dst_chained);
 	} else {
 		rctx->dst_nents = rctx->src_nents;
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
index be2f504..86fae62 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -92,7 +92,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
+	rctx->src_nents = sg_nents_for_len2(req->src, req->nbytes,
 				      &rctx->src_chained);
 	ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
 			rctx->src_chained);
-- 
2.4.6
