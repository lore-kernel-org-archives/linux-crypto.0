Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4F5C28CBC
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67397214D8
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgEIJpc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 05:45:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58146 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728182AbgEIJpb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 05:45:31 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 66D73129F6F098DB95AB;
        Sat,  9 May 2020 17:45:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:45:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 11/12] crypto: hisilicon - add device error report through abnormal irq
Date:   Sat, 9 May 2020 17:44:04 +0800
Message-ID: <1589017445-15514-12-git-send-email-tanshukun1@huawei.com>
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

By configuring the device error in firmware to report through abnormal
interruption, process all NFE errors in irq handler.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 339 +++++++++++++++++++++++-------------------
 drivers/crypto/hisilicon/qm.h |   1 +
 2 files changed, 187 insertions(+), 153 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 80935d6..6365f93 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -219,6 +219,12 @@ enum vft_type {
 	CQC_VFT,
 };
 
+enum acc_err_result {
+	ACC_ERR_NONE,
+	ACC_ERR_NEED_RESET,
+	ACC_ERR_RECOVERED,
+};
+
 struct qm_cqe {
 	__le32 rsvd0;
 	__le16 cmd_id;
@@ -315,7 +321,7 @@ struct hisi_qm_hw_ops {
 	int (*debug_init)(struct hisi_qm *qm);
 	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe);
 	void (*hw_error_uninit)(struct hisi_qm *qm);
-	pci_ers_result_t (*hw_error_handle)(struct hisi_qm *qm);
+	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
 };
 
 static const char * const qm_debug_file_name[] = {
@@ -704,46 +710,6 @@ static irqreturn_t qm_aeq_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t qm_abnormal_irq(int irq, void *data)
-{
-	return IRQ_HANDLED;
-}
-
-static int qm_irq_register(struct hisi_qm *qm)
-{
-	struct pci_dev *pdev = qm->pdev;
-	int ret;
-
-	ret = request_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR),
-			  qm_irq, IRQF_SHARED, qm->dev_name, qm);
-	if (ret)
-		return ret;
-
-	if (qm->ver == QM_HW_V2) {
-		ret = request_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR),
-				  qm_aeq_irq, IRQF_SHARED, qm->dev_name, qm);
-		if (ret)
-			goto err_aeq_irq;
-
-		if (qm->fun_type == QM_HW_PF) {
-			ret = request_irq(pci_irq_vector(pdev,
-					  QM_ABNORMAL_EVENT_IRQ_VECTOR),
-					  qm_abnormal_irq, IRQF_SHARED,
-					  qm->dev_name, qm);
-			if (ret)
-				goto err_abonormal_irq;
-		}
-	}
-
-	return 0;
-
-err_abonormal_irq:
-	free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
-err_aeq_irq:
-	free_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR), qm);
-	return ret;
-}
-
 static void qm_irq_unregister(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -1163,7 +1129,7 @@ static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 	}
 }
 
-static pci_ers_result_t qm_hw_error_handle_v2(struct hisi_qm *qm)
+static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 {
 	u32 error_status, tmp;
 
@@ -1179,13 +1145,13 @@ static pci_ers_result_t qm_hw_error_handle_v2(struct hisi_qm *qm)
 		if (error_status == QM_DB_RANDOM_INVALID) {
 			writel(error_status, qm->io_base +
 			       QM_ABNORMAL_INT_SOURCE);
-			return PCI_ERS_RESULT_RECOVERED;
+			return ACC_ERR_RECOVERED;
 		}
 
-		return PCI_ERS_RESULT_NEED_RESET;
+		return ACC_ERR_NEED_RESET;
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return ACC_ERR_RECOVERED;
 }
 
 static const struct hisi_qm_hw_ops qm_hw_ops_v1 = {
@@ -1943,100 +1909,6 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 }
 
 /**
- * hisi_qm_init() - Initialize configures about qm.
- * @qm: The qm needing init.
- *
- * This function init qm, then we can call hisi_qm_start to put qm into work.
- */
-int hisi_qm_init(struct hisi_qm *qm)
-{
-	struct pci_dev *pdev = qm->pdev;
-	struct device *dev = &pdev->dev;
-	unsigned int num_vec;
-	int ret;
-
-	hisi_qm_pre_init(qm);
-
-	ret = qm_alloc_uacce(qm);
-	if (ret < 0)
-		dev_warn(&pdev->dev, "fail to alloc uacce (%d)\n", ret);
-
-	ret = pci_enable_device_mem(pdev);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to enable device mem!\n");
-		goto err_remove_uacce;
-	}
-
-	ret = pci_request_mem_regions(pdev, qm->dev_name);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to request mem regions!\n");
-		goto err_disable_pcidev;
-	}
-
-	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
-	qm->phys_size = pci_resource_len(qm->pdev, PCI_BAR_2);
-	qm->io_base = ioremap(qm->phys_base, qm->phys_size);
-	if (!qm->io_base) {
-		ret = -EIO;
-		goto err_release_mem_regions;
-	}
-
-	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (ret < 0)
-		goto err_iounmap;
-	pci_set_master(pdev);
-
-	if (!qm->ops->get_irq_num) {
-		ret = -EOPNOTSUPP;
-		goto err_iounmap;
-	}
-	num_vec = qm->ops->get_irq_num(qm);
-	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
-	if (ret < 0) {
-		dev_err(dev, "Failed to enable MSI vectors!\n");
-		goto err_iounmap;
-	}
-
-	ret = qm_irq_register(qm);
-	if (ret)
-		goto err_free_irq_vectors;
-
-	if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2) {
-		/* v2 starts to support get vft by mailbox */
-		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
-		if (ret)
-			goto err_irq_unregister;
-	}
-
-	ret = hisi_qm_memory_init(qm);
-	if (ret)
-		goto err_irq_unregister;
-
-	INIT_WORK(&qm->work, qm_work_process);
-
-	atomic_set(&qm->status.flags, QM_INIT);
-
-	return 0;
-
-err_irq_unregister:
-	qm_irq_unregister(qm);
-err_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
-err_iounmap:
-	iounmap(qm->io_base);
-err_release_mem_regions:
-	pci_release_mem_regions(pdev);
-err_disable_pcidev:
-	pci_disable_device(pdev);
-err_remove_uacce:
-	uacce_remove(qm->uacce);
-	qm->uacce = NULL;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(hisi_qm_init);
-
-/**
  * hisi_qm_uninit() - Uninitialize qm.
  * @qm: The qm needed uninit.
  *
@@ -2460,11 +2332,11 @@ static void qm_hw_error_uninit(struct hisi_qm *qm)
 	qm->ops->hw_error_uninit(qm);
 }
 
-static pci_ers_result_t qm_hw_error_handle(struct hisi_qm *qm)
+static enum acc_err_result qm_hw_error_handle(struct hisi_qm *qm)
 {
 	if (!qm->ops->hw_error_handle) {
 		dev_err(&qm->pdev->dev, "QM doesn't support hw error report!\n");
-		return PCI_ERS_RESULT_NONE;
+		return ACC_ERR_NONE;
 	}
 
 	return qm->ops->hw_error_handle(qm);
@@ -2777,13 +2649,13 @@ int hisi_qm_sriov_configure(struct pci_dev *pdev, int num_vfs)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_configure);
 
-static pci_ers_result_t qm_dev_err_handle(struct hisi_qm *qm)
+static enum acc_err_result qm_dev_err_handle(struct hisi_qm *qm)
 {
 	u32 err_sts;
 
 	if (!qm->err_ini->get_dev_hw_err_status) {
 		dev_err(&qm->pdev->dev, "Device doesn't support get hw error status!\n");
-		return PCI_ERS_RESULT_NONE;
+		return ACC_ERR_NONE;
 	}
 
 	/* get device hardware error status */
@@ -2794,20 +2666,19 @@ static pci_ers_result_t qm_dev_err_handle(struct hisi_qm *qm)
 
 		if (!qm->err_ini->log_dev_hw_err) {
 			dev_err(&qm->pdev->dev, "Device doesn't support log hw error!\n");
-			return PCI_ERS_RESULT_NEED_RESET;
+			return ACC_ERR_NEED_RESET;
 		}
 
 		qm->err_ini->log_dev_hw_err(qm, err_sts);
-		return PCI_ERS_RESULT_NEED_RESET;
+		return ACC_ERR_NEED_RESET;
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return ACC_ERR_RECOVERED;
 }
 
-static pci_ers_result_t qm_process_dev_error(struct pci_dev *pdev)
+static enum acc_err_result qm_process_dev_error(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = pci_get_drvdata(pdev);
-	pci_ers_result_t qm_ret, dev_ret;
+	enum acc_err_result qm_ret, dev_ret;
 
 	/* log qm error */
 	qm_ret = qm_hw_error_handle(qm);
@@ -2815,9 +2686,9 @@ static pci_ers_result_t qm_process_dev_error(struct pci_dev *pdev)
 	/* log device error */
 	dev_ret = qm_dev_err_handle(qm);
 
-	return (qm_ret == PCI_ERS_RESULT_NEED_RESET ||
-		dev_ret == PCI_ERS_RESULT_NEED_RESET) ?
-		PCI_ERS_RESULT_NEED_RESET : PCI_ERS_RESULT_RECOVERED;
+	return (qm_ret == ACC_ERR_NEED_RESET ||
+		dev_ret == ACC_ERR_NEED_RESET) ?
+		ACC_ERR_NEED_RESET : ACC_ERR_RECOVERED;
 }
 
 /**
@@ -2831,6 +2702,9 @@ static pci_ers_result_t qm_process_dev_error(struct pci_dev *pdev)
 pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
 					  pci_channel_state_t state)
 {
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
+	enum acc_err_result ret;
+
 	if (pdev->is_virtfn)
 		return PCI_ERS_RESULT_NONE;
 
@@ -2838,7 +2712,11 @@ pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	return qm_process_dev_error(pdev);
+	ret = qm_process_dev_error(qm);
+	if (ret == ACC_ERR_NEED_RESET)
+		return PCI_ERS_RESULT_NEED_RESET;
+
+	return PCI_ERS_RESULT_RECOVERED;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_err_detected);
 
@@ -3428,6 +3306,161 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_done);
 
+static irqreturn_t qm_abnormal_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = data;
+	enum acc_err_result ret;
+
+	ret = qm_process_dev_error(qm);
+	if (ret == ACC_ERR_NEED_RESET)
+		schedule_work(&qm->rst_work);
+
+	return IRQ_HANDLED;
+}
+
+static int qm_irq_register(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	int ret;
+
+	ret = request_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR),
+			  qm_irq, IRQF_SHARED, qm->dev_name, qm);
+	if (ret)
+		return ret;
+
+	if (qm->ver == QM_HW_V2) {
+		ret = request_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR),
+				  qm_aeq_irq, IRQF_SHARED, qm->dev_name, qm);
+		if (ret)
+			goto err_aeq_irq;
+
+		if (qm->fun_type == QM_HW_PF) {
+			ret = request_irq(pci_irq_vector(pdev,
+					  QM_ABNORMAL_EVENT_IRQ_VECTOR),
+					  qm_abnormal_irq, IRQF_SHARED,
+					  qm->dev_name, qm);
+			if (ret)
+				goto err_abonormal_irq;
+		}
+	}
+
+	return 0;
+
+err_abonormal_irq:
+	free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
+err_aeq_irq:
+	free_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR), qm);
+	return ret;
+}
+
+static void hisi_qm_controller_reset(struct work_struct *rst_work)
+{
+	struct hisi_qm *qm = container_of(rst_work, struct hisi_qm, rst_work);
+	int ret;
+
+	/* reset pcie device controller */
+	ret = qm_controller_reset(qm);
+	if (ret)
+		dev_err(&qm->pdev->dev, "controller reset failed (%d)\n", ret);
+
+}
+
+/**
+ * hisi_qm_init() - Initialize configures about qm.
+ * @qm: The qm needing init.
+ *
+ * This function init qm, then we can call hisi_qm_start to put qm into work.
+ */
+int hisi_qm_init(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct device *dev = &pdev->dev;
+	unsigned int num_vec;
+	int ret;
+
+	hisi_qm_pre_init(qm);
+
+	ret = qm_alloc_uacce(qm);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "fail to alloc uacce (%d)\n", ret);
+
+	ret = pci_enable_device_mem(pdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to enable device mem!\n");
+		goto err_remove_uacce;
+	}
+
+	ret = pci_request_mem_regions(pdev, qm->dev_name);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request mem regions!\n");
+		goto err_disable_pcidev;
+	}
+
+	qm->phys_base = pci_resource_start(pdev, PCI_BAR_2);
+	qm->phys_size = pci_resource_len(qm->pdev, PCI_BAR_2);
+	qm->io_base = ioremap(qm->phys_base, qm->phys_size);
+	if (!qm->io_base) {
+		ret = -EIO;
+		goto err_release_mem_regions;
+	}
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (ret < 0)
+		goto err_iounmap;
+	pci_set_master(pdev);
+
+	if (!qm->ops->get_irq_num) {
+		ret = -EOPNOTSUPP;
+		goto err_iounmap;
+	}
+	num_vec = qm->ops->get_irq_num(qm);
+	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSI);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable MSI vectors!\n");
+		goto err_iounmap;
+	}
+
+	ret = qm_irq_register(qm);
+	if (ret)
+		goto err_free_irq_vectors;
+
+	if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2) {
+		/* v2 starts to support get vft by mailbox */
+		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+		if (ret)
+			goto err_irq_unregister;
+	}
+
+	ret = hisi_qm_memory_init(qm);
+	if (ret)
+		goto err_irq_unregister;
+
+	INIT_WORK(&qm->work, qm_work_process);
+	if (qm->fun_type == QM_HW_PF)
+		INIT_WORK(&qm->rst_work, hisi_qm_controller_reset);
+
+	atomic_set(&qm->status.flags, QM_INIT);
+
+	return 0;
+
+err_irq_unregister:
+	qm_irq_unregister(qm);
+err_free_irq_vectors:
+	pci_free_irq_vectors(pdev);
+err_iounmap:
+	iounmap(qm->io_base);
+err_release_mem_regions:
+	pci_release_mem_regions(pdev);
+err_disable_pcidev:
+	pci_disable_device(pdev);
+err_remove_uacce:
+	uacce_remove(qm->uacce);
+	qm->uacce = NULL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_init);
+
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
 MODULE_DESCRIPTION("HiSilicon Accelerator queue manager driver");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index fc5e96a..a431ff2 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -226,6 +226,7 @@ struct hisi_qm {
 
 	struct workqueue_struct *wq;
 	struct work_struct work;
+	struct work_struct rst_work;
 
 	const char *algs;
 	bool use_sva;
-- 
2.7.4

