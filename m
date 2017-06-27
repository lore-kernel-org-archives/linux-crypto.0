From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/14] staging: ccree: fix pointer location
Date: Tue, 27 Jun 2017 10:27:20 +0300
Message-ID: <1498548449-10803-9-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52480 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752498AbdF0H2V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:28:21 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix location of pointer in variables definitions and dereference.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.h        |  4 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 12 ++++++------
 drivers/staging/ccree/ssi_cipher.c      |  8 ++++----
 drivers/staging/ccree/ssi_fips_ll.c     | 24 ++++++++++++------------
 drivers/staging/ccree/ssi_fips_local.c  |  2 +-
 drivers/staging/ccree/ssi_hash.c        |  2 +-
 drivers/staging/ccree/ssi_hash.h        |  6 +++---
 drivers/staging/ccree/ssi_request_mgr.c | 10 +++++-----
 drivers/staging/ccree/ssi_sysfs.c       |  4 ++--
 9 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 07cab84..d69e729 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -98,8 +98,8 @@ struct aead_req_ctx {
 	struct ssi_mlli assoc;
 	struct ssi_mlli src;
 	struct ssi_mlli dst;
-	struct scatterlist* srcSgl;
-	struct scatterlist* dstSgl;
+	struct scatterlist *srcSgl;
+	struct scatterlist *dstSgl;
 	unsigned int srcOffset;
 	unsigned int dstOffset;
 	enum ssi_req_dma_buf_type assoc_buff_type;
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index e060ea1..1b41c12 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -66,7 +66,7 @@ struct buffer_array {
 	int total_data_len[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	enum dma_buffer_type type[MAX_NUM_OF_BUFFERS_IN_MLLI];
 	bool is_last[MAX_NUM_OF_BUFFERS_IN_MLLI];
-	u32 * mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
+	u32 *mlli_nents[MAX_NUM_OF_BUFFERS_IN_MLLI];
 };
 
 /**
@@ -409,7 +409,7 @@ static int ssi_buffer_mgr_map_scatterlist(
 static inline int
 ssi_aead_handle_config_buf(struct device *dev,
 	struct aead_req_ctx *areq_ctx,
-	u8* config_data,
+	u8 *config_data,
 	struct buffer_array *sg_data,
 	unsigned int assoclen)
 {
@@ -444,7 +444,7 @@ ssi_aead_handle_config_buf(struct device *dev,
 
 static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 					   struct ahash_req_ctx *areq_ctx,
-					   u8* curr_buff,
+					   u8 *curr_buff,
 					   u32 curr_buff_cnt,
 					   struct buffer_array *sg_data)
 {
@@ -1460,7 +1460,7 @@ int ssi_buffer_mgr_map_hash_request_final(
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = &drvdata->plat_dev->dev;
-	u8* curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
+	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
 			areq_ctx->buff0;
 	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
 			&areq_ctx->buff0_cnt;
@@ -1551,11 +1551,11 @@ int ssi_buffer_mgr_map_hash_request_update(
 {
 	struct ahash_req_ctx *areq_ctx = (struct ahash_req_ctx *)ctx;
 	struct device *dev = &drvdata->plat_dev->dev;
-	u8* curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
+	u8 *curr_buff = areq_ctx->buff_index ? areq_ctx->buff1 :
 			areq_ctx->buff0;
 	u32 *curr_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff1_cnt :
 			&areq_ctx->buff0_cnt;
-	u8* next_buff = areq_ctx->buff_index ? areq_ctx->buff0 :
+	u8 *next_buff = areq_ctx->buff_index ? areq_ctx->buff0 :
 			areq_ctx->buff1;
 	u32 *next_buff_cnt = areq_ctx->buff_index ? &areq_ctx->buff0_cnt :
 			&areq_ctx->buff1_cnt;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 1baa215..b4fc9a6 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -268,11 +268,11 @@ static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 {
 #ifdef CCREE_FIPS_SUPPORT
-	tdes_keys_t *tdes_key = (tdes_keys_t*)key;
+	tdes_keys_t *tdes_key = (tdes_keys_t *)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-	if (unlikely((memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
-		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
+	if (unlikely((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
+		      (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2, sizeof(tdes_key->key3)) == 0))) {
 		return -ENOEXEC;
 	}
 #endif /* CCREE_FIPS_SUPPORT */
@@ -342,7 +342,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 
 	if (ssi_is_hw_key(tfm)) {
 		/* setting HW key slots */
-		struct arm_hw_key_info *hki = (struct arm_hw_key_info*)key;
+		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
 
 		if (unlikely(ctx_p->flow_mode != S_DIN_to_AES)) {
 			SSI_LOG_ERR("HW key not supported for non-AES flows\n");
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 804384d..4a11f15 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -430,7 +430,7 @@ ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffe
 
 	for (i = 0; i < FIPS_CIPHER_NUM_OF_TESTS; ++i)
 	{
-		FipsCipherData *cipherData = (FipsCipherData*)&FipsCipherDataTable[i];
+		FipsCipherData *cipherData = (FipsCipherData *)&FipsCipherDataTable[i];
 		int rc = 0;
 		size_t iv_size = cipherData->isAes ? NIST_AES_IV_SIZE : NIST_TDES_IV_SIZE;
 
@@ -558,7 +558,7 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 	for (i = 0; i < FIPS_CMAC_NUM_OF_TESTS; ++i)
 	{
-		FipsCmacData *cmac_data = (FipsCmacData*)&FipsCmacDataTable[i];
+		FipsCmacData *cmac_data = (FipsCmacData *)&FipsCmacDataTable[i];
 		int rc = 0;
 
 		memset(cpu_addr_buffer, 0, sizeof(struct fips_cmac_ctx));
@@ -704,7 +704,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 	for (i = 0; i < FIPS_HASH_NUM_OF_TESTS; ++i)
 	{
-		FipsHashData *hash_data = (FipsHashData*)&FipsHashDataTable[i];
+		FipsHashData *hash_data = (FipsHashData *)&FipsHashDataTable[i];
 		int rc = 0;
 		enum drv_hash_hw_mode hw_mode = 0;
 		int digest_size = 0;
@@ -718,20 +718,20 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			digest_size = CC_SHA1_DIGEST_SIZE;
 			inter_digestsize = CC_SHA1_DIGEST_SIZE;
 			/* copy the initial digest into the allocated cache coherent buffer */
-			memcpy(virt_ctx->initial_digest, (void*)sha1_init, CC_SHA1_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha1_init, CC_SHA1_DIGEST_SIZE);
 			break;
 		case DRV_HASH_SHA256:
 			hw_mode = DRV_HASH_HW_SHA256;
 			digest_size = CC_SHA256_DIGEST_SIZE;
 			inter_digestsize = CC_SHA256_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha256_init, CC_SHA256_DIGEST_SIZE);
 			break;
 #if (CC_SUPPORT_SHA > 256)
 		case DRV_HASH_SHA512:
 			hw_mode = DRV_HASH_HW_SHA512;
 			digest_size = CC_SHA512_DIGEST_SIZE;
 			inter_digestsize = CC_SHA512_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha512_init, CC_SHA512_DIGEST_SIZE);
 			break;
 #endif
 		default:
@@ -1024,7 +1024,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 	for (i = 0; i < FIPS_HMAC_NUM_OF_TESTS; ++i)
 	{
-		FipsHmacData *hmac_data = (FipsHmacData*)&FipsHmacDataTable[i];
+		FipsHmacData *hmac_data = (FipsHmacData *)&FipsHmacDataTable[i];
 		int rc = 0;
 		enum drv_hash_hw_mode hw_mode = 0;
 		int digest_size = 0;
@@ -1039,7 +1039,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			digest_size = CC_SHA1_DIGEST_SIZE;
 			block_size = CC_SHA1_BLOCK_SIZE;
 			inter_digestsize = CC_SHA1_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha1_init, CC_SHA1_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha1_init, CC_SHA1_DIGEST_SIZE);
 			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
 			break;
 		case DRV_HASH_SHA256:
@@ -1047,7 +1047,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			digest_size = CC_SHA256_DIGEST_SIZE;
 			block_size = CC_SHA256_BLOCK_SIZE;
 			inter_digestsize = CC_SHA256_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha256_init, CC_SHA256_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha256_init, CC_SHA256_DIGEST_SIZE);
 			memcpy(virt_ctx->digest_bytes_len, digest_len_init, HASH_LEN_SIZE);
 			break;
 #if (CC_SUPPORT_SHA > 256)
@@ -1056,7 +1056,7 @@ ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			digest_size = CC_SHA512_DIGEST_SIZE;
 			block_size = CC_SHA512_BLOCK_SIZE;
 			inter_digestsize = CC_SHA512_DIGEST_SIZE;
-			memcpy(virt_ctx->initial_digest, (void*)sha512_init, CC_SHA512_DIGEST_SIZE);
+			memcpy(virt_ctx->initial_digest, (void *)sha512_init, CC_SHA512_DIGEST_SIZE);
 			memcpy(virt_ctx->digest_bytes_len, digest_len_sha512_init, HASH_LEN_SIZE);
 			break;
 #endif
@@ -1266,7 +1266,7 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 	for (i = 0; i < FIPS_CCM_NUM_OF_TESTS; ++i)
 	{
-		FipsCcmData *ccmData = (FipsCcmData*)&FipsCcmDataTable[i];
+		FipsCcmData *ccmData = (FipsCcmData *)&FipsCcmDataTable[i];
 		int rc = 0;
 
 		memset(cpu_addr_buffer, 0, sizeof(struct fips_ccm_ctx));
@@ -1566,7 +1566,7 @@ ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 	for (i = 0; i < FIPS_GCM_NUM_OF_TESTS; ++i)
 	{
-		FipsGcmData *gcmData = (FipsGcmData*)&FipsGcmDataTable[i];
+		FipsGcmData *gcmData = (FipsGcmData *)&FipsGcmDataTable[i];
 		int rc = 0;
 
 		memset(cpu_addr_buffer, 0, sizeof(struct fips_gcm_ctx));
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index c571b85..50d7189 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -165,7 +165,7 @@ static void fips_dsr(unsigned long devarg)
 ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 {
 	ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
-	void * cpu_addr_buffer = NULL;
+	void *cpu_addr_buffer = NULL;
 	dma_addr_t dma_handle;
 	size_t alloc_buff_size = ssi_fips_max_mem_alloc_size();
 	struct device *dev = &drvdata->plat_dev->dev;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 7a70d87..79655bb 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1358,7 +1358,7 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 {
 	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct hash_alg_common * hash_alg_common =
+	struct hash_alg_common *hash_alg_common =
 		container_of(tfm->__crt_alg, struct hash_alg_common, base);
 	struct ahash_alg *ahash_alg =
 		container_of(hash_alg_common, struct ahash_alg, halg);
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 0bb99cb..2400e38 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -50,9 +50,9 @@ struct aeshash_state {
 
 /* ahash state */
 struct ahash_req_ctx {
-	u8* buff0;
-	u8* buff1;
-	u8* digest_result_buff;
+	u8 *buff0;
+	u8 *buff1;
+	u8 *digest_result_buff;
 	struct async_gen_req_ctx gen_ctx;
 	enum ssi_req_dma_buf_type data_dma_buf_type;
 	u8 *digest_buff;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index ecd4a8b..f6f7ea8 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -452,7 +452,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_req *ssi_req;
 	struct platform_device *plat_dev = drvdata->plat_dev;
-	struct ssi_request_mgr_handle * request_mgr_handle =
+	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	int rc = 0;
@@ -511,7 +511,7 @@ static void comp_handler(unsigned long devarg)
 {
 	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
 	void __iomem *cc_base = drvdata->cc_base;
-	struct ssi_request_mgr_handle * request_mgr_handle =
+	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	u32 irq;
@@ -559,7 +559,7 @@ static void comp_handler(unsigned long devarg)
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle * request_mgr_handle = drvdata->request_mgr_handle;
+	struct ssi_request_mgr_handle *request_mgr_handle = drvdata->request_mgr_handle;
 
 	spin_lock_bh(&request_mgr_handle->hw_lock);
 	request_mgr_handle->is_runtime_suspended = false;
@@ -574,7 +574,7 @@ int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
  */
 int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle * request_mgr_handle =
+	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	/* lock the send_request */
@@ -592,7 +592,7 @@ int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
 
 bool ssi_request_mgr_is_queue_runtime_suspend(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle * request_mgr_handle =
+	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	return	request_mgr_handle->is_runtime_suspended;
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 8de4353..75c9a89 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -285,7 +285,7 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 {
 	struct ssi_drvdata *drvdata = sys_get_drvdata();
 	u32 register_value;
-	void __iomem* cc_base = drvdata->cc_base;
+	void __iomem *cc_base = drvdata->cc_base;
 	int offset = 0;
 
 	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
@@ -304,7 +304,7 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 static ssize_t ssi_sys_help_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	char* help_str[] = {
+	char *help_str[] = {
 				"cat reg_dump              ", "Print several of CC register values",
 		#if defined CC_CYCLE_COUNT
 				"cat stats_host            ", "Print host statistics",
-- 
2.1.4
