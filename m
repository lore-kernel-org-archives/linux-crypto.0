Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F74E2BEFED;
	Mon, 18 May 2026 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114692; cv=none; b=EkVsJJwXVuxkiEQMd1W671zqP1/8EDOjGdblNs8hroDuEGrJ8tRFxQ8INEqWBsbk0yZFoFlSHNHinjRW3nJF/hgD+FIiqQ3PexsZ3BdKZWID2UiPhpw+jBS3MEU7nLAX8aw+Qsg4STnmRQ9puUbMoS30P5txgaoIOnJsk8J7lXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114692; c=relaxed/simple;
	bh=uVf9zRL9PyqxuBQA6mnbmZZrpKdygjMALPP7Y70YadQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/FvcX9pPQR7fHSFAjkAiwgg0HxwXEhkeAPtX6XB7DXhYC8q1vkuiFvXN2wl19OMQBbAjPs2+cfrxvgXiYA6jWckZPUIxrJnfVX2awCkIBlUnLUrYFpiEzIT/9oeqTYQX/FooxVAmAc6Vuryn2YMvlgfhzsQxOQlwJkQqELrXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QdFgl+NQ; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QdFgl+NQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nWnSzZFmk/tgwu3p4Z/clwa5y6lnFaYzZKwBB8r5jyg=;
	b=QdFgl+NQsGNoz5wUJjk235ncgSdSvuQ5PKeWNcx7apiqtEzn0yX7zpfqPLwE6cHUv3UqZhJNz
	NB1eAJaF3jom993bou7+3MwBhBGphb3AMAHjc12RzShwqIDTS68wt8l8KrjtNftTedjOr6TP3Lb
	iz/jtemMmsjoyfdcJAIBg0o=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gK0R13RcTzLlSx;
	Mon, 18 May 2026 22:23:41 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 560EB4056E;
	Mon, 18 May 2026 22:31:21 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:20 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 1/6] crypto: hisilicon/qm - allow VF devices to query hardware isolation status
Date: Mon, 18 May 2026 22:29:51 +0800
Message-ID: <20260518142956.3593934-2-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260518142956.3593934-1-wuzongyu1@huawei.com>
References: <20260518142956.3593934-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Zhushuai Yin <yinzhushuai@huawei.com>

The problem that the VF device cannot obtain the isolation
status and isolation threshold of the device is resolved.

The accelerator driver can query the device isolation status
and threshold via the VF device using the fault query sysfs
interface under uacce. Note that only the PF device supports
isolation policy configuration, while the VF device is
limited to read-only query operations.

Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  10 +-
 drivers/crypto/hisilicon/qm.c             | 128 ++++++++++++++++++++--
 drivers/crypto/hisilicon/sec2/sec_main.c  |  10 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  10 +-
 include/linux/hisi_acc_qm.h               |   1 +
 5 files changed, 129 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 357ab5e5887e..a484381f522a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1631,12 +1631,10 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_qm_del_list;
 	}
 
-	if (qm->uacce) {
-		ret = uacce_register(qm->uacce);
-		if (ret) {
-			pci_err(pdev, "failed to register uacce (%d)!\n", ret);
-			goto err_with_alg_register;
-		}
+	ret = hisi_qm_register_uacce(qm);
+	if (ret) {
+		pci_err(pdev, "failed to register uacce (%d)!\n", ret);
+		goto err_with_alg_register;
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num) {
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 3ca47e2a9719..9cf52873a891 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -246,6 +246,10 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
 
+/* qm isolation state mask */
+#define QM_ISOLATED_STATE		BIT(31)
+#define QM_ISOLATED_THRESHOLD_MASK	GENMASK(15, 0)
+
  /* abnormal status value for stopping queue */
 #define QM_STOP_QUEUE_FAIL		1
 #define	QM_DUMP_SQC_FAIL		3
@@ -286,6 +290,20 @@ enum qm_alg_type {
 	ALG_TYPE_1,
 };
 
+/*
+ * Message format for QM_VF_GET_ISOLATE and QM_PF_SET_ISOLATE commands
+ *
+ * These commands use a 32-bit command field (cmd) and 32-bit data field (data)
+ *
+ * Command behavior:
+ * - QM_VF_GET_ISOLATE: VF requests isolation status and threshold
+ * - QM_PF_SET_ISOLATE: PF sets isolation status and threshold
+ *
+ * Data field bit layout:
+ * - bit31 (MSB): Isolation status flag (1 = isolated, 0 = non-isolated)
+ * - bit15-0 (16 LSB): Isolation threshold value
+ * - bit30-16 (15 bits): Reserved
+ */
 enum qm_ifc_cmd {
 	QM_PF_FLR_PREPARE = 0x01,
 	QM_PF_SRST_PREPARE,
@@ -296,6 +314,8 @@ enum qm_ifc_cmd {
 	QM_VF_START_FAIL,
 	QM_PF_SET_QOS,
 	QM_VF_GET_QOS,
+	QM_VF_GET_ISOLATE,
+	QM_PF_SET_ISOLATE,
 };
 
 enum qm_basic_type {
@@ -1734,7 +1754,7 @@ static int qm_ping_single_vf(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data,
 	return ret;
 }
 
-static int qm_ping_all_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
+static int qm_ping_all_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data)
 {
 	struct device *dev = &qm->pdev->dev;
 	u32 vfs_num = qm->vfs_num;
@@ -1743,7 +1763,7 @@ static int qm_ping_all_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 	int ret;
 	u32 i;
 
-	ret = qm->ops->set_ifc_begin(qm, cmd, 0, QM_MB_PING_ALL_VFS);
+	ret = qm->ops->set_ifc_begin(qm, cmd, data, QM_MB_PING_ALL_VFS);
 	if (ret) {
 		dev_err(dev, "failed to send command(0x%x) to all vfs!\n", cmd);
 		qm->ops->set_ifc_end(qm);
@@ -2779,6 +2799,7 @@ static enum uacce_dev_state hisi_qm_get_isolate_state(struct uacce_device *uacce
 static int hisi_qm_isolate_threshold_write(struct uacce_device *uacce, u32 num)
 {
 	struct hisi_qm *qm = uacce->priv;
+	int ret;
 
 	/* Must be set by PF */
 	if (uacce->is_vf)
@@ -2792,6 +2813,18 @@ static int hisi_qm_isolate_threshold_write(struct uacce_device *uacce, u32 num)
 
 	/* After the policy is updated, need to reset the hardware err list */
 	qm_hw_err_destroy(qm);
+
+	if (!qm->vfs_num) {
+		mutex_unlock(&qm->isolate_data.isolate_lock);
+		return 0;
+	}
+
+	/* Notify all VFs to update the isolation threshold. */
+	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
+		ret = qm_ping_all_vfs(qm, QM_PF_SET_ISOLATE, qm->isolate_data.err_threshold);
+		if (ret)
+			dev_err(&qm->pdev->dev, "failed to send command to all VFs set isolate!\n");
+	}
 	mutex_unlock(&qm->isolate_data.isolate_lock);
 
 	return 0;
@@ -2802,7 +2835,7 @@ static u32 hisi_qm_isolate_threshold_read(struct uacce_device *uacce)
 	struct hisi_qm *qm = uacce->priv;
 	struct hisi_qm *pf_qm;
 
-	if (uacce->is_vf) {
+	if (uacce->is_vf && !test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
 		pf_qm = pci_get_drvdata(pci_physfn(qm->pdev));
 		return pf_qm->isolate_data.err_threshold;
 	}
@@ -2889,7 +2922,10 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		return -EINVAL;
 	}
 
-	uacce->is_vf = pdev->is_virtfn;
+	if (qm->fun_type == QM_HW_PF)
+		uacce->is_vf = false;
+	else
+		uacce->is_vf = true;
 	uacce->priv = qm;
 
 	if (qm->ver == QM_HW_V1)
@@ -2918,6 +2954,25 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	return 0;
 }
 
+int hisi_qm_register_uacce(struct hisi_qm *qm)
+{
+	int ret;
+
+	if (!qm->uacce)
+		return 0;
+
+	dev_info(&qm->pdev->dev, "qm register to uacce\n");
+
+	if (qm->fun_type == QM_HW_VF && test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
+		ret = qm_ping_pf(qm, QM_VF_GET_ISOLATE);
+		if (ret)
+			dev_err(&qm->pdev->dev, "failed to send cmd to PF to get isolate!\n");
+	}
+
+	return uacce_register(qm->uacce);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_register_uacce);
+
 /**
  * qm_frozen() - Try to froze QM to cut continuous queue request. If
  * there is user on the QM, return failure without doing anything.
@@ -4484,7 +4539,7 @@ static int qm_try_stop_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd,
 
 	/* Kunpeng930 supports to notify VFs to stop before PF reset */
 	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
-		ret = qm_ping_all_vfs(qm, cmd);
+		ret = qm_ping_all_vfs(qm, cmd, 0);
 		if (ret)
 			pci_err(pdev, "failed to send command to all VFs before PF reset!\n");
 	} else {
@@ -4671,6 +4726,7 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 {
 	struct pci_dev *pdev = qm->pdev;
+	u32 data;
 	int ret;
 
 	if (!qm->vfs_num)
@@ -4684,7 +4740,11 @@ static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_ifc_cmd cmd)
 
 	/* Kunpeng930 supports to notify VFs to start after PF reset. */
 	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
-		ret = qm_ping_all_vfs(qm, cmd);
+		data = qm->isolate_data.err_threshold;
+		if (qm->isolate_data.is_isolate)
+			data |= QM_ISOLATED_STATE;
+		/* Broadcasting isolate info via RAS to all VFs. */
+		ret = qm_ping_all_vfs(qm, cmd, data);
 		if (ret)
 			pci_warn(pdev, "failed to send cmd to all VFs after PF reset!\n");
 	} else {
@@ -5131,10 +5191,22 @@ static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 	qm_reset_bit_clear(qm);
 }
 
-static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
+static void qm_vf_update_isolate_info(struct hisi_qm *qm, u32 data)
+{
+	/* Updating the local isolation status. */
+	mutex_lock(&qm->isolate_data.isolate_lock);
+	if (data & QM_ISOLATED_STATE)
+		qm->isolate_data.is_isolate = true;
+	else
+		qm->isolate_data.is_isolate = false;
+	qm->isolate_data.err_threshold = data & QM_ISOLATED_THRESHOLD_MASK;
+	mutex_unlock(&qm->isolate_data.isolate_lock);
+}
+
+static int qm_wait_pf_reset_finish(struct hisi_qm *qm, enum qm_stop_reason stop_reason)
 {
 	struct device *dev = &qm->pdev->dev;
-	u32 val, cmd;
+	u32 val, cmd, data;
 	int ret;
 
 	/* Wait for reset to finish */
@@ -5151,7 +5223,7 @@ static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
 	 * Whether message is got successfully,
 	 * VF needs to ack PF by clearing the interrupt.
 	 */
-	ret = qm->ops->get_ifc(qm, &cmd, NULL, 0);
+	ret = qm->ops->get_ifc(qm, &cmd, &data, 0);
 	qm_clear_cmd_interrupt(qm, 0);
 	if (ret) {
 		dev_err(dev, "failed to get command from PF in reset done!\n");
@@ -5160,10 +5232,14 @@ static int qm_wait_pf_reset_finish(struct hisi_qm *qm)
 
 	if (cmd != QM_PF_RESET_DONE) {
 		dev_err(dev, "the command(0x%x) is not reset done!\n", cmd);
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
-	return ret;
+	/* The VF processes the device isolation information received from the RAS reset. */
+	if (stop_reason == QM_SOFT_RESET)
+		qm_vf_update_isolate_info(qm, data);
+
+	return 0;
 }
 
 static void qm_pf_reset_vf_process(struct hisi_qm *qm,
@@ -5178,7 +5254,7 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 	qm_cmd_uninit(qm);
 	qm_pf_reset_vf_prepare(qm, stop_reason);
 
-	ret = qm_wait_pf_reset_finish(qm);
+	ret = qm_wait_pf_reset_finish(qm, stop_reason);
 	if (ret)
 		goto err_get_status;
 
@@ -5189,10 +5265,31 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 	return;
 
 err_get_status:
+	if (stop_reason == QM_SOFT_RESET) {
+		/* Update local isolation status on PF-VF reset failure. */
+		mutex_lock(&qm->isolate_data.isolate_lock);
+		qm->isolate_data.is_isolate = true;
+		mutex_unlock(&qm->isolate_data.isolate_lock);
+	}
 	qm_cmd_init(qm);
 	qm_reset_bit_clear(qm);
 }
 
+static void qm_vf_get_isolate_data(struct hisi_qm *qm, u32 fun_num)
+{
+	u32 data = qm->isolate_data.err_threshold;
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+
+	if (qm->isolate_data.is_isolate)
+		data |= QM_ISOLATED_STATE;
+
+	ret = qm_ping_single_vf(qm, QM_PF_SET_ISOLATE, data, fun_num);
+	if (ret)
+		dev_err(dev, "failed to send command(0x%x) to VF(%u)!\n",
+			(unsigned int)QM_PF_SET_ISOLATE, fun_num);
+}
+
 static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -5224,6 +5321,13 @@ static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 	case QM_PF_SET_QOS:
 		qm->mb_qos = data;
 		break;
+	case QM_VF_GET_ISOLATE:
+		/* Read the isolation policy of the PF during VF initialization. */
+		qm_vf_get_isolate_data(qm, fun_num);
+		break;
+	case QM_PF_SET_ISOLATE:
+		qm_vf_update_isolate_info(qm, data);
+		break;
 	default:
 		dev_err(dev, "unsupported command(0x%x) sent by function(%u)!\n", cmd, fun_num);
 		break;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 056bd8f4da5a..e8bea1e496f7 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1449,12 +1449,10 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_qm_del_list;
 	}
 
-	if (qm->uacce) {
-		ret = uacce_register(qm->uacce);
-		if (ret) {
-			pci_err(pdev, "failed to register uacce (%d)!\n", ret);
-			goto err_alg_unregister;
-		}
+	ret = hisi_qm_register_uacce(qm);
+	if (ret) {
+		pci_err(pdev, "failed to register uacce (%d)!\n", ret);
+		goto err_alg_unregister;
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num) {
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 44df9c859bd8..5135b3028cb2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1559,12 +1559,10 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_qm_del_list;
 	}
 
-	if (qm->uacce) {
-		ret = uacce_register(qm->uacce);
-		if (ret) {
-			pci_err(pdev, "failed to register uacce (%d)!\n", ret);
-			goto err_qm_alg_unregister;
-		}
+	ret = hisi_qm_register_uacce(qm);
+	if (ret) {
+		pci_err(pdev, "failed to register uacce (%d)!\n", ret);
+		goto err_qm_alg_unregister;
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index a6268dc4f7cb..ddecdc2531a2 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -552,6 +552,7 @@ static inline void hisi_qm_del_list(struct hisi_qm *qm, struct hisi_qm_list *qm_
 	mutex_unlock(&qm_list->lock);
 }
 
+int hisi_qm_register_uacce(struct hisi_qm *qm);
 int hisi_qm_q_num_set(const char *val, const struct kernel_param *kp,
 		      unsigned int device);
 int hisi_qm_init(struct hisi_qm *qm);
-- 
2.33.0

