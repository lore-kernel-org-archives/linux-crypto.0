Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CCAC47254
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08ECA214D8
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgEIJpd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 05:45:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728206AbgEIJpd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 05:45:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5B13076F1C539BCEBC77;
        Sat,  9 May 2020 17:45:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:45:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 10/12] crypto: hisilicon - remove codes of directly report device errors through MSI
Date:   Sat, 9 May 2020 17:44:03 +0800
Message-ID: <1589017445-15514-11-git-send-email-tanshukun1@huawei.com>
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

The hardware device can be configured to report directly through MSI, but
this method will not go through RAS, configure all hardware errors that
should be processed by driver to NFE.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  1 -
 drivers/crypto/hisilicon/qm.c             | 54 +++++++------------------------
 drivers/crypto/hisilicon/qm.h             |  4 +--
 drivers/crypto/hisilicon/sec2/sec_main.c  |  1 -
 drivers/crypto/hisilicon/zip/zip_main.c   |  1 -
 5 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 93df31a..5eedd3c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -730,7 +730,6 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 		.ce			= QM_BASE_CE,
 		.nfe			= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT,
 		.fe			= 0,
-		.msi			= QM_DB_RANDOM_INVALID,
 		.ecc_2bits_mask		= HPRE_CORE_ECC_2BIT_ERR |
 					  HPRE_OOO_ECC_2BIT_ERR,
 		.msi_wr_port		= HPRE_WR_MSI_PORT,
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e988124..80935d6 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -313,8 +313,7 @@ struct hisi_qm_hw_ops {
 		      u8 cmd, u16 index, u8 priority);
 	u32 (*get_irq_num)(struct hisi_qm *qm);
 	int (*debug_init)(struct hisi_qm *qm);
-	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
-			      u32 msi);
+	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe);
 	void (*hw_error_uninit)(struct hisi_qm *qm);
 	pci_ers_result_t (*hw_error_handle)(struct hisi_qm *qm);
 };
@@ -707,26 +706,6 @@ static irqreturn_t qm_aeq_irq(int irq, void *data)
 
 static irqreturn_t qm_abnormal_irq(int irq, void *data)
 {
-	const struct hisi_qm_hw_error *err = qm_hw_error;
-	struct hisi_qm *qm = data;
-	struct device *dev = &qm->pdev->dev;
-	u32 error_status, tmp;
-
-	/* read err sts */
-	tmp = readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
-	error_status = qm->msi_mask & tmp;
-
-	while (err->msg) {
-		if (err->int_msk & error_status)
-			dev_err(dev, "%s [error status=0x%x] found\n",
-				err->msg, err->int_msk);
-
-		err++;
-	}
-
-	/* clear err sts */
-	writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
-
 	return IRQ_HANDLED;
 }
 
@@ -1116,28 +1095,21 @@ static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
 	return 0;
 }
 
-static void qm_hw_error_init_v1(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
-				u32 msi)
+static void qm_hw_error_init_v1(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe)
 {
 	writel(QM_ABNORMAL_INT_MASK_VALUE, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
-static void qm_hw_error_init_v2(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
-				u32 msi)
+static void qm_hw_error_init_v2(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe)
 {
-	u32 irq_enable = ce | nfe | fe | msi;
+	u32 irq_enable = ce | nfe | fe;
 	u32 irq_unmask = ~irq_enable;
-	u32 error_status;
 
 	qm->error_mask = ce | nfe | fe;
-	qm->msi_mask = msi;
 
 	/* clear QM hw residual error source */
-	error_status = readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
-	if (error_status) {
-		error_status &= qm->error_mask;
-		writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
-	}
+	writel(QM_ABNORMAL_INT_SOURCE_CLR,
+	       qm->io_base + QM_ABNORMAL_INT_SOURCE);
 
 	/* configure error type */
 	writel(ce, qm->io_base + QM_RAS_CE_ENABLE);
@@ -1145,9 +1117,6 @@ static void qm_hw_error_init_v2(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 	writel(nfe, qm->io_base + QM_RAS_NFE_ENABLE);
 	writel(fe, qm->io_base + QM_RAS_FE_ENABLE);
 
-	/* use RAS irq default, so only set QM_RAS_MSI_INT_SEL for MSI */
-	writel(msi, qm->io_base + QM_RAS_MSI_INT_SEL);
-
 	irq_unmask &= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
 	writel(irq_unmask, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
@@ -1207,9 +1176,11 @@ static pci_ers_result_t qm_hw_error_handle_v2(struct hisi_qm *qm)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
-
-		/* clear err sts */
-		writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+		if (error_status == QM_DB_RANDOM_INVALID) {
+			writel(error_status, qm->io_base +
+			       QM_ABNORMAL_INT_SOURCE);
+			return PCI_ERS_RESULT_RECOVERED;
+		}
 
 		return PCI_ERS_RESULT_NEED_RESET;
 	}
@@ -2476,8 +2447,7 @@ static void qm_hw_error_init(struct hisi_qm *qm)
 		return;
 	}
 
-	qm->ops->hw_error_init(qm, err_info->ce, err_info->nfe,
-			       err_info->fe, err_info->msi);
+	qm->ops->hw_error_init(qm, err_info->ce, err_info->nfe, err_info->fe);
 }
 
 static void qm_hw_error_uninit(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 80b9746..fc5e96a 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -74,7 +74,7 @@
 
 #define QM_BASE_NFE	(QM_AXI_RRESP | QM_AXI_BRESP | QM_ECC_MBIT | \
 			 QM_ACC_GET_TASK_TIMEOUT | QM_DB_TIMEOUT | \
-			 QM_OF_FIFO_OF)
+			 QM_OF_FIFO_OF | QM_DB_RANDOM_INVALID)
 #define QM_BASE_CE			QM_ECC_1BIT
 
 #define QM_Q_DEPTH			1024
@@ -158,7 +158,6 @@ struct hisi_qm_err_info {
 	u32 ce;
 	u32 nfe;
 	u32 fe;
-	u32 msi;
 };
 
 struct hisi_qm_err_status {
@@ -224,7 +223,6 @@ struct hisi_qm {
 	struct qm_debug debug;
 
 	u32 error_mask;
-	u32 msi_mask;
 
 	struct workqueue_struct *wq;
 	struct work_struct work;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 703b8b1..28c73bb 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -682,7 +682,6 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 		.nfe			= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT |
 					  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe			= 0,
-		.msi			= QM_DB_RANDOM_INVALID,
 		.ecc_2bits_mask		= SEC_CORE_INT_STATUS_M_ECC,
 		.msi_wr_port		= BIT(0),
 		.acpi_rst		= "SRST",
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 1a5a6e3..226d398 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -643,7 +643,6 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 		.nfe			= QM_BASE_NFE |
 					  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe			= 0,
-		.msi			= QM_DB_RANDOM_INVALID,
 		.ecc_2bits_mask		= HZIP_CORE_INT_STATUS_M_ECC,
 		.msi_wr_port		= HZIP_WR_PORT,
 		.acpi_rst		= "ZRST",
-- 
2.7.4

