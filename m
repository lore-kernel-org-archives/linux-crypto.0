From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/14] staging: ccree: drop comparsion to true/false
Date: Tue, 27 Jun 2017 10:27:14 +0300
Message-ID: <1498548449-10803-3-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752362AbdF0H16 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:27:58 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix cases in ccree where explicit comparsion to true/false
was made.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       | 18 +++++++++---------
 drivers/staging/ccree/ssi_buffer_mgr.c | 20 ++++++++++----------
 drivers/staging/ccree/ssi_cipher.c     |  2 +-
 drivers/staging/ccree/ssi_driver.c     |  4 ++--
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 2e8dc3f..00375b6 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -236,7 +236,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 			err = -EBADMSG;
 		}
 	} else { /*ENCRYPT*/
-		if (unlikely(areq_ctx->is_icv_fragmented == true))
+		if (unlikely(areq_ctx->is_icv_fragmented))
 			ssi_buffer_mgr_copy_scatterlist_portion(
 				areq_ctx->mac_buf, areq_ctx->dstSgl, areq->cryptlen + areq_ctx->dstOffset,
 				areq->cryptlen + areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
@@ -790,7 +790,7 @@ ssi_aead_process_authenc_data_desc(
 		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
-		if (likely(areq_ctx->is_single_pass == true)) {
+		if (likely(areq_ctx->is_single_pass)) {
 			if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 				mlli_addr = areq_ctx->dst.sram_addr;
 				mlli_nents = areq_ctx->dst.mlli_nents;
@@ -1173,7 +1173,7 @@ static inline void ssi_aead_load_mlli_to_sram(
 	if (unlikely(
 		(req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
 		(req_ctx->data_buff_type == SSI_DMA_BUF_MLLI) ||
-		(req_ctx->is_single_pass == false))) {
+		!req_ctx->is_single_pass)) {
 		SSI_LOG_DEBUG("Copy-to-sram: mlli_dma=%08x, mlli_size=%u\n",
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
 			req_ctx->mlli_params.mlli_len);
@@ -1228,7 +1228,7 @@ static inline void ssi_aead_hmac_authenc(
 	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
 		direct, ctx->flow_mode, req_ctx->is_single_pass);
 
-	if (req_ctx->is_single_pass == true) {
+	if (req_ctx->is_single_pass) {
 		/**
 		 * Single-pass flow
 		 */
@@ -1282,7 +1282,7 @@ ssi_aead_xcbc_authenc(
 	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
 		direct, ctx->flow_mode, req_ctx->is_single_pass);
 
-	if (req_ctx->is_single_pass == true) {
+	if (req_ctx->is_single_pass) {
 		/**
 		 * Single-pass flow
 		 */
@@ -1341,7 +1341,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			break;
 		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
-			if (areq_ctx->plaintext_authenticate_only == true)
+			if (areq_ctx->plaintext_authenticate_only)
 				areq_ctx->is_single_pass = false;
 			break;
 		}
@@ -1715,7 +1715,7 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only == false)) {
+	if ((req_ctx->cryptlen != 0) && (!req_ctx->plaintext_authenticate_only)) {
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1815,7 +1815,7 @@ static inline int ssi_aead_gcm(
 
 
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
-	if (req_ctx->plaintext_authenticate_only == true) {
+	if (req_ctx->plaintext_authenticate_only) {
 		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
 		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 		/* process(ghash) assoc data */
@@ -1913,7 +1913,7 @@ static int config_gcm_context(struct aead_request *req)
 	memcpy(req_ctx->gcm_iv_inc1, req->iv, 16);
 
 
-	if (req_ctx->plaintext_authenticate_only == false) {
+	if (!req_ctx->plaintext_authenticate_only) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
 		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 00d95c1..5c46145 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -798,7 +798,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
 		hw_iv_size, req->iv,
 		(unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
-	if (do_chain == true && areq_ctx->plaintext_authenticate_only == true) {  // TODO: what about CTR?? ask Ron
+	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
 		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
@@ -894,7 +894,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	else
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 
-	if (unlikely((do_chain == true) ||
+	if (unlikely((do_chain) ||
 		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI))) {
 
 		SSI_LOG_DEBUG("Chain assoc: buff_type=%s nents=%u\n",
@@ -975,7 +975,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			goto prepare_data_mlli_exit;
 		}
 
-		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
+		if (unlikely(areq_ctx->is_icv_fragmented)) {
 			/* Backup happens only when ICV is fragmented, ICV
 			 * verification is made by CPU compare in order to simplify
 			 * MAC verification upon request completion
@@ -1033,7 +1033,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			goto prepare_data_mlli_exit;
 		}
 
-		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
+		if (unlikely(areq_ctx->is_icv_fragmented)) {
 			/* Backup happens only when ICV is fragmented, ICV
 			 * verification is made by CPU compare in order to simplify
 			 * MAC verification upon request completion
@@ -1076,7 +1076,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			goto prepare_data_mlli_exit;
 		}
 
-		if (likely(areq_ctx->is_icv_fragmented == false)) {
+		if (likely(!areq_ctx->is_icv_fragmented)) {
 			/* Contig. ICV */
 			areq_ctx->icv_dma_addr = sg_dma_address(
 				&areq_ctx->dstSgl[areq_ctx->dst.nents - 1]) +
@@ -1200,7 +1200,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	areq_ctx->dstOffset = offset;
 	if ((src_mapped_nents > 1) ||
 	    (dst_mapped_nents  > 1) ||
-	    (do_chain == true)) {
+	    do_chain) {
 		areq_ctx->data_buff_type = SSI_DMA_BUF_MLLI;
 		rc = ssi_buffer_mgr_prepare_aead_data_mlli(drvdata, req, sg_data,
 			&src_last_bytes, &dst_last_bytes, is_last_table);
@@ -1233,7 +1233,7 @@ static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 			areq_ctx->src.sram_addr = drvdata->mlli_sram_addr +
 								curr_mlli_size;
 			areq_ctx->dst.sram_addr = areq_ctx->src.sram_addr;
-			if (areq_ctx->is_single_pass == false)
+			if (!areq_ctx->is_single_pass)
 				areq_ctx->assoc.mlli_nents +=
 					areq_ctx->src.mlli_nents;
 		} else {
@@ -1246,7 +1246,7 @@ static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 						areq_ctx->src.sram_addr +
 						areq_ctx->src.mlli_nents *
 						LLI_ENTRY_BYTE_SIZE;
-				if (areq_ctx->is_single_pass == false)
+				if (!areq_ctx->is_single_pass)
 					areq_ctx->assoc.mlli_nents +=
 						areq_ctx->src.mlli_nents;
 			} else {
@@ -1257,7 +1257,7 @@ static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 						areq_ctx->dst.sram_addr +
 						areq_ctx->dst.mlli_nents *
 						LLI_ENTRY_BYTE_SIZE;
-				if (areq_ctx->is_single_pass == false)
+				if (!areq_ctx->is_single_pass)
 					areq_ctx->assoc.mlli_nents +=
 						areq_ctx->dst.mlli_nents;
 			}
@@ -1399,7 +1399,7 @@ int ssi_buffer_mgr_map_aead_request(
 		goto aead_map_failure;
 	}
 
-	if (likely(areq_ctx->is_single_pass == true)) {
+	if (likely(areq_ctx->is_single_pass)) {
 		/*
 		 * Create MLLI table for:
 		 *   (1) Assoc. data
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 519e04e..1dab3e6 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -839,7 +839,7 @@ static int ssi_blkcipher_process(
 			      desc, &seq_len);
 
 	/* do we need to generate IV? */
-	if (req_ctx->is_giv == true) {
+	if (req_ctx->is_giv) {
 		ssi_req.ivgen_dma_addr[0] = req_ctx->gen_ctx.iv_dma_addr;
 		ssi_req.ivgen_dma_addr_len = 1;
 		/* set the IV size (8/16 B long)*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 7c94354..05930e8 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -205,13 +205,13 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
 
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
-	if (is_probe == true) {
+	if (is_probe) {
 		SSI_LOG_INFO("Cache params previous: 0x%08X\n", val);
 	}
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS),
 			      cache_params);
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
-	if (is_probe == true) {
+	if (is_probe) {
 		SSI_LOG_INFO("Cache params current: 0x%08X (expect: 0x%08X)\n",
 			     val, cache_params);
 	}
-- 
2.1.4
