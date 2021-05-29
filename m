Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1ECC47090
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65FAD6120A
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhE2OUZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 10:20:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2357 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhE2OUX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 10:20:23 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fsk7g3wfNz1BG9f;
        Sat, 29 May 2021 22:14:07 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 22:18:44 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - update reset flow
Date:   Sat, 29 May 2021 22:15:37 +0800
Message-ID: <1622297737-46604-5-git-send-email-qianweili@huawei.com>
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

This patch updates the reset flow based on PF/VF communications. VFs
will be stopped after receiving reset message from PF, and wait for
reset finish to restart VFs.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 279 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 262 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 111142a..13bbb25 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -201,7 +201,10 @@
 #define QM_WAIT_DST_ACK			10
 #define QM_MAX_PF_WAIT_COUNT		10
 #define QM_MAX_VF_WAIT_COUNT		40
-
+#define QM_VF_RESET_WAIT_US            20000
+#define QM_VF_RESET_WAIT_CNT           3000
+#define QM_VF_RESET_WAIT_TIMEOUT_US    \
+	(QM_VF_RESET_WAIT_US * QM_VF_RESET_WAIT_CNT)
 
 #define QM_DFX_MB_CNT_VF		0x104010
 #define QM_DFX_DB_CNT_VF		0x104020
@@ -285,6 +288,16 @@ enum acc_err_result {
 	ACC_ERR_RECOVERED,
 };
 
+enum qm_mb_cmd {
+	QM_PF_FLR_PREPARE = 0x01,
+	QM_PF_SRST_PREPARE,
+	QM_PF_RESET_DONE,
+	QM_VF_PREPARE_DONE,
+	QM_VF_PREPARE_FAIL,
+	QM_VF_START_DONE,
+	QM_VF_START_FAIL,
+};
+
 struct qm_cqe {
 	__le32 rsvd0;
 	__le16 cmd_id;
@@ -1897,9 +1910,74 @@ static void qm_clear_cmd_interrupt(struct hisi_qm *qm, u64 vf_mask)
 	writel(val, qm->io_base + QM_IFC_INT_SOURCE_V);
 }
 
+static void qm_handle_vf_msg(struct hisi_qm *qm, u32 vf_id)
+{
+	struct device *dev = &qm->pdev->dev;
+	u32 cmd;
+	u64 msg;
+	int ret;
+
+	ret = qm_get_mb_cmd(qm, &msg, vf_id);
+	if (ret) {
+		dev_err(dev, "failed to get msg from VF(%u)!\n", vf_id);
+		return;
+	}
+
+	cmd = msg & QM_MB_CMD_DATA_MASK;
+	switch (cmd) {
+	case QM_VF_PREPARE_FAIL:
+		dev_err(dev, "failed to stop VF(%u)!\n", vf_id);
+		break;
+	case QM_VF_START_FAIL:
+		dev_err(dev, "failed to start VF(%u)!\n", vf_id);
+		break;
+	case QM_VF_PREPARE_DONE:
+	case QM_VF_START_DONE:
+		break;
+	default:
+		dev_err(dev, "unsupported cmd %u sent by VF(%u)!\n", cmd, vf_id);
+		break;
+	}
+}
+
 static int qm_wait_vf_prepare_finish(struct hisi_qm *qm)
 {
-	return 0;
+	struct device *dev = &qm->pdev->dev;
+	u32 vfs_num = qm->vfs_num;
+	int cnt = 0;
+	int ret = 0;
+	u64 val;
+	u32 i;
+
+	if (!qm->vfs_num || qm->ver < QM_HW_V3)
+		return 0;
+
+	while (true) {
+		val = readq(qm->io_base + QM_IFC_INT_SOURCE_P);
+		/* All VFs send command to PF, break */
+		if ((val & GENMASK(vfs_num, 1)) == GENMASK(vfs_num, 1))
+			break;
+
+		if (++cnt > QM_MAX_PF_WAIT_COUNT) {
+			ret = -EBUSY;
+			break;
+		}
+
+		msleep(QM_WAIT_DST_ACK);
+	}
+
+	/* PF check VFs msg */
+	for (i = 1; i <= vfs_num; i++) {
+		if (val & BIT(i))
+			qm_handle_vf_msg(qm, i);
+		else
+			dev_err(dev, "VF(%u) not ping PF!\n", i);
+	}
+
+	/* PF clear interrupt to ack VFs */
+	qm_clear_cmd_interrupt(qm, val);
+
+	return ret;
 }
 
 static void qm_trigger_vf_interrupt(struct hisi_qm *qm, u32 fun_num)
@@ -4045,7 +4123,8 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm,
 	return ret;
 }
 
-static int qm_try_stop_vfs(struct hisi_qm *qm, enum qm_stop_reason stop_reason)
+static int qm_try_stop_vfs(struct hisi_qm *qm, u64 cmd,
+			   enum qm_stop_reason stop_reason)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
@@ -4053,9 +4132,16 @@ static int qm_try_stop_vfs(struct hisi_qm *qm, enum qm_stop_reason stop_reason)
 	if (!qm->vfs_num)
 		return 0;
 
-	ret = qm_vf_reset_prepare(qm, stop_reason);
-	if (ret)
-		pci_err(pdev, "failed to prepare reset, ret = %d.\n", ret);
+	/* Kunpeng930 supports to notify VFs to stop before PF reset */
+	if (qm->ops->ping_all_vfs) {
+		ret = qm->ops->ping_all_vfs(qm, cmd);
+		if (ret)
+			pci_err(pdev, "failed to send cmd to all VFs before PF reset!\n");
+	} else {
+		ret = qm_vf_reset_prepare(qm, stop_reason);
+		if (ret)
+			pci_err(pdev, "failed to prepare reset, ret = %d.\n", ret);
+	}
 
 	return ret;
 }
@@ -4079,7 +4165,14 @@ static int qm_reset_prepare_ready(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(pdev));
 
-	return qm_wait_reset_finish(pf_qm);
+	/*
+	 * PF and VF on host doesnot support resetting at the
+	 * same time on Kunpeng920.
+	 */
+	if (qm->ver < QM_HW_V3)
+		return qm_wait_reset_finish(pf_qm);
+
+	return qm_wait_reset_finish(qm);
 }
 
 static void qm_reset_bit_clear(struct hisi_qm *qm)
@@ -4087,7 +4180,10 @@ static void qm_reset_bit_clear(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(pdev));
 
-	clear_bit(QM_RESETTING, &pf_qm->misc_ctl);
+	if (qm->ver < QM_HW_V3)
+		clear_bit(QM_RESETTING, &pf_qm->misc_ctl);
+
+	clear_bit(QM_RESETTING, &qm->misc_ctl);
 }
 
 static int qm_controller_reset_prepare(struct hisi_qm *qm)
@@ -4101,7 +4197,11 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
-	ret = qm_try_stop_vfs(qm, QM_SOFT_RESET);
+	/* PF obtains the information of VF by querying the register. */
+	qm_cmd_uninit(qm);
+
+	/* Whether VFs stop successfully, soft reset will continue. */
+	ret = qm_try_stop_vfs(qm, QM_PF_SRST_PREPARE, QM_SOFT_RESET);
 	if (ret)
 		pci_err(pdev, "failed to stop vfs by pf in soft reset.\n");
 
@@ -4250,7 +4350,7 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 	return ret;
 }
 
-static int qm_try_start_vfs(struct hisi_qm *qm)
+static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_mb_cmd cmd)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
@@ -4264,9 +4364,16 @@ static int qm_try_start_vfs(struct hisi_qm *qm)
 		return ret;
 	}
 
-	ret = qm_vf_reset_done(qm);
-	if (ret)
-		pci_warn(pdev, "failed to start vfs, ret = %d.\n", ret);
+	/* Kunpeng930 supports to notify VFs to start after PF reset. */
+	if (qm->ops->ping_all_vfs) {
+		ret = qm->ops->ping_all_vfs(qm, cmd);
+		if (ret)
+			pci_warn(pdev, "failed to send cmd to all VFs after PF reset!\n");
+	} else {
+		ret = qm_vf_reset_done(qm);
+		if (ret)
+			pci_warn(pdev, "failed to start vfs, ret = %d.\n", ret);
+	}
 
 	return ret;
 }
@@ -4370,7 +4477,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 		return ret;
 	}
 
-	ret = qm_try_start_vfs(qm);
+	ret = qm_try_start_vfs(qm, QM_PF_RESET_DONE);
 	if (ret)
 		pci_err(pdev, "failed to start vfs by pf in soft reset.\n");
 
@@ -4378,6 +4485,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 	if (ret)
 		pci_err(pdev, "failed to start by vfs in soft reset!\n");
 
+	qm_cmd_init(qm);
 	qm_restart_done(qm);
 
 	qm_reset_bit_clear(qm);
@@ -4469,7 +4577,11 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
-	ret = qm_try_stop_vfs(qm, QM_SOFT_RESET);
+	/* PF obtains the information of VF by querying the register. */
+	if (qm->fun_type == QM_HW_PF)
+		qm_cmd_uninit(qm);
+
+	ret = qm_try_stop_vfs(qm, QM_PF_FLR_PREPARE, QM_FLR);
 	if (ret)
 		pci_err(pdev, "failed to stop vfs by pf in FLR.\n");
 
@@ -4524,7 +4636,7 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 		goto flr_done;
 	}
 
-	ret = qm_try_start_vfs(qm);
+	ret = qm_try_start_vfs(qm, QM_PF_RESET_DONE);
 	if (ret)
 		pci_err(pdev, "failed to start vfs by pf in FLR.\n");
 
@@ -4533,6 +4645,9 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 		pci_err(pdev, "failed to start by vfs in FLR!\n");
 
 flr_done:
+	if (qm->fun_type == QM_HW_PF)
+		qm_cmd_init(qm);
+
 	if (qm_flr_reset_complete(pdev))
 		pci_info(pdev, "FLR reset complete\n");
 
@@ -4628,12 +4743,128 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 
 }
 
+static void qm_pf_reset_vf_prepare(struct hisi_qm *qm,
+				   enum qm_stop_reason stop_reason)
+{
+	enum qm_mb_cmd cmd = QM_VF_PREPARE_DONE;
+	struct pci_dev *pdev = qm->pdev;
+	int ret;
+
+	ret = qm_reset_prepare_ready(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "reset prepare not ready!\n");
+		atomic_set(&qm->status.flags, QM_STOP);
+		cmd = QM_VF_PREPARE_FAIL;
+		goto err_prepare;
+	}
+
+	ret = hisi_qm_stop(qm, stop_reason);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to stop QM, ret = %d.\n", ret);
+		atomic_set(&qm->status.flags, QM_STOP);
+		cmd = QM_VF_PREPARE_FAIL;
+		goto err_prepare;
+	}
+
+err_prepare:
+	pci_save_state(pdev);
+	ret = qm->ops->ping_pf(qm, cmd);
+	if (ret)
+		dev_warn(&pdev->dev, "PF responds timeout in reset prepare!\n");
+}
+
+static void qm_pf_reset_vf_done(struct hisi_qm *qm)
+{
+	enum qm_mb_cmd cmd = QM_VF_START_DONE;
+	struct pci_dev *pdev = qm->pdev;
+	int ret;
+
+	pci_restore_state(pdev);
+	ret = hisi_qm_start(qm);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to start QM, ret = %d.\n", ret);
+		cmd = QM_VF_START_FAIL;
+	}
+
+	ret = qm->ops->ping_pf(qm, cmd);
+	if (ret)
+		dev_warn(&pdev->dev, "PF responds timeout in reset done!\n");
+
+	qm_reset_bit_clear(qm);
+}
+
+static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	u32 val, cmd;
+	u64 msg;
+	int ret;
+
+	/* Wait for reset to finish */
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_IFC_INT_SOURCE_V, val,
+					 val == BIT(0), QM_VF_RESET_WAIT_US,
+					 QM_VF_RESET_WAIT_TIMEOUT_US);
+	/* hardware completion status should be available by this time */
+	if (ret) {
+		dev_err(dev, "couldn't get reset done status from PF, timeout!\n");
+		return -ETIMEDOUT;
+	}
+
+	/*
+	 * Whether message is got successfully,
+	 * VF needs to ack PF by clearing the interrupt.
+	 */
+	ret = qm_get_mb_cmd(qm, &msg, 0);
+	qm_clear_cmd_interrupt(qm, 0);
+	if (ret) {
+		dev_err(dev, "failed to get msg from PF in reset done!\n");
+		return ret;
+	}
+
+	cmd = msg & QM_MB_CMD_DATA_MASK;
+	if (cmd != QM_PF_RESET_DONE) {
+		dev_err(dev, "the cmd(%u) is not reset done!\n", cmd);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void qm_pf_reset_vf_process(struct hisi_qm *qm,
+				   enum qm_stop_reason stop_reason)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+
+	dev_info(dev, "device reset start...\n");
+
+	/* The message is obtained by querying the register during resetting */
+	qm_cmd_uninit(qm);
+	qm_pf_reset_vf_prepare(qm, stop_reason);
+
+	ret = qm_wait_pf_reset_finish(qm);
+	if (ret)
+		goto err_get_status;
+
+	qm_pf_reset_vf_done(qm);
+	qm_cmd_init(qm);
+
+	dev_info(dev, "device reset done.\n");
+
+	return;
+
+err_get_status:
+	qm_cmd_init(qm);
+	qm_reset_bit_clear(qm);
+}
+
 static void qm_cmd_process(struct work_struct *cmd_process)
 {
 	struct hisi_qm *qm = container_of(cmd_process,
 					struct hisi_qm, cmd_process);
 	struct device *dev = &qm->pdev->dev;
 	u64 msg;
+	u32 cmd;
 	int ret;
 
 	/*
@@ -4642,9 +4873,23 @@ static void qm_cmd_process(struct work_struct *cmd_process)
 	 */
 	ret = qm_get_mb_cmd(qm, &msg, 0);
 	qm_clear_cmd_interrupt(qm, 0);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "failed to get msg from source!\n");
+		return;
+	}
 
+	cmd = msg & QM_MB_CMD_DATA_MASK;
+	switch (cmd) {
+	case QM_PF_FLR_PREPARE:
+		qm_pf_reset_vf_process(qm, QM_FLR);
+		break;
+	case QM_PF_SRST_PREPARE:
+		qm_pf_reset_vf_process(qm, QM_SOFT_RESET);
+		break;
+	default:
+		dev_err(dev, "unsupported cmd %u sent by PF!\n", cmd);
+		break;
+	}
 }
 
 /**
-- 
2.8.1

