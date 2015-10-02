From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: qce: dma_map_sg can handle chained SG
Date: Fri,  2 Oct 2015 08:01:02 +0200
Message-ID: <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
References: <20151001140106.GC27726@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	cristian.stoica@freescale.com, axboe@fb.com,
	dan.j.williams@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38325 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbJBGBM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 02:01:12 -0400
In-Reply-To: <20151001140106.GC27726@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The qce driver use two dma_map_sg path according to SG are chained
or not.
Since dma_map_sg can handle both case, clean the code with all
references to sg chained.

Thus removing qce_mapsg, qce_unmapsg and qce_countsg functions.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/qce/ablkcipher.c | 30 ++++++++----------------
 drivers/crypto/qce/cipher.h     |  4 ----
 drivers/crypto/qce/dma.c        | 52 -----------------------------------------
 drivers/crypto/qce/dma.h        |  5 ----
 drivers/crypto/qce/sha.c        | 18 ++++++--------
 drivers/crypto/qce/sha.h        |  2 --
 6 files changed, 17 insertions(+), 94 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ad592de..2c0d63d 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -44,10 +44,8 @@ static void qce_ablkcipher_done(void *data)
 			error);
 
 	if (diff_dst)
-		qce_unmapsg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src,
-			    rctx->dst_chained);
-	qce_unmapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
-		    rctx->dst_chained);
+		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
+	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 
 	sg_free_table(&rctx->dst_tbl);
 
@@ -80,15 +78,11 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
-				      &rctx->src_chained);
-	if (diff_dst) {
-		rctx->dst_nents = qce_countsg(req->dst, req->nbytes,
-					      &rctx->dst_chained);
-	} else {
+	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (diff_dst)
+		rctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
+	else
 		rctx->dst_nents = rctx->src_nents;
-		rctx->dst_chained = rctx->src_chained;
-	}
 
 	rctx->dst_nents += 1;
 
@@ -116,14 +110,12 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	sg_mark_end(sg);
 	rctx->dst_sg = rctx->dst_tbl.sgl;
 
-	ret = qce_mapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
-			rctx->dst_chained);
+	ret = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 	if (ret < 0)
 		goto error_free;
 
 	if (diff_dst) {
-		ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, dir_src,
-				rctx->src_chained);
+		ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
 		if (ret < 0)
 			goto error_unmap_dst;
 		rctx->src_sg = req->src;
@@ -149,11 +141,9 @@ error_terminate:
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_src:
 	if (diff_dst)
-		qce_unmapsg(qce->dev, req->src, rctx->src_nents, dir_src,
-			    rctx->src_chained);
+		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
 error_unmap_dst:
-	qce_unmapsg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst,
-		    rctx->dst_chained);
+	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 error_free:
 	sg_free_table(&rctx->dst_tbl);
 	return ret;
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index d5757cf..5c6a5f8 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -32,8 +32,6 @@ struct qce_cipher_ctx {
  * @ivsize: IV size
  * @src_nents: source entries
  * @dst_nents: destination entries
- * @src_chained: is source chained
- * @dst_chained: is destination chained
  * @result_sg: scatterlist used for result buffer
  * @dst_tbl: destination sg table
  * @dst_sg: destination sg pointer table beginning
@@ -47,8 +45,6 @@ struct qce_cipher_reqctx {
 	unsigned int ivsize;
 	int src_nents;
 	int dst_nents;
-	bool src_chained;
-	bool dst_chained;
 	struct scatterlist result_sg;
 	struct sg_table dst_tbl;
 	struct scatterlist *dst_sg;
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 378cb76..4797e79 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -54,58 +54,6 @@ void qce_dma_release(struct qce_dma_data *dma)
 	kfree(dma->result_buf);
 }
 
-int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
-	      enum dma_data_direction dir, bool chained)
-{
-	int err;
-
-	if (chained) {
-		while (sg) {
-			err = dma_map_sg(dev, sg, 1, dir);
-			if (!err)
-				return -EFAULT;
-			sg = sg_next(sg);
-		}
-	} else {
-		err = dma_map_sg(dev, sg, nents, dir);
-		if (!err)
-			return -EFAULT;
-	}
-
-	return nents;
-}
-
-void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
-		 enum dma_data_direction dir, bool chained)
-{
-	if (chained)
-		while (sg) {
-			dma_unmap_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
-		}
-	else
-		dma_unmap_sg(dev, sg, nents, dir);
-}
-
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
index 65bedb8..130235d 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -49,11 +49,6 @@ int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 		     dma_async_tx_callback cb, void *cb_param);
 void qce_dma_issue_pending(struct qce_dma_data *dma);
 int qce_dma_terminate_all(struct qce_dma_data *dma);
-int qce_countsg(struct scatterlist *sg_list, int nbytes, bool *chained);
-void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
-		 enum dma_data_direction dir, bool chained);
-int qce_mapsg(struct device *dev, struct scatterlist *sg, int nents,
-	      enum dma_data_direction dir, bool chained);
 struct scatterlist *
 qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add);
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index be2f504..0c9973e 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -51,9 +51,8 @@ static void qce_ahash_done(void *data)
 	if (error)
 		dev_dbg(qce->dev, "ahash dma termination error (%d)\n", error);
 
-	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
-		    rctx->src_chained);
-	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+	dma_unmap_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
+	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 
 	memcpy(rctx->digest, result->auth_iv, digestsize);
 	if (req->result)
@@ -92,16 +91,14 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
-	rctx->src_nents = qce_countsg(req->src, req->nbytes,
-				      &rctx->src_chained);
-	ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
-			rctx->src_chained);
+	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
 	if (ret < 0)
 		return ret;
 
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
 
-	ret = qce_mapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+	ret = dma_map_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 	if (ret < 0)
 		goto error_unmap_src;
 
@@ -121,10 +118,9 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 error_terminate:
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_dst:
-	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
+	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 error_unmap_src:
-	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
-		    rctx->src_chained);
+	dma_unmap_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
 	return ret;
 }
 
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
index 286f0d5..236bb5e9 100644
--- a/drivers/crypto/qce/sha.h
+++ b/drivers/crypto/qce/sha.h
@@ -36,7 +36,6 @@ struct qce_sha_ctx {
  * @flags: operation flags
  * @src_orig: original request sg list
  * @nbytes_orig: original request number of bytes
- * @src_chained: is source scatterlist chained
  * @src_nents: source number of entries
  * @byte_count: byte count
  * @count: save count in states during update, import and export
@@ -55,7 +54,6 @@ struct qce_sha_reqctx {
 	unsigned long flags;
 	struct scatterlist *src_orig;
 	unsigned int nbytes_orig;
-	bool src_chained;
 	int src_nents;
 	__be32 byte_count[2];
 	u64 count;
-- 
2.4.9
