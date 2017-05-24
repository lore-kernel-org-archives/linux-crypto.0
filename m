From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 23/27] Drivers: ccree: ssi_aead.c - align block comments
Date: Wed, 24 May 2017 16:46:51 +1200
Message-ID: <20170524044651.30932-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_aead.c | 45 ++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 26afa8794668..ecf9ff2ae336 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -250,7 +250,8 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 				"(auth-size=%d, cipher=%d).\n",
 				ctx->authsize, ctx->cipher_mode);
 			/* In case of payload authentication failure, MUST NOT
-			   revealed the decrypted message --> zero its memory. */
+			 * revealed the decrypted message --> zero its memory.
+			 */
 			ssi_buffer_mgr_zero_sgl(areq->dst, areq_ctx->cryptlen);
 			err = -EBADMSG;
 		}
@@ -279,7 +280,8 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	/* Load the AES key */
 	HW_DESC_INIT(&desc[0]);
 	/* We are using for the source/user key the same buffer as for the output keys,
-	   because after this key loading it is not needed anymore */
+	 * because after this key loading it is not needed anymore
+	 */
 	HW_DESC_SET_DIN_TYPE(&desc[0], DMA_DLLI, ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen, NS_BIT);
 	HW_DESC_SET_CIPHER_MODE(&desc[0], DRV_CIPHER_ECB);
 	HW_DESC_SET_CIPHER_CONFIG0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
@@ -420,8 +422,9 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
 
 	return 0; /* All tests of keys sizes passed */
 }
-/*This function prepers the user key so it can pass to the hmac processing
-  (copy to intenral buffer or hash in case of key longer than block */
+/* This function prepers the user key so it can pass to the hmac processing
+ * (copy to intenral buffer or hash in case of key longer than block
+ */
 static int
 ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
@@ -600,7 +603,8 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 			    (AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE))
 				goto badkey;
 			/* Copy nonce from last 4 bytes in CTR key to
-			*  first 4 bytes in CTR IV */
+			 *  first 4 bytes in CTR IV
+			 */
 			memcpy(ctx->ctr_nonce, key + ctx->auth_keylen + ctx->enc_keylen -
 				CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
 			/* Set CTR key size */
@@ -829,7 +833,8 @@ ssi_aead_process_authenc_data_desc(
 	{
 		/* DOUBLE-PASS flow (as default)
 		 * assoc. + iv + data -compact in one table
-		 * if assoclen is ZERO only IV perform */
+		 * if assoclen is ZERO only IV perform
+		 */
 		ssi_sram_addr_t mlli_addr = areq_ctx->assoc.sram_addr;
 		u32 mlli_nents = areq_ctx->assoc.mlli_nents;
 
@@ -1287,7 +1292,8 @@ static inline void ssi_aead_hmac_authenc(
 	/**
 	 * Double-pass flow
 	 * Fallback for unsupported single-pass modes,
-	 * i.e. using assoc. data of non-word-multiple */
+	 * i.e. using assoc. data of non-word-multiple
+	 */
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* encrypt first.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
@@ -1305,7 +1311,8 @@ static inline void ssi_aead_hmac_authenc(
 		/* decrypt after.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
-		   must be after the cipher operation */
+		 * must be after the cipher operation
+		 */
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 	}
 }
@@ -1338,7 +1345,8 @@ ssi_aead_xcbc_authenc(
 	/**
 	 * Double-pass flow
 	 * Fallback for unsupported single-pass modes,
-	 * i.e. using assoc. data of non-word-multiple */
+	 * i.e. using assoc. data of non-word-multiple
+	 */
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* encrypt first.. */
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
@@ -1353,7 +1361,8 @@ ssi_aead_xcbc_authenc(
 		/* decrypt after..*/
 		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
-		   must be after the cipher operation */
+		 * must be after the cipher operation
+		 */
 		ssi_aead_process_digest_result_desc(req, desc, seq_size);
 	}
 }
@@ -1712,8 +1721,10 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	idx++;
 
 	/* Configure Hash Engine to work with GHASH.
-	   Since it was not possible to extend HASH submodes to add GHASH,
-	   The following command is necessary in order to select GHASH (according to HW designers)*/
+	 * Since it was not possible to extend HASH submodes to add GHASH,
+	 * The following command is necessary in order to
+	 * select GHASH (according to HW designers)
+	 */
 	HW_DESC_INIT(&desc[idx]);
 	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
 	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
@@ -2044,7 +2055,8 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 
 	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
 		/* Build CTR IV - Copy nonce from last 4 bytes in
-		*  CTR key to first 4 bytes in CTR IV */
+		 * CTR key to first 4 bytes in CTR IV
+		 */
 		memcpy(areq_ctx->ctr_iv, ctx->ctr_nonce, CTR_RFC3686_NONCE_SIZE);
 		if (areq_ctx->backup_giv == NULL) /*User none-generated IV*/
 			memcpy(areq_ctx->ctr_iv + CTR_RFC3686_NONCE_SIZE,
@@ -2106,9 +2118,10 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 			ssi_req.ivgen_dma_addr_len = 1;
 		} else if (ctx->cipher_mode == DRV_CIPHER_CCM) {
 			/* In ccm, the IV needs to exist both inside B0 and inside the counter.
-			   It is also copied to iv_dma_addr for other reasons (like returning
-			   it to the user).
-			   So, using 3 (identical) IV outputs. */
+			 * It is also copied to iv_dma_addr for other reasons (like returning
+			 * it to the user).
+			 * So, using 3 (identical) IV outputs.
+			 */
 			ssi_req.ivgen_dma_addr[0] = areq_ctx->gen_ctx.iv_dma_addr + CCM_BLOCK_IV_OFFSET;
 			ssi_req.ivgen_dma_addr[1] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_B0_OFFSET          + CCM_BLOCK_IV_OFFSET;
 			ssi_req.ivgen_dma_addr[2] = sg_dma_address(&areq_ctx->ccm_adata_sg) + CCM_CTR_COUNT_0_OFFSET + CCM_BLOCK_IV_OFFSET;
-- 
2.12.2
