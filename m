From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 23/24] staging: ccree: use local vars for readability
Date: Mon, 13 Nov 2017 14:45:51 +0000
Message-ID: <1510584358-29473-24-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Refactor cc_map_aead_request() to use local vars for addresses
for better readability of code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 64 +++++++++++++++-------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 966033d..c542225 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1259,7 +1259,7 @@ int cc_map_aead_request(
 	int rc = 0;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
-
+	dma_addr_t dma_addr;
 	u32 mapped_nents = 0;
 	u32 dummy = 0; /*used for the assoc data fragments */
 	u32 size_to_map = 0;
@@ -1281,32 +1281,31 @@ int cc_map_aead_request(
 				req->cryptlen :
 				(req->cryptlen - authsize);
 
-	areq_ctx->mac_buf_dma_addr = dma_map_single(dev, areq_ctx->mac_buf,
-						    MAX_MAC_SIZE,
-						    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
+	dma_addr = dma_map_single(dev, areq_ctx->mac_buf, MAX_MAC_SIZE,
+				  DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, dma_addr))) {
 		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
 			MAX_MAC_SIZE, areq_ctx->mac_buf);
 		rc = -ENOMEM;
 		goto aead_map_failure;
 	}
+	areq_ctx->mac_buf_dma_addr = dma_addr;
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		areq_ctx->ccm_iv0_dma_addr =
-			dma_map_single(dev, (areq_ctx->ccm_config +
-					     CCM_CTR_COUNT_0_OFFSET),
-				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		void *addr = areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET;
 
-		if (unlikely(dma_mapping_error(dev,
-					       areq_ctx->ccm_iv0_dma_addr))) {
+		dma_addr = dma_map_single(dev, addr, AES_BLOCK_SIZE,
+					  DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, dma_addr))) {
 			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
-				AES_BLOCK_SIZE,
-				(areq_ctx->ccm_config +
-				 CCM_CTR_COUNT_0_OFFSET));
+				AES_BLOCK_SIZE, addr);
 			areq_ctx->ccm_iv0_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
+		areq_ctx->ccm_iv0_dma_addr = dma_addr;
+
 		if (ssi_aead_handle_config_buf(dev, areq_ctx,
 					       areq_ctx->ccm_config, &sg_data,
 					       req->assoclen)) {
@@ -1317,54 +1316,49 @@ int cc_map_aead_request(
 
 #if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
-		areq_ctx->hkey_dma_addr = dma_map_single(dev,
-							 areq_ctx->hkey,
-							 AES_BLOCK_SIZE,
-							 DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev,
-					       areq_ctx->hkey_dma_addr))) {
+		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
+					  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(dev, dma_addr))) {
 			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
+		areq_ctx->hkey_dma_addr = dma_addr;
 
-		areq_ctx->gcm_block_len_dma_addr =
-			dma_map_single(dev, &areq_ctx->gcm_len_block,
-				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev,
-					       areq_ctx->gcm_block_len_dma_addr))) {
+		dma_addr = dma_map_single(dev, &areq_ctx->gcm_len_block,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, dma_addr))) {
 			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
+		areq_ctx->gcm_block_len_dma_addr = dma_addr;
 
-		areq_ctx->gcm_iv_inc1_dma_addr =
-			dma_map_single(dev, areq_ctx->gcm_iv_inc1,
-				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc1,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev,
-					       areq_ctx->gcm_iv_inc1_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev, dma_addr))) {
 			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
+		areq_ctx->gcm_iv_inc1_dma_addr = dma_addr;
 
-		areq_ctx->gcm_iv_inc2_dma_addr =
-			dma_map_single(dev, areq_ctx->gcm_iv_inc2,
-				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		dma_addr = dma_map_single(dev, areq_ctx->gcm_iv_inc2,
+					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev,
-					       areq_ctx->gcm_iv_inc2_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev, dma_addr))) {
 			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
+		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
 	}
 #endif /*SSI_CC_HAS_AES_GCM*/
 
-- 
2.7.4
