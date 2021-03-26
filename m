Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8891C433C1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 08:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FB0619C7
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 08:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCZIpj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 04:45:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14619 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhCZIp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 04:45:26 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6Fqb2Q06z19JmG;
        Fri, 26 Mar 2021 16:43:23 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 16:45:14 +0800
From:   Hao Fang <fanghao11@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <xuzaibo@huawei.com>,
        <shenyang39@huawei.com>, <fanghao11@huawei.com>
Subject: [PATCH] crypto: hisilicon - use the correct HiSilicon copyright
Date:   Fri, 26 Mar 2021 16:42:39 +0800
Message-ID: <1616748159-22049-1-git-send-email-fanghao11@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

s/Hisilicon/HiSilicon/g,
according to https://www.hisilicon.com/en/terms-of-use.

Signed-off-by: Hao Fang <fanghao11@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 2 +-
 drivers/crypto/hisilicon/sec/sec_drv.c  | 6 +++---
 drivers/crypto/hisilicon/sec/sec_drv.h  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 8ca945a..0a3c8f0 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2016-2017 Hisilicon Limited. */
+/* Copyright (c) 2016-2017 HiSilicon Limited. */
 #include <linux/crypto.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 91ee2bb..8c20beb 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Driver for the Hisilicon SEC units found on Hip06 Hip07
+ * Driver for the HiSilicon SEC units found on Hip06 Hip07
  *
- * Copyright (c) 2016-2017 Hisilicon Limited.
+ * Copyright (c) 2016-2017 HiSilicon Limited.
  */
 #include <linux/acpi.h>
 #include <linux/atomic.h>
@@ -1315,6 +1315,6 @@ static struct platform_driver sec_driver = {
 module_platform_driver(sec_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Hisilicon Security Accelerators");
+MODULE_DESCRIPTION("HiSilicon Security Accelerators");
 MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com");
 MODULE_AUTHOR("Jonathan Cameron <jonathan.cameron@huawei.com>");
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.h b/drivers/crypto/hisilicon/sec/sec_drv.h
index 4d9063a..179a825 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.h
+++ b/drivers/crypto/hisilicon/sec/sec_drv.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2016-2017 Hisilicon Limited. */
+/* Copyright (c) 2016-2017 HiSilicon Limited. */
 
 #ifndef _SEC_DRV_H_
 #define _SEC_DRV_H_
-- 
2.8.1

