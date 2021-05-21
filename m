Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AE4C43460
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039956135A
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhEUKCw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 06:02:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5721 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhEUKC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 06:02:27 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmhqH41YxzqVcK;
        Fri, 21 May 2021 17:57:31 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 18:00:52 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 18:00:52 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 1/2] crypto: hisilicon/qm - add dfx log if not use hardware crypto algs
Date:   Fri, 21 May 2021 17:57:49 +0800
Message-ID: <1621591070-15652-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621591070-15652-1-git-send-email-yekai13@huawei.com>
References: <1621591070-15652-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add print information necessary if not use hardware crypto algs.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8f7ea50..deb104e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4252,11 +4252,14 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
  */
 int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 {
+	struct device *dev = &qm->pdev->dev;
 	int flag = 0;
 	int ret = 0;
-	/* HW V2 not support both use uacce sva mode and hardware crypto algs */
-	if (qm->ver <= QM_HW_V2 && qm->use_sva)
+
+	if (qm->ver <= QM_HW_V2 && qm->use_sva) {
+		dev_info(dev, "HW V2 not both use uacce sva mode and hardware crypto algs.\n");
 		return 0;
+	}
 
 	mutex_lock(&qm_list->lock);
 	if (list_empty(&qm_list->list))
-- 
2.8.1

