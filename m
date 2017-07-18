From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 3/6] staging: ccree: Fix alignment issues in ssi_buffer_mgr.c
Date: Tue, 18 Jul 2017 22:03:54 +0200
Message-ID: <20170718200357.32646-4-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36567 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdGRUFV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:21 -0400
Received: by mail-lf0-f44.google.com with SMTP id d78so17766781lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:20 -0700 (PDT)
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 40 ++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 6579a54f9dc4..63936091d524 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -371,7 +371,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 		*mapped_nents = 1;
 	} else {  /*sg_is_last*/
 		*nents = ssi_buffer_mgr_get_sgl_nents(sg, nbytes, lbytes,
-						     &is_chained);
+						      &is_chained);
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			SSI_LOG_ERR("Too many fragments. current %d max %d\n",
@@ -393,9 +393,9 @@ static int ssi_buffer_mgr_map_scatterlist(
 			 * must have the same nents before and after map
 			 */
 			*mapped_nents = ssi_buffer_mgr_dma_map_sg(dev,
-								 sg,
-								 *nents,
-								 direction);
+								  sg,
+								  *nents,
+								  direction);
 			if (unlikely(*mapped_nents != *nents)) {
 				*nents = *mapped_nents;
 				SSI_LOG_ERR("dma_map_sg() sg buffer failed\n");
@@ -783,8 +783,8 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 		goto chain_iv_exit;
 	}
 
-	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
-		hw_iv_size, DMA_BIDIRECTIONAL);
+	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv, hw_iv_size,
+						       DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
 		SSI_LOG_ERR("Mapping iv %u B at va=%pK for DMA failed\n",
 			    hw_iv_size, req->iv);
@@ -1323,8 +1323,9 @@ int ssi_buffer_mgr_map_aead_request(
 				req->cryptlen :
 				(req->cryptlen - authsize);
 
-	areq_ctx->mac_buf_dma_addr = dma_map_single(dev,
-		areq_ctx->mac_buf, MAX_MAC_SIZE, DMA_BIDIRECTIONAL);
+	areq_ctx->mac_buf_dma_addr = dma_map_single(dev, areq_ctx->mac_buf,
+						    MAX_MAC_SIZE,
+						    DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->mac_buf_dma_addr))) {
 		SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK for DMA failed\n",
 			    MAX_MAC_SIZE, areq_ctx->mac_buf);
@@ -1334,8 +1335,9 @@ int ssi_buffer_mgr_map_aead_request(
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		areq_ctx->ccm_iv0_dma_addr = dma_map_single(dev,
-			(areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET),
-			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+							    (areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET),
+							    AES_BLOCK_SIZE,
+							    DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
 			SSI_LOG_ERR("Mapping mac_buf %u B at va=%pK "
@@ -1356,7 +1358,9 @@ int ssi_buffer_mgr_map_aead_request(
 #if SSI_CC_HAS_AES_GCM
 	if (areq_ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		areq_ctx->hkey_dma_addr = dma_map_single(dev,
-			areq_ctx->hkey, AES_BLOCK_SIZE, DMA_BIDIRECTIONAL);
+							 areq_ctx->hkey,
+							 AES_BLOCK_SIZE,
+							 DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
 			SSI_LOG_ERR("Mapping hkey %u B at va=%pK for DMA failed\n",
 				    AES_BLOCK_SIZE, areq_ctx->hkey);
@@ -1365,7 +1369,9 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_block_len_dma_addr = dma_map_single(dev,
-			&areq_ctx->gcm_len_block, AES_BLOCK_SIZE, DMA_TO_DEVICE);
+								  &areq_ctx->gcm_len_block,
+								  AES_BLOCK_SIZE,
+								  DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
 				    AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
@@ -1374,8 +1380,9 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_iv_inc1_dma_addr = dma_map_single(dev,
-			areq_ctx->gcm_iv_inc1,
-			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+								areq_ctx->gcm_iv_inc1,
+								AES_BLOCK_SIZE,
+								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_iv_inc1 %u B at va=%pK "
@@ -1387,8 +1394,9 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_map_single(dev,
-			areq_ctx->gcm_iv_inc2,
-			AES_BLOCK_SIZE, DMA_TO_DEVICE);
+								areq_ctx->gcm_iv_inc2,
+								AES_BLOCK_SIZE,
+								DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
 			SSI_LOG_ERR("Mapping gcm_iv_inc2 %u B at va=%pK "
-- 
2.11.0
