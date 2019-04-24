Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D9CC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF545218D2
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="ddRU2uuG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfDXNhU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:37:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:38238 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727369AbfDXNhU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 09:37:20 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3ODU5mq019752;
        Wed, 24 Apr 2019 15:35:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=9d9FjDMPYFvQCTzlRmg0uybrmhlVz6nU0nj2RYqkkTk=;
 b=ddRU2uuG1Fx61Uj34/n7dogCSdRIewzJpk4y29NdpaLf0DsEsTPH5B0xasUzy/yfFlPw
 6+yzE2LF3qonph7YsjmK/fqs/FnQjH0xfgLJ0hzCL3xvUkV1dt496M8gzKrYL4LWdJD/
 eUQ6D8zXOyq9FGo4+Xqz4mzfs4nXTP6Kha/0WsHHzfLuGgKvlwgt2VUN6/1hW29w8eRc
 ZwxSSlc/YdWLGFUlk2FI9mElUnIHFnCosy3rkfW4R10wltqJxTpp94S9VM9jiRCmppFA
 pvwo6ePiIHQfSDaHvob0c3YE9F/MpRM7m0Pqhkybbyjyoroe7/TUlOYlwGUjSPXqn93D eA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rytad6ttg-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 24 Apr 2019 15:35:04 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 27EB741;
        Wed, 24 Apr 2019 13:35:02 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C504526A4;
        Wed, 24 Apr 2019 13:35:02 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 24 Apr
 2019 15:35:02 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Wed, 24 Apr 2019 15:35:02
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 1/3] crypto: stm32/cryp - add weak key check for DES
Date:   Wed, 24 Apr 2019 15:34:51 +0200
Message-ID: <1556112893-13116-1-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_09:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add weak key test for des functions calling the generic
des_ekey.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/Kconfig      |  1 +
 drivers/crypto/stm32/stm32-cryp.c | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 63aa78c..4491e21 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -24,6 +24,7 @@ config CRYPTO_DEV_STM32_CRYP
 	depends on ARCH_STM32
 	select CRYPTO_HASH
 	select CRYPTO_ENGINE
+	select CRYPTO_DES
 	help
           This enables support for the CRYP (AES/DES/TDES) hw accelerator which
 	  can be found on STMicroelectronics STM32 SOC.
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 5785f3e..cfcb640 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -753,10 +753,19 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
+	u32 tmp[DES_EXPKEY_WORDS];
+
 	if (keylen != DES_KEY_SIZE)
 		return -EINVAL;
-	else
-		return stm32_cryp_setkey(tfm, key, keylen);
+
+	if ((crypto_ablkcipher_get_flags(tfm) &
+	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
+	    unlikely(!des_ekey(tmp, key))) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
+	return stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
-- 
2.7.4

