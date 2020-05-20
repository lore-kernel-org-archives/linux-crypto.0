Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB753C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBB9207ED
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 09:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETJVR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 05:21:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4825 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgETJVP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 05:21:15 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D4A7C41085CE4D065252;
        Wed, 20 May 2020 17:21:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 17:21:00 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto:hisilicon - fix driver compatibility issue with different versions of devices
Date:   Wed, 20 May 2020 17:19:50 +0800
Message-ID: <1589966390-37030-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

In order to be compatible with devices of different versions, V1 in the
accelerator driver is now isolated, and other versions are the previous
V2 processing flow.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 10 +---
 drivers/crypto/hisilicon/qm.c             | 89 ++++++++++---------------------
 drivers/crypto/hisilicon/qm.h             | 13 ++---
 drivers/crypto/hisilicon/sec2/sec_main.c  | 19 ++-----
 drivers/crypto/hisilicon/zip/zip_main.c   | 20 ++-----
 5 files changed, 39 insertions(+), 112 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 38405b5..a3ee127 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -717,19 +717,13 @@ static void hpre_debugfs_exit(struct hpre *hpre)
 
 static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
-	enum qm_hw_ver rev_id;
-
-	rev_id = hisi_qm_get_hw_version(pdev);
-	if (rev_id < 0)
-		return -ENODEV;
-
-	if (rev_id == QM_HW_V1) {
+	if (pdev->revision == QM_HW_V1) {
 		pci_warn(pdev, "HPRE version 1 is not supported!\n");
 		return -EINVAL;
 	}
 
 	qm->pdev = pdev;
-	qm->ver = rev_id;
+	qm->ver = pdev->revision;
 	qm->sqe_size = HPRE_SQE_SIZE;
 	qm->dev_name = hpre_name;
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a781c02..9bb263c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -737,13 +737,14 @@ static void qm_irq_unregister(struct hisi_qm *qm)
 
 	free_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR), qm);
 
-	if (qm->ver == QM_HW_V2) {
-		free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
+	if (qm->ver == QM_HW_V1)
+		return;
 
-		if (qm->fun_type == QM_HW_PF)
-			free_irq(pci_irq_vector(pdev,
-				 QM_ABNORMAL_EVENT_IRQ_VECTOR), qm);
-	}
+	free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
+
+	if (qm->fun_type == QM_HW_PF)
+		free_irq(pci_irq_vector(pdev,
+			 QM_ABNORMAL_EVENT_IRQ_VECTOR), qm);
 }
 
 static void qm_init_qp_status(struct hisi_qp *qp)
@@ -764,36 +765,26 @@ static void qm_vft_data_cfg(struct hisi_qm *qm, enum vft_type type, u32 base,
 	if (number > 0) {
 		switch (type) {
 		case SQC_VFT:
-			switch (qm->ver) {
-			case QM_HW_V1:
+			if (qm->ver == QM_HW_V1) {
 				tmp = QM_SQC_VFT_BUF_SIZE	|
 				      QM_SQC_VFT_SQC_SIZE	|
 				      QM_SQC_VFT_INDEX_NUMBER	|
 				      QM_SQC_VFT_VALID		|
 				      (u64)base << QM_SQC_VFT_START_SQN_SHIFT;
-				break;
-			case QM_HW_V2:
+			} else {
 				tmp = (u64)base << QM_SQC_VFT_START_SQN_SHIFT |
 				      QM_SQC_VFT_VALID |
 				      (u64)(number - 1) << QM_SQC_VFT_SQN_SHIFT;
-				break;
-			case QM_HW_UNKNOWN:
-				break;
 			}
 			break;
 		case CQC_VFT:
-			switch (qm->ver) {
-			case QM_HW_V1:
+			if (qm->ver == QM_HW_V1) {
 				tmp = QM_CQC_VFT_BUF_SIZE	|
 				      QM_CQC_VFT_SQC_SIZE	|
 				      QM_CQC_VFT_INDEX_NUMBER	|
 				      QM_CQC_VFT_VALID;
-				break;
-			case QM_HW_V2:
+			} else {
 				tmp = QM_CQC_VFT_VALID;
-				break;
-			case QM_HW_UNKNOWN:
-				break;
 			}
 			break;
 		}
@@ -1777,7 +1768,7 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	if (ver == QM_HW_V1) {
 		sqc->dw3 = cpu_to_le32(QM_MK_SQC_DW3_V1(0, 0, 0, qm->sqe_size));
 		sqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
-	} else if (ver == QM_HW_V2) {
+	} else {
 		sqc->dw3 = cpu_to_le32(QM_MK_SQC_DW3_V2(qm->sqe_size));
 		sqc->w8 = 0; /* rand_qc */
 	}
@@ -1804,7 +1795,7 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	if (ver == QM_HW_V1) {
 		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V1(0, 0, 0, 4));
 		cqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
-	} else if (ver == QM_HW_V2) {
+	} else {
 		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(4));
 		cqc->w8 = 0;
 	}
@@ -2020,12 +2011,13 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
 {
 	unsigned int val;
 
-	if (qm->ver == QM_HW_V2) {
-		writel(0x1, qm->io_base + QM_CACHE_WB_START);
-		if (readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
-					       val, val & BIT(0), 10, 1000))
-			dev_err(&qm->pdev->dev, "QM writeback sqc cache fail!\n");
-	}
+	if (qm->ver == QM_HW_V1)
+		return;
+
+	writel(0x1, qm->io_base + QM_CACHE_WB_START);
+	if (readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
+					    val, val & BIT(0), 10, 1000))
+		dev_err(&qm->pdev->dev, "QM writeback sqc cache fail!\n");
 }
 
 static void qm_qp_event_notifier(struct hisi_qp *qp)
@@ -2082,12 +2074,12 @@ static int hisi_qm_uacce_mmap(struct uacce_queue *q,
 
 	switch (qfr->type) {
 	case UACCE_QFRT_MMIO:
-		if (qm->ver == QM_HW_V2) {
-			if (sz > PAGE_SIZE * (QM_DOORBELL_PAGE_NR +
-			    QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE))
+		if (qm->ver == QM_HW_V1) {
+			if (sz > PAGE_SIZE * QM_DOORBELL_PAGE_NR)
 				return -EINVAL;
 		} else {
-			if (sz > PAGE_SIZE * QM_DOORBELL_PAGE_NR)
+			if (sz > PAGE_SIZE * (QM_DOORBELL_PAGE_NR +
+			    QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE))
 				return -EINVAL;
 		}
 
@@ -2342,16 +2334,10 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 
-	switch (qm->ver) {
-	case QM_HW_V1:
+	if (qm->ver == QM_HW_V1)
 		qm->ops = &qm_hw_ops_v1;
-		break;
-	case QM_HW_V2:
+	else
 		qm->ops = &qm_hw_ops_v2;
-		break;
-	default:
-		return;
-	}
 
 	pci_set_drvdata(pdev, qm);
 	mutex_init(&qm->mailbox_lock);
@@ -2860,25 +2846,6 @@ static enum acc_err_result qm_hw_error_handle(struct hisi_qm *qm)
 }
 
 /**
- * hisi_qm_get_hw_version() - Get hardware version of a qm.
- * @pdev: The device which hardware version we want to get.
- *
- * This function gets the hardware version of a qm. Return QM_HW_UNKNOWN
- * if the hardware version is not supported.
- */
-enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev)
-{
-	switch (pdev->revision) {
-	case QM_HW_V1:
-	case QM_HW_V2:
-		return pdev->revision;
-	default:
-		return QM_HW_UNKNOWN;
-	}
-}
-EXPORT_SYMBOL_GPL(hisi_qm_get_hw_version);
-
-/**
  * hisi_qm_dev_err_init() - Initialize device error configuration.
  * @qm: The qm for which we want to do error initialization.
  *
@@ -3846,7 +3813,7 @@ static int qm_irq_register(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
-	if (qm->ver == QM_HW_V2) {
+	if (qm->ver != QM_HW_V1) {
 		ret = request_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR),
 				  qm_aeq_irq, IRQF_SHARED, qm->dev_name, qm);
 		if (ret)
@@ -3942,7 +3909,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 	if (ret)
 		goto err_free_irq_vectors;
 
-	if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2) {
+	if (qm->fun_type == QM_HW_VF && qm->ver != QM_HW_V1) {
 		/* v2 starts to support get vft by mailbox */
 		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
 		if (ret)
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 63267442..0a351de 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -108,6 +108,7 @@ enum qm_hw_ver {
 	QM_HW_UNKNOWN = -1,
 	QM_HW_V1 = 0x20,
 	QM_HW_V2 = 0x21,
+	QM_HW_V3 = 0x30,
 };
 
 enum qm_fun_type {
@@ -287,7 +288,6 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
 					      device, NULL);
 	u32 n, q_num;
-	u8 rev_id;
 	int ret;
 
 	if (!val)
@@ -298,17 +298,10 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 		pr_info("No device found currently, suppose queue number is %d\n",
 			q_num);
 	} else {
-		rev_id = pdev->revision;
-		switch (rev_id) {
-		case QM_HW_V1:
+		if (pdev->revision == QM_HW_V1)
 			q_num = QM_QNUM_V1;
-			break;
-		case QM_HW_V2:
+		else
 			q_num = QM_QNUM_V2;
-			break;
-		default:
-			return -EINVAL;
-		}
 	}
 
 	ret = kstrtou32(val, 10, &n);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 829959b..a4cb58b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -728,18 +728,10 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	struct hisi_qm *qm = &sec->qm;
 	int ret;
 
-	switch (qm->ver) {
-	case QM_HW_V1:
+	if (qm->ver == QM_HW_V1)
 		qm->ctrl_qp_num = SEC_QUEUE_NUM_V1;
-		break;
-
-	case QM_HW_V2:
+	else
 		qm->ctrl_qp_num = SEC_QUEUE_NUM_V2;
-		break;
-
-	default:
-		return -EINVAL;
-	}
 
 	qm->err_ini = &sec_err_ini;
 
@@ -755,15 +747,10 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 
 static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
-	enum qm_hw_ver rev_id;
 	int ret;
 
-	rev_id = hisi_qm_get_hw_version(pdev);
-	if (rev_id == QM_HW_UNKNOWN)
-		return -ENODEV;
-
 	qm->pdev = pdev;
-	qm->ver = rev_id;
+	qm->ver = pdev->revision;
 	qm->sqe_size = SEC_SQE_SIZE;
 	qm->dev_name = sec_name;
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 87db2e1..2229a21 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -719,18 +719,10 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	hisi_zip->ctrl = ctrl;
 	ctrl->hisi_zip = hisi_zip;
 
-	switch (qm->ver) {
-	case QM_HW_V1:
+	if (qm->ver == QM_HW_V1)
 		qm->ctrl_qp_num = HZIP_QUEUE_NUM_V1;
-		break;
-
-	case QM_HW_V2:
+	else
 		qm->ctrl_qp_num = HZIP_QUEUE_NUM_V2;
-		break;
-
-	default:
-		return -EINVAL;
-	}
 
 	qm->err_ini = &hisi_zip_err_ini;
 
@@ -743,14 +735,8 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 
 static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
-	enum qm_hw_ver rev_id;
-
-	rev_id = hisi_qm_get_hw_version(pdev);
-	if (rev_id == QM_HW_UNKNOWN)
-		return -EINVAL;
-
 	qm->pdev = pdev;
-	qm->ver = rev_id;
+	qm->ver = pdev->revision;
 	qm->algs = "zlib\ngzip";
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
-- 
2.7.4

