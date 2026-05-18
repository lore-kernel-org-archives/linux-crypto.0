Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312F148850;
	Mon, 18 May 2026 14:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114696; cv=none; b=sjjL9538/dDTGvr17tFJxp2ESYKS/B6tAM17tHUP5/A3NbYympWWAXLzRxycx3n+InY1+gpuZwRosY+N/YwtlElCijr3MkzO/3rJK7Jh5QyZiqDvOaac6esgBHKr/UodV8KGUEgrpgVZhD7AAse8zWv2M5EykTYORhrs2vCx8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114696; c=relaxed/simple;
	bh=7Pk2kKCbAyrSAGwW9L4BK00mzLlCcRLJGL9zoKiZ09A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYNm7Ynyopaic+3x9TACqmytGrrccmOFWENsaht1lMTluxmiIMw3a2L21N9V9nXd0kEDfTLz7oBcPG042/jMATBuVdLJt01XNmJ2mSOrgvBbt9wPg9Sova8/Cu8urZRU95JNfIHw2Zlh6R2nA6SnVKV1TXE5v/zOZpxmAXleSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ugdd9tRy; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ugdd9tRy"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AQWPcoigOyBlMWDfxXrZOeubu2WvVChyktZ3ib0FRkg=;
	b=ugdd9tRyco6POoTTdriMu1KHdwdW1G/C+Hez9qm4pGGQIsM3WYg+r/71z0yN76sUg5XyjVf1c
	1fvGwXXRqWuGUmBKBZzic6vnSkL10LjdndU22PqJ9n8WGOLfjGhLJaz98BKVtVYnn4/W5R3r/rj
	u6ARZwy7lvdzpapa3bJ4SUM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gK0R20dHGzRhV2;
	Mon, 18 May 2026 22:23:42 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 0523C4056D;
	Mon, 18 May 2026 22:31:22 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:21 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 3/6] crypto: hisilicon/qm - support function-level error reset
Date: Mon, 18 May 2026 22:29:53 +0800
Message-ID: <20260518142956.3593934-4-wuzongyu1@huawei.com>
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

When executing operations on crypto devices, hardware errors
are inevitable. For certain errors, a full device reset is
required to recover. However, in certain cases, only a
specific function may fail, while other functions can still
operate normally. A system-wide RAS reset in such cases would
unnecessarily impact functioning components.

This patch introduces function-level granularity handling,
enabling targeted resets of only the error-reporting
functions without affecting other operational functions.

Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 90 +++++++++++++++++++++++++++++++----
 include/linux/hisi_acc_qm.h   |  1 +
 2 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 71af462daf5b..2b3132595e42 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -246,6 +246,11 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
 
+/* qm function err mask */
+#define QM_FUNC_AXI_ERR_ST0		0x100280
+#define QM_RAS_FUNC_ERROR		(BIT(0) | BIT(1))
+#define QM_FUNC_RAS_CLEAR_ALL		GENMASK(63, 0)
+
 /* qm isolation state mask */
 #define QM_ISOLATED_STATE		BIT(31)
 #define QM_ISOLATED_THRESHOLD_MASK	GENMASK(15, 0)
@@ -314,6 +319,7 @@ enum qm_ifc_cmd {
 	QM_VF_START_FAIL,
 	QM_PF_SET_QOS,
 	QM_VF_GET_QOS,
+	QM_FUNCTION_RESET,
 	QM_VF_GET_ISOLATE,
 	QM_PF_SET_ISOLATE,
 };
@@ -493,6 +499,7 @@ static struct qm_typical_qos_table shaper_cbs_s[] = {
 static void qm_irqs_unregister(struct hisi_qm *qm);
 static int qm_reset_device(struct hisi_qm *qm);
 static void hisi_qm_stop_qp(struct hisi_qp *qp);
+static int qm_restart(struct hisi_qm *qm);
 
 int hisi_qm_q_num_set(const char *val, const struct kernel_param *kp,
 		      unsigned int device)
@@ -1171,18 +1178,20 @@ static void qm_reset_function(struct hisi_qm *qm)
 		return;
 	}
 
+	dev_info(dev, "function reset start...\n");
 	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret) {
 		dev_err(dev, "failed to stop qm when reset function\n");
 		goto clear_bit;
 	}
 
-	ret = hisi_qm_start(qm);
+	ret = qm_restart(qm);
 	if (ret)
 		dev_err(dev, "failed to start qm when reset function\n");
 
 clear_bit:
 	qm_reset_bit_clear(qm);
+	dev_info(dev, "function reset end...\n");
 }
 
 static irqreturn_t qm_aeq_thread(int irq, void *data)
@@ -1505,6 +1514,8 @@ static void qm_hw_error_cfg(struct hisi_qm *qm)
 	qm->error_mask = qm_err->nfe | qm_err->ce | qm_err->fe;
 	/* clear QM hw residual error source */
 	writel(qm->error_mask, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+	if (qm->ver >= QM_HW_V5)
+		writeq(QM_FUNC_RAS_CLEAR_ALL, qm->io_base + QM_FUNC_AXI_ERR_ST0);
 
 	/* configure error type */
 	writel(qm_err->ce, qm->io_base + QM_RAS_CE_ENABLE);
@@ -1610,6 +1621,15 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
+		/* Trigger func reset only when error is detected in bit 0 or bit 1. */
+		if ((qm->ver >= QM_HW_V5) &&
+		    (error_status & QM_RAS_FUNC_ERROR) &&
+		    (error_status & qm_err->reset_mask) == 0) {
+			writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+			writel(qm_err->nfe, qm->io_base + QM_RAS_NFE_ENABLE);
+			return ACC_ERR_NEED_FUNC_RESET;
+		}
+
 		if (error_status & qm_err->reset_mask) {
 			/* Disable the same error reporting until device is recovered. */
 			writel(qm_err->nfe & (~error_status), qm->io_base + QM_RAS_NFE_ENABLE);
@@ -4364,10 +4384,13 @@ static enum acc_err_result qm_process_dev_error(struct hisi_qm *qm)
 
 	/* log device error */
 	dev_ret = qm_dev_err_handle(qm);
+	if (qm_ret == ACC_ERR_NEED_RESET || dev_ret == ACC_ERR_NEED_RESET)
+		return ACC_ERR_NEED_RESET;
+
+	if (qm_ret == ACC_ERR_NEED_FUNC_RESET)
+		return ACC_ERR_NEED_FUNC_RESET;
 
-	return (qm_ret == ACC_ERR_NEED_RESET ||
-		dev_ret == ACC_ERR_NEED_RESET) ?
-		ACC_ERR_NEED_RESET : ACC_ERR_RECOVERED;
+	return ACC_ERR_RECOVERED;
 }
 
 /**
@@ -4392,7 +4415,7 @@ pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 
 	ret = qm_process_dev_error(qm);
-	if (ret == ACC_ERR_NEED_RESET)
+	if (ret == ACC_ERR_NEED_RESET || ret == ACC_ERR_NEED_FUNC_RESET)
 		return PCI_ERS_RESULT_NEED_RESET;
 
 	return PCI_ERS_RESULT_RECOVERED;
@@ -5119,9 +5142,53 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_shutdown);
 
+static u64 qm_get_function_mask(struct hisi_qm *qm)
+{
+	return readq(qm->io_base + QM_FUNC_AXI_ERR_ST0);
+}
+
+static void qm_clear_function_mask(struct hisi_qm *qm, u64 func_mask)
+{
+	/* Register write 1 clear */
+	writeq(func_mask, qm->io_base + QM_FUNC_AXI_ERR_ST0);
+}
+
+static void qm_function_reset(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	u64 func_mask;
+	u32 fun_num;
+	int ret;
+
+	func_mask = qm_get_function_mask(qm);
+	if (!func_mask) {
+		dev_info(dev, "no function need reset!\n");
+		return;
+	}
+
+	for (fun_num = 1; fun_num <= qm->vfs_num; fun_num++) {
+		if (func_mask & BIT(fun_num)) {
+			ret = qm_ping_single_vf(qm, QM_FUNCTION_RESET, 0, fun_num);
+			/* When function ping fail, user decides the VF reset method. */
+			if (ret)
+				dev_err(dev, "failed to send command(0x%x) to VF(%u)!\n",
+					(unsigned int)QM_FUNCTION_RESET, fun_num);
+		}
+	}
+
+	if (func_mask & BIT(0)) {
+		dev_info(dev, "function reset start...\n");
+		qm_reset_function(qm);
+		dev_info(dev, "function reset end!\n");
+	}
+
+	qm_clear_function_mask(qm, func_mask);
+}
+
 static void hisi_qm_controller_reset(struct work_struct *rst_work)
 {
 	struct hisi_qm *qm = container_of(rst_work, struct hisi_qm, rst_work);
+	enum acc_err_result err_result;
 	int ret;
 
 	ret = qm_pm_get_sync(qm);
@@ -5130,9 +5197,11 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 		return;
 	}
 
-	ret = qm_process_dev_error(qm);
-	if (ret == ACC_ERR_NEED_RESET)
+	err_result = qm_process_dev_error(qm);
+	if (err_result == ACC_ERR_NEED_RESET)
 		(void)qm_controller_reset(qm);
+	else if (err_result == ACC_ERR_NEED_FUNC_RESET)
+		qm_function_reset(qm);
 
 	qm_pm_put_sync(qm);
 }
@@ -5179,7 +5248,7 @@ static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 	int ret;
 
 	pci_restore_state(pdev);
-	ret = hisi_qm_start(qm);
+	ret = qm_restart(qm);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to start QM, ret = %d.\n", ret);
 		cmd = QM_VF_START_FAIL;
@@ -5323,6 +5392,11 @@ static void qm_handle_cmd_msg(struct hisi_qm *qm, u32 fun_num)
 	case QM_PF_SET_QOS:
 		qm->mb_qos = data;
 		break;
+	case QM_FUNCTION_RESET:
+		dev_info(dev, "function reset start...\n");
+		qm_reset_function(qm);
+		dev_info(dev, "function reset end!\n");
+		break;
 	case QM_VF_GET_ISOLATE:
 		/* Read the isolation policy of the PF during VF initialization. */
 		qm_vf_get_isolate_data(qm, fun_num);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 98ff6bcfdebe..0a2da1029a3f 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -248,6 +248,7 @@ enum acc_err_result {
 	ACC_ERR_NONE,
 	ACC_ERR_NEED_RESET,
 	ACC_ERR_RECOVERED,
+	ACC_ERR_NEED_FUNC_RESET,
 };
 
 struct hisi_qm_err_mask {
-- 
2.33.0

