From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2] staging: ccree: - style fix, spaces and tabs
Date: Sat, 17 Jun 2017 14:44:05 +1200
Message-ID: <20170617024405.13672-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35355 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbdFQCoP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 22:44:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changed code indent to be tabs across whole driver
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>

V1 had vague subject.
---
 drivers/staging/ccree/ssi_cipher.c     | 45 +++++++++++++++++-----------------
 drivers/staging/ccree/ssi_driver.c     |  6 ++---
 drivers/staging/ccree/ssi_driver.h     |  6 ++---
 drivers/staging/ccree/ssi_fips.h       |  8 +++---
 drivers/staging/ccree/ssi_fips_ext.c   |  4 +--
 drivers/staging/ccree/ssi_fips_ll.c    | 40 +++++++++++++++---------------
 drivers/staging/ccree/ssi_fips_local.c | 28 ++++++++++-----------
 drivers/staging/ccree/ssi_fips_local.h | 12 ++++-----
 8 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 2dfc6a3bd4c1..34450a5e6573 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -258,45 +258,45 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
 
 
 typedef struct tdes_keys{
-        u8      key1[DES_KEY_SIZE];
-        u8      key2[DES_KEY_SIZE];
-        u8      key3[DES_KEY_SIZE];
+	u8	key1[DES_KEY_SIZE];
+	u8	key2[DES_KEY_SIZE];
+	u8	key3[DES_KEY_SIZE];
 }tdes_keys_t;
 
-static const u8 zero_buff[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
-                               0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
+static const u8 zero_buff[] = {	0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
 
 /* The function verifies that tdes keys are not weak.*/
 static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
 {
 #ifdef CCREE_FIPS_SUPPORT
-        tdes_keys_t *tdes_key = (tdes_keys_t*)key;
+	tdes_keys_t *tdes_key = (tdes_keys_t*)key;
 
 	/* verify key1 != key2 and key3 != key2*/
-        if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
+	if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2, sizeof(tdes_key->key1)) == 0) ||
 		      (memcmp((u8*)tdes_key->key3, (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0) )) {
-                return -ENOEXEC;
-        }
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
@@ -720,12 +720,13 @@ ssi_blkcipher_create_data_desc(
 }
 
 static int ssi_blkcipher_complete(struct device *dev,
-                                  struct ssi_ablkcipher_ctx *ctx_p,
-                                  struct blkcipher_req_ctx *req_ctx,
-                                  struct scatterlist *dst, struct scatterlist *src,
-                                  unsigned int ivsize,
-                                  void *areq,
-                                  void __iomem *cc_base)
+				struct ssi_ablkcipher_ctx *ctx_p,
+				struct blkcipher_req_ctx *req_ctx,
+				struct scatterlist *dst,
+				struct scatterlist *src,
+				unsigned int ivsize,
+				void *areq,
+				void __iomem *cc_base)
 {
 	int completion_error = 0;
 	u32 inflight_counter;
@@ -779,7 +780,7 @@ static int ssi_blkcipher_process(
 		/* No data to process is valid */
 		return 0;
 	}
-        /*For CTS in case of data size aligned to 16 use CBC mode*/
+	/*For CTS in case of data size aligned to 16 use CBC mode*/
 	if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS)){
 
 		ctx_p->cipher_mode = DRV_CIPHER_CBC;
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 190922970bf0..b9d0dd27e853 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -437,9 +437,9 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	struct ssi_drvdata *drvdata =
 		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
 
-        ssi_aead_free(drvdata);
-        ssi_hash_free(drvdata);
-        ssi_ablkcipher_free(drvdata);
+	ssi_aead_free(drvdata);
+	ssi_hash_free(drvdata);
+	ssi_ablkcipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
 	ssi_power_mgr_fini(drvdata);
 	ssi_buffer_mgr_fini(drvdata);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 34bd7efb1907..78a327aa9029 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -110,9 +110,9 @@ struct ssi_crypto_req {
 	void *user_arg;
 	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES];
 	/* For the first 'ivgen_dma_addr_len' addresses of this array,
- 	 * generated IV would be placed in it by send_request().
- 	 * Same generated IV for all addresses!
- 	 */
+	 * generated IV would be placed in it by send_request().
+	 * Same generated IV for all addresses!
+	 */
 	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
 	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
 	struct completion seq_compl; /* request completion */
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index e108d89ef98c..2fdb1b90a890 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -23,10 +23,10 @@
  */
 
 typedef enum ssi_fips_state {
-        CC_FIPS_STATE_NOT_SUPPORTED = 0,
-        CC_FIPS_STATE_SUPPORTED,
-        CC_FIPS_STATE_ERROR,
-        CC_FIPS_STATE_RESERVE32B = S32_MAX
+	CC_FIPS_STATE_NOT_SUPPORTED = 0,
+	CC_FIPS_STATE_SUPPORTED,
+	CC_FIPS_STATE_ERROR,
+	CC_FIPS_STATE_RESERVE32B = S32_MAX
 } ssi_fips_state_t;
 
 
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index 0f53a4bc43de..aa90ddd14b99 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -39,7 +39,7 @@ static ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
  */
 int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
 {
-        int rc = 0;
+	int rc = 0;
 
 	if (p_state == NULL) {
 		return -EINVAL;
@@ -58,7 +58,7 @@ int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
  */
 int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
 {
-        int rc = 0;
+	int rc = 0;
 
 	if (p_err == NULL) {
 		return -EINVAL;
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index cdfbf04d7ad3..6c79e7de207f 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -233,8 +233,8 @@ static const FipsCmacData FipsCmacDataTable[] = {
 #define FIPS_CMAC_NUM_OF_TESTS        (sizeof(FipsCmacDataTable) / sizeof(FipsCmacData))
 
 static const FipsHashData FipsHashDataTable[] = {
-        { DRV_HASH_SHA1,   NIST_SHA_1_MSG,   NIST_SHA_MSG_SIZE, NIST_SHA_1_MD },
-        { DRV_HASH_SHA256, NIST_SHA_256_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_256_MD },
+	{ DRV_HASH_SHA1,   NIST_SHA_1_MSG,   NIST_SHA_MSG_SIZE, NIST_SHA_1_MD },
+	{ DRV_HASH_SHA256, NIST_SHA_256_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_256_MD },
 #if (CC_SUPPORT_SHA > 256)
 //        { DRV_HASH_SHA512, NIST_SHA_512_MSG, NIST_SHA_MSG_SIZE, NIST_SHA_512_MD },
 #endif
@@ -242,8 +242,8 @@ static const FipsHashData FipsHashDataTable[] = {
 #define FIPS_HASH_NUM_OF_TESTS        (sizeof(FipsHashDataTable) / sizeof(FipsHashData))
 
 static const FipsHmacData FipsHmacDataTable[] = {
-        { DRV_HASH_SHA1,   NIST_HMAC_SHA1_KEY,   NIST_HMAC_SHA1_KEY_SIZE,   NIST_HMAC_SHA1_MSG,   NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA1_MD },
-        { DRV_HASH_SHA256, NIST_HMAC_SHA256_KEY, NIST_HMAC_SHA256_KEY_SIZE, NIST_HMAC_SHA256_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA256_MD },
+	{ DRV_HASH_SHA1,   NIST_HMAC_SHA1_KEY,   NIST_HMAC_SHA1_KEY_SIZE,   NIST_HMAC_SHA1_MSG,   NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA1_MD },
+	{ DRV_HASH_SHA256, NIST_HMAC_SHA256_KEY, NIST_HMAC_SHA256_KEY_SIZE, NIST_HMAC_SHA256_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA256_MD },
 #if (CC_SUPPORT_SHA > 256)
 //        { DRV_HASH_SHA512, NIST_HMAC_SHA512_KEY, NIST_HMAC_SHA512_KEY_SIZE, NIST_HMAC_SHA512_MSG, NIST_HMAC_MSG_SIZE, NIST_HMAC_SHA512_MD },
 #endif
@@ -251,22 +251,22 @@ static const FipsHmacData FipsHmacDataTable[] = {
 #define FIPS_HMAC_NUM_OF_TESTS        (sizeof(FipsHmacDataTable) / sizeof(FipsHmacData))
 
 static const FipsCcmData FipsCcmDataTable[] = {
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_128_KEY, NIST_AESCCM_128_BIT_KEY_SIZE, NIST_AESCCM_128_NONCE, NIST_AESCCM_128_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_128_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_128_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_128_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_192_KEY, NIST_AESCCM_192_BIT_KEY_SIZE, NIST_AESCCM_192_NONCE, NIST_AESCCM_192_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_192_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_192_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_192_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESCCM_256_KEY, NIST_AESCCM_256_BIT_KEY_SIZE, NIST_AESCCM_256_NONCE, NIST_AESCCM_256_ADATA, NIST_AESCCM_ADATA_SIZE, NIST_AESCCM_256_CIPHER, NIST_AESCCM_TEXT_SIZE, NIST_AESCCM_256_PLAIN_TEXT, NIST_AESCCM_TAG_SIZE, NIST_AESCCM_256_MAC },
 };
 #define FIPS_CCM_NUM_OF_TESTS        (sizeof(FipsCcmDataTable) / sizeof(FipsCcmData))
 
 static const FipsGcmData FipsGcmDataTable[] = {
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
-        { DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
-        { DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_128_KEY, NIST_AESGCM_128_BIT_KEY_SIZE, NIST_AESGCM_128_IV, NIST_AESGCM_128_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_128_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_128_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_128_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_192_KEY, NIST_AESGCM_192_BIT_KEY_SIZE, NIST_AESGCM_192_IV, NIST_AESGCM_192_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_192_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_192_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_192_MAC },
+	{ DRV_CRYPTO_DIRECTION_ENCRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
+	{ DRV_CRYPTO_DIRECTION_DECRYPT, NIST_AESGCM_256_KEY, NIST_AESGCM_256_BIT_KEY_SIZE, NIST_AESGCM_256_IV, NIST_AESGCM_256_ADATA, NIST_AESGCM_ADATA_SIZE, NIST_AESGCM_256_CIPHER, NIST_AESGCM_TEXT_SIZE, NIST_AESGCM_256_PLAIN_TEXT, NIST_AESGCM_TAG_SIZE, NIST_AESGCM_256_MAC },
 };
 #define FIPS_GCM_NUM_OF_TESTS        (sizeof(FipsGcmDataTable) / sizeof(FipsGcmData))
 
@@ -758,7 +758,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 			FIPS_LOG("ssi_hash_fips_run_test %d returned error - rc = %d \n", i, rc);
 			error = FIPS_HashToFipsError(hash_data->hash_mode);
 			break;
-                }
+		}
 
 		/* compare actual mac result to expected */
 		if (memcmp(virt_ctx->mac_res, hash_data->mac_res, digest_size) != 0)
@@ -773,7 +773,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 
 			error = FIPS_HashToFipsError(hash_data->hash_mode);
 			break;
-                }
+		}
 	}
 
 	return error;
@@ -1317,9 +1317,9 @@ ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 		if (memcmp(virt_ctx->dout, ccmData->dataOut, ccmData->dataInSize) != 0)
 		{
 			FIPS_LOG("dout comparison error %d - size=%d \n", i, ccmData->dataInSize);
-                        error = CC_REE_FIPS_ERROR_AESCCM_PUT;
+			error = CC_REE_FIPS_ERROR_AESCCM_PUT;
 			break;
-                }
+		}
 
 		/* compare actual mac result to expected */
 		if (memcmp(virt_ctx->mac_res, ccmData->macResOut, ccmData->tagSize) != 0)
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 8076c771f750..d6c994a2362c 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -264,32 +264,32 @@ int ssi_fips_set_state(ssi_fips_state_t state)
 int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
 {
 	int rc = 0;
-        ssi_fips_error_t current_err;
+	ssi_fips_error_t current_err;
 
-        FIPS_LOG("ssi_fips_set_error - fips_error = %d \n", err);
+	FIPS_LOG("ssi_fips_set_error - fips_error = %d \n", err);
 
 	// setting no error is not allowed
 	if (err == CC_REE_FIPS_ERROR_OK) {
-                return -ENOEXEC;
+		return -ENOEXEC;
+	}
+	// If error exists, do not set new error
+	if (ssi_fips_get_error(&current_err) != 0) {
+		return -ENOEXEC;
 	}
-        // If error exists, do not set new error
-        if (ssi_fips_get_error(&current_err) != 0) {
-                return -ENOEXEC;
-        }
-        if (current_err != CC_REE_FIPS_ERROR_OK) {
-                return -ENOEXEC;
-        }
-        // set REE internal error and state
+	if (current_err != CC_REE_FIPS_ERROR_OK) {
+		return -ENOEXEC;
+	}
+	// set REE internal error and state
 	rc = ssi_fips_ext_set_error(err);
 	if (rc != 0) {
-                return -ENOEXEC;
+		return -ENOEXEC;
 	}
 	rc = ssi_fips_ext_set_state(CC_FIPS_STATE_ERROR);
 	if (rc != 0) {
-                return -ENOEXEC;
+		return -ENOEXEC;
 	}
 
-        // push error towards TEE libraray, if it's not TEE error
+	// push error towards TEE libraray, if it's not TEE error
 	if (err != CC_REE_FIPS_ERROR_FROM_TEE) {
 		ssi_fips_update_tee_upon_ree_status(p_drvdata, err);
 	}
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index 038dd3b24903..ac1ab967def5 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -34,14 +34,14 @@ typedef enum CC_FipsSyncStatus{
 
 
 #define CHECK_AND_RETURN_UPON_FIPS_ERROR() {\
-        if (ssi_fips_check_fips_error() != 0) {\
-                return -ENOEXEC;\
-        }\
+	if (ssi_fips_check_fips_error() != 0) {\
+		return -ENOEXEC;\
+	}\
 }
 #define CHECK_AND_RETURN_VOID_UPON_FIPS_ERROR() {\
-        if (ssi_fips_check_fips_error() != 0) {\
-                return;\
-        }\
+	if (ssi_fips_check_fips_error() != 0) {\
+		return;\
+	}\
 }
 #define SSI_FIPS_INIT(p_drvData)  (ssi_fips_init(p_drvData))
 #define SSI_FIPS_FINI(p_drvData)  (ssi_fips_fini(p_drvData))
-- 
2.13.0
