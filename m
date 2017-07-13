From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/12] staging: ccree: CamelCase to snake_case in aead struct
Date: Thu, 13 Jul 2017 11:19:57 +0300
Message-ID: <1499934004-28513-8-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rename aead_req_struct fields from CamelCase to snake_case.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       | 26 ++++++------
 drivers/staging/ccree/ssi_aead.h       | 12 +++---
 drivers/staging/ccree/ssi_buffer_mgr.c | 78 +++++++++++++++++-----------------
 3 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 6d5cf02..dab4914 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -251,8 +251,8 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	} else { /*ENCRYPT*/
 		if (unlikely(areq_ctx->is_icv_fragmented))
 			ssi_buffer_mgr_copy_scatterlist_portion(
-				areq_ctx->mac_buf, areq_ctx->dstSgl, areq->cryptlen + areq_ctx->dstOffset,
-				areq->cryptlen + areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
+				areq_ctx->mac_buf, areq_ctx->dst_sgl, areq->cryptlen + areq_ctx->dst_offset,
+				areq->cryptlen + areq_ctx->dst_offset + ctx->authsize, SSI_SG_FROM_BUF);
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv) {
@@ -777,11 +777,11 @@ ssi_aead_process_authenc_data_desc(
 	{
 		struct scatterlist *cipher =
 			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dstSgl : areq_ctx->srcSgl;
+			areq_ctx->dst_sgl : areq_ctx->src_sgl;
 
 		unsigned int offset =
 			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-			areq_ctx->dstOffset : areq_ctx->srcOffset;
+			areq_ctx->dst_offset : areq_ctx->src_offset;
 		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
@@ -843,11 +843,11 @@ ssi_aead_process_cipher_data_desc(
 		SSI_LOG_DEBUG("CIPHER: SRC/DST buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
-			     (sg_dma_address(areq_ctx->srcSgl) +
-			      areq_ctx->srcOffset), areq_ctx->cryptlen, NS_BIT);
+			     (sg_dma_address(areq_ctx->src_sgl) +
+			      areq_ctx->src_offset), areq_ctx->cryptlen, NS_BIT);
 		set_dout_dlli(&desc[idx],
-			      (sg_dma_address(areq_ctx->dstSgl) +
-			       areq_ctx->dstOffset),
+			      (sg_dma_address(areq_ctx->dst_sgl) +
+			       areq_ctx->dst_offset),
 			      areq_ctx->cryptlen, NS_BIT, 0);
 		set_flow_mode(&desc[idx], flow_mode);
 		break;
@@ -1880,7 +1880,7 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("mac_buf", req_ctx->mac_buf, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a, AES_BLOCK_SIZE);
 
 	if (req->src && req->cryptlen)
 		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
@@ -1919,16 +1919,16 @@ static int config_gcm_context(struct aead_request *req)
 		__be64 temp64;
 
 		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
+		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy(&req_ctx->gcm_len_block.lenC, &temp64, 8);
+		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
 	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 
 		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
-		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
+		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
-		memcpy(&req_ctx->gcm_len_block.lenC, &temp64, 8);
+		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
 	}
 
 	return 0;
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 39cc633..e85bcd9 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -69,8 +69,8 @@ struct aead_req_ctx {
 	u8 gcm_iv_inc2[AES_BLOCK_SIZE] ____cacheline_aligned;
 	u8 hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
 	struct {
-		u8 lenA[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
-		u8 lenC[GCM_BLOCK_LEN_SIZE];
+		u8 len_a[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
+		u8 len_c[GCM_BLOCK_LEN_SIZE];
 	} gcm_len_block;
 
 	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
@@ -94,10 +94,10 @@ struct aead_req_ctx {
 	struct ssi_mlli assoc;
 	struct ssi_mlli src;
 	struct ssi_mlli dst;
-	struct scatterlist *srcSgl;
-	struct scatterlist *dstSgl;
-	unsigned int srcOffset;
-	unsigned int dstOffset;
+	struct scatterlist *src_sgl;
+	struct scatterlist *dst_sgl;
+	unsigned int src_offset;
+	unsigned int dst_offset;
 	enum ssi_req_dma_buf_type assoc_buff_type;
 	enum ssi_req_dma_buf_type data_buff_type;
 	struct mlli_params mlli_params;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index b707cbc..648be32 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -907,26 +907,26 @@ static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
 	if (likely(req->src == req->dst)) {
 		/*INPLACE*/
 		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->srcSgl) +
+			areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->srcSgl) +
+			areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 	} else if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 		/*NON-INPLACE and DECRYPT*/
 		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->srcSgl) +
+			areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->srcSgl) +
+			areq_ctx->src_sgl) +
 			(*src_last_bytes - authsize);
 	} else {
 		/*NON-INPLACE and ENCRYPT*/
 		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->dstSgl) +
+			areq_ctx->dst_sgl) +
 			(*dst_last_bytes - authsize);
 		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->dstSgl) +
+			areq_ctx->dst_sgl) +
 			(*dst_last_bytes - authsize);
 	}
 }
@@ -948,13 +948,13 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*INPLACE*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 						     areq_ctx->src.nents,
-						     areq_ctx->srcSgl,
+						     areq_ctx->src_sgl,
 						     areq_ctx->cryptlen,
-						     areq_ctx->srcOffset,
+						     areq_ctx->src_offset,
 						     is_last_table,
 						     &areq_ctx->src.mlli_nents);
 
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->src_sgl,
 							      areq_ctx->src.nents,
 							      authsize,
 							      *src_last_bytes,
@@ -996,10 +996,10 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
 			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
 				(*src_last_bytes - authsize);
 			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
 				(*src_last_bytes - authsize);
 		}
 
@@ -1007,20 +1007,20 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*NON-INPLACE and DECRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 						     areq_ctx->src.nents,
-						     areq_ctx->srcSgl,
+						     areq_ctx->src_sgl,
 						     areq_ctx->cryptlen,
-						     areq_ctx->srcOffset,
+						     areq_ctx->src_offset,
 						     is_last_table,
 						     &areq_ctx->src.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 						     areq_ctx->dst.nents,
-						     areq_ctx->dstSgl,
+						     areq_ctx->dst_sgl,
 						     areq_ctx->cryptlen,
-						     areq_ctx->dstOffset,
+						     areq_ctx->dst_offset,
 						     is_last_table,
 						     &areq_ctx->dst.mlli_nents);
 
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->src_sgl,
 							      areq_ctx->src.nents,
 							      authsize,
 							      *src_last_bytes,
@@ -1048,10 +1048,10 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
 			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
 				(*src_last_bytes - authsize);
 			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->srcSgl[areq_ctx->src.nents - 1]) +
+				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
 				(*src_last_bytes - authsize);
 		}
 
@@ -1059,20 +1059,20 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*NON-INPLACE and ENCRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 						     areq_ctx->dst.nents,
-						     areq_ctx->dstSgl,
+						     areq_ctx->dst_sgl,
 						     areq_ctx->cryptlen,
-						     areq_ctx->dstOffset,
+						     areq_ctx->dst_offset,
 						     is_last_table,
 						     &areq_ctx->dst.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 						     areq_ctx->src.nents,
-						     areq_ctx->srcSgl,
+						     areq_ctx->src_sgl,
 						     areq_ctx->cryptlen,
-						     areq_ctx->srcOffset,
+						     areq_ctx->src_offset,
 						     is_last_table,
 						     &areq_ctx->src.mlli_nents);
 
-		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->dstSgl,
+		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->dst_sgl,
 							      areq_ctx->dst.nents,
 							      authsize,
 							      *dst_last_bytes,
@@ -1085,10 +1085,10 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		if (likely(!areq_ctx->is_icv_fragmented)) {
 			/* Contig. ICV */
 			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->dstSgl[areq_ctx->dst.nents - 1]) +
+				&areq_ctx->dst_sgl[areq_ctx->dst.nents - 1]) +
 				(*dst_last_bytes - authsize);
 			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->dstSgl[areq_ctx->dst.nents - 1]) +
+				&areq_ctx->dst_sgl[areq_ctx->dst.nents - 1]) +
 				(*dst_last_bytes - authsize);
 		} else {
 			areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
@@ -1130,25 +1130,25 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		rc = -EINVAL;
 		goto chain_data_exit;
 	}
-	areq_ctx->srcSgl = req->src;
-	areq_ctx->dstSgl = req->dst;
+	areq_ctx->src_sgl = req->src;
+	areq_ctx->dst_sgl = req->dst;
 
 	if (is_gcm4543)
 		size_for_map += crypto_aead_ivsize(tfm);
 
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
 	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->src, size_for_map, &src_last_bytes, &chained);
-	sg_index = areq_ctx->srcSgl->length;
+	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
-		offset -= areq_ctx->srcSgl->length;
-		areq_ctx->srcSgl = sg_next(areq_ctx->srcSgl);
+		offset -= areq_ctx->src_sgl->length;
+		areq_ctx->src_sgl = sg_next(areq_ctx->src_sgl);
 		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->srcSgl) {
+		if (!areq_ctx->src_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
-		sg_index += areq_ctx->srcSgl->length;
+		sg_index += areq_ctx->src_sgl->length;
 		src_mapped_nents--;
 	}
 	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
@@ -1159,7 +1159,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 
 	areq_ctx->src.nents = src_mapped_nents;
 
-	areq_ctx->srcOffset = offset;
+	areq_ctx->src_offset = offset;
 
 	if (req->src != req->dst) {
 		size_for_map = req->assoclen + req->cryptlen;
@@ -1180,19 +1180,19 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	}
 
 	dst_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->dst, size_for_map, &dst_last_bytes, &chained);
-	sg_index = areq_ctx->dstSgl->length;
+	sg_index = areq_ctx->dst_sgl->length;
 	offset = size_to_skip;
 
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
-		offset -= areq_ctx->dstSgl->length;
-		areq_ctx->dstSgl = sg_next(areq_ctx->dstSgl);
+		offset -= areq_ctx->dst_sgl->length;
+		areq_ctx->dst_sgl = sg_next(areq_ctx->dst_sgl);
 		//if have reached the end of the sgl, then this is unexpected
-		if (!areq_ctx->dstSgl) {
+		if (!areq_ctx->dst_sgl) {
 			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
-		sg_index += areq_ctx->dstSgl->length;
+		sg_index += areq_ctx->dst_sgl->length;
 		dst_mapped_nents--;
 	}
 	if (unlikely(dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
@@ -1201,7 +1201,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		return -ENOMEM;
 	}
 	areq_ctx->dst.nents = dst_mapped_nents;
-	areq_ctx->dstOffset = offset;
+	areq_ctx->dst_offset = offset;
 	if ((src_mapped_nents > 1) ||
 	    (dst_mapped_nents  > 1) ||
 	    do_chain) {
-- 
2.1.4
