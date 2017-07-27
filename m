From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/4] staging: ccree: remove func name from log messages
Date: Thu, 27 Jul 2017 13:43:17 +0300
Message-ID: <1501152199-7671-4-git-send-email-gilad@benyossef.com>
References: <1501152199-7671-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501152199-7671-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The SSI_LOG macros already add __func__ to log messages, so remove
log message that add them a second time in the log message itself.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c   |  4 ++--
 drivers/staging/ccree/ssi_cipher.c | 14 +++++++-------
 drivers/staging/ccree/ssi_driver.c |  2 +-
 drivers/staging/ccree/ssi_hash.c   |  2 +-
 drivers/staging/ccree/ssi_pm.c     |  4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index c6edef0..aa94839 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2269,7 +2269,7 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 				       unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4106_gcm_setauthsize()  authsize %d\n", authsize);
+	SSI_LOG_DEBUG("authsize %d\n", authsize);
 
 	switch (authsize) {
 	case 8:
@@ -2286,7 +2286,7 @@ static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
 				       unsigned int authsize)
 {
-	SSI_LOG_DEBUG("ssi_rfc4543_gcm_setauthsize()  authsize %d\n", authsize);
+	SSI_LOG_DEBUG("authsize %d\n", authsize);
 
 	if (authsize != 16)
 		return -EINVAL;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 4ee2a12..61976b5 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -304,7 +304,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		      ctx_p, crypto_tfm_alg_name(tfm), keylen);
 	dump_byte_array("key", (u8 *)key, keylen);
 
-	SSI_LOG_DEBUG("ssi_blkcipher_setkey: after FIPS check");
+	SSI_LOG_DEBUG("after FIPS check");
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
@@ -350,7 +350,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		}
 
 		ctx_p->keylen = keylen;
-		SSI_LOG_DEBUG("ssi_blkcipher_setkey: ssi_is_hw_key ret 0");
+		SSI_LOG_DEBUG("ssi_is_hw_key ret 0");
 
 		return 0;
 	}
@@ -360,19 +360,19 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		if (unlikely(!des_ekey(tmp, key)) &&
 		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			SSI_LOG_DEBUG("ssi_blkcipher_setkey:  weak DES key");
+			SSI_LOG_DEBUG("weak DES key");
 			return -EINVAL;
 		}
 	}
 	if ((ctx_p->cipher_mode == DRV_CIPHER_XTS) &&
 	    xts_check_key(tfm, key, keylen) != 0) {
-		SSI_LOG_DEBUG("ssi_blkcipher_setkey: weak XTS key");
+		SSI_LOG_DEBUG("weak XTS key");
 		return -EINVAL;
 	}
 	if ((ctx_p->flow_mode == S_DIN_to_DES) &&
 	    (keylen == DES3_EDE_KEY_SIZE) &&
 	    ssi_verify_3des_keys(key, keylen) != 0) {
-		SSI_LOG_DEBUG("ssi_blkcipher_setkey: weak 3DES key");
+		SSI_LOG_DEBUG("weak 3DES key");
 		return -EINVAL;
 	}
 
@@ -387,7 +387,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
 		    ctx_p->key_round_number > CC_MULTI2_MAX_NUM_ROUNDS) {
 			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-			SSI_LOG_DEBUG("ssi_blkcipher_setkey: SSI_CC_HAS_MULTI2 einval");
+			SSI_LOG_DEBUG("SSI_CC_HAS_MULTI2 einval");
 			return -EINVAL;
 #endif /*SSI_CC_HAS_MULTI2*/
 	} else {
@@ -414,7 +414,7 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 				   max_key_buf_size, DMA_TO_DEVICE);
 	ctx_p->keylen = keylen;
 
-	 SSI_LOG_DEBUG("ssi_blkcipher_setkey: return safely");
+	 SSI_LOG_DEBUG("return safely");
 	return 0;
 }
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index b26eebd..d104dbd 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -81,7 +81,7 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 	char line_buf[80];
 
 	if (!the_array) {
-		SSI_LOG_ERR("cannot %s - NULL pointer\n", __func__);
+		SSI_LOG_ERR("cannot dump array - NULL pointer\n");
 		return;
 	}
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index eb5b78f..736dedc 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -974,7 +974,7 @@ static int ssi_hash_setkey(void *hash,
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
 	ssi_sram_addr_t larval_addr;
 
-	 SSI_LOG_DEBUG("ssi_hash_setkey: start keylen: %d", keylen);
+	 SSI_LOG_DEBUG("start keylen: %d", keylen);
 
 	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
 	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 52a8ed5..31325e6 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -40,7 +40,7 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 		(struct ssi_drvdata *)dev_get_drvdata(dev);
 	int rc;
 
-	SSI_LOG_DEBUG("ssi_power_mgr_runtime_suspend: set HOST_POWER_DOWN_EN\n");
+	SSI_LOG_DEBUG("set HOST_POWER_DOWN_EN\n");
 	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
 	if (rc != 0) {
@@ -58,7 +58,7 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 	struct ssi_drvdata *drvdata =
 		(struct ssi_drvdata *)dev_get_drvdata(dev);
 
-	SSI_LOG_DEBUG("ssi_power_mgr_runtime_resume , unset HOST_POWER_DOWN_EN\n");
+	SSI_LOG_DEBUG("unset HOST_POWER_DOWN_EN\n");
 	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
 
 	rc = cc_clk_on(drvdata);
-- 
2.1.4
