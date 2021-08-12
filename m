Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408A8C432BE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DDDE61059
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbhHLL4w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:56:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8401 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbhHLL4v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 07:56:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GllRX1h9xz85wP;
        Thu, 12 Aug 2021 19:52:24 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 19:56:22 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 12 Aug
 2021 19:56:22 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 1/2] crypto: hisilicon/sec - fix the abnormal exiting process
Date:   Thu, 12 Aug 2021 19:55:20 +0800
Message-ID: <1628769321-25192-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628769321-25192-1-git-send-email-yekai13@huawei.com>
References: <1628769321-25192-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because the algs registration process has added a judgment.
So need to add the judgment for the abnormal exiting process.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 490db7b..8addbd7 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -984,7 +984,8 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_alg_unregister:
-	hisi_qm_alg_unregister(qm, &sec_devices);
+	if (qm->qp_num >= ctx_q_num)
+		hisi_qm_alg_unregister(qm, &sec_devices);
 err_qm_stop:
 	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-- 
2.7.4

