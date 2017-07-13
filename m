From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/12] staging: ccree: clean up struct ssi_aead_ctx
Date: Thu, 13 Jul 2017 11:19:52 +0300
Message-ID: <1499934004-28513-3-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
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

struct ssi_aead_ctx has some nested structure defined, resulting
in code accessing them to be very unreadable.

Move out the nested structure definitions out of the struct
and use the change to make the code accessing it more readable
and better coding style compliant by shortening lines and
properly matching alignment,

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 108 +++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 99eeeda..fd37dde 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -56,22 +56,26 @@ struct ssi_aead_handle {
 	struct list_head aead_list;
 };
 
+struct cc_hmac_s {
+	u8 *padded_authkey;
+	u8 *ipad_opad; /* IPAD, OPAD*/
+	dma_addr_t padded_authkey_dma_addr;
+	dma_addr_t ipad_opad_dma_addr;
+};
+
+struct cc_xcbc_s {
+	u8 *xcbc_keys; /* K1,K2,K3 */
+	dma_addr_t xcbc_keys_dma_addr;
+};
+
 struct ssi_aead_ctx {
 	struct ssi_drvdata *drvdata;
 	u8 ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
 	u8 *enckey;
 	dma_addr_t enckey_dma_addr;
 	union {
-		struct {
-			u8 *padded_authkey;
-			u8 *ipad_opad; /* IPAD, OPAD*/
-			dma_addr_t padded_authkey_dma_addr;
-			dma_addr_t ipad_opad_dma_addr;
-		} hmac;
-		struct {
-			u8 *xcbc_keys; /* K1,K2,K3 */
-			dma_addr_t xcbc_keys_dma_addr;
-		} xcbc;
+		struct cc_hmac_s hmac;
+		struct cc_xcbc_s xcbc;
 	} auth_state;
 	unsigned int enc_keylen;
 	unsigned int auth_keylen;
@@ -105,33 +109,37 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	}
 
 	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
-		if (ctx->auth_state.xcbc.xcbc_keys) {
+		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
+
+		if (xcbc->xcbc_keys) {
 			dma_free_coherent(dev, CC_AES_128_BIT_KEY_SIZE * 3,
-				ctx->auth_state.xcbc.xcbc_keys,
-				ctx->auth_state.xcbc.xcbc_keys_dma_addr);
+					  xcbc->xcbc_keys,
+					  xcbc->xcbc_keys_dma_addr);
 		}
 		SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=0x%llX\n",
-			(unsigned long long)ctx->auth_state.xcbc.xcbc_keys_dma_addr);
-		ctx->auth_state.xcbc.xcbc_keys_dma_addr = 0;
-		ctx->auth_state.xcbc.xcbc_keys = NULL;
+			      (unsigned long long)xcbc->xcbc_keys_dma_addr);
+		xcbc->xcbc_keys_dma_addr = 0;
+		xcbc->xcbc_keys = NULL;
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
-		if (ctx->auth_state.hmac.ipad_opad) {
+		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
+
+		if (hmac->ipad_opad) {
 			dma_free_coherent(dev, 2 * MAX_HMAC_DIGEST_SIZE,
-				ctx->auth_state.hmac.ipad_opad,
-				ctx->auth_state.hmac.ipad_opad_dma_addr);
+					  hmac->ipad_opad,
+					  hmac->ipad_opad_dma_addr);
 			SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=0x%llX\n",
-				(unsigned long long)ctx->auth_state.hmac.ipad_opad_dma_addr);
-			ctx->auth_state.hmac.ipad_opad_dma_addr = 0;
-			ctx->auth_state.hmac.ipad_opad = NULL;
+				      (unsigned long long)hmac->ipad_opad_dma_addr);
+			hmac->ipad_opad_dma_addr = 0;
+			hmac->ipad_opad = NULL;
 		}
-		if (ctx->auth_state.hmac.padded_authkey) {
+		if (hmac->padded_authkey) {
 			dma_free_coherent(dev, MAX_HMAC_BLOCK_SIZE,
-				ctx->auth_state.hmac.padded_authkey,
-				ctx->auth_state.hmac.padded_authkey_dma_addr);
+					  hmac->padded_authkey,
+					  hmac->padded_authkey_dma_addr);
 			SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=0x%llX\n",
-				(unsigned long long)ctx->auth_state.hmac.padded_authkey_dma_addr);
-			ctx->auth_state.hmac.padded_authkey_dma_addr = 0;
-			ctx->auth_state.hmac.padded_authkey = NULL;
+				(unsigned long long)hmac->padded_authkey_dma_addr);
+			hmac->padded_authkey_dma_addr = 0;
+			hmac->padded_authkey = NULL;
 		}
 	}
 }
@@ -165,31 +173,42 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	/* Set default authlen value */
 
 	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) { /* XCBC authetication */
+		struct cc_xcbc_s *xcbc = &ctx->auth_state.xcbc;
+		const unsigned int key_size = CC_AES_128_BIT_KEY_SIZE * 3;
+
 		/* Allocate dma-coherent buffer for XCBC's K1+K2+K3 */
 		/* (and temporary for user key - up to 256b) */
-		ctx->auth_state.xcbc.xcbc_keys = dma_alloc_coherent(dev,
-			CC_AES_128_BIT_KEY_SIZE * 3,
-			&ctx->auth_state.xcbc.xcbc_keys_dma_addr, GFP_KERNEL);
-		if (!ctx->auth_state.xcbc.xcbc_keys) {
+		xcbc->xcbc_keys = dma_alloc_coherent(dev, key_size,
+						     &xcbc->xcbc_keys_dma_addr,
+						     GFP_KERNEL);
+		if (!xcbc->xcbc_keys) {
 			SSI_LOG_ERR("Failed allocating buffer for XCBC keys\n");
 			goto init_failed;
 		}
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC authentication */
+		struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
+		const unsigned int digest_size = 2 * MAX_HMAC_DIGEST_SIZE;
+		dma_addr_t *pkey_dma = &hmac->padded_authkey_dma_addr;
+
 		/* Allocate dma-coherent buffer for IPAD + OPAD */
-		ctx->auth_state.hmac.ipad_opad = dma_alloc_coherent(dev,
-			2 * MAX_HMAC_DIGEST_SIZE,
-			&ctx->auth_state.hmac.ipad_opad_dma_addr, GFP_KERNEL);
-		if (!ctx->auth_state.hmac.ipad_opad) {
+		hmac->ipad_opad = dma_alloc_coherent(dev, digest_size,
+						     &hmac->ipad_opad_dma_addr,
+						     GFP_KERNEL);
+
+		if (!hmac->ipad_opad) {
 			SSI_LOG_ERR("Failed allocating IPAD/OPAD buffer\n");
 			goto init_failed;
 		}
+
 		SSI_LOG_DEBUG("Allocated authkey buffer in context ctx->authkey=@%p\n",
-			ctx->auth_state.hmac.ipad_opad);
+			      hmac->ipad_opad);
+
+		hmac->padded_authkey = dma_alloc_coherent(dev,
+							  MAX_HMAC_BLOCK_SIZE,
+							  pkey_dma,
+							  GFP_KERNEL);
 
-		ctx->auth_state.hmac.padded_authkey = dma_alloc_coherent(dev,
-			MAX_HMAC_BLOCK_SIZE,
-			&ctx->auth_state.hmac.padded_authkey_dma_addr, GFP_KERNEL);
-		if (!ctx->auth_state.hmac.padded_authkey) {
+		if (!hmac->padded_authkey) {
 			SSI_LOG_ERR("failed to allocate padded_authkey\n");
 			goto init_failed;
 		}
@@ -295,6 +314,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 			DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
 			CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
+	struct cc_hmac_s *hmac = &ctx->auth_state.hmac;
 
 	int idx = 0;
 	int i;
@@ -331,7 +351,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 		/* Perform HASH update */
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
-			     ctx->auth_state.hmac.padded_authkey_dma_addr,
+			     hmac->padded_authkey_dma_addr,
 			     SHA256_BLOCK_SIZE, NS_BIT);
 		set_cipher_mode(&desc[idx], hash_mode);
 		set_xor_active(&desc[idx]);
@@ -342,8 +362,8 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hash_mode);
 		set_dout_dlli(&desc[idx],
-			      (ctx->auth_state.hmac.ipad_opad_dma_addr +
-			       digest_ofs), digest_size, NS_BIT, 0);
+			      (hmac->ipad_opad_dma_addr + digest_ofs),
+			      digest_size, NS_BIT, 0);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
-- 
2.1.4
