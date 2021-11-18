Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04640C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E10556112D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhKRPMg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 10:12:36 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:53024 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231515AbhKRPMf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 10:12:35 -0500
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AIEiE9Y004075;
        Thu, 18 Nov 2021 16:09:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=AvLW6/k4bd6TATcPdoATdn/HWLAD3uHiP4K+O5Y0WxE=;
 b=fezl8mi2BWo08C4PUIhIrlBj3RJIrXXrM1tHyT3AsoFKd5Tfhgd5VziLsaYb6pgb6qI0
 I6PkZQORy1tag+pZfXU8xXPAkqZwJoUulpqph9bcxjnNteHWi9P75m0j/MdxlhKVV8/k
 C4tczBsETlcP8AjTuD7TEDDQqmmsOmj645yR7ggbTnsw4rqWUTGp2nwCCa6mH8rkAxp0
 +/qHBq6FcHea1OoPYVNpGOPQFVg8LUPe4FdzBgY3ytc4MF52w+sGBVMQJ5ESOmYGLJxA
 doM+M5QPDrF9UKag8wJJO0MQ5gEGQO/LWZzbA3UT1JVQfMcofqE8Y6wSrbyTr0J+12Vj ow== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3cdm1n28qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:09:21 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4B59A10002A;
        Thu, 18 Nov 2021 16:09:21 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4345A23153D;
        Thu, 18 Nov 2021 16:09:21 +0100 (CET)
Received: from localhost (10.75.127.51) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 18 Nov 2021 16:09:20
 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 5/9] crypto: stm32/cryp - check early input data
Date:   Thu, 18 Nov 2021 16:07:52 +0100
Message-ID: <20211118150756.6593-6-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
References: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some auto tests failed because driver wasn't returning the expected
error with some input size/iv value/tag size.
Now:
 Return 0 early for empty buffer. (We don't need to start the engine for
 an empty input buffer).
 Accept any valid authsize for gcm(aes).
 Return -EINVAL if iv for ccm(aes) is invalid.
 Return -EINVAL if buffer size is a not a multiple of algorithm block size.

Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 114 +++++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index c0903025a4cc..8cea7d3abf87 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -801,7 +801,20 @@ static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 static int stm32_cryp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 					  unsigned int authsize)
 {
-	return authsize == AES_BLOCK_SIZE ? 0 : -EINVAL;
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int stm32_cryp_aes_ccm_setauthsize(struct crypto_aead *tfm,
@@ -825,31 +838,61 @@ static int stm32_cryp_aes_ccm_setauthsize(struct crypto_aead *tfm,
 
 static int stm32_cryp_aes_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_ECB);
 }
 
 static int stm32_cryp_aes_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CBC);
 }
 
 static int stm32_cryp_aes_ctr_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CTR | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ctr_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CTR);
 }
 
@@ -863,53 +906,122 @@ static int stm32_cryp_aes_gcm_decrypt(struct aead_request *req)
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_GCM);
 }
 
+static inline int crypto_ccm_check_iv(const u8 *iv)
+{
+	/* 2 <= L <= 8, so 1 <= L' <= 7. */
+	if (iv[0] < 1 || iv[0] > 7)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int stm32_cryp_aes_ccm_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ccm_check_iv(req->iv);
+	if (err)
+		return err;
+
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ccm_decrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ccm_check_iv(req->iv);
+	if (err)
+		return err;
+
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM);
 }
 
 static int stm32_cryp_des_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_des_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_ECB);
 }
 
 static int stm32_cryp_des_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_des_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_CBC);
 }
 
 static int stm32_cryp_tdes_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_tdes_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_ECB);
 }
 
 static int stm32_cryp_tdes_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_tdes_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_CBC);
 }
 
-- 
2.17.1

