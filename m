Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7110C4320E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 11:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8932061165
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 11:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhHYLWn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:22:43 -0400
Received: from mx20.baidu.com ([111.202.115.85]:52254 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240035AbhHYLWn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Aug 2021 07:22:43 -0400
Received: from BC-Mail-Ex18.internal.baidu.com (unknown [172.31.51.12])
        by Forcepoint Email with ESMTPS id F32F3B7DF3CB3292C294;
        Wed, 25 Aug 2021 19:21:55 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex18.internal.baidu.com (172.31.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 25 Aug 2021 19:21:55 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 19:21:55 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <nicolas.toromanoff@st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 2/2] crypto: stm32 - open the configuration for COMPILE_TEST
Date:   Wed, 25 Aug 2021 19:21:47 +0800
Message-ID: <20210825112147.2669-3-caihuoqing@baidu.com>
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

it could be opened for complie test in other platform(e.g.X86)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 1fe5120eb966..17b640de1823 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
-obj-$(CONFIG_ARCH_STM32) += stm32/
+obj-y += stm32/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
-- 
2.25.1

