Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE90C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3315A613A0
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 12:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbhDFM66 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:58:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15559 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242308AbhDFM66 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 08:58:58 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF6w35vTdzPnkh;
        Tue,  6 Apr 2021 20:56:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 20:58:39 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - add stop queue by hardware
Date:   Tue, 6 Apr 2021 20:56:02 +0800
Message-ID: <1617713762-52120-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 could be able to stop queue by writing hardware registers,
which will trigger tasks in device to be flushed out.

In order to be compatible with the kunpeng920 driver, add 'qm_hw_ops_v3' to
adapt Kunpeng930. And 'stop_qp' callback is added in 'qm_hw_ops_v3' to
write hardware registers. Call 'stop_qp' to drain the tasks in device
before releasing queue.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c91e57a..05f96aa 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -38,6 +38,7 @@
 #define QM_MB_CMD_SQC_BT		0x4
 #define QM_MB_CMD_CQC_BT		0x5
 #define QM_MB_CMD_SQC_VFT_V2		0x6
+#define QM_MB_CMD_STOP_QP		0x8
 
 #define QM_MB_CMD_SEND_BASE		0x300
 #define QM_MB_EVENT_SHIFT		8
@@ -349,6 +350,7 @@ struct hisi_qm_hw_ops {
 	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe);
 	void (*hw_error_uninit)(struct hisi_qm *qm);
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
+	int (*stop_qp)(struct hisi_qp *qp);
 };
 
 struct qm_dfx_item {
@@ -1711,6 +1713,11 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 	return ACC_ERR_RECOVERED;
 }
 
+static int qm_stop_qp(struct hisi_qp *qp)
+{
+	return qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
+}
+
 static const struct hisi_qm_hw_ops qm_hw_ops_v1 = {
 	.qm_db = qm_db_v1,
 	.get_irq_num = qm_get_irq_num_v1,
@@ -1726,6 +1733,16 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v2 = {
 	.hw_error_handle = qm_hw_error_handle_v2,
 };
 
+static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
+	.get_vft = qm_get_vft_v2,
+	.qm_db = qm_db_v2,
+	.get_irq_num = qm_get_irq_num_v2,
+	.hw_error_init = qm_hw_error_init_v2,
+	.hw_error_uninit = qm_hw_error_uninit_v2,
+	.hw_error_handle = qm_hw_error_handle_v2,
+	.stop_qp = qm_stop_qp,
+};
+
 static void *qm_get_avail_sqe(struct hisi_qp *qp)
 {
 	struct hisi_qp_status *qp_status = &qp->qp_status;
@@ -2005,6 +2022,14 @@ static int qm_drain_qp(struct hisi_qp *qp)
 	if (qm->err_status.is_qm_ecc_mbit || qm->err_status.is_dev_ecc_mbit)
 		return 0;
 
+	/* Kunpeng930 supports drain qp by device */
+	if (qm->ops->stop_qp) {
+		ret = qm->ops->stop_qp(qp);
+		if (ret)
+			dev_err(dev, "Failed to stop qp(%u)!\n", qp->qp_id);
+		return ret;
+	}
+
 	addr = qm_ctx_alloc(qm, size, &dma_addr);
 	if (IS_ERR(addr)) {
 		dev_err(dev, "Failed to alloc ctx for sqc and cqc!\n");
@@ -2565,8 +2590,10 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 
 	if (qm->ver == QM_HW_V1)
 		qm->ops = &qm_hw_ops_v1;
-	else
+	else if (qm->ver == QM_HW_V2)
 		qm->ops = &qm_hw_ops_v2;
+	else
+		qm->ops = &qm_hw_ops_v3;
 
 	pci_set_drvdata(pdev, qm);
 	mutex_init(&qm->mailbox_lock);
-- 
2.8.1

