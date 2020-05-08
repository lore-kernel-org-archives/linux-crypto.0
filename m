Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA00C47247
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E95A21582
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHG7J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:59:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbgEHG7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:59:07 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 18D1A84D3CFDA324D742;
        Fri,  8 May 2020 14:59:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 14:58:52 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 05/13] crypto: hisilicon/qm - add state machine for QM
Date:   Fri, 8 May 2020 14:57:40 +0800
Message-ID: <1588921068-20739-6-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

Add specific states for qm and qp, every state change under critical region
to prevent from race condition. Meanwhile, qp state change will also depend
on qm state.

Due to the introduction of these states, it is necessary to pay attention
to the calls of public logic, such as concurrent scenarios resetting and
releasing queue will call hisi_qm_stop, which needs to add additional
status to distinguish and process.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 366 +++++++++++++++++++++++++++++++++---------
 drivers/crypto/hisilicon/qm.h |  24 ++-
 2 files changed, 307 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 69d02cb..e42097e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -352,6 +352,93 @@ static const char * const qm_fifo_overflow[] = {
 	"cq", "eq", "aeq",
 };
 
+static const char * const qm_s[] = {
+	"init", "start", "close", "stop",
+};
+
+static const char * const qp_s[] = {
+	"none", "init", "start", "stop", "close",
+};
+
+static bool qm_avail_state(struct hisi_qm *qm, enum qm_state new)
+{
+	enum qm_state curr = atomic_read(&qm->status.flags);
+	bool avail = false;
+
+	switch (curr) {
+	case QM_INIT:
+		if (new == QM_START || new == QM_CLOSE)
+			avail = true;
+		break;
+	case QM_START:
+		if (new == QM_STOP)
+			avail = true;
+		break;
+	case QM_STOP:
+		if (new == QM_CLOSE || new == QM_START)
+			avail = true;
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(&qm->pdev->dev, "change qm state from %s to %s\n",
+		qm_s[curr], qm_s[new]);
+
+	if (!avail)
+		dev_warn(&qm->pdev->dev, "Can not change qm state from %s to %s\n",
+			 qm_s[curr], qm_s[new]);
+
+	return avail;
+}
+
+static bool qm_qp_avail_state(struct hisi_qm *qm, struct hisi_qp *qp,
+			      enum qp_state new)
+{
+	enum qm_state qm_curr = atomic_read(&qm->status.flags);
+	enum qp_state qp_curr = 0;
+	bool avail = false;
+
+	if (qp)
+		qp_curr = atomic_read(&qp->qp_status.flags);
+
+	switch (new) {
+	case QP_INIT:
+		if (qm_curr == QM_START || qm_curr == QM_INIT)
+			avail = true;
+		break;
+	case QP_START:
+		if ((qm_curr == QM_START && qp_curr == QP_INIT) ||
+		    (qm_curr == QM_START && qp_curr == QP_STOP))
+			avail = true;
+		break;
+	case QP_STOP:
+		if ((qm_curr == QM_START && qp_curr == QP_START) ||
+		    (qp_curr == QP_INIT))
+			avail = true;
+		break;
+	case QP_CLOSE:
+		if ((qm_curr == QM_START && qp_curr == QP_INIT) ||
+		    (qm_curr == QM_START && qp_curr == QP_STOP) ||
+		    (qm_curr == QM_STOP && qp_curr == QP_STOP)  ||
+		    (qm_curr == QM_STOP && qp_curr == QP_INIT))
+			avail = true;
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(&qm->pdev->dev, "change qp state from %s to %s in QM %s\n",
+		qp_s[qp_curr], qp_s[new], qm_s[qm_curr]);
+
+	if (!avail)
+		dev_warn(&qm->pdev->dev,
+			 "Can not change qp state from %s to %s in QM %s\n",
+			 qp_s[qp_curr], qp_s[new], qm_s[qm_curr]);
+
+	return avail;
+}
+
 /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
 static int qm_wait_mb_ready(struct hisi_qm *qm)
 {
@@ -699,7 +786,7 @@ static void qm_init_qp_status(struct hisi_qp *qp)
 	qp_status->sq_tail = 0;
 	qp_status->cq_head = 0;
 	qp_status->cqc_phase = true;
-	qp_status->flags = 0;
+	atomic_set(&qp_status->flags, 0);
 }
 
 static void qm_vft_data_cfg(struct hisi_qm *qm, enum vft_type type, u32 base,
@@ -1155,29 +1242,21 @@ static void *qm_get_avail_sqe(struct hisi_qp *qp)
 	return qp->sqe + sq_tail * qp->qm->sqe_size;
 }
 
-/**
- * hisi_qm_create_qp() - Create a queue pair from qm.
- * @qm: The qm we create a qp from.
- * @alg_type: Accelerator specific algorithm type in sqc.
- *
- * return created qp, -EBUSY if all qps in qm allocated, -ENOMEM if allocating
- * qp memory fails.
- */
-struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
+static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct hisi_qp *qp;
 	int qp_id, ret;
 
+	if (!qm_qp_avail_state(qm, NULL, QP_INIT))
+		return ERR_PTR(-EPERM);
+
 	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
-	write_lock(&qm->qps_lock);
-
 	qp_id = find_first_zero_bit(qm->qp_bitmap, qm->qp_num);
 	if (qp_id >= qm->qp_num) {
-		write_unlock(&qm->qps_lock);
 		dev_info(&qm->pdev->dev, "QM all queues are busy!\n");
 		ret = -EBUSY;
 		goto err_free_qp;
@@ -1185,9 +1264,6 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 	set_bit(qp_id, qm->qp_bitmap);
 	qm->qp_array[qp_id] = qp;
 	qm->qp_in_used++;
-
-	write_unlock(&qm->qps_lock);
-
 	qp->qm = qm;
 
 	if (qm->use_dma_api) {
@@ -1206,18 +1282,36 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 
 	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
+	atomic_set(&qp->qp_status.flags, QP_INIT);
 
 	return qp;
 
 err_clear_bit:
-	write_lock(&qm->qps_lock);
 	qm->qp_array[qp_id] = NULL;
 	clear_bit(qp_id, qm->qp_bitmap);
-	write_unlock(&qm->qps_lock);
 err_free_qp:
 	kfree(qp);
 	return ERR_PTR(ret);
 }
+
+/**
+ * hisi_qm_create_qp() - Create a queue pair from qm.
+ * @qm: The qm we create a qp from.
+ * @alg_type: Accelerator specific algorithm type in sqc.
+ *
+ * return created qp, -EBUSY if all qps in qm allocated, -ENOMEM if allocating
+ * qp memory fails.
+ */
+struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
+{
+	struct hisi_qp *qp;
+
+	down_write(&qm->qps_lock);
+	qp = qm_create_qp_nolock(qm, alg_type);
+	up_write(&qm->qps_lock);
+
+	return qp;
+}
 EXPORT_SYMBOL_GPL(hisi_qm_create_qp);
 
 /**
@@ -1232,16 +1326,23 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 	struct qm_dma *qdma = &qp->qdma;
 	struct device *dev = &qm->pdev->dev;
 
+	down_write(&qm->qps_lock);
+
+	if (!qm_qp_avail_state(qm, qp, QP_CLOSE)) {
+		up_write(&qm->qps_lock);
+		return;
+	}
+
 	if (qm->use_dma_api && qdma->va)
 		dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
 
-	write_lock(&qm->qps_lock);
 	qm->qp_array[qp->qp_id] = NULL;
 	clear_bit(qp->qp_id, qm->qp_bitmap);
 	qm->qp_in_used--;
-	write_unlock(&qm->qps_lock);
 
 	kfree(qp);
+
+	up_write(&qm->qps_lock);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
 
@@ -1312,15 +1413,7 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	return ret;
 }
 
-/**
- * hisi_qm_start_qp() - Start a qp into running.
- * @qp: The qp we want to start to run.
- * @arg: Accelerator specific argument.
- *
- * After this function, qp can receive request from user. Return 0 if
- * successful, Return -EBUSY if failed.
- */
-int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
+static int qm_start_qp_nolock(struct hisi_qp *qp, unsigned long arg)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
@@ -1330,6 +1423,9 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 	size_t off = 0;
 	int ret;
 
+	if (!qm_qp_avail_state(qm, qp, QP_START))
+		return -EPERM;
+
 #define QP_INIT_BUF(qp, type, size) do { \
 	(qp)->type = ((qp)->qdma.va + (off)); \
 	(qp)->type##_dma = (qp)->qdma.dma + (off); \
@@ -1360,10 +1456,31 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 	if (ret)
 		return ret;
 
+	atomic_set(&qp->qp_status.flags, QP_START);
 	dev_dbg(dev, "queue %d started\n", qp_id);
 
 	return 0;
 }
+
+/**
+ * hisi_qm_start_qp() - Start a qp into running.
+ * @qp: The qp we want to start to run.
+ * @arg: Accelerator specific argument.
+ *
+ * After this function, qp can receive request from user. Return 0 if
+ * successful, Return -EBUSY if failed.
+ */
+int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
+{
+	struct hisi_qm *qm = qp->qm;
+	int ret;
+
+	down_write(&qm->qps_lock);
+	ret = qm_start_qp_nolock(qp, arg);
+	up_write(&qm->qps_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 
 static void *qm_ctx_alloc(struct hisi_qm *qm, size_t ctx_size,
@@ -1467,20 +1584,26 @@ static int qm_drain_qp(struct hisi_qp *qp)
 	return ret;
 }
 
-/**
- * hisi_qm_stop_qp() - Stop a qp in qm.
- * @qp: The qp we want to stop.
- *
- * This function is reverse of hisi_qm_start_qp. Return 0 if successful.
- */
-int hisi_qm_stop_qp(struct hisi_qp *qp)
+static int qm_stop_qp_nolock(struct hisi_qp *qp)
 {
 	struct device *dev = &qp->qm->pdev->dev;
 	int ret;
 
-	/* it is stopped */
-	if (test_bit(QP_STOP, &qp->qp_status.flags))
+	/*
+	 * It is allowed to stop and release qp when reset, If the qp is
+	 * stopped when reset but still want to be released then, the
+	 * is_resetting flag should be set negative so that this qp will not
+	 * be restarted after reset.
+	 */
+	if (atomic_read(&qp->qp_status.flags) == QP_STOP) {
+		qp->is_resetting = false;
 		return 0;
+	}
+
+	if (!qm_qp_avail_state(qp->qm, qp, QP_STOP))
+		return -EPERM;
+
+	atomic_set(&qp->qp_status.flags, QP_STOP);
 
 	ret = qm_drain_qp(qp);
 	if (ret)
@@ -1491,12 +1614,27 @@ int hisi_qm_stop_qp(struct hisi_qp *qp)
 	else
 		flush_work(&qp->qm->work);
 
-	set_bit(QP_STOP, &qp->qp_status.flags);
-
 	dev_dbg(dev, "stop queue %u!", qp->qp_id);
 
 	return 0;
 }
+
+/**
+ * hisi_qm_stop_qp() - Stop a qp in qm.
+ * @qp: The qp we want to stop.
+ *
+ * This function is reverse of hisi_qm_start_qp. Return 0 if successful.
+ */
+int hisi_qm_stop_qp(struct hisi_qp *qp)
+{
+	int ret;
+
+	down_write(&qp->qm->qps_lock);
+	ret = qm_stop_qp_nolock(qp);
+	up_write(&qp->qm->qps_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(hisi_qm_stop_qp);
 
 /**
@@ -1506,6 +1644,13 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop_qp);
  *
  * This function will return -EBUSY if qp is currently full, and -EAGAIN
  * if qp related qm is resetting.
+ *
+ * Note: This function may run with qm_irq_thread and ACC reset at same time.
+ *       It has no race with qm_irq_thread. However, during hisi_qp_send, ACC
+ *       reset may happen, we have no lock here considering performance. This
+ *       causes current qm_db sending fail or can not receive sended sqe. QM
+ *       sync/async receive function should handle the error sqe. ACC reset
+ *       done function should clear used sqe to 0.
  */
 int hisi_qp_send(struct hisi_qp *qp, const void *msg)
 {
@@ -1514,7 +1659,9 @@ int hisi_qp_send(struct hisi_qp *qp, const void *msg)
 	u16 sq_tail_next = (sq_tail + 1) % QM_Q_DEPTH;
 	void *sqe = qm_get_avail_sqe(qp);
 
-	if (unlikely(test_bit(QP_STOP, &qp->qp_status.flags))) {
+	if (unlikely(atomic_read(&qp->qp_status.flags) == QP_STOP ||
+		     atomic_read(&qp->qm->status.flags) == QM_STOP ||
+		     qp->is_resetting)) {
 		dev_info(&qp->qm->pdev->dev, "QP is stopped or resetting\n");
 		return -EAGAIN;
 	}
@@ -1554,11 +1701,11 @@ static int hisi_qm_get_available_instances(struct uacce_device *uacce)
 	int i, ret;
 	struct hisi_qm *qm = uacce->priv;
 
-	read_lock(&qm->qps_lock);
+	down_read(&qm->qps_lock);
 	for (i = 0, ret = 0; i < qm->qp_num; i++)
 		if (!qm->qp_array[i])
 			ret++;
-	read_unlock(&qm->qps_lock);
+	up_read(&qm->qps_lock);
 
 	return ret;
 }
@@ -1658,9 +1805,9 @@ static int qm_set_sqctype(struct uacce_queue *q, u16 type)
 	struct hisi_qm *qm = q->uacce->priv;
 	struct hisi_qp *qp = q->priv;
 
-	write_lock(&qm->qps_lock);
+	down_write(&qm->qps_lock);
 	qp->alg_type = type;
-	write_unlock(&qm->qps_lock);
+	up_write(&qm->qps_lock);
 
 	return 0;
 }
@@ -1762,9 +1909,9 @@ int hisi_qm_get_free_qp_num(struct hisi_qm *qm)
 {
 	int ret;
 
-	read_lock(&qm->qps_lock);
+	down_read(&qm->qps_lock);
 	ret = qm->qp_num - qm->qp_in_used;
-	read_unlock(&qm->qps_lock);
+	up_read(&qm->qps_lock);
 
 	return ret;
 }
@@ -1840,9 +1987,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 
 	qm->qp_in_used = 0;
 	mutex_init(&qm->mailbox_lock);
-	rwlock_init(&qm->qps_lock);
+	init_rwsem(&qm->qps_lock);
 	INIT_WORK(&qm->work, qm_work_process);
 
+	atomic_set(&qm->status.flags, QM_INIT);
 	dev_dbg(dev, "init qm %s with %s\n", pdev->is_physfn ? "pf" : "vf",
 		qm->use_dma_api ? "dma api" : "iommu api");
 
@@ -1875,6 +2023,13 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 
+	down_write(&qm->qps_lock);
+
+	if (!qm_avail_state(qm, QM_CLOSE)) {
+		up_write(&qm->qps_lock);
+		return;
+	}
+
 	uacce_remove(qm->uacce);
 	qm->uacce = NULL;
 
@@ -1890,6 +2045,8 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	iounmap(qm->io_base);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
+
+	up_write(&qm->qps_lock);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
@@ -2072,12 +2229,21 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 int hisi_qm_start(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
+	int ret = 0;
+
+	down_write(&qm->qps_lock);
+
+	if (!qm_avail_state(qm, QM_START)) {
+		up_write(&qm->qps_lock);
+		return -EPERM;
+	}
 
 	dev_dbg(dev, "qm start with %d queue pairs\n", qm->qp_num);
 
 	if (!qm->qp_num) {
 		dev_err(dev, "qp_num should not be 0\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_unlock;
 	}
 
 	if (!qm->qp_bitmap) {
@@ -2086,12 +2252,15 @@ int hisi_qm_start(struct hisi_qm *qm)
 		qm->qp_array = devm_kcalloc(dev, qm->qp_num,
 					    sizeof(struct hisi_qp *),
 					    GFP_KERNEL);
-		if (!qm->qp_bitmap || !qm->qp_array)
-			return -ENOMEM;
+		if (!qm->qp_bitmap || !qm->qp_array) {
+			ret = -ENOMEM;
+			goto err_unlock;
+		}
 	}
 
 	if (!qm->use_dma_api) {
 		dev_dbg(&qm->pdev->dev, "qm delay start\n");
+		up_write(&qm->qps_lock);
 		return 0;
 	} else if (!qm->qdma.va) {
 		qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_Q_DEPTH) +
@@ -2102,11 +2271,19 @@ int hisi_qm_start(struct hisi_qm *qm)
 						 &qm->qdma.dma, GFP_KERNEL);
 		dev_dbg(dev, "allocate qm dma buf(va=%pK, dma=%pad, size=%zx)\n",
 			qm->qdma.va, &qm->qdma.dma, qm->qdma.size);
-		if (!qm->qdma.va)
-			return -ENOMEM;
+		if (!qm->qdma.va) {
+			ret = -ENOMEM;
+			goto err_unlock;
+		}
 	}
 
-	return __hisi_qm_start(qm);
+	ret = __hisi_qm_start(qm);
+	if (!ret)
+		atomic_set(&qm->status.flags, QM_START);
+
+err_unlock:
+	up_write(&qm->qps_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_start);
 
@@ -2120,20 +2297,44 @@ static int qm_restart(struct hisi_qm *qm)
 	if (ret < 0)
 		return ret;
 
-	write_lock(&qm->qps_lock);
+	down_write(&qm->qps_lock);
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = qm->qp_array[i];
-		if (qp) {
-			ret = hisi_qm_start_qp(qp, 0);
+		if (qp && atomic_read(&qp->qp_status.flags) == QP_STOP &&
+		    qp->is_resetting == true) {
+			ret = qm_start_qp_nolock(qp, 0);
 			if (ret < 0) {
 				dev_err(dev, "Failed to start qp%d!\n", i);
 
-				write_unlock(&qm->qps_lock);
+				up_write(&qm->qps_lock);
+				return ret;
+			}
+			qp->is_resetting = false;
+		}
+	}
+	up_write(&qm->qps_lock);
+
+	return 0;
+}
+
+/* Stop started qps in reset flow */
+static int qm_stop_started_qp(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	struct hisi_qp *qp;
+	int i, ret;
+
+	for (i = 0; i < qm->qp_num; i++) {
+		qp = qm->qp_array[i];
+		if (qp && atomic_read(&qp->qp_status.flags) == QP_START) {
+			qp->is_resetting = true;
+			ret = qm_stop_qp_nolock(qp);
+			if (ret < 0) {
+				dev_err(dev, "Failed to stop qp%d!\n", i);
 				return ret;
 			}
 		}
 	}
-	write_unlock(&qm->qps_lock);
 
 	return 0;
 }
@@ -2149,7 +2350,7 @@ static void qm_clear_queues(struct hisi_qm *qm)
 
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = qm->qp_array[i];
-		if (qp)
+		if (qp && qp->is_resetting)
 			memset(qp->qdma.va, 0, qp->qdma.size);
 	}
 
@@ -2166,41 +2367,43 @@ static void qm_clear_queues(struct hisi_qm *qm)
  */
 int hisi_qm_stop(struct hisi_qm *qm)
 {
-	struct device *dev;
-	struct hisi_qp *qp;
-	int ret = 0, i;
+	struct device *dev = &qm->pdev->dev;
+	int ret = 0;
 
-	if (!qm || !qm->pdev) {
-		WARN_ON(1);
-		return -EINVAL;
+	down_write(&qm->qps_lock);
+
+	if (!qm_avail_state(qm, QM_STOP)) {
+		ret = -EPERM;
+		goto err_unlock;
 	}
 
-	dev = &qm->pdev->dev;
+	if (qm->status.stop_reason == QM_SOFT_RESET ||
+	    qm->status.stop_reason == QM_FLR) {
+		ret = qm_stop_started_qp(qm);
+		if (ret < 0) {
+			dev_err(dev, "Failed to stop started qp!\n");
+			goto err_unlock;
+		}
+	}
 
 	/* Mask eq and aeq irq */
 	writel(0x1, qm->io_base + QM_VF_EQ_INT_MASK);
 	writel(0x1, qm->io_base + QM_VF_AEQ_INT_MASK);
 
-	/* Stop all qps belong to this qm */
-	for (i = 0; i < qm->qp_num; i++) {
-		qp = qm->qp_array[i];
-		if (qp) {
-			ret = hisi_qm_stop_qp(qp);
-			if (ret < 0) {
-				dev_err(dev, "Failed to stop qp%d!\n", i);
-				return -EBUSY;
-			}
-		}
-	}
-
 	if (qm->fun_type == QM_HW_PF) {
 		ret = hisi_qm_set_vft(qm, 0, 0, 0);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(dev, "Failed to set vft!\n");
+			ret = -EBUSY;
+			goto err_unlock;
+		}
 	}
 
 	qm_clear_queues(qm);
+	atomic_set(&qm->status.flags, QM_STOP);
 
+err_unlock:
+	up_write(&qm->qps_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_stop);
@@ -2772,6 +2975,7 @@ static int qm_set_msi(struct hisi_qm *qm, bool set)
 static int qm_vf_reset_prepare(struct hisi_qm *qm)
 {
 	struct hisi_qm_list *qm_list = qm->qm_list;
+	int stop_reason = qm->status.stop_reason;
 	struct pci_dev *pdev = qm->pdev;
 	struct pci_dev *virtfn;
 	struct hisi_qm *vf_qm;
@@ -2784,6 +2988,7 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm)
 			continue;
 
 		if (pci_physfn(virtfn) == pdev) {
+			vf_qm->status.stop_reason = stop_reason;
 			ret = hisi_qm_stop(vf_qm);
 			if (ret)
 				goto stop_fail;
@@ -2830,6 +3035,7 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		}
 	}
 
+	qm->status.stop_reason = QM_SOFT_RESET;
 	ret = hisi_qm_stop(qm);
 	if (ret) {
 		pci_err(pdev, "Fails to stop QM!\n");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index d1be8cd..eff156a 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -84,8 +84,24 @@
 /* page number for queue file region */
 #define QM_DOORBELL_PAGE_NR		1
 
+enum qm_stop_reason {
+	QM_NORMAL,
+	QM_SOFT_RESET,
+	QM_FLR,
+};
+
+enum qm_state {
+	QM_INIT = 0,
+	QM_START,
+	QM_CLOSE,
+	QM_STOP,
+};
+
 enum qp_state {
+	QP_INIT = 1,
+	QP_START,
 	QP_STOP,
+	QP_CLOSE,
 };
 
 enum qm_hw_ver {
@@ -129,7 +145,8 @@ struct hisi_qm_status {
 	bool eqc_phase;
 	u32 aeq_head;
 	bool aeqc_phase;
-	unsigned long flags;
+	atomic_t flags;
+	int stop_reason;
 };
 
 struct hisi_qm;
@@ -196,7 +213,7 @@ struct hisi_qm {
 	struct hisi_qm_err_status err_status;
 	unsigned long reset_flag;
 
-	rwlock_t qps_lock;
+	struct rw_semaphore qps_lock;
 	unsigned long *qp_bitmap;
 	struct hisi_qp **qp_array;
 
@@ -225,7 +242,7 @@ struct hisi_qp_status {
 	u16 sq_tail;
 	u16 cq_head;
 	bool cqc_phase;
-	unsigned long flags;
+	atomic_t flags;
 };
 
 struct hisi_qp_ops {
@@ -250,6 +267,7 @@ struct hisi_qp {
 	void (*event_cb)(struct hisi_qp *qp);
 
 	struct hisi_qm *qm;
+	bool is_resetting;
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 };
-- 
2.7.4

