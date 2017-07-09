From: sleepingzucchini@gmail.com
Subject: [PATCH 2/5] staging: ccree: fix placement of curly braces
Date: Sun,  9 Jul 2017 17:10:44 -0400
Message-ID: <55da63eb7e084d553f94dac2a50e28eae761480c.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33215 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdGIWP6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 18:15:58 -0400
Received: by mail-qt0-f193.google.com with SMTP id c20so10703836qte.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 15:15:57 -0700 (PDT)
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tyler Olivieri <sleepingzucchini@gmail.com>

Patch to fix checkpatch errors:
ERROR: that open brace { should be on the previous line
ERROR: open brace '{' following function declarations go on the next line

Signed-off-by: Tyler Olivieri <sleepingzucchini@gmail.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 12 ++---
 drivers/staging/ccree/ssi_cipher.c     |  6 ++-
 drivers/staging/ccree/ssi_driver.c     |  5 +-
 drivers/staging/ccree/ssi_fips_ll.c    | 85 +++++++++++-----------------------
 drivers/staging/ccree/ssi_hash.c       |  3 +-
 drivers/staging/ccree/ssi_sysfs.c      |  3 +-
 6 files changed, 40 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index c05cd67..cbf672b 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -696,8 +696,7 @@ void ssi_buffer_mgr_unmap_aead_request(
 	}
 	if (drvdata->coherent &&
 	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-	    likely(req->src == req->dst))
-	{
+	    likely(req->src == req->dst)) {
 		u32 size_to_skip = req->assoclen;
 
 		if (areq_ctx->is_gcm4543)
@@ -1134,8 +1133,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		sg_index += areq_ctx->srcSgl->length;
 		src_mapped_nents--;
 	}
-	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES))
-	{
+	if (unlikely(src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
 		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
 				src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
 			return -ENOMEM;
@@ -1177,8 +1175,7 @@ static inline int ssi_buffer_mgr_aead_chain_data(
 		sg_index += areq_ctx->dstSgl->length;
 		dst_mapped_nents--;
 	}
-	if (unlikely(dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES))
-	{
+	if (unlikely(dst_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES)) {
 		SSI_LOG_ERR("Too many fragments. current %d max %d\n",
 			    dst_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
 		return -ENOMEM;
@@ -1274,8 +1271,7 @@ int ssi_buffer_mgr_map_aead_request(
 
 	if (drvdata->coherent &&
 	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-	    likely(req->src == req->dst))
-	{
+	    likely(req->src == req->dst)) {
 		u32 size_to_skip = req->assoclen;
 
 		if (is_gcm4543)
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index cd2eafc..4ef0c9b 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -68,7 +68,8 @@ struct ssi_ablkcipher_ctx {
 
 static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __iomem *cc_base);
 
-static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
+static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size)
+{
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
 		switch (size) {
@@ -108,7 +109,8 @@ static int validate_keys_sizes(struct ssi_ablkcipher_ctx *ctx_p, u32 size) {
 	return -EINVAL;
 }
 
-static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size) {
+static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int size)
+{
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
 		switch (ctx_p->cipher_mode) {
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 78709b92..d396474 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -301,13 +301,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 
 	if (!new_drvdata->plat_dev->dev.dma_mask)
-	{
 		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
-	}
+
 	if (!new_drvdata->plat_dev->dev.coherent_dma_mask)
-	{
 		new_drvdata->plat_dev->dev.coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
-	}
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 3557e20..4a7a1a6 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -270,8 +270,7 @@ static const FipsGcmData FipsGcmDataTable[] = {
 static inline enum cc_fips_error
 FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
 {
-	switch (mode)
-	{
+	switch (mode) {
 	case DRV_CIPHER_ECB:
 		return is_aes ? CC_REE_FIPS_ERROR_AES_ECB_PUT : CC_REE_FIPS_ERROR_DES_ECB_PUT;
 	case DRV_CIPHER_CBC:
@@ -422,8 +421,7 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, din);
 	dma_addr_t dout_dma_addr = dma_coherent_buffer + offsetof(struct fips_cipher_ctx, dout);
 
-	for (i = 0; i < FIPS_CIPHER_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_CIPHER_NUM_OF_TESTS; ++i) {
 		FipsCipherData *cipherData = (FipsCipherData *)&FipsCipherDataTable[i];
 		int rc = 0;
 		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE;
@@ -447,21 +445,18 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 					      din_dma_addr,
 					      dout_dma_addr,
 					      cipherData->dataInSize);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_cipher_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = FIPS_CipherToFipsError(cipherData->oprMode, cipherData->isAes);
 			break;
 		}
 
 		/* compare actual dout to expected */
-		if (memcmp(virt_ctx->dout, cipherData->dataOut, cipherData->dataInSize) != 0)
-		{
+		if (memcmp(virt_ctx->dout, cipherData->dataOut, cipherData->dataInSize) != 0) {
 			FIPS_LOG("dout comparison error %d - oprMode=%d, isAes=%d\n", i, cipherData->oprMode, cipherData->isAes);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x  (size=%d) \n", (size_t)cipherData->dataOut, (size_t)virt_ctx->dout, cipherData->dataInSize);
-			for (i = 0; i < cipherData->dataInSize; ++i)
-			{
+			for (i = 0; i < cipherData->dataInSize; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, cipherData->dataOut[i], virt_ctx->dout[i]);
 			}
 
@@ -548,8 +543,7 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_cmac_ctx, din);
 	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_cmac_ctx, mac_res);
 
-	for (i = 0; i < FIPS_CMAC_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_CMAC_NUM_OF_TESTS; ++i) {
 		FipsCmacData *cmac_data = (FipsCmacData *)&FipsCmacDataTable[i];
 		int rc = 0;
 
@@ -569,21 +563,18 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 					    cmac_data->data_in_size,
 					    mac_res_dma_addr,
 					    cmac_data->mac_res_size);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_cmac_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = CC_REE_FIPS_ERROR_AES_CMAC_PUT;
 			break;
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, cmac_data->mac_res, cmac_data->mac_res_size) != 0)
-		{
+		if (memcmp(virt_ctx->mac_res, cmac_data->mac_res, cmac_data->mac_res_size) != 0) {
 			FIPS_LOG("comparison error %d - digest_size=%d \n", i, cmac_data->mac_res_size);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)cmac_data->mac_res, (size_t)virt_ctx->mac_res);
-			for (i = 0; i < cmac_data->mac_res_size; ++i)
-			{
+			for (i = 0; i < cmac_data->mac_res_size; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, cmac_data->mac_res[i], virt_ctx->mac_res[i]);
 			}
 
@@ -693,8 +684,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_hash_ctx, din);
 	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_hash_ctx, mac_res);
 
-	for (i = 0; i < FIPS_HASH_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_HASH_NUM_OF_TESTS; ++i) {
 		FipsHashData *hash_data = (FipsHashData *)&FipsHashDataTable[i];
 		int rc = 0;
 		enum drv_hash_hw_mode hw_mode = 0;
@@ -744,21 +734,18 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 					    hw_mode,
 					    digest_size,
 					    inter_digestsize);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_hash_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = FIPS_HashToFipsError(hash_data->hash_mode);
 			break;
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, hash_data->mac_res, digest_size) != 0)
-		{
+		if (memcmp(virt_ctx->mac_res, hash_data->mac_res, digest_size) != 0) {
 			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hash_data->hash_mode, digest_size);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)hash_data->mac_res, (size_t)virt_ctx->mac_res);
-			for (i = 0; i < digest_size; ++i)
-			{
+			for (i = 0; i < digest_size; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, hash_data->mac_res[i], virt_ctx->mac_res[i]);
 			}
 
@@ -1010,8 +997,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	dma_addr_t din_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, din);
 	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_hmac_ctx, mac_res);
 
-	for (i = 0; i < FIPS_HMAC_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_HMAC_NUM_OF_TESTS; ++i) {
 		FipsHmacData *hmac_data = (FipsHmacData *)&FipsHmacDataTable[i];
 		int rc = 0;
 		enum drv_hash_hw_mode hw_mode = 0;
@@ -1074,21 +1060,18 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 					    k0_dma_addr,
 					    tmp_digest_dma_addr,
 					    digest_bytes_len_dma_addr);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_hmac_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = FIPS_HmacToFipsError(hmac_data->hash_mode);
 			break;
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, hmac_data->mac_res, digest_size) != 0)
-		{
+		if (memcmp(virt_ctx->mac_res, hmac_data->mac_res, digest_size) != 0) {
 			FIPS_LOG("comparison error %d - hash_mode=%d digest_size=%d \n", i, hmac_data->hash_mode, digest_size);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)hmac_data->mac_res, (size_t)virt_ctx->mac_res);
-			for (i = 0; i < digest_size; ++i)
-			{
+			for (i = 0; i < digest_size; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, hmac_data->mac_res[i], virt_ctx->mac_res[i]);
 			}
 
@@ -1251,8 +1234,7 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	dma_addr_t dout_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, dout);
 	dma_addr_t mac_res_dma_addr = dma_coherent_buffer + offsetof(struct fips_ccm_ctx, mac_res);
 
-	for (i = 0; i < FIPS_CCM_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_CCM_NUM_OF_TESTS; ++i) {
 		FipsCcmData *ccmData = (FipsCcmData *)&FipsCcmDataTable[i];
 		int rc = 0;
 
@@ -1294,29 +1276,25 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 					   ccmData->dataInSize,
 					   dout_dma_addr,
 					   mac_res_dma_addr);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_ccm_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = CC_REE_FIPS_ERROR_AESCCM_PUT;
 			break;
 		}
 
 		/* compare actual dout to expected */
-		if (memcmp(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize) != 0)
-		{
+		if (memcmp(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize) != 0) {
 			FIPS_LOG("dout comparison error %d - size=%d \n", i, ccmData->dataInSize);
 			error = CC_REE_FIPS_ERROR_AESCCM_PUT;
 			break;
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize) != 0)
-		{
+		if (memcmp(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize) != 0) {
 			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, ccmData->tagSize);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)ccmData->macResOut, (size_t)virt_ctx->mac_res);
-			for (i = 0; i < ccmData->tagSize; ++i)
-			{
+			for (i = 0; i < ccmData->tagSize; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, ccmData->macResOut[i], virt_ctx->mac_res[i]);
 			}
 
@@ -1546,8 +1524,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 	dma_addr_t iv_inc1_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, iv_inc1);
 	dma_addr_t iv_inc2_dma_addr = dma_coherent_buffer + offsetof(struct fips_gcm_ctx, iv_inc2);
 
-	for (i = 0; i < FIPS_GCM_NUM_OF_TESTS; ++i)
-	{
+	for (i = 0; i < FIPS_GCM_NUM_OF_TESTS; ++i) {
 		FipsGcmData *gcmData = (FipsGcmData *)&FipsGcmDataTable[i];
 		int rc = 0;
 
@@ -1593,8 +1570,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 					   gcmData->dataInSize,
 					   dout_dma_addr,
 					   mac_res_dma_addr);
-		if (rc != 0)
-		{
+		if (rc != 0) {
 			FIPS_LOG("ssi_gcm_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = CC_REE_FIPS_ERROR_AESGCM_PUT;
 			break;
@@ -1602,13 +1578,11 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 		if (gcmData->direction == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 			/* compare actual dout to expected */
-			if (memcmp(virt_ctx->dout, gcmData->dataOut, gcmData->dataInSize) != 0)
-			{
+			if (memcmp(virt_ctx->dout, gcmData->dataOut, gcmData->dataInSize) != 0) {
 				FIPS_LOG("dout comparison error %d - size=%d \n", i, gcmData->dataInSize);
 				FIPS_LOG("  i  expected   received \n");
 				FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)gcmData->dataOut, (size_t)virt_ctx->dout);
-				for (i = 0; i < gcmData->dataInSize; ++i)
-				{
+				for (i = 0; i < gcmData->dataInSize; ++i) {
 					FIPS_LOG("  %d    0x%02x     0x%02x \n", i, gcmData->dataOut[i], virt_ctx->dout[i]);
 				}
 
@@ -1618,16 +1592,13 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		}
 
 		/* compare actual mac result to expected */
-		if (memcmp(virt_ctx->mac_res, gcmData->macResOut, gcmData->tagSize) != 0)
-		{
+		if (memcmp(virt_ctx->mac_res, gcmData->macResOut, gcmData->tagSize) != 0) {
 			FIPS_LOG("mac_res comparison error %d - mac_size=%d \n", i, gcmData->tagSize);
 			FIPS_LOG("  i  expected   received \n");
 			FIPS_LOG("  i  0x%08x 0x%08x \n", (size_t)gcmData->macResOut, (size_t)virt_ctx->mac_res);
-			for (i = 0; i < gcmData->tagSize; ++i)
-			{
+			for (i = 0; i < gcmData->tagSize; ++i) {
 				FIPS_LOG("  %d    0x%02x     0x%02x \n", i, gcmData->macResOut[i], virt_ctx->mac_res[i]);
 			}
-
 			error = CC_REE_FIPS_ERROR_AESGCM_PUT;
 			break;
 		}
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ae8f36a..7e9f273 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2366,7 +2366,8 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 
 static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
 				  struct cc_hw_desc desc[],
-				  unsigned int *seq_size) {
+				  unsigned int *seq_size)
+{
 	unsigned int idx = *seq_size;
 	struct ahash_req_ctx *state = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index dbcd163..07b634c 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -40,8 +40,7 @@ struct stat_name {
 	const char *stat_phase_name[MAX_STAT_PHASES];
 };
 
-static struct stat_name stat_name_db[MAX_STAT_OP_TYPES] =
-{
+static struct stat_name stat_name_db[MAX_STAT_OP_TYPES] = {
 	{
 		/* STAT_OP_TYPE_NULL */
 		.op_type_name = "NULL",
-- 
2.9.4
