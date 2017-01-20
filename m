From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 2/8] crypto: mediatek - fix incorrect data transfer result
Date: Fri, 20 Jan 2017 13:41:09 +0800
Message-ID: <1484890875-57105-3-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes mtk_aes_xmit() data transfer bug.

The original function uses the same loop and ring->pos
to handle both command and result descriptors. But this
produces incomplete results when src.sg_len != dst.sg_len.

To solve the problem, we splits the descriptors into different
loops and uses cmd_pos and res_pos to record them respectively.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/mediatek/mtk-aes.c      | 44 ++++++++++++++++++++--------------
 drivers/crypto/mediatek/mtk-platform.h |  6 +++--
 drivers/crypto/mediatek/mtk-sha.c      | 29 ++++++++++++----------
 3 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 126b93c..b658cb9 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -225,29 +225,25 @@ static int mtk_aes_info_map(struct mtk_cryp *cryp,
 	return 0;
 }
 
+/*
+ * Write descriptors for processing. This will configure the engine, load
+ * the transform information and then start the packet processing.
+ */
 static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
 	struct mtk_ring *ring = cryp->ring[aes->id];
 	struct mtk_desc *cmd = NULL, *res = NULL;
-	struct scatterlist *ssg, *dsg;
-	u32 len = aes->src.sg_len;
+	struct scatterlist *ssg = aes->src.sg, *dsg = aes->dst.sg;
+	u32 slen = aes->src.sg_len, dlen = aes->dst.sg_len;
 	int nents;
 
-	/* Fill in the command/result descriptors */
-	for (nents = 0; nents < len; ++nents) {
-		ssg = &aes->src.sg[nents];
-		dsg = &aes->dst.sg[nents];
-
-		cmd = ring->cmd_base + ring->pos;
+	/* Write command descriptors */
+	for (nents = 0; nents < slen; ++nents, ssg = sg_next(ssg)) {
+		cmd = ring->cmd_base + ring->cmd_pos;
 		cmd->hdr = MTK_DESC_BUF_LEN(ssg->length);
 		cmd->buf = cpu_to_le32(sg_dma_address(ssg));
 
-		res = ring->res_base + ring->pos;
-		res->hdr = MTK_DESC_BUF_LEN(dsg->length);
-		res->buf = cpu_to_le32(sg_dma_address(dsg));
-
 		if (nents == 0) {
-			res->hdr |= MTK_DESC_FIRST;
 			cmd->hdr |= MTK_DESC_FIRST |
 				    MTK_DESC_CT_LEN(aes->ctx->ct_size);
 			cmd->ct = cpu_to_le32(aes->ctx->ct_dma);
@@ -255,11 +251,23 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 			cmd->tfm = cpu_to_le32(aes->ctx->tfm_dma);
 		}
 
-		if (++ring->pos == MTK_DESC_NUM)
-			ring->pos = 0;
+		if (++ring->cmd_pos == MTK_DESC_NUM)
+			ring->cmd_pos = 0;
 	}
-
 	cmd->hdr |= MTK_DESC_LAST;
+
+	/* Prepare result descriptors */
+	for (nents = 0; nents < dlen; ++nents, dsg = sg_next(dsg)) {
+		res = ring->res_base + ring->res_pos;
+		res->hdr = MTK_DESC_BUF_LEN(dsg->length);
+		res->buf = cpu_to_le32(sg_dma_address(dsg));
+
+		if (nents == 0)
+			res->hdr |= MTK_DESC_FIRST;
+
+		if (++ring->res_pos == MTK_DESC_NUM)
+			ring->res_pos = 0;
+	}
 	res->hdr |= MTK_DESC_LAST;
 
 	/*
@@ -268,8 +276,8 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	 */
 	wmb();
 	/* Start DMA transfer */
-	mtk_aes_write(cryp, RDR_PREP_COUNT(aes->id), MTK_DESC_CNT(len));
-	mtk_aes_write(cryp, CDR_PREP_COUNT(aes->id), MTK_DESC_CNT(len));
+	mtk_aes_write(cryp, RDR_PREP_COUNT(aes->id), MTK_DESC_CNT(dlen));
+	mtk_aes_write(cryp, CDR_PREP_COUNT(aes->id), MTK_DESC_CNT(slen));
 
 	return -EINPROGRESS;
 }
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 1516786..8c50b74 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -83,9 +83,10 @@ struct mtk_desc {
  * struct mtk_ring - Descriptor ring
  * @cmd_base:	pointer to command descriptor ring base
  * @cmd_dma:	DMA address of command descriptor ring
+ * @cmd_pos:	current position in the command descriptor ring
  * @res_base:	pointer to result descriptor ring base
  * @res_dma:	DMA address of result descriptor ring
- * @pos:	current position in the ring
+ * @res_pos:	current position in the result descriptor ring
  *
  * A descriptor ring is a circular buffer that is used to manage
  * one or more descriptors. There are two type of descriptor rings;
@@ -94,9 +95,10 @@ struct mtk_desc {
 struct mtk_ring {
 	struct mtk_desc *cmd_base;
 	dma_addr_t cmd_dma;
+	u32 cmd_pos;
 	struct mtk_desc *res_base;
 	dma_addr_t res_dma;
-	u32 pos;
+	u32 res_pos;
 };
 
 /**
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 8cbff21..2536ebc 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -426,8 +426,8 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_ring *ring = cryp->ring[sha->id];
-	struct mtk_desc *cmd = ring->cmd_base + ring->pos;
-	struct mtk_desc *res = ring->res_base + ring->pos;
+	struct mtk_desc *cmd = ring->cmd_base + ring->cmd_pos;
+	struct mtk_desc *res = ring->res_base + ring->res_pos;
 	int err;
 
 	err = mtk_sha_info_map(cryp, sha, len);
@@ -451,9 +451,10 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 	cmd->ct_hdr = ctx->ct_hdr;
 	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
 
-	if (++ring->pos == MTK_DESC_NUM)
-		ring->pos = 0;
+	if (++ring->cmd_pos == MTK_DESC_NUM)
+		ring->cmd_pos = 0;
 
+	ring->res_pos = ring->cmd_pos;
 	/*
 	 * Make sure that all changes to the DMA ring are done before we
 	 * start engine.
@@ -472,8 +473,8 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 			 size_t len1, size_t len2)
 {
 	struct mtk_ring *ring = cryp->ring[sha->id];
-	struct mtk_desc *cmd = ring->cmd_base + ring->pos;
-	struct mtk_desc *res = ring->res_base + ring->pos;
+	struct mtk_desc *cmd = ring->cmd_base + ring->cmd_pos;
+	struct mtk_desc *res = ring->res_base + ring->res_pos;
 	int err;
 
 	err = mtk_sha_info_map(cryp, sha, len1 + len2);
@@ -492,11 +493,13 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 	cmd->ct_hdr = ctx->ct_hdr;
 	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
 
-	if (++ring->pos == MTK_DESC_NUM)
-		ring->pos = 0;
+	if (++ring->cmd_pos == MTK_DESC_NUM)
+		ring->cmd_pos = 0;
 
-	cmd = ring->cmd_base + ring->pos;
-	res = ring->res_base + ring->pos;
+	ring->res_pos = ring->cmd_pos;
+
+	cmd = ring->cmd_base + ring->cmd_pos;
+	res = ring->res_base + ring->res_pos;
 
 	res->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
 	res->buf = cpu_to_le32(cryp->tmp_dma);
@@ -504,8 +507,10 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 	cmd->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
 	cmd->buf = cpu_to_le32(ctx->dma_addr);
 
-	if (++ring->pos == MTK_DESC_NUM)
-		ring->pos = 0;
+	if (++ring->cmd_pos == MTK_DESC_NUM)
+		ring->cmd_pos = 0;
+
+	ring->res_pos = ring->cmd_pos;
 
 	/*
 	 * Make sure that all changes to the DMA ring are done before we
-- 
1.9.1
