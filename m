From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 6/8] crypto: mediatek - fix error handling in
 mtk_aes_complete()
Date: Thu, 9 Mar 2017 10:11:17 +0800
Message-ID: <1489025479-48036-7-git-send-email-ryder.lee@mediatek.com>
References: <1489025479-48036-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1489025479-48036-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes how errors should be handled by mtk_aes_complete().

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 140e9a3..6a0180d 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -248,6 +248,17 @@ static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
 	sg->length += dma->remainder;
 }
 
+static inline int mtk_aes_complete(struct mtk_cryp *cryp,
+				   struct mtk_aes_rec *aes,
+				   int err)
+{
+	aes->flags &= ~AES_FLAGS_BUSY;
+	aes->areq->complete(aes->areq, err);
+	/* Handle new request */
+	tasklet_schedule(&aes->queue_task);
+	return err;
+}
+
 /*
  * Write descriptors for processing. This will configure the engine, load
  * the transform information and then start the packet processing.
@@ -352,7 +363,7 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	ctx->ct_dma = dma_map_single(cryp->dev, &ctx->ct, sizeof(ctx->ct),
 				     DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
-		return -EINVAL;
+		goto exit;
 
 	ctx->tfm_dma = dma_map_single(cryp->dev, &ctx->tfm, sizeof(ctx->tfm),
 				      DMA_TO_DEVICE);
@@ -389,8 +400,8 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 tfm_map_err:
 	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
 			 DMA_TO_DEVICE);
-
-	return -EINVAL;
+exit:
+	return mtk_aes_complete(cryp, aes, -EINVAL);
 }
 
 /* Initialize transform information of CBC/ECB/CTR mode */
@@ -467,7 +478,7 @@ static int mtk_aes_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 		padlen = mtk_aes_padlen(len);
 
 		if (len + padlen > AES_BUF_SIZE)
-			return -ENOMEM;
+			return mtk_aes_complete(cryp, aes, -ENOMEM);
 
 		if (!src_aligned) {
 			sg_copy_to_buffer(src, sg_nents(src), aes->buf, len);
@@ -527,14 +538,10 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 	return ctx->start(cryp, aes);
 }
 
-static int mtk_aes_complete(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+static int mtk_aes_transfer_complete(struct mtk_cryp *cryp,
+				     struct mtk_aes_rec *aes)
 {
-	aes->flags &= ~AES_FLAGS_BUSY;
-	aes->areq->complete(aes->areq, 0);
-
-	/* Handle new request */
-	tasklet_schedule(&aes->queue_task);
-	return 0;
+	return mtk_aes_complete(cryp, aes, 0);
 }
 
 static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
@@ -543,7 +550,7 @@ static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 
 	mtk_aes_set_mode(aes, rctx);
-	aes->resume = mtk_aes_complete;
+	aes->resume = mtk_aes_transfer_complete;
 
 	return mtk_aes_dma(cryp, aes, req->src, req->dst, req->nbytes);
 }
@@ -568,7 +575,7 @@ static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	/* Check for transfer completion. */
 	cctx->offset += aes->total;
 	if (cctx->offset >= req->nbytes)
-		return mtk_aes_complete(cryp, aes);
+		return mtk_aes_transfer_complete(cryp, aes);
 
 	/* Compute data length. */
 	datalen = req->nbytes - cctx->offset;
@@ -602,7 +609,6 @@ static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		cctx->iv[3] = cpu_to_be32(ctr);
 		crypto_inc((u8 *)cctx->iv, AES_BLOCK_SIZE);
 	}
-	aes->resume = mtk_aes_ctr_transfer;
 
 	return mtk_aes_dma(cryp, aes, src, dst, datalen);
 }
@@ -618,6 +624,7 @@ static int mtk_aes_ctr_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	memcpy(cctx->iv, req->info, AES_BLOCK_SIZE);
 	cctx->offset = 0;
 	aes->total = 0;
+	aes->resume = mtk_aes_ctr_transfer;
 
 	return mtk_aes_ctr_transfer(cryp, aes);
 }
@@ -859,7 +866,7 @@ static int mtk_aes_gcm_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 
 	if (!src_aligned || !dst_aligned) {
 		if (aes->total > AES_BUF_SIZE)
-			return -ENOMEM;
+			return mtk_aes_complete(cryp, aes, -ENOMEM);
 
 		if (!src_aligned) {
 			sg_copy_to_buffer(src, sg_nents(src), aes->buf, len);
@@ -905,7 +912,7 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		aes->total = len;
 		gctx->textlen = req->cryptlen - gctx->authsize;
 	}
-	aes->resume = mtk_aes_complete;
+	aes->resume = mtk_aes_transfer_complete;
 
 	return mtk_aes_gcm_dma(cryp, aes, req->src, req->dst, len);
 }
-- 
1.9.1
