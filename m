Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4D2C48BDF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 09:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23739613ED
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 09:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFRJjA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 05:39:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11064 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhFRJi7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 05:38:59 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5tz36kxKzZgD6;
        Fri, 18 Jun 2021 17:33:51 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 17:36:48 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 18
 Jun 2021 17:36:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <clabbe@baylibre.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 -next] crypto: sl3516 - Fix build warning without CONFIG_PM
Date:   Fri, 18 Jun 2021 17:35:51 +0800
Message-ID: <20210618093551.23748-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/gemini/sl3516-ce-core.c:345:12:
 warning: ‘sl3516_ce_pm_resume’ defined but not used [-Wunused-function]
 static int sl3516_ce_pm_resume(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~

The driver needs PM, otherwise clock and resets are never set.
So make it depends on PM to fix this warning.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Suggested-by: LABBE Corentin <clabbe@baylibre.com>
---
v2: Using depends on PM instead of #ifdef macro

 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 99b090790178..6f14f39d32e3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -273,6 +273,7 @@ config CRYPTO_DEV_SL3516
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select HW_RANDOM
+	depends on PM
 	help
 	  This option allows you to have support for SL3516 crypto offloader.
 
-- 
2.17.1

