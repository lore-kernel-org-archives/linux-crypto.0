Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3130C632;
	Mon, 18 May 2026 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114697; cv=none; b=Uk/1DcNXd6MmymF2uTMxJgRdn6fmx7ZzmR81TKS9DE6RzoPwhgcpORYbanvwcNwCbX36Fvb/GELj0slASDposqXSlmct9iM9UMTeg1XQjnZnJsVkRi4VLcBICIdtlonkwLPhSPMpKl6f3sZChJRytJFT7pAey0HNCxQLX43IK3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114697; c=relaxed/simple;
	bh=Yjd44ld67t99rFPyQOmE3FDR1Bab02bHUQ3VQg2EcoY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVM1LhKJNusKM4nPIpow8RX7PTFev9uCTaQsngAwDsRyBBQSzQOhfiCZYcFi7hPUjXeoFjCRiGc2FxASKXNUggygV2mqlfVecsJE6q8PZyMjNcyF3HmCgnvfumqrvH9GCUmNltq1WR1pYcqJyMvfWjqLWMUvglpoI7aI2ZqkP6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1TwPrf2r; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1TwPrf2r"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mi89BOFRCY8D4yiPfVakvGZRIRJXMPZGBz9M8stKJkE=;
	b=1TwPrf2rUsfNyHCSjPZ2b79fOLISMDNmtf66Za194WIHMNr6noqDxmQxtMlQufqfFSeEkdVRB
	4zLgnD9nVyuW8KlbqLWPW9E4wMasz8/40xTZsn5l9wyJXByWzuwTfDfAtVo1PWqSgJLelkmbySo
	lnBGh5tyTerwOTK92dE3CO0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gK0Rq1WWXznTV5;
	Mon, 18 May 2026 22:24:23 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id EC6B54056C;
	Mon, 18 May 2026 22:31:22 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:22 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 6/6] crypto: hisilicon/qm - support doorbell enable control
Date: Mon, 18 May 2026 22:29:56 +0800
Message-ID: <20260518142956.3593934-7-wuzongyu1@huawei.com>
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

From: Zongyu Wu <wuzongyu1@huawei.com>

The driver notifies the hardware to handle task through
doorbell. Currently, doorbell is enabled by default. To
prevent the process from sending doorbells during hardware
reset scenarios, which could cause the hardware to process
doorbells and trigger new errors:

For example, when the physical machine is resetting the device,
doorbells are still being sent from the virtual machine.

Therefore, the driver disables doorbell during hardware
unavailability. After hardware initialization is completed,
doorbell is enabled, and any task sent during the unavailability
period will return errors.

The hardware supports the PF to disable doorbells for all functions,
while the VF can only disable its own doorbell function. When the PF
is reset, it will disable doorbells for all functions. When VF is
reset, it only disables its own doorbell and does not affect tasks
on other functions.

Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 54 +++++++++++++++++++++++++++++++----
 include/linux/hisi_acc_qm.h   | 12 ++++++++
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bfee16503c38..a951d2ef7833 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -247,6 +247,11 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
 
+#define QM_DB_DROP_ALL_FUNC_ENABLE	GENMASK(63, 0)
+#define QM_DB_DROP_ALL_FUNC_DISABLE	0
+#define QM_DEV_DB_DROP			0x0100250
+#define QM_FUN_DB_DROP			0x0038
+
 /* qm function err mask */
 #define QM_FUNC_AXI_ERR_ST0		0x100280
 #define QM_RAS_FUNC_ERROR		(BIT(0) | BIT(1))
@@ -577,6 +582,29 @@ static int qm_wait_reset_finish(struct hisi_qm *qm)
 	return 0;
 }
 
+static void qm_fun_db_ctrl(struct hisi_qm *qm, bool enable)
+{
+	u32 val;
+
+	if (qm->ver >= QM_HW_V5) {
+		val = readl(qm->io_base + QM_FUN_DB_DROP);
+		val = enable ? (val | BIT(0)) : (val & ~BIT(0));
+
+		writel(val, qm->io_base + QM_FUN_DB_DROP);
+	}
+}
+
+static void qm_dev_db_ctrl(struct hisi_qm *qm, bool enable)
+{
+	u64 val;
+
+	if (qm->ver >= QM_HW_V5 && qm->fun_type == QM_HW_PF) {
+		val = enable ? QM_DB_DROP_ALL_FUNC_ENABLE : QM_DB_DROP_ALL_FUNC_DISABLE;
+
+		writeq(val, qm->io_base + QM_DEV_DB_DROP);
+	}
+}
+
 static int qm_reset_prepare_ready(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -3434,6 +3462,9 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
+	/* Enables the doorbell function when the device is enabled. */
+	qm_dev_db_ctrl(qm, false);
+	qm_fun_db_ctrl(qm, false);
 	qm_init_prefetch(qm);
 	qm_enable_eq_aeq_interrupts(qm);
 
@@ -3541,7 +3572,7 @@ static void qm_invalid_queues(struct hisi_qm *qm)
 	if (qm->status.stop_reason == QM_NORMAL)
 		return;
 
-	if (qm->status.stop_reason == QM_DOWN)
+	if (qm->status.stop_reason == QM_DOWN || qm->status.stop_reason == QM_SHUTDOWN)
 		hisi_qm_cache_wb(qm);
 
 	for (i = 0; i < qm->qp_num; i++) {
@@ -3585,6 +3616,8 @@ int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 
 	if (qm->status.stop_reason != QM_NORMAL) {
 		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
+		if (qm->status.stop_reason != QM_SHUTDOWN)
+			qm_fun_db_ctrl(qm, true);
 		/*
 		 * When performing soft reset, the hardware will no longer
 		 * do tasks, and the tasks in the device will be flushed
@@ -4611,6 +4644,8 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	if (ret)
 		pci_err(pdev, "failed to stop by vfs in soft reset!\n");
 
+	qm_dev_db_ctrl(qm, true);
+
 	return 0;
 }
 
@@ -5019,16 +5054,25 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret) {
 		pci_err(pdev, "Failed to stop QM, ret = %d.\n", ret);
-		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
-		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
-		return;
+		goto err_prepare;
 	}
 
 	ret = qm_wait_vf_prepare_finish(qm);
 	if (ret)
 		pci_err(pdev, "failed to stop by vfs in FLR!\n");
 
+	qm_dev_db_ctrl(qm, true);
+
 	pci_info(pdev, "FLR resetting...\n");
+
+	return;
+
+err_prepare:
+	pci_info(pdev, "FLR resetting prepare failed!\n");
+	atomic_set(&qm->status.flags, QM_STOP);
+	hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
+	hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
+	qm_dev_db_ctrl(qm, true);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_prepare);
 
@@ -5122,7 +5166,7 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev)
 	struct hisi_qm *qm = pci_get_drvdata(pdev);
 	int ret;
 
-	ret = hisi_qm_stop(qm, QM_DOWN);
+	ret = hisi_qm_stop(qm, QM_SHUTDOWN);
 	if (ret)
 		dev_err(&pdev->dev, "Fail to stop qm in shutdown!\n");
 }
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 0a2da1029a3f..f7570a409905 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -115,10 +115,22 @@
 
 #define QM_ECC_MBIT			BIT(2)
 
+/**
+ * enum qm_stop_reason - Queue manager stop reasons
+ * @QM_NORMAL:      Graceful stop. Used for device unbind, driver removal,
+ *                  or runtime power management (runtime_suspend).
+ * @QM_SOFT_RESET:  Error recovery reset. Triggered by unrecoverable hardware
+ *                  errors (e.g., PCIe AER, timeout) to recover device state.
+ * @QM_DOWN:        Function Level Reset. Used when the device needs to
+ *                  be reset at the function level without resetting the link.
+ * @QM_SHUTDOWN:    System shutdown. Used during system poweroff, reboot, or
+ *                  kexec to ensure hardware is in a safe state.
+ */
 enum qm_stop_reason {
 	QM_NORMAL,
 	QM_SOFT_RESET,
 	QM_DOWN,
+	QM_SHUTDOWN,
 };
 
 enum qm_state {
-- 
2.33.0

