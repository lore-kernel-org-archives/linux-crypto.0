Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED59C3F2CE
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6271320866
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCECKM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:10:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10726 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbgCECKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 21:10:12 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 146B3B2B70745AD3F838;
        Thu,  5 Mar 2020 10:10:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 10:10:01 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v3 1/5] crypto: hisilicon - Use one workqueue per qm instead of per qp
Date:   Thu, 5 Mar 2020 10:06:21 +0800
Message-ID: <1583373985-718-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
References: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shukun Tan <tanshukun1@huawei.com>

Since SEC need not so many workqueues as our test, we just use
one workqueue created by the device driver of QM if necessary,
which will also reduce CPU waste without any throughput decreasing.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 39 ++++++++++++++++-----------------------
 drivers/crypto/hisilicon/qm.h |  5 +++--
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ad7146a..2fa1d1a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -494,17 +494,9 @@ static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
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
@@ -513,7 +505,7 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
 		eqe_num++;
 		qp = qm_to_hisi_qp(qm, eqe);
 		if (qp)
-			queue_work(qp->wq, &qp->work);
+			qm_poll_qp(qp, qm);
 
 		if (qm->status.eq_head == QM_Q_DEPTH - 1) {
 			qm->status.eqc_phase = !qm->status.eqc_phase;
@@ -531,6 +523,17 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
 	}
 
 	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
+}
+
+static irqreturn_t do_qm_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = (struct hisi_qm *)data;
+
+	/* the workqueue created by device driver of QM */
+	if (qm->wq)
+		queue_work(qm->wq, &qm->work);
+	else
+		schedule_work(&qm->work);
 
 	return IRQ_HANDLED;
 }
@@ -540,7 +543,7 @@ static irqreturn_t qm_irq(int irq, void *data)
 	struct hisi_qm *qm = data;
 
 	if (readl(qm->io_base + QM_VF_EQ_INT_SOURCE))
-		return qm_irq_handler(irq, data);
+		return do_qm_irq(irq, data);
 
 	dev_err(&qm->pdev->dev, "invalid int source\n");
 	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
@@ -1159,20 +1162,9 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 
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
@@ -1704,6 +1696,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 	qm->qp_in_used = 0;
 	mutex_init(&qm->mailbox_lock);
 	rwlock_init(&qm->qps_lock);
+	INIT_WORK(&qm->work, qm_work_process);
 
 	dev_dbg(dev, "init qm %s with %s\n", pdev->is_physfn ? "pf" : "vf",
 		qm->use_dma_api ? "dma api" : "iommu api");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 1a4f208..c72c2e6 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -183,6 +183,9 @@ struct hisi_qm {
 	u32 error_mask;
 	u32 msi_mask;
 
+	struct workqueue_struct *wq;
+	struct work_struct work;
+
 	const char *algs;
 	bool use_dma_api;
 	bool use_sva;
@@ -219,8 +222,6 @@ struct hisi_qp {
 	void *qp_ctx;
 	void (*req_cb)(struct hisi_qp *qp, void *data);
 	void (*event_cb)(struct hisi_qp *qp);
-	struct work_struct work;
-	struct workqueue_struct *wq;
 
 	struct hisi_qm *qm;
 	u16 pasid;
-- 
2.8.1

