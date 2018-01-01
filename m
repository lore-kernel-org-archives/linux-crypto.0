From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 20/26] staging: ccree: fix indentation of func params
Date: Mon,  1 Jan 2018 12:06:47 +0000
Message-ID: <1514808421-21993-21-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix indentation of some function params in hash code for
better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 46 +++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 7118d30..d263934 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -109,8 +109,7 @@ static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
 {
 	state->digest_result_dma_addr =
 		dma_map_single(dev, state->digest_result_buff,
-			       digestsize,
-			       DMA_BIDIRECTIONAL);
+			       digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_result_dma_addr)) {
 		dev_err(dev, "Mapping digest result buffer %u B for DMA failed\n",
 			digestsize);
@@ -264,16 +263,12 @@ static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
 			    unsigned int digestsize, u8 *result)
 {
 	if (state->digest_result_dma_addr) {
-		dma_unmap_single(dev,
-				 state->digest_result_dma_addr,
-				 digestsize,
-				  DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_result_dma_addr, digestsize,
+				 DMA_BIDIRECTIONAL);
 		dev_dbg(dev, "unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
 			state->digest_result_buff,
 			&state->digest_result_dma_addr, digestsize);
-		memcpy(result,
-		       state->digest_result_buff,
-		       digestsize);
+		memcpy(result, state->digest_result_buff, digestsize);
 	}
 	state->digest_result_dma_addr = 0;
 }
@@ -1100,25 +1095,25 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K1_OFFSET),
-			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K2_OFFSET),
-			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	hw_desc_init(&desc[idx]);
 	set_din_const(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
-	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
-					   XCBC_MAC_K3_OFFSET),
-			       CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
+	set_dout_dlli(&desc[idx],
+		      (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
+		      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
 	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
@@ -1245,8 +1240,7 @@ static int cc_cra_init(struct crypto_tfm *tfm)
 	struct ahash_alg *ahash_alg =
 		container_of(hash_alg_common, struct ahash_alg, halg);
 	struct cc_hash_alg *cc_alg =
-			container_of(ahash_alg, struct cc_hash_alg,
-				     ahash_alg);
+			container_of(ahash_alg, struct cc_hash_alg, ahash_alg);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct ahash_req_ctx));
@@ -1391,8 +1385,8 @@ static int cc_mac_final(struct ahash_request *req)
 		set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
 		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
 		set_din_type(&desc[idx], DMA_DLLI,
-			     (ctx->opad_tmp_keys_dma_addr +
-			      XCBC_MAC_K1_OFFSET), key_size, NS_BIT);
+			     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K1_OFFSET),
+			     key_size, NS_BIT);
 		set_key_size_aes(&desc[idx], key_len);
 		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -2197,8 +2191,8 @@ static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
 
 	/* Setup XCBC MAC K2 */
 	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
-					    XCBC_MAC_K2_OFFSET),
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K2_OFFSET),
 		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
 	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
@@ -2209,8 +2203,8 @@ static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
 
 	/* Setup XCBC MAC K3 */
 	hw_desc_init(&desc[idx]);
-	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
-					    XCBC_MAC_K3_OFFSET),
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->opad_tmp_keys_dma_addr + XCBC_MAC_K3_OFFSET),
 		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
 	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
 	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
-- 
2.7.4
