From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 4/8] crypto: mediatek - simplify descriptor ring management
Date: Thu, 9 Mar 2017 10:11:15 +0800
Message-ID: <1489025479-48036-5-git-send-email-ryder.lee@mediatek.com>
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

This patch replaces cmd_pos/res_pos with pointer cmd_next/res_next.

In old code, we must to add one to shift ring to the next segment, and
then use this value to caculate current offset from ring base for each
DMA operation. Now these pointers helps us to simplify flow, so we just
need to move pointers and check the boundaries of ring.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c      | 14 ++++++++------
 drivers/crypto/mediatek/mtk-platform.c |  3 +++
 drivers/crypto/mediatek/mtk-platform.h |  8 ++++----
 drivers/crypto/mediatek/mtk-sha.c      | 35 ++++++++++++++++++----------------
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index b57b68f..21f3e59 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -262,7 +262,7 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 
 	/* Write command descriptors */
 	for (nents = 0; nents < slen; ++nents, ssg = sg_next(ssg)) {
-		cmd = ring->cmd_base + ring->cmd_pos;
+		cmd = ring->cmd_next;
 		cmd->hdr = MTK_DESC_BUF_LEN(ssg->length);
 		cmd->buf = cpu_to_le32(sg_dma_address(ssg));
 
@@ -274,22 +274,24 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 			cmd->tfm = cpu_to_le32(aes->ctx->tfm_dma);
 		}
 
-		if (++ring->cmd_pos == MTK_DESC_NUM)
-			ring->cmd_pos = 0;
+		/* Shift ring buffer and check boundary */
+		if (++ring->cmd_next == ring->cmd_base + MTK_DESC_NUM)
+			ring->cmd_next = ring->cmd_base;
 	}
 	cmd->hdr |= MTK_DESC_LAST;
 
 	/* Prepare result descriptors */
 	for (nents = 0; nents < dlen; ++nents, dsg = sg_next(dsg)) {
-		res = ring->res_base + ring->res_pos;
+		res = ring->res_next;
 		res->hdr = MTK_DESC_BUF_LEN(dsg->length);
 		res->buf = cpu_to_le32(sg_dma_address(dsg));
 
 		if (nents == 0)
 			res->hdr |= MTK_DESC_FIRST;
 
-		if (++ring->res_pos == MTK_DESC_NUM)
-			ring->res_pos = 0;
+		/* Shift ring buffer and check boundary */
+		if (++ring->res_next == ring->res_base + MTK_DESC_NUM)
+			ring->res_next = ring->res_base;
 	}
 	res->hdr |= MTK_DESC_LAST;
 
diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 50de335..b6ecc28 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -465,6 +465,9 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 					   GFP_KERNEL);
 		if (!ring[i]->res_base)
 			goto err_cleanup;
+
+		ring[i]->cmd_next = ring[i]->cmd_base;
+		ring[i]->res_next = ring[i]->res_base;
 	}
 	return 0;
 
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 78ce54e..218e30d 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -84,11 +84,11 @@ struct mtk_desc {
 /**
  * struct mtk_ring - Descriptor ring
  * @cmd_base:	pointer to command descriptor ring base
+ * @cmd_next:	pointer to the next command descriptor
  * @cmd_dma:	DMA address of command descriptor ring
- * @cmd_pos:	current position in the command descriptor ring
  * @res_base:	pointer to result descriptor ring base
+ * @res_next:	pointer to the next result descriptor
  * @res_dma:	DMA address of result descriptor ring
- * @res_pos:	current position in the result descriptor ring
  *
  * A descriptor ring is a circular buffer that is used to manage
  * one or more descriptors. There are two type of descriptor rings;
@@ -96,11 +96,11 @@ struct mtk_desc {
  */
 struct mtk_ring {
 	struct mtk_desc *cmd_base;
+	struct mtk_desc *cmd_next;
 	dma_addr_t cmd_dma;
-	u32 cmd_pos;
 	struct mtk_desc *res_base;
+	struct mtk_desc *res_next;
 	dma_addr_t res_dma;
-	u32 res_pos;
 };
 
 /**
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index ef6fb20..0884d62 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -152,6 +152,21 @@ static inline void mtk_sha_write(struct mtk_cryp *cryp,
 	writel_relaxed(value, cryp->base + offset);
 }
 
+static inline void mtk_sha_ring_shift(struct mtk_ring *ring,
+				      struct mtk_desc **cmd_curr,
+				      struct mtk_desc **res_curr,
+				      int *count)
+{
+	*cmd_curr = ring->cmd_next++;
+	*res_curr = ring->res_next++;
+	(*count)++;
+
+	if (ring->cmd_next == ring->cmd_base + MTK_DESC_NUM) {
+		ring->cmd_next = ring->cmd_base;
+		ring->res_next = ring->res_base;
+	}
+}
+
 static struct mtk_cryp *mtk_sha_find_dev(struct mtk_sha_ctx *tctx)
 {
 	struct mtk_cryp *cryp = NULL;
@@ -426,8 +441,7 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_ring *ring = cryp->ring[sha->id];
-	struct mtk_desc *cmd = ring->cmd_base + ring->cmd_pos;
-	struct mtk_desc *res = ring->res_base + ring->res_pos;
+	struct mtk_desc *cmd, *res;
 	int err, count = 0;
 
 	err = mtk_sha_info_update(cryp, sha, len1, len2);
@@ -435,6 +449,8 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 		return err;
 
 	/* Fill in the command/result descriptors */
+	mtk_sha_ring_shift(ring, &cmd, &res, &count);
+
 	res->hdr = MTK_DESC_FIRST | MTK_DESC_BUF_LEN(len1);
 	cmd->hdr = MTK_DESC_FIRST | MTK_DESC_BUF_LEN(len1) |
 		   MTK_DESC_CT_LEN(ctx->ct_size);
@@ -443,25 +459,12 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 	cmd->ct_hdr = ctx->ct_hdr;
 	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
 
-	if (++ring->cmd_pos == MTK_DESC_NUM)
-		ring->cmd_pos = 0;
-
-	ring->res_pos = ring->cmd_pos;
-	count++;
-
 	if (len2) {
-		cmd = ring->cmd_base + ring->cmd_pos;
-		res = ring->res_base + ring->res_pos;
+		mtk_sha_ring_shift(ring, &cmd, &res, &count);
 
 		res->hdr = MTK_DESC_BUF_LEN(len2);
 		cmd->hdr = MTK_DESC_BUF_LEN(len2);
 		cmd->buf = cpu_to_le32(addr2);
-
-		if (++ring->cmd_pos == MTK_DESC_NUM)
-			ring->cmd_pos = 0;
-
-		ring->res_pos = ring->cmd_pos;
-		count++;
 	}
 
 	cmd->hdr |= MTK_DESC_LAST;
-- 
1.9.1
