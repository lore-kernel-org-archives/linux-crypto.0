From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 10/22] staging: ccree: rewrite GET_DMA_BUFFER_TYPE as func
Date: Tue, 15 Aug 2017 09:26:38 +0300
Message-ID: <1502778412-16255-11-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The GET_DMA_BUFFER_TYPE macro was triggering a macro argument reuse
warning from checkpatch. Rewrite the macro as inline function instead
to avoid risk of unintended side effects.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 26 +++++++++++++++++---------
 drivers/staging/ccree/ssi_buffer_mgr.h |  6 ++++--
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 0b81fd5..4be7b51 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -34,11 +34,6 @@
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
@@ -65,6 +60,19 @@ struct buffer_array {
 	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
 
+static const char *dma_buf_types[SSI_DMA_BUF_TYPE_MAX] = {
+	"BUF_NULL",
+	"BUF_DLLI",
+	"BUF_MLLI"
+	"BUF_INVALID"
+};
+
+static inline const char *dma_buf_type_str(enum ssi_req_dma_buf_type type)
+{
+	type = (type < SSI_DMA_BUF_INVL) ? type : SSI_DMA_BUF_INVL;
+	return dma_buf_types[type];
+}
+
 /**
  * ssi_buffer_mgr_get_sgl_nents() - Get scatterlist number of entries.
  *
@@ -597,7 +605,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	}
 
 	SSI_LOG_DEBUG("areq_ctx->dma_buf_type = %s\n",
-		      GET_DMA_BUFFER_TYPE(req_ctx->dma_buf_type));
+		      dma_buf_type_str(req_ctx->dma_buf_type));
 
 	return 0;
 
@@ -827,7 +835,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
 		SSI_LOG_DEBUG("Chain assoc of length 0: buff_type=%s nents=%u\n",
-			      GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			      dma_buf_type_str(areq_ctx->assoc_buff_type),
 			      areq_ctx->assoc.nents);
 		goto chain_assoc_exit;
 	}
@@ -879,7 +887,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	if (unlikely((do_chain) ||
 		     (areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
 		SSI_LOG_DEBUG("Chain assoc: buff_type=%s nents=%u\n",
-			      GET_DMA_BUFFER_TYPE(areq_ctx->assoc_buff_type),
+			      dma_buf_type_str(areq_ctx->assoc_buff_type),
 			      areq_ctx->assoc.nents);
 		ssi_buffer_mgr_add_scatterlist_entry(
 			sg_data, areq_ctx->assoc.nents,
@@ -1555,7 +1563,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	/* change the buffer index for the unmap function */
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
 	SSI_LOG_DEBUG("areq_ctx->data_dma_buf_type = %s\n",
-		      GET_DMA_BUFFER_TYPE(areq_ctx->data_dma_buf_type));
+		      dma_buf_type_str(areq_ctx->data_dma_buf_type));
 	return 0;
 
 fail_unmap_din:
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 41f5223..93972fd 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -28,8 +28,10 @@
 
 enum ssi_req_dma_buf_type {
 	SSI_DMA_BUF_NULL = 0,
-	SSI_DMA_BUF_DLLI,
-	SSI_DMA_BUF_MLLI
+	SSI_DMA_BUF_DLLI = 1,
+	SSI_DMA_BUF_MLLI = 2,
+	SSI_DMA_BUF_INVL = 3,
+	SSI_DMA_BUF_TYPE_MAX = 4
 };
 
 enum ssi_sg_cpy_direct {
-- 
2.1.4
