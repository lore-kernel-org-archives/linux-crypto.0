Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E67EC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 04:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0394920775
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 04:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgG1EEv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 00:04:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53944 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgG1EEv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 00:04:51 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Gr8-0002DV-Tc; Tue, 28 Jul 2020 14:04:48 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 14:04:46 +1000
Date:   Tue, 28 Jul 2020 14:04:46 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: ccree - Delete non-standard algorithms
Message-ID: <20200728040446.GA12763@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch deletes non-standard algorithms such as essiv512 and
essiv4096 which have no corresponding generic implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index f5b75b6d9ad4a..83567b60d6908 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1056,44 +1056,6 @@ static const struct cc_alg_template skcipher_algs[] = {
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
@@ -1112,100 +1074,6 @@ static const struct cc_alg_template skcipher_algs[] = {
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
@@ -1319,42 +1187,6 @@ static const struct cc_alg_template skcipher_algs[] = {
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
@@ -1372,95 +1204,6 @@ static const struct cc_alg_template skcipher_algs[] = {
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
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
