Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3E3C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFF81217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389235AbfDRNj5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:57 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:33512 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNj4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25F4380D;
        Thu, 18 Apr 2019 06:39:56 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DDFC3F5AF;
        Thu, 18 Apr 2019 06:39:54 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/35] crypto: ccree: add remaining logic for CPP
Date:   Thu, 18 Apr 2019 16:38:41 +0300
Message-Id: <20190418133913.9122-7-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing logic to set usage policy protections for keys.
This enables key policy protection for AES.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c        | 186 +++++++++++++++++-------
 drivers/crypto/ccree/cc_hw_queue_defs.h |  37 +++++
 drivers/crypto/ccree/cc_kernel_regs.h   |   6 +
 3 files changed, 178 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 8a9c664390f0..d1754d1156ee 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -34,6 +34,18 @@ struct cc_hw_key_info {
 	enum cc_hw_crypto_key key2_slot;
 };
 
+struct cc_cpp_key_info {
+	u8 slot;
+	enum cc_cpp_alg alg;
+};
+
+enum cc_key_type {
+	CC_UNPROTECTED_KEY,		/* User key */
+	CC_HW_PROTECTED_KEY,		/* HW (FDE) key */
+	CC_POLICY_PROTECTED_KEY,	/* CPP key */
+	CC_INVALID_PROTECTED_KEY	/* Invalid key */
+};
+
 struct cc_cipher_ctx {
 	struct cc_drvdata *drvdata;
 	int keylen;
@@ -41,19 +53,22 @@ struct cc_cipher_ctx {
 	int cipher_mode;
 	int flow_mode;
 	unsigned int flags;
-	bool hw_key;
+	enum cc_key_type key_type;
 	struct cc_user_key_info user;
-	struct cc_hw_key_info hw;
+	union {
+		struct cc_hw_key_info hw;
+		struct cc_cpp_key_info cpp;
+	};
 	struct crypto_shash *shash_tfm;
 };
 
 static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
 
-static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
+static inline enum cc_key_type cc_key_type(struct crypto_tfm *tfm)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 
-	return ctx_p->hw_key;
+	return ctx_p->key_type;
 }
 
 static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
@@ -232,7 +247,7 @@ struct tdes_keys {
 	u8	key3[DES_KEY_SIZE];
 };
 
-static enum cc_hw_crypto_key cc_slot_to_hw_key(int slot_num)
+static enum cc_hw_crypto_key cc_slot_to_hw_key(u8 slot_num)
 {
 	switch (slot_num) {
 	case 0:
@@ -247,6 +262,22 @@ static enum cc_hw_crypto_key cc_slot_to_hw_key(int slot_num)
 	return END_OF_KEYS;
 }
 
+static u8 cc_slot_to_cpp_key(u8 slot_num)
+{
+	return (slot_num - CC_FIRST_CPP_KEY_SLOT);
+}
+
+static inline enum cc_key_type cc_slot_to_key_type(u8 slot_num)
+{
+	if (slot_num >= CC_FIRST_HW_KEY_SLOT && slot_num <= CC_LAST_HW_KEY_SLOT)
+		return CC_HW_PROTECTED_KEY;
+	else if (slot_num >=  CC_FIRST_CPP_KEY_SLOT &&
+		 slot_num <=  CC_LAST_CPP_KEY_SLOT)
+		return CC_POLICY_PROTECTED_KEY;
+	else
+		return CC_INVALID_PROTECTED_KEY;
+}
+
 static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 			     unsigned int keylen)
 {
@@ -261,18 +292,13 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
-	/* This check the size of the hardware key token */
+	/* This check the size of the protected key token */
 	if (keylen != sizeof(hki)) {
-		dev_err(dev, "Unsupported HW key size %d.\n", keylen);
+		dev_err(dev, "Unsupported protected key size %d.\n", keylen);
 		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	if (ctx_p->flow_mode != S_DIN_to_AES) {
-		dev_err(dev, "HW key not supported for non-AES flows\n");
-		return -EINVAL;
-	}
-
 	memcpy(&hki, key, keylen);
 
 	/* The real key len for crypto op is the size of the HW key
@@ -286,31 +312,70 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 		return -EINVAL;
 	}
 
-	ctx_p->hw.key1_slot = cc_slot_to_hw_key(hki.hw_key1);
-	if (ctx_p->hw.key1_slot == END_OF_KEYS) {
-		dev_err(dev, "Unsupported hw key1 number (%d)\n", hki.hw_key1);
-		return -EINVAL;
-	}
+	ctx_p->keylen = keylen;
 
-	if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-	    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-	    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
-		if (hki.hw_key1 == hki.hw_key2) {
-			dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
-				hki.hw_key1, hki.hw_key2);
+	switch (cc_slot_to_key_type(hki.hw_key1)) {
+	case CC_HW_PROTECTED_KEY:
+		if (ctx_p->flow_mode == S_DIN_to_SM4) {
+			dev_err(dev, "Only AES HW protected keys are supported\n");
 			return -EINVAL;
 		}
-		ctx_p->hw.key2_slot = cc_slot_to_hw_key(hki.hw_key2);
-		if (ctx_p->hw.key2_slot == END_OF_KEYS) {
-			dev_err(dev, "Unsupported hw key2 number (%d)\n",
-				hki.hw_key2);
+
+		ctx_p->hw.key1_slot = cc_slot_to_hw_key(hki.hw_key1);
+		if (ctx_p->hw.key1_slot == END_OF_KEYS) {
+			dev_err(dev, "Unsupported hw key1 number (%d)\n",
+				hki.hw_key1);
 			return -EINVAL;
 		}
-	}
 
-	ctx_p->keylen = keylen;
-	ctx_p->hw_key = true;
-	dev_dbg(dev, "cc_is_hw_key ret 0");
+		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
+			if (hki.hw_key1 == hki.hw_key2) {
+				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
+					hki.hw_key1, hki.hw_key2);
+				return -EINVAL;
+			}
+
+			ctx_p->hw.key2_slot = cc_slot_to_hw_key(hki.hw_key2);
+			if (ctx_p->hw.key2_slot == END_OF_KEYS) {
+				dev_err(dev, "Unsupported hw key2 number (%d)\n",
+					hki.hw_key2);
+				return -EINVAL;
+			}
+		}
+
+		ctx_p->key_type = CC_HW_PROTECTED_KEY;
+		dev_dbg(dev, "HW protected key  %d/%d set\n.",
+			ctx_p->hw.key1_slot, ctx_p->hw.key2_slot);
+		break;
+
+	case CC_POLICY_PROTECTED_KEY:
+		if (ctx_p->drvdata->hw_rev < CC_HW_REV_713) {
+			dev_err(dev, "CPP keys not supported in this hardware revision.\n");
+			return -EINVAL;
+		}
+
+		if (ctx_p->cipher_mode != DRV_CIPHER_CBC &&
+		    ctx_p->cipher_mode != DRV_CIPHER_CTR) {
+			dev_err(dev, "CPP keys only supported in CBC or CTR modes.\n");
+			return -EINVAL;
+		}
+
+		ctx_p->cpp.slot = cc_slot_to_cpp_key(hki.hw_key1);
+		if (ctx_p->flow_mode == S_DIN_to_AES)
+			ctx_p->cpp.alg = CC_CPP_AES;
+		else /* Must be SM4 since due to sethkey registration */
+			ctx_p->cpp.alg = CC_CPP_SM4;
+		ctx_p->key_type = CC_POLICY_PROTECTED_KEY;
+		dev_dbg(dev, "policy protedcted key alg: %d slot: %d.\n",
+			ctx_p->cpp.alg, ctx_p->cpp.slot);
+		break;
+
+	default:
+		dev_err(dev, "Unsupported protected key (%d)\n", hki.hw_key1);
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -338,7 +403,7 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 		return -EINVAL;
 	}
 
-	ctx_p->hw_key = false;
+	ctx_p->key_type = CC_UNPROTECTED_KEY;
 
 	/*
 	 * Verify DES weak keys
@@ -451,7 +516,7 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_is_hw_key(tfm)) {
+		if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
 			set_hw_crypto_key(&desc[*seq_size],
 					  ctx_p->hw.key2_slot);
 		} else {
@@ -495,6 +560,7 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
 	unsigned int key_len = ctx_p->keylen;
 	unsigned int du_size = nbytes;
+	unsigned int din_size;
 
 	struct cc_crypto_alg *cc_alg =
 		container_of(tfm->__crt_alg, struct cc_crypto_alg,
@@ -511,27 +577,38 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	case DRV_CIPHER_ECB:
 		/* Load key */
 		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (flow_mode == S_DIN_to_AES) {
-			if (cc_is_hw_key(tfm)) {
-				set_hw_crypto_key(&desc[*seq_size],
-						  ctx_p->hw.key1_slot);
+		if (cc_key_type(tfm) == CC_POLICY_PROTECTED_KEY) {
+			set_cpp_crypto_key(&desc[*seq_size], ctx_p->cpp.alg,
+					   cipher_mode, ctx_p->cpp.slot);
+		} else {
+			set_cipher_mode(&desc[*seq_size], cipher_mode);
+			set_cipher_config0(&desc[*seq_size], direction);
+			if (flow_mode == S_DIN_to_AES) {
+				if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
+					set_hw_crypto_key(&desc[*seq_size],
+							  ctx_p->hw.key1_slot);
+				} else {
+					/* CC_POLICY_UNPROTECTED_KEY
+					 * Invalid keys are filtered out in
+					 * sethkey()
+					 */
+					din_size = (key_len == 24) ?
+						AES_MAX_KEY_SIZE : key_len;
+
+					set_din_type(&desc[*seq_size], DMA_DLLI,
+						     key_dma_addr, din_size,
+						     NS_BIT);
+				}
+				set_key_size_aes(&desc[*seq_size], key_len);
 			} else {
+				/*des*/
 				set_din_type(&desc[*seq_size], DMA_DLLI,
-					     key_dma_addr, ((key_len == 24) ?
-							    AES_MAX_KEY_SIZE :
-							    key_len), NS_BIT);
+					     key_dma_addr, key_len, NS_BIT);
+				set_key_size_des(&desc[*seq_size], key_len);
 			}
-			set_key_size_aes(&desc[*seq_size], key_len);
-		} else {
-			/*des*/
-			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
-				     key_len, NS_BIT);
-			set_key_size_des(&desc[*seq_size], key_len);
+			set_flow_mode(&desc[*seq_size], flow_mode);
+			set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		}
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		(*seq_size)++;
 		break;
 	case DRV_CIPHER_XTS:
@@ -541,7 +618,7 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_is_hw_key(tfm)) {
+		if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
 			set_hw_crypto_key(&desc[*seq_size],
 					  ctx_p->hw.key1_slot);
 		} else {
@@ -789,6 +866,13 @@ static int cc_cipher_process(struct skcipher_request *req,
 	cc_req.user_cb = (void *)cc_cipher_complete;
 	cc_req.user_arg = (void *)req;
 
+	/* Setup CPP operation details */
+	if (ctx_p->key_type == CC_POLICY_PROTECTED_KEY) {
+		cc_req.cpp.is_cpp = true;
+		cc_req.cpp.alg = ctx_p->cpp.alg;
+		cc_req.cpp.slot = ctx_p->cpp.slot;
+	}
+
 	/* Setup request context */
 	req_ctx->gen_ctx.op_type = direction;
 
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index 7a9b90db7db7..2c8cd907d8db 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -28,11 +28,13 @@
 	GENMASK(CC_REG_HIGH(word, name), CC_REG_LOW(word, name))
 
 #define WORD0_VALUE		CC_GENMASK(0, VALUE)
+#define	WORD0_CPP_CIPHER_MODE	CC_GENMASK(0, CPP_CIPHER_MODE)
 #define WORD1_DIN_CONST_VALUE	CC_GENMASK(1, DIN_CONST_VALUE)
 #define WORD1_DIN_DMA_MODE	CC_GENMASK(1, DIN_DMA_MODE)
 #define WORD1_DIN_SIZE		CC_GENMASK(1, DIN_SIZE)
 #define WORD1_NOT_LAST		CC_GENMASK(1, NOT_LAST)
 #define WORD1_NS_BIT		CC_GENMASK(1, NS_BIT)
+#define WORD1_LOCK_QUEUE	CC_GENMASK(1, LOCK_QUEUE)
 #define WORD2_VALUE		CC_GENMASK(2, VALUE)
 #define WORD3_DOUT_DMA_MODE	CC_GENMASK(3, DOUT_DMA_MODE)
 #define WORD3_DOUT_LAST_IND	CC_GENMASK(3, DOUT_LAST_IND)
@@ -53,6 +55,8 @@
 #define WORD4_DATA_FLOW_MODE	CC_GENMASK(4, DATA_FLOW_MODE)
 #define WORD4_KEY_SIZE		CC_GENMASK(4, KEY_SIZE)
 #define WORD4_SETUP_OPERATION	CC_GENMASK(4, SETUP_OPERATION)
+#define WORD4_CPP_ALG		CC_GENMASK(4, CPP_ALG)
+#define WORD4_CPP_SLOT		CC_GENMASK(4, CPP_SLOT)
 #define WORD5_DIN_ADDR_HIGH	CC_GENMASK(5, DIN_ADDR_HIGH)
 #define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
 
@@ -176,6 +180,15 @@ enum cc_hw_crypto_key {
 	END_OF_KEYS = S32_MAX,
 };
 
+#define CC_NUM_HW_KEY_SLOTS	4
+#define CC_FIRST_HW_KEY_SLOT	0
+#define CC_LAST_HW_KEY_SLOT	(CC_FIRST_HW_KEY_SLOT + CC_NUM_HW_KEY_SLOTS - 1)
+
+#define CC_NUM_CPP_KEY_SLOTS	8
+#define CC_FIRST_CPP_KEY_SLOT	16
+#define CC_LAST_CPP_KEY_SLOT	(CC_FIRST_CPP_KEY_SLOT + \
+					CC_NUM_CPP_KEY_SLOTS - 1)
+
 enum cc_hw_aes_key_size {
 	AES_128_KEY = 0,
 	AES_192_KEY = 1,
@@ -189,6 +202,8 @@ enum cc_hash_cipher_pad {
 	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
 };
 
+#define CC_CPP_DESC_INDICATOR	0xFF0000UL
+
 /*****************************/
 /* Descriptor packing macros */
 /*****************************/
@@ -248,6 +263,28 @@ static inline void set_din_no_dma(struct cc_hw_desc *pdesc, u32 addr, u32 size)
 	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size);
 }
 
+/*
+ * Setup the special CPP descriptor
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @alg: cipher used (AES / SM4)
+ * @mode: mode used (CTR or CBC)
+ * @slot: slot number
+ * @ksize: key size
+ */
+static inline void set_cpp_crypto_key(struct cc_hw_desc *pdesc,
+				      enum cc_cpp_alg alg,
+				      enum drv_cipher_mode mode, u8 slot)
+{
+	u8 mode_val = (mode == DRV_CIPHER_CBC ? 0 : 1);
+
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, CC_CPP_DESC_INDICATOR);
+	pdesc->word[1] |= FIELD_PREP(WORD1_LOCK_QUEUE, 1);
+	pdesc->word[0] |= FIELD_PREP(WORD0_CPP_CIPHER_MODE, mode_val);
+	pdesc->word[4] |= FIELD_PREP(WORD4_CPP_ALG, alg);
+	pdesc->word[4] |= FIELD_PREP(WORD4_CPP_SLOT, slot);
+}
+
 /*
  * Set the DIN field of a HW descriptors to SRAM mode.
  * Note: No need to check SRAM alignment since host requests do not use SRAM and
diff --git a/drivers/crypto/ccree/cc_kernel_regs.h b/drivers/crypto/ccree/cc_kernel_regs.h
index 8d7262a35156..f148d13c4b65 100644
--- a/drivers/crypto/ccree/cc_kernel_regs.h
+++ b/drivers/crypto/ccree/cc_kernel_regs.h
@@ -31,6 +31,8 @@
 #define CC_DSCRPTR_QUEUE_WORD0_REG_OFFSET	0xE80UL
 #define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE	0x20UL
+#define CC_DSCRPTR_QUEUE_WORD0_CPP_CIPHER_MODE_BIT_SHIFT	0x5UL
+#define CC_DSCRPTR_QUEUE_WORD0_CPP_CIPHER_MODE_BIT_SIZE	0x3UL
 #define CC_DSCRPTR_QUEUE_WORD1_REG_OFFSET	0xE84UL
 #define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE	0x2UL
@@ -97,6 +99,10 @@
 #define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE	0x1UL
 #define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT	0x1FUL
 #define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE	0x1UL
+#define CC_DSCRPTR_QUEUE_WORD4_CPP_SLOT_BIT_SHIFT	0xAUL
+#define CC_DSCRPTR_QUEUE_WORD4_CPP_SLOT_BIT_SIZE	0x3UL
+#define CC_DSCRPTR_QUEUE_WORD4_CPP_ALG_BIT_SHIFT	0xDUL
+#define CC_DSCRPTR_QUEUE_WORD4_CPP_ALG_BIT_SIZE	0x1UL
 #define CC_DSCRPTR_QUEUE_WORD5_REG_OFFSET	0xE94UL
 #define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE	0x10UL
-- 
2.21.0

