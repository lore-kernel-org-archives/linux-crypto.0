Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2404CC48BE6
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CADC613CA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhFKJJS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:09:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4035 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhFKJJL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:09:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1Zbs4bzkzWsQC;
        Fri, 11 Jun 2021 17:02:17 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 17:07:09 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 17:07:08 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/8] crypto: hisilicon/qm - add the "alg_qos" file node
Date:   Fri, 11 Jun 2021 17:06:44 +0800
Message-ID: <1623402410-63906-3-git-send-email-yekai13@huawei.com>
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

1. Just move the code as needed.
2. Add the "alg_qos" file node in the qm debug sysfs.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 284 +++++++++++++++++++++++-------------------
 1 file changed, 155 insertions(+), 129 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f2e5d0b..171ddbb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3145,62 +3145,6 @@ static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id)
 	return 0;
 }
 
-static int hisi_qm_memory_init(struct hisi_qm *qm)
-{
-	struct device *dev = &qm->pdev->dev;
-	size_t qp_dma_size, off = 0;
-	int i, ret = 0;
-
-#define QM_INIT_BUF(qm, type, num) do { \
-	(qm)->type = ((qm)->qdma.va + (off)); \
-	(qm)->type##_dma = (qm)->qdma.dma + (off); \
-	off += QMC_ALIGN(sizeof(struct qm_##type) * (num)); \
-} while (0)
-
-	idr_init(&qm->qp_idr);
-	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_EQ_DEPTH) +
-			QMC_ALIGN(sizeof(struct qm_aeqe) * QM_Q_DEPTH) +
-			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
-			QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
-	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size, &qm->qdma.dma,
-					 GFP_ATOMIC);
-	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
-	if (!qm->qdma.va)
-		return -ENOMEM;
-
-	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
-	QM_INIT_BUF(qm, aeqe, QM_Q_DEPTH);
-	QM_INIT_BUF(qm, sqc, qm->qp_num);
-	QM_INIT_BUF(qm, cqc, qm->qp_num);
-
-	qm->qp_array = kcalloc(qm->qp_num, sizeof(struct hisi_qp), GFP_KERNEL);
-	if (!qm->qp_array) {
-		ret = -ENOMEM;
-		goto err_alloc_qp_array;
-	}
-
-	/* one more page for device or qp statuses */
-	qp_dma_size = qm->sqe_size * QM_Q_DEPTH +
-		      sizeof(struct qm_cqe) * QM_Q_DEPTH;
-	qp_dma_size = PAGE_ALIGN(qp_dma_size);
-	for (i = 0; i < qm->qp_num; i++) {
-		ret = hisi_qp_memory_init(qm, qp_dma_size, i);
-		if (ret)
-			goto err_init_qp_mem;
-
-		dev_dbg(dev, "allocate qp dma buf size=%zx)\n", qp_dma_size);
-	}
-
-	return ret;
-
-err_init_qp_mem:
-	hisi_qp_memory_uninit(qm, i);
-err_alloc_qp_array:
-	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
-
-	return ret;
-}
-
 static void hisi_qm_pre_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -3681,79 +3625,6 @@ static int qm_debugfs_atomic64_get(void *data, u64 *val)
 DEFINE_DEBUGFS_ATTRIBUTE(qm_atomic64_ops, qm_debugfs_atomic64_get,
 			 qm_debugfs_atomic64_set, "%llu\n");
 
-/**
- * hisi_qm_debug_init() - Initialize qm related debugfs files.
- * @qm: The qm for which we want to add debugfs files.
- *
- * Create qm related debugfs files.
- */
-void hisi_qm_debug_init(struct hisi_qm *qm)
-{
-	struct qm_dfx *dfx = &qm->debug.dfx;
-	struct dentry *qm_d;
-	void *data;
-	int i;
-
-	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
-	qm->debug.qm_d = qm_d;
-
-	/* only show this in PF */
-	if (qm->fun_type == QM_HW_PF) {
-		qm_create_debugfs_file(qm, qm->debug.debug_root, CURRENT_QM);
-		for (i = CURRENT_Q; i < DEBUG_FILE_NUM; i++)
-			qm_create_debugfs_file(qm, qm_d, i);
-	}
-
-	debugfs_create_file("regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
-
-	debugfs_create_file("cmd", 0444, qm->debug.qm_d, qm, &qm_cmd_fops);
-
-	debugfs_create_file("status", 0444, qm->debug.qm_d, qm,
-			&qm_status_fops);
-	for (i = 0; i < ARRAY_SIZE(qm_dfx_files); i++) {
-		data = (atomic64_t *)((uintptr_t)dfx + qm_dfx_files[i].offset);
-		debugfs_create_file(qm_dfx_files[i].name,
-			0644,
-			qm_d,
-			data,
-			&qm_atomic64_ops);
-	}
-}
-EXPORT_SYMBOL_GPL(hisi_qm_debug_init);
-
-/**
- * hisi_qm_debug_regs_clear() - clear qm debug related registers.
- * @qm: The qm for which we want to clear its debug registers.
- */
-void hisi_qm_debug_regs_clear(struct hisi_qm *qm)
-{
-	struct qm_dfx_registers *regs;
-	int i;
-
-	/* clear current_qm */
-	writel(0x0, qm->io_base + QM_DFX_MB_CNT_VF);
-	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
-
-	/* clear current_q */
-	writel(0x0, qm->io_base + QM_DFX_SQE_CNT_VF_SQN);
-	writel(0x0, qm->io_base + QM_DFX_CQE_CNT_VF_CQN);
-
-	/*
-	 * these registers are reading and clearing, so clear them after
-	 * reading them.
-	 */
-	writel(0x1, qm->io_base + QM_DFX_CNT_CLR_CE);
-
-	regs = qm_dfx_regs;
-	for (i = 0; i < CNT_CYC_REGS_NUM; i++) {
-		readl(qm->io_base + regs->reg_offset);
-		regs++;
-	}
-
-	writel(0x0, qm->io_base + QM_DFX_CNT_CLR_CE);
-}
-EXPORT_SYMBOL_GPL(hisi_qm_debug_regs_clear);
-
 static void qm_hw_error_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -4153,6 +4024,83 @@ static void hisi_qm_set_algqos_init(struct hisi_qm *qm)
 }
 
 /**
+ * hisi_qm_debug_init() - Initialize qm related debugfs files.
+ * @qm: The qm for which we want to add debugfs files.
+ *
+ * Create qm related debugfs files.
+ */
+void hisi_qm_debug_init(struct hisi_qm *qm)
+{
+	struct qm_dfx *dfx = &qm->debug.dfx;
+	struct dentry *qm_d;
+	void *data;
+	int i;
+
+	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
+	qm->debug.qm_d = qm_d;
+
+	/* only show this in PF */
+	if (qm->fun_type == QM_HW_PF) {
+		qm_create_debugfs_file(qm, qm->debug.debug_root, CURRENT_QM);
+		for (i = CURRENT_Q; i < DEBUG_FILE_NUM; i++)
+			qm_create_debugfs_file(qm, qm->debug.qm_d, i);
+	}
+
+	debugfs_create_file("regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
+
+	debugfs_create_file("cmd", 0600, qm->debug.qm_d, qm, &qm_cmd_fops);
+
+	debugfs_create_file("status", 0444, qm->debug.qm_d, qm,
+			&qm_status_fops);
+	for (i = 0; i < ARRAY_SIZE(qm_dfx_files); i++) {
+		data = (atomic64_t *)((uintptr_t)dfx + qm_dfx_files[i].offset);
+		debugfs_create_file(qm_dfx_files[i].name,
+			0644,
+			qm_d,
+			data,
+			&qm_atomic64_ops);
+	}
+
+	if (qm->ver >= QM_HW_V3)
+		hisi_qm_set_algqos_init(qm);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_debug_init);
+
+/**
+ * hisi_qm_debug_regs_clear() - clear qm debug related registers.
+ * @qm: The qm for which we want to clear its debug registers.
+ */
+void hisi_qm_debug_regs_clear(struct hisi_qm *qm)
+{
+	struct qm_dfx_registers *regs;
+	int i;
+
+	/* clear current_qm */
+	writel(0x0, qm->io_base + QM_DFX_MB_CNT_VF);
+	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
+
+	/* clear current_q */
+	writel(0x0, qm->io_base + QM_DFX_SQE_CNT_VF_SQN);
+	writel(0x0, qm->io_base + QM_DFX_CQE_CNT_VF_CQN);
+
+	/*
+	 * these registers are reading and clearing, so clear them after
+	 * reading them.
+	 */
+	writel(0x1, qm->io_base + QM_DFX_CNT_CLR_CE);
+
+	regs = qm_dfx_regs;
+	for (i = 0; i < CNT_CYC_REGS_NUM; i++) {
+		readl(qm->io_base + regs->reg_offset);
+		regs++;
+	}
+
+	/* clear clear_enable */
+	writel(0x0, qm->io_base + QM_DFX_CNT_CLR_CE);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_debug_regs_clear);
+
+/**
  * hisi_qm_sriov_enable() - enable virtual functions
  * @pdev: the PCIe device
  * @max_vfs: the number of virtual functions to enable
@@ -5389,6 +5337,84 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 	return ret;
 }
 
+static int hisi_qp_alloc_memory(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	size_t qp_dma_size;
+	int i, ret;
+
+	qm->qp_array = kcalloc(qm->qp_num, sizeof(struct hisi_qp), GFP_KERNEL);
+	if (!qm->qp_array)
+		return -ENOMEM;
+
+	/* one more page for device or qp statuses */
+	qp_dma_size = qm->sqe_size * QM_Q_DEPTH +
+		      sizeof(struct qm_cqe) * QM_Q_DEPTH;
+	qp_dma_size = PAGE_ALIGN(qp_dma_size) + PAGE_SIZE;
+	for (i = 0; i < qm->qp_num; i++) {
+		ret = hisi_qp_memory_init(qm, qp_dma_size, i);
+		if (ret)
+			goto err_init_qp_mem;
+
+		dev_dbg(dev, "allocate qp dma buf size=%zx)\n", qp_dma_size);
+	}
+
+	return 0;
+err_init_qp_mem:
+	hisi_qp_memory_uninit(qm, i);
+
+	return ret;
+}
+
+static int hisi_qm_memory_init(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret, total_vfs;
+	size_t off = 0;
+
+	total_vfs = pci_sriov_get_totalvfs(qm->pdev);
+	qm->factor = kcalloc(total_vfs + 1, sizeof(struct qm_shaper_factor), GFP_KERNEL);
+	if (!qm->factor)
+		return -ENOMEM;
+
+#define QM_INIT_BUF(qm, type, num) do { \
+	(qm)->type = ((qm)->qdma.va + (off)); \
+	(qm)->type##_dma = (qm)->qdma.dma + (off); \
+	off += QMC_ALIGN(sizeof(struct qm_##type) * (num)); \
+} while (0)
+
+	idr_init(&qm->qp_idr);
+	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_EQ_DEPTH) +
+			QMC_ALIGN(sizeof(struct qm_aeqe) * QM_Q_DEPTH) +
+			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
+			QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
+	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size, &qm->qdma.dma,
+					 GFP_ATOMIC);
+	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
+	if (!qm->qdma.va) {
+		ret =  -ENOMEM;
+		goto err_alloc_qdma;
+	}
+
+	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
+	QM_INIT_BUF(qm, aeqe, QM_Q_DEPTH);
+	QM_INIT_BUF(qm, sqc, qm->qp_num);
+	QM_INIT_BUF(qm, cqc, qm->qp_num);
+
+	ret = hisi_qp_alloc_memory(qm);
+	if (ret)
+		goto err_alloc_qp_array;
+
+	return 0;
+
+err_alloc_qp_array:
+	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
+err_alloc_qdma:
+	kfree(qm->factor);
+
+	return ret;
+}
+
 /**
  * hisi_qm_init() - Initialize configures about qm.
  * @qm: The qm needing init.
-- 
2.7.4

