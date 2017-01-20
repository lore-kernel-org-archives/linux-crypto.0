From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 5/8] crypto: mediatek - regroup functions by usage
Date: Fri, 20 Jan 2017 13:41:12 +0800
Message-ID: <1484890875-57105-6-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:7513 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751325AbdATFla (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 00:41:30 -0500
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch only regroup functions by usage.
This will help to integrate the GCM support patch later by
adjusting some shared code section, such as common code which
will be reused by GCM, AES mode setting, and DMA transfer.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 272 ++++++++++++++++++++------------------
 1 file changed, 141 insertions(+), 131 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9c4e468..b5946e9 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -42,7 +42,6 @@
 #define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)
 
 /* AES flags */
-#define AES_FLAGS_MODE_MSK	0x7
 #define AES_FLAGS_ECB		BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
 #define AES_FLAGS_ENCRYPT	BIT(2)
@@ -170,65 +169,28 @@ static bool mtk_aes_check_aligned(struct scatterlist *sg, size_t len,
 	return false;
 }
 
-/* Initialize and map transform information of AES */
-static int mtk_aes_info_map(struct mtk_cryp *cryp,
-			    struct mtk_aes_rec *aes,
-			    size_t len)
+static inline void mtk_aes_set_mode(struct mtk_aes_rec *aes,
+				    const struct mtk_aes_reqctx *rctx)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
-	struct mtk_aes_base_ctx *ctx = aes->ctx;
-
-	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
-	ctx->ct.cmd[0] = AES_CMD0 | cpu_to_le32(len);
-	ctx->ct.cmd[1] = AES_CMD1;
-
-	if (aes->flags & AES_FLAGS_ENCRYPT)
-		ctx->tfm.ctrl[0] = AES_TFM_BASIC_OUT;
-	else
-		ctx->tfm.ctrl[0] = AES_TFM_BASIC_IN;
-
-	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
-		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
-	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
-		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
-	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_192))
-		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
-
-	if (aes->flags & AES_FLAGS_CBC) {
-		const u32 *iv = (const u32 *)req->info;
-		u32 *iv_state = ctx->tfm.state + ctx->keylen;
-		int i;
-
-		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
-				  SIZE_IN_WORDS(AES_BLOCK_SIZE));
-		ctx->tfm.ctrl[1] = AES_TFM_CBC | AES_TFM_FULL_IV;
-
-		for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
-			iv_state[i] = cpu_to_le32(iv[i]);
+	/* Clear all but persistent flags and set request flags. */
+	aes->flags = (aes->flags & AES_FLAGS_BUSY) | rctx->mode;
+}
 
-		ctx->ct.cmd[2] = AES_CMD2;
-		ctx->ct_size  = AES_CT_SIZE_CBC;
-	} else if (aes->flags & AES_FLAGS_ECB) {
-		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen);
-		ctx->tfm.ctrl[1] = AES_TFM_ECB;
+static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
+{
+	struct scatterlist *sg = dma->sg;
+	int nents = dma->nents;
 
-		ctx->ct_size = AES_CT_SIZE_ECB;
-	}
+	if (!dma->remainder)
+		return;
 
-	ctx->ct_dma = dma_map_single(cryp->dev, &ctx->ct, sizeof(ctx->ct),
-				     DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
-		return -EINVAL;
+	while (--nents > 0 && sg)
+		sg = sg_next(sg);
 
-	ctx->tfm_dma = dma_map_single(cryp->dev, &ctx->tfm, sizeof(ctx->tfm),
-				      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, ctx->tfm_dma))) {
-		dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
-				 DMA_TO_DEVICE);
-		return -EINVAL;
-	}
+	if (!sg)
+		return;
 
-	return 0;
+	sg->length += dma->remainder;
 }
 
 /*
@@ -288,24 +250,134 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	return -EINPROGRESS;
 }
 
-static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
+static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
-	struct scatterlist *sg = dma->sg;
-	int nents = dma->nents;
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
 
-	if (!dma->remainder)
-		return;
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
+			 DMA_TO_DEVICE);
+	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
+			 DMA_TO_DEVICE);
 
-	while (--nents > 0 && sg)
-		sg = sg_next(sg);
+	if (aes->src.sg == aes->dst.sg) {
+		dma_unmap_sg(cryp->dev, aes->src.sg, aes->src.nents,
+			     DMA_BIDIRECTIONAL);
 
-	if (!sg)
-		return;
+		if (aes->src.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->src);
+	} else {
+		dma_unmap_sg(cryp->dev, aes->dst.sg, aes->dst.nents,
+			     DMA_FROM_DEVICE);
 
-	sg->length += dma->remainder;
+		if (aes->dst.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->dst);
+
+		dma_unmap_sg(cryp->dev, aes->src.sg, aes->src.nents,
+			     DMA_TO_DEVICE);
+
+		if (aes->src.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->src);
+	}
+
+	if (aes->dst.sg == &aes->aligned_sg)
+		sg_copy_from_buffer(aes->real_dst, sg_nents(aes->real_dst),
+				    aes->buf, aes->total);
 }
 
-static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
+static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
+
+	ctx->ct_dma = dma_map_single(cryp->dev, &ctx->ct, sizeof(ctx->ct),
+				     DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
+		return -EINVAL;
+
+	ctx->tfm_dma = dma_map_single(cryp->dev, &ctx->tfm, sizeof(ctx->tfm),
+				      DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->tfm_dma)))
+		goto tfm_map_err;
+
+	if (aes->src.sg == aes->dst.sg) {
+		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
+					     aes->src.nents,
+					     DMA_BIDIRECTIONAL);
+		aes->dst.sg_len = aes->src.sg_len;
+		if (unlikely(!aes->src.sg_len))
+			goto sg_map_err;
+	} else {
+		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
+					     aes->src.nents, DMA_TO_DEVICE);
+		if (unlikely(!aes->src.sg_len))
+			goto sg_map_err;
+
+		aes->dst.sg_len = dma_map_sg(cryp->dev, aes->dst.sg,
+					     aes->dst.nents, DMA_FROM_DEVICE);
+		if (unlikely(!aes->dst.sg_len)) {
+			dma_unmap_sg(cryp->dev, aes->src.sg,
+				     aes->src.nents, DMA_TO_DEVICE);
+			goto sg_map_err;
+		}
+	}
+
+	return mtk_aes_xmit(cryp, aes);
+
+sg_map_err:
+	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
+			 DMA_TO_DEVICE);
+tfm_map_err:
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
+			 DMA_TO_DEVICE);
+
+	return -EINVAL;
+}
+
+/* Initialize transform information of CBC/ECB mode */
+static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
+			      size_t len)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
+	struct mtk_aes_base_ctx *ctx = aes->ctx;
+
+	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
+	ctx->ct.cmd[0] = AES_CMD0 | cpu_to_le32(len);
+	ctx->ct.cmd[1] = AES_CMD1;
+
+	if (aes->flags & AES_FLAGS_ENCRYPT)
+		ctx->tfm.ctrl[0] = AES_TFM_BASIC_OUT;
+	else
+		ctx->tfm.ctrl[0] = AES_TFM_BASIC_IN;
+
+	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
+		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
+	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
+		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
+	else
+		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
+
+	if (aes->flags & AES_FLAGS_CBC) {
+		const u32 *iv = (const u32 *)req->info;
+		u32 *iv_state = ctx->tfm.state + ctx->keylen;
+		int i;
+
+		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
+				    SIZE_IN_WORDS(AES_BLOCK_SIZE));
+		ctx->tfm.ctrl[1] = AES_TFM_CBC | AES_TFM_FULL_IV;
+
+		for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
+			iv_state[i] = cpu_to_le32(iv[i]);
+
+		ctx->ct.cmd[2] = AES_CMD2;
+		ctx->ct_size = AES_CT_SIZE_CBC;
+	} else if (aes->flags & AES_FLAGS_ECB) {
+		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen);
+		ctx->tfm.ctrl[1] = AES_TFM_ECB;
+
+		ctx->ct_size = AES_CT_SIZE_ECB;
+	}
+}
+
+static int mtk_aes_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 		       struct scatterlist *src, struct scatterlist *dst,
 		       size_t len)
 {
@@ -346,28 +418,9 @@ static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 		sg_set_buf(&aes->aligned_sg, aes->buf, len + padlen);
 	}
 
-	if (aes->src.sg == aes->dst.sg) {
-		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
-				aes->src.nents, DMA_BIDIRECTIONAL);
-		aes->dst.sg_len = aes->src.sg_len;
-		if (unlikely(!aes->src.sg_len))
-			return -EFAULT;
-	} else {
-		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
-				aes->src.nents, DMA_TO_DEVICE);
-		if (unlikely(!aes->src.sg_len))
-			return -EFAULT;
-
-		aes->dst.sg_len = dma_map_sg(cryp->dev, aes->dst.sg,
-				aes->dst.nents, DMA_FROM_DEVICE);
-		if (unlikely(!aes->dst.sg_len)) {
-			dma_unmap_sg(cryp->dev, aes->src.sg,
-				     aes->src.nents, DMA_TO_DEVICE);
-			return -EFAULT;
-		}
-	}
+	mtk_aes_info_init(cryp, aes, len + padlen);
 
-	return mtk_aes_info_map(cryp, aes, len + padlen);
+	return mtk_aes_map(cryp, aes);
 }
 
 static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
@@ -419,54 +472,11 @@ static int mtk_aes_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
 	struct ablkcipher_request *req = ablkcipher_request_cast(aes->areq);
 	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
-	int err;
-
-	rctx = ablkcipher_request_ctx(req);
-	rctx->mode &= AES_FLAGS_MODE_MSK;
-	aes->flags = (aes->flags & ~AES_FLAGS_MODE_MSK) | rctx->mode;
 
+	mtk_aes_set_mode(aes, rctx);
 	aes->resume = mtk_aes_complete;
 
-	err = mtk_aes_map(cryp, aes, req->src, req->dst, req->nbytes);
-	if (err)
-		return err;
-
-	return mtk_aes_xmit(cryp, aes);
-}
-
-static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
-{
-	struct mtk_aes_base_ctx *ctx = aes->ctx;
-
-	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
-			 DMA_TO_DEVICE);
-	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
-			 DMA_TO_DEVICE);
-
-	if (aes->src.sg == aes->dst.sg) {
-		dma_unmap_sg(cryp->dev, aes->src.sg,
-			     aes->src.nents, DMA_BIDIRECTIONAL);
-
-		if (aes->src.sg != &aes->aligned_sg)
-			mtk_aes_restore_sg(&aes->src);
-	} else {
-		dma_unmap_sg(cryp->dev, aes->dst.sg,
-			     aes->dst.nents, DMA_FROM_DEVICE);
-
-		if (aes->dst.sg != &aes->aligned_sg)
-			mtk_aes_restore_sg(&aes->dst);
-
-		dma_unmap_sg(cryp->dev, aes->src.sg,
-			     aes->src.nents, DMA_TO_DEVICE);
-
-		if (aes->src.sg != &aes->aligned_sg)
-			mtk_aes_restore_sg(&aes->src);
-	}
-
-	if (aes->dst.sg == &aes->aligned_sg)
-		sg_copy_from_buffer(aes->real_dst,
-				    sg_nents(aes->real_dst),
-				    aes->buf, aes->total);
+	return mtk_aes_dma(cryp, aes, req->src, req->dst, req->nbytes);
 }
 
 /* Check and set the AES key to transform state buffer */
-- 
1.9.1
