Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63897C54E8D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D7E3206F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="m5xQdrY6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgELOMY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 10:12:24 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:2080 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgELOMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 10:12:24 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CE8Cki015056;
        Tue, 12 May 2020 16:11:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=4pNmSi5ml3tKByzebGX13JwE22RuftEAKg4WQdiHZi8=;
 b=m5xQdrY6vIezXFH13dESAUkJiiQlF952to5ae7R1g2DVWORiFhg5oY57gZnYLACJI+3C
 bIBwxDe+6P2Yd/VIA3vQ+RxAnypwLEhhU+QrAUgYbRsjby4j6R7Ahq/L8OL0aymsHQCr
 JIh3OiIef6gXX+w4pGYi9jKw0f96qs1/jZF428ZjKFkkzHnCeU+/rNp0/CcNfvJqO8is
 jzi9XmPFqFsU9Mu0Z6eka4yBkeQAeB4PTS1beOcskuBIWd57pecwcSdkiJyvhmmnZti0
 oBZa3QP8Hb+rgKee0NUE3IEHQ0wH3NCR/SAIVWsLaaS4osUbnT+Cq4ZkV0y6K1jp+QuR bw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30whn9gw57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 16:11:58 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8B9E9100034;
        Tue, 12 May 2020 16:11:57 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7CBBE2BC7A1;
        Tue, 12 May 2020 16:11:57 +0200 (CEST)
Received: from localhost (10.75.127.47) by SFHDAG6NODE1.st.com (10.75.127.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 May 2020 16:11:56
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
CC:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] crypto: stm32/crc: fix run-time self test issue.
Date:   Tue, 12 May 2020 16:11:10 +0200
Message-ID: <20200512141113.18972-3-nicolas.toromanoff@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512141113.18972-1-nicolas.toromanoff@st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG3NODE1.st.com (10.75.127.7) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_03:2020-05-11,2020-05-12 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix wrong crc32 initialisation value:
"alg: shash: stm32_crc32 test failed (wrong result) on test vector 0,
cfg="init+update+final aligned buffer"
cra_name="crc32c" expects an init value of 0XFFFFFFFF,
cra_name="crc32" expects an init value of 0.

Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
---
 drivers/crypto/stm32/stm32-crc32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index c6156bf6c603..1c3e411b7acb 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -28,10 +28,10 @@
 
 /* Registers values */
 #define CRC_CR_RESET            BIT(0)
-#define CRC_INIT_DEFAULT        0xFFFFFFFF
 #define CRC_CR_REV_IN_WORD      (BIT(6) | BIT(5))
 #define CRC_CR_REV_IN_BYTE      BIT(5)
 #define CRC_CR_REV_OUT          BIT(7)
+#define CRC32C_INIT_DEFAULT     0xFFFFFFFF
 
 #define CRC_AUTOSUSPEND_DELAY	50
 
@@ -65,7 +65,7 @@ static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
 {
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
-	mctx->key = CRC_INIT_DEFAULT;
+	mctx->key = 0;
 	mctx->poly = CRC32_POLY_LE;
 	return 0;
 }
@@ -74,7 +74,7 @@ static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
 {
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
-	mctx->key = CRC_INIT_DEFAULT;
+	mctx->key = CRC32C_INIT_DEFAULT;
 	mctx->poly = CRC32C_POLY_LE;
 	return 0;
 }
-- 
2.17.1

