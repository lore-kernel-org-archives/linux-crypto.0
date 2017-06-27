From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/14] staging: ccree: fix missing or redundant spaces
Date: Tue, 27 Jun 2017 10:27:13 +0300
Message-ID: <1498548449-10803-2-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
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

Add and/or remove redundant and/or missing spaces in ccree source

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig           |   2 +-
 drivers/staging/ccree/ssi_aead.c        |  38 ++++----
 drivers/staging/ccree/ssi_aead.h        |  12 +--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 158 ++++++++++++++++----------------
 drivers/staging/ccree/ssi_cipher.c      |  44 ++++-----
 drivers/staging/ccree/ssi_driver.c      |  18 ++--
 drivers/staging/ccree/ssi_driver.h      |   4 +-
 drivers/staging/ccree/ssi_fips_data.h   |  12 +--
 drivers/staging/ccree/ssi_fips_ll.c     |  12 +--
 drivers/staging/ccree/ssi_fips_local.c  |   8 +-
 drivers/staging/ccree/ssi_fips_local.h  |  18 ++--
 drivers/staging/ccree/ssi_hash.c        |  38 ++++----
 drivers/staging/ccree/ssi_pm.c          |  16 ++--
 drivers/staging/ccree/ssi_pm.h          |   2 +-
 drivers/staging/ccree/ssi_request_mgr.c |  62 ++++++-------
 drivers/staging/ccree/ssi_request_mgr.h |   6 +-
 drivers/staging/ccree/ssi_sysfs.c       |  56 +++++------
 17 files changed, 253 insertions(+), 253 deletions(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index ec3749d..36a87c6 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -18,7 +18,7 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_CTR
 	select CRYPTO_XTS
 	help
-	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell 
+	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell
 	  C7xx. Currently only the CryptoCell 712 REE is supported.
 	  Choose this if you wish to use hardware acceleration of
 	  cryptographic operations on the system REE.
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index c70e450..2e8dc3f 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -238,8 +238,8 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 	} else { /*ENCRYPT*/
 		if (unlikely(areq_ctx->is_icv_fragmented == true))
 			ssi_buffer_mgr_copy_scatterlist_portion(
-				areq_ctx->mac_buf, areq_ctx->dstSgl, areq->cryptlen+areq_ctx->dstOffset,
-				areq->cryptlen+areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
+				areq_ctx->mac_buf, areq_ctx->dstSgl, areq->cryptlen + areq_ctx->dstOffset,
+				areq->cryptlen + areq_ctx->dstOffset + ctx->authsize, SSI_SG_FROM_BUF);
 
 		/* If an IV was generated, copy it back to the user provided buffer. */
 		if (areq_ctx->backup_giv != NULL) {
@@ -1561,7 +1561,7 @@ static int config_ccm_adata(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	int rc;
 	memset(req_ctx->mac_buf, 0, AES_BLOCK_SIZE);
-	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE*3);
+	memset(req_ctx->ccm_config, 0, AES_BLOCK_SIZE * 3);
 
 	/* taken from crypto/ccm.c */
 	/* 2 <= L <= 8, so 1 <= L' <= 7. */
@@ -1585,12 +1585,12 @@ static int config_ccm_adata(struct aead_request *req)
 	 /* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
-	req_ctx->ccm_hdr_size = format_ccm_a0 (a0, req->assoclen);
+	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
 
 	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
 	req->iv[15] = 1;
 
-	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE) ;
+	memcpy(ctr_count_0, req->iv, AES_BLOCK_SIZE);
 	ctr_count_0[15] = 0;
 
 	return 0;
@@ -1858,7 +1858,7 @@ static inline void ssi_aead_dump_gcm(
 		SSI_LOG_DEBUG("%s\n", title);
 	}
 
-	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d \n", \
+	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n", \
 				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
 
 	if (ctx->enckey != NULL) {
@@ -1878,12 +1878,12 @@ static inline void ssi_aead_dump_gcm(
 	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.lenA, AES_BLOCK_SIZE);
 
 	if (req->src != NULL && req->cryptlen) {
-		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen+req->assoclen);
+		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
 	}
 
 	if (req->dst != NULL) {
-		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen+ctx->authsize+req->assoclen);
-    }
+		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen + ctx->authsize + req->assoclen);
+	}
 }
 #endif
 
@@ -1899,7 +1899,7 @@ static int config_gcm_context(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d \n", cryptlen, req->assoclen, ctx->authsize);
+	SSI_LOG_DEBUG("config_gcm_context() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n", cryptlen, req->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -1916,15 +1916,15 @@ static int config_gcm_context(struct aead_request *req)
 	if (req_ctx->plaintext_authenticate_only == false) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
-		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
+		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
-		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
+		memcpy(&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
-		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
-		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
+		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
+		memcpy(&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = 0;
-		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
+		memcpy(&req_ctx->gcm_len_block.lenC, &temp64, 8);
 	}
 
 	return 0;
@@ -2220,7 +2220,7 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p \n", keylen, key);
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setkey()  keylen %d, key %p\n", keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2238,7 +2238,7 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int rc = 0;
 
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p \n", keylen, key);
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setkey()  keylen %d, key %p\n", keylen, key);
 
 	if (keylen < 4)
 		return -EINVAL;
@@ -2273,7 +2273,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 				      unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d \n", authsize);
+	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d\n", authsize);
 
 	switch (authsize) {
 	case 8:
@@ -2290,7 +2290,7 @@ static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
 				       unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d \n", authsize);
+	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d\n", authsize);
 
 	if (authsize != 16)
 		return -EINVAL;
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 00a3680..07cab84 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -28,17 +28,17 @@
 
 /* mac_cmp - HW writes 8 B but all bytes hold the same value */
 #define ICV_CMP_SIZE 8
-#define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE*3)
+#define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE * 3)
 #define MAX_MAC_SIZE MAX(SHA256_DIGEST_SIZE, AES_BLOCK_SIZE)
 
 
 /* defines for AES GCM configuration buffer */
 #define GCM_BLOCK_LEN_SIZE 8
 
-#define GCM_BLOCK_RFC4_IV_OFFSET    	4
-#define GCM_BLOCK_RFC4_IV_SIZE  	    8  /* IV size for rfc's */
-#define GCM_BLOCK_RFC4_NONCE_OFFSET 	0
-#define GCM_BLOCK_RFC4_NONCE_SIZE   	4
+#define GCM_BLOCK_RFC4_IV_OFFSET	4
+#define GCM_BLOCK_RFC4_IV_SIZE		8  /* IV size for rfc's */
+#define GCM_BLOCK_RFC4_NONCE_OFFSET	0
+#define GCM_BLOCK_RFC4_NONCE_SIZE	4
 
 
 
@@ -74,7 +74,7 @@ struct aead_req_ctx {
 	u8 hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
 	struct {
 		u8 lenA[GCM_BLOCK_LEN_SIZE] ____cacheline_aligned;
-		u8 lenC[GCM_BLOCK_LEN_SIZE] ;
+		u8 lenC[GCM_BLOCK_LEN_SIZE];
 	} gcm_len_block;
 
 	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 4373d1d..00d95c1 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -83,14 +83,14 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 	while (nbytes != 0) {
 		if (sg_is_chain(sg_list)) {
 			SSI_LOG_ERR("Unexpected chained entry "
-				   "in sg (entry =0x%X) \n", nents);
+				   "in sg (entry =0x%X)\n", nents);
 			BUG();
 		}
 		if (sg_list->length != 0) {
 			nents++;
 			/* get the number of bytes in the last entry */
 			*lbytes = nbytes;
-			nbytes -= ( sg_list->length > nbytes ) ? nbytes : sg_list->length;
+			nbytes -= (sg_list->length > nbytes) ? nbytes : sg_list->length;
 			sg_list = sg_next(sg_list);
 		} else {
 			sg_list = (struct scatterlist *)sg_page(sg_list);
@@ -99,7 +99,7 @@ static unsigned int ssi_buffer_mgr_get_sgl_nents(
 			}
 		}
 	}
-	SSI_LOG_DEBUG("nents %d last bytes %d\n",nents, *lbytes);
+	SSI_LOG_DEBUG("nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
 }
 
@@ -154,16 +154,16 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	u32 new_nents;;
 
 	/* Verify there is no memory overflow*/
-	new_nents = (*curr_nents + buff_size/CC_MAX_MLLI_ENTRY_SIZE + 1);
-	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES ) {
+	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES) {
 		return -ENOMEM;
 	}
 
 	/*handle buffer longer than 64 kbytes */
-	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE ) {
+	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
 		cc_lli_set_addr(mlli_entry_p, buff_dma);
 		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
-		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
+		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n", *curr_nents,
 			   mlli_entry_p[LLI_WORD0_OFFSET],
 			   mlli_entry_p[LLI_WORD1_OFFSET]);
 		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
@@ -174,7 +174,7 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	/*Last entry */
 	cc_lli_set_addr(mlli_entry_p, buff_dma);
 	cc_lli_set_size(mlli_entry_p, buff_size);
-	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
+	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n", *curr_nents,
 		   mlli_entry_p[LLI_WORD0_OFFSET],
 		   mlli_entry_p[LLI_WORD1_OFFSET]);
 	mlli_entry_p = mlli_entry_p + 2;
@@ -196,15 +196,15 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 	      curr_sgl = sg_next(curr_sgl)) {
 		u32 entry_data_len =
 			(sgl_data_len > sg_dma_len(curr_sgl) - sglOffset) ?
-				sg_dma_len(curr_sgl) - sglOffset : sgl_data_len ;
+				sg_dma_len(curr_sgl) - sglOffset : sgl_data_len;
 		sgl_data_len -= entry_data_len;
 		rc = ssi_buffer_mgr_render_buff_to_mlli(
 			sg_dma_address(curr_sgl) + sglOffset, entry_data_len, curr_nents,
 			&mlli_entry_p);
-		if(rc != 0) {
+		if (rc != 0) {
 			return rc;
 		}
-		sglOffset=0;
+		sglOffset = 0;
 	}
 	*mlli_entry_pp = mlli_entry_p;
 	return 0;
@@ -216,7 +216,7 @@ static int ssi_buffer_mgr_generate_mlli(
 	struct mlli_params *mlli_params)
 {
 	u32 *mlli_p;
-	u32 total_nents = 0,prev_total_nents = 0;
+	u32 total_nents = 0, prev_total_nents = 0;
 	int rc = 0, i;
 
 	SSI_LOG_DEBUG("NUM of SG's = %d\n", sg_data->num_of_buffers);
@@ -227,7 +227,7 @@ static int ssi_buffer_mgr_generate_mlli(
 			&(mlli_params->mlli_dma_addr));
 	if (unlikely(mlli_params->mlli_virt_addr == NULL)) {
 		SSI_LOG_ERR("dma_pool_alloc() failed\n");
-		rc =-ENOMEM;
+		rc = -ENOMEM;
 		goto build_mlli_exit;
 	}
 	/* Point to start of MLLI */
@@ -244,7 +244,7 @@ static int ssi_buffer_mgr_generate_mlli(
 				sg_data->entry[i].buffer_dma,
 				sg_data->total_data_len[i], &total_nents,
 				&mlli_p);
-		if(rc != 0) {
+		if (rc != 0) {
 			return rc;
 		}
 
@@ -323,13 +323,13 @@ static int
 ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 			 enum dma_data_direction direction)
 {
-	u32 i , j;
+	u32 i, j;
 	struct scatterlist *l_sg = sg;
 	for (i = 0; i < nents; i++) {
 		if (l_sg == NULL) {
 			break;
 		}
-		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)){
+		if (unlikely(dma_map_sg(dev, l_sg, 1, direction) != 1)) {
 			SSI_LOG_ERR("dma_map_page() sg buffer failed\n");
 			goto err;
 		}
@@ -343,7 +343,7 @@ ssi_buffer_mgr_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
 		if (sg == NULL) {
 			break;
 		}
-		dma_unmap_sg(dev,sg,1,direction);
+		dma_unmap_sg(dev, sg, 1, direction);
 		sg = sg_next(sg);
 	}
 	return 0;
@@ -387,7 +387,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 			 * be changed from the original sgl nents
 			 */
 			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-			if (unlikely(*mapped_nents == 0)){
+			if (unlikely(*mapped_nents == 0)) {
 				*nents = 0;
 				SSI_LOG_ERR("dma_map_sg() sg buffer failed\n");
 				return -ENOMEM;
@@ -400,7 +400,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 								 sg,
 								 *nents,
 								 direction);
-			if (unlikely(*mapped_nents != *nents)){
+			if (unlikely(*mapped_nents != *nents)) {
 				*nents = *mapped_nents;
 				SSI_LOG_ERR("dma_map_sg() sg buffer failed\n");
 				return -ENOMEM;
@@ -418,7 +418,7 @@ ssi_aead_handle_config_buf(struct device *dev,
 	struct buffer_array *sg_data,
 	unsigned int assoclen)
 {
-	SSI_LOG_DEBUG(" handle additional data config set to   DLLI \n");
+	SSI_LOG_DEBUG(" handle additional data config set to   DLLI\n");
 	/* create sg for the current buffer */
 	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
 	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
@@ -453,9 +453,9 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 					   u32 curr_buff_cnt,
 					   struct buffer_array *sg_data)
 {
-	SSI_LOG_DEBUG(" handle curr buff %x set to   DLLI \n", curr_buff_cnt);
+	SSI_LOG_DEBUG(" handle curr buff %x set to   DLLI\n", curr_buff_cnt);
 	/* create sg for the current buffer */
-	sg_init_one(areq_ctx->buff_sg,curr_buff, curr_buff_cnt);
+	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
 	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
 			SSI_LOG_ERR("dma_map_sg() "
@@ -540,12 +540,12 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	sg_data.num_of_buffers = 0;
 
 	/* Map IV buffer */
-	if (likely(ivsize != 0) ) {
+	if (likely(ivsize != 0)) {
 		dump_byte_array("iv", (u8 *)info, ivsize);
 		req_ctx->gen_ctx.iv_dma_addr =
 			dma_map_single(dev, (void *)info,
 				       ivsize,
-				       req_ctx->is_giv ? DMA_BIDIRECTIONAL:
+				       req_ctx->is_giv ? DMA_BIDIRECTIONAL :
 				       DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev,
 					req_ctx->gen_ctx.iv_dma_addr))) {
@@ -581,7 +581,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	} else {
 		/* Map the dst sg */
 		if (unlikely(ssi_buffer_mgr_map_scatterlist(
-			dev,dst, nbytes,
+			dev, dst, nbytes,
 			DMA_BIDIRECTIONAL, &req_ctx->out_nents,
 			LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy,
 			&mapped_nents))){
@@ -606,7 +606,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
 	if (unlikely(req_ctx->dma_buf_type == SSI_DMA_BUF_MLLI)) {
 		mlli_params->curr_pool = buff_mgr->mlli_buffs_pool;
 		rc = ssi_buffer_mgr_generate_mlli(dev, &sg_data, mlli_params);
-		if (unlikely(rc!= 0))
+		if (unlikely(rc != 0))
 			goto ablkcipher_exit;
 
 	}
@@ -686,19 +686,19 @@ void ssi_buffer_mgr_unmap_aead_request(
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	SSI_LOG_DEBUG("Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n", sg_virt(req->src),areq_ctx->src.nents,areq_ctx->assoc.nents,req->assoclen,req->cryptlen);
-	size_to_unmap = req->assoclen+req->cryptlen;
-	if(areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT){
+	SSI_LOG_DEBUG("Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n", sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents, req->assoclen, req->cryptlen);
+	size_to_unmap = req->assoclen + req->cryptlen;
+	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		size_to_unmap += areq_ctx->req_authsize;
 	}
 	if (areq_ctx->is_gcm4543)
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
-	dma_unmap_sg(dev, req->src, ssi_buffer_mgr_get_sgl_nents(req->src,size_to_unmap,&dummy,&chained) , DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, ssi_buffer_mgr_get_sgl_nents(req->src, size_to_unmap, &dummy, &chained), DMA_BIDIRECTIONAL);
 	if (unlikely(req->src != req->dst)) {
 		SSI_LOG_DEBUG("Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst,size_to_unmap,&dummy,&chained),
+		dma_unmap_sg(dev, req->dst, ssi_buffer_mgr_get_sgl_nents(req->dst, size_to_unmap, &dummy, &chained),
 			DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -714,8 +714,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
-			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
-			size_to_skip+ req->cryptlen, SSI_SG_FROM_BUF);
+			size_to_skip + req->cryptlen - areq_ctx->req_authsize,
+			size_to_skip + req->cryptlen, SSI_SG_FROM_BUF);
 	}
 }
 
@@ -736,7 +736,7 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 		return 0;
 	}
 
-	for( i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
+	for (i = 0 ; i < (sgl_nents - MAX_ICV_NENTS_SUPPORTED) ; i++) {
 		if (sgl == NULL) {
 			break;
 		}
@@ -798,7 +798,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
 		hw_iv_size, req->iv,
 		(unsigned long long)areq_ctx->gen_ctx.iv_dma_addr);
-	if (do_chain == true && areq_ctx->plaintext_authenticate_only == true){  // TODO: what about CTR?? ask Ron
+	if (do_chain == true && areq_ctx->plaintext_authenticate_only == true) {  // TODO: what about CTR?? ask Ron
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
 		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
@@ -858,7 +858,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 			current_sg = sg_next(current_sg);
 			//if have reached the end of the sgl, then this is unexpected
 			if (current_sg == NULL) {
-				SSI_LOG_ERR("reached end of sg list. unexpected \n");
+				SSI_LOG_ERR("reached end of sg list. unexpected\n");
 				BUG();
 			}
 			sg_index += current_sg->length;
@@ -923,7 +923,7 @@ static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
 	if (likely(req->src == req->dst)) {
 		/*INPLACE*/
 		areq_ctx->icv_dma_addr = sg_dma_address(
-			areq_ctx->srcSgl)+
+			areq_ctx->srcSgl) +
 			(*src_last_bytes - authsize);
 		areq_ctx->icv_virt_addr = sg_virt(
 			areq_ctx->srcSgl) +
@@ -942,7 +942,7 @@ static inline void ssi_buffer_mgr_prepare_aead_data_dlli(
 			areq_ctx->dstSgl) +
 			(*dst_last_bytes - authsize);
 		areq_ctx->icv_virt_addr = sg_virt(
-			areq_ctx->dstSgl)+
+			areq_ctx->dstSgl) +
 			(*dst_last_bytes - authsize);
 	}
 }
@@ -964,7 +964,7 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*INPLACE*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen,areq_ctx->srcOffset, is_last_table,
+			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
 			&areq_ctx->src.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
@@ -1018,11 +1018,11 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*NON-INPLACE and DECRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen, areq_ctx->srcOffset,is_last_table,
+			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
 			&areq_ctx->src.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 			areq_ctx->dst.nents, areq_ctx->dstSgl,
-			areq_ctx->cryptlen,areq_ctx->dstOffset, is_last_table,
+			areq_ctx->cryptlen, areq_ctx->dstOffset, is_last_table,
 			&areq_ctx->dst.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->srcSgl,
@@ -1044,8 +1044,8 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 			  }
 			  ssi_buffer_mgr_copy_scatterlist_portion(
 				  areq_ctx->backup_mac, req->src,
-				  size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
-				  size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
+				  size_to_skip + req->cryptlen - areq_ctx->req_authsize,
+				  size_to_skip + req->cryptlen, SSI_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
@@ -1061,11 +1061,11 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 		/*NON-INPLACE and ENCRYPT*/
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 			areq_ctx->dst.nents, areq_ctx->dstSgl,
-			areq_ctx->cryptlen,areq_ctx->dstOffset, is_last_table,
+			areq_ctx->cryptlen, areq_ctx->dstOffset, is_last_table,
 			&areq_ctx->dst.mlli_nents);
 		ssi_buffer_mgr_add_scatterlist_entry(sg_data,
 			areq_ctx->src.nents, areq_ctx->srcSgl,
-			areq_ctx->cryptlen, areq_ctx->srcOffset,is_last_table,
+			areq_ctx->cryptlen, areq_ctx->srcOffset, is_last_table,
 			&areq_ctx->src.mlli_nents);
 
 		icv_nents = ssi_buffer_mgr_get_aead_icv_nents(areq_ctx->dstSgl,
@@ -1108,7 +1108,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	int rc = 0;
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
-	unsigned int size_for_map = req->assoclen +req->cryptlen; /*non-inplace mode*/
+	unsigned int size_for_map = req->assoclen + req->cryptlen; /*non-inplace mode*/
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
 	bool chained = false;
@@ -1130,8 +1130,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		size_for_map += crypto_aead_ivsize(tfm);
 	}
 
-	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize:0;
-	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->src,size_for_map,&src_last_bytes, &chained);
+	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
+	src_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->src, size_for_map, &src_last_bytes, &chained);
 	sg_index = areq_ctx->srcSgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
@@ -1139,7 +1139,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		areq_ctx->srcSgl = sg_next(areq_ctx->srcSgl);
 		//if have reached the end of the sgl, then this is unexpected
 		if (areq_ctx->srcSgl == NULL) {
-			SSI_LOG_ERR("reached end of sg list. unexpected \n");
+			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
 		sg_index += areq_ctx->srcSgl->length;
@@ -1157,7 +1157,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	areq_ctx->srcOffset = offset;
 
 	if (req->src != req->dst) {
-		size_for_map = req->assoclen +req->cryptlen;
+		size_for_map = req->assoclen + req->cryptlen;
 		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
 		if (is_gcm4543) {
 			size_for_map += crypto_aead_ivsize(tfm);
@@ -1173,7 +1173,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		}
 	}
 
-	dst_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->dst,size_for_map,&dst_last_bytes, &chained);
+	dst_mapped_nents = ssi_buffer_mgr_get_sgl_nents(req->dst, size_for_map, &dst_last_bytes, &chained);
 	sg_index = areq_ctx->dstSgl->length;
 	offset = size_to_skip;
 
@@ -1184,7 +1184,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		areq_ctx->dstSgl = sg_next(areq_ctx->dstSgl);
 		//if have reached the end of the sgl, then this is unexpected
 		if (areq_ctx->dstSgl == NULL) {
-			SSI_LOG_ERR("reached end of sg list. unexpected \n");
+			SSI_LOG_ERR("reached end of sg list. unexpected\n");
 			BUG();
 		}
 		sg_index += areq_ctx->dstSgl->length;
@@ -1214,7 +1214,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	return rc;
 }
 
-static void ssi_buffer_mgr_update_aead_mlli_nents( struct ssi_drvdata *drvdata,
+static void ssi_buffer_mgr_update_aead_mlli_nents(struct ssi_drvdata *drvdata,
 					   struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
@@ -1298,8 +1298,8 @@ int ssi_buffer_mgr_map_aead_request(
 		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
-			size_to_skip+ req->cryptlen - areq_ctx->req_authsize,
-			size_to_skip+ req->cryptlen, SSI_SG_TO_BUF);
+			size_to_skip + req->cryptlen - areq_ctx->req_authsize,
+			size_to_skip + req->cryptlen, SSI_SG_TO_BUF);
 	}
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
@@ -1393,7 +1393,7 @@ int ssi_buffer_mgr_map_aead_request(
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = ssi_buffer_mgr_map_scatterlist(dev, req->src,
 					    size_to_map, DMA_BIDIRECTIONAL, &(areq_ctx->src.nents),
-					    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES+LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
+					    LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES + LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
 	if (unlikely(rc != 0)) {
 		rc = -ENOMEM;
 		goto aead_map_failure;
@@ -1459,9 +1459,9 @@ int ssi_buffer_mgr_map_aead_request(
 		}
 
 		ssi_buffer_mgr_update_aead_mlli_nents(drvdata, req);
-		SSI_LOG_DEBUG("assoc params mn %d\n",areq_ctx->assoc.mlli_nents);
-		SSI_LOG_DEBUG("src params mn %d\n",areq_ctx->src.mlli_nents);
-		SSI_LOG_DEBUG("dst params mn %d\n",areq_ctx->dst.mlli_nents);
+		SSI_LOG_DEBUG("assoc params mn %d\n", areq_ctx->assoc.mlli_nents);
+		SSI_LOG_DEBUG("src params mn %d\n", areq_ctx->src.mlli_nents);
+		SSI_LOG_DEBUG("dst params mn %d\n", areq_ctx->dst.mlli_nents);
 	}
 	return 0;
 
@@ -1503,7 +1503,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 
 	/*TODO: copy data in case that buffer is enough for operation */
 	/* map the previous buffer */
-	if (*curr_buff_cnt != 0 ) {
+	if (*curr_buff_cnt != 0) {
 		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
 					    *curr_buff_cnt, &sg_data) != 0) {
 			return -ENOMEM;
@@ -1511,7 +1511,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	}
 
 	if (src && (nbytes > 0) && do_update) {
-		if ( unlikely( ssi_buffer_mgr_map_scatterlist( dev,src,
+		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src,
 					  nbytes,
 					  DMA_TO_DEVICE,
 					  &areq_ctx->in_nents,
@@ -1519,9 +1519,9 @@ int ssi_buffer_mgr_map_hash_request_final(
 					  &dummy, &mapped_nents))){
 			goto unmap_curr_buff;
 		}
-		if ( src && (mapped_nents == 1)
-		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) ) {
-			memcpy(areq_ctx->buff_sg,src,
+		if (src && (mapped_nents == 1)
+		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL)) {
+			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = nbytes;
 			areq_ctx->curr_sg = areq_ctx->buff_sg;
@@ -1547,7 +1547,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 		}
 	}
 	/* change the buffer index for the unmap function */
-	areq_ctx->buff_index = (areq_ctx->buff_index^1);
+	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
 	SSI_LOG_DEBUG("areq_ctx->data_dma_buf_type = %s\n",
 		GET_DMA_BUFFER_TYPE(areq_ctx->data_dma_buf_type));
 	return 0;
@@ -1556,7 +1556,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0 ) {
+	if (*curr_buff_cnt != 0) {
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 	}
 	return -ENOMEM;
@@ -1586,7 +1586,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 
 	SSI_LOG_DEBUG(" update params : curr_buff=%pK "
 		     "curr_buff_cnt=0x%X nbytes=0x%X "
-		     "src=%pK curr_index=%u \n",
+		     "src=%pK curr_index=%u\n",
 		     curr_buff, *curr_buff_cnt, nbytes,
 		     src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
@@ -1623,12 +1623,12 @@ int ssi_buffer_mgr_map_hash_request_update(
 	/* Copy the new residue to next buffer */
 	if (*next_buff_cnt != 0) {
 		SSI_LOG_DEBUG(" handle residue: next buff %pK skip data %u"
-			     " residue %u \n", next_buff,
+			     " residue %u\n", next_buff,
 			     (update_data_len - *curr_buff_cnt),
 			     *next_buff_cnt);
 		ssi_buffer_mgr_copy_scatterlist_portion(next_buff, src,
-			     (update_data_len -*curr_buff_cnt),
-			     nbytes,SSI_SG_TO_BUF);
+			     (update_data_len - *curr_buff_cnt),
+			     nbytes, SSI_SG_TO_BUF);
 		/* change the buffer index for next operation */
 		swap_index = 1;
 	}
@@ -1642,19 +1642,19 @@ int ssi_buffer_mgr_map_hash_request_update(
 		swap_index = 1;
 	}
 
-	if ( update_data_len > *curr_buff_cnt ) {
-		if ( unlikely( ssi_buffer_mgr_map_scatterlist( dev,src,
-					  (update_data_len -*curr_buff_cnt),
+	if (update_data_len > *curr_buff_cnt) {
+		if (unlikely(ssi_buffer_mgr_map_scatterlist(dev, src,
+					  (update_data_len - *curr_buff_cnt),
 					  DMA_TO_DEVICE,
 					  &areq_ctx->in_nents,
 					  LLI_MAX_NUM_OF_DATA_ENTRIES,
 					  &dummy, &mapped_nents))){
 			goto unmap_curr_buff;
 		}
-		if ( (mapped_nents == 1)
-		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) ) {
+		if ((mapped_nents == 1)
+		     && (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL)) {
 			/* only one entry in the SG and no previous data */
-			memcpy(areq_ctx->buff_sg,src,
+			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = update_data_len;
 			areq_ctx->data_dma_buf_type = SSI_DMA_BUF_DLLI;
@@ -1678,7 +1678,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 		}
 
 	}
-	areq_ctx->buff_index = (areq_ctx->buff_index^swap_index);
+	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
 
 	return 0;
 
@@ -1686,7 +1686,7 @@ int ssi_buffer_mgr_map_hash_request_update(
 	dma_unmap_sg(dev, src, areq_ctx->in_nents, DMA_TO_DEVICE);
 
 unmap_curr_buff:
-	if (*curr_buff_cnt != 0 ) {
+	if (*curr_buff_cnt != 0) {
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 	}
 	return -ENOMEM;
@@ -1722,7 +1722,7 @@ void ssi_buffer_mgr_unmap_hash_request(
 
 	if (*prev_len != 0) {
 		SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK"
-			     "dma=0x%llX len 0x%X\n",
+			     " dma=0x%llX len 0x%X\n",
 				sg_virt(areq_ctx->buff_sg),
 				(unsigned long long)sg_dma_address(areq_ctx->buff_sg),
 				sg_dma_len(areq_ctx->buff_sg));
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 34450a5..519e04e 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -69,9 +69,9 @@ static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __io
 
 
 static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
-	switch (ctx_p->flow_mode){
+	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
-		switch (size){
+		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
 			if (likely((ctx_p->cipher_mode != DRV_CIPHER_XTS) &&
@@ -81,8 +81,8 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 			break;
 		case CC_AES_256_BIT_KEY_SIZE:
 			return 0;
-		case (CC_AES_192_BIT_KEY_SIZE*2):
-		case (CC_AES_256_BIT_KEY_SIZE*2):
+		case (CC_AES_192_BIT_KEY_SIZE * 2):
+		case (CC_AES_256_BIT_KEY_SIZE * 2):
 			if (likely((ctx_p->cipher_mode == DRV_CIPHER_XTS) ||
 				   (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) ||
 				   (ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)))
@@ -111,9 +111,9 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 
 
 static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size) {
-	switch (ctx_p->flow_mode){
+	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
-		switch (ctx_p->cipher_mode){
+		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
 			if ((size >= SSI_MIN_AES_XTS_SIZE) &&
 			    (size <= SSI_MAX_AES_XTS_SIZE) &&
@@ -198,7 +198,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
 	dev = &ctx_p->drvdata->plat_dev->dev;
 
 	/* Allocate key buffer, cache line aligned */
-	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL|GFP_DMA);
+	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
 	if (!ctx_p->user.key) {
 		SSI_LOG_ERR("Allocating key buffer in context failed\n");
 		rc = -ENOMEM;
@@ -257,11 +257,11 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 }
 
 
-typedef struct tdes_keys{
+typedef struct tdes_keys {
 	u8	key1[DES_KEY_SIZE];
 	u8	key2[DES_KEY_SIZE];
 	u8	key3[DES_KEY_SIZE];
-}tdes_keys_t;
+} tdes_keys_t;
 
 static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
@@ -275,8 +275,8 @@ static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 	tdes_keys_t *tdes_key = (tdes_keys_t*)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-	if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0) )) {
+	if (unlikely((memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
+		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
 		return -ENOEXEC;
 	}
 #endif /* CCREE_FIPS_SUPPORT */
@@ -336,11 +336,11 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 #if SSI_CC_HAS_MULTI2
 	/*last byte of key buffer is round number and should not be a part of key size*/
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
-		keylen -=1;
+		keylen -= 1;
 	}
 #endif /*SSI_CC_HAS_MULTI2*/
 
-	if (unlikely(validate_keys_sizes(ctx_p,keylen) != 0)) {
+	if (unlikely(validate_keys_sizes(ctx_p, keylen) != 0)) {
 		SSI_LOG_ERR("Unsupported key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
@@ -485,7 +485,7 @@ ssi_blkcipher_create_setup_desc(
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		if ((cipher_mode == DRV_CIPHER_CTR) ||
-		    (cipher_mode == DRV_CIPHER_OFB) ) {
+		    (cipher_mode == DRV_CIPHER_OFB)) {
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 		} else {
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
@@ -650,7 +650,7 @@ ssi_blkcipher_create_data_desc(
 		return;
 	}
 	/* Process */
-	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)){
+	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
 		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
 			     (unsigned long long)sg_dma_address(src),
 			     nbytes);
@@ -737,10 +737,10 @@ static int ssi_blkcipher_complete(struct device *dev,
 	/*Set the inflight couter value to local variable*/
 	inflight_counter =  ctx_p->drvdata->inflight_counter;
 	/*Decrease the inflight counter*/
-	if(ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
+	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
 		ctx_p->drvdata->inflight_counter--;
 
-	if(areq){
+	if (areq) {
 		ablkcipher_request_complete(areq, completion_error);
 		return 0;
 	}
@@ -761,10 +761,10 @@ static int ssi_blkcipher_process(
 	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
-	int rc, seq_len = 0,cts_restore_flag = 0;
+	int rc, seq_len = 0, cts_restore_flag = 0;
 
 	SSI_LOG_DEBUG("%s areq=%p info=%p nbytes=%d\n",
-		((direction==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
+		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Encrypt" : "Decrypt"),
 		     areq, info, nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
@@ -781,7 +781,7 @@ static int ssi_blkcipher_process(
 		return 0;
 	}
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)){
+	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
 
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
@@ -848,8 +848,8 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL)? 0:1);
-	if(areq != NULL) {
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL) ? 0 : 1);
+	if (areq != NULL) {
 		if (unlikely(rc != -EINPROGRESS)) {
 			/* Failed to send the request or request completed synchronously */
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 151afcf..7c94354 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -77,7 +77,7 @@
 #ifdef DX_DUMP_BYTES
 void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 {
-	int i , line_offset = 0, ret = 0;
+	int i, line_offset = 0, ret = 0;
 	const u8 *cur_byte;
 	char line_buf[80];
 
@@ -89,17 +89,17 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ",
 		name, size);
 	if (ret < 0) {
-		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n",ret);
+		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
 		return;
 	}
 	line_offset = ret;
-	for (i = 0 , cur_byte = the_array;
+	for (i = 0, cur_byte = the_array;
 	     (i < size) && (line_offset < sizeof(line_buf)); i++, cur_byte++) {
 			ret = snprintf(line_buf + line_offset,
 					sizeof(line_buf) - line_offset,
 					"0x%02X ", *cur_byte);
 		if (ret < 0) {
-			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n",ret);
+			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
 			return;
 		}
 		line_offset += ret;
@@ -301,9 +301,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc)
 		goto init_cc_res_err;
 
-	if(new_drvdata->plat_dev->dev.dma_mask == NULL)
+	if (new_drvdata->plat_dev->dev.dma_mask == NULL)
 	{
-		new_drvdata->plat_dev->dev.dma_mask = & new_drvdata->plat_dev->dev.coherent_dma_mask;
+		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
 	}
 	if (!new_drvdata->plat_dev->dev.coherent_dma_mask)
 	{
@@ -523,7 +523,7 @@ static int cc7x_probe(struct platform_device *plat_dev)
 	asm volatile("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
 	SSI_LOG_DEBUG("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X,"
 		     " Part 0x%03X, Rev r%dp%d\n",
-		(ctr>>24), (ctr>>16)&0xF, (ctr>>4)&0xFFF, (ctr>>20)&0xF, ctr&0xF);
+		(ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF, (ctr >> 20) & 0xF, ctr & 0xF);
 #endif
 
 	/* Map registers space */
@@ -546,13 +546,13 @@ static int cc7x_remove(struct platform_device *plat_dev)
 
 	return 0;
 }
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static struct dev_pm_ops arm_cc7x_driver_pm = {
 	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
 };
 #endif
 
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 #define	DX_DRIVER_RUNTIME_PM	(&arm_cc7x_driver_pm)
 #else
 #define	DX_DRIVER_RUNTIME_PM	NULL
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 1b8471b..c1ed61f 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -93,7 +93,7 @@
 
 /* Logging macros */
 #define SSI_LOG(level, format, ...) \
-	printk(level "cc715ree::%s: " format , __func__, ##__VA_ARGS__)
+	printk(level "cc715ree::%s: " format, __func__, ##__VA_ARGS__)
 #define SSI_LOG_ERR(format, ...) SSI_LOG(KERN_ERR, format, ##__VA_ARGS__)
 #define SSI_LOG_WARNING(format, ...) SSI_LOG(KERN_WARNING, format, ##__VA_ARGS__)
 #define SSI_LOG_NOTICE(format, ...) SSI_LOG(KERN_NOTICE, format, ##__VA_ARGS__)
@@ -107,7 +107,7 @@
 #define MIN(a, b) (((a) < (b)) ? (a) : (b))
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
 
-#define SSI_MAX_IVGEN_DMA_ADDRESSES 	3
+#define SSI_MAX_IVGEN_DMA_ADDRESSES	3
 struct ssi_crypto_req {
 	void (*user_cb)(struct device *dev, void *req, void __iomem *cc_base);
 	void *user_arg;
diff --git a/drivers/staging/ccree/ssi_fips_data.h b/drivers/staging/ccree/ssi_fips_data.h
index fa6bf41..27b2866 100644
--- a/drivers/staging/ccree/ssi_fips_data.h
+++ b/drivers/staging/ccree/ssi_fips_data.h
@@ -153,20 +153,20 @@
 #define NIST_TDES_VECTOR_SIZE           8
 #define NIST_TDES_IV_SIZE               8
 
-#define NIST_TDES_ECB_IV             	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
+#define NIST_TDES_ECB_IV		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
 
 #define NIST_TDES_ECB3_KEY		{ 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, \
 					  0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, \
 					  0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, 0x23 }
-#define NIST_TDES_ECB3_PLAIN_DATA    	{ 0x54, 0x68, 0x65, 0x20, 0x71, 0x75, 0x66, 0x63 }
-#define NIST_TDES_ECB3_CIPHER        	{ 0xa8, 0x26, 0xfd, 0x8c, 0xe5, 0x3b, 0x85, 0x5f }
+#define NIST_TDES_ECB3_PLAIN_DATA	{ 0x54, 0x68, 0x65, 0x20, 0x71, 0x75, 0x66, 0x63 }
+#define NIST_TDES_ECB3_CIPHER		{ 0xa8, 0x26, 0xfd, 0x8c, 0xe5, 0x3b, 0x85, 0x5f }
 
-#define NIST_TDES_CBC3_IV            	{ 0xf8, 0xee, 0xe1, 0x35, 0x9c, 0x6e, 0x54, 0x40 }
+#define NIST_TDES_CBC3_IV		{ 0xf8, 0xee, 0xe1, 0x35, 0x9c, 0x6e, 0x54, 0x40 }
 #define NIST_TDES_CBC3_KEY		{ 0xe9, 0xda, 0x37, 0xf8, 0xdc, 0x97, 0x6d, 0x5b, \
 					  0xb6, 0x8c, 0x04, 0xe3, 0xec, 0x98, 0x20, 0x15, \
 					  0xf4, 0x0e, 0x08, 0xb5, 0x97, 0x29, 0xf2, 0x8f }
-#define NIST_TDES_CBC3_PLAIN_DATA    	{ 0x3b, 0xb7, 0xa7, 0xdb, 0xa3, 0xd5, 0x92, 0x91 }
-#define NIST_TDES_CBC3_CIPHER        	{ 0x5b, 0x84, 0x24, 0xd2, 0x39, 0x3e, 0x55, 0xa2 }
+#define NIST_TDES_CBC3_PLAIN_DATA	{ 0x3b, 0xb7, 0xa7, 0xdb, 0xa3, 0xd5, 0x92, 0x91 }
+#define NIST_TDES_CBC3_CIPHER		{ 0x5b, 0x84, 0x24, 0xd2, 0x39, 0x3e, 0x55, 0xa2 }
 
 
 /* NIST AES-CCM */
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 6c79e7d..804384d 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -214,8 +214,8 @@ static const FipsCipherData FipsCipherDataTable[] = {
 	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_VECTOR_SIZE },
 	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_VECTOR_SIZE },
 #if (CC_SUPPORT_SHA > 256)
-	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_VECTOR_SIZE },
-	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_VECTOR_SIZE },
+	{ 1, NIST_AES_512_XTS_KEY, 2 * CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_VECTOR_SIZE },
+	{ 1, NIST_AES_512_XTS_KEY, 2 * CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_VECTOR_SIZE },
 #endif
 	/* DES */
 	{ 0, NIST_TDES_ECB3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_TDES_ECB3_PLAIN_DATA, NIST_TDES_ECB3_CIPHER, NIST_TDES_VECTOR_SIZE },
@@ -277,9 +277,9 @@ FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
 	switch (mode)
 	{
 	case DRV_CIPHER_ECB:
-		return is_aes ? CC_REE_FIPS_ERROR_AES_ECB_PUT : CC_REE_FIPS_ERROR_DES_ECB_PUT ;
+		return is_aes ? CC_REE_FIPS_ERROR_AES_ECB_PUT : CC_REE_FIPS_ERROR_DES_ECB_PUT;
 	case DRV_CIPHER_CBC:
-		return is_aes ? CC_REE_FIPS_ERROR_AES_CBC_PUT : CC_REE_FIPS_ERROR_DES_CBC_PUT ;
+		return is_aes ? CC_REE_FIPS_ERROR_AES_CBC_PUT : CC_REE_FIPS_ERROR_DES_CBC_PUT;
 	case DRV_CIPHER_OFB:
 		return CC_REE_FIPS_ERROR_AES_OFB_PUT;
 	case DRV_CIPHER_CTR:
@@ -332,7 +332,7 @@ ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 		set_flow_mode(&desc[idx], s_flow_mode);
 		set_cipher_mode(&desc[idx], cipher_mode);
 		if ((cipher_mode == DRV_CIPHER_CTR) ||
-		    (cipher_mode == DRV_CIPHER_OFB) ) {
+		    (cipher_mode == DRV_CIPHER_OFB)) {
 			set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 		} else {
 			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
@@ -432,7 +432,7 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 	{
 		FipsCipherData *cipherData = (FipsCipherData*)&FipsCipherDataTable[i];
 		int rc = 0;
-		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE ;
+		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE;
 
 		memset(cpu_addr_buffer, 0, sizeof(struct fips_cipher_ctx));
 
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index d6c994a..33a07e4 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -88,9 +88,9 @@ static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, ssi
 {
 	void __iomem *cc_base = drvdata->cc_base;
 	if (err == CC_REE_FIPS_ERROR_OK) {
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS|CC_FIPS_SYNC_MODULE_OK));
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_OK));
 	} else {
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS|CC_FIPS_SYNC_MODULE_ERROR));
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), (CC_FIPS_SYNC_REE_STATUS | CC_FIPS_SYNC_MODULE_ERROR));
 	}
 }
 
@@ -305,7 +305,7 @@ int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 
 	FIPS_DBG("CC FIPS code ..  (fips=%d) \n", ssi_fips_support);
 
-	fips_h = kzalloc(sizeof(struct ssi_fips_handle),GFP_KERNEL);
+	fips_h = kzalloc(sizeof(struct ssi_fips_handle), GFP_KERNEL);
 	if (fips_h == NULL) {
 		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
 		return -ENOMEM;
@@ -329,7 +329,7 @@ int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 #endif
 
 	/* init fips driver data */
-	rc = ssi_fips_set_state((ssi_fips_support == 0)? CC_FIPS_STATE_NOT_SUPPORTED : CC_FIPS_STATE_SUPPORTED);
+	rc = ssi_fips_set_state((ssi_fips_support == 0) ? CC_FIPS_STATE_NOT_SUPPORTED : CC_FIPS_STATE_SUPPORTED);
 	if (unlikely(rc != 0)) {
 		ssi_fips_set_error(p_drvdata, CC_REE_FIPS_ERROR_GENERAL);
 		rc = -EAGAIN;
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index ac1ab96..fa09084 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -24,24 +24,24 @@
 struct ssi_drvdata;
 
 // IG - how to make 1 file for TEE and REE
-typedef enum CC_FipsSyncStatus{
-	CC_FIPS_SYNC_MODULE_OK 		= 0x0,
-	CC_FIPS_SYNC_MODULE_ERROR 	= 0x1,
-	CC_FIPS_SYNC_REE_STATUS 	= 0x4,
-	CC_FIPS_SYNC_TEE_STATUS 	= 0x8,
-	CC_FIPS_SYNC_STATUS_RESERVE32B 	= S32_MAX
-}CCFipsSyncStatus_t;
+typedef enum CC_FipsSyncStatus {
+	CC_FIPS_SYNC_MODULE_OK		= 0x0,
+	CC_FIPS_SYNC_MODULE_ERROR	= 0x1,
+	CC_FIPS_SYNC_REE_STATUS		= 0x4,
+	CC_FIPS_SYNC_TEE_STATUS		= 0x8,
+	CC_FIPS_SYNC_STATUS_RESERVE32B	= S32_MAX
+} CCFipsSyncStatus_t;
 
 
 #define CHECK_AND_RETURN_UPON_FIPS_ERROR() {\
 	if (ssi_fips_check_fips_error() != 0) {\
 		return -ENOEXEC;\
-	}\
+	} \
 }
 #define CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR() {\
 	if (ssi_fips_check_fips_error() != 0) {\
 		return;\
-	}\
+	} \
 }
 #define SSI_FIPS_INIT(p_drvData)  (ssi_fips_init(p_drvData))
 #define SSI_FIPS_FINI(p_drvData)  (ssi_fips_fini(p_drvData))
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index bfe2bec..64e969e 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -111,7 +111,7 @@ struct ssi_hash_ctx {
 static void ssi_hash_create_data_desc(
 	struct ahash_req_ctx *areq_ctx,
 	struct ssi_hash_ctx *ctx,
-	unsigned int flow_mode,struct cc_hw_desc desc[],
+	unsigned int flow_mode, struct cc_hw_desc desc[],
 	bool is_not_last_data,
 	unsigned int *seq_size);
 
@@ -158,22 +158,22 @@ static int ssi_hash_map_request(struct device *dev,
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(SSI_MAX_HASH_BLCK_SIZE ,GFP_KERNEL|GFP_DMA);
+	state->buff0 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->buff0) {
 		SSI_LOG_ERR("Allocating buff0 in context failed\n");
 		goto fail0;
 	}
-	state->buff1 = kzalloc(SSI_MAX_HASH_BLCK_SIZE ,GFP_KERNEL|GFP_DMA);
+	state->buff1 = kzalloc(SSI_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->buff1) {
 		SSI_LOG_ERR("Allocating buff1 in context failed\n");
 		goto fail_buff0;
 	}
-	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE ,GFP_KERNEL|GFP_DMA);
+	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!state->digest_result_buff) {
 		SSI_LOG_ERR("Allocating digest_result_buff in context failed\n");
 		goto fail_buff1;
 	}
-	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL|GFP_DMA);
+	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
 	if (!state->digest_buff) {
 		SSI_LOG_ERR("Allocating digest-buffer in context failed\n");
 		goto fail_digest_result_buff;
@@ -181,7 +181,7 @@ static int ssi_hash_map_request(struct device *dev,
 
 	SSI_LOG_DEBUG("Allocated digest-buffer in context ctx->digest_buff=@%p\n", state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL|GFP_DMA);
+		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!state->digest_bytes_len) {
 			SSI_LOG_ERR("Allocating digest-bytes-len in context failed\n");
 			goto fail1;
@@ -191,7 +191,7 @@ static int ssi_hash_map_request(struct device *dev,
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL|GFP_DMA);
+	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
 	if (!state->opad_digest_buff) {
 		SSI_LOG_ERR("Allocating opad-digest-buffer in context failed\n");
 		goto fail2;
@@ -431,7 +431,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	int rc = 0;
 
 
-	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-digest (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
@@ -598,7 +598,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	int rc;
 
 	SSI_LOG_DEBUG("===== %s-update (%d) ====\n", ctx->is_hmac ?
-					"hmac":"hash", nbytes);
+					"hmac" : "hash", nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 	if (nbytes == 0) {
@@ -696,11 +696,11 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	int idx = 0;
 	int rc;
 
-	SSI_LOG_DEBUG("===== %s-finup (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
-	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src , nbytes, 1) != 0)) {
+	if (unlikely(ssi_buffer_mgr_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1) != 0)) {
 		SSI_LOG_ERR("map_ahash_request_final() failed\n");
 		return -ENOMEM;
 	}
@@ -742,7 +742,7 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 			      digestsize, NS_BIT, 0);
-		ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
+		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
@@ -792,7 +792,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
+	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
@@ -833,7 +833,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	int idx = 0;
 	int rc;
 
-	SSI_LOG_DEBUG("===== %s-final (%d) ====\n", is_hmac?"hmac":"hash", nbytes);
+	SSI_LOG_DEBUG("===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash", nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
@@ -890,7 +890,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 			      digestsize, NS_BIT, 0);
-		ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
+		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
@@ -939,7 +939,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
-	ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
+	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
@@ -1057,7 +1057,7 @@ static int ssi_hash_setkey(void *hash,
 			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-			ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
+			ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 			idx++;
 
 			hw_desc_init(&desc[idx]);
@@ -1871,7 +1871,7 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 static int ssi_ahash_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
-	return ssi_hash_setkey((void *) ahash, key, keylen, false);
+	return ssi_hash_setkey((void *)ahash, key, keylen, false);
 }
 
 struct ssi_hash_template {
@@ -2143,7 +2143,7 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
 	ssi_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
 	unsigned int larval_seq_len = 0;
-	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX/sizeof(u32)];
+	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
 	int rc = 0;
 #if (DX_DEV_SHA_MAX > 256)
 	int i;
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 67ae1dc..c8c5875 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -31,7 +31,7 @@
 #include "ssi_pm.h"
 
 
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
@@ -71,14 +71,14 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 	}
 
 	rc = init_cc_regs(drvdata, false);
-	if (rc !=0) {
-		SSI_LOG_ERR("init_cc_regs (%x)\n",rc);
+	if (rc != 0) {
+		SSI_LOG_ERR("init_cc_regs (%x)\n", rc);
 		return rc;
 	}
 
 	rc = ssi_request_mgr_runtime_resume_queue(drvdata);
-	if (rc !=0) {
-		SSI_LOG_ERR("ssi_request_mgr_runtime_resume_queue (%x)\n",rc);
+	if (rc != 0) {
+		SSI_LOG_ERR("ssi_request_mgr_runtime_resume_queue (%x)\n", rc);
 		return rc;
 	}
 
@@ -126,10 +126,10 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 {
 	int rc = 0;
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	struct platform_device *plat_dev = drvdata->plat_dev;
 	/* must be before the enabling to avoid resdundent suspending */
-	pm_runtime_set_autosuspend_delay(&plat_dev->dev,SSI_SUSPEND_TIMEOUT);
+	pm_runtime_set_autosuspend_delay(&plat_dev->dev, SSI_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&plat_dev->dev);
 	/* activate the PM module */
 	rc = pm_runtime_set_active(&plat_dev->dev);
@@ -143,7 +143,7 @@ int ssi_power_mgr_init(struct ssi_drvdata *drvdata)
 
 void ssi_power_mgr_fini(struct ssi_drvdata *drvdata)
 {
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	struct platform_device *plat_dev = drvdata->plat_dev;
 
 	pm_runtime_disable(&plat_dev->dev);
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 8b0d8be..4874987 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -32,7 +32,7 @@ int ssi_power_mgr_init(struct ssi_drvdata *drvdata);
 
 void ssi_power_mgr_fini(struct ssi_drvdata *drvdata);
 
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 int ssi_power_mgr_runtime_suspend(struct device *dev);
 
 int ssi_power_mgr_runtime_resume(struct device *dev);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2c6937a..3176578 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -57,7 +57,7 @@ struct ssi_request_mgr_handle {
 #else
 	struct tasklet_struct comptask;
 #endif
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	bool is_runtime_suspended;
 #endif
 };
@@ -81,7 +81,7 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 	}
 
 	SSI_LOG_DEBUG("max_used_hw_slots=%d\n", (req_mgr_h->hw_queue_size -
-						req_mgr_h->min_free_hw_slots) );
+						req_mgr_h->min_free_hw_slots));
 	SSI_LOG_DEBUG("max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
 
 #ifdef COMP_IN_WQ
@@ -101,7 +101,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	struct ssi_request_mgr_handle *req_mgr_h;
 	int rc = 0;
 
-	req_mgr_h = kzalloc(sizeof(struct ssi_request_mgr_handle),GFP_KERNEL);
+	req_mgr_h = kzalloc(sizeof(struct ssi_request_mgr_handle), GFP_KERNEL);
 	if (req_mgr_h == NULL) {
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
@@ -168,13 +168,13 @@ static inline void enqueue_seq(
 	int i;
 
 	for (i = 0; i < seq_len; i++) {
-		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
 		wmb();
-		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base+CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
 #ifdef DX_DUMP_DESCS
 		SSI_LOG_DEBUG("desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n", i,
 			seq[i].word[0], seq[i].word[1], seq[i].word[2], seq[i].word[3], seq[i].word[4], seq[i].word[5]);
@@ -215,11 +215,11 @@ static inline int request_mgr_queues_status_check(
 		return -EBUSY;
 	}
 
-	if ((likely(req_mgr_h->q_free_slots >= total_seq_len)) ) {
+	if ((likely(req_mgr_h->q_free_slots >= total_seq_len))) {
 		return 0;
 	}
 	/* Wait for space in HW queue. Poll constant num of iterations. */
-	for (poll_queue =0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue ++) {
+	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
 			CC_HAL_READ_REGISTER(
 				CC_REG_OFFSET(CRY_KERNEL,
@@ -229,7 +229,7 @@ static inline int request_mgr_queues_status_check(
 			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
 		}
 
-		if (likely (req_mgr_h->q_free_slots >= total_seq_len)) {
+		if (likely(req_mgr_h->q_free_slots >= total_seq_len)) {
 			/* If there is enough place return */
 			return 0;
 		}
@@ -255,8 +255,8 @@ static inline int request_mgr_queues_status_check(
  * \param desc The crypto sequence
  * \param len The crypto sequence length
  * \param is_dout If "true": completion is handled by the caller
- *      	  If "false": this function adds a dummy descriptor completion
- *      	  and waits upon completion signal.
+ *	  If "false": this function adds a dummy descriptor completion
+ *	  and waits upon completion signal.
  *
  * \return int Returns -EINPROGRESS if "is_dout=true"; "0" if "is_dout=false"
  */
@@ -273,13 +273,13 @@ int send_request(
 	int rc;
 	unsigned int max_required_seq_len = (total_seq_len +
 					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
-					SSI_IVPOOL_SEQ_LEN ) +
-					((is_dout == 0 )? 1 : 0));
+					SSI_IVPOOL_SEQ_LEN) +
+					((is_dout == 0) ? 1 : 0));
 
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	rc = ssi_power_mgr_runtime_get(&drvdata->plat_dev->dev);
 	if (rc != 0) {
-		SSI_LOG_ERR("ssi_power_mgr_runtime_get returned %x\n",rc);
+		SSI_LOG_ERR("ssi_power_mgr_runtime_get returned %x\n", rc);
 		return rc;
 	}
 #endif
@@ -294,7 +294,7 @@ int send_request(
 		rc = request_mgr_queues_status_check(req_mgr_h,
 					       cc_base,
 					       max_required_seq_len);
-		if (likely(rc == 0 ))
+		if (likely(rc == 0))
 			/* There is enough place in the queue */
 			break;
 		/* something wrong release the spinlock*/
@@ -304,7 +304,7 @@ int send_request(
 			/* Any error other than HW queue full
 			 * (SW queue is full)
 			 */
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
 #endif
 			return rc;
@@ -339,7 +339,7 @@ int send_request(
 		if (unlikely(rc != 0)) {
 			SSI_LOG_ERR("Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
 #endif
 			return rc;
@@ -348,7 +348,7 @@ int send_request(
 		total_seq_len += iv_seq_len;
 	}
 
-	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE-1));
+	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE - 1));
 	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots)) {
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
 	}
@@ -412,7 +412,7 @@ int send_request_init(
 
 	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
 	rc = request_mgr_queues_status_check(req_mgr_h, cc_base, total_seq_len);
-	if (unlikely(rc != 0 )) {
+	if (unlikely(rc != 0)) {
 		return rc;
 	}
 	set_queue_last_ind(&desc[(len - 1)]);
@@ -455,11 +455,11 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	struct platform_device *plat_dev = drvdata->plat_dev;
 	struct ssi_request_mgr_handle * request_mgr_handle =
 						drvdata->request_mgr_handle;
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	int rc = 0;
 #endif
 
-	while(request_mgr_handle->axi_completed) {
+	while (request_mgr_handle->axi_completed) {
 		request_mgr_handle->axi_completed--;
 
 		/* Dequeue request */
@@ -480,7 +480,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 			u32 axi_err;
 			int i;
 			SSI_LOG_INFO("Delay\n");
-			for (i=0;i<1000000;i++) {
+			for (i = 0; i < 1000000; i++) {
 				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
 			}
 		}
@@ -492,10 +492,10 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
 		SSI_LOG_DEBUG("Dequeue request tail=%u\n", request_mgr_handle->req_queue_tail);
 		SSI_LOG_DEBUG("Request completed. axi_completed=%d\n", request_mgr_handle->axi_completed);
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 		rc = ssi_power_mgr_runtime_put_suspend(&plat_dev->dev);
 		if (rc != 0) {
-			SSI_LOG_ERR("Failed to set runtime suspension %d\n",rc);
+			SSI_LOG_ERR("Failed to set runtime suspension %d\n", rc);
 		}
 #endif
 	}
@@ -561,7 +561,7 @@ static void comp_handler(unsigned long devarg)
  * resume the queue configuration - no need to take the lock as this happens inside
  * the spin lock protection
  */
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle * request_mgr_handle = drvdata->request_mgr_handle;
@@ -570,7 +570,7 @@ int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
 	request_mgr_handle->is_runtime_suspended = false;
 	spin_unlock_bh(&request_mgr_handle->hw_lock);
 
-	return 0 ;
+	return 0;
 }
 
 /*
@@ -600,7 +600,7 @@ bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata)
 	struct ssi_request_mgr_handle * request_mgr_handle =
 						drvdata->request_mgr_handle;
 
-	return 	request_mgr_handle->is_runtime_suspended;
+	return	request_mgr_handle->is_runtime_suspended;
 }
 
 #endif
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index c4036ab..bdbbf89 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -33,8 +33,8 @@ int request_mgr_init(struct ssi_drvdata *drvdata);
  * \param desc The crypto sequence
  * \param len The crypto sequence length
  * \param is_dout If "true": completion is handled by the caller
- *      	  If "false": this function adds a dummy descriptor completion
- *      	  and waits upon completion signal.
+ *	  If "false": this function adds a dummy descriptor completion
+ *	  and waits upon completion signal.
  *
  * \return int Returns -EINPROGRESS if "is_dout=ture"; "0" if "is_dout=false"
  */
@@ -49,7 +49,7 @@ void complete_request(struct ssi_drvdata *drvdata);
 
 void request_mgr_fini(struct ssi_drvdata *drvdata);
 
-#if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata);
 
 int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata);
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 69e1ae4..db70300 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -66,7 +66,7 @@ static struct stat_name stat_name_db[MAX_STAT_OP_TYPES] =
 		.stat_phase_name[STAT_PHASE_5] = "Sequence completion",
 		.stat_phase_name[STAT_PHASE_6] = "HW cycles",
 	},
-	{ 	.op_type_name = "Setkey",
+	{	.op_type_name = "Setkey",
 		.stat_phase_name[STAT_PHASE_0] = "Init and sanity checks",
 		.stat_phase_name[STAT_PHASE_1] = "Copy key to ctx",
 		.stat_phase_name[STAT_PHASE_2] = "Create sequence",
@@ -114,8 +114,8 @@ static void init_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES])
 	unsigned int i, j;
 
 	/* Clear db */
-	for (i=0; i<MAX_STAT_OP_TYPES; i++) {
-		for (j=0; j<MAX_STAT_PHASES; j++) {
+	for (i = 0; i < MAX_STAT_OP_TYPES; i++) {
+		for (j = 0; j < MAX_STAT_PHASES; j++) {
 			item[i][j].min = 0xFFFFFFFF;
 			item[i][j].max = 0;
 			item[i][j].sum = 0;
@@ -130,7 +130,7 @@ static void update_db(struct stat_item *item, unsigned int result)
 	item->sum += result;
 	if (result < item->min)
 		item->min = result;
-	if (result > item->max )
+	if (result > item->max)
 		item->max = result;
 }
 
@@ -139,8 +139,8 @@ static void display_db(struct stat_item item[MAX_STAT_OP_TYPES][MAX_STAT_PHASES]
 	unsigned int i, j;
 	u64 avg;
 
-	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
-		for (j=0; j<MAX_STAT_PHASES; j++) {
+	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
+		for (j = 0; j < MAX_STAT_PHASES; j++) {
 			if (item[i][j].count > 0) {
 				avg = (u64)item[i][j].sum;
 				do_div(avg, item[i][j].count);
@@ -174,18 +174,18 @@ static ssize_t ssi_sys_stats_cc_db_clear(struct kobject *kobj,
 static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	int i, j ;
+	int i, j;
 	char line[512];
 	u32 min_cyc, max_cyc;
 	u64 avg;
-	ssize_t buf_len, tmp_len=0;
+	ssize_t buf_len, tmp_len = 0;
 
-	buf_len = scnprintf(buf,PAGE_SIZE,
+	buf_len = scnprintf(buf, PAGE_SIZE,
 		"phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if ( buf_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 		return buf_len;
-	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
-		for (j=0; j<MAX_STAT_PHASES-1; j++) {
+	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
+		for (j = 0; j < MAX_STAT_PHASES - 1; j++) {
 			if (stat_host_db[i][j].count > 0) {
 				avg = (u64)stat_host_db[i][j].sum;
 				do_div(avg, stat_host_db[i][j].count);
@@ -194,18 +194,18 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 			} else {
 				avg = min_cyc = max_cyc = 0;
 			}
-			tmp_len = scnprintf(line,512,
+			tmp_len = scnprintf(line, 512,
 				"%s::%s\t\t\t\t\t%6u\t%6u\t%6u\t%7u\n",
 				stat_name_db[i].op_type_name,
 				stat_name_db[i].stat_phase_name[j],
 				min_cyc, (unsigned int)avg, max_cyc,
 				stat_host_db[i][j].count);
-			if ( tmp_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+			if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 				return buf_len;
-			if ( buf_len + tmp_len >= PAGE_SIZE)
+			if (buf_len + tmp_len >= PAGE_SIZE)
 				return buf_len;
 			buf_len += tmp_len;
-			strncat(buf, line,512);
+			strncat(buf, line, 512);
 		}
 	}
 	return buf_len;
@@ -218,13 +218,13 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 	char line[256];
 	u32 min_cyc, max_cyc;
 	u64 avg;
-	ssize_t buf_len,tmp_len=0;
+	ssize_t buf_len, tmp_len = 0;
 
-	buf_len = scnprintf(buf,PAGE_SIZE,
+	buf_len = scnprintf(buf, PAGE_SIZE,
 		"phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if ( buf_len <0 )/* scnprintf shouldn't return negative value according to its implementation*/
+	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 		return buf_len;
-	for (i=STAT_OP_TYPE_ENCODE; i<MAX_STAT_OP_TYPES; i++) {
+	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
 		if (stat_cc_db[i][STAT_PHASE_6].count > 0) {
 			avg = (u64)stat_cc_db[i][STAT_PHASE_6].sum;
 			do_div(avg, stat_cc_db[i][STAT_PHASE_6].count);
@@ -233,7 +233,7 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 		} else {
 			avg = min_cyc = max_cyc = 0;
 		}
-		tmp_len = scnprintf(line,256,
+		tmp_len = scnprintf(line, 256,
 			"%s\t%6u\t%6u\t%6u\t%7u\n",
 			stat_name_db[i].op_type_name,
 			min_cyc,
@@ -241,13 +241,13 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 			max_cyc,
 			stat_cc_db[i][STAT_PHASE_6].count);
 
-		if ( tmp_len < 0 )/* scnprintf shouldn't return negative value according to its implementation*/
+		if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
 			return buf_len;
 
-		if ( buf_len + tmp_len >= PAGE_SIZE)
+		if (buf_len + tmp_len >= PAGE_SIZE)
 			return buf_len;
 		buf_len += tmp_len;
-		strncat(buf, line,256);
+		strncat(buf, line, 256);
 	}
 	return buf_len;
 }
@@ -304,7 +304,7 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 static ssize_t ssi_sys_help_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	char* help_str[]={
+	char* help_str[] = {
 				"cat reg_dump              ", "Print several of CC register values",
 		#if defined CC_CYCLE_COUNT
 				"cat stats_host            ", "Print host statistics",
@@ -313,11 +313,11 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 				"echo <number> > stats_cc  ", "Clear CC statistics database",
 		#endif
 				};
-	int i=0, offset = 0;
+	int i = 0, offset = 0;
 
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
-	for ( i = 0; i < ARRAY_SIZE(help_str); i+=2) {
-	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i+1]);
+	for (i = 0; i < ARRAY_SIZE(help_str); i += 2) {
+	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i + 1]);
 	}
 	return offset;
 }
-- 
2.1.4
