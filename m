Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B6BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9A72245C
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 06:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHEGXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 02:23:18 -0400
Received: from foss.arm.com ([217.140.110.172]:54342 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHEGXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 02:23:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 603D8101E;
        Tue,  4 Aug 2020 23:23:17 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 151E63F718;
        Tue,  4 Aug 2020 23:23:14 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: ccree: remove data unit size support
Date:   Wed,  5 Aug 2020 09:23:00 +0300
Message-Id: <20200805062302.16569-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805062302.16569-1-gilad@benyossef.com>
References: <20200805062302.16569-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the implementaion of automatic advancement of sector size in IV for
storage ciphers as its use is not supproted by the kernel.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 233 +------------------------------
 drivers/crypto/ccree/cc_driver.h |   1 -
 2 files changed, 1 insertion(+), 233 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 8e446a097086..0a74f3808510 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -645,16 +645,8 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
 	unsigned int key_len = (ctx_p->keylen / 2);
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
-	unsigned int du_size = nbytes;
 	unsigned int key_offset = key_len;
 
-	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     skcipher_alg.base);
-
-	if (cc_alg->data_unit)
-		du_size = cc_alg->data_unit;
-
 	switch (cipher_mode) {
 	case DRV_CIPHER_ECB:
 		break;
@@ -682,7 +674,7 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 				     (key_dma_addr + key_offset),
 				     key_len, NS_BIT);
 		}
-		set_xex_data_unit_size(&desc[*seq_size], du_size);
+		set_xex_data_unit_size(&desc[*seq_size], nbytes);
 		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
 		set_key_size_aes(&desc[*seq_size], key_len);
 		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
@@ -1059,44 +1051,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
-	{
-		.name = "xts512(paes)",
-		.driver_name = "xts-paes-du512-ccree",
-		.blocksize = 1,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
-	{
-		.name = "xts4096(paes)",
-		.driver_name = "xts-paes-du4096-ccree",
-		.blocksize = 1,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
 	{
 		.name = "essiv(cbc(paes),sha256)",
 		.driver_name = "essiv-paes-ccree",
@@ -1115,44 +1069,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
-	{
-		.name = "essiv512(cbc(paes),sha256)",
-		.driver_name = "essiv-paes-du512-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
-	{
-		.name = "essiv4096(cbc(paes),sha256)",
-		.driver_name = "essiv-paes-du4096-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
 	{
 		.name = "bitlocker(paes)",
 		.driver_name = "bitlocker-paes-ccree",
@@ -1171,44 +1087,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
-	{
-		.name = "bitlocker512(paes)",
-		.driver_name = "bitlocker-paes-du512-ccree",
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
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
-	{
-		.name = "bitlocker4096(paes)",
-		.driver_name = "bitlocker-paes-du4096-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize =  CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_BITLOCKER,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
 	{
 		.name = "ecb(paes)",
 		.driver_name = "ecb-paes-ccree",
@@ -1320,42 +1198,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_630,
 		.std_body = CC_STD_NIST,
 	},
-	{
-		.name = "xts512(aes)",
-		.driver_name = "xts-aes-du512-ccree",
-		.blocksize = 1,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
-	{
-		.name = "xts4096(aes)",
-		.driver_name = "xts-aes-du4096-ccree",
-		.blocksize = 1,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_XTS,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
 	{
 		.name = "essiv(cbc(aes),sha256)",
 		.driver_name = "essiv-aes-ccree",
@@ -1373,42 +1215,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
 	},
-	{
-		.name = "essiv512(cbc(aes),sha256)",
-		.driver_name = "essiv-aes-du512-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
-	{
-		.name = "essiv4096(cbc(aes),sha256)",
-		.driver_name = "essiv-aes-du4096-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_ESSIV,
-		.flow_mode = S_DIN_to_AES,
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
 	{
 		.name = "bitlocker(aes)",
 		.driver_name = "bitlocker-aes-ccree",
@@ -1426,42 +1232,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
 	},
-	{
-		.name = "bitlocker512(aes)",
-		.driver_name = "bitlocker-aes-du512-ccree",
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
-		.data_unit = 512,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
-	{
-		.name = "bitlocker4096(aes)",
-		.driver_name = "bitlocker-aes-du4096-ccree",
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
-		.data_unit = 4096,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-	},
 	{
 		.name = "ecb(aes)",
 		.driver_name = "ecb-aes-ccree",
@@ -1733,7 +1503,6 @@ static struct cc_crypto_alg *cc_create_alg(const struct cc_alg_template *tmpl,
 
 	t_alg->cipher_mode = tmpl->cipher_mode;
 	t_alg->flow_mode = tmpl->flow_mode;
-	t_alg->data_unit = tmpl->data_unit;
 
 	return t_alg;
 }
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index c78275ce4761..3b9ea3fcd42d 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -169,7 +169,6 @@ struct cc_crypto_alg {
 	int cipher_mode;
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
-	unsigned int data_unit;
 	struct cc_drvdata *drvdata;
 	struct skcipher_alg skcipher_alg;
 	struct aead_alg aead_alg;
-- 
2.27.0

