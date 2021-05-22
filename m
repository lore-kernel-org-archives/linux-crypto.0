Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78EDC2B9F2
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 06:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978A061244
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 06:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhEVGxs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 May 2021 02:53:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3651 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhEVGxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 May 2021 02:53:46 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FnDcT75JvzmXNH;
        Sat, 22 May 2021 14:50:01 +0800 (CST)
Received: from dggeme768-chm.china.huawei.com (10.3.19.114) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 14:52:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 14:52:19 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - add MSI detection steps on Kunpeng930
Date:   Sat, 22 May 2021 14:49:21 +0800
Message-ID: <1621666161-51143-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Compared with Kunpeng920, Kunpeng930 adds MSI configuration steps to wait
for the interrupt to be emptied. In order to be compatible with the
kunpeng920 driver, 'set_msi' callback is added in 'hisi_qm_hw_ops' to
configure hardware register. Call 'set_msi' to disable or enable MSI
during reset.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 124 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 100 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8f7ea50..c67cb51 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -161,6 +161,9 @@
 #define QM_PEH_VENDOR_ID		0x1000d8
 #define ACC_VENDOR_ID_VALUE		0x5a5a
 #define QM_PEH_DFX_INFO0		0x1000fc
+#define QM_PEH_DFX_INFO1		0x100100
+#define QM_PEH_DFX_MASK			(BIT(0) | BIT(2))
+#define QM_PEH_MSI_FINISH_MASK		GENMASK(19, 16)
 #define ACC_PEH_SRIOV_CTRL_VF_MSE_SHIFT	3
 #define ACC_PEH_MSI_DISABLE		GENMASK(31, 0)
 #define ACC_MASTER_GLOBAL_CTRL_SHUTDOWN	0x1
@@ -171,6 +174,7 @@
 #define QM_RAS_NFE_MBIT_DISABLE		~QM_ECC_MBIT
 #define ACC_AM_ROB_ECC_INT_STS		0x300104
 #define ACC_ROB_ECC_ERR_MULTPL		BIT(1)
+#define QM_MSI_CAP_ENABLE		BIT(16)
 
 #define QM_DFX_MB_CNT_VF		0x104010
 #define QM_DFX_DB_CNT_VF		0x104020
@@ -352,6 +356,7 @@ struct hisi_qm_hw_ops {
 	void (*hw_error_uninit)(struct hisi_qm *qm);
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
 	int (*stop_qp)(struct hisi_qp *qp);
+	int (*set_msi)(struct hisi_qm *qm, bool set);
 };
 
 struct qm_dfx_item {
@@ -1776,10 +1781,98 @@ static int qm_stop_qp(struct hisi_qp *qp)
 	return qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
 }
 
+static int qm_set_msi(struct hisi_qm *qm, bool set)
+{
+	struct pci_dev *pdev = qm->pdev;
+
+	if (set) {
+		pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_MASK_64,
+				       0);
+	} else {
+		pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_MASK_64,
+				       ACC_PEH_MSI_DISABLE);
+		if (qm->err_status.is_qm_ecc_mbit ||
+		    qm->err_status.is_dev_ecc_mbit)
+			return 0;
+
+		mdelay(1);
+		if (readl(qm->io_base + QM_PEH_DFX_INFO0))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static void qm_wait_msi_finish(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	u32 cmd = ~0;
+	int cnt = 0;
+	u32 val;
+	int ret;
+
+	while (true) {
+		pci_read_config_dword(pdev, pdev->msi_cap +
+				      PCI_MSI_PENDING_64, &cmd);
+		if (!cmd)
+			break;
+
+		if (++cnt > MAX_WAIT_COUNTS) {
+			pci_warn(pdev, "failed to empty MSI PENDING!\n");
+			break;
+		}
+
+		udelay(1);
+	}
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_PEH_DFX_INFO0,
+					 val, !(val & QM_PEH_DFX_MASK),
+					 POLL_PERIOD, POLL_TIMEOUT);
+	if (ret)
+		pci_warn(pdev, "failed to empty PEH MSI!\n");
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_PEH_DFX_INFO1,
+					 val, !(val & QM_PEH_MSI_FINISH_MASK),
+					 POLL_PERIOD, POLL_TIMEOUT);
+	if (ret)
+		pci_warn(pdev, "failed to finish MSI operation!\n");
+}
+
+static int qm_set_msi_v3(struct hisi_qm *qm, bool set)
+{
+	struct pci_dev *pdev = qm->pdev;
+	int ret = -ETIMEDOUT;
+	u32 cmd, i;
+
+	pci_read_config_dword(pdev, pdev->msi_cap, &cmd);
+	if (set)
+		cmd |= QM_MSI_CAP_ENABLE;
+	else
+		cmd &= ~QM_MSI_CAP_ENABLE;
+
+	pci_write_config_dword(pdev, pdev->msi_cap, cmd);
+	if (set) {
+		for (i = 0; i < MAX_WAIT_COUNTS; i++) {
+			pci_read_config_dword(pdev, pdev->msi_cap, &cmd);
+			if (cmd & QM_MSI_CAP_ENABLE)
+				return 0;
+
+			udelay(1);
+		}
+	} else {
+		udelay(WAIT_PERIOD_US_MIN);
+		qm_wait_msi_finish(qm);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static const struct hisi_qm_hw_ops qm_hw_ops_v1 = {
 	.qm_db = qm_db_v1,
 	.get_irq_num = qm_get_irq_num_v1,
 	.hw_error_init = qm_hw_error_init_v1,
+	.set_msi = qm_set_msi,
 };
 
 static const struct hisi_qm_hw_ops qm_hw_ops_v2 = {
@@ -1789,6 +1882,7 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v2 = {
 	.hw_error_init = qm_hw_error_init_v2,
 	.hw_error_uninit = qm_hw_error_uninit_v2,
 	.hw_error_handle = qm_hw_error_handle_v2,
+	.set_msi = qm_set_msi,
 };
 
 static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
@@ -1799,6 +1893,7 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
 	.hw_error_uninit = qm_hw_error_uninit_v3,
 	.hw_error_handle = qm_hw_error_handle_v2,
 	.stop_qp = qm_stop_qp,
+	.set_msi = qm_set_msi_v3,
 };
 
 static void *qm_get_avail_sqe(struct hisi_qp *qp)
@@ -3586,6 +3681,9 @@ static int qm_check_req_recv(struct hisi_qm *qm)
 	int ret;
 	u32 val;
 
+	if (qm->ver >= QM_HW_V3)
+		return 0;
+
 	writel(ACC_VENDOR_ID_VALUE, qm->io_base + QM_PEH_VENDOR_ID);
 	ret = readl_relaxed_poll_timeout(qm->io_base + QM_PEH_VENDOR_ID, val,
 					 (val == ACC_VENDOR_ID_VALUE),
@@ -3656,28 +3754,6 @@ static int qm_set_vf_mse(struct hisi_qm *qm, bool set)
 	return -ETIMEDOUT;
 }
 
-static int qm_set_msi(struct hisi_qm *qm, bool set)
-{
-	struct pci_dev *pdev = qm->pdev;
-
-	if (set) {
-		pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_MASK_64,
-				       0);
-	} else {
-		pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_MASK_64,
-				       ACC_PEH_MSI_DISABLE);
-		if (qm->err_status.is_qm_ecc_mbit ||
-		    qm->err_status.is_dev_ecc_mbit)
-			return 0;
-
-		mdelay(1);
-		if (readl(qm->io_base + QM_PEH_DFX_INFO0))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
 static int qm_vf_reset_prepare(struct hisi_qm *qm,
 			       enum qm_stop_reason stop_reason)
 {
@@ -3800,7 +3876,7 @@ static int qm_soft_reset(struct hisi_qm *qm)
 		}
 	}
 
-	ret = qm_set_msi(qm, false);
+	ret = qm->ops->set_msi(qm, false);
 	if (ret) {
 		pci_err(pdev, "Fails to disable PEH MSI bit.\n");
 		return ret;
@@ -3941,7 +4017,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
 
-	ret = qm_set_msi(qm, true);
+	ret = qm->ops->set_msi(qm, true);
 	if (ret) {
 		pci_err(pdev, "Fails to enable PEH MSI bit!\n");
 		return ret;
-- 
2.8.1

