From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/2] crypto: ccree: enable support for hardware keys
Date: Mon, 23 Apr 2018 08:25:14 +0100
Message-ID: <1524468316-6606-2-git-send-email-gilad@benyossef.com>
References: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enable CryptoCell support for hardware keys.

Hardware keys are regular AES keys loaded into CryptoCell internal memory
via firmware, often from secure boot ROM or hardware fuses at boot time.

As such, they can be used for enc/dec purposes like any other key but
cannot (read: extremely hard to) be extracted since since they are not
available anywhere in RAM during runtime.

The mechanism has some similarities to s390 secure keys although the keys
are not wrapped or sealed, but simply loaded offline. The interface was
therefore modeled based on the s390 secure keys support.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c                 |  43 +++++
 drivers/crypto/ccree/cc_cipher.c | 350 ++++++++++++++++++++++++++++++++++-----
 drivers/crypto/ccree/cc_cipher.h |  30 +---
 3 files changed, 361 insertions(+), 62 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 397b117..c31da0f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2582,6 +2582,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as cbc(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "cbc(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "cbc(serpent)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -2728,6 +2735,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as ctr(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "ctr(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "ctr(serpent)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -2998,6 +3012,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as ecb(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "ecb(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "ecb(khazad)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3325,6 +3346,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as ofb(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "ofb(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "pcbc(fcrypt)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -3582,6 +3610,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		/* Same as xts(aes) except the key is stored in
+		 * hardware secure memory which we reference by index
+		 */
+		.alg = "xts(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "xts4096(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "xts512(paes)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "xts(camellia)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index df98f7a..d2810c1 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -42,6 +42,7 @@ struct cc_cipher_ctx {
 	int cipher_mode;
 	int flow_mode;
 	unsigned int flags;
+	bool hw_key;
 	struct cc_user_key_info user;
 	struct cc_hw_key_info hw;
 	struct crypto_shash *shash_tfm;
@@ -49,6 +50,13 @@ struct cc_cipher_ctx {
 
 static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
 
+static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+
+	return ctx_p->hw_key;
+}
+
 static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 {
 	switch (ctx_p->flow_mode) {
@@ -211,7 +219,7 @@ struct tdes_keys {
 	u8	key3[DES_KEY_SIZE];
 };
 
-static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
+static enum cc_hw_crypto_key cc_slot_to_hw_key(int slot_num)
 {
 	switch (slot_num) {
 	case 0:
@@ -226,69 +234,100 @@ static enum cc_hw_crypto_key hw_key_to_cc_hw_key(int slot_num)
 	return END_OF_KEYS;
 }
 
-static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
-			    unsigned int keylen)
+static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
+			     unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(sktfm);
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct cc_crypto_alg *cc_alg =
-			container_of(tfm->__crt_alg, struct cc_crypto_alg,
-				     skcipher_alg.base);
-	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
+	struct cc_hkey_info hki;
 
-	dev_dbg(dev, "Setting key in context @%p for %s. keylen=%u\n",
+	dev_dbg(dev, "Setting HW key in context @%p for %s. keylen=%u\n",
 		ctx_p, crypto_tfm_alg_name(tfm), keylen);
 	dump_byte_array("key", (u8 *)key, keylen);
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
+	/* This check the size of the hardware key token */
+	if (keylen != sizeof(hki)) {
+		dev_err(dev, "Unsupported HW key size %d.\n", keylen);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (ctx_p->flow_mode != S_DIN_to_AES) {
+		dev_err(dev, "HW key not supported for non-AES flows\n");
+		return -EINVAL;
+	}
+
+	memcpy(&hki, key, keylen);
+
+	/* The real key len for crypto op is the size of the HW key
+	 * referenced by the HW key slot, not the hardware key token
+	 */
+	keylen = hki.keylen;
+
 	if (validate_keys_sizes(ctx_p, keylen)) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	if (cc_is_hw_key(tfm)) {
-		/* setting HW key slots */
-		struct arm_hw_key_info *hki = (struct arm_hw_key_info *)key;
+	ctx_p->hw.key1_slot = cc_slot_to_hw_key(hki.hw_key1);
+	if (ctx_p->hw.key1_slot == END_OF_KEYS) {
+		dev_err(dev, "Unsupported hw key1 number (%d)\n", hki.hw_key1);
+		return -EINVAL;
+	}
 
-		if (ctx_p->flow_mode != S_DIN_to_AES) {
-			dev_err(dev, "HW key not supported for non-AES flows\n");
+	if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+	    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+	    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
+		if (hki.hw_key1 == hki.hw_key2) {
+			dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
+				hki.hw_key1, hki.hw_key2);
 			return -EINVAL;
 		}
-
-		ctx_p->hw.key1_slot = hw_key_to_cc_hw_key(hki->hw_key1);
-		if (ctx_p->hw.key1_slot == END_OF_KEYS) {
-			dev_err(dev, "Unsupported hw key1 number (%d)\n",
-				hki->hw_key1);
+		ctx_p->hw.key2_slot = cc_slot_to_hw_key(hki.hw_key2);
+		if (ctx_p->hw.key2_slot == END_OF_KEYS) {
+			dev_err(dev, "Unsupported hw key2 number (%d)\n",
+				hki.hw_key2);
 			return -EINVAL;
 		}
+	}
 
-		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
-			if (hki->hw_key1 == hki->hw_key2) {
-				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
-					hki->hw_key1, hki->hw_key2);
-				return -EINVAL;
-			}
-			ctx_p->hw.key2_slot =
-				hw_key_to_cc_hw_key(hki->hw_key2);
-			if (ctx_p->hw.key2_slot == END_OF_KEYS) {
-				dev_err(dev, "Unsupported hw key2 number (%d)\n",
-					hki->hw_key2);
-				return -EINVAL;
-			}
-		}
+	ctx_p->keylen = keylen;
+	ctx_p->hw_key = true;
+	dev_dbg(dev, "cc_is_hw_key ret 0");
+
+	return 0;
+}
+
+static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(sktfm);
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	u32 tmp[DES3_EDE_EXPKEY_WORDS];
+	struct cc_crypto_alg *cc_alg =
+			container_of(tfm->__crt_alg, struct cc_crypto_alg,
+				     skcipher_alg.base);
+	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
+
+	dev_dbg(dev, "Setting key in context @%p for %s. keylen=%u\n",
+		ctx_p, crypto_tfm_alg_name(tfm), keylen);
+	dump_byte_array("key", (u8 *)key, keylen);
 
-		ctx_p->keylen = keylen;
-		dev_dbg(dev, "cc_is_hw_key ret 0");
+	/* STAT_PHASE_0: Init and sanity checks */
 
-		return 0;
+	if (validate_keys_sizes(ctx_p, keylen)) {
+		dev_err(dev, "Unsupported key size %d.\n", keylen);
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
 	}
 
+	ctx_p->hw_key = false;
+
 	/*
 	 * Verify DES weak keys
 	 * Note that we're dropping the expanded key since the
@@ -735,6 +774,241 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
 /* Block cipher alg */
 static const struct cc_alg_template skcipher_algs[] = {
 	{
+		.name = "xts(paes)",
+		.driver_name = "xts-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_630,
+	},
+	{
+		.name = "xts512(paes)",
+		.driver_name = "xts-paes-du512-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 512,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "xts4096(paes)",
+		.driver_name = "xts-paes-du4096-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_XTS,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 4096,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "essiv(paes)",
+		.driver_name = "essiv-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "essiv512(paes)",
+		.driver_name = "essiv-paes-du512-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 512,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "essiv4096(paes)",
+		.driver_name = "essiv-paes-du4096-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_ESSIV,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 4096,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "bitlocker(paes)",
+		.driver_name = "bitlocker-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "bitlocker512(paes)",
+		.driver_name = "bitlocker-paes-du512-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 512,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "bitlocker4096(paes)",
+		.driver_name = "bitlocker-paes-du4096-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize =  CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.data_unit = 4096,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "ecb(paes)",
+		.driver_name = "ecb-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = 0,
+			},
+		.cipher_mode = DRV_CIPHER_ECB,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "cbc(paes)",
+		.driver_name = "cbc-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "ofb(paes)",
+		.driver_name = "ofb-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_OFB,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "cts1(cbc(paes))",
+		.driver_name = "cts1-cbc-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC_CTS,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
+		.name = "ctr(paes)",
+		.driver_name = "ctr-paes-ccree",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+	},
+	{
 		.name = "xts(aes)",
 		.driver_name = "xts-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
diff --git a/drivers/crypto/ccree/cc_cipher.h b/drivers/crypto/ccree/cc_cipher.h
index 2a2a6f4..68444cf 100644
--- a/drivers/crypto/ccree/cc_cipher.h
+++ b/drivers/crypto/ccree/cc_cipher.h
@@ -13,18 +13,6 @@
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 
-/* Crypto cipher flags */
-#define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
-#define CC_CRYPTO_CIPHER_KEY_KFDE1	BIT(1)
-#define CC_CRYPTO_CIPHER_KEY_KFDE2	BIT(2)
-#define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
-#define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)
-
-#define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE1 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE2 | \
-					CC_CRYPTO_CIPHER_KEY_KFDE3)
-
 struct cipher_req_ctx {
 	struct async_gen_req_ctx gen_ctx;
 	enum cc_req_dma_buf_type dma_buf_type;
@@ -42,18 +30,12 @@ int cc_cipher_alloc(struct cc_drvdata *drvdata);
 
 int cc_cipher_free(struct cc_drvdata *drvdata);
 
-struct arm_hw_key_info {
-	int hw_key1;
-	int hw_key2;
-};
+struct cc_hkey_info {
+	u16 keylen;
+	u8 hw_key1;
+	u8 hw_key2;
+} __packed;
 
-/*
- * This is a stub function that will replaced when we
- * implement secure keys
- */
-static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
-{
-	return false;
-}
+#define CC_HW_KEY_SIZE sizeof(struct cc_hkey_info)
 
 #endif /*__CC_CIPHER_H__*/
-- 
2.7.4
