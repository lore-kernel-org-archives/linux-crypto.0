Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2B2C00528
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 11:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbjGNLoO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 07:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbjGNLoN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 07:44:13 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12992D41;
        Fri, 14 Jul 2023 04:44:11 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4R2V3m0xWyz18Lqp;
        Fri, 14 Jul 2023 19:43:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 19:44:09 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - stop function and write data to memory
Date:   Fri, 14 Jul 2023 19:41:36 +0800
Message-ID: <20230714114138.1582-3-qianweili@huawei.com>
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

When the system is shut down, the process is killed, but the
accelerator device does not stop executing the tasks. If the
accelerator device still accesses the memory and writes back data
to the memory after the memory is reclaimed by the system,
an NFE error may occur. Therefore, before the system is shut
down, the driver needs to stop the device and write data back
to the memory.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 14 ++++++++------
 include/linux/hisi_acc_qm.h   |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 81c21ca40375..fdff87c09aaf 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1002,7 +1002,7 @@ static void qm_reset_function(struct hisi_qm *qm)
 		return;
 	}
 
-	ret = hisi_qm_stop(qm, QM_FLR);
+	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret) {
 		dev_err(dev, "failed to stop qm when reset function\n");
 		goto clear_bit;
@@ -3251,7 +3251,7 @@ int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 	}
 
 	if (qm->status.stop_reason == QM_SOFT_RESET ||
-	    qm->status.stop_reason == QM_FLR) {
+	    qm->status.stop_reason == QM_DOWN) {
 		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
 		ret = qm_stop_started_qp(qm);
 		if (ret < 0) {
@@ -4547,11 +4547,11 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
 
-	ret = qm_try_stop_vfs(qm, QM_PF_FLR_PREPARE, QM_FLR);
+	ret = qm_try_stop_vfs(qm, QM_PF_FLR_PREPARE, QM_DOWN);
 	if (ret)
 		pci_err(pdev, "failed to stop vfs by pf in FLR.\n");
 
-	ret = hisi_qm_stop(qm, QM_FLR);
+	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret) {
 		pci_err(pdev, "Failed to stop QM, ret = %d.\n", ret);
 		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
@@ -4649,9 +4649,11 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev)
 	struct hisi_qm *qm = pci_get_drvdata(pdev);
 	int ret;
 
-	ret = hisi_qm_stop(qm, QM_NORMAL);
+	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret)
 		dev_err(&pdev->dev, "Fail to stop qm in shutdown!\n");
+
+	hisi_qm_cache_wb(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_shutdown);
 
@@ -4815,7 +4817,7 @@ static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 	cmd = msg & QM_MB_CMD_DATA_MASK;
 	switch (cmd) {
 	case QM_PF_FLR_PREPARE:
-		qm_pf_reset_vf_process(qm, QM_FLR);
+		qm_pf_reset_vf_process(qm, QM_DOWN);
 		break;
 	case QM_PF_SRST_PREPARE:
 		qm_pf_reset_vf_process(qm, QM_SOFT_RESET);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index a7d54d4d41fd..39fbfb4be944 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -104,7 +104,7 @@
 enum qm_stop_reason {
 	QM_NORMAL,
 	QM_SOFT_RESET,
-	QM_FLR,
+	QM_DOWN,
 };
 
 enum qm_state {
-- 
2.33.0

