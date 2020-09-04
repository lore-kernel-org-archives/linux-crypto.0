Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0820AC433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC0D2074D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="S/tGmJML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgIDL1S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:27:18 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:21986 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730210AbgIDL1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:27:09 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084BMtnu014170;
        Fri, 4 Sep 2020 13:25:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=I8ccoTHg3d9B6AkVKdCfXmiAQ8dN+CnLyb2SJtv640w=;
 b=S/tGmJML0d2Xt4lbIUD6dMLDrBrX41roU3etZNiaTzdqS3BFfiJoX3LhCq6NYJEM/14L
 rULRhvJS56awypM44t2P3DTtDyh/c/bdp27qhgADzpjjaoPUyeHXefglOngqIMKzOY/X
 k0zIrEAgkdnHay/lCHnD9V1DR4yuiE95y/k7XyaNqpAFKk+Pg1rsDMHdsrEObMRf6OBW
 dH41fAtF69FXKREm/0mX818jy5LtNFAaAuHz5NTLC+Es6+/EyzdXE2MvzAhxIE0Fk9n9
 niJquIeVAQlZaSCjYhYdMTA03e8le/iyFngAPJTru63SeA3XNXky5wHGVE/S9DY0s6JC 6A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 337c591nbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 13:25:54 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 14F7910002A;
        Fri,  4 Sep 2020 13:25:51 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C024E2AC84B;
        Fri,  4 Sep 2020 13:25:51 +0200 (CEST)
Received: from localhost (10.75.127.45) by SFHDAG6NODE1.st.com (10.75.127.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Sep 2020 13:25:51
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: stm32/crc32 - Avoid lock if hardware is already used
Date:   Fri, 4 Sep 2020 13:25:27 +0200
Message-ID: <20200904112527.15677-1-nicolas.toromanoff@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG5NODE3.st.com (10.75.127.15) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If STM32 CRC device is already in use, calculate CRC by software.

This will release CPU constraint for a concurrent access to the
hardware, and avoid masking irqs during the whole block processing.

Fixes: 7795c0baf5ac ("crypto: stm32/crc32 - protect from concurrent accesses")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
---
 drivers/crypto/stm32/Kconfig       |  2 ++
 drivers/crypto/stm32/stm32-crc32.c | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 4ef3eb11361c..8d605b07571f 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -3,6 +3,8 @@ config CRYPTO_DEV_STM32_CRC
 	tristate "Support for STM32 crc accelerators"
 	depends on ARCH_STM32
 	select CRYPTO_HASH
+	select CRYPTO_CRC32
+	select CRYPTO_CRC32C
 	help
 	  This enables support for the CRC32 hw accelerator which can be found
 	  on STMicroelectronics STM32 SOC.
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 783a64f3f635..75867c0b0017 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitrev.h>
 #include <linux/clk.h>
+#include <linux/crc32.h>
 #include <linux/crc32poly.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -149,7 +150,6 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 	struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
 	struct stm32_crc *crc;
-	unsigned long flags;
 
 	crc = stm32_crc_get_next_crc();
 	if (!crc)
@@ -157,7 +157,15 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 
 	pm_runtime_get_sync(crc->dev);
 
-	spin_lock_irqsave(&crc->lock, flags);
+	if (!spin_trylock(&crc->lock)) {
+		/* Hardware is busy, calculate crc32 by software */
+		if (mctx->poly == CRC32_POLY_LE)
+			ctx->partial = crc32_le(ctx->partial, d8, length);
+		else
+			ctx->partial = __crc32c_le(ctx->partial, d8, length);
+
+		goto pm_out;
+	}
 
 	/*
 	 * Restore previously calculated CRC for this context as init value
@@ -197,8 +205,9 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 	/* Store partial result */
 	ctx->partial = readl_relaxed(crc->regs + CRC_DR);
 
-	spin_unlock_irqrestore(&crc->lock, flags);
+	spin_unlock(&crc->lock);
 
+pm_out:
 	pm_runtime_mark_last_busy(crc->dev);
 	pm_runtime_put_autosuspend(crc->dev);
 
-- 
2.17.1

