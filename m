Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D56C48BE0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45993613CA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhFKJJR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:09:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4034 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhFKJJI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:09:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1Zbq2QQNzWspr;
        Fri, 11 Jun 2021 17:02:15 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 17:07:09 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 17:07:09 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 3/8] crypto: hisilicon/qm - merges the work initialization process into a single function
Date:   Fri, 11 Jun 2021 17:06:45 +0800
Message-ID: <1623402410-63906-4-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
References: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Merges the work initialization process into a single function from
qm initialization.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 171ddbb..9b8e09e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5337,6 +5337,16 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 	return ret;
 }
 
+static void hisi_qm_init_work(struct hisi_qm *qm)
+{
+	INIT_WORK(&qm->work, qm_work_process);
+	if (qm->fun_type == QM_HW_PF)
+		INIT_WORK(&qm->rst_work, hisi_qm_controller_reset);
+
+	if (qm->ver > QM_HW_V2)
+		INIT_WORK(&qm->cmd_process, qm_cmd_process);
+}
+
 static int hisi_qp_alloc_memory(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -5452,13 +5462,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 	if (ret)
 		goto err_alloc_uacce;
 
-	INIT_WORK(&qm->work, qm_work_process);
-	if (qm->fun_type == QM_HW_PF)
-		INIT_WORK(&qm->rst_work, hisi_qm_controller_reset);
-
-	if (qm->ver >= QM_HW_V3)
-		INIT_WORK(&qm->cmd_process, qm_cmd_process);
-
+	hisi_qm_init_work(qm);
 	qm_cmd_init(qm);
 	atomic_set(&qm->status.flags, QM_INIT);
 
-- 
2.7.4

