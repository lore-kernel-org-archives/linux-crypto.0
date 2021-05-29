Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECF1C4708F
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3954D6120A
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhE2OUY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 10:20:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2541 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhE2OUX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 10:20:23 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fsk9t0BTgzYrTJ;
        Sat, 29 May 2021 22:16:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 22:18:43 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - enable PF and VFs communication
Date:   Sat, 29 May 2021 22:15:35 +0800
Message-ID: <1622297737-46604-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
References: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 hardware supports the communication between PF and VFs.

This patch enables communication between PF and VFs by writing hardware
registers, and requests an irq for communication.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 113 +++++++++++++++++++++++++++++++++++++++---
 drivers/crypto/hisilicon/qm.h |   1 +
 2 files changed, 106 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9071dac..a7c16c5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -25,9 +25,11 @@
 #define QM_IRQ_NUM_V1			1
 #define QM_IRQ_NUM_PF_V2		4
 #define QM_IRQ_NUM_VF_V2		2
+#define QM_IRQ_NUM_VF_V3		3
 
 #define QM_EQ_EVENT_IRQ_VECTOR		0
 #define QM_AEQ_EVENT_IRQ_VECTOR		1
+#define QM_CMD_EVENT_IRQ_VECTOR		2
 #define QM_ABNORMAL_EVENT_IRQ_VECTOR	3
 
 /* mailbox */
@@ -177,6 +179,16 @@
 #define ACC_ROB_ECC_ERR_MULTPL		BIT(1)
 #define QM_MSI_CAP_ENABLE		BIT(16)
 
+/* interfunction communication */
+#define QM_IFC_INT_SOURCE_P		0x100138
+#define QM_IFC_INT_SOURCE_V		0x0020
+#define QM_IFC_INT_MASK			0x0024
+#define QM_IFC_INT_STATUS		0x0028
+#define QM_IFC_INT_SOURCE_CLR		GENMASK(63, 0)
+#define QM_IFC_INT_SOURCE_MASK		BIT(0)
+#define QM_IFC_INT_DISABLE		BIT(0)
+#define QM_IFC_INT_STATUS_MASK		BIT(0)
+
 #define QM_DFX_MB_CNT_VF		0x104010
 #define QM_DFX_DB_CNT_VF		0x104020
 #define QM_DFX_SQE_CNT_VF_SQN		0x104030
@@ -633,6 +645,14 @@ static u32 qm_get_irq_num_v2(struct hisi_qm *qm)
 		return QM_IRQ_NUM_VF_V2;
 }
 
+static u32 qm_get_irq_num_v3(struct hisi_qm *qm)
+{
+	if (qm->fun_type == QM_HW_PF)
+		return QM_IRQ_NUM_PF_V2;
+
+	return QM_IRQ_NUM_VF_V3;
+}
+
 static struct hisi_qp *qm_to_hisi_qp(struct hisi_qm *qm, struct qm_eqe *eqe)
 {
 	u16 cqn = le32_to_cpu(eqe->dw0) & QM_EQE_CQN_MASK;
@@ -737,6 +757,21 @@ static irqreturn_t qm_irq(int irq, void *data)
 	return IRQ_NONE;
 }
 
+static irqreturn_t qm_mb_cmd_irq(int irq, void *data)
+{
+	struct hisi_qm *qm = data;
+	u32 val;
+
+	val = readl(qm->io_base + QM_IFC_INT_STATUS);
+	val &= QM_IFC_INT_STATUS_MASK;
+	if (!val)
+		return IRQ_NONE;
+
+	schedule_work(&qm->cmd_process);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t qm_aeq_irq(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
@@ -777,14 +812,16 @@ static void qm_irq_unregister(struct hisi_qm *qm)
 
 	free_irq(pci_irq_vector(pdev, QM_EQ_EVENT_IRQ_VECTOR), qm);
 
-	if (qm->ver == QM_HW_V1)
-		return;
+	if (qm->ver > QM_HW_V1) {
+		free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
 
-	free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
+		if (qm->fun_type == QM_HW_PF)
+			free_irq(pci_irq_vector(pdev,
+				 QM_ABNORMAL_EVENT_IRQ_VECTOR), qm);
+	}
 
-	if (qm->fun_type == QM_HW_PF)
-		free_irq(pci_irq_vector(pdev,
-			 QM_ABNORMAL_EVENT_IRQ_VECTOR), qm);
+	if (qm->ver > QM_HW_V2)
+		free_irq(pci_irq_vector(pdev, QM_CMD_EVENT_IRQ_VECTOR), qm);
 }
 
 static void qm_init_qp_status(struct hisi_qp *qp)
@@ -1803,6 +1840,18 @@ static int qm_check_dev_error(struct hisi_qm *qm)
 	       (dev_val & (~qm->err_info.dev_ce_mask));
 }
 
+static void qm_clear_cmd_interrupt(struct hisi_qm *qm, u64 vf_mask)
+{
+	u32 val;
+
+	if (qm->fun_type == QM_HW_PF)
+		writeq(vf_mask, qm->io_base + QM_IFC_INT_SOURCE_P);
+
+	val = readl(qm->io_base + QM_IFC_INT_SOURCE_V);
+	val |= QM_IFC_INT_SOURCE_MASK;
+	writel(val, qm->io_base + QM_IFC_INT_SOURCE_V);
+}
+
 static int qm_wait_vf_prepare_finish(struct hisi_qm *qm)
 {
 	return 0;
@@ -1920,7 +1969,7 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v2 = {
 static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
 	.get_vft = qm_get_vft_v2,
 	.qm_db = qm_db_v2,
-	.get_irq_num = qm_get_irq_num_v2,
+	.get_irq_num = qm_get_irq_num_v3,
 	.hw_error_init = qm_hw_error_init_v3,
 	.hw_error_uninit = qm_hw_error_uninit_v3,
 	.hw_error_handle = qm_hw_error_handle_v2,
@@ -2784,6 +2833,34 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	qm->misc_ctl = false;
 }
 
+static void qm_cmd_uninit(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	val = readl(qm->io_base + QM_IFC_INT_MASK);
+	val |= QM_IFC_INT_DISABLE;
+	writel(val, qm->io_base + QM_IFC_INT_MASK);
+}
+
+static void qm_cmd_init(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	/* Clear communication interrupt source */
+	qm_clear_cmd_interrupt(qm, QM_IFC_INT_SOURCE_CLR);
+
+	/* Enable pf to vf communication reg. */
+	val = readl(qm->io_base + QM_IFC_INT_MASK);
+	val &= ~QM_IFC_INT_DISABLE;
+	writel(val, qm->io_base + QM_IFC_INT_MASK);
+}
+
 static void qm_put_pci_res(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -2815,6 +2892,7 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 
+	qm_cmd_uninit(qm);
 	down_write(&qm->qps_lock);
 
 	if (!qm_avail_state(qm, QM_CLOSE)) {
@@ -4338,7 +4416,7 @@ static int qm_irq_register(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
-	if (qm->ver != QM_HW_V1) {
+	if (qm->ver > QM_HW_V1) {
 		ret = request_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR),
 				  qm_aeq_irq, 0, qm->dev_name, qm);
 		if (ret)
@@ -4353,8 +4431,18 @@ static int qm_irq_register(struct hisi_qm *qm)
 		}
 	}
 
+	if (qm->ver > QM_HW_V2) {
+		ret = request_irq(pci_irq_vector(pdev, QM_CMD_EVENT_IRQ_VECTOR),
+				qm_mb_cmd_irq, 0, qm->dev_name, qm);
+		if (ret)
+			goto err_mb_cmd_irq;
+	}
+
 	return 0;
 
+err_mb_cmd_irq:
+	if (qm->fun_type == QM_HW_PF)
+		free_irq(pci_irq_vector(pdev, QM_ABNORMAL_EVENT_IRQ_VECTOR), qm);
 err_abonormal_irq:
 	free_irq(pci_irq_vector(pdev, QM_AEQ_EVENT_IRQ_VECTOR), qm);
 err_aeq_irq:
@@ -4391,6 +4479,11 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 
 }
 
+static void qm_cmd_process(struct work_struct *cmd_process)
+{
+	/* handling messages sent by communication source */
+}
+
 /**
  * hisi_qm_alg_register() - Register alg to crypto and add qm to qm_list.
  * @qm: The qm needs add.
@@ -4622,6 +4715,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 	if (qm->fun_type == QM_HW_PF)
 		INIT_WORK(&qm->rst_work, hisi_qm_controller_reset);
 
+	if (qm->ver >= QM_HW_V3)
+		INIT_WORK(&qm->cmd_process, qm_cmd_process);
+
+	qm_cmd_init(qm);
 	atomic_set(&qm->status.flags, QM_INIT);
 
 	return 0;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 9048aa6..8a36bad 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -250,6 +250,7 @@ struct hisi_qm {
 	struct workqueue_struct *wq;
 	struct work_struct work;
 	struct work_struct rst_work;
+	struct work_struct cmd_process;
 
 	const char *algs;
 	bool use_sva;
-- 
2.8.1

