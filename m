Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E37FC11D05
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 812A524672
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 09:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBTJJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 04:09:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56082 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbgBTJJJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 04:09:09 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 47ABB268E60EEAE15F16;
        Thu, 20 Feb 2020 17:09:06 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Feb 2020 17:08:56 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>,
        <linuxarm@huawei.com>, <fanghao11@huawei.com>,
        <yekai13@huawei.com>, <tanshukun1@huawei.com>,
        <qianweili@huawei.com>, <shenyang39@huawei.com>,
        <zhangwei375@huawei.com>, <tanghui20@huawei.com>,
        <liulongfang@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon - Use one workqueue per qm instead of per qp
Date:   Thu, 20 Feb 2020 17:04:52 +0800
Message-ID: <1582189495-38051-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shukun Tan <tanshukun1@huawei.com>

Because so many work queues are not needed. Using one workqueue
per QM will reduce the number of kworker threads as well as
reducing usage of CPU.This would not degrade any performance.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 38 +++++++++++++++-----------------------
 drivers/crypto/hisilicon/qm.h |  4 ++--
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 79f84dc6..a3510c9 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -486,17 +486,9 @@ static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
 	}
 }
 
-static void qm_qp_work_func(struct work_struct *work)
+static void qm_work_process(struct work_struct *work)
 {
-	struct hisi_qp *qp;
-
-	qp = container_of(work, struct hisi_qp, work);
-	qm_poll_qp(qp, qp->qm);
-}
-
-static irqreturn_t qm_irq_handler(int irq, void *data)
-{
-	struct hisi_qm *qm = data;
+	struct hisi_qm *qm = container_of(work, struct hisi_qm, work);
 	struct qm_eqe *eqe = qm->eqe + qm->status.eq_head;
 	struct hisi_qp *qp;
 	int eqe_num = 0;
@@ -505,7 +497,7 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
 		eqe_num++;
 		qp = qm_to_hisi_qp(qm, eqe);
 		if (qp)
-			queue_work(qp->wq, &qp->work);
+			qm_poll_qp(qp, qm);
 
 		if (qm->status.eq_head == QM_Q_DEPTH - 1) {
 			qm->status.eqc_phase = !qm->status.eqc_phase;
@@ -523,6 +515,16 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
 	}
 
 	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
+}
+
+static irqreturn_t do_qm_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = (struct hisi_qm *)data;
+
+	if (qm->wq)
+		queue_work(qm->wq, &qm->work);
+	else
+		schedule_work(&qm->work);
 
 	return IRQ_HANDLED;
 }
@@ -532,7 +534,7 @@ static irqreturn_t qm_irq(int irq, void *data)
 	struct hisi_qm *qm = data;
 
 	if (readl(qm->io_base + QM_VF_EQ_INT_SOURCE))
-		return qm_irq_handler(irq, data);
+		return do_qm_irq(irq, data);
 
 	dev_err(&qm->pdev->dev, "invalid int source\n");
 	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
@@ -1151,20 +1153,9 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 
 	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
-	INIT_WORK(&qp->work, qm_qp_work_func);
-	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI |
-				 WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0);
-	if (!qp->wq) {
-		ret = -EFAULT;
-		goto err_free_qp_mem;
-	}
 
 	return qp;
 
-err_free_qp_mem:
-	if (qm->use_dma_api)
-		dma_free_coherent(dev, qp->qdma.size, qp->qdma.va,
-				  qp->qdma.dma);
 err_clear_bit:
 	write_lock(&qm->qps_lock);
 	qm->qp_array[qp_id] = NULL;
@@ -1483,6 +1474,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 	qm->qp_in_used = 0;
 	mutex_init(&qm->mailbox_lock);
 	rwlock_init(&qm->qps_lock);
+	INIT_WORK(&qm->work, qm_work_process);
 
 	dev_dbg(dev, "init qm %s with %s\n", pdev->is_physfn ? "pf" : "vf",
 		qm->use_dma_api ? "dma api" : "iommu api");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index cae26ea..4c0a2d81 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -181,6 +181,8 @@ struct hisi_qm {
 	u32 msi_mask;
 
 	bool use_dma_api;
+	struct workqueue_struct *wq;
+	struct work_struct work;
 };
 
 struct hisi_qp_status {
@@ -210,8 +212,6 @@ struct hisi_qp {
 	struct hisi_qp_ops *hw_ops;
 	void *qp_ctx;
 	void (*req_cb)(struct hisi_qp *qp, void *data);
-	struct work_struct work;
-	struct workqueue_struct *wq;
 
 	struct hisi_qm *qm;
 };
-- 
2.8.1

