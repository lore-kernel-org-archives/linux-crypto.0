From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/7] crypto: talitos: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:34 +0100
Message-ID: <1446668045-8620-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_nents_for_len() function could fail, this patch add a check for
its return value.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/talitos.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 46f531e..898ab6c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1216,6 +1216,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	int max_len = is_sec1 ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
+	void *err;
 
 	if (cryptlen + authsize > max_len) {
 		dev_err(dev, "length exceeds h/w max limit\n");
@@ -1228,14 +1229,29 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	if (!dst || dst == src) {
 		src_nents = sg_nents_for_len(src,
 					     assoclen + cryptlen + authsize);
+		if (src_nents < 0) {
+			dev_err(dev, "Invalid number of src SG.\n");
+			err = ERR_PTR(-EINVAL);
+			goto error_sg;
+		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
 	} else { /* dst && dst != src*/
 		src_nents = sg_nents_for_len(src, assoclen + cryptlen +
 						 (encrypt ? 0 : authsize));
+		if (src_nents < 0) {
+			dev_err(dev, "Invalid number of src SG.\n");
+			err = ERR_PTR(-EINVAL);
+			goto error_sg;
+		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = sg_nents_for_len(dst, assoclen + cryptlen +
 						 (encrypt ? authsize : 0));
+		if (dst_nents < 0) {
+			dev_err(dev, "Invalid number of dst SG.\n");
+			err = ERR_PTR(-EINVAL);
+			goto error_sg;
+		}
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
@@ -1260,11 +1276,9 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
-		if (iv_dma)
-			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
-
 		dev_err(dev, "could not allocate edescriptor\n");
-		return ERR_PTR(-ENOMEM);
+		err = ERR_PTR(-ENOMEM);
+		goto error_sg;
 	}
 
 	edesc->src_nents = src_nents;
@@ -1277,6 +1291,10 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						     DMA_BIDIRECTIONAL);
 
 	return edesc;
+error_sg:
+	if (iv_dma)
+		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+	return err;
 }
 
 static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
@@ -1830,11 +1848,16 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	unsigned int nsg;
+	int nents;
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		sg_copy_to_buffer(areq->src,
-				  sg_nents_for_len(areq->src, nbytes),
+		nents = sg_nents_for_len(areq->src, nbytes);
+		if (nents < 0) {
+			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			return nents;
+		}
+		sg_copy_to_buffer(areq->src, nents,
 				  req_ctx->buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -1867,7 +1890,11 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		int nents = sg_nents_for_len(areq->src, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
+		if (nents < 0) {
+			dev_err(ctx->dev, "Invalid number of src SG.\n");
+			return nents;
+		}
 		sg_pcopy_to_buffer(areq->src, nents,
 				      req_ctx->bufnext,
 				      to_hash_later,
-- 
2.4.10
