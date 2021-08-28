Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F4DC432BE
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 03:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9E8601FA
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 03:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhH1Dlo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:41:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18984 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhH1Dln (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 23:41:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GxMhW694bzbjqb;
        Sat, 28 Aug 2021 11:36:59 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 11:40:51 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 28 Aug
 2021 11:40:51 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/qm - support the userspace task resetting
Date:   Sat, 28 Aug 2021 11:39:39 +0800
Message-ID: <1630121979-53760-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630121979-53760-1-git-send-email-yekai13@huawei.com>
References: <1630121979-53760-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allocate an extra memory page for qp in the qp memory initialization.
Set a qp error flag in the extra page addr when device resetting.
This error flag can be seen in the userspace. This flag can helps
users to stop tasks when device resetting. After resetting, this error
flag will be reset when this qp is created again. So app should release
the old qp and request a new one, and do the task on the new queue
again.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2bd25bf..cc5563d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -233,6 +233,8 @@
 #define QM_DBG_WRITE_LEN		1024
 #define QM_DBG_TMP_BUF_LEN		22
 #define QM_PCI_COMMAND_INVALID		~0
+#define QM_RESET_STOP_TX_OFFSET		1
+#define QM_RESET_STOP_RX_OFFSET		2
 
 #define WAIT_PERIOD			20
 #define REMOVE_WAIT_DELAY		10
@@ -883,6 +885,20 @@ static irqreturn_t qm_mb_cmd_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void qm_set_qp_disable(struct hisi_qp *qp, int offset)
+{
+	u32 *addr;
+
+	if (qp->is_in_kernel)
+		return;
+
+	addr = (u32 *)(qp->qdma.va + qp->qdma.size) - offset;
+	*addr = 1;
+
+	/* make sure setup is completed */
+	mb();
+}
+
 static irqreturn_t qm_aeq_irq(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
@@ -2467,6 +2483,15 @@ static void *qm_get_avail_sqe(struct hisi_qp *qp)
 	return qp->sqe + sq_tail * qp->qm->sqe_size;
 }
 
+static void hisi_qm_unset_hw_reset(struct hisi_qp *qp)
+{
+	u64 *addr;
+
+	/* Use last 64 bits of DUS to reset status. */
+	addr = (u64 *)(qp->qdma.va + qp->qdma.size) - QM_RESET_STOP_TX_OFFSET;
+	*addr = 0;
+}
+
 static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -2492,7 +2517,7 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 	}
 
 	qp = &qm->qp_array[qp_id];
-
+	hisi_qm_unset_hw_reset(qp);
 	memset(qp->cqe, 0, sizeof(struct qm_cqe) * QM_Q_DEPTH);
 
 	qp->event_cb = NULL;
@@ -2912,6 +2937,14 @@ static int hisi_qm_get_available_instances(struct uacce_device *uacce)
 	return hisi_qm_get_free_qp_num(uacce->priv);
 }
 
+static void hisi_qm_set_hw_reset(struct hisi_qm *qm, int offset)
+{
+	int i;
+
+	for (i = 0; i < qm->qp_num; i++)
+		qm_set_qp_disable(&qm->qp_array[i], offset);
+}
+
 static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
 				   unsigned long arg,
 				   struct uacce_queue *q)
@@ -3684,11 +3717,13 @@ int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 
 	if (qm->status.stop_reason == QM_SOFT_RESET ||
 	    qm->status.stop_reason == QM_FLR) {
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
 		ret = qm_stop_started_qp(qm);
 		if (ret < 0) {
 			dev_err(dev, "Failed to stop started qp!\n");
 			goto err_unlock;
 		}
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
 	}
 
 	/* Mask eq and aeq irq */
@@ -5047,6 +5082,8 @@ static int qm_controller_reset(struct hisi_qm *qm)
 
 	ret = qm_controller_reset_prepare(qm);
 	if (ret) {
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
 		clear_bit(QM_RST_SCHED, &qm->misc_ctl);
 		return ret;
 	}
@@ -5133,6 +5170,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	ret = hisi_qm_stop(qm, QM_FLR);
 	if (ret) {
 		pci_err(pdev, "Failed to stop QM, ret = %d.\n", ret);
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
+		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
 		return;
 	}
 
@@ -5316,9 +5355,14 @@ static void qm_pf_reset_vf_prepare(struct hisi_qm *qm,
 		atomic_set(&qm->status.flags, QM_STOP);
 		cmd = QM_VF_PREPARE_FAIL;
 		goto err_prepare;
+	} else {
+		goto out;
 	}
 
 err_prepare:
+	hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
+	hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
+out:
 	pci_save_state(pdev);
 	ret = qm->ops->ping_pf(qm, cmd);
 	if (ret)
-- 
2.7.4

