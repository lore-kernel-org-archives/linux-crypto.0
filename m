Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC15EEB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 11:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjGNLoN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 07:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbjGNLoM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 07:44:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1DC210A;
        Fri, 14 Jul 2023 04:44:11 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R2V1k5hJ7zLlj4;
        Fri, 14 Jul 2023 19:41:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 19:44:08 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - flush all work before driver removed
Date:   Fri, 14 Jul 2023 19:41:35 +0800
Message-ID: <20230714114138.1582-2-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230714114138.1582-1-qianweili@huawei.com>
References: <20230714114138.1582-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Before removing the driver, flush inter-function communication
work, and subsequent communication work is not processed.
This prevents communication threads from accessing released memory.

Fixes: ("crypto: hisilicon/qm - enable PF and VFs communication")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index edc6fd44e7ca..81c21ca40375 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -954,6 +954,11 @@ static irqreturn_t qm_mb_cmd_irq(int irq, void *data)
 	if (!val)
 		return IRQ_NONE;
 
+	if (test_bit(QM_DRIVER_REMOVING, &qm->misc_ctl)) {
+		dev_warn(&qm->pdev->dev, "Driver is down, message cannot be processed!\n");
+		return IRQ_HANDLED;
+	}
+
 	schedule_work(&qm->cmd_process);
 
 	return IRQ_HANDLED;
@@ -2743,6 +2748,9 @@ void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 	       test_bit(QM_RESETTING, &qm->misc_ctl))
 		msleep(WAIT_PERIOD);
 
+	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
+		flush_work(&qm->cmd_process);
+
 	udelay(REMOVE_WAIT_DELAY);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_wait_task_finish);
-- 
2.33.0

