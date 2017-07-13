From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/12] staging: ccree: CamelCase to snake_case in func vars
Date: Thu, 13 Jul 2017 11:19:56 +0300
Message-ID: <1499934004-28513-7-git-send-email-gilad@benyossef.com>
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

Turn local vars and function parameters names in CamelCase
to snake_case.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c       | 26 +++++++++++++-------------
 drivers/staging/ccree/ssi_buffer_mgr.c | 15 ++++++++-------
 drivers/staging/ccree/ssi_hash.c       | 29 +++++++++++++++--------------
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 2d6ba8d..6d5cf02 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -307,7 +307,7 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 
 static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 {
-	unsigned int hmacPadConst[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
+	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	unsigned int digest_ofs = 0;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
 			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
@@ -341,7 +341,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 
 		/* Prepare ipad key */
 		hw_desc_init(&desc[idx]);
-		set_xor_val(&desc[idx], hmacPadConst[i]);
+		set_xor_val(&desc[idx], hmac_pad_const[i]);
 		set_cipher_mode(&desc[idx], hash_mode);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
@@ -1381,27 +1381,27 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 }
 
 #if SSI_CC_HAS_AES_CCM
-static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
+static unsigned int format_ccm_a0(u8 *pa0_buff, u32 header_size)
 {
 	unsigned int len = 0;
 
-	if (headerSize == 0)
+	if (header_size == 0)
 		return 0;
 
-	if (headerSize < ((1UL << 16) - (1UL << 8))) {
+	if (header_size < ((1UL << 16) - (1UL << 8))) {
 		len = 2;
 
-		pA0Buff[0] = (headerSize >> 8) & 0xFF;
-		pA0Buff[1] = headerSize & 0xFF;
+		pa0_buff[0] = (header_size >> 8) & 0xFF;
+		pa0_buff[1] = header_size & 0xFF;
 	} else {
 		len = 6;
 
-		pA0Buff[0] = 0xFF;
-		pA0Buff[1] = 0xFE;
-		pA0Buff[2] = (headerSize >> 24) & 0xFF;
-		pA0Buff[3] = (headerSize >> 16) & 0xFF;
-		pA0Buff[4] = (headerSize >> 8) & 0xFF;
-		pA0Buff[5] = headerSize & 0xFF;
+		pa0_buff[0] = 0xFF;
+		pa0_buff[1] = 0xFE;
+		pa0_buff[2] = (header_size >> 24) & 0xFF;
+		pa0_buff[3] = (header_size >> 16) & 0xFF;
+		pa0_buff[4] = (header_size >> 8) & 0xFF;
+		pa0_buff[5] = header_size & 0xFF;
 	}
 
 	return len;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index ed3945b..b707cbc 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -182,8 +182,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 }
 
 static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
-	struct scatterlist *sgl, u32 sgl_data_len, u32 sglOffset, u32 *curr_nents,
-	u32 **mlli_entry_pp)
+	struct scatterlist *sgl, u32 sgl_data_len, u32 sgl_offset,
+	u32 *curr_nents, u32 **mlli_entry_pp)
 {
 	struct scatterlist *curr_sgl = sgl;
 	u32 *mlli_entry_p = *mlli_entry_pp;
@@ -192,16 +192,17 @@ static inline int ssi_buffer_mgr_render_scatterlist_to_mlli(
 	for ( ; (curr_sgl) && (sgl_data_len != 0);
 	      curr_sgl = sg_next(curr_sgl)) {
 		u32 entry_data_len =
-			(sgl_data_len > sg_dma_len(curr_sgl) - sglOffset) ?
-				sg_dma_len(curr_sgl) - sglOffset : sgl_data_len;
+			(sgl_data_len > sg_dma_len(curr_sgl) - sgl_offset) ?
+				sg_dma_len(curr_sgl) - sgl_offset :
+				sgl_data_len;
 		sgl_data_len -= entry_data_len;
 		rc = ssi_buffer_mgr_render_buff_to_mlli(
-			sg_dma_address(curr_sgl) + sglOffset, entry_data_len, curr_nents,
-			&mlli_entry_p);
+			sg_dma_address(curr_sgl) + sgl_offset, entry_data_len,
+			curr_nents, &mlli_entry_p);
 		if (rc != 0)
 			return rc;
 
-		sglOffset = 0;
+		sgl_offset = 0;
 	}
 	*mlli_entry_pp = mlli_entry_p;
 	return 0;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index d0c8a8d..9c9c48b 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -965,7 +965,7 @@ static int ssi_hash_setkey(void *hash,
 			   unsigned int keylen,
 			   bool synchronize)
 {
-	unsigned int hmacPadConst[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
+	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	struct ssi_crypto_req ssi_req = {};
 	struct ssi_hash_ctx *ctx = NULL;
 	int blocksize = 0;
@@ -1106,7 +1106,7 @@ static int ssi_hash_setkey(void *hash,
 
 		/* Prepare ipad key */
 		hw_desc_init(&desc[idx]);
-		set_xor_val(&desc[idx], hmacPadConst[i]);
+		set_xor_val(&desc[idx], hmac_pad_const[i]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
@@ -1436,18 +1436,19 @@ static int ssi_mac_final(struct ahash_request *req)
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	int idx = 0;
 	int rc = 0;
-	u32 keySize, keyLen;
+	u32 key_size, key_len;
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
 	u32 rem_cnt = state->buff_index ? state->buff1_cnt :
 			state->buff0_cnt;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
-		keySize = CC_AES_128_BIT_KEY_SIZE;
-		keyLen  = CC_AES_128_BIT_KEY_SIZE;
+		key_size = CC_AES_128_BIT_KEY_SIZE;
+		key_len  = CC_AES_128_BIT_KEY_SIZE;
 	} else {
-		keySize = (ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE : ctx->key_params.keylen;
-		keyLen =  ctx->key_params.keylen;
+		key_size = (ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
+			ctx->key_params.keylen;
+		key_len =  ctx->key_params.keylen;
 	}
 
 	SSI_LOG_DEBUG("===== final  xcbc reminder (%d) ====\n", rem_cnt);
@@ -1473,8 +1474,8 @@ static int ssi_mac_final(struct ahash_request *req)
 		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
 		set_din_type(&desc[idx], DMA_DLLI,
 			     (ctx->opad_tmp_keys_dma_addr +
-			      XCBC_MAC_K1_OFFSET), keySize, NS_BIT);
-		set_key_size_aes(&desc[idx], keyLen);
+			      XCBC_MAC_K1_OFFSET), key_size, NS_BIT);
+		set_key_size_aes(&desc[idx], key_len);
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -1503,7 +1504,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	if (state->xcbc_count == 0) {
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_key_size_aes(&desc[idx], keyLen);
+		set_key_size_aes(&desc[idx], key_len);
 		set_cmac_size0_mode(&desc[idx]);
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
@@ -1616,7 +1617,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
-	u32 keyLen;
+	u32 key_len;
 	int idx = 0;
 	int rc;
 
@@ -1641,17 +1642,17 @@ static int ssi_mac_digest(struct ahash_request *req)
 	ssi_req.user_arg = (void *)req;
 
 	if (ctx->hw_mode == DRV_CIPHER_XCBC_MAC) {
-		keyLen = CC_AES_128_BIT_KEY_SIZE;
+		key_len = CC_AES_128_BIT_KEY_SIZE;
 		ssi_hash_create_xcbc_setup(req, desc, &idx);
 	} else {
-		keyLen = ctx->key_params.keylen;
+		key_len = ctx->key_params.keylen;
 		ssi_hash_create_cmac_setup(req, desc, &idx);
 	}
 
 	if (req->nbytes == 0) {
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_key_size_aes(&desc[idx], keyLen);
+		set_key_size_aes(&desc[idx], key_len);
 		set_cmac_size0_mode(&desc[idx]);
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
-- 
2.1.4
