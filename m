Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5E9C54E7F
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBBA217BA
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgEIJp0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 05:45:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4317 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728154AbgEIJpW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 05:45:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 76CB7BCEC9AFC5A6958A;
        Sat,  9 May 2020 17:45:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:45:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 09/12] crypto: hisilicon - QM memory management optimization
Date:   Sat, 9 May 2020 17:44:02 +0800
Message-ID: <1589017445-15514-10-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
References: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

Put all the code for the memory allocation into the QM initialization
process. Before, The qp memory was allocated when the qp was created,
and released when the qp was released, It is now changed to allocate
all the qp memory once.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 265 ++++++++++++++++++++----------------------
 drivers/crypto/hisilicon/qm.h |   4 +-
 2 files changed, 128 insertions(+), 141 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e401638..e988124 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -6,6 +6,7 @@
 #include <linux/bitmap.h>
 #include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
+#include <linux/idr.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
 #include <linux/log2.h>
@@ -575,7 +576,7 @@ static struct hisi_qp *qm_to_hisi_qp(struct hisi_qm *qm, struct qm_eqe *eqe)
 {
 	u16 cqn = le32_to_cpu(eqe->dw0) & QM_EQE_CQN_MASK;
 
-	return qm->qp_array[cqn];
+	return &qm->qp_array[cqn];
 }
 
 static void qm_cq_head_update(struct hisi_qp *qp)
@@ -625,8 +626,7 @@ static void qm_work_process(struct work_struct *work)
 	while (QM_EQE_PHASE(eqe) == qm->status.eqc_phase) {
 		eqe_num++;
 		qp = qm_to_hisi_qp(qm, eqe);
-		if (qp)
-			qm_poll_qp(qp, qm);
+		qm_poll_qp(qp, qm);
 
 		if (qm->status.eq_head == QM_Q_DEPTH - 1) {
 			qm->status.eqc_phase = !qm->status.eqc_phase;
@@ -1247,50 +1247,36 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct hisi_qp *qp;
-	int qp_id, ret;
+	int qp_id;
 
 	if (!qm_qp_avail_state(qm, NULL, QP_INIT))
 		return ERR_PTR(-EPERM);
 
-	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
-	if (!qp)
-		return ERR_PTR(-ENOMEM);
-
-	qp_id = find_first_zero_bit(qm->qp_bitmap, qm->qp_num);
-	if (qp_id >= qm->qp_num) {
-		dev_info(&qm->pdev->dev, "QM all queues are busy!\n");
-		ret = -EBUSY;
-		goto err_free_qp;
+	if (qm->qp_in_used == qm->qp_num) {
+		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
+				     qm->qp_num);
+		return ERR_PTR(-EBUSY);
 	}
-	set_bit(qp_id, qm->qp_bitmap);
-	qm->qp_array[qp_id] = qp;
-	qm->qp_in_used++;
-	qp->qm = qm;
 
-	qp->qdma.size = qm->sqe_size * QM_Q_DEPTH +
-			sizeof(struct qm_cqe) * QM_Q_DEPTH;
-	qp->qdma.va = dma_alloc_coherent(dev, qp->qdma.size,
-					 &qp->qdma.dma, GFP_KERNEL);
-	if (!qp->qdma.va) {
-		ret = -ENOMEM;
-		goto err_clear_bit;
+	qp_id = idr_alloc_cyclic(&qm->qp_idr, NULL, 0, qm->qp_num, GFP_ATOMIC);
+	if (qp_id < 0) {
+		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
+				    qm->qp_num);
+		return ERR_PTR(-EBUSY);
 	}
 
-	dev_dbg(dev, "allocate qp dma buf(va=%pK, dma=%pad, size=%zx)\n",
-		qp->qdma.va, &qp->qdma.dma, qp->qdma.size);
+	qp = &qm->qp_array[qp_id];
+
+	memset(qp->cqe, 0, sizeof(struct qm_cqe) * QM_Q_DEPTH);
 
+	qp->event_cb = NULL;
+	qp->req_cb = NULL;
 	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
+	qm->qp_in_used++;
 	atomic_set(&qp->qp_status.flags, QP_INIT);
 
 	return qp;
-
-err_clear_bit:
-	qm->qp_array[qp_id] = NULL;
-	clear_bit(qp_id, qm->qp_bitmap);
-err_free_qp:
-	kfree(qp);
-	return ERR_PTR(ret);
 }
 
 /**
@@ -1322,8 +1308,6 @@ EXPORT_SYMBOL_GPL(hisi_qm_create_qp);
 void hisi_qm_release_qp(struct hisi_qp *qp)
 {
 	struct hisi_qm *qm = qp->qm;
-	struct qm_dma *qdma = &qp->qdma;
-	struct device *dev = &qm->pdev->dev;
 
 	down_write(&qm->qps_lock);
 
@@ -1332,14 +1316,8 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 		return;
 	}
 
-	if (qdma->va)
-		dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
-
-	qm->qp_array[qp->qp_id] = NULL;
-	clear_bit(qp->qp_id, qm->qp_bitmap);
 	qm->qp_in_used--;
-
-	kfree(qp);
+	idr_remove(&qm->qp_idr, qp->qp_id);
 
 	up_write(&qm->qps_lock);
 }
@@ -1416,41 +1394,13 @@ static int qm_start_qp_nolock(struct hisi_qp *qp, unsigned long arg)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
-	enum qm_hw_ver ver = qm->ver;
 	int qp_id = qp->qp_id;
 	int pasid = arg;
-	size_t off = 0;
 	int ret;
 
 	if (!qm_qp_avail_state(qm, qp, QP_START))
 		return -EPERM;
 
-#define QP_INIT_BUF(qp, type, size) do { \
-	(qp)->type = ((qp)->qdma.va + (off)); \
-	(qp)->type##_dma = (qp)->qdma.dma + (off); \
-	off += (size); \
-} while (0)
-
-	if (!qp->qdma.dma) {
-		dev_err(dev, "cannot get qm dma buffer\n");
-		return -EINVAL;
-	}
-
-	/* sq need 128 bytes alignment */
-	if (qp->qdma.dma & QM_SQE_DATA_ALIGN_MASK) {
-		dev_err(dev, "qm sq is not aligned to 128 byte\n");
-		return -EINVAL;
-	}
-
-	QP_INIT_BUF(qp, sqe, qm->sqe_size * QM_Q_DEPTH);
-	QP_INIT_BUF(qp, cqe, sizeof(struct qm_cqe) * QM_Q_DEPTH);
-
-	dev_dbg(dev, "init qp buffer(v%d):\n"
-		     " sqe	(%pK, %lx)\n"
-		     " cqe	(%pK, %lx)\n",
-		     ver, qp->sqe, (unsigned long)qp->sqe_dma,
-		     qp->cqe, (unsigned long)qp->cqe_dma);
-
 	ret = qm_qp_ctx_cfg(qp, qp_id, pasid);
 	if (ret)
 		return ret;
@@ -1697,16 +1647,7 @@ static void qm_qp_event_notifier(struct hisi_qp *qp)
 
 static int hisi_qm_get_available_instances(struct uacce_device *uacce)
 {
-	int i, ret;
-	struct hisi_qm *qm = uacce->priv;
-
-	down_read(&qm->qps_lock);
-	for (i = 0, ret = 0; i < qm->qp_num; i++)
-		if (!qm->qp_array[i])
-			ret++;
-	up_read(&qm->qps_lock);
-
-	return ret;
+	return hisi_qm_get_free_qp_num(uacce->priv);
 }
 
 static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
@@ -1916,6 +1857,99 @@ int hisi_qm_get_free_qp_num(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_get_free_qp_num);
 
+static void hisi_qp_memory_uninit(struct hisi_qm *qm, int num)
+{
+	struct device *dev = &qm->pdev->dev;
+	struct qm_dma *qdma;
+	int i;
+
+	for (i = num - 1; i >= 0; i--) {
+		qdma = &qm->qp_array[i].qdma;
+		dma_free_coherent(dev, qdma->size, qdma->va, qdma->dma);
+	}
+
+	kfree(qm->qp_array);
+}
+
+static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id)
+{
+	struct device *dev = &qm->pdev->dev;
+	size_t off = qm->sqe_size * QM_Q_DEPTH;
+	struct hisi_qp *qp;
+
+	qp = &qm->qp_array[id];
+	qp->qdma.va = dma_alloc_coherent(dev, dma_size, &qp->qdma.dma,
+					 GFP_KERNEL);
+	if (!qp->qdma.va)
+		return -ENOMEM;
+
+	qp->sqe = qp->qdma.va;
+	qp->sqe_dma = qp->qdma.dma;
+	qp->cqe = qp->qdma.va + off;
+	qp->cqe_dma = qp->qdma.dma + off;
+	qp->qdma.size = dma_size;
+	qp->qm = qm;
+	qp->qp_id = id;
+
+	return 0;
+}
+
+static int hisi_qm_memory_init(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	size_t qp_dma_size, off = 0;
+	int i, ret = 0;
+
+#define QM_INIT_BUF(qm, type, num) do { \
+	(qm)->type = ((qm)->qdma.va + (off)); \
+	(qm)->type##_dma = (qm)->qdma.dma + (off); \
+	off += QMC_ALIGN(sizeof(struct qm_##type) * (num)); \
+} while (0)
+
+	idr_init(&qm->qp_idr);
+	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_Q_DEPTH) +
+			QMC_ALIGN(sizeof(struct qm_aeqe) * QM_Q_DEPTH) +
+			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
+			QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
+	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size, &qm->qdma.dma,
+					 GFP_ATOMIC);
+	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
+	if (!qm->qdma.va)
+		return -ENOMEM;
+
+	QM_INIT_BUF(qm, eqe, QM_Q_DEPTH);
+	QM_INIT_BUF(qm, aeqe, QM_Q_DEPTH);
+	QM_INIT_BUF(qm, sqc, qm->qp_num);
+	QM_INIT_BUF(qm, cqc, qm->qp_num);
+
+	qm->qp_array = kcalloc(qm->qp_num, sizeof(struct hisi_qp), GFP_KERNEL);
+	if (!qm->qp_array) {
+		ret = -ENOMEM;
+		goto err_alloc_qp_array;
+	}
+
+	/* one more page for device or qp statuses */
+	qp_dma_size = qm->sqe_size * QM_Q_DEPTH +
+		      sizeof(struct qm_cqe) * QM_Q_DEPTH;
+	qp_dma_size = PAGE_ALIGN(qp_dma_size);
+	for (i = 0; i < qm->qp_num; i++) {
+		ret = hisi_qp_memory_init(qm, qp_dma_size, i);
+		if (ret)
+			goto err_init_qp_mem;
+
+		dev_dbg(dev, "allocate qp dma buf size=%zx)\n", qp_dma_size);
+	}
+
+	return ret;
+
+err_init_qp_mem:
+	hisi_qp_memory_uninit(qm, i);
+err_alloc_qp_array:
+	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
+
+	return ret;
+}
+
 static void hisi_qm_pre_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -2003,6 +2037,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 			goto err_irq_unregister;
 	}
 
+	ret = hisi_qm_memory_init(qm);
+	if (ret)
+		goto err_irq_unregister;
+
 	INIT_WORK(&qm->work, qm_work_process);
 
 	atomic_set(&qm->status.flags, QM_INIT);
@@ -2048,6 +2086,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	uacce_remove(qm->uacce);
 	qm->uacce = NULL;
 
+	hisi_qp_memory_uninit(qm, qm->qp_num);
+	idr_destroy(&qm->qp_idr);
+
 	if (qm->qdma.va) {
 		hisi_qm_cache_wb(qm);
 		dma_free_coherent(dev, qm->qdma.size,
@@ -2176,22 +2217,10 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 
 static int __hisi_qm_start(struct hisi_qm *qm)
 {
-	struct pci_dev *pdev = qm->pdev;
-	struct device *dev = &pdev->dev;
-	size_t off = 0;
 	int ret;
 
-#define QM_INIT_BUF(qm, type, num) do { \
-	(qm)->type = ((qm)->qdma.va + (off)); \
-	(qm)->type##_dma = (qm)->qdma.dma + (off); \
-	off += QMC_ALIGN(sizeof(struct qm_##type) * (num)); \
-} while (0)
-
 	WARN_ON(!qm->qdma.dma);
 
-	if (qm->qp_num == 0)
-		return -EINVAL;
-
 	if (qm->fun_type == QM_HW_PF) {
 		ret = qm_dev_mem_reset(qm);
 		if (ret)
@@ -2202,21 +2231,6 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 			return ret;
 	}
 
-	QM_INIT_BUF(qm, eqe, QM_Q_DEPTH);
-	QM_INIT_BUF(qm, aeqe, QM_Q_DEPTH);
-	QM_INIT_BUF(qm, sqc, qm->qp_num);
-	QM_INIT_BUF(qm, cqc, qm->qp_num);
-
-	dev_dbg(dev, "init qm buffer:\n"
-		     " eqe	(%pK, %lx)\n"
-		     " aeqe	(%pK, %lx)\n"
-		     " sqc	(%pK, %lx)\n"
-		     " cqc	(%pK, %lx)\n",
-		     qm->eqe, (unsigned long)qm->eqe_dma,
-		     qm->aeqe, (unsigned long)qm->aeqe_dma,
-		     qm->sqc, (unsigned long)qm->sqc_dma,
-		     qm->cqc, (unsigned long)qm->cqc_dma);
-
 	ret = qm_eq_ctx_cfg(qm);
 	if (ret)
 		return ret;
@@ -2261,33 +2275,6 @@ int hisi_qm_start(struct hisi_qm *qm)
 		goto err_unlock;
 	}
 
-	if (!qm->qp_bitmap) {
-		qm->qp_bitmap = devm_kcalloc(dev, BITS_TO_LONGS(qm->qp_num),
-					     sizeof(long), GFP_KERNEL);
-		qm->qp_array = devm_kcalloc(dev, qm->qp_num,
-					    sizeof(struct hisi_qp *),
-					    GFP_KERNEL);
-		if (!qm->qp_bitmap || !qm->qp_array) {
-			ret = -ENOMEM;
-			goto err_unlock;
-		}
-	}
-
-	if (!qm->qdma.va) {
-		qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_Q_DEPTH) +
-				QMC_ALIGN(sizeof(struct qm_aeqe) * QM_Q_DEPTH) +
-				QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
-				QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
-		qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size,
-						 &qm->qdma.dma, GFP_KERNEL);
-		dev_dbg(dev, "allocate qm dma buf(va=%pK, dma=%pad, size=%zx)\n",
-			qm->qdma.va, &qm->qdma.dma, qm->qdma.size);
-		if (!qm->qdma.va) {
-			ret = -ENOMEM;
-			goto err_unlock;
-		}
-	}
-
 	ret = __hisi_qm_start(qm);
 	if (!ret)
 		atomic_set(&qm->status.flags, QM_START);
@@ -2310,8 +2297,8 @@ static int qm_restart(struct hisi_qm *qm)
 
 	down_write(&qm->qps_lock);
 	for (i = 0; i < qm->qp_num; i++) {
-		qp = qm->qp_array[i];
-		if (qp && atomic_read(&qp->qp_status.flags) == QP_STOP &&
+		qp = &qm->qp_array[i];
+		if (atomic_read(&qp->qp_status.flags) == QP_STOP &&
 		    qp->is_resetting == true) {
 			ret = qm_start_qp_nolock(qp, 0);
 			if (ret < 0) {
@@ -2336,7 +2323,7 @@ static int qm_stop_started_qp(struct hisi_qm *qm)
 	int i, ret;
 
 	for (i = 0; i < qm->qp_num; i++) {
-		qp = qm->qp_array[i];
+		qp = &qm->qp_array[i];
 		if (qp && atomic_read(&qp->qp_status.flags) == QP_START) {
 			qp->is_resetting = true;
 			ret = qm_stop_qp_nolock(qp);
@@ -2360,8 +2347,8 @@ static void qm_clear_queues(struct hisi_qm *qm)
 	int i;
 
 	for (i = 0; i < qm->qp_num; i++) {
-		qp = qm->qp_array[i];
-		if (qp && qp->is_resetting)
+		qp = &qm->qp_array[i];
+		if (qp->is_resetting)
 			memset(qp->qdma.va, 0, qp->qdma.size);
 	}
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 743cb63..80b9746 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -214,8 +214,8 @@ struct hisi_qm {
 	unsigned long reset_flag;
 
 	struct rw_semaphore qps_lock;
-	unsigned long *qp_bitmap;
-	struct hisi_qp **qp_array;
+	struct idr qp_idr;
+	struct hisi_qp *qp_array;
 
 	struct mutex mailbox_lock;
 
-- 
2.7.4

