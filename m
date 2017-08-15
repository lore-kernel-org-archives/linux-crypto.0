From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 17/22] staging: ccree: clean up comments
Date: Tue, 15 Aug 2017 09:26:45 +0300
Message-ID: <1502778412-16255-18-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Clean up comments: fix style, trim long lines and remove useless ones.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 40 +++++++++++++++++--------
 drivers/staging/ccree/ssi_aead.h        | 47 ++++++++++++++++++-----------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 52 +++++++++++++++++++++------------
 drivers/staging/ccree/ssi_cipher.c      | 10 +++++--
 drivers/staging/ccree/ssi_config.h      |  7 +++--
 drivers/staging/ccree/ssi_driver.c      |  8 +++--
 drivers/staging/ccree/ssi_driver.h      |  9 ++++--
 drivers/staging/ccree/ssi_hash.c        | 16 +++++++---
 drivers/staging/ccree/ssi_hash.h        | 10 +++++--
 drivers/staging/ccree/ssi_ivgen.c       |  7 +++--
 drivers/staging/ccree/ssi_ivgen.h       |  3 +-
 drivers/staging/ccree/ssi_request_mgr.c | 29 ++++++++++++------
 drivers/staging/ccree/ssi_sysfs.c       |  9 +++---
 13 files changed, 167 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 515a603..88305f0 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -267,7 +267,10 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req,
 								ctx->authsize,
 								SSI_SG_FROM_BUF);
 
-		/* If an IV was generated, copy it back to the user provided buffer. */
+		/*
+		 * If an IV was generated, copy it back to the user provided
+		 * buffer.
+		 */
 		if (areq_ctx->backup_giv) {
 			if (ctx->cipher_mode == DRV_CIPHER_CTR)
 				memcpy(areq_ctx->backup_giv,
@@ -288,8 +291,9 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 {
 	/* Load the AES key */
 	hw_desc_init(&desc[0]);
-	/* We are using for the source/user key the same buffer as for the output keys,
-	 * because after this key loading it is not needed anymore
+	/* We are using for the source/user key the same buffer as for the
+	 * output keys, because after this key loading it is not needed
+	 * anymore.
 	 */
 	set_din_type(&desc[0], DMA_DLLI,
 		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
@@ -1570,7 +1574,9 @@ static int config_ccm_adata(struct aead_request *req)
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	//unsigned int size_of_a = 0, rem_a_size = 0;
 	unsigned int lp = req->iv[0];
-	/* Note: The code assume that req->iv[0] already contains the value of L' of RFC3610 */
+	/* Note: The code assumes that req->iv[0] already contains the value
+	 * of L' of RFC3610
+	 */
 	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
 	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
 	u8 *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
@@ -1624,9 +1630,14 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 	/* L' */
 	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
-	areq_ctx->ctr_iv[0] = 3;  /* For RFC 4309, always use 4 bytes for message length (at most 2^32-1 bytes). */
+	/* For RFC 4309, always use 4 bytes for message length
+	 * (at most 2^32-1 bytes).
+	 */
+	areq_ctx->ctr_iv[0] = 3;
 
-	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build here. */
+	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build
+	 * here.
+	 */
 	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce,
 	       CCM_BLOCK_NONCE_SIZE);
 	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
@@ -1701,7 +1712,9 @@ static inline void ssi_aead_gcm_setup_ghash_desc(struct aead_request *req,
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
+	/* Load GHASH initial STATE (which is 0). (for any hash there is an
+	 * initial state).
+	 */
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
 	set_dout_no_dma(&desc[idx], 0, 0, 1);
@@ -1938,7 +1951,10 @@ static int config_gcm_context(struct aead_request *req)
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
-	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
+	} else {
+		/* rfc4543=> all data(AAD,IV,Plain) are considered additional
+		 * data that is nothing is encrypted.
+		 */
 		__be64 temp64;
 
 		temp64 =
@@ -2078,10 +2094,10 @@ static int ssi_aead_process(struct aead_request *req,
 			    CTR_RFC3686_NONCE_SIZE;
 			ssi_req.ivgen_dma_addr_len = 1;
 		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
-			/* In ccm, the IV needs to exist both inside B0 and inside the counter.
-			 * It is also copied to iv_dma_addr for other reasons (like returning
-			 * it to the user).
-			 * So, using 3 (identical) IV outputs.
+			/* In ccm, the IV needs to exist both inside B0 and
+			 * inside the counter. It is also copied to
+			 * iv_dma_addr for other reasons (like returning it
+			 * to the user). So, using 3 (identical) IV outputs.
 			 */
 			ssi_req.ivgen_dma_addr[0] =
 			    areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index e85bcd9..96586d8 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -58,13 +58,13 @@ enum aead_ccm_header_size {
 
 struct aead_req_ctx {
 	/* Allocate cache line although only 4 bytes are needed to
-	 *  assure next field falls @ cache line
-	 *  Used for both: digest HW compare and CCM/GCM MAC value
+	 * assure next field falls @ cache line
+	 * Used for both: digest HW compare and CCM/GCM MAC value
 	 */
 	u8 mac_buf[MAX_MAC_SIZE] ____cacheline_aligned;
 	u8 ctr_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
 
-	//used in gcm
+	/* used in gcm */
 	u8 gcm_iv_inc1[AES_BLOCK_SIZE] ____cacheline_aligned;
 	u8 gcm_iv_inc2[AES_BLOCK_SIZE] ____cacheline_aligned;
 	u8 hkey[AES_BLOCK_SIZE] ____cacheline_aligned;
@@ -74,22 +74,34 @@ struct aead_req_ctx {
 	} gcm_len_block;
 
 	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
-	unsigned int hw_iv_size ____cacheline_aligned; /*HW actual size input*/
-	u8 backup_mac[MAX_MAC_SIZE]; /*used to prevent cache coherence problem*/
-	u8 *backup_iv; /*store iv for generated IV flow*/
-	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
-	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
-	dma_addr_t ccm_iv0_dma_addr; /* buffer for internal ccm configurations */
-	dma_addr_t icv_dma_addr; /* Phys. address of ICV */
+	/* HW actual size input */
+	unsigned int hw_iv_size ____cacheline_aligned;
+	/* used to prevent cache coherence problem */
+	u8 backup_mac[MAX_MAC_SIZE];
+	/* store iv for generated IV flow */
+	u8 *backup_iv;
+	/* store iv for rfc3686(ctr) flow */
+	u8 *backup_giv;
+	/* internal ICV DMA buffer */
+	dma_addr_t mac_buf_dma_addr;
+	/* buf for internal ccm configurations */
+	dma_addr_t ccm_iv0_dma_addr;
+	/* Phys. address of ICV */
+	dma_addr_t icv_dma_addr;
 
-	//used in gcm
-	dma_addr_t gcm_iv_inc1_dma_addr; /* buffer for internal gcm configurations */
-	dma_addr_t gcm_iv_inc2_dma_addr; /* buffer for internal gcm configurations */
-	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
-	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
+	/* used in gcm */
+	/* buf for internal gcm configurations */
+	dma_addr_t gcm_iv_inc1_dma_addr;
+	/* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc2_dma_addr;
+	/* Phys. address of hkey */
+	dma_addr_t hkey_dma_addr;
+	/* Phys. address of gcm block len */
+	dma_addr_t gcm_block_len_dma_addr;
 	bool is_gcm4543;
 
-	u8 *icv_virt_addr; /* Virt. address of ICV */
+	/* Virt. address of ICV */
+	u8 *icv_virt_addr;
 	struct async_gen_req_ctx gen_ctx;
 	struct ssi_mlli assoc;
 	struct ssi_mlli src;
@@ -108,7 +120,8 @@ struct aead_req_ctx {
 	enum drv_cipher_mode cipher_mode;
 	bool is_icv_fragmented;
 	bool is_single_pass;
-	bool plaintext_authenticate_only; //for gcm_rfc4543
+	/* for gcm_rfc4543 */
+	bool plaintext_authenticate_only;
 };
 
 int ssi_aead_alloc(struct ssi_drvdata *drvdata);
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 4be7b51..202387b 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -706,7 +706,8 @@ void ssi_buffer_mgr_unmap_aead_request(
 			size_to_skip += crypto_aead_ivsize(tfm);
 
 		/* copy mac to a temporary location to deal with possible
-		 * data memory overriding that caused by cache coherence problem.
+		 * data memory overriding that caused by cache coherence
+		 * problem.
 		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
@@ -742,10 +743,12 @@ static inline int ssi_buffer_mgr_get_aead_icv_nents(
 		icv_max_size = sgl->length;
 
 	if (last_entry_data_size > authsize) {
-		nents = 0; /* ICV attached to data in last entry (not fragmented!) */
+		/* ICV attached to data in last entry (not fragmented!) */
+		nents = 0;
 		*is_icv_fragmented = false;
 	} else if (last_entry_data_size == authsize) {
-		nents = 1; /* ICV placed in whole last entry (not fragmented!) */
+		/* ICV placed in whole last entry (not fragmented!) */
+		nents = 1;
 		*is_icv_fragmented = false;
 	} else if (icv_max_size > icv_required_size) {
 		nents = 1;
@@ -792,7 +795,8 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
 	SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
 		      hw_iv_size, req->iv,
 		      &areq_ctx->gen_ctx.iv_dma_addr);
-	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
+	if (do_chain && areq_ctx->plaintext_authenticate_only) {
+		/* TODO: what about CTR?? */
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
 		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
@@ -840,16 +844,22 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 		goto chain_assoc_exit;
 	}
 
-	//iterate over the sgl to see how many entries are for associated data
-	//it is assumed that if we reach here , the sgl is already mapped
+	/* Iterate over the sgl to see how many entries are for associated
+	 * data it is assumed that if we reach here , the sgl is already
+	 * mapped
+	 */
 	sg_index = current_sg->length;
-	if (sg_index > size_of_assoc) { //the first entry in the scatter list contains all the associated data
+	if (sg_index > size_of_assoc) {
+		/* The first entry in the scatter list contains all the
+		 * associated data
+		 */
 		mapped_nents++;
 	} else {
 		while (sg_index <= size_of_assoc) {
 			current_sg = sg_next(current_sg);
-			//if have reached the end of the sgl, then this is unexpected
-			if (!current_sg) {
+			/* If have reached the end of the sgl, then this is
+			 * unexpected
+			 */			if (!current_sg) {
 				SSI_LOG_ERR("reached end of sg list. unexpected\n");
 				BUG();
 			}
@@ -971,8 +981,8 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 		if (unlikely(areq_ctx->is_icv_fragmented)) {
 			/* Backup happens only when ICV is fragmented, ICV
-			 * verification is made by CPU compare in order to simplify
-			 * MAC verification upon request completion
+			 * verification is made by CPU compare in order to
+			 * simplify MAC verification upon request completion
 			 */
 			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 				if (!drvdata->coherent) {
@@ -1037,8 +1047,8 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
 
 		if (unlikely(areq_ctx->is_icv_fragmented)) {
 			/* Backup happens only when ICV is fragmented, ICV
-			 * verification is made by CPU compare in order to simplify
-			 * MAC verification upon request completion
+			 * verification is made by CPU compare in order to
+			 * simplify MAC verification upon request completion
 			 */
 			  u32 size_to_skip = req->assoclen;
 
@@ -1119,7 +1129,8 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 	int rc = 0;
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
-	unsigned int size_for_map = req->assoclen + req->cryptlen; /*non-inplace mode*/
+	/* Non-inplace mode */
+	unsigned int size_for_map = req->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
 	bool chained = false;
@@ -1305,8 +1316,9 @@ int ssi_buffer_mgr_map_aead_request(
 		if (is_gcm4543)
 			size_to_skip += crypto_aead_ivsize(tfm);
 
-		/* copy mac to a temporary location to deal with possible
-		 * data memory overriding that caused by cache coherence problem.
+		/* Copy mac to a temporary location to deal with possible
+		 * data memory overriding that caused by cache coherence
+		 * problem.
 		 */
 		ssi_buffer_mgr_copy_scatterlist_portion(
 			areq_ctx->backup_mac, req->src,
@@ -1466,7 +1478,9 @@ int ssi_buffer_mgr_map_aead_request(
 			goto aead_map_failure;
 	}
 
-	/* Mlli support -start building the MLLI according to the above results */
+	/* Mlli support - start building the MLLI according to the above
+	 * results
+	 */
 	if (unlikely(
 		(areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) ||
 		(areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI))) {
@@ -1739,7 +1753,9 @@ void ssi_buffer_mgr_unmap_hash_request(
 			      sg_dma_len(areq_ctx->buff_sg));
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 		if (!do_revert) {
-			/* clean the previous data length for update operation */
+			/* Clean the previous data length for update
+			 * operation
+			 */
 			*prev_len = 0;
 		} else {
 			areq_ctx->buff_index ^= 1;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index e417bfd..14930ce 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -310,10 +310,12 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	/* STAT_PHASE_0: Init and sanity checks */
 
 #if SSI_CC_HAS_MULTI2
-	/*last byte of key buffer is round number and should not be a part of key size*/
+	/* Last byte of key buffer is round number and should not be a part
+	 * of key size
+	 */
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
 		keylen -= 1;
-#endif /*SSI_CC_HAS_MULTI2*/
+#endif /* SSI_CC_HAS_MULTI2 */
 
 	if (unlikely(validate_keys_sizes(ctx_p, keylen) != 0)) {
 		SSI_LOG_ERR("Unsupported key size %d.\n", keylen);
@@ -797,7 +799,9 @@ static int ssi_blkcipher_process(
 	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (!areq) ? 0 : 1);
 	if (areq) {
 		if (unlikely(rc != -EINPROGRESS)) {
-			/* Failed to send the request or request completed synchronously */
+			/* Failed to send the request or request completed
+			 * synchronously
+			 */
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 		}
 
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index ff7597c..b26812b 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -28,9 +28,12 @@
 //#define DX_DUMP_DESCS
 // #define DX_DUMP_BYTES
 // #define CC_DEBUG
-#define ENABLE_CC_SYSFS		/* Enable sysfs interface for debugging REE driver */
+
+/* Enable sysfs interface for debugging REE driver */
+#define ENABLE_CC_SYSFS
+
 //#define DX_IRQ_DELAY 100000
-#define DMA_BIT_MASK_LEN	48	/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
+#define DMA_BIT_MASK_LEN	48
 
 #endif /*__DX_CONFIG_H__*/
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 0ce2f57..91c0b71 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -140,7 +140,9 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
 	if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
-		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
+		/* Mask AXI completion interrupt - will be unmasked in deferred
+		 * service handler
+		 */
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
 				      imr | SSI_COMP_IRQ_MASK);
 		irr &= ~SSI_COMP_IRQ_MASK;
@@ -149,7 +151,9 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
 	if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
-		/* Mask interrupt - will be unmasked in Deferred service handler */
+		/* Mask interrupt - will be unmasked in deferred
+		 * service handler
+		 */
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
 				      imr | SSI_GPR0_IRQ_MASK);
 		irr &= ~SSI_GPR0_IRQ_MASK;
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 47c648a..e37a55a 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -115,9 +115,12 @@ struct ssi_crypto_req {
 	 * generated IV would be placed in it by send_request().
 	 * Same generated IV for all addresses!
 	 */
-	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
-	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
-	struct completion seq_compl; /* request completion */
+	/* Amount of 'ivgen_dma_addr' elements to be filled. */
+	unsigned int ivgen_dma_addr_len;
+	/* The generated IV size required, 8/16 B allowed. */
+	unsigned int ivgen_size;
+	/* request completion */
+	struct completion seq_compl;
 };
 
 /**
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index cfd5f5c..04b5025 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -502,7 +502,9 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		ssi_req.user_arg = (void *)async_req;
 	}
 
-	/* If HMAC then load hash IPAD xor key, if HASH then load initial digest */
+	/* If HMAC then load hash IPAD xor key, if HASH then load
+	 * initial digest.
+	 */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	if (is_hmac) {
@@ -1193,7 +1195,9 @@ static int ssi_hash_setkey(void *hash,
 		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 
-		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest of the first HASH "update" state) */
+		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial
+		 * digest of the first HASH "update" state)
+		 */
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		if (i > 0) /* Not first iteration */
@@ -1562,7 +1566,9 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
-		/* Initiate decryption of block state to previous block_state-XOR-M[n] */
+		/* Initiate decryption of block state to previous
+		 * block_state-XOR-M[n]
+		 */
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
 			     CC_AES_BLOCK_SIZE, NS_BIT);
@@ -2269,7 +2275,9 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 #if (DX_DEV_SHA_MAX > 256)
-	/* We are forced to swap each double-word larval before copying to sram */
+	/* We are forced to swap each double-word larval before
+	 * copying to sram
+	 */
 	for (i = 0; i < ARRAY_SIZE(sha384_init); i++) {
 		const u32 const0 = ((u32 *)((u64 *)&sha384_init[i]))[1];
 		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index c884727..8868cb1 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -41,7 +41,9 @@
 
 #define CC_EXPORT_MAGIC 0xC2EE1070U
 
-// this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used for xcbc/cmac statesize
+/* This struct was taken from drivers/crypto/nx/nx-aes-xcbc.c
+ * and it is used for xcbc/cmac statesize
+ */
 struct aeshash_state {
 	u8 state[AES_BLOCK_SIZE];
 	unsigned int count;
@@ -81,7 +83,8 @@ int ssi_hash_free(struct ssi_drvdata *drvdata);
  * Gets the initial digest length
  *
  * \param drvdata
- * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256/SHA384/SHA512
+ * \param mode The Hash mode. Supported modes:
+ *             MD5 / SHA1 / SHA224 / SHA256 / SHA384 / SHA512
  *
  * \return u32 returns the address of the initial digest length in SRAM
  */
@@ -93,7 +96,8 @@ ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode);
  * according to the given hash mode
  *
  * \param drvdata
- * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256/SHA384/SHA512
+ * \param mode The Hash mode. Supported modes:
+ *             MD5 / SHA1 / SHA224 / SHA256 / SHA384 / SHA512
  *
  * \return u32 The address of the initial digest in SRAM
  */
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index ba70237..c14f165 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -230,7 +230,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
  *
  * \param drvdata Driver private context
  * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_dma_len Length of iv_out_dma array
+ *                       (additional elements of iv_out_dma array are ignored)
  * \param iv_out_size May be 8 or 16 bytes long
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
@@ -258,7 +259,9 @@ int ssi_ivgen_getiv(
 		return -EINVAL;
 	}
 
-	//check that number of generated IV is limited to max dma address iv buffer size
+	/* Check that number of generated IV is limited to max dma address
+	 * iv buffer size
+	 */
 	if (iv_out_dma_len > SSI_MAX_IVGEN_DMA_ADDRESSES) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index 961aea4..36f295d 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -53,7 +53,8 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata);
  *
  * \param drvdata Driver private context
  * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_dma_len Length of iv_out_dma array
+ *                       (additional elements of iv_out_dma array are ignored)
  * \param iv_out_size May be 8 or 16 bytes long
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 9ca2536..b671eff 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -405,7 +405,9 @@ int send_request_init(
 	unsigned int total_seq_len = len; /*initial sequence length*/
 	int rc = 0;
 
-	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
+	/* Wait for space in HW and SW FIFO. Poll for as much as
+	 * FIFO_TIMEOUT.
+	 */
 	rc = request_mgr_queues_status_check(req_mgr_h, cc_base, total_seq_len);
 	if (unlikely(rc != 0))
 		return rc;
@@ -514,10 +516,14 @@ static void comp_handler(unsigned long devarg)
 	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
 
 	if (irq & SSI_COMP_IRQ_MASK) {
-		/* To avoid the interrupt from firing as we unmask it, we clear it now */
+		/* To avoid the interrupt from firing as we unmask it,
+		 * we clear it now
+		 */
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
 
-		/* Avoid race with above clear: Test completion counter once more */
+		/* Avoid race with above clear: Test completion counter
+		 * once more
+		 */
 		request_mgr_handle->axi_completed +=
 				cc_axi_comp_count(cc_base);
 
@@ -531,22 +537,27 @@ static void comp_handler(unsigned long devarg)
 						cc_axi_comp_count(cc_base);
 			} while (request_mgr_handle->axi_completed > 0);
 
-			/* To avoid the interrupt from firing as we unmask it, we clear it now */
+			/* To avoid the interrupt from firing as we unmask it,
+			 * we clear it now
+			 */
 			CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
 
-			/* Avoid race with above clear: Test completion counter once more */
+			/* Avoid race with above clear: Test completion counter
+			 * once more
+			 */
 			request_mgr_handle->axi_completed +=
 					cc_axi_comp_count(cc_base);
 		}
 	}
-	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
+	/* After verifing that there is nothing to do, Unmask AXI completion
+	 * interrupt
+	 */
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
 			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
 }
 
-/*
- * resume the queue configuration - no need to take the lock as this happens inside
- * the spin lock protection
+/* Resume the queue configuration - no need to take the lock as this happens
+ * inside the spin lock protection
  */
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 0655658..a0ab3c6 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -185,7 +185,7 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 
 	buf_len = scnprintf(buf, PAGE_SIZE,
 			    "phase\t\t\t\t\t\t\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
+	if (buf_len < 0)
 		return buf_len;
 	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
 		for (j = 0; j < MAX_STAT_PHASES - 1; j++) {
@@ -203,7 +203,8 @@ static ssize_t ssi_sys_stat_host_db_show(struct kobject *kobj,
 					    stat_name_db[i].stat_phase_name[j],
 					    min_cyc, (unsigned int)avg, max_cyc,
 					    stat_host_db[i][j].count);
-			if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
+
+			if (tmp_len < 0)
 				return buf_len;
 			if (buf_len + tmp_len >= PAGE_SIZE)
 				return buf_len;
@@ -225,7 +226,7 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 
 	buf_len = scnprintf(buf, PAGE_SIZE,
 			    "phase\tmin[cy]\tavg[cy]\tmax[cy]\t#samples\n");
-	if (buf_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
+	if (buf_len < 0)
 		return buf_len;
 	for (i = STAT_OP_TYPE_ENCODE; i < MAX_STAT_OP_TYPES; i++) {
 		if (stat_cc_db[i][STAT_PHASE_6].count > 0) {
@@ -241,7 +242,7 @@ static ssize_t ssi_sys_stat_cc_db_show(struct kobject *kobj,
 				    (unsigned int)avg, max_cyc,
 				    stat_cc_db[i][STAT_PHASE_6].count);
 
-		if (tmp_len < 0)/* scnprintf shouldn't return negative value according to its implementation*/
+		if (tmp_len < 0)
 			return buf_len;
 
 		if (buf_len + tmp_len >= PAGE_SIZE)
-- 
2.1.4
