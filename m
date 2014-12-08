From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Fix assumption that sg in and out will have the
 same nents
Date: Mon, 08 Dec 2014 12:05:42 -0800
Message-ID: <20141208200542.15341.78542.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50434 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLHUJM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 15:09:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed invalid assumpion that the sgl in and sgl out will always have the same
number of entries.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c   |   82 +++++++++++++++++-----------
 drivers/crypto/qat/qat_common/qat_crypto.h |    1 
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 19eea1c..e4e32d8 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -557,7 +557,8 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp = qat_req->buf.blp;
 	dma_addr_t blpout = qat_req->buf.bloutp;
 	size_t sz = qat_req->buf.sz;
-	int i, bufs = bl->num_bufs;
+	size_t sz_out = qat_req->buf.sz_out;
+	int i;
 
 	for (i = 0; i < bl->num_bufs; i++)
 		dma_unmap_single(dev, bl->bufers[i].addr,
@@ -567,14 +568,14 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	kfree(bl);
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
-		int bufless = bufs - blout->num_mapped_bufs;
+		int bufless = blout->num_bufs - blout->num_mapped_bufs;
 
-		for (i = bufless; i < bufs; i++) {
+		for (i = bufless; i < blout->num_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 		}
-		dma_unmap_single(dev, blpout, sz, DMA_TO_DEVICE);
+		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
 		kfree(blout);
 	}
 }
@@ -587,19 +588,20 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			       struct qat_crypto_request *qat_req)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
-	int i, bufs = 0, n = sg_nents(sgl), assoc_n = sg_nents(assoc);
+	int i, bufs = 0, sg_nctr = 0;
+	int n = sg_nents(sgl), assoc_n = sg_nents(assoc);
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
 	dma_addr_t blp;
 	dma_addr_t bloutp = 0;
 	struct scatterlist *sg;
-	size_t sz = sizeof(struct qat_alg_buf_list) +
+	size_t sz_out, sz = sizeof(struct qat_alg_buf_list) +
 			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kmalloc_node(sz, GFP_ATOMIC,
+	bufl = kzalloc_node(sz, GFP_ATOMIC,
 			    dev_to_node(&GET_DEV(inst->accel_dev)));
 	if (unlikely(!bufl))
 		return -ENOMEM;
@@ -620,15 +622,20 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			goto err;
 		bufs++;
 	}
-	bufl->bufers[bufs].addr = dma_map_single(dev, iv, ivlen,
-						 DMA_BIDIRECTIONAL);
-	bufl->bufers[bufs].len = ivlen;
-	if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
-		goto err;
-	bufs++;
+	if (ivlen) {
+		bufl->bufers[bufs].addr = dma_map_single(dev, iv, ivlen,
+							 DMA_BIDIRECTIONAL);
+		bufl->bufers[bufs].len = ivlen;
+		if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
+			goto err;
+		bufs++;
+	}
 
 	for_each_sg(sgl, sg, n, i) {
-		int y = i + bufs;
+		int y = sg_nctr + bufs;
+
+		if (!sg->length)
+			continue;
 
 		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 						      sg->length,
@@ -636,8 +643,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		bufl->bufers[y].len = sg->length;
 		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
 			goto err;
+		sg_nctr++;
 	}
-	bufl->num_bufs = n + bufs;
+	bufl->num_bufs = sg_nctr + bufs;
 	qat_req->buf.bl = bufl;
 	qat_req->buf.blp = blp;
 	qat_req->buf.sz = sz;
@@ -645,11 +653,15 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (sgl != sglout) {
 		struct qat_alg_buf *bufers;
 
-		buflout = kmalloc_node(sz, GFP_ATOMIC,
+		n = sg_nents(sglout);
+		sz_out = sizeof(struct qat_alg_buf_list) +
+			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
+		sg_nctr = 0;
+		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
 			goto err;
-		bloutp = dma_map_single(dev, buflout, sz, DMA_TO_DEVICE);
+		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
 			goto err;
 		bufers = buflout->bufers;
@@ -660,47 +672,51 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			bufers[i].addr = bufl->bufers[i].addr;
 		}
 		for_each_sg(sglout, sg, n, i) {
-			int y = i + bufs;
+			int y = sg_nctr + bufs;
+
+			if (!sg->length)
+				continue;
 
 			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 							sg->length,
 							DMA_BIDIRECTIONAL);
-			buflout->bufers[y].len = sg->length;
 			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
 				goto err;
+			bufers[y].len = sg->length;
+			sg_nctr++;
 		}
-		buflout->num_bufs = n + bufs;
-		buflout->num_mapped_bufs = n;
+		buflout->num_bufs = sg_nctr + bufs;
+		buflout->num_mapped_bufs = sg_nctr;
 		qat_req->buf.blout = buflout;
 		qat_req->buf.bloutp = bloutp;
+		qat_req->buf.sz_out = sz_out;
 	} else {
 		/* Otherwise set the src and dst to the same address */
 		qat_req->buf.bloutp = qat_req->buf.blp;
+		qat_req->buf.sz_out = 0;
 	}
 	return 0;
 err:
 	dev_err(dev, "Failed to map buf for dma\n");
-	for_each_sg(sgl, sg, n + bufs, i) {
-		if (!dma_mapping_error(dev, bufl->bufers[i].addr)) {
+	sg_nctr = 0;
+	for (i = 0; i < n + bufs; i++)
+		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
 			dma_unmap_single(dev, bufl->bufers[i].addr,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-		}
-	}
+
 	if (!dma_mapping_error(dev, blp))
 		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
 	kfree(bufl);
 	if (sgl != sglout && buflout) {
-		for_each_sg(sglout, sg, n, i) {
-			int y = i + bufs;
-
-			if (!dma_mapping_error(dev, buflout->bufers[y].addr))
-				dma_unmap_single(dev, buflout->bufers[y].addr,
-						 buflout->bufers[y].len,
+		n = sg_nents(sglout);
+		for (i = bufs; i < n + bufs; i++)
+			if (!dma_mapping_error(dev, buflout->bufers[i].addr))
+				dma_unmap_single(dev, buflout->bufers[i].addr,
+						 buflout->bufers[i].len,
 						 DMA_BIDIRECTIONAL);
-		}
 		if (!dma_mapping_error(dev, bloutp))
-			dma_unmap_single(dev, bloutp, sz, DMA_TO_DEVICE);
+			dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
 		kfree(buflout);
 	}
 	return -ENOMEM;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index ab8468d..fcb3231 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -72,6 +72,7 @@ struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *blout;
 	dma_addr_t bloutp;
 	size_t sz;
+	size_t sz_out;
 };
 
 struct qat_crypto_request {
