Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D96C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 07:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B2261246
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 07:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhETH5h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 03:57:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4765 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhETH5h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 03:57:37 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fm25m3JYszqV8p
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 15:52:44 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 15:56:15 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 15:56:14 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-crypto@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] hwrng: core - remove redundant initialization of variable err
Date:   Thu, 20 May 2021 15:56:11 +0800
Message-ID: <1621497371-14746-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'err' will be assigned later and cleanup the redundant initialization.

Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index adb3c2bd7783..322e3d0ea98c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -323,7 +323,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	int err = -ENODEV;
+	int err;
 	struct hwrng *rng, *old_rng, *new_rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
-- 
2.7.4

