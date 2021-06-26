Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56124C2B9F4
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Jun 2021 02:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E8B61864
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Jun 2021 02:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFZCxY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 22:53:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5082 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFZCxY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 22:53:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBdXV6bHlzXhxP;
        Sat, 26 Jun 2021 10:45:46 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 10:51:00 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 26 Jun
 2021 10:51:00 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec - fix the process of disabling sva prefetching
Date:   Sat, 26 Jun 2021 10:50:33 +0800
Message-ID: <1624675833-20107-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The open interface of the sva prefetching function is distinguish the chip
version. But the close interface of the sva prefetching function doesn't
distinguish the chip version. As a result, the sva prefetching close
operation is also performed on Kunpeng920, those registers are important
on Kunpeng920, which eventually leads to abnormal hardware problems. So
need to fix it immediately.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 8ab4e67..710ea8d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -363,6 +363,9 @@ static void sec_close_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
+	if (qm->ver < QM_HW_V3)
+		return;
+
 	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
 	val |= SEC_PREFETCH_DISABLE;
 	writel(val, qm->io_base + SEC_PREFETCH_CFG);
-- 
2.7.4

