From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/staging/ccree: Fixing coding guideline errors
Date: Tue, 16 May 2017 13:35:52 +0530
Message-ID: <1494921952-8384-1-git-send-email-pushkar.iit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Pushkar Jambhlekar <pushkar.iit@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

Fixing coding guideline errors reported by 'checkpatch.pl'

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/ccree/ssi_cipher.c | 158 +++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index d245a2b..6eb0f0b 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -68,11 +68,11 @@ struct ssi_ablkcipher_ctx {
 
 static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base);
 
-
-static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
-	switch (ctx_p->flow_mode){
+static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
+{
+	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
-		switch (size){
+		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
 			if (likely((ctx_p->cipher_mode != DRV_CIPHER_XTS) &&
@@ -110,11 +110,11 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 	return -EINVAL;
 }
 
-
-static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size) {
-	switch (ctx_p->flow_mode){
+static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size)
+{
+	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
-		switch (ctx_p->cipher_mode){
+		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
 			if ((size >= SSI_MIN_AES_XTS_SIZE) &&
 			    (size <= SSI_MAX_AES_XTS_SIZE) &&
@@ -260,46 +260,46 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 }
 
 
-typedef struct tdes_keys{
-        u8      key1[DES_KEY_SIZE];
-        u8      key2[DES_KEY_SIZE];
-        u8      key3[DES_KEY_SIZE];
-}tdes_keys_t;
+typedef struct tdes_keys {
+	u8      key1[DES_KEY_SIZE];
+	u8      key2[DES_KEY_SIZE];
+	u8      key3[DES_KEY_SIZE];
+} tdes_keys_t;
 
 static const u8 zero_buff[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
+			       0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+			       0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+			       0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
 
 /* The function verifies that tdes keys are not weak.*/
 static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 {
 #ifdef CCREE_FIPS_SUPPORT
-        tdes_keys_t *tdes_key = (tdes_keys_t*)key;
+	tdes_keys_t *tdes_key = (tdes_keys_t *)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-        if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0) )) {
-                return -ENOEXEC;
-        }
+	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
+		      (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
+		return -ENOEXEC;
+	}
 #endif /* CCREE_FIPS_SUPPORT */
 
-        return 0;
+	return 0;
 }
 
 /* The function verifies that xts keys are not weak.*/
 static int ssi_fips_verify_xts_keys(const u8 *key, unsigned int keylen)
 {
 #ifdef CCREE_FIPS_SUPPORT
-        /* Weak key is define as key that its first half (128/256 lsb) equals its second half (128/256 msb) */
-        int singleKeySize = keylen >> 1;
+	/* Weak key is define as key that its first half (128/256 lsb) equals its second half (128/256 msb) */
+	int singleKeySize = keylen >> 1;
 
 	if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) == 0)) {
 		return -ENOEXEC;
 	}
 #endif /* CCREE_FIPS_SUPPORT */
 
-        return 0;
+	return 0;
 }
 
 static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
@@ -325,6 +325,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
 	u32 tmp[DES_EXPKEY_WORDS];
 	unsigned int max_key_buf_size = get_max_keysize(tfm);
+
 	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("Setting key in context @%p for %s. keylen=%u\n",
@@ -341,11 +342,11 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
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
@@ -353,7 +354,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 	if (ssi_is_hw_key(tfm)) {
 		/* setting HW key slots */
-		struct arm_hw_key_info *hki = (struct arm_hw_key_info*)key;
+		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
 
 		if (unlikely(ctx_p->flow_mode != S_DIN_to_AES)) {
 			SSI_LOG_ERR("HW key not supported for non-AES flows\n");
@@ -437,6 +438,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			/* sha256 for key2 - use sw implementation */
 			int key_len = keylen >> 1;
 			int err;
+
 			SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
 			desc->tfm = ctx_p->shash_tfm;
 
@@ -449,7 +451,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	}
 	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
-	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr ,max_key_buf_size);
+	SSI_UPDATE_DMA_ADDR_TO_48BIT(ctx_p->user.key_dma_addr, max_key_buf_size);
 	ctx_p->keylen = keylen;
 
 	END_CYCLE_COUNT(STAT_OP_TYPE_SETKEY, STAT_PHASE_1);
@@ -497,7 +499,7 @@ ssi_blkcipher_create_setup_desc(
 		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
 		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
 		if ((cipher_mode == DRV_CIPHER_CTR) ||
-		    (cipher_mode == DRV_CIPHER_OFB) ) {
+		    (cipher_mode == DRV_CIPHER_OFB)) {
 			HW_DESC_SET_SETUP_MODE(&desc[*seq_size],
 					       SETUP_LOAD_STATE1);
 		} else {
@@ -620,7 +622,7 @@ static inline void ssi_blkcipher_create_multi2_setup_desc(
 	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
 	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
 	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE0 );
+	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE0);
 	(*seq_size)++;
 
 
@@ -664,15 +666,15 @@ ssi_blkcipher_create_data_desc(
 		break;
 #endif /*SSI_CC_HAS_MULTI2*/
 	default:
-		SSI_LOG_ERR("invalid flow mode, flow_mode = %d \n", flow_mode);
+		SSI_LOG_ERR("invalid flow mode, flow_mode = %d\n", flow_mode);
 		return;
 	}
 	/* Process */
-	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)){
-		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
+	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
+		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X\n",
 			     (unsigned long long)sg_dma_address(src),
 			     nbytes);
-		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
+		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X\n",
 			     (unsigned long long)sg_dma_address(dst),
 			     nbytes);
 		HW_DESC_INIT(&desc[*seq_size]);
@@ -682,7 +684,7 @@ ssi_blkcipher_create_data_desc(
 		HW_DESC_SET_DOUT_DLLI(&desc[*seq_size],
 				      sg_dma_address(dst),
 				      nbytes,
-				      NS_BIT, (areq == NULL)? 0:1);
+				      NS_BIT, (areq == NULL) ? 0:1);
 		if (areq != NULL) {
 			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
 		}
@@ -690,8 +692,7 @@ ssi_blkcipher_create_data_desc(
 		(*seq_size)++;
 	} else {
 		/* bypass */
-		SSI_LOG_DEBUG(" bypass params addr 0x%llX "
-			     "length 0x%X addr 0x%08X\n",
+		SSI_LOG_DEBUG(" bypass params addr 0x%llX length 0x%X addr 0x%08X\n",
 			(unsigned long long)req_ctx->mlli_params.mlli_dma_addr,
 			req_ctx->mlli_params.mlli_len,
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
@@ -711,17 +712,15 @@ ssi_blkcipher_create_data_desc(
 			ctx_p->drvdata->mlli_sram_addr,
 				     req_ctx->in_mlli_nents, NS_BIT);
 		if (req_ctx->out_nents == 0) {
-			SSI_LOG_DEBUG(" din/dout params addr 0x%08X "
-				     "addr 0x%08X\n",
+			SSI_LOG_DEBUG(" din/dout params addr 0x%08X addr 0x%08X\n",
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr,
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
 			HW_DESC_SET_DOUT_MLLI(&desc[*seq_size],
 			ctx_p->drvdata->mlli_sram_addr,
 					      req_ctx->in_mlli_nents,
-					      NS_BIT,(areq == NULL)? 0:1);
+					      NS_BIT, (areq == NULL) ? 0:1);
 		} else {
-			SSI_LOG_DEBUG(" din/dout params "
-				     "addr 0x%08X addr 0x%08X\n",
+			SSI_LOG_DEBUG(" din/dout params addr 0x%08X addr 0x%08X\n",
 				(unsigned int)ctx_p->drvdata->mlli_sram_addr,
 				(unsigned int)ctx_p->drvdata->mlli_sram_addr +
 				(u32)LLI_ENTRY_BYTE_SIZE *
@@ -730,7 +729,7 @@ ssi_blkcipher_create_data_desc(
 				(ctx_p->drvdata->mlli_sram_addr +
 				LLI_ENTRY_BYTE_SIZE *
 						req_ctx->in_mlli_nents),
-				req_ctx->out_mlli_nents, NS_BIT,(areq == NULL)? 0:1);
+				req_ctx->out_mlli_nents, NS_BIT, (areq == NULL) ? 0:1);
 		}
 		if (areq != NULL) {
 			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
@@ -741,15 +740,16 @@ ssi_blkcipher_create_data_desc(
 }
 
 static int ssi_blkcipher_complete(struct device *dev,
-                                  struct ssi_ablkcipher_ctx *ctx_p,
-                                  struct blkcipher_req_ctx *req_ctx,
-                                  struct scatterlist *dst, struct scatterlist *src,
-                                  unsigned int ivsize,
-                                  void *areq,
-                                  void __iomem *cc_base)
+				  struct ssi_ablkcipher_ctx *ctx_p,
+				  struct blkcipher_req_ctx *req_ctx,
+				  struct scatterlist *dst, struct scatterlist *src,
+				  unsigned int ivsize,
+				  void *areq,
+				  void __iomem *cc_base)
 {
 	int completion_error = 0;
 	u32 inflight_counter;
+
 	DECL_CYCLE_COUNT_RESOURCES;
 
 	START_CYCLE_COUNT();
@@ -760,10 +760,10 @@ static int ssi_blkcipher_complete(struct device *dev,
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
@@ -784,11 +784,12 @@ static int ssi_blkcipher_process(
 	struct device *dev = &ctx_p->drvdata->plat_dev->dev;
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct ssi_crypto_req ssi_req = {};
-	int rc, seq_len = 0,cts_restore_flag = 0;
+	int rc, seq_len = 0, cts_restore_flag = 0;
+
 	DECL_CYCLE_COUNT_RESOURCES;
 
 	SSI_LOG_DEBUG("%s areq=%p info=%p nbytes=%d\n",
-		((direction==DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
+		((direction == DRV_CRYPTO_DIRECTION_ENCRYPT)?"Encrypt":"Decrypt"),
 		     areq, info, nbytes);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
@@ -805,8 +806,8 @@ static int ssi_blkcipher_process(
 		/* No data to process is valid */
 		return 0;
 	}
-        /*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)){
+	/*For CTS in case of data size aligned to 16 use CBC mode*/
+	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)) {
 
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
 		cts_restore_flag = 1;
@@ -879,8 +880,8 @@ static int ssi_blkcipher_process(
 	/* STAT_PHASE_3: Lock HW and push sequence */
 	START_CYCLE_COUNT();
 
-	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL)? 0:1);
-	if(areq != NULL) {
+	rc = send_request(ctx_p->drvdata, &ssi_req, desc, seq_len, (areq == NULL) ? 0:1);
+	if (areq != NULL) {
 		if (unlikely(rc != -EINPROGRESS)) {
 			/* Failed to send the request or request completed synchronously */
 			ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
@@ -951,8 +952,8 @@ static void ssi_sblkcipher_exit(struct crypto_tfm *tfm)
 
 #ifdef SYNC_ALGS
 static int ssi_sblkcipher_encrypt(struct blkcipher_desc *desc,
-                        struct scatterlist *dst, struct scatterlist *src,
-                        unsigned int nbytes)
+			struct scatterlist *dst, struct scatterlist *src,
+			unsigned int nbytes)
 {
 	struct crypto_blkcipher *blk_tfm = desc->tfm;
 	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
@@ -967,8 +968,8 @@ static int ssi_sblkcipher_encrypt(struct blkcipher_desc *desc,
 }
 
 static int ssi_sblkcipher_decrypt(struct blkcipher_desc *desc,
-                        struct scatterlist *dst, struct scatterlist *src,
-                        unsigned int nbytes)
+			struct scatterlist *dst, struct scatterlist *src,
+			unsigned int nbytes)
 {
 	struct crypto_blkcipher *blk_tfm = desc->tfm;
 	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
@@ -1048,7 +1049,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "xts(aes)",
@@ -1206,7 +1207,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "cbc(aes)",
@@ -1223,7 +1224,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "ofb(aes)",
@@ -1240,7 +1241,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 #if SSI_CC_HAS_AES_CTS
 	{
@@ -1258,7 +1259,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 #endif
 	{
@@ -1276,7 +1277,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "cbc(des3_ede)",
@@ -1293,7 +1294,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "ecb(des3_ede)",
@@ -1310,7 +1311,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "cbc(des)",
@@ -1327,7 +1328,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "ecb(des)",
@@ -1344,7 +1345,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
+	.synchronous = false,
 	},
 #if SSI_CC_HAS_MULTI2
 	{
@@ -1362,7 +1363,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_CBC,
 		.flow_mode = S_DIN_to_MULTI2,
-        .synchronous = false,
+	.synchronous = false,
 	},
 	{
 		.name = "ofb(multi2)",
@@ -1379,7 +1380,7 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_OFB,
 		.flow_mode = S_DIN_to_MULTI2,
-        .synchronous = false,
+	.synchronous = false,
 	},
 #endif /*SSI_CC_HAS_MULTI2*/
 };
@@ -1407,10 +1408,10 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template *templa
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct ssi_ablkcipher_ctx);
 
-	alg->cra_init = template->synchronous? ssi_sblkcipher_init:ssi_ablkcipher_init;
-	alg->cra_exit = template->synchronous? ssi_sblkcipher_exit:ssi_blkcipher_exit;
-	alg->cra_type = template->synchronous? &crypto_blkcipher_type:&crypto_ablkcipher_type;
-	if(template->synchronous) {
+	alg->cra_init = template->synchronous ? ssi_sblkcipher_init:ssi_ablkcipher_init;
+	alg->cra_exit = template->synchronous ? ssi_sblkcipher_exit:ssi_blkcipher_exit;
+	alg->cra_type = template->synchronous ? &crypto_blkcipher_type :  &crypto_ablkcipher_type;
+	if (template->synchronous) {
 		alg->cra_blkcipher = template->template_sblkcipher;
 		alg->cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
 				template->type;
@@ -1432,6 +1433,7 @@ int ssi_ablkcipher_free(struct ssi_drvdata *drvdata)
 	struct ssi_blkcipher_handle *blkcipher_handle =
 						drvdata->blkcipher_handle;
 	struct device *dev;
+
 	dev = &drvdata->plat_dev->dev;
 
 	if (blkcipher_handle != NULL) {
-- 
2.7.4
