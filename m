Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B97C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907B4600D1
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhEUInT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 04:43:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5646 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbhEUInS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 04:43:18 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fmg4p1scVz16Plf
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 16:39:06 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 16:41:53 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 16:41:53 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-crypto@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: nx - Fix typo in comment
Date:   Fri, 21 May 2021 16:41:47 +0800
Message-ID: <1621586507-22178-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix typo '@workmem' -> '@wmem'.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/crypto/nx/nx-common-powernv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 446f611726df..655361ba9107 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -660,8 +660,8 @@ static int nx842_powernv_compress(const unsigned char *in, unsigned int inlen,
  * @inlen: input buffer size
  * @out: output buffer pointer
  * @outlenp: output buffer size pointer
- * @workmem: working memory buffer pointer, size determined by
- *           nx842_powernv_driver.workmem_size
+ * @wmem: working memory buffer pointer, size determined by
+ *        nx842_powernv_driver.workmem_size
  *
  * Returns: see @nx842_powernv_exec()
  */
-- 
2.7.4

