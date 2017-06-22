From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/7] staging: ccree: add support for older HW revisions
Date: Thu, 22 Jun 2017 10:07:49 +0300
Message-ID: <1498115276-1601-4-git-send-email-gilad@benyossef.com>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
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

Add support for the older CryptoCell 710 and 630P hardware revisions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig            |   7 +-
 drivers/staging/ccree/cc_crypto_ctx.h    |  16 ---
 drivers/staging/ccree/cc_hw_queue_defs.h |   2 +-
 drivers/staging/ccree/cc_regs.h          |   7 +-
 drivers/staging/ccree/dx_crys_kernel.h   |   1 +
 drivers/staging/ccree/dx_host.h          |   3 +
 drivers/staging/ccree/dx_reg_common.h    |   2 -
 drivers/staging/ccree/ssi_aead.c         |  36 +++--
 drivers/staging/ccree/ssi_cipher.c       |  27 +++-
 drivers/staging/ccree/ssi_config.h       |   2 +-
 drivers/staging/ccree/ssi_driver.c       | 115 ++++++++++-----
 drivers/staging/ccree/ssi_driver.h       |  25 +++-
 drivers/staging/ccree/ssi_fips_ll.c      |  59 ++++----
 drivers/staging/ccree/ssi_hash.c         | 234 +++++++++++++++++--------------
 drivers/staging/ccree/ssi_hash.h         |  10 +-
 drivers/staging/ccree/ssi_request_mgr.c  |  19 ++-
 drivers/staging/ccree/ssi_sram_mgr.c     |  15 +-
 17 files changed, 349 insertions(+), 231 deletions(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 4be87f5..f1e75e8 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -19,9 +19,10 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_XTS
 	help
 	  Say 'Y' to enable a driver for the Arm TrustZone CryptoCell 
-	  C7xx. Currently only the CryptoCell 712 REE is supported.
-	  Choose this if you wish to use hardware acceleration of
-	  cryptographic operations on the system REE.
+	  C7xx. Currently the REE interface of the CryptoCell 712,
+	  710 and 630p are supported. Choose this if you wish to use
+	  hardware acceleration of cryptographic operations on the
+	  system REE.
 	  If unsure say Y.
 
 config CCREE_FIPS_SUPPORT
diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 591f6fd..1542aa7 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -19,17 +19,6 @@
 
 #include <linux/types.h>
 
-/* context size */
-#ifndef CC_CTX_SIZE_LOG2
-#if (CC_SUPPORT_SHA > 256)
-#define CC_CTX_SIZE_LOG2 8
-#else
-#define CC_CTX_SIZE_LOG2 7
-#endif
-#endif
-#define CC_CTX_SIZE BIT(CC_CTX_SIZE_LOG2)
-#define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
-
 #define CC_DRV_DES_IV_SIZE 8
 #define CC_DRV_DES_BLOCK_SIZE 8
 
@@ -72,13 +61,8 @@
 #define CC_SHA384_BLOCK_SIZE 128
 #define CC_SHA512_BLOCK_SIZE 128
 
-#if (CC_SUPPORT_SHA > 256)
 #define CC_DIGEST_SIZE_MAX CC_SHA512_DIGEST_SIZE
 #define CC_HASH_BLOCK_SIZE_MAX CC_SHA512_BLOCK_SIZE /*1024b*/
-#else /* Only up to SHA256 */
-#define CC_DIGEST_SIZE_MAX CC_SHA256_DIGEST_SIZE
-#define CC_HASH_BLOCK_SIZE_MAX CC_SHA256_BLOCK_SIZE /*512b*/
-#endif
 
 #define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
 
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index aaa56c8..c730c3c 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -220,7 +220,7 @@ static inline void hw_desc_init(struct cc_hw_desc *pdesc)
  *
  * @pdesc: pointer HW descriptor struct
  */
-static inline void set_queue_last_ind(struct cc_hw_desc *pdesc)
+static inline void set_queue_last_ind_bit(struct cc_hw_desc *pdesc)
 {
 	pdesc->word[3] |= FIELD_PREP(WORD3_QUEUE_LAST_IND, 1);
 }
diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 4a893a6..62ace81 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -25,12 +25,9 @@
 
 #include <linux/bitfield.h>
 
-#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
-#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+#define AXIM_MON_BASE_712_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
+#define AXIM_MON_BASE_630_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP8)
 
-#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
 #define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
 		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
 		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/dx_crys_kernel.h
index 2196030..0d1d01e 100644
--- a/drivers/staging/ccree/dx_crys_kernel.h
+++ b/drivers/staging/ccree/dx_crys_kernel.h
@@ -131,6 +131,7 @@
 #define DX_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SHIFT	0x0UL
 #define DX_AXIM_MON_INFLIGHTLAST_VALUE_BIT_SIZE	0x8UL
 #define DX_AXIM_MON_COMP_REG_OFFSET	0xB80UL
+#define DX_AXIM_MON_COMP8_REG_OFFSET	0xBA0UL
 #define DX_AXIM_MON_COMP_VALUE_BIT_SHIFT	0x0UL
 #define DX_AXIM_MON_COMP_VALUE_BIT_SIZE	0x10UL
 #define DX_AXIM_MON_ERR_REG_OFFSET	0xBC4UL
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/dx_host.h
index 863c267..b4bdb42 100644
--- a/drivers/staging/ccree/dx_host.h
+++ b/drivers/staging/ccree/dx_host.h
@@ -31,6 +31,9 @@
 #define DX_HOST_IRR_DSCRPTR_WATERMARK_INT_BIT_SIZE	0x1UL
 #define DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT	0x17UL
 #define DX_HOST_IRR_AXIM_COMP_INT_BIT_SIZE	0x1UL
+#define DX_HOST_SEP_SRAM_THRESHOLD_REG_OFFSET   0xA10UL
+#define DX_HOST_SEP_SRAM_THRESHOLD_VALUE_BIT_SHIFT      0x0UL
+#define DX_HOST_SEP_SRAM_THRESHOLD_VALUE_BIT_SIZE       0xCUL
 #define DX_HOST_IMR_REG_OFFSET	0xA04UL
 #define DX_HOST_IMR_NOT_USED_MASK_BIT_SHIFT	0x1UL
 #define DX_HOST_IMR_NOT_USED_MASK_BIT_SIZE	0x1UL
diff --git a/drivers/staging/ccree/dx_reg_common.h b/drivers/staging/ccree/dx_reg_common.h
index d5132ff..f7cec05 100644
--- a/drivers/staging/ccree/dx_reg_common.h
+++ b/drivers/staging/ccree/dx_reg_common.h
@@ -21,6 +21,4 @@
 
 #define CC_HW_VERSION 0xef840015UL
 
-#define DX_DEV_SHA_MAX 512
-
 #endif /*__DX_REG_COMMON_H__*/
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index e8936a3..a1ac345 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -321,7 +321,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hash_mode);
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -456,7 +456,8 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 			/* Load the hash current length*/
 			hw_desc_init(&desc[idx]);
 			set_cipher_mode(&desc[idx], hashmode);
-			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_din_const(&desc[idx], 0,
+				      ctx->drvdata->hash_len_sz);
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 			set_flow_mode(&desc[idx], S_DIN_to_HASH);
 			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -879,7 +880,7 @@ static inline void ssi_aead_process_digest_result_desc(
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		set_dout_dlli(&desc[idx], req_ctx->icv_dma_addr, ctx->authsize,
 			      NS_BIT, 1);
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
 			set_aes_not_hash_mode(&desc[idx]);
 			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
@@ -895,7 +896,7 @@ static inline void ssi_aead_process_digest_result_desc(
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr,
 			      ctx->authsize, NS_BIT, 1);
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 		set_cipher_config0(&desc[idx],
 				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
@@ -1012,7 +1013,7 @@ static inline void ssi_aead_hmac_setup_digest_desc(
 	set_din_sram(&desc[idx],
 		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
 								hash_mode),
-								HASH_LEN_SIZE);
+		     ctx->drvdata->hash_len_sz);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -1113,7 +1114,7 @@ static inline void ssi_aead_process_digest_scheme_desc(
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
 	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		      HASH_LEN_SIZE);
+		      ctx->drvdata->hash_len_sz);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	set_cipher_do(&desc[idx], DO_PAD);
@@ -1145,7 +1146,7 @@ static inline void ssi_aead_process_digest_scheme_desc(
 	set_din_sram(&desc[idx],
 		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
 								hash_mode),
-		     HASH_LEN_SIZE);
+		     ctx->drvdata->hash_len_sz);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -1535,7 +1536,7 @@ static inline int ssi_aead_ccm(
 	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
 		     ctx->authsize, NS_BIT);
 	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
@@ -1791,7 +1792,7 @@ static inline void ssi_aead_process_gcm_result_desc(
 	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
 		     AES_BLOCK_SIZE, NS_BIT);
 	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
@@ -2424,6 +2425,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA1,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(hmac(sha1),cbc(des3_ede))",
@@ -2443,6 +2445,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
 		.auth_mode = DRV_HASH_SHA1,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(hmac(sha256),cbc(aes))",
@@ -2462,6 +2465,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA256,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(hmac(sha256),cbc(des3_ede))",
@@ -2481,6 +2485,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
 		.auth_mode = DRV_HASH_SHA256,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(xcbc(aes),cbc(aes))",
@@ -2500,6 +2505,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_XCBC_MAC,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
@@ -2519,6 +2525,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA1,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
@@ -2538,6 +2545,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_SHA256,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "authenc(xcbc(aes),rfc3686(ctr(aes)))",
@@ -2557,6 +2565,8 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_XCBC_MAC,
+		.min_hw_rev = CC_HW_REV_630,
+
 	},
 #if SSI_CC_HAS_AES_CCM
 	{
@@ -2577,6 +2587,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CCM,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "rfc4309(ccm(aes))",
@@ -2596,6 +2607,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_CCM,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #endif /*SSI_CC_HAS_AES_CCM*/
 #if SSI_CC_HAS_AES_GCM
@@ -2617,6 +2629,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_GCTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "rfc4106(gcm(aes))",
@@ -2636,6 +2649,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_GCTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "rfc4543(gcm(aes))",
@@ -2655,6 +2669,7 @@ static struct ssi_alg_template aead_algs[] = {
 		.cipher_mode = DRV_CIPHER_GCTR,
 		.flow_mode = S_DIN_to_AES,
 		.auth_mode = DRV_HASH_NULL,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #endif /*SSI_CC_HAS_AES_GCM*/
 };
@@ -2739,6 +2754,9 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 
 	/* Linux crypto */
 	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
+		if (aead_algs[alg].min_hw_rev > drvdata->hw_rev)
+			continue;
+
 		t_alg = ssi_aead_create_alg(&aead_algs[alg]);
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 2dfc6a3..e5bb976 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -663,7 +663,7 @@ ssi_blkcipher_create_data_desc(
 		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
 			      nbytes, NS_BIT, (!areq ? 0 : 1));
 		if (areq != NULL) {
-			set_queue_last_ind(&desc[*seq_size]);
+			set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
 		}
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
@@ -712,7 +712,7 @@ ssi_blkcipher_create_data_desc(
 				      (!areq ? 0 : 1));
 		}
 		if (areq != NULL) {
-			set_queue_last_ind(&desc[*seq_size]);
+			set_queue_last_ind(ctx_p->drvdata, &desc[*seq_size]);
 		}
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
@@ -950,6 +950,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "xts(aes)",
@@ -966,6 +967,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "xts(aes)",
@@ -982,6 +984,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 #endif /*SSI_CC_HAS_AES_XTS*/
 #if SSI_CC_HAS_AES_ESSIV
@@ -1000,6 +1003,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "essiv(aes)",
@@ -1016,6 +1020,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "essiv(aes)",
@@ -1032,6 +1037,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 #endif /*SSI_CC_HAS_AES_ESSIV*/
 #if SSI_CC_HAS_AES_BITLOCKER
@@ -1050,6 +1056,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "bitlocker(aes)",
@@ -1066,6 +1073,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "bitlocker(aes)",
@@ -1082,6 +1090,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 #endif /*SSI_CC_HAS_AES_BITLOCKER*/
 	{
@@ -1099,6 +1108,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "cbc(aes)",
@@ -1115,6 +1125,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "ofb(aes)",
@@ -1131,6 +1142,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #if SSI_CC_HAS_AES_CTS
 	{
@@ -1148,6 +1160,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #endif
 	{
@@ -1165,6 +1178,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "cbc(des3_ede)",
@@ -1181,6 +1195,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "ecb(des3_ede)",
@@ -1197,6 +1212,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "cbc(des)",
@@ -1213,6 +1229,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "ecb(des)",
@@ -1229,6 +1246,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #if SSI_CC_HAS_MULTI2
 	{
@@ -1246,6 +1264,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_CBC,
 		.flow_mode = S_DIN_to_MULTI2,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "ofb(multi2)",
@@ -1262,6 +1281,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_OFB,
 		.flow_mode = S_DIN_to_MULTI2,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #endif /*SSI_CC_HAS_MULTI2*/
 };
@@ -1346,6 +1366,9 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 	/* Linux crypto */
 	SSI_LOG_DEBUG("Number of algorithms = %zu\n", ARRAY_SIZE(blkcipher_algs));
 	for (alg = 0; alg < ARRAY_SIZE(blkcipher_algs); alg++) {
+		if (blkcipher_algs[alg].min_hw_rev > drvdata->hw_rev)
+			continue;
+
 		SSI_LOG_DEBUG("creating %s\n", blkcipher_algs[alg].driver_name);
 		t_alg = ssi_ablkcipher_create_alg(&blkcipher_algs[alg]);
 		if (IS_ERR(t_alg)) {
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index b7c0576..2484a06 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -23,7 +23,7 @@
 
 #include <linux/version.h>
 
-#define DISABLE_COHERENT_DMA_OPS
+//#define DISABLE_COHERENT_DMA_OPS
 //#define FLUSH_CACHE_ALL
 //#define COMPLETION_DELAY
 //#define DX_DUMP_DESCS
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1909229..5a62b4f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -71,6 +71,33 @@
 #include "ssi_pm.h"
 #include "ssi_fips_local.h"
 
+struct cc_hw_data {
+	char *name;
+	enum cc_hw_rev rev;
+	u32 sig;
+};
+
+/* Hardware revisions defs. */
+
+static const struct cc_hw_data cc712_hw = {
+	.name = "712", .rev = CC_HW_REV_712, .sig =  0xDCC71200U
+};
+
+static const struct cc_hw_data cc710_hw = {
+	.name = "710", .rev = CC_HW_REV_710, .sig =  0xDCC63200U
+};
+
+static const struct cc_hw_data cc630p_hw = {
+	.name = "630P", .rev = CC_HW_REV_630, .sig = 0xDCC63000U
+};
+
+static const struct of_device_id arm_ccree_dev_of_match[] = {
+	{ .compatible = "arm,cryptocell-712-ree", .data = &cc712_hw },
+	{ .compatible = "arm,cryptocell-710-ree", .data = &cc710_hw },
+	{ .compatible = "arm,cryptocell-630p-ree", .data = &cc630p_hw },
+	{}
+};
+MODULE_DEVICE_TABLE(of, arm_ccree_dev_of_match);
 
 #ifdef DX_DUMP_BYTES
 void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
@@ -185,8 +212,12 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
-	val = (~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK | SSI_GPR0_IRQ_MASK));
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
+	val = (SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK);
+
+	if (drvdata->hw_rev >= CC_HW_REV_712)
+		val |= SSI_GPR0_IRQ_MASK;
+
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), ~val);
 
 #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
 #ifdef DX_IRQ_DELAY
@@ -215,11 +246,15 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 
 static int init_cc_resources(struct platform_device *plat_dev)
 {
-	struct resource *req_mem_cc_regs = NULL;
+	struct resource *cc_regs_res = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
 	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
 	u32 signature_val;
+	struct device *dev = &plat_dev->dev;
+	struct device_node *np = dev->of_node;
+	const struct cc_hw_data *hw_rev;
+	const struct of_device_id *dev_id;
 	int rc = 0;
 
 	if (unlikely(new_drvdata == NULL)) {
@@ -228,6 +263,21 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 
+	dev_id = of_match_node(arm_ccree_dev_of_match, np);
+	if (!dev_id)
+		return -ENODEV;
+	hw_rev = (struct cc_hw_data *)dev_id->data;
+	new_drvdata->hw_rev_name = hw_rev->name;
+	new_drvdata->hw_rev = hw_rev->rev;
+
+	if (hw_rev->rev >= CC_HW_REV_712) {
+		new_drvdata->hash_len_sz = HASH_LEN_SIZE_712;
+		new_drvdata->axim_mon_offset = AXIM_MON_BASE_712_OFFSET;
+	} else {
+		new_drvdata->hash_len_sz = HASH_LEN_SIZE_630;
+		new_drvdata->axim_mon_offset = AXIM_MON_BASE_630_OFFSET;
+	}
+
 	/*Initialize inflight counter used in dx_ablkcipher_secure_complete used for count of BYSPASS blocks operations*/
 	new_drvdata->inflight_counter = 0;
 
@@ -245,8 +295,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		(unsigned long long)new_drvdata->res_mem->start,
 		(unsigned long long)new_drvdata->res_mem->end);
 	/* Map registers space */
-	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
-	if (unlikely(req_mem_cc_regs == NULL)) {
+	cc_regs_res = request_mem_region(new_drvdata->res_mem->start,
+					 resource_size(new_drvdata->res_mem),
+					 "arm_ccree_regs");
+	if (unlikely(!cc_regs_res)) {
 		SSI_LOG_ERR("Couldn't allocate registers memory region at "
 			     "0x%08X\n", (unsigned int)new_drvdata->res_mem->start);
 		rc = -EBUSY;
@@ -271,7 +323,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 	rc = request_irq(new_drvdata->res_irq->start, cc_isr,
-			 IRQF_SHARED, "arm_cc7x", new_drvdata);
+			 IRQF_SHARED, "arm_ccree", new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("Could not register to interrupt %llu\n",
 			(unsigned long long)new_drvdata->res_irq->start);
@@ -297,17 +349,19 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
-	if (signature_val != DX_DEV_SIGNATURE) {
-		SSI_LOG_ERR("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-			signature_val, (u32)DX_DEV_SIGNATURE);
+	if (signature_val != hw_rev->sig) {
+		SSI_LOG_ERR("Signature mismatch: expected 0x%08X got 0x%08X\n",
+			    signature_val, hw_rev->sig);
 		rc = -EINVAL;
 		goto init_cc_res_err;
 	}
 	SSI_LOG_DEBUG("CC SIGNATURE=0x%08X\n", signature_val);
 
 	/* Display HW versions */
-	SSI_LOG(KERN_INFO, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n", SSI_DEV_NAME_STR,
-		CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)), DRV_MODULE_VERSION);
+	SSI_LOG(KERN_INFO, "ARM CryptoCell %s (HW ver 0x%08X, SW version %s)\n",
+		hw_rev->name,
+		CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)),
+		DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
 	if (unlikely(rc != 0)) {
@@ -406,7 +460,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		ssi_sysfs_fini();
 #endif
 
-		if (req_mem_cc_regs != NULL) {
+		if (cc_regs_res) {
 			if (irq_registered) {
 				free_irq(new_drvdata->res_irq->start, new_drvdata);
 				new_drvdata->res_irq = NULL;
@@ -470,7 +524,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
-static int cc7x_probe(struct platform_device *plat_dev)
+static int ccree_probe(struct platform_device *plat_dev)
 {
 	int rc;
 #if defined(CONFIG_ARM) && defined(CC_DEBUG)
@@ -492,54 +546,43 @@ static int cc7x_probe(struct platform_device *plat_dev)
 	if (rc != 0)
 		return rc;
 
-	SSI_LOG(KERN_INFO, "ARM cc7x_ree device initialized\n");
+	SSI_LOG(KERN_INFO, "ARM CryptoCell REE device initialized\n");
 
 	return 0;
 }
 
-static int cc7x_remove(struct platform_device *plat_dev)
+static int ccree_remove(struct platform_device *plat_dev)
 {
-	SSI_LOG_DEBUG("Releasing cc7x resources...\n");
+	SSI_LOG_DEBUG("Releasing resources...\n");
 
 	cleanup_cc_resources(plat_dev);
 
-	SSI_LOG(KERN_INFO, "ARM cc7x_ree device terminated\n");
+	SSI_LOG(KERN_INFO, "ARM CryptoCell REE device unloaded\n");
 
 	return 0;
 }
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
-static struct dev_pm_ops arm_cc7x_driver_pm = {
+static const struct dev_pm_ops arm_ccree_driver_pm = {
 	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
 };
 #endif
 
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
-#define	DX_DRIVER_RUNTIME_PM	(&arm_cc7x_driver_pm)
+#define	DX_DRIVER_RUNTIME_PM	(&arm_ccree_driver_pm)
 #else
 #define	DX_DRIVER_RUNTIME_PM	NULL
 #endif
 
-
-#ifdef CONFIG_OF
-static const struct of_device_id arm_cc7x_dev_of_match[] = {
-	{.compatible = "arm,cryptocell-712-ree"},
-	{}
-};
-MODULE_DEVICE_TABLE(of, arm_cc7x_dev_of_match);
-#endif
-
-static struct platform_driver cc7x_driver = {
+static struct platform_driver ccree_driver = {
 	.driver = {
-		   .name = "cc7xree",
-#ifdef CONFIG_OF
-		   .of_match_table = arm_cc7x_dev_of_match,
-#endif
+		   .name = "ccree",
+		   .of_match_table = arm_ccree_dev_of_match,
 		   .pm = DX_DRIVER_RUNTIME_PM,
 	},
-	.probe = cc7x_probe,
-	.remove = cc7x_remove,
+	.probe = ccree_probe,
+	.remove = ccree_remove,
 };
-module_platform_driver(cc7x_driver);
+module_platform_driver(ccree_driver);
 
 /* Module description */
 MODULE_DESCRIPTION("ARM TrustZone CryptoCell REE Driver");
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 34bd7ef..52ac43c 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -43,7 +43,6 @@
 #include "cc_regs.h"
 #include "dx_reg_common.h"
 #include "cc_hal.h"
-#define CC_SUPPORT_SHA DX_DEV_SHA_MAX
 #include "cc_crypto_ctx.h"
 #include "ssi_sysfs.h"
 #include "hash_defs.h"
@@ -51,9 +50,14 @@
 #include "cc_hw_queue_defs.h"
 #include "ssi_sram_mgr.h"
 
-#define DRV_MODULE_VERSION "3.0"
+#define DRV_MODULE_VERSION "4.0"
+
+enum cc_hw_rev {
+	CC_HW_REV_630 = 630,
+	CC_HW_REV_710 = 710,
+	CC_HW_REV_712 = 712
+};
 
-#define SSI_DEV_NAME_STR "cc715ree"
 #define SSI_CC_HAS_AES_CCM 1
 #define SSI_CC_HAS_AES_GCM 1
 #define SSI_CC_HAS_AES_XTS 1
@@ -90,7 +94,7 @@
 
 /* Logging macros */
 #define SSI_LOG(level, format, ...) \
-	printk(level "cc715ree::%s: " format , __func__, ##__VA_ARGS__)
+	printk(level "ccree::%s: " format, __func__, ##__VA_ARGS__)
 #define SSI_LOG_ERR(format, ...) SSI_LOG(KERN_ERR, format, ##__VA_ARGS__)
 #define SSI_LOG_WARNING(format, ...) SSI_LOG(KERN_WARNING, format, ##__VA_ARGS__)
 #define SSI_LOG_NOTICE(format, ...) SSI_LOG(KERN_NOTICE, format, ##__VA_ARGS__)
@@ -148,7 +152,10 @@ struct ssi_drvdata {
 	void *ivgen_handle;
 	void *sram_mgr_handle;
 	u32 inflight_counter;
-
+	char *hw_rev_name;
+	enum cc_hw_rev hw_rev;
+	u32 hash_len_sz;
+	u32 axim_mon_offset;
 };
 
 struct ssi_crypto_alg {
@@ -176,6 +183,7 @@ struct ssi_alg_template {
 	int cipher_mode;
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
+	u32 min_hw_rev;
 	struct ssi_drvdata *drvdata;
 };
 
@@ -194,5 +202,12 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
 int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct ssi_drvdata *drvdata);
 
+static inline void set_queue_last_ind(struct ssi_drvdata *drvdata,
+				      struct cc_hw_desc *pdesc)
+{
+	if (drvdata->hw_rev >= CC_HW_REV_712)
+		set_queue_last_ind_bit(pdesc);
+}
+
 #endif /*__SSI_DRIVER_H__*/
 
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index cdfbf04..f64177c 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -35,13 +35,11 @@ static const u32 sha1_init[] = {
 static const u32 sha256_init[] = {
 	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
 	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
-#if (CC_SUPPORT_SHA > 256)
 static const u32 digest_len_sha512_init[] = {
 	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
 static const u64 sha512_init[] = {
 	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
-#endif
 
 
 #define NIST_CIPHER_AES_MAX_VECTOR_SIZE      32
@@ -102,7 +100,7 @@ struct fips_hmac_ctx {
 	u8 initial_digest[CC_DIGEST_SIZE_MAX];
 	u8 key[CC_HMAC_BLOCK_SIZE_MAX];
 	u8 k0[CC_HMAC_BLOCK_SIZE_MAX];
-	u8 digest_bytes_len[HASH_LEN_SIZE];
+	u8 digest_bytes_len[HASH_MAX_LEN_SIZE];
 	u8 tmp_digest[CC_DIGEST_SIZE_MAX];
 	u8 din[NIST_HMAC_MSG_SIZE];
 	u8 mac_res[CC_DIGEST_SIZE_MAX];
@@ -213,10 +211,8 @@ static const FipsCipherData FipsCipherDataTable[] = {
 	{ 1, RFC3962_AES_128_KEY,  CC_AES_128_BIT_KEY_SIZE, RFC3962_AES_CBC_CTS_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_CBC_CTS, RFC3962_AES_128_CBC_CTS_CIPHER, RFC3962_AES_PLAIN_DATA, RFC3962_AES_VECTOR_SIZE },
 	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_VECTOR_SIZE },
 	{ 1, NIST_AES_256_XTS_KEY, CC_AES_256_BIT_KEY_SIZE,   NIST_AES_256_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_256_XTS_CIPHER, NIST_AES_256_XTS_PLAIN, NIST_AES_256_XTS_VECTOR_SIZE },
-#if (CC_SUPPORT_SHA > 256)
 	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_VECTOR_SIZE },
 	{ 1, NIST_AES_512_XTS_KEY, 2*CC_AES_256_BIT_KEY_SIZE, NIST_AES_512_XTS_IV,  DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_XTS,     NIST_AES_512_XTS_CIPHER, NIST_AES_512_XTS_PLAIN, NIST_AES_512_XTS_VECTOR_SIZE },
-#endif
 	/* DES */
 	{ 0, NIST_TDES_ECB3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_ECB_IV, DRV_CRYPTO_DIRECTION_ENCRYPT, DRV_CIPHER_ECB, NIST_TDES_ECB3_PLAIN_DATA, NIST_TDES_ECB3_CIPHER, NIST_TDES_VECTOR_SIZE },
 	{ 0, NIST_TDES_ECB3_KEY, CC_DRV_DES_TRIPLE_KEY_SIZE, NIST_TDES_ECB_IV, DRV_CRYPTO_DIRECTION_DECRYPT, DRV_CIPHER_ECB, NIST_TDES_ECB3_CIPHER, NIST_TDES_ECB3_PLAIN_DATA, NIST_TDES_VECTOR_SIZE },
@@ -235,18 +231,16 @@ static const FipsCmacData FipsCmacDataTable[] = {
 static const FipsHashData FipsHashDataTable[] = {
         { DRV_HASH_SHA1,   NIST_SHA_1_MSG,   NIST_SHA_MSG_SIZE, NIST_SHA_1_MD },
         { DRV_HASH_SHA256, NIST_SHA_256_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_256_MD },
-#if (CC_SUPPORT_SHA > 256)
-//        { DRV_HASH_SHA512, NIST_SHA_512_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_512_MD },
-#endif
+	{ DRV_HASH_SHA512, NIST_SHA_512_MSG, NIST_SHA_MSG_SIZE,
+		NIST_SHA_512_MD },
 };
 #define FIPS_HASH_NUM_OF_TESTS        (sizeof(FipsHashDataTable) / sizeof(FipsHashData))
 
 static const FipsHmacData FipsHmacDataTable[] = {
         { DRV_HASH_SHA1,   NIST_HMAC_SHA1_KEY,   NIST_HMAC_SHA1_KEY_SIZE,   NIST_HMAC_SHA1_MSG,   NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA1_MD },
         { DRV_HASH_SHA256, NIST_HMAC_SHA256_KEY, NIST_HMAC_SHA256_KEY_SIZE, NIST_HMAC_SHA256_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA256_MD },
-#if (CC_SUPPORT_SHA > 256)
-//        { DRV_HASH_SHA512, NIST_HMAC_SHA512_KEY, NIST_HMAC_SHA512_KEY_SIZE, NIST_HMAC_SHA512_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA512_MD },
-#endif
+	{ DRV_HASH_SHA512, NIST_HMAC_SHA512_KEY, NIST_HMAC_SHA512_KEY_SIZE,
+		NIST_HMAC_SHA512_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA512_MD },
 };
 #define FIPS_HMAC_NUM_OF_TESTS        (sizeof(FipsHmacDataTable) / sizeof(FipsHmacData))
 
@@ -434,6 +428,11 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 		int rc = 0;
 		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE ;
 
+		/* AES 512 was introduced in 712 */
+		if ((cipherDara->keySize > CC_AES_256_BIT_KEY_SIZE) &&
+		    (drvdata->hw_rev < CC_HW_REV_712))
+			continue;
+
 		memset(cpu_addr_buffer, 0, sizeof(struct fips_cipher_ctx));
 
 		/* copy into the allocated buffer */
@@ -612,10 +611,8 @@ FIPS_HashToFipsError(enum drv_hash_mode hash_mode)
 		return CC_REE_FIPS_ERROR_SHA1_PUT;
 	case DRV_HASH_SHA256:
 		return CC_REE_FIPS_ERROR_SHA256_PUT;
-#if (CC_SUPPORT_SHA > 256)
 	case DRV_HASH_SHA512:
 		return CC_REE_FIPS_ERROR_SHA512_PUT;
-#endif
 	default:
 		return CC_REE_FIPS_ERROR_GENERAL;
 	}
@@ -654,7 +651,7 @@ ssi_hash_fips_run_test(struct ssi_drvdata *drvdata,
 	/* Load the hash current length */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hw_mode);
-	set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+	set_din_const(&desc[idx], 0, drvdata->hash_len_sz);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -726,14 +723,15 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			inter_digestsize = CC_SHA256_DIGEST_SIZE;
 			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
 			break;
-#if (CC_SUPPORT_SHA > 256)
 		case DRV_HASH_SHA512:
+			/* SHA 512 was introduced in CC 712 */
+			if (drvdata->hw_rev < CC_HW_REV_712)
+				continue;
 			hw_mode = DRV_HASH_HW_SHA512;
 			digest_size = CC_SHA512_DIGEST_SIZE;
 			inter_digestsize = CC_SHA512_DIGEST_SIZE;
 			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
 			break;
-#endif
 		default:
 			error = FIPS_HashToFipsError(hash_data->hash_mode);
 			break;
@@ -788,10 +786,8 @@ FIPS_HmacToFipsError(enum drv_hash_mode hash_mode)
 		return CC_REE_FIPS_ERROR_HMAC_SHA1_PUT;
 	case DRV_HASH_SHA256:
 		return CC_REE_FIPS_ERROR_HMAC_SHA256_PUT;
-#if (CC_SUPPORT_SHA > 256)
 	case DRV_HASH_SHA512:
 		return CC_REE_FIPS_ERROR_HMAC_SHA512_PUT;
-#endif
 	default:
 		return CC_REE_FIPS_ERROR_GENERAL;
 	}
@@ -871,7 +867,7 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hw_mode);
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_din_const(&desc[idx], 0, drvdata->hash_len_sz);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -923,7 +919,7 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	/* HW last hash block padding (aka. "DO_PAD") */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hw_mode);
-	set_dout_dlli(&desc[idx], k0_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
+	set_dout_dlli(&desc[idx], k0_dma_addr, drvdata->hash_len_sz, NS_BIT, 0);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	set_cipher_do(&desc[idx], DO_PAD);
@@ -963,7 +959,7 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hw_mode);
 	set_din_type(&desc[idx], DMA_DLLI, digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
+		     drvdata->hash_len_sz, NS_BIT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -1039,27 +1035,32 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			digest_size = CC_SHA1_DIGEST_SIZE;
 			block_size = CC_SHA1_BLOCK_SIZE;
 			inter_digestsize = CC_SHA1_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha1_init, CC_SHA1_DIGEST_SIZE);
-			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha1_init,
+			       CC_SHA1_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len, digest_len_init,
+			       drvdata->hash_len_sz);
 			break;
 		case DRV_HASH_SHA256:
 			hw_mode = DRV_HASH_HW_SHA256;
 			digest_size = CC_SHA256_DIGEST_SIZE;
 			block_size = CC_SHA256_BLOCK_SIZE;
 			inter_digestsize = CC_SHA256_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
-			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha256_init,
+			       CC_SHA256_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len, digest_len_init,
+			       drvdata->hash_len_sz);
 			break;
-#if (CC_SUPPORT_SHA > 256)
 		case DRV_HASH_SHA512:
 			hw_mode = DRV_HASH_HW_SHA512;
 			digest_size = CC_SHA512_DIGEST_SIZE;
 			block_size = CC_SHA512_BLOCK_SIZE;
 			inter_digestsize = CC_SHA512_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
-			memcpy(virt_ctx->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha512_init,
+			       CC_SHA512_DIGEST_SIZE);
+			memcpy(virt_ctx->digest_bytes_len,
+			       digest_len_sha512_init,
+			       drvdata->hash_len_sz);
 			break;
-#endif
 		default:
 			error = FIPS_HmacToFipsError(hmac_data->hash_mode);
 			break;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index f52e1af..623486d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -54,7 +54,6 @@ static const u32 sha224_init[] = {
 static const u32 sha256_init[] = {
 	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
 	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
-#if (DX_DEV_SHA_MAX > 256)
 static const u32 digest_len_sha512_init[] = {
 	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
 static const u64 sha384_init[] = {
@@ -63,7 +62,6 @@ static const u64 sha384_init[] = {
 static const u64 sha512_init[] = {
 	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
-#endif
 
 static void ssi_hash_create_xcbc_setup(
 	struct ahash_request *areq,
@@ -181,7 +179,8 @@ static int ssi_hash_map_request(struct device *dev,
 
 	SSI_LOG_DEBUG("Allocated digest-buffer in context ctx->digest_buff=@%p\n", state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL|GFP_DMA);
+		state->digest_bytes_len = kzalloc(HASH_MAX_LEN_SIZE,
+						  GFP_KERNEL | GFP_DMA);
 		if (!state->digest_bytes_len) {
 			SSI_LOG_ERR("Allocating digest-bytes-len in context failed\n");
 			goto fail1;
@@ -214,15 +213,15 @@ static int ssi_hash_map_request(struct device *dev,
 			memset(state->digest_buff, 0, ctx->inter_digestsize);
 		} else { /*sha*/
 			memcpy(state->digest_buff, ctx->digest_buff, ctx->inter_digestsize);
-#if (DX_DEV_SHA_MAX > 256)
 			if (unlikely((ctx->hash_mode == DRV_HASH_SHA512) || (ctx->hash_mode == DRV_HASH_SHA384))) {
-				memcpy(state->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
+				memcpy(state->digest_bytes_len,
+				       digest_len_sha512_init,
+				       ctx->drvdata->hash_len_sz);
 			} else {
-				memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
+				memcpy(state->digest_bytes_len,
+				       digest_len_init,
+				       ctx->drvdata->hash_len_sz);
 			}
-#else
-			memcpy(state->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
-#endif
 		}
 		dma_sync_single_for_device(dev, state->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 
@@ -248,21 +247,26 @@ static int ssi_hash_map_request(struct device *dev,
 	}
 
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len_dma_addr = dma_map_single(dev, (void *)state->digest_bytes_len, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		state->digest_bytes_len_dma_addr =
+			dma_map_single(dev, (void *)state->digest_bytes_len,
+				       HASH_MAX_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
 			SSI_LOG_ERR("Mapping digest len %u B at va=%pK for DMA failed\n",
-			HASH_LEN_SIZE, state->digest_bytes_len);
+			HASH_MAX_LEN_SIZE, state->digest_bytes_len);
 			goto fail4;
 		}
 		SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=0x%llX\n",
-			HASH_LEN_SIZE, state->digest_bytes_len,
+			HASH_MAX_LEN_SIZE, state->digest_bytes_len,
 			(unsigned long long)state->digest_bytes_len_dma_addr);
 	} else {
 		state->digest_bytes_len_dma_addr = 0;
 	}
 
 	if (is_hmac && ctx->hash_mode != DRV_HASH_NULL) {
-		state->opad_digest_dma_addr = dma_map_single(dev, (void *)state->opad_digest_buff, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+		state->opad_digest_dma_addr =
+			dma_map_single(dev, (void *)state->opad_digest_buff,
+				       ctx->inter_digestsize,
+				       DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
 			SSI_LOG_ERR("Mapping opad digest %d B at va=%pK for DMA failed\n",
 			ctx->inter_digestsize, state->opad_digest_buff);
@@ -283,7 +287,8 @@ static int ssi_hash_map_request(struct device *dev,
 
 fail5:
 	if (state->digest_bytes_len_dma_addr != 0) {
-		dma_unmap_single(dev, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
+				 HASH_MAX_LEN_SIZE, DMA_BIDIRECTIONAL);
 		state->digest_bytes_len_dma_addr = 0;
 	}
 fail4:
@@ -329,7 +334,7 @@ static void ssi_hash_unmap_request(struct device *dev,
 	}
 	if (state->digest_bytes_len_dma_addr != 0) {
 		dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
-				 HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+				 HASH_MAX_LEN_SIZE, DMA_BIDIRECTIONAL);
 		SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=0x%llX\n",
 			(unsigned long long)state->digest_bytes_len_dma_addr);
 		state->digest_bytes_len_dma_addr = 0;
@@ -476,10 +481,11 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 
 	if (is_hmac) {
 		set_din_type(&desc[idx], DMA_DLLI,
-			     state->digest_bytes_len_dma_addr, HASH_LEN_SIZE,
+			     state->digest_bytes_len_dma_addr,
+			     ctx->drvdata->hash_len_sz,
 			     NS_BIT);
 	} else {
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
 		if (likely(nbytes != 0)) {
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		} else {
@@ -497,7 +503,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      HASH_LEN_SIZE, NS_BIT, 0);
+			      ctx->drvdata->hash_len_sz, NS_BIT, 0);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 		set_cipher_do(&desc[idx], DO_PAD);
@@ -527,7 +533,7 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
 			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+ctx->drvdata, ctx->hash_mode), ctx->drvdata->hash_len_sz);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -554,7 +560,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
@@ -635,7 +641,7 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
+		     ctx->drvdata->hash_len_sz, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -655,9 +661,9 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      HASH_LEN_SIZE, NS_BIT, (async_req ? 1 : 0));
+		      ctx->drvdata->hash_len_sz, NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
@@ -729,7 +735,7 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
+		     ctx->drvdata->hash_len_sz, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -761,7 +767,7 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
 			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+ctx->drvdata, ctx->hash_mode), ctx->drvdata->hash_len_sz);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -787,7 +793,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
@@ -867,7 +873,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     HASH_LEN_SIZE, NS_BIT);
+		     ctx->drvdata->hash_len_sz, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -879,7 +885,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	set_cipher_do(&desc[idx], DO_PAD);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      HASH_LEN_SIZE, NS_BIT, 0);
+		      ctx->drvdata->hash_len_sz, NS_BIT, 0);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	idx++;
@@ -909,7 +915,7 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_din_sram(&desc[idx],
 			     ssi_ahash_get_initial_digest_len_sram_addr(
-ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+ctx->drvdata, ctx->hash_mode), ctx->drvdata->hash_len_sz);
 		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -934,7 +940,7 @@ ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		set_queue_last_ind(&desc[idx]);
+		set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	}
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
@@ -1036,7 +1042,7 @@ static int ssi_hash_setkey(void *hash,
 			/* Load the hash current length*/
 			hw_desc_init(&desc[idx]);
 			set_cipher_mode(&desc[idx], ctx->hw_mode);
-			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 			set_flow_mode(&desc[idx], S_DIN_to_HASH);
 			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -1117,7 +1123,7 @@ static int ssi_hash_setkey(void *hash,
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -1437,7 +1443,7 @@ static int ssi_mac_update(struct ahash_request *req)
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 		      ctx->inter_digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], S_AES_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	idx++;
@@ -1553,7 +1559,7 @@ static int ssi_mac_final(struct ahash_request *req)
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
 		      digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], S_AES_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
@@ -1625,7 +1631,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
 		      digestsize, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], S_AES_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
@@ -1697,7 +1703,7 @@ static int ssi_mac_digest(struct ahash_request *req)
 	hw_desc_init(&desc[idx]);
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
 		      CC_AES_BLOCK_SIZE, NS_BIT, 1);
-	set_queue_last_ind(&desc[idx]);
+	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], S_AES_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
@@ -1789,10 +1795,12 @@ static int ssi_ahash_export(struct ahash_request *req, void *out)
 
 	if (state->digest_bytes_len_dma_addr) {
 		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
-					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
+					ctx->drvdata->hash_len_sz,
+					DMA_BIDIRECTIONAL);
+		memcpy(out, state->digest_bytes_len,
+		       ctx->drvdata->hash_len_sz);
 	}
-	out += HASH_LEN_SIZE;
+	out += ctx->drvdata->hash_len_sz;
 
 	memcpy(out, &curr_buff_cnt, sizeof(u32));
 	out += sizeof(u32);
@@ -1835,10 +1843,11 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 
 	if (state->digest_bytes_len_dma_addr) {
 		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
-					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
-		memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
+					ctx->drvdata->hash_len_sz,
+					DMA_BIDIRECTIONAL);
+		memcpy(state->digest_bytes_len, in, ctx->drvdata->hash_len_sz);
 	}
-	in += HASH_LEN_SIZE;
+	in += ctx->drvdata->hash_len_sz;
 
 	dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
 				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
@@ -1846,7 +1855,8 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 	if (state->digest_bytes_len_dma_addr)
 		dma_sync_single_for_device(dev,
 					   state->digest_bytes_len_dma_addr,
-					   HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+					   ctx->drvdata->hash_len_sz,
+					   DMA_BIDIRECTIONAL);
 
 	state->buff_index = 0;
 
@@ -1883,10 +1893,11 @@ struct ssi_hash_template {
 	int hw_mode;
 	int inter_digestsize;
 	struct ssi_drvdata *drvdata;
+	u32 min_hw_rev;
 };
 
 #define CC_STATE_SIZE(_x) \
-	((_x) + HASH_LEN_SIZE + SSI_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
+	((_x) + HASH_MAX_LEN_SIZE + SSI_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
 
 /* hash descriptors */
 static struct ssi_hash_template driver_hash[] = {
@@ -1915,6 +1926,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_SHA1,
 		.hw_mode = DRV_HASH_HW_SHA1,
 		.inter_digestsize = SHA1_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "sha256",
@@ -1939,6 +1951,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_SHA256,
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.name = "sha224",
@@ -1963,8 +1976,8 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_SHA224,
 		.hw_mode = DRV_HASH_HW_SHA256,
 		.inter_digestsize = SHA256_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
-#if (DX_DEV_SHA_MAX > 256)
 	{
 		.name = "sha384",
 		.driver_name = "sha384-dx",
@@ -1988,6 +2001,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_SHA384,
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
 		.name = "sha512",
@@ -2012,8 +2026,8 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_SHA512,
 		.hw_mode = DRV_HASH_HW_SHA512,
 		.inter_digestsize = SHA512_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_712,
 	},
-#endif
 	{
 		.name = "md5",
 		.driver_name = "md5-dx",
@@ -2037,6 +2051,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_MD5,
 		.hw_mode = DRV_HASH_HW_MD5,
 		.inter_digestsize = MD5_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
 		.mac_name = "xcbc(aes)",
@@ -2059,6 +2074,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_NULL,
 		.hw_mode = DRV_CIPHER_XCBC_MAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #if SSI_CC_HAS_CMAC
 	{
@@ -2082,6 +2098,7 @@ static struct ssi_hash_template driver_hash[] = {
 		.hash_mode = DRV_HASH_NULL,
 		.hw_mode = DRV_CIPHER_CMAC,
 		.inter_digestsize = AES_BLOCK_SIZE,
+		.min_hw_rev = CC_HW_REV_630,
 	},
 #endif
 
@@ -2142,9 +2159,8 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	unsigned int larval_seq_len = 0;
 	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX/sizeof(u32)];
 	int rc = 0;
-#if (DX_DEV_SHA_MAX > 256)
+	bool large_sha_supported = (drvdata->hw_rev >= CC_HW_REV_712);
 	int i;
-#endif
 
 	/* Copy-to-sram digest-len */
 	ssi_sram_mgr_const2sram_desc(digest_len_init, sram_buff_ofs,
@@ -2156,17 +2172,19 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	sram_buff_ofs += sizeof(digest_len_init);
 	larval_seq_len = 0;
 
-#if (DX_DEV_SHA_MAX > 256)
-	/* Copy-to-sram digest-len for sha384/512 */
-	ssi_sram_mgr_const2sram_desc(digest_len_sha512_init, sram_buff_ofs,
-		ARRAY_SIZE(digest_len_sha512_init), larval_seq, &larval_seq_len);
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0))
-		goto init_digest_const_err;
+	if (large_sha_supported) {
+		/* Copy-to-sram digest-len for sha384/512 */
+		ssi_sram_mgr_const2sram_desc(digest_len_sha512_init,
+					     sram_buff_ofs,
+					     ARRAY_SIZE(digest_len_sha512_init),
+					     larval_seq, &larval_seq_len);
+		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+		if (unlikely(rc != 0))
+			goto init_digest_const_err;
 
-	sram_buff_ofs += sizeof(digest_len_sha512_init);
-	larval_seq_len = 0;
-#endif
+		sram_buff_ofs += sizeof(digest_len_sha512_init);
+		larval_seq_len = 0;
+	}
 
 	/* The initial digests offset */
 	hash_handle->larval_digest_sram_addr = sram_buff_ofs;
@@ -2204,43 +2222,53 @@ int ssi_hash_init_sram_digest_consts(struct ssi_drvdata *drvdata)
 	sram_buff_ofs += sizeof(sha256_init);
 	larval_seq_len = 0;
 
-#if (DX_DEV_SHA_MAX > 256)
-	/* We are forced to swap each double-word larval before copying to sram */
-	for (i = 0; i < ARRAY_SIZE(sha384_init); i++) {
-		const u32 const0 = ((u32 *)((u64 *)&sha384_init[i]))[1];
-		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
-
-		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-	}
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0)) {
-		SSI_LOG_ERR("send_request() failed (rc = %d)\n", rc);
-		goto init_digest_const_err;
-	}
-	larval_seq_len = 0;
-
-	for (i = 0; i < ARRAY_SIZE(sha512_init); i++) {
-		const u32 const0 = ((u32 *)((u64 *)&sha512_init[i]))[1];
-		const u32 const1 = ((u32 *)((u64 *)&sha512_init[i]))[0];
-
-		ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-		ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
-			larval_seq, &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-	}
-	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (unlikely(rc != 0)) {
-		SSI_LOG_ERR("send_request() failed (rc = %d)\n", rc);
-		goto init_digest_const_err;
+	if (large_sha_supported) {
+		/* We are forced to swap each double-word larval before
+		 * copying to sram
+		 */
+		for (i = 0; i < ARRAY_SIZE(sha384_init); i++) {
+			const u32 const0 =
+				((u32 *)((u64 *)&sha384_init[i]))[1];
+			const u32 const1 =
+				((u32 *)((u64 *)&sha384_init[i]))[0];
+
+			ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
+						     larval_seq,
+						     &larval_seq_len);
+			sram_buff_ofs += sizeof(u32);
+			ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
+						     larval_seq,
+						     &larval_seq_len);
+			sram_buff_ofs += sizeof(u32);
+		}
+		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("send_request() failed (rc = %d)\n", rc);
+			goto init_digest_const_err;
+		}
+		larval_seq_len = 0;
+
+		for (i = 0; i < ARRAY_SIZE(sha512_init); i++) {
+			const u32 const0 =
+				((u32 *)((u64 *)&sha512_init[i]))[1];
+			const u32 const1 =
+				((u32 *)((u64 *)&sha512_init[i]))[0];
+
+			ssi_sram_mgr_const2sram_desc(&const0, sram_buff_ofs, 1,
+						     larval_seq,
+						     &larval_seq_len);
+			sram_buff_ofs += sizeof(u32);
+			ssi_sram_mgr_const2sram_desc(&const1, sram_buff_ofs, 1,
+						     larval_seq,
+						     &larval_seq_len);
+			sram_buff_ofs += sizeof(u32);
+		}
+		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+		if (unlikely(rc != 0)) {
+			SSI_LOG_ERR("send_request() failed (rc = %d)\n", rc);
+			goto init_digest_const_err;
+		}
 	}
-#endif
 
 init_digest_const_err:
 	return rc;
@@ -2265,16 +2293,16 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	drvdata->hash_handle = hash_handle;
 
 	sram_size_to_alloc = sizeof(digest_len_init) +
-#if (DX_DEV_SHA_MAX > 256)
-			sizeof(digest_len_sha512_init) +
-			sizeof(sha384_init) +
-			sizeof(sha512_init) +
-#endif
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init) +
 			sizeof(sha256_init);
 
+	if (drvdata->hw_rev >= CC_HW_REV_712)
+		sram_size_to_alloc += sizeof(digest_len_sha512_init) +
+					sizeof(sha384_init) +
+					sizeof(sha512_init);
+
 	sram_buff = ssi_sram_mgr_alloc(drvdata, sram_size_to_alloc);
 	if (sram_buff == NULL_SRAM_ADDR) {
 		SSI_LOG_ERR("SRAM pool exhausted\n");
@@ -2299,6 +2327,10 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		struct ssi_hash_alg *t_alg;
 		int hw_mode = driver_hash[alg].hw_mode;
 
+		/* We either support both HASH and MAC or none */
+		if (driver_hash[alg].min_hw_rev > drvdata->hw_rev)
+			continue;
+
 		/* register hmac version */
 		t_alg = ssi_hash_create_alg(&driver_hash[alg], true);
 		if (IS_ERR(t_alg)) {
@@ -2543,7 +2575,6 @@ ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init));
-#if (DX_DEV_SHA_MAX > 256)
 	case DRV_HASH_SHA384:
 		return (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
@@ -2557,7 +2588,6 @@ ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
 			sizeof(sha224_init) +
 			sizeof(sha256_init) +
 			sizeof(sha384_init));
-#endif
 	default:
 		SSI_LOG_ERR("Invalid hash mode (%d)\n", mode);
 	}
@@ -2579,11 +2609,9 @@ ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode)
 	case DRV_HASH_SHA256:
 	case DRV_HASH_MD5:
 		return digest_len_addr;
-#if (DX_DEV_SHA_MAX > 256)
 	case DRV_HASH_SHA384:
 	case DRV_HASH_SHA512:
 		return  digest_len_addr + sizeof(digest_len_init);
-#endif
 	default:
 		return digest_len_addr; /*to avoid kernel crash*/
 	}
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 0bb99cb..1c12ab9 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -25,15 +25,11 @@
 
 #define HMAC_IPAD_CONST	0x36363636
 #define HMAC_OPAD_CONST	0x5C5C5C5C
-#if (DX_DEV_SHA_MAX > 256)
-#define HASH_LEN_SIZE 16
+#define HASH_LEN_SIZE_712 16
+#define HASH_LEN_SIZE_630 8
+#define HASH_MAX_LEN_SIZE HASH_LEN_SIZE_712
 #define SSI_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
 #define SSI_MAX_HASH_BLCK_SIZE SHA512_BLOCK_SIZE
-#else
-#define HASH_LEN_SIZE 8
-#define SSI_MAX_HASH_DIGEST_SIZE	SHA256_DIGEST_SIZE
-#define SSI_MAX_HASH_BLCK_SIZE SHA256_BLOCK_SIZE
-#endif
 
 #define XCBC_MAC_K1_OFFSET 0
 #define XCBC_MAC_K2_OFFSET 16
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 7c2d88a..cffc8de 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -152,7 +152,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	set_dout_dlli(&req_mgr_h->compl_desc, req_mgr_h->dummy_comp_buff_dma,
 		      sizeof(u32), NS_BIT, 1);
 	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
-	set_queue_last_ind(&req_mgr_h->compl_desc);
+	set_queue_last_ind(drvdata, &req_mgr_h->compl_desc);
 
 	return 0;
 
@@ -414,7 +414,7 @@ int send_request_init(
 	if (unlikely(rc != 0 )) {
 		return rc;
 	}
-	set_queue_last_ind(&desc[(len - 1)]);
+	set_queue_last_ind(drvdata, &desc[(len - 1)]);
 
 	enqueue_seq(cc_base, desc, len);
 
@@ -500,13 +500,15 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	}
 }
 
-static inline u32 cc_axi_comp_count(void __iomem *cc_base)
+static inline u32 cc_axi_comp_count(struct ssi_drvdata *drvdata)
 {
 	/* The CC_HAL_READ_REGISTER macro implictly requires and uses
 	 * a base MMIO register address variable named cc_base.
 	 */
+	void __iomem *cc_base = drvdata->cc_base;
+
 	return FIELD_GET(AXIM_MON_COMP_VALUE,
-			 CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+			 CC_HAL_READ_REGISTER(drvdata->axim_mon_offset));
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
@@ -516,11 +518,8 @@ static void comp_handler(unsigned long devarg)
 	void __iomem *cc_base = drvdata->cc_base;
 	struct ssi_request_mgr_handle * request_mgr_handle =
 						drvdata->request_mgr_handle;
-
 	u32 irq;
 
-
-
 	irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
 
 	if (irq & SSI_COMP_IRQ_MASK) {
@@ -529,7 +528,7 @@ static void comp_handler(unsigned long devarg)
 
 		/* Avoid race with above clear: Test completion counter once more */
 		request_mgr_handle->axi_completed +=
-				cc_axi_comp_count(cc_base);
+				cc_axi_comp_count(drvdata);
 
 		while (request_mgr_handle->axi_completed) {
 			do {
@@ -538,7 +537,7 @@ static void comp_handler(unsigned long devarg)
 				 * request_mgr_handle->axi_completed is 0.
 				 */
 				request_mgr_handle->axi_completed =
-						cc_axi_comp_count(cc_base);
+						cc_axi_comp_count(drvdata);
 			} while (request_mgr_handle->axi_completed > 0);
 
 			/* To avoid the interrupt from firing as we unmask it, we clear it now */
@@ -546,7 +545,7 @@ static void comp_handler(unsigned long devarg)
 
 			/* Avoid race with above clear: Test completion counter once more */
 			request_mgr_handle->axi_completed +=
-					cc_axi_comp_count(cc_base);
+					cc_axi_comp_count(drvdata);
 		}
 
 	}
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index c8ab55e..589638c 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -53,6 +53,8 @@ void ssi_sram_mgr_fini(struct ssi_drvdata *drvdata)
 int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
 {
 	struct ssi_sram_mgr_ctx *smgr_ctx;
+	void *cc_base = drvdata->cc_base;
+	dma_addr_t start = 0;
 	int rc;
 
 	/* Allocate "this" context */
@@ -66,9 +68,18 @@ int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
 	}
 	smgr_ctx = drvdata->sram_mgr_handle;
 
-	/* Pool starts at start of SRAM */
-	smgr_ctx->sram_free_offset = 0;
+	if (drvdata->hw_rev < CC_HW_REV_712) {
+		/* Pool starts after ROM bytes */
+		start = (dma_addr_t)CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF,
+HOST_SEP_SRAM_THRESHOLD));
+		if ((start & 0x3) != 0) {
+			SSI_LOG_ERR("Invalid SRAM offset 0x%x\n", start);
+			rc = -ENODEV;
+			goto out;
+		}
+	}
 
+	smgr_ctx->sram_free_offset = start;
 	return 0;
 
 out:
-- 
2.1.4
