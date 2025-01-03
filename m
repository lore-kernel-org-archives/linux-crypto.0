Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213F61C174A;
	Fri,  3 Jan 2025 10:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735900413; cv=none; b=qWLdjst5vfIeYYKRa+UwAq/oKuKnTM+T+99FwlGCTPAG2KEsXDK/vSloiAJqxHSZY0AFkSPGbf3pIzEWQ1h9StLH6164euNz8kWxJpXIyjGT+04pZ+eV0bMmKhDpvU2Wzt/sqR0tDQm58IG3YdoLawlyBz/ScOoIi17uQH0fUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735900413; c=relaxed/simple;
	bh=3K0FPSJ+SPI07+fnd2R498e2fDCwyqByqiuELnbdaJU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GYK2lO+c/bGu72zWeD/Mlf6qmYWTWUxZDuDD89S+N4PFiyLvSc1VBvXxgh3gHfnPulkSxdzNYyJm3KD5ikNb5dTb1t5fYBJGVvx3ewXZXHS3MR6WgxNEgMPrZlYTI8xuqwD+i1jwYlY69J/XXm4eUdXx/8y7zgPUJgsXD3udGus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YPg0V5wKtz20n8T;
	Fri,  3 Jan 2025 18:33:46 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D3E21A0188;
	Fri,  3 Jan 2025 18:33:25 +0800 (CST)
Received: from localhost.localdomain (10.28.79.22) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 3 Jan 2025 18:33:24 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - support new function communication
Date: Fri, 3 Jan 2025 18:21:38 +0800
Message-ID: <20250103102138.28991-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.22.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemk500010.china.huawei.com (7.202.194.95)

From: Yang Shen <shenyang39@huawei.com>

On the HiSilicon accelerators drivers, the PF/VFs driver can send messages
to the VFs/PF by writing hardware registers, and the VFs/PF driver receives
messages from the PF/VFs by reading hardware registers. To support this
feature, a new version id is added, different communication mechanism are
used based on different version id.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |   1 -
 drivers/crypto/hisilicon/qm.c             | 233 ++++++++++++++++------
 drivers/crypto/hisilicon/sec2/sec_main.c  |   1 -
 drivers/crypto/hisilicon/zip/zip_main.c   |   1 -
 include/linux/hisi_acc_qm.h               |   3 +
 5 files changed, 178 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 5b4c65440d06..f5b47e5ff48a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1209,7 +1209,6 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 
 	qm->mode = uacce_mode;
 	qm->pdev = pdev;
-	qm->ver = pdev->revision;
 	qm->sqe_size = HPRE_SQE_SIZE;
 	qm->dev_name = hpre_name;
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 38193e25b014..d3f5d108b898 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -30,8 +30,6 @@
 
 /* mailbox */
 #define QM_MB_PING_ALL_VFS		0xffff
-#define QM_MB_CMD_DATA_SHIFT		32
-#define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
 #define QM_MB_STATUS_MASK		GENMASK(12, 9)
 
 /* sqc shift */
@@ -102,6 +100,8 @@
 #define QM_PM_CTRL			0x100148
 #define QM_IDLE_DISABLE			BIT(9)
 
+#define QM_SUB_VERSION_ID		0x210
+
 #define QM_VFT_CFG_DATA_L		0x100064
 #define QM_VFT_CFG_DATA_H		0x100068
 #define QM_SQC_VFT_BUF_SIZE		(7ULL << 8)
@@ -177,6 +177,10 @@
 #define QM_IFC_INT_MASK			0x0024
 #define QM_IFC_INT_STATUS		0x0028
 #define QM_IFC_INT_SET_V		0x002C
+#define QM_PF2VF_PF_W			0x104700
+#define QM_VF2PF_PF_R			0x104800
+#define QM_VF2PF_VF_W			0x320
+#define QM_PF2VF_VF_R			0x380
 #define QM_IFC_SEND_ALL_VFS		GENMASK(6, 0)
 #define QM_IFC_INT_SOURCE_CLR		GENMASK(63, 0)
 #define QM_IFC_INT_SOURCE_MASK		BIT(0)
@@ -186,8 +190,11 @@
 #define QM_WAIT_DST_ACK			10
 #define QM_MAX_PF_WAIT_COUNT		10
 #define QM_MAX_VF_WAIT_COUNT		40
-#define QM_VF_RESET_WAIT_US            20000
-#define QM_VF_RESET_WAIT_CNT           3000
+#define QM_VF_RESET_WAIT_US		20000
+#define QM_VF_RESET_WAIT_CNT		3000
+#define QM_VF2PF_REG_SIZE		4
+#define QM_IFC_CMD_MASK			GENMASK(31, 0)
+#define QM_IFC_DATA_SHIFT		32
 #define QM_VF_RESET_WAIT_TIMEOUT_US    \
 	(QM_VF_RESET_WAIT_US * QM_VF_RESET_WAIT_CNT)
 
@@ -275,7 +282,7 @@ enum qm_alg_type {
 	ALG_TYPE_1,
 };
 
-enum qm_mb_cmd {
+enum qm_ifc_cmd {
 	QM_PF_FLR_PREPARE = 0x01,
 	QM_PF_SRST_PREPARE,
 	QM_PF_RESET_DONE,
@@ -396,6 +403,11 @@ struct hisi_qm_hw_ops {
 	void (*hw_error_uninit)(struct hisi_qm *qm);
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
 	int (*set_msi)(struct hisi_qm *qm, bool set);
+
+	/* (u64)msg = (u32)data << 32 | (enum qm_ifc_cmd)cmd */
+	int (*set_ifc_begin)(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data, u32 fun_num);
+	void (*set_ifc_end)(struct hisi_qm *qm);
+	int (*get_ifc)(struct hisi_qm *qm, enum qm_ifc_cmd *cmd, u32 *data, u32 fun_num);
 };
 
 struct hisi_qm_hw_error {
@@ -1543,17 +1555,15 @@ static void qm_clear_cmd_interrupt(struct hisi_qm *qm, u64 vf_mask)
 static void qm_handle_vf_msg(struct hisi_qm *qm, u32 vf_id)
 {
 	struct device *dev = &qm->pdev->dev;
-	u32 cmd;
-	u64 msg;
+	enum qm_ifc_cmd cmd;
 	int ret;
 
-	ret = qm_get_mb_cmd(qm, &msg, vf_id);
+	ret = qm->ops->get_ifc(qm, &cmd, NULL, vf_id);
 	if (ret) {
-		dev_err(dev, "failed to get msg from VF(%u)!\n", vf_id);
+		dev_err(dev, "failed to get command from VF(%u)!\n", vf_id);
 		return;
 	}
 
-	cmd = msg & QM_MB_CMD_DATA_MASK;
 	switch (cmd) {
 	case QM_VF_PREPARE_FAIL:
 		dev_err(dev, "failed to stop VF(%u)!\n", vf_id);
@@ -1565,7 +1575,7 @@ static void qm_handle_vf_msg(struct hisi_qm *qm, u32 vf_id)
 	case QM_VF_START_DONE:
 		break;
 	default:
-		dev_err(dev, "unsupported cmd %u sent by VF(%u)!\n", cmd, vf_id);
+		dev_err(dev, "unsupported command(0x%x) sent by VF(%u)!\n", cmd, vf_id);
 		break;
 	}
 }
@@ -1633,17 +1643,14 @@ static void qm_trigger_pf_interrupt(struct hisi_qm *qm)
 	writel(val, qm->io_base + QM_IFC_INT_SET_V);
 }
 
-static int qm_ping_single_vf(struct hisi_qm *qm, u64 cmd, u32 fun_num)
+static int qm_ping_single_vf(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data, u32 fun_num)
 {
 	struct device *dev = &qm->pdev->dev;
-	struct qm_mailbox mailbox;
 	int cnt = 0;
 	u64 val;
 	int ret;
 
-	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, cmd, fun_num, 0);
-	mutex_lock(&qm->mailbox_lock);
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm->ops->set_ifc_begin(qm, cmd, data, fun_num);
 	if (ret) {
 		dev_err(dev, "failed to send command to vf(%u)!\n", fun_num);
 		goto err_unlock;
@@ -1665,27 +1672,23 @@ static int qm_ping_single_vf(struct hisi_qm *qm, u64 cmd, u32 fun_num)
 	}
 
 err_unlock:
-	mutex_unlock(&qm->mailbox_lock);
+	qm->ops->set_ifc_end(qm);
 	return ret;
 }
 
-static int qm_ping_all_vfs(struct hisi_qm *qm, u64 cmd)
+static int qm_ping_all_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 {
 	struct device *dev = &qm->pdev->dev;
 	u32 vfs_num = qm->vfs_num;
-	struct qm_mailbox mailbox;
 	u64 val = 0;
 	int cnt = 0;
 	int ret;
 	u32 i;
 
-	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, cmd, QM_MB_PING_ALL_VFS, 0);
-	mutex_lock(&qm->mailbox_lock);
-	/* PF sends command to all VFs by mailbox */
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm->ops->set_ifc_begin(qm, cmd, 0, QM_MB_PING_ALL_VFS);
 	if (ret) {
-		dev_err(dev, "failed to send command to VFs!\n");
-		mutex_unlock(&qm->mailbox_lock);
+		dev_err(dev, "failed to send command(0x%x) to all vfs!\n", cmd);
+		qm->ops->set_ifc_end(qm);
 		return ret;
 	}
 
@@ -1695,7 +1698,7 @@ static int qm_ping_all_vfs(struct hisi_qm *qm, u64 cmd)
 		val = readq(qm->io_base + QM_IFC_READY_STATUS);
 		/* If all VFs acked, PF notifies VFs successfully. */
 		if (!(val & GENMASK(vfs_num, 1))) {
-			mutex_unlock(&qm->mailbox_lock);
+			qm->ops->set_ifc_end(qm);
 			return 0;
 		}
 
@@ -1703,7 +1706,7 @@ static int qm_ping_all_vfs(struct hisi_qm *qm, u64 cmd)
 			break;
 	}
 
-	mutex_unlock(&qm->mailbox_lock);
+	qm->ops->set_ifc_end(qm);
 
 	/* Check which vf respond timeout. */
 	for (i = 1; i <= vfs_num; i++) {
@@ -1714,18 +1717,15 @@ static int qm_ping_all_vfs(struct hisi_qm *qm, u64 cmd)
 	return -ETIMEDOUT;
 }
 
-static int qm_ping_pf(struct hisi_qm *qm, u64 cmd)
+static int qm_ping_pf(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 {
-	struct qm_mailbox mailbox;
 	int cnt = 0;
 	u32 val;
 	int ret;
 
-	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, cmd, 0, 0);
-	mutex_lock(&qm->mailbox_lock);
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm->ops->set_ifc_begin(qm, cmd, 0, 0);
 	if (ret) {
-		dev_err(&qm->pdev->dev, "failed to send command to PF!\n");
+		dev_err(&qm->pdev->dev, "failed to send command(0x%x) to PF!\n", cmd);
 		goto unlock;
 	}
 
@@ -1744,7 +1744,8 @@ static int qm_ping_pf(struct hisi_qm *qm, u64 cmd)
 	}
 
 unlock:
-	mutex_unlock(&qm->mailbox_lock);
+	qm->ops->set_ifc_end(qm);
+
 	return ret;
 }
 
@@ -1845,6 +1846,94 @@ static int qm_set_msi_v3(struct hisi_qm *qm, bool set)
 	return ret;
 }
 
+static int qm_set_ifc_begin_v3(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data, u32 fun_num)
+{
+	struct qm_mailbox mailbox;
+	u64 msg;
+
+	msg = cmd | (u64)data << QM_IFC_DATA_SHIFT;
+
+	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, msg, fun_num, 0);
+	mutex_lock(&qm->mailbox_lock);
+	return qm_mb_nolock(qm, &mailbox);
+}
+
+static void qm_set_ifc_end_v3(struct hisi_qm *qm)
+{
+	mutex_unlock(&qm->mailbox_lock);
+}
+
+static int qm_get_ifc_v3(struct hisi_qm *qm, enum qm_ifc_cmd *cmd, u32 *data, u32 fun_num)
+{
+	u64 msg;
+	int ret;
+
+	ret = qm_get_mb_cmd(qm, &msg, fun_num);
+	if (ret)
+		return ret;
+
+	*cmd = msg & QM_IFC_CMD_MASK;
+
+	if (data)
+		*data = msg >> QM_IFC_DATA_SHIFT;
+
+	return 0;
+}
+
+static int qm_set_ifc_begin_v4(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data, u32 fun_num)
+{
+	uintptr_t offset;
+	u64 msg;
+
+	if (qm->fun_type == QM_HW_PF)
+		offset = QM_PF2VF_PF_W;
+	else
+		offset = QM_VF2PF_VF_W;
+
+	msg = cmd | (u64)data << QM_IFC_DATA_SHIFT;
+
+	mutex_lock(&qm->ifc_lock);
+	writeq(msg, qm->io_base + offset);
+
+	return 0;
+}
+
+static void qm_set_ifc_end_v4(struct hisi_qm *qm)
+{
+	mutex_unlock(&qm->ifc_lock);
+}
+
+static u64 qm_get_ifc_pf(struct hisi_qm *qm, u32 fun_num)
+{
+	uintptr_t offset;
+
+	offset = QM_VF2PF_PF_R + QM_VF2PF_REG_SIZE * fun_num;
+
+	return (u64)readl(qm->io_base + offset);
+}
+
+static u64 qm_get_ifc_vf(struct hisi_qm *qm)
+{
+	return readq(qm->io_base + QM_PF2VF_VF_R);
+}
+
+static int qm_get_ifc_v4(struct hisi_qm *qm, enum qm_ifc_cmd *cmd, u32 *data, u32 fun_num)
+{
+	u64 msg;
+
+	if (qm->fun_type == QM_HW_PF)
+		msg = qm_get_ifc_pf(qm, fun_num);
+	else
+		msg = qm_get_ifc_vf(qm);
+
+	*cmd = msg & QM_IFC_CMD_MASK;
+
+	if (data)
+		*data = msg >> QM_IFC_DATA_SHIFT;
+
+	return 0;
+}
+
 static const struct hisi_qm_hw_ops qm_hw_ops_v1 = {
 	.qm_db = qm_db_v1,
 	.hw_error_init = qm_hw_error_init_v1,
@@ -1867,6 +1956,21 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
 	.hw_error_uninit = qm_hw_error_uninit_v3,
 	.hw_error_handle = qm_hw_error_handle_v2,
 	.set_msi = qm_set_msi_v3,
+	.set_ifc_begin = qm_set_ifc_begin_v3,
+	.set_ifc_end = qm_set_ifc_end_v3,
+	.get_ifc = qm_get_ifc_v3,
+};
+
+static const struct hisi_qm_hw_ops qm_hw_ops_v4 = {
+	.get_vft = qm_get_vft_v2,
+	.qm_db = qm_db_v2,
+	.hw_error_init = qm_hw_error_init_v3,
+	.hw_error_uninit = qm_hw_error_uninit_v3,
+	.hw_error_handle = qm_hw_error_handle_v2,
+	.set_msi = qm_set_msi_v3,
+	.set_ifc_begin = qm_set_ifc_begin_v4,
+	.set_ifc_end = qm_set_ifc_end_v4,
+	.get_ifc = qm_get_ifc_v4,
 };
 
 static void *qm_get_avail_sqe(struct hisi_qp *qp)
@@ -2845,11 +2949,14 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 		qm->ops = &qm_hw_ops_v1;
 	else if (qm->ver == QM_HW_V2)
 		qm->ops = &qm_hw_ops_v2;
-	else
+	else if (qm->ver == QM_HW_V3)
 		qm->ops = &qm_hw_ops_v3;
+	else
+		qm->ops = &qm_hw_ops_v4;
 
 	pci_set_drvdata(pdev, qm);
 	mutex_init(&qm->mailbox_lock);
+	mutex_init(&qm->ifc_lock);
 	init_rwsem(&qm->qps_lock);
 	qm->qp_in_used = 0;
 	if (test_bit(QM_SUPPORT_RPM, &qm->caps)) {
@@ -3609,7 +3716,6 @@ static u32 qm_get_shaper_vft_qos(struct hisi_qm *qm, u32 fun_index)
 static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
 {
 	struct device *dev = &qm->pdev->dev;
-	u64 mb_cmd;
 	u32 qos;
 	int ret;
 
@@ -3619,10 +3725,9 @@ static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
 		return;
 	}
 
-	mb_cmd = QM_PF_SET_QOS | (u64)qos << QM_MB_CMD_DATA_SHIFT;
-	ret = qm_ping_single_vf(qm, mb_cmd, fun_num);
+	ret = qm_ping_single_vf(qm, QM_PF_SET_QOS, qos, fun_num);
 	if (ret)
-		dev_err(dev, "failed to send cmd to VF(%u)!\n", fun_num);
+		dev_err(dev, "failed to send command(0x%x) to VF(%u)!\n", QM_PF_SET_QOS, fun_num);
 }
 
 static int qm_vf_read_qos(struct hisi_qm *qm)
@@ -4111,7 +4216,7 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm,
 	return ret;
 }
 
-static int qm_try_stop_vfs(struct hisi_qm *qm, u64 cmd,
+static int qm_try_stop_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd,
 			   enum qm_stop_reason stop_reason)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -4124,7 +4229,7 @@ static int qm_try_stop_vfs(struct hisi_qm *qm, u64 cmd,
 	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
 		ret = qm_ping_all_vfs(qm, cmd);
 		if (ret)
-			pci_err(pdev, "failed to send cmd to all VFs before PF reset!\n");
+			pci_err(pdev, "failed to send command to all VFs before PF reset!\n");
 	} else {
 		ret = qm_vf_reset_prepare(qm, stop_reason);
 		if (ret)
@@ -4306,7 +4411,7 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 	return ret;
 }
 
-static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_mb_cmd cmd)
+static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
@@ -4683,7 +4788,7 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 static void qm_pf_reset_vf_prepare(struct hisi_qm *qm,
 				   enum qm_stop_reason stop_reason)
 {
-	enum qm_mb_cmd cmd = QM_VF_PREPARE_DONE;
+	enum qm_ifc_cmd cmd = QM_VF_PREPARE_DONE;
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
 
@@ -4717,7 +4822,7 @@ static void qm_pf_reset_vf_prepare(struct hisi_qm *qm,
 
 static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 {
-	enum qm_mb_cmd cmd = QM_VF_START_DONE;
+	enum qm_ifc_cmd cmd = QM_VF_START_DONE;
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
 
@@ -4740,7 +4845,6 @@ static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 	u32 val, cmd;
-	u64 msg;
 	int ret;
 
 	/* Wait for reset to finish */
@@ -4757,16 +4861,15 @@ static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
 	 * Whether message is got successfully,
 	 * VF needs to ack PF by clearing the interrupt.
 	 */
-	ret = qm_get_mb_cmd(qm, &msg, 0);
+	ret = qm->ops->get_ifc(qm, &cmd, NULL, 0);
 	qm_clear_cmd_interrupt(qm, 0);
 	if (ret) {
-		dev_err(dev, "failed to get msg from PF in reset done!\n");
+		dev_err(dev, "failed to get command from PF in reset done!\n");
 		return ret;
 	}
 
-	cmd = msg & QM_MB_CMD_DATA_MASK;
 	if (cmd != QM_PF_RESET_DONE) {
-		dev_err(dev, "the cmd(%u) is not reset done!\n", cmd);
+		dev_err(dev, "the command(0x%x) is not reset done!\n", cmd);
 		ret = -EINVAL;
 	}
 
@@ -4803,22 +4906,21 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 {
 	struct device *dev = &qm->pdev->dev;
-	u64 msg;
-	u32 cmd;
+	enum qm_ifc_cmd cmd;
+	u32 data;
 	int ret;
 
 	/*
 	 * Get the msg from source by sending mailbox. Whether message is got
 	 * successfully, destination needs to ack source by clearing the interrupt.
 	 */
-	ret = qm_get_mb_cmd(qm, &msg, fun_num);
+	ret = qm->ops->get_ifc(qm, &cmd, &data, fun_num);
 	qm_clear_cmd_interrupt(qm, BIT(fun_num));
 	if (ret) {
-		dev_err(dev, "failed to get msg from source!\n");
+		dev_err(dev, "failed to get command from source!\n");
 		return;
 	}
 
-	cmd = msg & QM_MB_CMD_DATA_MASK;
 	switch (cmd) {
 	case QM_PF_FLR_PREPARE:
 		qm_pf_reset_vf_process(qm, QM_DOWN);
@@ -4830,10 +4932,10 @@ static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 		qm_vf_get_qos(qm, fun_num);
 		break;
 	case QM_PF_SET_QOS:
-		qm->mb_qos = msg >> QM_MB_CMD_DATA_SHIFT;
+		qm->mb_qos = data;
 		break;
 	default:
-		dev_err(dev, "unsupported cmd %u sent by function(%u)!\n", cmd, fun_num);
+		dev_err(dev, "unsupported command(0x%x) sent by function(%u)!\n", cmd, fun_num);
 		break;
 	}
 }
@@ -5175,6 +5277,20 @@ static int qm_get_hw_caps(struct hisi_qm *qm)
 	return qm_pre_store_caps(qm);
 }
 
+static void qm_get_version(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	u32 sub_version_id;
+
+	qm->ver = pdev->revision;
+
+	if (pdev->revision == QM_HW_V3) {
+		sub_version_id = readl(qm->io_base + QM_SUB_VERSION_ID);
+		if (sub_version_id)
+			qm->ver = sub_version_id;
+	}
+}
+
 static int qm_get_pci_res(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -5194,6 +5310,8 @@ static int qm_get_pci_res(struct hisi_qm *qm)
 		goto err_request_mem_regions;
 	}
 
+	qm_get_version(qm);
+
 	ret = qm_get_hw_caps(qm);
 	if (ret)
 		goto err_ioremap;
@@ -5213,6 +5331,7 @@ static int qm_get_pci_res(struct hisi_qm *qm)
 		qm->db_interval = 0;
 	}
 
+	hisi_qm_pre_init(qm);
 	ret = qm_get_qp_num(qm);
 	if (ret)
 		goto err_db_ioremap;
@@ -5477,8 +5596,6 @@ int hisi_qm_init(struct hisi_qm *qm)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	hisi_qm_pre_init(qm);
-
 	ret = hisi_qm_pci_init(qm);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index d71594588b85..72cf48d1f3ab 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1192,7 +1192,6 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	int ret;
 
 	qm->pdev = pdev;
-	qm->ver = pdev->revision;
 	qm->mode = uacce_mode;
 	qm->sqe_size = SEC_SQE_SIZE;
 	qm->dev_name = sec_name;
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index cb17d6cbf6ff..d8ba23b7cc7d 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1296,7 +1296,6 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	int ret;
 
 	qm->pdev = pdev;
-	qm->ver = pdev->revision;
 	qm->mode = uacce_mode;
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index c1dafbabbd6b..99fcf65d575f 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -124,6 +124,7 @@ enum qm_hw_ver {
 	QM_HW_V1 = 0x20,
 	QM_HW_V2 = 0x21,
 	QM_HW_V3 = 0x30,
+	QM_HW_V4 = 0x50,
 };
 
 enum qm_fun_type {
@@ -397,6 +398,8 @@ struct hisi_qm {
 
 	struct mutex mailbox_lock;
 
+	struct mutex ifc_lock;
+
 	const struct hisi_qm_hw_ops *ops;
 
 	struct qm_debug debug;
-- 
2.33.0

