Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F75C432BE
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 11:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8169B6113C
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 11:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbhHYLWm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:22:42 -0400
Received: from mx20.baidu.com ([111.202.115.85]:52186 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239411AbhHYLWm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Aug 2021 07:22:42 -0400
Received: from BC-Mail-Ex19.internal.baidu.com (unknown [172.31.51.13])
        by Forcepoint Email with ESMTPS id 69BB2EF880CE6D117B12;
        Wed, 25 Aug 2021 19:21:55 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex19.internal.baidu.com (172.31.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 25 Aug 2021 19:21:55 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 19:21:54 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <nicolas.toromanoff@st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 1/2] crypto: stm32 - Add support of COMPILE_TEST
Date:   Wed, 25 Aug 2021 19:21:46 +0800
Message-ID: <20210825112147.2669-2-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825112147.2669-1-caihuoqing@baidu.com>
References: <20210825112147.2669-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

it's helpful for complie test in other platform(e.g.X86)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/crypto/stm32/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
index 4a4c3284ae1f..0fa30260300f 100644
--- a/drivers/crypto/stm32/Kconfig
+++ b/drivers/crypto/stm32/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CRYPTO_DEV_STM32_CRC
 	tristate "Support for STM32 crc accelerators"
-	depends on ARCH_STM32
+	depends on ARCH_STM32 || (COMPILE_TEST && OF)
 	select CRYPTO_HASH
 	select CRC32
 	help
@@ -10,7 +10,7 @@ config CRYPTO_DEV_STM32_CRC
 
 config CRYPTO_DEV_STM32_HASH
 	tristate "Support for STM32 hash accelerators"
-	depends on ARCH_STM32
+	depends on ARCH_STM32 || (COMPILE_TEST && OF)
 	depends on HAS_DMA
 	select CRYPTO_HASH
 	select CRYPTO_MD5
@@ -23,7 +23,7 @@ config CRYPTO_DEV_STM32_HASH
 
 config CRYPTO_DEV_STM32_CRYP
 	tristate "Support for STM32 cryp accelerators"
-	depends on ARCH_STM32
+	depends on ARCH_STM32 || (COMPILE_TEST && OF)
 	select CRYPTO_HASH
 	select CRYPTO_ENGINE
 	select CRYPTO_LIB_DES
-- 
2.25.1

