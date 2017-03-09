From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 7/8] crypto: mediatek - add mtk_aes_gcm_tag_verify()
Date: Thu, 9 Mar 2017 10:11:18 +0800
Message-ID: <1489025479-48036-8-git-send-email-ryder.lee@mediatek.com>
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

This patch adds mtk_aes_gcm_tag_verify() which is used to compare
authenticated tag.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c      | 24 ++++++++++++++++++++++--
 drivers/crypto/mediatek/mtk-platform.h |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 6a0180d..8f3efa5 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -70,6 +70,8 @@
 #define AES_FLAGS_ENCRYPT	BIT(4)
 #define AES_FLAGS_BUSY		BIT(5)
 
+#define AES_AUTH_TAG_ERR	cpu_to_le32(BIT(26))
+
 /**
  * Command token(CT) is a set of hardware instructions that
  * are used to control engine's processing flow of AES.
@@ -306,6 +308,9 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	}
 	res->hdr |= MTK_DESC_LAST;
 
+	/* Pointer to current result descriptor */
+	ring->res_prev = res;
+
 	/* Prepare enough space for authenticated tag */
 	if (aes->flags & AES_FLAGS_GCM)
 		res->hdr += AES_BLOCK_SIZE;
@@ -799,6 +804,19 @@ static int mtk_aes_ctr_cra_init(struct crypto_tfm *tfm)
 	return container_of(ctx, struct mtk_aes_gcm_ctx, base);
 }
 
+/*
+ * Engine will verify and compare tag automatically, so we just need
+ * to check returned status which stored in the result descriptor.
+ */
+static int mtk_aes_gcm_tag_verify(struct mtk_cryp *cryp,
+				  struct mtk_aes_rec *aes)
+{
+	u32 status = cryp->ring[aes->id]->res_prev->ct;
+
+	return mtk_aes_complete(cryp, aes, (status & AES_AUTH_TAG_ERR) ?
+				-EBADMSG : 0);
+}
+
 /* Initialize transform information of GCM mode */
 static void mtk_aes_gcm_info_init(struct mtk_cryp *cryp,
 				  struct mtk_aes_rec *aes,
@@ -902,6 +920,8 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 
 	if (aes->flags & AES_FLAGS_ENCRYPT) {
 		u32 tag[4];
+
+		aes->resume = mtk_aes_transfer_complete;
 		/* Compute total process length. */
 		aes->total = len + gctx->authsize;
 		/* Compute text length. */
@@ -909,10 +929,10 @@ static int mtk_aes_gcm_start(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		/* Hardware will append authenticated tag to output buffer */
 		scatterwalk_map_and_copy(tag, req->dst, len, gctx->authsize, 1);
 	} else {
+		aes->resume = mtk_aes_gcm_tag_verify;
 		aes->total = len;
 		gctx->textlen = req->cryptlen - gctx->authsize;
 	}
-	aes->resume = mtk_aes_transfer_complete;
 
 	return mtk_aes_gcm_dma(cryp, aes, req->src, req->dst, len);
 }
@@ -925,7 +945,7 @@ static int mtk_aes_gcm_crypt(struct aead_request *req, u64 mode)
 	rctx->mode = AES_FLAGS_GCM | mode;
 
 	return mtk_aes_handle_queue(ctx->cryp, !!(mode & AES_FLAGS_ENCRYPT),
-								&req->base);
+				    &req->base);
 }
 
 static void mtk_gcm_setkey_done(struct crypto_async_request *req, int err)
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index cc98c2c..303c152 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -88,6 +88,7 @@ struct mtk_desc {
  * @cmd_dma:	DMA address of command descriptor ring
  * @res_base:	pointer to result descriptor ring base
  * @res_next:	pointer to the next result descriptor
+ * @res_prev:	pointer to the previous result descriptor
  * @res_dma:	DMA address of result descriptor ring
  *
  * A descriptor ring is a circular buffer that is used to manage
@@ -100,6 +101,7 @@ struct mtk_ring {
 	dma_addr_t cmd_dma;
 	struct mtk_desc *res_base;
 	struct mtk_desc *res_next;
+	struct mtk_desc *res_prev;
 	dma_addr_t res_dma;
 };
 
-- 
1.9.1
