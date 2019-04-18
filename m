Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B11C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74E6217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbfDRNkI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:08 -0400
Received: from foss.arm.com ([217.140.101.70]:33532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNkI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B754880D;
        Thu, 18 Apr 2019 06:40:07 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B2433F5AF;
        Thu, 18 Apr 2019 06:40:06 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/35] crypto: ccree: adapt CPP descriptor to new HW
Date:   Thu, 18 Apr 2019 16:38:43 +0300
Message-Id: <20190418133913.9122-9-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adapt the CPP descriptor to new HW interface.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c        | 42 +++++++++++++------------
 drivers/crypto/ccree/cc_hw_queue_defs.h | 18 +++++------
 drivers/crypto/ccree/cc_kernel_regs.h   |  6 ----
 3 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 8acedbafbcb3..4c7231d24631 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -546,6 +546,19 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 	}
 }
 
+static int cc_out_flow_mode(struct cc_cipher_ctx *ctx_p)
+{
+	switch (ctx_p->flow_mode) {
+	case S_DIN_to_AES:
+		return DIN_AES_DOUT;
+	case S_DIN_to_DES:
+		return DIN_DES_DOUT;
+	case S_DIN_to_SM4:
+		return DIN_SM4_DOUT;
+	default:
+		return ctx_p->flow_mode;
+	}
+}
 
 static void cc_setup_key_desc(struct crypto_tfm *tfm,
 			      struct cipher_req_ctx *req_ctx,
@@ -577,12 +590,15 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	case DRV_CIPHER_ECB:
 		/* Load key */
 		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+
 		if (cc_key_type(tfm) == CC_POLICY_PROTECTED_KEY) {
-			set_cpp_crypto_key(&desc[*seq_size], ctx_p->cpp.alg,
-					   cipher_mode, ctx_p->cpp.slot);
+			/* We use the AES key size coding for all CPP algs */
+			set_key_size_aes(&desc[*seq_size], key_len);
+			set_cpp_crypto_key(&desc[*seq_size], ctx_p->cpp.slot);
+			flow_mode = cc_out_flow_mode(ctx_p);
 		} else {
-			set_cipher_mode(&desc[*seq_size], cipher_mode);
-			set_cipher_config0(&desc[*seq_size], direction);
 			if (flow_mode == S_DIN_to_AES) {
 				if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
 					set_hw_crypto_key(&desc[*seq_size],
@@ -606,9 +622,9 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 					     key_dma_addr, key_len, NS_BIT);
 				set_key_size_des(&desc[*seq_size], key_len);
 			}
-			set_flow_mode(&desc[*seq_size], flow_mode);
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		}
+		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 		break;
 	case DRV_CIPHER_XTS:
@@ -670,22 +686,8 @@ static void cc_setup_flow_desc(struct crypto_tfm *tfm,
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	unsigned int flow_mode = ctx_p->flow_mode;
+	unsigned int flow_mode = cc_out_flow_mode(ctx_p);
 
-	switch (ctx_p->flow_mode) {
-	case S_DIN_to_AES:
-		flow_mode = DIN_AES_DOUT;
-		break;
-	case S_DIN_to_DES:
-		flow_mode = DIN_DES_DOUT;
-		break;
-	case S_DIN_to_SM4:
-		flow_mode = DIN_SM4_DOUT;
-		break;
-	default:
-		dev_err(dev, "invalid flow mode, flow_mode = %d\n", flow_mode);
-		return;
-	}
 	/* Process */
 	if (req_ctx->dma_buf_type == CC_DMA_BUF_DLLI) {
 		dev_dbg(dev, " data params addr %pad length 0x%X\n",
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index 2c8cd907d8db..fd693681808e 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -55,8 +55,6 @@
 #define WORD4_DATA_FLOW_MODE	CC_GENMASK(4, DATA_FLOW_MODE)
 #define WORD4_KEY_SIZE		CC_GENMASK(4, KEY_SIZE)
 #define WORD4_SETUP_OPERATION	CC_GENMASK(4, SETUP_OPERATION)
-#define WORD4_CPP_ALG		CC_GENMASK(4, CPP_ALG)
-#define WORD4_CPP_SLOT		CC_GENMASK(4, CPP_SLOT)
 #define WORD5_DIN_ADDR_HIGH	CC_GENMASK(5, DIN_ADDR_HIGH)
 #define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
 
@@ -202,7 +200,8 @@ enum cc_hash_cipher_pad {
 	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
 };
 
-#define CC_CPP_DESC_INDICATOR	0xFF0000UL
+#define CC_CPP_DIN_ADDR	0xFF00FF00UL
+#define CC_CPP_DIN_SIZE 0xFF00FFUL
 
 /*****************************/
 /* Descriptor packing macros */
@@ -272,17 +271,14 @@ static inline void set_din_no_dma(struct cc_hw_desc *pdesc, u32 addr, u32 size)
  * @slot: slot number
  * @ksize: key size
  */
-static inline void set_cpp_crypto_key(struct cc_hw_desc *pdesc,
-				      enum cc_cpp_alg alg,
-				      enum drv_cipher_mode mode, u8 slot)
+static inline void set_cpp_crypto_key(struct cc_hw_desc *pdesc, u8 slot)
 {
-	u8 mode_val = (mode == DRV_CIPHER_CBC ? 0 : 1);
+	pdesc->word[0] |= CC_CPP_DIN_ADDR;
 
-	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, CC_CPP_DESC_INDICATOR);
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, CC_CPP_DIN_SIZE);
 	pdesc->word[1] |= FIELD_PREP(WORD1_LOCK_QUEUE, 1);
-	pdesc->word[0] |= FIELD_PREP(WORD0_CPP_CIPHER_MODE, mode_val);
-	pdesc->word[4] |= FIELD_PREP(WORD4_CPP_ALG, alg);
-	pdesc->word[4] |= FIELD_PREP(WORD4_CPP_SLOT, slot);
+
+	pdesc->word[4] |= FIELD_PREP(WORD4_SETUP_OPERATION, slot);
 }
 
 /*
diff --git a/drivers/crypto/ccree/cc_kernel_regs.h b/drivers/crypto/ccree/cc_kernel_regs.h
index f148d13c4b65..8d7262a35156 100644
--- a/drivers/crypto/ccree/cc_kernel_regs.h
+++ b/drivers/crypto/ccree/cc_kernel_regs.h
@@ -31,8 +31,6 @@
 #define CC_DSCRPTR_QUEUE_WORD0_REG_OFFSET	0xE80UL
 #define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD0_VALUE_BIT_SIZE	0x20UL
-#define CC_DSCRPTR_QUEUE_WORD0_CPP_CIPHER_MODE_BIT_SHIFT	0x5UL
-#define CC_DSCRPTR_QUEUE_WORD0_CPP_CIPHER_MODE_BIT_SIZE	0x3UL
 #define CC_DSCRPTR_QUEUE_WORD1_REG_OFFSET	0xE84UL
 #define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD1_DIN_DMA_MODE_BIT_SIZE	0x2UL
@@ -99,10 +97,6 @@
 #define CC_DSCRPTR_QUEUE_WORD4_WORD_SWAP_BIT_SIZE	0x1UL
 #define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SHIFT	0x1FUL
 #define CC_DSCRPTR_QUEUE_WORD4_BYTES_SWAP_BIT_SIZE	0x1UL
-#define CC_DSCRPTR_QUEUE_WORD4_CPP_SLOT_BIT_SHIFT	0xAUL
-#define CC_DSCRPTR_QUEUE_WORD4_CPP_SLOT_BIT_SIZE	0x3UL
-#define CC_DSCRPTR_QUEUE_WORD4_CPP_ALG_BIT_SHIFT	0xDUL
-#define CC_DSCRPTR_QUEUE_WORD4_CPP_ALG_BIT_SIZE	0x1UL
 #define CC_DSCRPTR_QUEUE_WORD5_REG_OFFSET	0xE94UL
 #define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SHIFT	0x0UL
 #define CC_DSCRPTR_QUEUE_WORD5_DIN_ADDR_HIGH_BIT_SIZE	0x10UL
-- 
2.21.0

