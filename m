Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08807C71156
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C769321534
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbgKZCTy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:19:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8039 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732827AbgKZCTx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 21:19:53 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ChM006GptzhhSV;
        Thu, 26 Nov 2020 10:19:28 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Nov 2020
 10:19:45 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] crypto: hisilicon/sec - add new skcipher mode for SEC
Date:   Thu, 26 Nov 2020 10:18:04 +0800
Message-ID: <1606357086-9785-4-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
References: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new skcipher algorithms to Kunpeng930:
OFB(AES), CFB(AES), CTR(AES),
OFB(SM4), CFB(SM4), CTR(SM4).

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 47 ++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2d338a3..b0ab4cc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1651,10 +1651,16 @@ static int sec_setkey_##name(struct crypto_skcipher *tfm,	        \
 GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
+GEN_SEC_SETKEY_FUNC(aes_ofb, SEC_CALG_AES, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(aes_cfb, SEC_CALG_AES, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(aes_ctr, SEC_CALG_AES, SEC_CMODE_CTR)
 GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
 GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
+GEN_SEC_SETKEY_FUNC(sm4_ofb, SEC_CALG_SM4, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(sm4_cfb, SEC_CALG_SM4, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 
 #define SEC_SKCIPHER_ALG(sec_cra_name, sec_set_key, \
 	sec_min_key_size, sec_max_key_size, blk_size, iv_size)\
@@ -1710,6 +1716,32 @@ static struct skcipher_alg sec_skciphers[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 };
 
+static struct skcipher_alg sec_skciphers_v3[] = {
+	SEC_SKCIPHER_ALG("ofb(aes)", sec_setkey_aes_ofb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("cfb(aes)", sec_setkey_aes_cfb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ctr(aes)", sec_setkey_aes_ctr,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ofb(sm4)", sec_setkey_sm4_ofb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("cfb(sm4)", sec_setkey_sm4_cfb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ctr(sm4)", sec_setkey_sm4_ctr,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+};
+
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	u8 c_alg = ctx->c_ctx.c_alg;
@@ -1825,12 +1857,23 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
+	if (qm->ver > QM_HW_V2) {
+		ret = crypto_register_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
+		if (ret)
+			goto reg_skcipher_fail;
+	}
+
 	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 	if (ret)
 		goto reg_aead_fail;
 	return ret;
 
 reg_aead_fail:
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
+reg_skcipher_fail:
 	crypto_unregister_skciphers(sec_skciphers,
 					ARRAY_SIZE(sec_skciphers));
 	return ret;
@@ -1839,6 +1882,10 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
+
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
 	crypto_unregister_skciphers(sec_skciphers,
 					ARRAY_SIZE(sec_skciphers));
 }
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 712176b..3c74440 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -29,6 +29,8 @@ enum sec_mac_len {
 enum sec_cmode {
 	SEC_CMODE_ECB    = 0x0,
 	SEC_CMODE_CBC    = 0x1,
+	SEC_CMODE_CFB    = 0x2,
+	SEC_CMODE_OFB    = 0x3,
 	SEC_CMODE_CTR    = 0x4,
 	SEC_CMODE_XTS    = 0x7,
 };
-- 
2.8.1

