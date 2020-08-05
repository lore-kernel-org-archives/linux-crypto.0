Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315DBC433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12799207FC
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHEGXV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 02:23:21 -0400
Received: from foss.arm.com ([217.140.110.172]:54350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHEGXV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 02:23:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F0A6D6E;
        Tue,  4 Aug 2020 23:23:20 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A5D03F718;
        Tue,  4 Aug 2020 23:23:18 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: ccree: remove bitlocker cipher
Date:   Wed,  5 Aug 2020 09:23:01 +0300
Message-Id: <20200805062302.16569-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805062302.16569-1-gilad@benyossef.com>
References: <20200805062302.16569-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the bitlocker cipher which is not supported by
the kernel.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c     | 49 ++--------------------------
 drivers/crypto/ccree/cc_crypto_ctx.h |  1 -
 2 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 0a74f3808510..50a0cd9abd49 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -96,8 +96,7 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
-			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
-			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
+			if (ctx_p->cipher_mode != DRV_CIPHER_XTS)
 				return 0;
 			break;
 		case CC_AES_256_BIT_KEY_SIZE:
@@ -105,8 +104,7 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		case (CC_AES_192_BIT_KEY_SIZE * 2):
 		case (CC_AES_256_BIT_KEY_SIZE * 2):
 			if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-			    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-			    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER)
+			    ctx_p->cipher_mode == DRV_CIPHER_ESSIV)
 				return 0;
 			break;
 		default:
@@ -143,7 +141,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 		case DRV_CIPHER_ECB:
 		case DRV_CIPHER_CBC:
 		case DRV_CIPHER_ESSIV:
-		case DRV_CIPHER_BITLOCKER:
 			if (IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
@@ -369,8 +366,7 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 		}
 
 		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
-		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 			if (hki.hw_key1 == hki.hw_key2) {
 				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
 					hki.hw_key1, hki.hw_key2);
@@ -568,7 +564,6 @@ static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
-	case DRV_CIPHER_BITLOCKER:
 		/*  IV */
 		hw_desc_init(&desc[*seq_size]);
 		set_setup_mode(&desc[*seq_size], SETUP_WRITE_STATE1);
@@ -623,7 +618,6 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
-	case DRV_CIPHER_BITLOCKER:
 		break;
 	default:
 		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
@@ -657,7 +651,6 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
-	case DRV_CIPHER_BITLOCKER:
 
 		if (cipher_mode == DRV_CIPHER_ESSIV)
 			key_len = SHA256_DIGEST_SIZE;
@@ -771,7 +764,6 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
-	case DRV_CIPHER_BITLOCKER:
 		/* Load AES key */
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
@@ -1069,24 +1061,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
-	{
-		.name = "bitlocker(paes)",
-		.driver_name = "bitlocker-paes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
 	{
 		.name = "ecb(paes)",
 		.driver_name = "ecb-paes-ccree",
@@ -1215,23 +1189,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
 	},
-	{
-		.name = "bitlocker(aes)",
-		.driver_name = "bitlocker-aes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
 	{
 		.name = "ecb(aes)",
 		.driver_name = "ecb-aes-ccree",
diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
index ccf960a0d989..bd9a1c0896b3 100644
--- a/drivers/crypto/ccree/cc_crypto_ctx.h
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -108,7 +108,6 @@ enum drv_cipher_mode {
 	DRV_CIPHER_CBC_CTS = 11,
 	DRV_CIPHER_GCTR = 12,
 	DRV_CIPHER_ESSIV = 13,
-	DRV_CIPHER_BITLOCKER = 14,
 	DRV_CIPHER_RESERVE32B = S32_MAX
 };
 
-- 
2.27.0

