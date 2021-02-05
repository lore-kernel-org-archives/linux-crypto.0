Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E2BC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF7B64F3F
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhBEK3G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:29:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12138 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhBEKQG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:06 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DXB8r30HKz164xS;
        Fri,  5 Feb 2021 18:14:04 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:13 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 4/6] crypto: hisilicon/qm - update irqflag
Date:   Fri, 5 Feb 2021 18:12:56 +0800
Message-ID: <1612519978-33340-5-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Sihang Chen <chensihang1@hisilicon.com>

There is no need to share IRQ among several devices,
and set 'irqflag' as 0.

Signed-off-by: Sihang Chen <chensihang1@hisilicon.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 908a13f..ec7d068 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3978,21 +3978,20 @@ static int qm_irq_register(struct hisi_qm *qm)
 	int ret;
 
 	ret = request_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR),
-			  qm_irq, IRQF_SHARED, qm->dev_name, qm);
+			  qm_irq, 0, qm->dev_name, qm);
 	if (ret)
 		return ret;
 
 	if (qm->ver != QM_HW_V1) {
 		ret = request_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR),
-				  qm_aeq_irq, IRQF_SHARED, qm->dev_name, qm);
+				  qm_aeq_irq, 0, qm->dev_name, qm);
 		if (ret)
 			goto err_aeq_irq;
 
 		if (qm->fun_type == QM_HW_PF) {
 			ret = request_irq(pci_irq_vector(pdev,
 					  QM_ABNORMAL_EVENT_IRQ_VECTOR),
-					  qm_abnormal_irq, IRQF_SHARED,
-					  qm->dev_name, qm);
+					  qm_abnormal_irq, 0, qm->dev_name, qm);
 			if (ret)
 				goto err_abonormal_irq;
 		}
-- 
2.8.1

