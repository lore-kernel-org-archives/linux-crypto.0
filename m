Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55D3C5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2DD20656
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="O85tGj8z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF1L1G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:27:06 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:1546 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfF1L1F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 07:27:05 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SBQSq5008465;
        Fri, 28 Jun 2019 13:26:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=3acCB+/2oJupGcCDZjqJgsqu3sTcxGcFU4Yg5GquxDg=;
 b=O85tGj8z/N9wFxbYQZC0SC8zZsT3lwtB6gFnR0p7TfWfPffAfE+Cdg+Os67QQLFVltNO
 sXVA1yIfOtsHyR11wl+LJQcynvK+Anru79KHuQVBmZm8QUXzC0UMMBouKBcQxTWjb4N2
 pWqRZOFzjnwcNy6cpTeJ2RadVJFBdZ4ZKq3HKgeymQPVFR2sOj5yE3xiBZJDy9rOZknN
 l9NySoh4VwnTwCM7OkEdckylicnr950xl6GzCdiz+z38JTwPeyWRqOhfULxJVahTF3qh
 LWFX989O9YvPTZcU5ADD6qSb864LirR5dqECKjWT0Dr/aVHKZeMnCc2q7KjG9GUu+Wv1 /g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2t9d2gwgkw-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 28 Jun 2019 13:26:44 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 83F3331;
        Fri, 28 Jun 2019 11:26:43 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2389527A5;
        Fri, 28 Jun 2019 11:26:43 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun
 2019 13:26:43 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun 2019 13:26:42
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
        Ludovic Barre <ludovic.barre@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 1/1] crypto: stm32/crc32 - rename driver file
Date:   Fri, 28 Jun 2019 13:26:41 +0200
Message-ID: <20190628112641.9269-1-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the same naming convention for all stm32 crypto
drivers.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/Makefile                         | 2 +-
 drivers/crypto/stm32/{stm32_crc32.c => stm32-crc32.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/crypto/stm32/{stm32_crc32.c => stm32-crc32.c} (100%)

diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
index ce77e38c77e0..518e0e0b11a9 100644
--- a/drivers/crypto/stm32/Makefile
+++ b/drivers/crypto/stm32/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_STM32_CRC) += stm32_crc32.o
+obj-$(CONFIG_CRYPTO_DEV_STM32_CRC) += stm32-crc32.o
 obj-$(CONFIG_CRYPTO_DEV_STM32_HASH) += stm32-hash.o
 obj-$(CONFIG_CRYPTO_DEV_STM32_CRYP) += stm32-cryp.o
diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32-crc32.c
similarity index 100%
rename from drivers/crypto/stm32/stm32_crc32.c
rename to drivers/crypto/stm32/stm32-crc32.c
-- 
2.17.1

