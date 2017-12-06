From: SUNIL KALLUR RAMEGOWDA <kallur.sunil@gmail.com>
Subject: [PATCH] staging: ccree: ssi_aead: fixed all coding style warnings.
Date: Wed,  6 Dec 2017 23:08:09 +0100
Message-ID: <1512598089-15699-1-git-send-email-kallur.sunil@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33045 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdLFWJp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 17:09:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

My first kernel patch, fixed warnings.

Signed-off-by: SUNIL KALLUR RAMEGOWDA <kallur.sunil@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 179 +++++++++++++++++++++++++++------------
 1 file changed, 123 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ba0954e..afb0036 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -100,7 +100,8 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 
 	/* Unmap enckey buffer */
 	if (ctx->enckey) {
-		dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
+		dma_free_coherent(dev, AES_MAX_KEY_SIZE,
+				  ctx->enckey, ctx->enckey_dma_addr);
 		dev_dbg(dev, "Freed enckey DMA buffer enckey_dma_addr=%pad\n",
 			&ctx->enckey_dma_addr);
 		ctx->enckey_dma_addr = 0;
@@ -225,7 +226,8 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	return -ENOMEM;
 }
 
-static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *cc_base)
+static void ssi_aead_complete(struct device *dev, void *ssi_req,
+			      void __iomem *cc_base)
 {
 	struct aead_request *areq = (struct aead_request *)ssi_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
@@ -258,12 +260,20 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 				 ctx->authsize),
 				SSI_SG_FROM_BUF);
 
-		/* If an IV was generated, copy it back to the user provided buffer. */
+		/* If an IV was generated,
+		 * copy it back to the user provided buffer.
+		 */
 		if (areq_ctx->backup_giv) {
 			if (ctx->cipher_mode == DRV_CIPHER_CTR)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_IV_SIZE);
+				memcpy(areq_ctx->backup_giv,
+				       areq_ctx->ctr_iv +
+					CTR_RFC3686_NONCE_SIZE,
+					CTR_RFC3686_IV_SIZE);
 			else if (ctx->cipher_mode == DRV_CIPHER_CCM)
-				memcpy(areq_ctx->backup_giv, areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, CCM_BLOCK_IV_SIZE);
+				memcpy(areq_ctx->backup_giv,
+				       areq_ctx->ctr_iv +
+					CCM_BLOCK_IV_OFFSET,
+					CCM_BLOCK_IV_SIZE);
 		}
 	}
 
@@ -274,8 +284,8 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 {
 	/* Load the AES key */
 	hw_desc_init(&desc[0]);
-	/* We are using for the source/user key the same buffer as for the output keys,
-	 * because after this key loading it is not needed anymore
+	/* We are using for the source/user key the same buffer as for the
+	 * output keys, because after this key loading it is not needed anymore
 	 */
 	set_din_type(&desc[0], DMA_DLLI,
 		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
@@ -427,7 +437,8 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
  * (copy to intenral buffer or hash in case of key longer than block
  */
 static int
-ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+		       unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -458,9 +469,11 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 	}
 
 	if (likely(keylen != 0)) {
-		key_dma_addr = dma_map_single(dev, (void *)key, keylen, DMA_TO_DEVICE);
+		key_dma_addr = dma_map_single(dev, (void *)key,
+					      keylen, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, key_dma_addr))) {
-			dev_err(dev, "Mapping key va=0x%p len=%u for DMA failed\n",
+			dev_err(dev,
+				"Mapping key va=0x%p len=%u for DMA failed\n",
 				key, keylen);
 			return -ENOMEM;
 		}
@@ -586,7 +599,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			/* Copy nonce from last 4 bytes in CTR key to
 			 *  first 4 bytes in CTR IV
 			 */
-			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen + ctx->enc_keylen -
+			memcpy(ctx->ctr_nonce, key +
+				ctx->auth_keylen + ctx->enc_keylen -
 				CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
 			/* Set CTR key size */
 			ctx->enc_keylen -= CTR_RFC3686_NONCE_SIZE;
@@ -653,7 +667,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm,
+				  const u8 *key, unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
@@ -855,7 +870,8 @@ ssi_aead_process_cipher_data_desc(
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     (sg_dma_address(areq_ctx->src_sgl) +
-			      areq_ctx->src_offset), areq_ctx->cryptlen, NS_BIT);
+			      areq_ctx->src_offset),
+			      areq_ctx->cryptlen, NS_BIT);
 		set_dout_dlli(&desc[idx],
 			      (sg_dma_address(areq_ctx->dst_sgl) +
 			       areq_ctx->dst_offset),
@@ -1255,7 +1271,8 @@ static inline void ssi_aead_hmac_authenc(
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode,
+						  desc, seq_size);
 		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
@@ -1271,14 +1288,16 @@ static inline void ssi_aead_hmac_authenc(
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after..*/
 		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc, seq_size, direct);
+		ssi_aead_process_authenc_data_desc(req, DIN_HASH,
+						   desc, seq_size, direct);
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
@@ -1309,7 +1328,8 @@ ssi_aead_xcbc_authenc(
 		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
 		ssi_aead_setup_cipher_desc(req, desc, seq_size);
 		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, data_flow_mode,
+						  desc, seq_size);
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 		return;
 	}
@@ -1324,12 +1344,14 @@ ssi_aead_xcbc_authenc(
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
@@ -1520,7 +1542,8 @@ static inline int ssi_aead_ccm(
 
 	/* process the cipher */
 	if (req_ctx->cryptlen != 0)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, &idx);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode,
+						  desc, &idx);
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1570,7 +1593,9 @@ static int config_ccm_adata(struct aead_request *req)
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	//unsigned int size_of_a = 0, rem_a_size = 0;
 	unsigned int lp = req->iv[0];
-	/* Note: The code assume that req->iv[0] already contains the value of L' of RFC3610 */
+	/* Note: The code assume that req->iv[0] already
+	 * contains the value of L' of RFC3610
+	 */
 	unsigned int l = lp + 1;  /* This is L' of RFC 3610. */
 	unsigned int m = ctx->authsize;  /* This is M' of RFC 3610. */
 	u8 *b0 = req_ctx->ccm_config + CCM_B0_OFFSET;
@@ -1627,11 +1652,18 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 	/* L' */
 	memset(areq_ctx->ctr_iv, 0, AES_BLOCK_SIZE);
-	areq_ctx->ctr_iv[0] = 3;  /* For RFC 4309, always use 4 bytes for message length (at most 2^32-1 bytes). */
+	/* For RFC 4309, always use 4 bytes for message
+	 * length (at most 2^32-1 bytes).
+	 */
+	areq_ctx->ctr_iv[0] = 3;
 
-	/* In RFC 4309 there is an 11-bytes nonce+IV part, that we build here. */
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET, ctx->ctr_nonce, CCM_BLOCK_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,    req->iv,        CCM_BLOCK_IV_SIZE);
+	/* In RFC 4309 there is an 11-bytes nonce+IV part,
+	 * that we build here.
+	 */
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_NONCE_OFFSET,
+	       ctx->ctr_nonce, CCM_BLOCK_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET,
+	       req->iv, CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
 	req->assoclen -= CCM_BLOCK_IV_SIZE;
 }
@@ -1703,7 +1735,9 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
+	/* Load GHASH initial STATE (which is 0).
+	 * (for any hash there is an initial state)
+	 */
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
 	set_dout_no_dma(&desc[idx], 0, 0, 1);
@@ -1738,7 +1772,8 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	if ((req_ctx->cryptlen != 0) && (!req_ctx->plaintext_authenticate_only)) {
+	if (req_ctx->cryptlen != 0 &&
+	    !req_ctx->plaintext_authenticate_only) {
 		/* load AES/CTR initial CTR value inc by 2*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
@@ -1779,7 +1814,7 @@ static inline void ssi_aead_process_gcm_result_desc(
 	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
-	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
+	/* Store GHASH state after GHASH(Associated Data + Cipher+LenBlock) */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
 	set_din_no_dma(&desc[idx], 0, 0xfffff0);
@@ -1854,7 +1889,8 @@ static inline int ssi_aead_gcm(
 	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
 	if (req_ctx->cryptlen != 0)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
+		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode,
+						  desc, seq_size);
 	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 
 	return 0;
@@ -1873,11 +1909,13 @@ static inline void ssi_aead_dump_gcm(
 		return;
 
 	if (title) {
-		dev_dbg(dev, "----------------------------------------------------------------------------------");
+		dev_dbg(dev, "-----------------------------------------------
+			-----------------------------------");
 		dev_dbg(dev, "%s\n", title);
 	}
 
-	dev_dbg(dev, "cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n",
+	dev_dbg(dev, "cipher_mode %d, authsize %d, enc_keylen %d,
+		assoclen %d, cryptlen %d\n",
 		ctx->cipher_mode, ctx->authsize, ctx->enc_keylen,
 		req->assoclen, req_ctx->cryptlen);
 
@@ -1894,13 +1932,16 @@ static inline void ssi_aead_dump_gcm(
 
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
 
@@ -1938,10 +1979,14 @@ static int config_gcm_context(struct aead_request *req)
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
-	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
+	} else {
+		/* rfc4543=>  all data(AAD,IV,Plain) are considered
+		 * additional data that is nothing is encrypted.
+		 */
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
+		temp64 = cpu_to_be64((req->assoclen +
+					GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1956,15 +2001,18 @@ static void ssi_rfc4_gcm_process(struct aead_request *req)
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET, ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
-	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET,    req->iv, GCM_BLOCK_RFC4_IV_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET,
+	       ctx->ctr_nonce, GCM_BLOCK_RFC4_NONCE_SIZE);
+	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET,
+	       req->iv, GCM_BLOCK_RFC4_IV_SIZE);
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
@@ -1975,7 +2023,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
 
-	dev_dbg(dev, "%s context=%p req=%p iv=%p src=%p src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
+	dev_dbg(dev, "%s context=%p req=%p iv=%p src=%p
+		src_ofs=%d dst=%p dst_ofs=%d cryptolen=%d\n",
 		((direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ? "Enc" : "Dec"),
 		ctx, req, req->iv, sg_virt(req->src), req->src->offset,
 		sg_virt(req->dst), req->dst->offset, req->cryptlen);
@@ -2005,7 +2054,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		/* Build CTR IV - Copy nonce from last 4 bytes in
 		 * CTR key to first 4 bytes in CTR IV
 		 */
-		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
+		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce,
+		       CTR_RFC3686_NONCE_SIZE);
 		if (!areq_ctx->backup_giv) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
 			       req->iv, CTR_RFC3686_IV_SIZE);
@@ -2020,7 +2070,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		   (ctx->cipher_mode == DRV_CIPHER_GCTR)) {
 		areq_ctx->hw_iv_size = AES_BLOCK_SIZE;
 		if (areq_ctx->ctr_iv != req->iv) {
-			memcpy(areq_ctx->ctr_iv, req->iv, crypto_aead_ivsize(tfm));
+			memcpy(areq_ctx->ctr_iv,
+			       req->iv, crypto_aead_ivsize(tfm));
 			req->iv = areq_ctx->ctr_iv;
 		}
 	}  else {
@@ -2031,7 +2082,9 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 		rc = config_ccm_adata(req);
 		if (unlikely(rc != 0)) {
-			dev_dbg(dev, "config_ccm_adata() returned with a failure %d!",
+			dev_dbg(dev,
+				"config_ccm_adata()
+				returned with a failure %d!",
 				rc);
 			goto exit;
 		}
@@ -2046,7 +2099,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 	if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 		rc = config_gcm_context(req);
 		if (unlikely(rc != 0)) {
-			dev_dbg(dev, "config_gcm_context() returned with a failure %d!",
+			dev_dbg(dev, "config_gcm_context()
+				returned with a failure %d!",
 				rc);
 			goto exit;
 		}
@@ -2063,20 +2117,29 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
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
-			 * So, using 3 (identical) IV outputs.
+			/* In ccm, the IV needs to exist both inside B0
+			 * and inside the counter. It is also copied to
+			 * iv_dma_addr for other reasons (like returning
+			 * it to the user). So, using 3 (identical) IV outputs.
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
 
@@ -2231,7 +2294,8 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -2247,7 +2311,8 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsign
 	return ssi_aead_setkey(tfm, key, keylen);
 }
 
-static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				  unsigned int keylen)
 {
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -2724,7 +2789,9 @@ int ssi_aead_free(struct ssi_drvdata *drvdata)
 
 	if (aead_handle) {
 		/* Remove registered algs */
-		list_for_each_entry_safe(t_alg, n, &aead_handle->aead_list, entry) {
+		list_for_each_entry_safe(t_alg, n,
+					 &aead_handle->aead_list,
+					 entry) {
 			crypto_unregister_aead(&t_alg->aead_alg);
 			list_del(&t_alg->entry);
 			kfree(t_alg);
-- 
2.7.4
