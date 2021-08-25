Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE1BC4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 04:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA05B60EE4
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 04:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhHYEG4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Aug 2021 00:06:56 -0400
Received: from mx21.baidu.com ([220.181.3.85]:53112 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229826AbhHYEGs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Aug 2021 00:06:48 -0400
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id 2690E62C50AA80D86CC8;
        Wed, 25 Aug 2021 12:06:00 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 12:05:59 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 12:05:59 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <broonie@kernel.org>, <zhouyanjie@wanyeetech.com>, <s-anna@ti.com>,
        <andre.przywara@arm.com>, <chris.obbard@collabora.com>,
        <qianweili@huawei.com>, <juerg.haefliger@canonical.com>
CC:     <linux-crypto@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] hwrng: Add helper dependency on COMPILE_TEST
Date:   Wed, 25 Aug 2021 12:05:52 +0800
Message-ID: <20210825040552.2265-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex08.internal.baidu.com (10.127.64.18) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2021-08-25 12:06:00:107
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

it's helpful to do a complie test in other platform(e.g.X86)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/char/hw_random/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 239eca4d6805..814b3d0ca7b7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -63,7 +63,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on ARCH_AT91 && HAVE_CLK && OF
+	depends on (ARCH_AT91 || COMPILE_TEST) && HAVE_CLK && OF
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
@@ -87,7 +87,7 @@ config HW_RANDOM_BA431
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
 	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
-		   ARCH_BCM_63XX || BCM63XX || BMIPS_GENERIC
+		   ARCH_BCM_63XX || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
@@ -100,7 +100,7 @@ config HW_RANDOM_BCM2835
 
 config HW_RANDOM_IPROC_RNG200
 	tristate "Broadcom iProc/STB RNG200 support"
-	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB
+	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the RNG200
@@ -165,7 +165,7 @@ config HW_RANDOM_IXP4XX
 
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
-	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU || ARCH_K3
+	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU || ARCH_K3 || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
@@ -179,7 +179,7 @@ config HW_RANDOM_OMAP
 
 config HW_RANDOM_OMAP3_ROM
 	tristate "OMAP3 ROM Random Number Generator support"
-	depends on ARCH_OMAP3
+	depends on ARCH_OMAP3 || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
@@ -298,7 +298,7 @@ config HW_RANDOM_INGENIC_TRNG
 
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
-	depends on ARCH_NOMADIK
+	depends on ARCH_NOMADIK || COMPILE_TEST
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.25.1

