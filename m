From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 14/24] staging: ccree: replace macro with inline func
Date: Mon, 13 Nov 2017 14:45:42 +0000
Message-ID: <1510584358-29473-15-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace GET_DMA_BUFFER_TYPE with an inline function
variant with type checking.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 684c934..5e01477 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -33,11 +33,6 @@
 #include "ssi_hash.h"
 #include "ssi_aead.h"
 
-#define GET_DMA_BUFFER_TYPE(buff_type) ( \
-	((buff_type) == SSI_DMA_BUF_NULL) ? "BUF_NULL" : \
-	((buff_type) == SSI_DMA_BUF_DLLI) ? "BUF_DLLI" : \
-	((buff_type) == SSI_DMA_BUF_MLLI) ? "BUF_MLLI" : "BUF_INVALID")
-
 enum dma_buffer_type {
 	DMA_NULL_TYPE = -1,
 	DMA_SGL_TYPE = 1,
@@ -64,6 +59,20 @@ struct buffer_array {
 	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
 
+static inline char *cc_dma_buf_type(enum ssi_req_dma_buf_type type)
+{
+	switch (type) {
+	case SSI_DMA_BUF_NULL:
+		return "BUF_NULL";
+	case SSI_DMA_BUF_DLLI:
+		return "BUF_DLLI";
+	case SSI_DMA_BUF_MLLI:
+		return "BUF_MLLI";
+	default:
+		return "BUF_INVALID";
+	}
+}
+
 /**
  * cc_copy_mac() - Copy MAC to temporary location
  *
@@ -594,7 +603,7 @@ int cc_map_blkcipher_request(
 	}
 
 	dev_dbg(dev, "areq_ctx->dma_buf_type = %s\n",
-		GET_DMA_BUFFER_TYPE(req_ctx->dma_buf_type));
+		cc_dma_buf_type(req_ctx->dma_buf_type));
 
 	return 0;
 
@@ -819,7 +828,7 @@ static inline int cc_aead_chain_assoc(
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
 		dev_dbg(dev, "Chain assoc of length 0: buff_type=%s nents=%u\n",
-			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
 		goto chain_assoc_exit;
 	}
@@ -871,7 +880,7 @@ static inline int cc_aead_chain_assoc(
 	if (unlikely((do_chain) ||
 		     areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI)) {
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
-			GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
 		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
 				req->assoclen, 0, is_last,
@@ -1496,7 +1505,7 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 	/* change the buffer index for the unmap function */
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
 	dev_dbg(dev, "areq_ctx->data_dma_buf_type = %s\n",
-		GET_DMA_BUFFER_TYPE(areq_ctx->data_dma_buf_type));
+		cc_dma_buf_type(areq_ctx->data_dma_buf_type));
 	return 0;
 
 fail_unmap_din:
-- 
2.7.4
