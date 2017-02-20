From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 7/9] crypto: mediatek - add mtk_aes_gcm_tag_verify()
Date: Mon, 20 Feb 2017 17:27:00 +0800
Message-ID: <1487582822-30393-8-git-send-email-ryder.lee@mediatek.com>
References: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:9078 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752450AbdBTJ1S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:18 -0500
In-Reply-To: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds mtk_aes_gcm_tag_verify() which is used to compare
authenticated tag.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
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
