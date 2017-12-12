From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 16/24] staging: ccree: drop unsupported MULTI2 mode code
Date: Tue, 12 Dec 2017 14:53:02 +0000
Message-ID: <1513090395-7938-17-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the code support for MULTI2 mode which is not supported
by the current hardware.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h    |  17 ----
 drivers/staging/ccree/cc_hw_queue_defs.h |   2 -
 drivers/staging/ccree/ssi_cipher.c       | 167 ++++---------------------------
 drivers/staging/ccree/ssi_driver.h       |   1 -
 4 files changed, 18 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 591f6fd..0e34d9a 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -82,15 +82,6 @@
 
 #define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
 
-#define CC_MULTI2_SYSTEM_KEY_SIZE		32
-#define CC_MULTI2_DATA_KEY_SIZE		8
-#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE \
-		(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
-#define	CC_MULTI2_BLOCK_SIZE					8
-#define	CC_MULTI2_IV_SIZE					8
-#define	CC_MULTI2_MIN_NUM_ROUNDS				8
-#define	CC_MULTI2_MAX_NUM_ROUNDS				128
-
 #define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
 
 enum drv_engine_type {
@@ -168,14 +159,6 @@ enum drv_hash_hw_mode {
 	DRV_HASH_HW_RESERVE32B = S32_MAX
 };
 
-enum drv_multi2_mode {
-	DRV_MULTI2_NULL = -1,
-	DRV_MULTI2_ECB = 0,
-	DRV_MULTI2_CBC = 1,
-	DRV_MULTI2_OFB = 2,
-	DRV_MULTI2_RESERVE32B = S32_MAX
-};
-
 /* drv_crypto_key_type[1:0] is mapped to cipher_do[1:0] */
 /* drv_crypto_key_type[2] is mapped to cipher_config2 */
 enum drv_crypto_key_type {
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index c5aaa79..3ca548d 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -120,7 +120,6 @@ enum cc_flow_mode {
 	AES_to_AES_to_HASH_and_DOUT	= 13,
 	AES_to_AES_to_HASH	= 14,
 	AES_to_HASH_and_AES	= 15,
-	DIN_MULTI2_DOUT		= 16,
 	DIN_AES_AESMAC		= 17,
 	HASH_to_DOUT		= 18,
 	/* setup flows */
@@ -128,7 +127,6 @@ enum cc_flow_mode {
 	S_DIN_to_AES2		= 33,
 	S_DIN_to_DES		= 34,
 	S_DIN_to_RC4		= 35,
-	S_DIN_to_MULTI2		= 36,
 	S_DIN_to_HASH		= 37,
 	S_AES_to_DOUT		= 38,
 	S_AES2_to_DOUT		= 39,
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 0b464d8..a158213 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -97,12 +97,6 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
 			return 0;
 		break;
-#if SSI_CC_HAS_MULTI2
-	case S_DIN_to_MULTI2:
-		if (size == CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE)
-			return 0;
-		break;
-#endif
 	default:
 		break;
 	}
@@ -143,20 +137,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 		if (IS_ALIGNED(size, DES_BLOCK_SIZE))
 			return 0;
 		break;
-#if SSI_CC_HAS_MULTI2
-	case S_DIN_to_MULTI2:
-		switch (ctx_p->cipher_mode) {
-		case DRV_MULTI2_CBC:
-			if (IS_ALIGNED(size, CC_MULTI2_BLOCK_SIZE))
-				return 0;
-			break;
-		case DRV_MULTI2_OFB:
-			return 0;
-		default:
-			break;
-		}
-		break;
-#endif /*SSI_CC_HAS_MULTI2*/
 	default:
 		break;
 	}
@@ -315,14 +295,6 @@ static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
-#if SSI_CC_HAS_MULTI2
-	/* last byte of key buffer is round number and should not be a part
-	 * of key size
-	 */
-	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
-		keylen -= 1;
-#endif /*SSI_CC_HAS_MULTI2*/
-
 	if (validate_keys_sizes(ctx_p, keylen)) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -393,38 +365,23 @@ static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
 				max_key_buf_size, DMA_TO_DEVICE);
 
-	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
-#if SSI_CC_HAS_MULTI2
-		memcpy(ctx_p->user.key, key, CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE);
-		ctx_p->key_round_number =
-			key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE];
-		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
-		    ctx_p->key_round_number > CC_MULTI2_MAX_NUM_ROUNDS) {
-			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-			dev_dbg(dev, "SSI_CC_HAS_MULTI2 einval");
-			return -EINVAL;
-#endif /*SSI_CC_HAS_MULTI2*/
-	} else {
-		memcpy(ctx_p->user.key, key, keylen);
-		if (keylen == 24)
-			memset(ctx_p->user.key + 24, 0,
-			       CC_AES_KEY_SIZE_MAX - 24);
-
-		if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-			/* sha256 for key2 - use sw implementation */
-			int key_len = keylen >> 1;
-			int err;
-			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
-
-			desc->tfm = ctx_p->shash_tfm;
-
-			err = crypto_shash_digest(desc, ctx_p->user.key,
-						  key_len,
-						  ctx_p->user.key + key_len);
-			if (err) {
-				dev_err(dev, "Failed to hash ESSIV key.\n");
-				return err;
-			}
+	memcpy(ctx_p->user.key, key, keylen);
+	if (keylen == 24)
+		memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
+
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* sha256 for key2 - use sw implementation */
+		int key_len = keylen >> 1;
+		int err;
+		SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
+
+		desc->tfm = ctx_p->shash_tfm;
+
+		err = crypto_shash_digest(desc, ctx_p->user.key, key_len,
+					  ctx_p->user.key + key_len);
+		if (err) {
+			dev_err(dev, "Failed to hash ESSIV key.\n");
+			return err;
 		}
 	}
 	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
@@ -561,49 +518,6 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 	}
 }
 
-#if SSI_CC_HAS_MULTI2
-static void cc_setup_multi2_desc(struct crypto_tfm *tfm,
-				 struct blkcipher_req_ctx *req_ctx,
-				 unsigned int ivsize, struct cc_hw_desc desc[],
-				 unsigned int *seq_size)
-{
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-
-	int direction = req_ctx->gen_ctx.op_type;
-	/* Load system key */
-	hw_desc_init(&desc[*seq_size]);
-	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
-	set_cipher_config0(&desc[*seq_size], direction);
-	set_din_type(&desc[*seq_size], DMA_DLLI, ctx_p->user.key_dma_addr,
-		     CC_MULTI2_SYSTEM_KEY_SIZE, NS_BIT);
-	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
-	set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
-	(*seq_size)++;
-
-	/* load data key */
-	hw_desc_init(&desc[*seq_size]);
-	set_din_type(&desc[*seq_size], DMA_DLLI,
-		     (ctx_p->user.key_dma_addr + CC_MULTI2_SYSTEM_KEY_SIZE),
-		     CC_MULTI2_DATA_KEY_SIZE, NS_BIT);
-	set_multi2_num_rounds(&desc[*seq_size], ctx_p->key_round_number);
-	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
-	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
-	set_cipher_config0(&desc[*seq_size], direction);
-	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
-	(*seq_size)++;
-
-	/* Set state */
-	hw_desc_init(&desc[*seq_size]);
-	set_din_type(&desc[*seq_size], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
-		     ivsize, NS_BIT);
-	set_cipher_config0(&desc[*seq_size], direction);
-	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
-	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
-	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
-	(*seq_size)++;
-}
-#endif /*SSI_CC_HAS_MULTI2*/
-
 static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 				 struct blkcipher_req_ctx *req_ctx,
 				 struct scatterlist *dst,
@@ -622,11 +536,6 @@ static void cc_setup_cipher_data(struct crypto_tfm *tfm,
 	case S_DIN_to_DES:
 		flow_mode = DIN_DES_DOUT;
 		break;
-#if SSI_CC_HAS_MULTI2
-	case S_DIN_to_MULTI2:
-		flow_mode = DIN_MULTI2_DOUT;
-		break;
-#endif /*SSI_CC_HAS_MULTI2*/
 	default:
 		dev_err(dev, "invalid flow mode, flow_mode = %d\n", flow_mode);
 		return;
@@ -806,13 +715,7 @@ static int cc_cipher_process(struct ablkcipher_request *req,
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Setup processing */
-#if SSI_CC_HAS_MULTI2
-	if (ctx_p->flow_mode == S_DIN_to_MULTI2)
-		cc_setup_multi2_desc(tfm, req_ctx, ivsize, desc, &seq_len);
-	else
-#endif /*SSI_CC_HAS_MULTI2*/
-		cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc,
-				     &seq_len);
+	cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
 	/* Data processing */
 	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
 			     &seq_len);
@@ -1177,40 +1080,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
 	},
-#if SSI_CC_HAS_MULTI2
-	{
-		.name = "cbc(multi2)",
-		.driver_name = "cbc-multi2-dx",
-		.blocksize = CC_MULTI2_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
-			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
-			.ivsize = CC_MULTI2_IV_SIZE,
-			},
-		.cipher_mode = DRV_MULTI2_CBC,
-		.flow_mode = S_DIN_to_MULTI2,
-	},
-	{
-		.name = "ofb(multi2)",
-		.driver_name = "ofb-multi2-dx",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_encrypt,
-			.min_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
-			.max_keysize = CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE + 1,
-			.ivsize = CC_MULTI2_IV_SIZE,
-			},
-		.cipher_mode = DRV_MULTI2_OFB,
-		.flow_mode = S_DIN_to_MULTI2,
-	},
-#endif /*SSI_CC_HAS_MULTI2*/
 };
 
 static
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index f92867b..a2de584 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -60,7 +60,6 @@
 #define SSI_CC_HAS_AES_ESSIV 1
 #define SSI_CC_HAS_AES_BITLOCKER 1
 #define SSI_CC_HAS_AES_CTS 1
-#define SSI_CC_HAS_MULTI2 0
 #define SSI_CC_HAS_CMAC 1
 
 #define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
-- 
2.7.4
