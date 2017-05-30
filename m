From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 21/27] Drivers: ccree: ssi_buffer_mgr.c - align block
 comments
Date: Tue, 30 May 2017 18:15:40 +1200
Message-ID: <20170530061540.13952-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 87 +++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 04515e70d2d3..edb88441e90d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -330,7 +330,8 @@ static int ssi_buffer_mgr_generate_mlli(
 		/* set last bit in the current table */
 		if (sg_data->mlli_nents[i] != NULL) {
 			/*Calculate the current MLLI table length for the
-			length field in the descriptor*/
+			 *length field in the descriptor
+			 */
 			*(sg_data->mlli_nents[i]) +=
 				(total_nents - prev_total_nents);
 			prev_total_nents = total_nents;
@@ -463,7 +464,8 @@ static int ssi_buffer_mgr_map_scatterlist(
 		}
 		if (!is_chained) {
 			/* In case of mmu the number of mapped nents might
-			be changed from the original sgl nents */
+			 * be changed from the original sgl nents
+			 */
 			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
 			if (unlikely(*mapped_nents == 0)){
 				*nents = 0;
@@ -472,7 +474,8 @@ static int ssi_buffer_mgr_map_scatterlist(
 			}
 		} else {
 			/*In this case the driver maps entry by entry so it
-			must have the same nents before and after map */
+			 * must have the same nents before and after map
+			 */
 			*mapped_nents = ssi_buffer_mgr_dma_map_sg(dev,
 								 sg,
 								 *nents,
@@ -764,7 +767,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 	}
 
 	/*In case a pool was set, a table was
-	  allocated and should be released */
+	 *allocated and should be released
+	 */
 	if (areq_ctx->mlli_params.curr_pool != NULL) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%08llX virt=%pK\n",
 			(unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
@@ -801,7 +805,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 			size_to_skip += crypto_aead_ivsize(tfm);
 		}
 		/* copy mac to a temporary location to deal with possible
-		  data memory overriding that caused by cache coherence problem. */
+		 * data memory overriding that caused by cache coherence problem.
+		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
 			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
@@ -965,7 +970,8 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	areq_ctx->assoc.nents = mapped_nents;
 
 	/* in CCM case we have additional entry for
-	*  ccm header configurations */
+	 * ccm header configurations
+	 */
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
 		if (unlikely((mapped_nents + 1) >
 			LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)) {
@@ -1068,13 +1074,15 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
 			/* Backup happens only when ICV is fragmented, ICV
-			   verification is made by CPU compare in order to simplify
-			   MAC verification upon request completion */
+			 * verification is made by CPU compare in order to simplify
+			 * MAC verification upon request completion
+			 */
 			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 #if !DX_HAS_ACP
 				/* In ACP platform we already copying ICV
-				   for any INPLACE-DECRYPT operation, hence
-				   we must neglect this code. */
+				 * for any INPLACE-DECRYPT operation, hence
+				 * we must neglect this code.
+				 */
 				u32 size_to_skip = req->assoclen;
 				if (areq_ctx->is_gcm4543) {
 					size_to_skip += crypto_aead_ivsize(tfm);
@@ -1120,8 +1128,9 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 		if (unlikely(areq_ctx->is_icv_fragmented == true)) {
 			/* Backup happens only when ICV is fragmented, ICV
-			   verification is made by CPU compare in order to simplify
-			   MAC verification upon request completion */
+			 * verification is made by CPU compare in order to simplify
+			 * MAC verification upon request completion
+			 */
 			  u32 size_to_skip = req->assoclen;
 			  if (areq_ctx->is_gcm4543) {
 				  size_to_skip += crypto_aead_ivsize(tfm);
@@ -1378,7 +1387,8 @@ int ssi_buffer_mgr_map_aead_request(
 			size_to_skip += crypto_aead_ivsize(tfm);
 		}
 		/* copy mac to a temporary location to deal with possible
-		   data memory overriding that caused by cache coherence problem. */
+		 * data memory overriding that caused by cache coherence problem.
+		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
 			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
@@ -1494,11 +1504,11 @@ int ssi_buffer_mgr_map_aead_request(
 
 	if (likely(areq_ctx->is_single_pass == true)) {
 		/*
-		* Create MLLI table for:
-		*   (1) Assoc. data
-		*   (2) Src/Dst SGLs
-		*   Note: IV is contg. buffer (not an SGL)
-		*/
+		 * Create MLLI table for:
+		 *   (1) Assoc. data
+		 *   (2) Src/Dst SGLs
+		 *   Note: IV is contg. buffer (not an SGL)
+		 */
 		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, true, false);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
@@ -1510,25 +1520,25 @@ int ssi_buffer_mgr_map_aead_request(
 			goto aead_map_failure;
 	} else { /* DOUBLE-PASS flow */
 		/*
-		* Prepare MLLI table(s) in this order:
-		*
-		* If ENCRYPT/DECRYPT (inplace):
-		*   (1) MLLI table for assoc
-		*   (2) IV entry (chained right after end of assoc)
-		*   (3) MLLI for src/dst (inplace operation)
-		*
-		* If ENCRYPT (non-inplace)
-		*   (1) MLLI table for assoc
-		*   (2) IV entry (chained right after end of assoc)
-		*   (3) MLLI for dst
-		*   (4) MLLI for src
-		*
-		* If DECRYPT (non-inplace)
-		*   (1) MLLI table for assoc
-		*   (2) IV entry (chained right after end of assoc)
-		*   (3) MLLI for src
-		*   (4) MLLI for dst
-		*/
+		 * Prepare MLLI table(s) in this order:
+		 *
+		 * If ENCRYPT/DECRYPT (inplace):
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for src/dst (inplace operation)
+		 *
+		 * If ENCRYPT (non-inplace)
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for dst
+		 *   (4) MLLI for src
+		 *
+		 * If DECRYPT (non-inplace)
+		 *   (1) MLLI table for assoc
+		 *   (2) IV entry (chained right after end of assoc)
+		 *   (3) MLLI for src
+		 *   (4) MLLI for dst
+		 */
 		rc = ssi_buffer_mgr_aead_chain_assoc(drvdata, req, &sg_data, false, true);
 		if (unlikely(rc != 0))
 			goto aead_map_failure;
@@ -1793,7 +1803,8 @@ void ssi_buffer_mgr_unmap_hash_request(
 						&areq_ctx->buff1_cnt;
 
 	/*In case a pool was set, a table was
-	  allocated and should be released */
+	 *allocated and should be released
+	 */
 	if (areq_ctx->mlli_params.curr_pool != NULL) {
 		SSI_LOG_DEBUG("free MLLI buffer: dma=0x%llX virt=%pK\n",
 			     (unsigned long long)areq_ctx->mlli_params.mlli_dma_addr,
-- 
2.13.0
