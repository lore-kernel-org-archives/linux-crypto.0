From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/24] staging: ccree: fix func call param indentation
Date: Tue, 12 Dec 2017 14:52:54 +0000
Message-ID: <1513090395-7938-9-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:45090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdLLOyd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 09:54:33 -0500
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix function call parameter indentation according to coding
style guide lines.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 28 +++++++++++-----------------
 drivers/staging/ccree/ssi_hash.c       | 10 ++++------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 490dd5a..4ab76dc 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -239,9 +239,9 @@ static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
 	dev_dbg(dev, "NUM of SG's = %d\n", sg_data->num_of_buffers);
 
 	/* Allocate memory from the pointed pool */
-	mlli_params->mlli_virt_addr = dma_pool_alloc(
-			mlli_params->curr_pool, GFP_KERNEL,
-			&mlli_params->mlli_dma_addr);
+	mlli_params->mlli_virt_addr =
+		dma_pool_alloc(mlli_params->curr_pool, GFP_KERNEL,
+			       &mlli_params->mlli_dma_addr);
 	if (!mlli_params->mlli_virt_addr) {
 		dev_err(dev, "dma_pool_alloc() failed\n");
 		rc = -ENOMEM;
@@ -881,27 +881,21 @@ static void cc_prepare_aead_data_dlli(struct aead_request *req,
 	areq_ctx->is_icv_fragmented = false;
 	if (req->src == req->dst) {
 		/*INPLACE*/
-		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->src_sgl) +
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->src_sgl) +
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		/*NON-INPLACE and DECRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->src_sgl) +
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->src_sgl) +
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 	} else {
 		/*NON-INPLACE and ENCRYPT*/
-		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->dst_sgl) +
+		areq_ctx->icv_dma_addr = sg_dma_address(areq_ctx->dst_sgl) +
 			(*dst_last_bytes - authsize);
-		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->dst_sgl) +
+		areq_ctx->icv_virt_addr = sg_virt(areq_ctx->dst_sgl) +
 			(*dst_last_bytes - authsize);
 	}
 }
@@ -1660,8 +1654,8 @@ int cc_buffer_mgr_init(struct ssi_drvdata *drvdata)
 
 	drvdata->buff_mgr_handle = buff_mgr_handle;
 
-	buff_mgr_handle->mlli_buffs_pool = dma_pool_create(
-				"dx_single_mlli_tables", dev,
+	buff_mgr_handle->mlli_buffs_pool =
+		dma_pool_create("dx_single_mlli_tables", dev,
 				MAX_NUM_OF_TOTAL_MLLI_ENTRIES *
 				LLI_ENTRY_BYTE_SIZE,
 				MLLI_TABLE_MIN_ALIGNMENT, 0);
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index a80279e..29c17f3 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -951,9 +951,8 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	ctx->is_hmac = true;
 
 	if (keylen) {
-		ctx->key_params.key_dma_addr = dma_map_single(
-						dev, (void *)key,
-						keylen, DMA_TO_DEVICE);
+		ctx->key_params.key_dma_addr =
+			dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
@@ -1132,9 +1131,8 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 
 	ctx->key_params.keylen = keylen;
 
-	ctx->key_params.key_dma_addr = dma_map_single(
-					dev, (void *)key,
-					keylen, DMA_TO_DEVICE);
+	ctx->key_params.key_dma_addr =
+		dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx->key_params.key_dma_addr)) {
 		dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 			key, keylen);
-- 
2.7.4
