From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 3/8] crypto: mediatek - make mtk_sha_xmit() more generic
Date: Thu, 9 Mar 2017 10:11:14 +0800
Message-ID: <1489025479-48036-4-git-send-email-ryder.lee@mediatek.com>
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

This is a transitional patch. It merges mtk_sha_xmit() and mtk_sha_xmit2()
to make transmit function more generic.
In addition, res->buf and cryp->tmp_dma in mtk_sha_xmit() are useless, since
crypto engine writes the result digests into ctx->tfm.digest instead of
res->buf. It's better to remove it.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-platform.h |   4 --
 drivers/crypto/mediatek/mtk-sha.c      | 116 ++++++++++-----------------------
 2 files changed, 34 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 3bbe9b0..78ce54e 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -202,8 +202,6 @@ struct mtk_sha_rec {
  * @sha:	pointer to operation record of SHA
  * @aes_list:	device list of AES
  * @sha_list:	device list of SHA
- * @tmp:	pointer to temporary buffer for internal use
- * @tmp_dma:	DMA address of temporary buffer
  * @rec:	it's used to select SHA record for tfm
  *
  * Structure storing cryptographic device information.
@@ -222,8 +220,6 @@ struct mtk_cryp {
 	struct list_head aes_list;
 	struct list_head sha_list;
 
-	void *tmp;
-	dma_addr_t tmp_dma;
 	bool rec;
 };
 
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index b4f0c62..ef6fb20 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -17,7 +17,6 @@
 
 #define SHA_ALIGN_MSK		(sizeof(u32) - 1)
 #define SHA_QUEUE_SIZE		512
-#define SHA_TMP_BUF_SIZE	512
 #define SHA_BUF_SIZE		((u32)PAGE_SIZE)
 
 #define SHA_OP_UPDATE		1
@@ -319,7 +318,7 @@ static void mtk_sha_info_init(struct mtk_sha_reqctx *ctx)
  */
 static int mtk_sha_info_update(struct mtk_cryp *cryp,
 			       struct mtk_sha_rec *sha,
-			       size_t len)
+			       size_t len1, size_t len2)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_sha_info *info = &ctx->info;
@@ -331,11 +330,11 @@ static int mtk_sha_info_update(struct mtk_cryp *cryp,
 		ct->ctrl[0] &= ~SHA_TFM_START;
 
 	ctx->ct_hdr &= ~SHA_DATA_LEN_MSK;
-	ctx->ct_hdr |= cpu_to_le32(len);
+	ctx->ct_hdr |= cpu_to_le32(len1 + len2);
 	ct->cmd[0] &= ~SHA_DATA_LEN_MSK;
-	ct->cmd[0] |= cpu_to_le32(len);
+	ct->cmd[0] |= cpu_to_le32(len1 + len2);
 
-	ctx->digcnt += len;
+	ctx->digcnt += len1;
 
 	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
 				     DMA_BIDIRECTIONAL);
@@ -422,67 +421,24 @@ static int mtk_sha_init(struct ahash_request *req)
 }
 
 static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
-			dma_addr_t addr, size_t len)
+			dma_addr_t addr1, size_t len1,
+			dma_addr_t addr2, size_t len2)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_ring *ring = cryp->ring[sha->id];
 	struct mtk_desc *cmd = ring->cmd_base + ring->cmd_pos;
 	struct mtk_desc *res = ring->res_base + ring->res_pos;
-	int err;
-
-	err = mtk_sha_info_update(cryp, sha, len);
-	if (err)
-		return err;
-
-	/* Fill in the command/result descriptors */
-	res->hdr = MTK_DESC_FIRST | MTK_DESC_LAST | MTK_DESC_BUF_LEN(len);
-	res->buf = cpu_to_le32(cryp->tmp_dma);
-
-	cmd->hdr = MTK_DESC_FIRST | MTK_DESC_LAST | MTK_DESC_BUF_LEN(len) |
-		   MTK_DESC_CT_LEN(ctx->ct_size);
-
-	cmd->buf = cpu_to_le32(addr);
-	cmd->ct = cpu_to_le32(ctx->ct_dma);
-	cmd->ct_hdr = ctx->ct_hdr;
-	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
-
-	if (++ring->cmd_pos == MTK_DESC_NUM)
-		ring->cmd_pos = 0;
-
-	ring->res_pos = ring->cmd_pos;
-	/*
-	 * Make sure that all changes to the DMA ring are done before we
-	 * start engine.
-	 */
-	wmb();
-	/* Start DMA transfer */
-	mtk_sha_write(cryp, RDR_PREP_COUNT(sha->id), MTK_DESC_CNT(1));
-	mtk_sha_write(cryp, CDR_PREP_COUNT(sha->id), MTK_DESC_CNT(1));
-
-	return -EINPROGRESS;
-}
-
-static int mtk_sha_xmit2(struct mtk_cryp *cryp,
-			 struct mtk_sha_rec *sha,
-			 struct mtk_sha_reqctx *ctx,
-			 size_t len1, size_t len2)
-{
-	struct mtk_ring *ring = cryp->ring[sha->id];
-	struct mtk_desc *cmd = ring->cmd_base + ring->cmd_pos;
-	struct mtk_desc *res = ring->res_base + ring->res_pos;
-	int err;
+	int err, count = 0;
 
-	err = mtk_sha_info_update(cryp, sha, len1 + len2);
+	err = mtk_sha_info_update(cryp, sha, len1, len2);
 	if (err)
 		return err;
 
 	/* Fill in the command/result descriptors */
-	res->hdr = MTK_DESC_BUF_LEN(len1) | MTK_DESC_FIRST;
-	res->buf = cpu_to_le32(cryp->tmp_dma);
-
-	cmd->hdr = MTK_DESC_BUF_LEN(len1) | MTK_DESC_FIRST |
+	res->hdr = MTK_DESC_FIRST | MTK_DESC_BUF_LEN(len1);
+	cmd->hdr = MTK_DESC_FIRST | MTK_DESC_BUF_LEN(len1) |
 		   MTK_DESC_CT_LEN(ctx->ct_size);
-	cmd->buf = cpu_to_le32(sg_dma_address(ctx->sg));
+	cmd->buf = cpu_to_le32(addr1);
 	cmd->ct = cpu_to_le32(ctx->ct_dma);
 	cmd->ct_hdr = ctx->ct_hdr;
 	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
@@ -491,20 +447,25 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 		ring->cmd_pos = 0;
 
 	ring->res_pos = ring->cmd_pos;
+	count++;
 
-	cmd = ring->cmd_base + ring->cmd_pos;
-	res = ring->res_base + ring->res_pos;
+	if (len2) {
+		cmd = ring->cmd_base + ring->cmd_pos;
+		res = ring->res_base + ring->res_pos;
 
-	res->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
-	res->buf = cpu_to_le32(cryp->tmp_dma);
+		res->hdr = MTK_DESC_BUF_LEN(len2);
+		cmd->hdr = MTK_DESC_BUF_LEN(len2);
+		cmd->buf = cpu_to_le32(addr2);
 
-	cmd->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
-	cmd->buf = cpu_to_le32(ctx->dma_addr);
+		if (++ring->cmd_pos == MTK_DESC_NUM)
+			ring->cmd_pos = 0;
 
-	if (++ring->cmd_pos == MTK_DESC_NUM)
-		ring->cmd_pos = 0;
+		ring->res_pos = ring->cmd_pos;
+		count++;
+	}
 
-	ring->res_pos = ring->cmd_pos;
+	cmd->hdr |= MTK_DESC_LAST;
+	res->hdr |= MTK_DESC_LAST;
 
 	/*
 	 * Make sure that all changes to the DMA ring are done before we
@@ -512,8 +473,8 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 	 */
 	wmb();
 	/* Start DMA transfer */
-	mtk_sha_write(cryp, RDR_PREP_COUNT(sha->id), MTK_DESC_CNT(2));
-	mtk_sha_write(cryp, CDR_PREP_COUNT(sha->id), MTK_DESC_CNT(2));
+	mtk_sha_write(cryp, RDR_PREP_COUNT(sha->id), MTK_DESC_CNT(count));
+	mtk_sha_write(cryp, CDR_PREP_COUNT(sha->id), MTK_DESC_CNT(count));
 
 	return -EINPROGRESS;
 }
@@ -532,7 +493,7 @@ static int mtk_sha_dma_map(struct mtk_cryp *cryp,
 
 	ctx->flags &= ~SHA_FLAGS_SG;
 
-	return mtk_sha_xmit(cryp, sha, ctx->dma_addr, count);
+	return mtk_sha_xmit(cryp, sha, ctx->dma_addr, count, 0, 0);
 }
 
 static int mtk_sha_update_slow(struct mtk_cryp *cryp,
@@ -625,7 +586,8 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 
 		if (len == 0) {
 			ctx->flags &= ~SHA_FLAGS_SG;
-			return mtk_sha_xmit(cryp, sha, ctx->dma_addr, count);
+			return mtk_sha_xmit(cryp, sha, ctx->dma_addr,
+					    count, 0, 0);
 
 		} else {
 			ctx->sg = sg;
@@ -635,7 +597,8 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 			}
 
 			ctx->flags |= SHA_FLAGS_SG;
-			return mtk_sha_xmit2(cryp, sha, ctx, len, count);
+			return mtk_sha_xmit(cryp, sha, sg_dma_address(ctx->sg),
+					    len, ctx->dma_addr, count);
 		}
 	}
 
@@ -646,7 +609,8 @@ static int mtk_sha_update_start(struct mtk_cryp *cryp,
 
 	ctx->flags |= SHA_FLAGS_SG;
 
-	return mtk_sha_xmit(cryp, sha, sg_dma_address(ctx->sg), len);
+	return mtk_sha_xmit(cryp, sha, sg_dma_address(ctx->sg),
+			    len, 0, 0);
 }
 
 static int mtk_sha_final_req(struct mtk_cryp *cryp,
@@ -1361,14 +1325,6 @@ int mtk_hash_alg_register(struct mtk_cryp *cryp)
 	mtk_sha_write(cryp, AIC_ENABLE_SET(MTK_RING2), MTK_IRQ_RDR2);
 	mtk_sha_write(cryp, AIC_ENABLE_SET(MTK_RING3), MTK_IRQ_RDR3);
 
-	cryp->tmp = dma_alloc_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
-					&cryp->tmp_dma, GFP_KERNEL);
-	if (!cryp->tmp) {
-		dev_err(cryp->dev, "unable to allocate tmp buffer.\n");
-		err = -EINVAL;
-		goto err_res;
-	}
-
 	spin_lock(&mtk_sha.lock);
 	list_add_tail(&cryp->sha_list, &mtk_sha.dev_list);
 	spin_unlock(&mtk_sha.lock);
@@ -1383,8 +1339,6 @@ int mtk_hash_alg_register(struct mtk_cryp *cryp)
 	spin_lock(&mtk_sha.lock);
 	list_del(&cryp->sha_list);
 	spin_unlock(&mtk_sha.lock);
-	dma_free_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
-			  cryp->tmp, cryp->tmp_dma);
 err_res:
 	mtk_sha_record_free(cryp);
 err_record:
@@ -1400,7 +1354,5 @@ void mtk_hash_alg_release(struct mtk_cryp *cryp)
 	spin_unlock(&mtk_sha.lock);
 
 	mtk_sha_unregister_algs();
-	dma_free_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
-			  cryp->tmp, cryp->tmp_dma);
 	mtk_sha_record_free(cryp);
 }
-- 
1.9.1
