From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 15/24] staging: ccree: trim long lines for readability
Date: Mon, 13 Nov 2017 14:45:43 +0000
Message-ID: <1510584358-29473-16-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccree driver did not adhere to the kernel max 80 chars per line limit
making the code hard to follow. Fix this by breaking long lines and
in some cases, moving comments to a separate line from code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 152 ++++++++++++++++++++++----------
 drivers/staging/ccree/ssi_aead.h        |  15 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 100 +++++++++++++--------
 drivers/staging/ccree/ssi_cipher.c      |  66 ++++++++++----
 drivers/staging/ccree/ssi_cipher.h      |   5 +-
 drivers/staging/ccree/ssi_config.h      |   6 +-
 drivers/staging/ccree/ssi_driver.c      |   8 +-
 drivers/staging/ccree/ssi_driver.h      |  15 ++--
 drivers/staging/ccree/ssi_fips.h        |   3 +-
 drivers/staging/ccree/ssi_hash.c        | 131 +++++++++++++++++++--------
 drivers/staging/ccree/ssi_hash.h        |  10 ++-
 drivers/staging/ccree/ssi_ivgen.c       |   7 +-
 drivers/staging/ccree/ssi_ivgen.h       |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |  45 ++++++----
 drivers/staging/ccree/ssi_sysfs.c       |  33 +++++--
 15 files changed, 406 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 7abc352..e2cdf52 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -100,7 +100,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 
 	/* Unmap enckey buffer */
 	if (ctx->enckey) {
-		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
+		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey,
+				  ctx->enckey_dma_addr);
 		dev_dbg(dev, "Freed enckey DMA buffer enckey_dma_addr=%pad\n",
 			&ctx->enckey_dma_addr);
 		ctx->enckey_dma_addr = 0;
@@ -259,12 +260,17 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req)
 					   SSI_SG_FROM_BUF);
 		}
 
-		/* If an IV was generated, copy it back to the user provided buffer. */
+		/* If an IV was generated, copy it back to the user provided
+		 * buffer.
+		 */
 		if (areq_ctx->backup_giv) {
 			if (ctx->cipher_mode == DRV_CIPHER_CTR)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
+				       CTR_RFC3686_NONCE_SIZE,
+				       CTR_RFC3686_IV_SIZE);
 			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
+				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv +
+				       CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
 		}
 	}
 
@@ -275,8 +281,9 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 {
 	/* Load the AES key */
 	hw_desc_init(&desc[0]);
-	/* We are using for the source/user key the same buffer as for the output keys,
-	 * because after this key loading it is not needed anymore
+	/* We are using for the source/user key the same buffer
+	 * as for the output keys, * because after this key loading it
+	 * is not needed anymore
 	 */
 	set_din_type(&desc[0], DMA_DLLI,
 		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
@@ -428,7 +435,8 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
  * (copy to intenral buffer or hash in case of key longer than block
  */
 static int
-ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -459,7 +467,8 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	}
 
 	if (likely(keylen != 0)) {
-		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		key_dma_addr = dma_map_single(dev, (void *)key, keylen,
+					      DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
 			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
@@ -587,8 +596,9 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			/* Copy nonce from last 4 bytes in CTR key to
 			 *  first 4 bytes in CTR IV
 			 */
-			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen + ctx->enc_keylen -
-				CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
+			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen +
+			       ctx->enc_keylen - CTR_RFC3686_NONCE_SIZE,
+			       CTR_RFC3686_NONCE_SIZE);
 			/* Set CTR key size */
 			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
 		}
@@ -654,7 +664,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
@@ -856,7 +867,8 @@ ssi_aead_process_cipher_data_desc(
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     (sg_dma_address(areq_ctx->src_sgl) +
-			      areq_ctx->src_offset), areq_ctx->cryptlen, NS_BIT);
+			      areq_ctx->src_offset), areq_ctx->cryptlen,
+			      NS_BIT);
 		set_dout_dlli(&desc[idx],
 			      (sg_dma_address(areq_ctx->dst_sgl) +
 			       areq_ctx->dst_offset),
@@ -1256,7 +1268,8 @@ static inline void ssi_aead_hmac_authenc(
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
+						  seq_size);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
@@ -1272,14 +1285,16 @@ static inline void ssi_aead_hmac_authenc(
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after..*/
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 
 	} else { /*DECRYPT*/
 		/* authenc first..*/
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		/* decrypt after.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
@@ -1310,7 +1325,8 @@ ssi_aead_xcbc_authenc(
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
+						  seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
 	}
@@ -1325,12 +1341,14 @@ ssi_aead_xcbc_authenc(
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after.. */
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 	} else { /*DECRYPT*/
 		/* authenc first.. */
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
+						   seq_size, direct);
 		/* decrypt after..*/
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
@@ -1521,7 +1539,8 @@ static inline int ssi_aead_ccm(
 
 	/* process the cipher */
 	if (req_ctx->cryptlen)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
+						  &idx);
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1571,7 +1590,9 @@ static int config_ccm_adata(struct aead_request *req)
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	//unsigned int size_of_a = 0, rem_a_size = 0;
 	unsigned int lp = req->iv[0];
-	/* Note: The code assume that req->iv[0] already contains the value of L' of RFC3610 */
+	/* Note: The code assume that req->iv[0] already contains the value
+	 * of L' of RFC3610
+	 */
 	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
 	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
 	u8 *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
@@ -1628,11 +1649,18 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 	/* L' */
 	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
-	areq_ctx->ctr_iv[0] = 3;  /* For RFC 4309, always use 4 bytes for message length (at most 2^32-1 bytes). */
+	/* For RFC 4309, always use 4 bytes for message length
+	 * (at most 2^32-1 bytes).
+	 */
+	areq_ctx->ctr_iv[0] = 3;
 
-	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build here. */
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce, CCM_BLOCK_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,    req->iv,        CCM_BLOCK_IV_SIZE);
+	/* In RFC 4309 there is an 11-bytes nonce+IV part,
+	 * that we build here.
+	 */
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce,
+	       CCM_BLOCK_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
+	       CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= CCM_BLOCK_IV_SIZE;
 }
@@ -1704,7 +1732,9 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
+	/* Load GHASH initial STATE (which is 0). (for any hash there is an
+	 * initial state)
+	 */
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
 	set_dout_no_dma(&desc[idx], 0, 0, 1);
@@ -1855,7 +1885,8 @@ static inline int ssi_aead_gcm(
 	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
 	if (req_ctx->cryptlen)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
+						  seq_size);
 	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 
 	return 0;
@@ -1895,13 +1926,16 @@ static inline void ssi_aead_dump_gcm(
 
 	dump_byte_array("mac_buf", req_ctx->mac_buf, AES_BLOCK_SIZE);
 
-	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a, AES_BLOCK_SIZE);
+	dump_byte_array("gcm_len_block", req_ctx->gcm_len_block.len_a,
+			AES_BLOCK_SIZE);
 
 	if (req->src && req->cryptlen)
-		dump_byte_array("req->src", sg_virt(req->src), req->cryptlen + req->assoclen);
+		dump_byte_array("req->src", sg_virt(req->src),
+				req->cryptlen + req->assoclen);
 
 	if (req->dst)
-		dump_byte_array("req->dst", sg_virt(req->dst), req->cryptlen + ctx->authsize + req->assoclen);
+		dump_byte_array("req->dst", sg_virt(req->dst),
+				req->cryptlen + ctx->authsize + req->assoclen);
 }
 #endif
 
@@ -1939,10 +1973,14 @@ static int config_gcm_context(struct aead_request *req)
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
-	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
+	} else {
+		/* rfc4543=>  all data(AAD,IV,Plain) are considered additional
+		 * data that is nothing is encrypted.
+		 */
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
+		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
+				      cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1957,15 +1995,18 @@ static void ssi_rfc4_gcm_process(struct aead_request *req)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET, ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET,    req->iv, GCM_BLOCK_RFC4_IV_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET,
+	       ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
+	       GCM_BLOCK_RFC4_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
 #endif /*SSI_CC_HAS_AES_GCM*/
 
-static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction direct)
+static int ssi_aead_process(struct aead_request *req,
+			    enum drv_crypto_direction direct)
 {
 	int rc = 0;
 	int seq_len = 0;
@@ -2006,7 +2047,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		/* Build CTR IV - Copy nonce from last 4 bytes in
 		 * CTR key to first 4 bytes in CTR IV
 		 */
-		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
+		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
+		       CTR_RFC3686_NONCE_SIZE);
 		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
 			       req->iv, CTR_RFC3686_IV_SIZE);
@@ -2021,7 +2063,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
 		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
 		if (areq_ctx->ctr_iv != req->iv) {
-			memcpy(areq_ctx->ctr_iv, req->iv, crypto_aead_ivsize(tfm));
+			memcpy(areq_ctx->ctr_iv, req->iv,
+			       crypto_aead_ivsize(tfm));
 			req->iv = areq_ctx->ctr_iv;
 		}
 	}  else {
@@ -2064,20 +2107,29 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (areq_ctx->backup_giv) {
 		/* set the DMA mapped IV address*/
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CTR_RFC3686_NONCE_SIZE;
+			ssi_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr +
+				CTR_RFC3686_NONCE_SIZE;
 			ssi_req.ivgen_dma_addr_len = 1;
 		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
-			/* In ccm, the IV needs to exist both inside B0 and inside the counter.
-			 * It is also copied to iv_dma_addr for other reasons (like returning
-			 * it to the user).
+			/* In ccm, the IV needs to exist both inside B0 and
+			 * inside the counter.It is also copied to iv_dma_addr
+			 * for other reasons (like returning it to the user).
 			 * So, using 3 (identical) IV outputs.
 			 */
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[1] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_B0_OFFSET          + CCM_BLOCK_IV_OFFSET;
-			ssi_req.ivgen_dma_addr[2] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr +
+				CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[1] =
+				sg_dma_address(&areq_ctx->ccm_adata_sg) +
+				CCM_B0_OFFSET + CCM_BLOCK_IV_OFFSET;
+			ssi_req.ivgen_dma_addr[2] =
+				sg_dma_address(&areq_ctx->ccm_adata_sg) +
+				CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
 			ssi_req.ivgen_dma_addr_len = 3;
 		} else {
-			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr;
+			ssi_req.ivgen_dma_addr[0] =
+				areq_ctx->gen_ctx.iv_dma_addr;
 			ssi_req.ivgen_dma_addr_len = 1;
 		}
 
@@ -2232,7 +2284,8 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -2248,7 +2301,8 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	return ssi_aead_setkey(tfm, key, keylen);
 }
 
-static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -2696,7 +2750,8 @@ static struct ssi_crypto_alg *ssi_aead_create_alg(
 
 	alg = &template->template_aead;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 template->name);
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 template->driver_name);
 	alg->base.cra_module = THIS_MODULE;
@@ -2725,7 +2780,8 @@ int ssi_aead_free(struct ssi_drvdata *drvdata)
 
 	if (aead_handle) {
 		/* Remove registered algs */
-		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list, entry) {
+		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list,
+					 entry) {
 			crypto_unregister_aead(&t_alg->aead_alg);
 			list_del(&t_alg->entry);
 			kfree(t_alg);
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 580fdb8..4e29063 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -74,17 +74,22 @@ struct aead_req_ctx {
 	} gcm_len_block;
 
 	u8 ccm_config[CCM_CONFIG_BUF_SIZE] ____cacheline_aligned;
-	unsigned int hw_iv_size ____cacheline_aligned; /*HW actual size input*/
-	u8 backup_mac[MAX_MAC_SIZE]; /*used to prevent cache coherence problem*/
+	/* HW actual size input */
+	unsigned int hw_iv_size ____cacheline_aligned;
+	/* used to prevent cache coherence problem */
+	u8 backup_mac[MAX_MAC_SIZE];
 	u8 *backup_iv; /*store iv for generated IV flow*/
 	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
 	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
-	dma_addr_t ccm_iv0_dma_addr; /* buffer for internal ccm configurations */
+	/* buffer for internal ccm configurations */
+	dma_addr_t ccm_iv0_dma_addr;
 	dma_addr_t icv_dma_addr; /* Phys. address of ICV */
 
 	//used in gcm
-	dma_addr_t gcm_iv_inc1_dma_addr; /* buffer for internal gcm configurations */
-	dma_addr_t gcm_iv_inc2_dma_addr; /* buffer for internal gcm configurations */
+	/* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc1_dma_addr;
+	/* buffer for internal gcm configurations */
+	dma_addr_t gcm_iv_inc2_dma_addr;
 	dma_addr_t hkey_dma_addr; /* Phys. address of hkey */
 	dma_addr_t gcm_block_len_dma_addr; /* Phys. address of gcm block len */
 	bool is_gcm4543;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 5e01477..966033d 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -112,7 +112,8 @@ static unsigned int cc_get_sgl_nents(
 			nents++;
 			/* get the number of bytes in the last entry */
 			*lbytes = nbytes;
-			nbytes -= (sg_list->length > nbytes) ? nbytes : sg_list->length;
+			nbytes -= (sg_list->length > nbytes) ?
+					nbytes : sg_list->length;
 			sg_list = sg_next(sg_list);
 		} else {
 			sg_list = (struct scatterlist *)sg_page(sg_list);
@@ -433,7 +434,8 @@ ssi_aead_handle_config_buf(struct device *dev,
 {
 	dev_dbg(dev, " handle additional data config set to DLLI\n");
 	/* create sg for the current buffer */
-	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
+	sg_init_one(&areq_ctx->ccm_adata_sg, config_data,
+		    AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
 	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
 				DMA_TO_DEVICE) != 1)) {
 		dev_err(dev, "dma_map_sg() config buffer failed\n");
@@ -701,7 +703,8 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
 	    likely(req->src == req->dst)) {
 		/* copy back mac from temporary location to deal with possible
-		 * data memory overriding that caused by cache coherence problem.
+		 * data memory overriding that caused by cache coherence
+		 * problem.
 		 */
 		cc_copy_mac(dev, req, SSI_SG_FROM_BUF);
 	}
@@ -716,7 +719,9 @@ static inline int cc_get_aead_icv_nents(
 	bool *is_icv_fragmented)
 {
 	unsigned int icv_max_size = 0;
-	unsigned int icv_required_size = authsize > last_entry_data_size ? (authsize - last_entry_data_size) : authsize;
+	unsigned int icv_required_size = authsize > last_entry_data_size ?
+					(authsize - last_entry_data_size) :
+					authsize;
 	unsigned int nents;
 	unsigned int i;
 
@@ -735,10 +740,12 @@ static inline int cc_get_aead_icv_nents(
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
@@ -773,7 +780,8 @@ static inline int cc_aead_chain_iv(
 		goto chain_iv_exit;
 	}
 
-	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv, hw_iv_size,
+	areq_ctx->gen_ctx.iv_dma_addr = dma_map_single(dev, req->iv,
+						       hw_iv_size,
 						       DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr))) {
 		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
@@ -784,7 +792,8 @@ static inline int cc_aead_chain_iv(
 
 	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
 		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
-	if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
+	// TODO: what about CTR?? ask Ron
+	if (do_chain && areq_ctx->plaintext_authenticate_only) {
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
 		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
@@ -836,12 +845,15 @@ static inline int cc_aead_chain_assoc(
 	//iterate over the sgl to see how many entries are for associated data
 	//it is assumed that if we reach here , the sgl is already mapped
 	sg_index = current_sg->length;
-	if (sg_index > size_of_assoc) { //the first entry in the scatter list contains all the associated data
+	//the first entry in the scatter list contains all the associated data
+	if (sg_index > size_of_assoc) {
 		mapped_nents++;
 	} else {
 		while (sg_index <= size_of_assoc) {
 			current_sg = sg_next(current_sg);
-			//if have reached the end of the sgl, then this is unexpected
+			/* if have reached the end of the sgl, then this is
+			 * unexpected
+			 */
 			if (!current_sg) {
 				dev_err(dev, "reached end of sg list. unexpected\n");
 				return -EINVAL;
@@ -959,8 +971,8 @@ static inline int cc_prepare_aead_data_mlli(
 
 		if (unlikely(areq_ctx->is_icv_fragmented)) {
 			/* Backup happens only when ICV is fragmented, ICV
-			 * verification is made by CPU compare in order to simplify
-			 * MAC verification upon request completion
+			 * verification is made by CPU compare in order to
+			 * simplify MAC verification upon request completion
 			 */
 			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
 				/* In coherent platforms (e.g. ACP)
@@ -974,7 +986,8 @@ static inline int cc_prepare_aead_data_mlli(
 				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 			} else {
 				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
-				areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
+				areq_ctx->icv_dma_addr =
+					areq_ctx->mac_buf_dma_addr;
 			}
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
@@ -1076,7 +1089,8 @@ static inline int cc_aead_chain_data(
 	int rc = 0;
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
-	unsigned int size_for_map = req->assoclen + req->cryptlen; /*non-inplace mode*/
+	/* non-inplace mode */
+	unsigned int size_for_map = req->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
 	bool chained = false;
@@ -1097,7 +1111,8 @@ static inline int cc_aead_chain_data(
 	if (is_gcm4543)
 		size_for_map += crypto_aead_ivsize(tfm);
 
-	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
+	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+			authsize : 0;
 	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
 					    &src_last_bytes, &chained);
 	sg_index = areq_ctx->src_sgl->length;
@@ -1125,7 +1140,8 @@ static inline int cc_aead_chain_data(
 
 	if (req->src != req->dst) {
 		size_for_map = req->assoclen + req->cryptlen;
-		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? authsize : 0;
+		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
+				authsize : 0;
 		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
 
@@ -1276,12 +1292,13 @@ int cc_map_aead_request(
 	}
 
 	if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
-		areq_ctx->ccm_iv0_dma_addr = dma_map_single(dev,
-							    (areq_ctx->ccm_config + CCM_CTR_COUNT_0_OFFSET),
-							    AES_BLOCK_SIZE,
-							    DMA_TO_DEVICE);
+		areq_ctx->ccm_iv0_dma_addr =
+			dma_map_single(dev, (areq_ctx->ccm_config +
+					     CCM_CTR_COUNT_0_OFFSET),
+				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, areq_ctx->ccm_iv0_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev,
+					       areq_ctx->ccm_iv0_dma_addr))) {
 			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE,
 				(areq_ctx->ccm_config +
@@ -1304,30 +1321,31 @@ int cc_map_aead_request(
 							 areq_ctx->hkey,
 							 AES_BLOCK_SIZE,
 							 DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev, areq_ctx->hkey_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev,
+					       areq_ctx->hkey_dma_addr))) {
 			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
 
-		areq_ctx->gcm_block_len_dma_addr = dma_map_single(dev,
-								  &areq_ctx->gcm_len_block,
-								  AES_BLOCK_SIZE,
-								  DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_block_len_dma_addr))) {
+		areq_ctx->gcm_block_len_dma_addr =
+			dma_map_single(dev, &areq_ctx->gcm_len_block,
+				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev,
+					       areq_ctx->gcm_block_len_dma_addr))) {
 			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
 
-		areq_ctx->gcm_iv_inc1_dma_addr = dma_map_single(dev,
-								areq_ctx->gcm_iv_inc1,
-								AES_BLOCK_SIZE,
-								DMA_TO_DEVICE);
+		areq_ctx->gcm_iv_inc1_dma_addr =
+			dma_map_single(dev, areq_ctx->gcm_iv_inc1,
+				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc1_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev,
+					       areq_ctx->gcm_iv_inc1_dma_addr))) {
 			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
@@ -1335,12 +1353,12 @@ int cc_map_aead_request(
 			goto aead_map_failure;
 		}
 
-		areq_ctx->gcm_iv_inc2_dma_addr = dma_map_single(dev,
-								areq_ctx->gcm_iv_inc2,
-								AES_BLOCK_SIZE,
-								DMA_TO_DEVICE);
+		areq_ctx->gcm_iv_inc2_dma_addr =
+			dma_map_single(dev, areq_ctx->gcm_iv_inc2,
+				       AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, areq_ctx->gcm_iv_inc2_dma_addr))) {
+		if (unlikely(dma_mapping_error(dev,
+					       areq_ctx->gcm_iv_inc2_dma_addr))) {
 			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
@@ -1414,7 +1432,9 @@ int cc_map_aead_request(
 			goto aead_map_failure;
 	}
 
-	/* Mlli support -start building the MLLI according to the above results */
+	/* Mlli support -start building the MLLI according to the above
+	 * results
+	 */
 	if (unlikely(
 		areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
 		areq_ctx->data_buff_type == SSI_DMA_BUF_MLLI)) {
@@ -1667,7 +1687,9 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			sg_dma_len(areq_ctx->buff_sg));
 		dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
 		if (!do_revert) {
-			/* clean the previous data length for update operation */
+			/* clean the previous data length for update
+			 * operation
+			 */
 			*prev_len = 0;
 		} else {
 			areq_ctx->buff_index ^= 1;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 4c1080a..f6e680c 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -109,7 +109,8 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
 	return -EINVAL;
 }
 
-static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size)
+static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p,
+			      unsigned int size)
 {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
@@ -164,12 +165,16 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 
 static unsigned int get_max_keysize(struct crypto_tfm *tfm)
 {
-	struct ssi_crypto_alg *ssi_alg = container_of(tfm->__crt_alg, struct ssi_crypto_alg, crypto_alg);
+	struct ssi_crypto_alg *ssi_alg =
+		container_of(tfm->__crt_alg, struct ssi_crypto_alg,
+			     crypto_alg);
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_ABLKCIPHER)
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_ABLKCIPHER)
 		return ssi_alg->crypto_alg.cra_ablkcipher.max_keysize;
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_BLKCIPHER)
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
 		return ssi_alg->crypto_alg.cra_blkcipher.max_keysize;
 
 	return 0;
@@ -267,8 +272,10 @@ static int ssi_verify_3des_keys(const u8 *key, unsigned int keylen)
 	struct tdes_keys *tdes_key = (struct tdes_keys *)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-		     (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
+	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
+			     sizeof(tdes_key->key1)) == 0) ||
+		     (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
+			     sizeof(tdes_key->key3)) == 0))) {
 		return -ENOEXEC;
 	}
 
@@ -306,7 +313,9 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	/* STAT_PHASE_0: Init and sanity checks */
 
 #if SSI_CC_HAS_MULTI2
-	/*last byte of key buffer is round number and should not be a part of key size*/
+	/* last byte of key buffer is round number and should not be a part
+	 * of key size
+	 */
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
 		keylen -= 1;
 #endif /*SSI_CC_HAS_MULTI2*/
@@ -341,7 +350,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 					hki->hw_key1, hki->hw_key2);
 				return -EINVAL;
 			}
-			ctx_p->hw.key2_slot = hw_key_to_cc_hw_key(hki->hw_key2);
+			ctx_p->hw.key2_slot =
+				hw_key_to_cc_hw_key(hki->hw_key2);
 			if (unlikely(ctx_p->hw.key2_slot == END_OF_KEYS)) {
 				dev_err(dev, "Unsupported hw key2 number (%d)\n",
 					hki->hw_key2);
@@ -383,7 +393,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
 #if SSI_CC_HAS_MULTI2
 		memcpy(ctx_p->user.key, key, CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE);
-		ctx_p->key_round_number = key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE];
+		ctx_p->key_round_number =
+			key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE];
 		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
 		    ctx_p->key_round_number > CC_MULTI2_MAX_NUM_ROUNDS) {
 			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -393,7 +404,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	} else {
 		memcpy(ctx_p->user.key, key, keylen);
 		if (keylen == 24)
-			memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+			memset(ctx_p->user.key + 24, 0,
+			       CC_AES_KEY_SIZE_MAX - 24);
 
 		if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 			/* sha256 for key2 - use sw implementation */
@@ -403,7 +415,9 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 			desc->tfm = ctx_p->shash_tfm;
 
-			err = crypto_shash_digest(desc, ctx_p->user.key, key_len, ctx_p->user.key + key_len);
+			err = crypto_shash_digest(desc, ctx_p->user.key,
+						  key_len,
+						  ctx_p->user.key + key_len);
 			if (err) {
 				dev_err(dev, "Failed to hash ESSIV key.\n");
 				return err;
@@ -437,11 +451,15 @@ ssi_blkcipher_create_setup_desc(
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
 	unsigned int du_size = nbytes;
 
-	struct ssi_crypto_alg *ssi_alg = container_of(tfm->__crt_alg, struct ssi_crypto_alg, crypto_alg);
+	struct ssi_crypto_alg *ssi_alg =
+		container_of(tfm->__crt_alg, struct ssi_crypto_alg,
+			     crypto_alg);
 
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) == CRYPTO_ALG_BULK_DU_512)
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	    CRYPTO_ALG_BULK_DU_512)
 		du_size = 512;
-	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) == CRYPTO_ALG_BULK_DU_4096)
+	if ((ssi_alg->crypto_alg.cra_flags & CRYPTO_ALG_BULK_MASK) ==
+	    CRYPTO_ALG_BULK_DU_4096)
 		du_size = 4096;
 
 	switch (cipher_mode) {
@@ -765,7 +783,8 @@ static int ssi_blkcipher_process(
 	memcpy(req_ctx->iv, info, ivsize);
 
 	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) && ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
+	if (((nbytes % AES_BLOCK_SIZE) == 0) &&
+	    ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
 	}
@@ -817,10 +836,13 @@ static int ssi_blkcipher_process(
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (!areq) ? 0 : 1);
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len,
+			  (!areq) ? 0 : 1);
 	if (areq) {
 		if (unlikely(rc != -EINPROGRESS)) {
-			/* Failed to send the request or request completed synchronously */
+			/* Failed to send the request or request completed
+			 * synchronously
+			 */
 			cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src,
 						   dst);
 		}
@@ -886,7 +908,10 @@ static int ssi_ablkcipher_encrypt(struct ablkcipher_request *req)
 
 	req_ctx->is_giv = false;
 
-	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
+				     req->nbytes, req->info, ivsize,
+				     (void *)req,
+				     DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
 
 static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
@@ -908,7 +933,10 @@ static int ssi_ablkcipher_decrypt(struct ablkcipher_request *req)
 				 (req->nbytes - ivsize), ivsize, 0);
 	req_ctx->is_giv = false;
 
-	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src, req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
+				     req->nbytes, req->info, ivsize,
+				     (void *)req,
+				     DRV_CRYPTO_DIRECTION_DECRYPT);
 }
 
 /* DX Block cipher alg */
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 25e6335..14c0ad9 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -33,7 +33,10 @@
 #define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
 #define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)
 
-#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
+#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE1 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE2 | \
+					CC_CRYPTO_CIPHER_KEY_KFDE3)
 
 struct blkcipher_req_ctx {
 	struct async_gen_req_ctx gen_ctx;
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index ff7597c..ea74845 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -28,9 +28,11 @@
 //#define DX_DUMP_DESCS
 // #define DX_DUMP_BYTES
 // #define CC_DEBUG
-#define ENABLE_CC_SYSFS		/* Enable sysfs interface for debugging REE driver */
+/* Enable sysfs interface for debugging REE driver */
+#define ENABLE_CC_SYSFS
 //#define DX_IRQ_DELAY 100000
-#define DMA_BIT_MASK_LEN	48	/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
+/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
+#define DMA_BIT_MASK_LEN	48
 
 #endif /*__DX_CONFIG_H__*/
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 8d16823..b17b811 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -112,7 +112,9 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
 	if (likely((irr & SSI_COMP_IRQ_MASK))) {
-		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
+		/* Mask AXI completion interrupt - will be unmasked in
+		 * Deferred service handler
+		 */
 		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
 		irr &= ~SSI_COMP_IRQ_MASK;
 		complete_request(drvdata);
@@ -120,7 +122,9 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
 	if (likely((irr & SSI_GPR0_IRQ_MASK))) {
-		/* Mask interrupt - will be unmasked in Deferred service handler */
+		/* Mask interrupt - will be unmasked in Deferred service
+		 * handler
+		 */
 		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
 		irr &= ~SSI_GPR0_IRQ_MASK;
 		fips_handler(drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 758268e..7c266ff 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -63,8 +63,10 @@
 #define SSI_CC_HAS_MULTI2 0
 #define SSI_CC_HAS_CMAC 1
 
-#define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) |	\
-			(1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_COMPMASK_BIT_SHIFT))
+#define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
+			  (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
+			  (1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
+			  (1 << DX_AXIM_CFG_COMPMASK_BIT_SHIFT))
 
 #define SSI_AXI_ERR_IRQ_MASK BIT(DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
 
@@ -104,8 +106,10 @@ struct ssi_crypto_req {
 	 * generated IV would be placed in it by send_request().
 	 * Same generated IV for all addresses!
 	 */
-	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
-	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
+	/* Amount of 'ivgen_dma_addr' elements to be filled. */
+	unsigned int ivgen_dma_addr_len;
+	/* The generated IV size required, 8/16 B allowed. */
+	unsigned int ivgen_size;
 	struct completion seq_compl; /* request completion */
 };
 
@@ -178,7 +182,8 @@ static inline struct device *drvdata_to_dev(struct ssi_drvdata *drvdata)
 }
 
 #ifdef DX_DUMP_BYTES
-void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
+void dump_byte_array(const char *name, const u8 *the_array,
+		     unsigned long size);
 #else
 static inline void dump_byte_array(const char *name, const u8 *the_array,
 				   unsigned long size) {};
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 63bcca7..8cb1893 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,7 +40,8 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }
 
 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata,
+					  bool ok) {}
 static inline void fips_handler(struct ssi_drvdata *drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 66b011c..4d7e565 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -164,18 +164,21 @@ static int ssi_hash_map_request(struct device *dev,
 	if (!state->buff1)
 		goto fail_buff0;
 
-	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE, GFP_KERNEL | GFP_DMA);
+	state->digest_result_buff = kzalloc(SSI_MAX_HASH_DIGEST_SIZE,
+					    GFP_KERNEL | GFP_DMA);
 	if (!state->digest_result_buff)
 		goto fail_buff1;
 
-	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
+	state->digest_buff = kzalloc(ctx->inter_digestsize,
+				     GFP_KERNEL | GFP_DMA);
 	if (!state->digest_buff)
 		goto fail_digest_result_buff;
 
 	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
 		state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL | GFP_DMA);
+		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE,
+						  GFP_KERNEL | GFP_DMA);
 		if (!state->digest_bytes_len)
 			goto fail1;
 
@@ -185,14 +188,17 @@ static int ssi_hash_map_request(struct device *dev,
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL | GFP_DMA);
+	state->opad_digest_buff = kzalloc(ctx->inter_digestsize,
+					  GFP_KERNEL | GFP_DMA);
 	if (!state->opad_digest_buff)
 		goto fail2;
 
 	dev_dbg(dev, "Allocated opad-digest-buffer in context state->digest_bytes_len=@%p\n",
 		state->opad_digest_buff);
 
-	state->digest_buff_dma_addr = dma_map_single(dev, (void *)state->digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	state->digest_buff_dma_addr =
+		dma_map_single(dev, (void *)state->digest_buff,
+			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
 		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
 			ctx->inter_digestsize, state->digest_buff);
@@ -203,25 +209,39 @@ static int ssi_hash_map_request(struct device *dev,
 		&state->digest_buff_dma_addr);
 
 	if (is_hmac) {
-		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-		if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC || ctx->hw_mode == DRV_CIPHER_CMAC) {
+		dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr,
+					ctx->inter_digestsize,
+					DMA_BIDIRECTIONAL);
+		if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC ||
+		    ctx->hw_mode == DRV_CIPHER_CMAC) {
 			memset(state->digest_buff, 0, ctx->inter_digestsize);
 		} else { /*sha*/
-			memcpy(state->digest_buff, ctx->digest_buff, ctx->inter_digestsize);
+			memcpy(state->digest_buff, ctx->digest_buff,
+			       ctx->inter_digestsize);
 #if (DX_DEV_SHA_MAX > 256)
-			if (unlikely(ctx->hash_mode == DRV_HASH_SHA512 || ctx->hash_mode == DRV_HASH_SHA384))
-				memcpy(state->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
+			if (unlikely(ctx->hash_mode == DRV_HASH_SHA512 ||
+				     ctx->hash_mode == DRV_HASH_SHA384))
+				memcpy(state->digest_bytes_len,
+				       digest_len_sha512_init, HASH_LEN_SIZE);
 			else
-				memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+				memcpy(state->digest_bytes_len,
+				       digest_len_init, HASH_LEN_SIZE);
 #else
-			memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			memcpy(state->digest_bytes_len, digest_len_init,
+			       HASH_LEN_SIZE);
 #endif
 		}
-		dma_sync_single_for_device(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
+					   ctx->inter_digestsize,
+					   DMA_BIDIRECTIONAL);
 
 		if (ctx->hash_mode != DRV_HASH_NULL) {
-			dma_sync_single_for_cpu(dev, ctx->opad_tmp_keys_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-			memcpy(state->opad_digest_buff, ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
+			dma_sync_single_for_cpu(dev,
+						ctx->opad_tmp_keys_dma_addr,
+						ctx->inter_digestsize,
+						DMA_BIDIRECTIONAL);
+			memcpy(state->opad_digest_buff,
+			       ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
 		}
 	} else { /*hash*/
 		/* Copy the initial digests if hash flow. The SRAM contains the
@@ -241,7 +261,9 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		state->digest_bytes_len_dma_addr =
+			dma_map_single(dev, (void *)state->digest_bytes_len,
+				       HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
 				HASH_LEN_SIZE, state->digest_bytes_len);
@@ -255,7 +277,10 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
-		state->opad_digest_dma_addr = dma_map_single(dev, (void *)state->opad_digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		state->opad_digest_dma_addr =
+			dma_map_single(dev, (void *)state->opad_digest_buff,
+				       ctx->inter_digestsize,
+				       DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
 			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
 				ctx->inter_digestsize,
@@ -277,12 +302,14 @@ static int ssi_hash_map_request(struct device *dev,
 
 fail5:
 	if (state->digest_bytes_len_dma_addr) {
-		dma_unmap_single(dev, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
+				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 fail4:
 	if (state->digest_buff_dma_addr) {
-		dma_unmap_single(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_buff_dma_addr,
+				 ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 		state->digest_buff_dma_addr = 0;
 	}
 fail3:
@@ -441,7 +468,9 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		ssi_req.user_arg = (void *)async_req;
 	}
 
-	/* If HMAC then load hash IPAD xor key, if HASH then load initial digest */
+	/* If HMAC then load hash IPAD xor key, if HASH then load initial
+	 * digest
+	 */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	if (is_hmac) {
@@ -1042,8 +1071,9 @@ static int ssi_hash_setkey(void *hash,
 			hw_desc_init(&desc[idx]);
 			set_din_const(&desc[idx], 0, (blocksize - digestsize));
 			set_flow_mode(&desc[idx], BYPASS);
-			set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-						   digestsize),
+			set_dout_dlli(&desc[idx],
+				      (ctx->opad_tmp_keys_dma_addr +
+				       digestsize),
 				      (blocksize - digestsize), NS_BIT, 0);
 			idx++;
 		} else {
@@ -1118,7 +1148,9 @@ static int ssi_hash_setkey(void *hash,
 		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 
-		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest of the first HASH "update" state) */
+		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest
+		 * of the first HASH "update" state)
+		 */
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		if (i > 0) /* Not first iteration */
@@ -1136,7 +1168,8 @@ static int ssi_hash_setkey(void *hash,
 
 out:
 	if (rc)
-		crypto_ahash_set_flags((struct crypto_ahash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_ahash_set_flags((struct crypto_ahash *)hash,
+				       CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
@@ -1257,8 +1290,10 @@ static int ssi_cmac_setkey(struct crypto_ahash *ahash,
 				keylen, DMA_TO_DEVICE);
 
 	memcpy(ctx->opad_tmp_keys_buff, key, keylen);
-	if (keylen == 24)
-		memset(ctx->opad_tmp_keys_buff + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+	if (keylen == 24) {
+		memset(ctx->opad_tmp_keys_buff + 24, 0,
+		       CC_AES_KEY_SIZE_MAX - 24);
+	}
 
 	dma_sync_single_for_device(dev, ctx->opad_tmp_keys_dma_addr,
 				   keylen, DMA_TO_DEVICE);
@@ -1298,7 +1333,9 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 
 	ctx->key_params.keylen = 0;
 
-	ctx->digest_buff_dma_addr = dma_map_single(dev, (void *)ctx->digest_buff, sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
+	ctx->digest_buff_dma_addr =
+		dma_map_single(dev, (void *)ctx->digest_buff,
+			       sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
 		dev_err(dev, "Mapping digest len %zu B at va=%pK for DMA failed\n",
 			sizeof(ctx->digest_buff), ctx->digest_buff);
@@ -1308,7 +1345,10 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 		sizeof(ctx->digest_buff), ctx->digest_buff,
 		&ctx->digest_buff_dma_addr);
 
-	ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
+	ctx->opad_tmp_keys_dma_addr =
+		dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff,
+			       sizeof(ctx->opad_tmp_keys_buff),
+			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
 		dev_err(dev, "Mapping opad digest %zu B at va=%pK for DMA failed\n",
 			sizeof(ctx->opad_tmp_keys_buff),
@@ -1335,7 +1375,8 @@ static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 	struct ahash_alg *ahash_alg =
 		container_of(hash_alg_common, struct ahash_alg, halg);
 	struct ssi_hash_alg *ssi_alg =
-			container_of(ahash_alg, struct ssi_hash_alg, ahash_alg);
+			container_of(ahash_alg, struct ssi_hash_alg,
+				     ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct ahash_req_ctx));
@@ -1473,7 +1514,9 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
-		/* Initiate decryption of block state to previous block_state-XOR-M[n] */
+		/* Initiate decryption of block state to previous
+		 * block_state-XOR-M[n]
+		 */
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
 			     CC_AES_BLOCK_SIZE, NS_BIT);
@@ -1502,7 +1545,8 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else if (rem_cnt > 0) {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
+					  false, &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
 		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
@@ -1579,7 +1623,8 @@ static int ssi_mac_finup(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
+					  false, &idx);
 	}
 
 	/* Get final MAC result */
@@ -1652,7 +1697,8 @@ static int ssi_mac_digest(struct ahash_request *req)
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
-		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
+		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc,
+					  false, &idx);
 	}
 
 	/* Get final MAC result */
@@ -1684,7 +1730,8 @@ static int ssi_ahash_digest(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_digest(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_digest(state, ctx, digestsize, req->src, req->nbytes,
+			       req->result, (void *)req);
 }
 
 static int ssi_ahash_update(struct ahash_request *req)
@@ -1694,7 +1741,8 @@ static int ssi_ahash_update(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	unsigned int block_size = crypto_tfm_alg_blocksize(&tfm->base);
 
-	return ssi_hash_update(state, ctx, block_size, req->src, req->nbytes, (void *)req);
+	return ssi_hash_update(state, ctx, block_size, req->src, req->nbytes,
+			       (void *)req);
 }
 
 static int ssi_ahash_finup(struct ahash_request *req)
@@ -1704,7 +1752,8 @@ static int ssi_ahash_finup(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_finup(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_finup(state, ctx, digestsize, req->src, req->nbytes,
+			      req->result, (void *)req);
 }
 
 static int ssi_ahash_final(struct ahash_request *req)
@@ -1714,7 +1763,8 @@ static int ssi_ahash_final(struct ahash_request *req)
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	return ssi_hash_final(state, ctx, digestsize, req->src, req->nbytes, req->result, (void *)req);
+	return ssi_hash_final(state, ctx, digestsize, req->src, req->nbytes,
+			      req->result, (void *)req);
 }
 
 static int ssi_ahash_init(struct ahash_request *req)
@@ -2176,7 +2226,9 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	larval_seq_len = 0;
 
 #if (DX_DEV_SHA_MAX > 256)
-	/* We are forced to swap each double-word larval before copying to sram */
+	/* We are forced to swap each double-word larval before copying to
+	 * sram
+	 */
 	for (i = 0; i < ARRAY_SIZE(sha384_init); i++) {
 		const u32 const0 = ((u32 *)((u64 *)&sha384_init[i]))[1];
 		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
@@ -2326,7 +2378,8 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	struct ssi_hash_handle *hash_handle = drvdata->hash_handle;
 
 	if (hash_handle) {
-		list_for_each_entry_safe(t_hash_alg, hash_n, &hash_handle->hash_list, entry) {
+		list_for_each_entry_safe(t_hash_alg, hash_n,
+					 &hash_handle->hash_list, entry) {
 			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
 			list_del(&t_hash_alg->entry);
 			kfree(t_hash_alg);
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index c884727..8e6eee5 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -41,7 +41,9 @@
 
 #define CC_EXPORT_MAGIC 0xC2EE1070U
 
-// this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used for xcbc/cmac statesize
+/* this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used
+ * for xcbc/cmac statesize
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
+ *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
  *
  * \return u32 returns the address of the initial digest length in SRAM
  */
@@ -93,7 +96,8 @@ ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode);
  * according to the given hash mode
  *
  * \param drvdata
- * \param mode The Hash mode. Supported modes: MD5/SHA1/SHA224/SHA256/SHA384/SHA512
+ * \param mode The Hash mode. Supported modes:
+ *             MD5/SHA1/SHA224/SHA256/SHA384/SHA512
  *
  * \return u32 The address of the initial digest in SRAM
  */
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 7171796..4ca6ca7 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -228,7 +228,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
  *
  * \param drvdata Driver private context
  * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements
+ *                       of iv_out_dma array are ignore)
  * \param iv_out_size May be 8 or 16 bytes long
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
@@ -257,7 +258,9 @@ int ssi_ivgen_getiv(
 		return -EINVAL;
 	}
 
-	//check that number of generated IV is limited to max dma address iv buffer size
+	/* check that number of generated IV is limited to max dma address
+	 * iv buffer size
+	 */
 	if (iv_out_dma_len > SSI_MAX_IVGEN_DMA_ADDRESSES) {
 		/* The sequence will be longer than allowed */
 		return -EINVAL;
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index 961aea4..fd28309 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -53,7 +53,8 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata);
  *
  * \param drvdata Driver private context
  * \param iv_out_dma Array of physical IV out addresses
- * \param iv_out_dma_len Length of iv_out_dma array (additional elements of iv_out_dma array are ignore)
+ * \param iv_out_dma_len Length of iv_out_dma array (additional elements of
+ *                       iv_out_dma array are ignore)
  * \param iv_out_size May be 8 or 16 bytes long
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index ab18851..001bbe9 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -123,7 +123,8 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
 #else
 	dev_dbg(dev, "Initializing completion tasklet\n");
-	tasklet_init(&req_mgr_h->comptask, comp_handler, (unsigned long)drvdata);
+	tasklet_init(&req_mgr_h->comptask, comp_handler,
+		     (unsigned long)drvdata);
 #endif
 	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
 					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
@@ -138,9 +139,10 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	req_mgr_h->max_used_sw_slots = 0;
 
 	/* Allocate DMA word for "dummy" completion descriptor use */
-	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(dev, sizeof(u32),
-							&req_mgr_h->dummy_comp_buff_dma,
-							GFP_KERNEL);
+	req_mgr_h->dummy_comp_buff =
+		dma_alloc_coherent(dev, sizeof(u32),
+				   &req_mgr_h->dummy_comp_buff_dma,
+				   GFP_KERNEL);
 	if (!req_mgr_h->dummy_comp_buff) {
 		dev_err(dev, "Not enough memory to allocate DMA (%zu) dropped buffer\n",
 			sizeof(u32));
@@ -272,10 +274,10 @@ int send_request(
 	struct cc_hw_desc iv_seq[SSI_IVPOOL_SEQ_LEN];
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc;
-	unsigned int max_required_seq_len = (total_seq_len +
-					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
-					SSI_IVPOOL_SEQ_LEN) +
-					(!is_dout ? 1 : 0));
+	unsigned int max_required_seq_len =
+		(total_seq_len +
+		 ((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
+		  SSI_IVPOOL_SEQ_LEN) + (!is_dout ? 1 : 0));
 
 #if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
@@ -349,13 +351,16 @@ int send_request(
 		total_seq_len += iv_seq_len;
 	}
 
-	used_sw_slots = ((req_mgr_h->req_queue_head - req_mgr_h->req_queue_tail) & (MAX_REQUEST_QUEUE_SIZE - 1));
+	used_sw_slots = ((req_mgr_h->req_queue_head -
+			  req_mgr_h->req_queue_tail) &
+			 (MAX_REQUEST_QUEUE_SIZE - 1));
 	if (unlikely(used_sw_slots > req_mgr_h->max_used_sw_slots))
 		req_mgr_h->max_used_sw_slots = used_sw_slots;
 
 	/* Enqueue request - must be locked with HW lock*/
 	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *ssi_req;
-	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
+				    (MAX_REQUEST_QUEUE_SIZE - 1);
 	/* TODO: Use circ_buf.h ? */
 
 	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
@@ -419,7 +424,8 @@ int send_request_init(
 	unsigned int total_seq_len = len; /*initial sequence length*/
 	int rc = 0;
 
-	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
+	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT.
+	 */
 	rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
 					     total_seq_len);
 	if (unlikely(rc))
@@ -447,7 +453,8 @@ void complete_request(struct ssi_drvdata *drvdata)
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 #ifdef COMP_IN_WQ
-	queue_delayed_work(request_mgr_handle->workq, &request_mgr_handle->compwork, 0);
+	queue_delayed_work(request_mgr_handle->workq,
+			   &request_mgr_handle->compwork, 0);
 #else
 	tasklet_schedule(&request_mgr_handle->comptask);
 #endif
@@ -477,7 +484,8 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		request_mgr_handle->axi_completed--;
 
 		/* Dequeue request */
-		if (unlikely(request_mgr_handle->req_queue_head == request_mgr_handle->req_queue_tail)) {
+		if (unlikely(request_mgr_handle->req_queue_head ==
+			     request_mgr_handle->req_queue_tail)) {
 			/* We are supposed to handle a completion but our
 			 * queue is empty. This is not normal. Return and
 			 * hope for the best.
@@ -508,7 +516,9 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 
 		if (likely(ssi_req->user_cb))
 			ssi_req->user_cb(dev, ssi_req->user_arg);
-		request_mgr_handle->req_queue_tail = (request_mgr_handle->req_queue_tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+		request_mgr_handle->req_queue_tail =
+			(request_mgr_handle->req_queue_tail + 1) &
+			(MAX_REQUEST_QUEUE_SIZE - 1);
 		dev_dbg(dev, "Dequeue request tail=%u\n",
 			request_mgr_handle->req_queue_tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
@@ -576,13 +586,14 @@ static void comp_handler(unsigned long devarg)
 }
 
 /*
- * resume the queue configuration - no need to take the lock as this happens inside
- * the spin lock protection
+ * resume the queue configuration - no need to take the lock as this happens
+ * inside the spin lock protection
  */
 #if defined(CONFIG_PM)
 int cc_resume_req_queue(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *request_mgr_handle = drvdata->request_mgr_handle;
+	struct ssi_request_mgr_handle *request_mgr_handle =
+		drvdata->request_mgr_handle;
 
 	spin_lock_bh(&request_mgr_handle->hw_lock);
 	request_mgr_handle->is_runtime_suspended = false;
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index ed97dec..656215b 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -32,15 +32,26 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 	int offset = 0;
 
 	register_value = cc_ioread(drvdata, CC_REG(HOST_SIGNATURE));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ",
+			    DX_HOST_SIGNATURE_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(HOST_IRR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ",
+			    DX_HOST_IRR_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(HOST_POWER_DOWN_EN));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ",
+			    DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
 	register_value =  cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ",
+			    DX_AXIM_MON_ERR_REG_OFFSET, register_value);
 	register_value = cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+			    "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT",
+			    DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET,
+			    register_value);
 	return offset;
 }
 
@@ -48,14 +59,16 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
 	static const char * const help_str[] = {
-				"cat reg_dump              ", "Print several of CC register values",
+				"cat reg_dump              ",
+				"Print several of CC register values",
 				};
 	int i = 0, offset = 0;
 
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
 	for (i = 0; i < ARRAY_SIZE(help_str); i += 2) {
 		offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-				    "%s\t\t%s\n", help_str[i], help_str[i + 1]);
+				    "%s\t\t%s\n", help_str[i],
+				    help_str[i + 1]);
 	}
 
 	return offset;
@@ -84,8 +97,10 @@ static struct kobj_attribute ssi_sys_top_level_attrs[] = {
 	__ATTR(dump_regs, 0444, ssi_sys_regdump_show, NULL),
 	__ATTR(help, 0444, ssi_sys_help_show, NULL),
 #if defined CC_CYCLE_COUNT
-	__ATTR(stats_host, 0664, ssi_sys_stat_host_db_show, ssi_sys_stats_host_db_clear),
-	__ATTR(stats_cc, 0664, ssi_sys_stat_cc_db_show, ssi_sys_stats_cc_db_clear),
+	__ATTR(stats_host, 0664, ssi_sys_stat_host_db_show,
+	       ssi_sys_stats_host_db_clear),
+	__ATTR(stats_cc, 0664, ssi_sys_stat_cc_db_show,
+	       ssi_sys_stats_cc_db_clear),
 #endif
 
 };
-- 
2.7.4
