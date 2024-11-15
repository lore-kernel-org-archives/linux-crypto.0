Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F701ABEDF;
	Fri, 15 Nov 2024 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670044; cv=none; b=YVGujmTWmUpxVTlWBG9TE53vSaWQolq+QRfaQgnwtDeARph00gh5IBnfNc3UC1Xj+cg1J6auZqks0nGA9WJAGYvvY6dVawCOU5qhSxo6oEeyEsZTCrBOCQ5EPkJfK1vW39NdbsFRbGN7XClKqN7WDgbaZ4vk5UyXMErD4vHB8KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670044; c=relaxed/simple;
	bh=jBfW3mYDT7y3mG/UQkx1VLZexfwqBYJwx02coWNMvvo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAakY8ZrWjLWOdiHD2vFZcZ4IQrTBZKqhagd6or9187GJRYIxSisCYaa4+Vtz+0D8KMgNkB9KhRJRYUHDs4gDPskle79VkclHNLyDlNueokcXkOjfFvwqFBG1YxiUk1QAy1M3/HcNLn38wURg539MexLrXGpaueqHOjEnmXcc8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XqZSj6SSFz1k02Q;
	Fri, 15 Nov 2024 19:25:25 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id 5694614022D;
	Fri, 15 Nov 2024 19:27:18 +0800 (CST)
Received: from ubuntu.huawei.com (10.69.192.56) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Nov 2024 19:27:17 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/zip - support new error report
Date: Fri, 15 Nov 2024 19:26:51 +0800
Message-ID: <20241115112651.54299-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241115112651.54299-1-qianweili@huawei.com>
References: <20241115112651.54299-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk500010.china.huawei.com (7.202.194.95)

The error detection of the data aggregation feature is separated from
the compression/decompression feature. This patch enables the error
detection and reporting of the data aggregation feature. When an
unrecoverable error occurs in the algorithm core, the device reports
the error to the driver, and the driver will reset the device.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  12 ++
 drivers/crypto/hisilicon/qm.c             |  46 ++++--
 drivers/crypto/hisilicon/sec2/sec_main.c  |  12 ++
 drivers/crypto/hisilicon/zip/dae_main.c   | 192 ++++++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip.h        |   6 +
 drivers/crypto/hisilicon/zip/zip_main.c   |  36 +++-
 include/linux/hisi_acc_qm.h               |   2 +
 7 files changed, 292 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 96fde9437b4b..5b4c65440d06 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1396,6 +1396,17 @@ static enum acc_err_result hpre_get_err_result(struct hisi_qm *qm)
 	return ACC_ERR_RECOVERED;
 }
 
+static bool hpre_dev_is_abnormal(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hpre_get_hw_err_status(qm);
+	if (err_status & qm->err_info.dev_shutdown_mask)
+		return true;
+
+	return false;
+}
+
 static void hpre_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1428,6 +1439,7 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 	.show_last_dfx_regs	= hpre_show_last_dfx_regs,
 	.err_info_init		= hpre_err_info_init,
 	.get_err_result		= hpre_get_err_result,
+	.dev_is_abnormal	= hpre_dev_is_abnormal,
 };
 
 static int hpre_pf_probe_init(struct hpre *hpre)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 97404efa2e41..38193e25b014 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -501,15 +501,20 @@ static u32 qm_get_dev_err_status(struct hisi_qm *qm)
 /* Check if the error causes the master ooo block */
 static bool qm_check_dev_error(struct hisi_qm *qm)
 {
-	u32 val, dev_val;
+	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(qm->pdev));
+	u32 err_status;
 
-	if (qm->fun_type == QM_HW_VF)
+	if (pf_qm->fun_type == QM_HW_VF)
 		return false;
 
-	val = qm_get_hw_error_status(qm) & qm->err_info.qm_shutdown_mask;
-	dev_val = qm_get_dev_err_status(qm) & qm->err_info.dev_shutdown_mask;
+	err_status = qm_get_hw_error_status(pf_qm);
+	if (err_status & pf_qm->err_info.qm_shutdown_mask)
+		return true;
+
+	if (pf_qm->err_ini->dev_is_abnormal)
+		return pf_qm->err_ini->dev_is_abnormal(pf_qm);
 
-	return val || dev_val;
+	return false;
 }
 
 static int qm_wait_reset_finish(struct hisi_qm *qm)
@@ -654,7 +659,6 @@ EXPORT_SYMBOL_GPL(hisi_qm_mb);
 /* op 0: set xqc information to hardware, 1: get xqc information from hardware. */
 int qm_set_and_get_xqc(struct hisi_qm *qm, u8 cmd, void *xqc, u32 qp_id, bool op)
 {
-	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(qm->pdev));
 	struct qm_mailbox mailbox;
 	dma_addr_t xqc_dma;
 	void *tmp_xqc;
@@ -688,7 +692,7 @@ int qm_set_and_get_xqc(struct hisi_qm *qm, u8 cmd, void *xqc, u32 qp_id, bool op
 	}
 
 	/* Setting xqc will fail if master OOO is blocked. */
-	if (qm_check_dev_error(pf_qm)) {
+	if (qm_check_dev_error(qm)) {
 		dev_err(&qm->pdev->dev, "failed to send mailbox since qm is stop!\n");
 		return -EIO;
 	}
@@ -1052,11 +1056,10 @@ static void qm_disable_qp(struct hisi_qm *qm, u32 qp_id)
 
 static void qm_reset_function(struct hisi_qm *qm)
 {
-	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(qm->pdev));
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
-	if (qm_check_dev_error(pf_qm))
+	if (qm_check_dev_error(qm))
 		return;
 
 	ret = qm_reset_prepare_ready(qm);
@@ -2156,12 +2159,11 @@ static int qm_wait_qp_empty(struct hisi_qm *qm, u32 *state, u32 qp_id)
 static int qm_drain_qp(struct hisi_qp *qp)
 {
 	struct hisi_qm *qm = qp->qm;
-	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(qm->pdev));
 	u32 state = 0;
 	int ret;
 
 	/* No need to judge if master OOO is blocked. */
-	if (qm_check_dev_error(pf_qm))
+	if (qm_check_dev_error(qm))
 		return 0;
 
 	/* HW V3 supports drain qp by device */
@@ -4137,6 +4139,12 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
 
+	if (qm->err_ini->set_priv_status) {
+		ret = qm->err_ini->set_priv_status(qm);
+		if (ret)
+			return ret;
+	}
+
 	ret = qm_reset_prepare_ready(qm);
 	if (ret) {
 		pci_err(pdev, "Controller reset not ready!\n");
@@ -4527,7 +4535,7 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
 	 */
-	while (qm_check_dev_error(pf_qm)) {
+	while (qm_check_dev_error(qm)) {
 		msleep(++delay);
 		if (delay > QM_RESET_WAIT_TIMEOUT)
 			return;
@@ -5247,6 +5255,14 @@ static int qm_clear_device(struct hisi_qm *qm)
 		return ret;
 	}
 
+	if (qm->err_ini->set_priv_status) {
+		ret = qm->err_ini->set_priv_status(qm);
+		if (ret) {
+			writel(0x0, qm->io_base + ACC_MASTER_GLOBAL_CTRL);
+			return ret;
+		}
+	}
+
 	return qm_reset_device(qm);
 }
 
@@ -5598,6 +5614,12 @@ static int qm_prepare_for_suspend(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
+	if (qm->err_ini->set_priv_status) {
+		ret = qm->err_ini->set_priv_status(qm);
+		if (ret)
+			return ret;
+	}
+
 	ret = qm_set_pf_mse(qm, false);
 	if (ret)
 		pci_err(pdev, "failed to disable MSE before suspending!\n");
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 8ec5333bb5aa..d71594588b85 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1097,6 +1097,17 @@ static enum acc_err_result sec_get_err_result(struct hisi_qm *qm)
 	return ACC_ERR_RECOVERED;
 }
 
+static bool sec_dev_is_abnormal(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = sec_get_hw_err_status(qm);
+	if (err_status & qm->err_info.dev_shutdown_mask)
+		return true;
+
+	return false;
+}
+
 static void sec_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1129,6 +1140,7 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 	.show_last_dfx_regs	= sec_show_last_dfx_regs,
 	.err_info_init		= sec_err_info_init,
 	.get_err_result		= sec_get_err_result,
+	.dev_is_abnormal        = sec_dev_is_abnormal,
 };
 
 static int sec_pf_probe_init(struct sec_dev *sec)
diff --git a/drivers/crypto/hisilicon/zip/dae_main.c b/drivers/crypto/hisilicon/zip/dae_main.c
index 4369c5a7e2d5..6f22e4c36e49 100644
--- a/drivers/crypto/hisilicon/zip/dae_main.c
+++ b/drivers/crypto/hisilicon/zip/dae_main.c
@@ -16,6 +16,42 @@
 
 #define DAE_ALG_NAME			"hashagg"
 
+/* error */
+#define DAE_AXI_CFG_OFFSET		0x331000
+#define DAE_AXI_SHUTDOWN_MASK		(BIT(0) | BIT(5))
+#define DAE_ERR_SOURCE_OFFSET		0x331C84
+#define DAE_ERR_STATUS_OFFSET		0x331C88
+#define DAE_ERR_CE_OFFSET		0x331CA0
+#define DAE_ERR_CE_MASK			BIT(3)
+#define DAE_ERR_NFE_OFFSET		0x331CA4
+#define DAE_ERR_NFE_MASK		0x17
+#define DAE_ERR_FE_OFFSET		0x331CA8
+#define DAE_ERR_FE_MASK			0
+#define DAE_ECC_MBIT_MASK		BIT(2)
+#define DAE_ECC_INFO_OFFSET		0x33400C
+#define DAE_ERR_SHUTDOWN_OFFSET		0x331CAC
+#define DAE_ERR_SHUTDOWN_MASK		0x17
+#define DAE_ERR_ENABLE_OFFSET		0x331C80
+#define DAE_ERR_ENABLE_MASK		(DAE_ERR_FE_MASK | DAE_ERR_NFE_MASK | DAE_ERR_CE_MASK)
+#define DAE_AM_CTRL_GLOBAL_OFFSET	0x330000
+#define DAE_AM_RETURN_OFFSET		0x330150
+#define DAE_AM_RETURN_MASK		0x3
+#define DAE_AXI_CFG_OFFSET		0x331000
+#define DAE_AXI_SHUTDOWN_EN_MASK	(BIT(0) | BIT(5))
+
+struct hisi_dae_hw_error {
+	u32 int_msk;
+	const char *msg;
+};
+
+static const struct hisi_dae_hw_error dae_hw_error[] = {
+	{ .int_msk = BIT(0), .msg = "dae_axi_bus_err" },
+	{ .int_msk = BIT(1), .msg = "dae_axi_poison_err" },
+	{ .int_msk = BIT(2), .msg = "dae_ecc_2bit_err" },
+	{ .int_msk = BIT(3), .msg = "dae_ecc_1bit_err" },
+	{ .int_msk = BIT(4), .msg = "dae_fsm_hbeat_err" },
+};
+
 static inline bool dae_is_support(struct hisi_qm *qm)
 {
 	if (test_bit(QM_SUPPORT_DAE, &qm->caps))
@@ -68,3 +104,159 @@ int hisi_dae_set_alg(struct hisi_qm *qm)
 
 	return 0;
 }
+
+static void hisi_dae_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
+{
+	u32 axi_val, err_val;
+
+	axi_val = readl(qm->io_base + DAE_AXI_CFG_OFFSET);
+	if (enable) {
+		axi_val |= DAE_AXI_SHUTDOWN_MASK;
+		err_val = DAE_ERR_SHUTDOWN_MASK;
+	} else {
+		axi_val &= ~DAE_AXI_SHUTDOWN_MASK;
+		err_val = 0;
+	}
+
+	writel(axi_val, qm->io_base + DAE_AXI_CFG_OFFSET);
+	writel(err_val, qm->io_base + DAE_ERR_SHUTDOWN_OFFSET);
+}
+
+void hisi_dae_hw_error_enable(struct hisi_qm *qm)
+{
+	if (!dae_is_support(qm))
+		return;
+
+	/* clear dae hw error source if having */
+	writel(DAE_ERR_ENABLE_MASK, qm->io_base + DAE_ERR_SOURCE_OFFSET);
+
+	/* configure error type */
+	writel(DAE_ERR_CE_MASK, qm->io_base + DAE_ERR_CE_OFFSET);
+	writel(DAE_ERR_NFE_MASK, qm->io_base + DAE_ERR_NFE_OFFSET);
+	writel(DAE_ERR_FE_MASK, qm->io_base + DAE_ERR_FE_OFFSET);
+
+	hisi_dae_master_ooo_ctrl(qm, true);
+
+	/* enable dae hw error interrupts */
+	writel(DAE_ERR_ENABLE_MASK, qm->io_base + DAE_ERR_ENABLE_OFFSET);
+}
+
+void hisi_dae_hw_error_disable(struct hisi_qm *qm)
+{
+	if (!dae_is_support(qm))
+		return;
+
+	writel(0, qm->io_base + DAE_ERR_ENABLE_OFFSET);
+	hisi_dae_master_ooo_ctrl(qm, false);
+}
+
+static u32 hisi_dae_get_hw_err_status(struct hisi_qm *qm)
+{
+	return readl(qm->io_base + DAE_ERR_STATUS_OFFSET);
+}
+
+static void hisi_dae_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
+{
+	if (!dae_is_support(qm))
+		return;
+
+	writel(err_sts, qm->io_base + DAE_ERR_SOURCE_OFFSET);
+}
+
+static void hisi_dae_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	writel(DAE_ERR_NFE_MASK & (~err_type), qm->io_base + DAE_ERR_NFE_OFFSET);
+}
+
+static void hisi_dae_log_hw_error(struct hisi_qm *qm, u32 err_type)
+{
+	const struct hisi_dae_hw_error *err = dae_hw_error;
+	struct device *dev = &qm->pdev->dev;
+	u32 ecc_info;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(dae_hw_error); i++) {
+		err = &dae_hw_error[i];
+		if (!(err->int_msk & err_type))
+			continue;
+
+		dev_err(dev, "%s [error status=0x%x] found\n",
+			err->msg, err->int_msk);
+
+		if (err->int_msk & DAE_ECC_MBIT_MASK) {
+			ecc_info = readl(qm->io_base + DAE_ECC_INFO_OFFSET);
+			dev_err(dev, "dae multi ecc sram info 0x%x\n", ecc_info);
+		}
+	}
+}
+
+enum acc_err_result hisi_dae_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	if (!dae_is_support(qm))
+		return ACC_ERR_NONE;
+
+	err_status = hisi_dae_get_hw_err_status(qm);
+	if (!err_status)
+		return ACC_ERR_NONE;
+
+	hisi_dae_log_hw_error(qm, err_status);
+
+	if (err_status & DAE_ERR_NFE_MASK) {
+		/* Disable the same error reporting until device is recovered. */
+		hisi_dae_disable_error_report(qm, err_status);
+		return ACC_ERR_NEED_RESET;
+	}
+	hisi_dae_clear_hw_err_status(qm, err_status);
+
+	return ACC_ERR_RECOVERED;
+}
+
+bool hisi_dae_dev_is_abnormal(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	if (!dae_is_support(qm))
+		return false;
+
+	err_status = hisi_dae_get_hw_err_status(qm);
+	if (err_status & DAE_ERR_NFE_MASK)
+		return true;
+
+	return false;
+}
+
+int hisi_dae_close_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!dae_is_support(qm))
+		return 0;
+
+	val = readl(qm->io_base + DAE_AM_CTRL_GLOBAL_OFFSET);
+	val |= BIT(0);
+	writel(val, qm->io_base + DAE_AM_CTRL_GLOBAL_OFFSET);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + DAE_AM_RETURN_OFFSET,
+					 val, (val == DAE_AM_RETURN_MASK),
+					 DAE_REG_RD_INTVRL_US, DAE_REG_RD_TMOUT_US);
+	if (ret)
+		dev_err(&qm->pdev->dev, "failed to close dae axi ooo!\n");
+
+	return ret;
+}
+
+void hisi_dae_open_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (!dae_is_support(qm))
+		return;
+
+	val = readl(qm->io_base + DAE_AXI_CFG_OFFSET);
+
+	writel(val & ~DAE_AXI_SHUTDOWN_EN_MASK, qm->io_base + DAE_AXI_CFG_OFFSET);
+	writel(val | DAE_AXI_SHUTDOWN_EN_MASK, qm->io_base + DAE_AXI_CFG_OFFSET);
+}
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index a44ce7f06786..9fb2a9c01132 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -105,4 +105,10 @@ void hisi_zip_unregister_from_crypto(struct hisi_qm *qm);
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg);
 int hisi_dae_set_user_domain(struct hisi_qm *qm);
 int hisi_dae_set_alg(struct hisi_qm *qm);
+void hisi_dae_hw_error_disable(struct hisi_qm *qm);
+void hisi_dae_hw_error_enable(struct hisi_qm *qm);
+void hisi_dae_open_axi_master_ooo(struct hisi_qm *qm);
+int hisi_dae_close_axi_master_ooo(struct hisi_qm *qm);
+bool hisi_dae_dev_is_abnormal(struct hisi_qm *qm);
+enum acc_err_result hisi_dae_get_err_result(struct hisi_qm *qm);
 #endif
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 63a18c26c4ea..cb17d6cbf6ff 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -631,6 +631,8 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 
 	/* enable ZIP hw error interrupts */
 	writel(0, qm->io_base + HZIP_CORE_INT_MASK_REG);
+
+	hisi_dae_hw_error_enable(qm);
 }
 
 static void hisi_zip_hw_error_disable(struct hisi_qm *qm)
@@ -643,6 +645,8 @@ static void hisi_zip_hw_error_disable(struct hisi_qm *qm)
 	writel(ce | nfe | HZIP_CORE_INT_RAS_FE_ENB_MASK, qm->io_base + HZIP_CORE_INT_MASK_REG);
 
 	hisi_zip_master_ooo_ctrl(qm, false);
+
+	hisi_dae_hw_error_disable(qm);
 }
 
 static inline struct hisi_qm *file_to_qm(struct ctrl_debug_file *file)
@@ -1129,6 +1133,8 @@ static void hisi_zip_open_axi_master_ooo(struct hisi_qm *qm)
 
 	writel(val | HZIP_AXI_SHUTDOWN_ENABLE,
 	       qm->io_base + HZIP_SOFT_CTRL_ZIP_CONTROL);
+
+	hisi_dae_open_axi_master_ooo(qm);
 }
 
 static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
@@ -1147,8 +1153,11 @@ static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
 
 static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
 {
+	enum acc_err_result zip_result = ACC_ERR_NONE;
+	enum acc_err_result dae_result;
 	u32 err_status;
 
+	/* Get device hardware new error status */
 	err_status = hisi_zip_get_hw_err_status(qm);
 	if (err_status) {
 		if (err_status & qm->err_info.ecc_2bits_mask)
@@ -1159,11 +1168,32 @@ static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
 			/* Disable the same error reporting until device is recovered. */
 			hisi_zip_disable_error_report(qm, err_status);
 			return ACC_ERR_NEED_RESET;
+		} else {
+			hisi_zip_clear_hw_err_status(qm, err_status);
 		}
-		hisi_zip_clear_hw_err_status(qm, err_status);
 	}
 
-	return ACC_ERR_RECOVERED;
+	dae_result = hisi_dae_get_err_result(qm);
+
+	return (zip_result == ACC_ERR_NEED_RESET ||
+		dae_result == ACC_ERR_NEED_RESET) ?
+		ACC_ERR_NEED_RESET : ACC_ERR_RECOVERED;
+}
+
+static bool hisi_zip_dev_is_abnormal(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hisi_zip_get_hw_err_status(qm);
+	if (err_status & qm->err_info.dev_shutdown_mask)
+		return true;
+
+	return hisi_dae_dev_is_abnormal(qm);
+}
+
+static int hisi_zip_set_priv_status(struct hisi_qm *qm)
+{
+	return hisi_dae_close_axi_master_ooo(qm);
 }
 
 static void hisi_zip_err_info_init(struct hisi_qm *qm)
@@ -1200,6 +1230,8 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.show_last_dfx_regs	= hisi_zip_show_last_dfx_regs,
 	.err_info_init		= hisi_zip_err_info_init,
 	.get_err_result		= hisi_zip_get_err_result,
+	.set_priv_status	= hisi_zip_set_priv_status,
+	.dev_is_abnormal	= hisi_zip_dev_is_abnormal,
 };
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 3a13fb719dd0..c1dafbabbd6b 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -269,6 +269,8 @@ struct hisi_qm_err_ini {
 	void (*show_last_dfx_regs)(struct hisi_qm *qm);
 	void (*err_info_init)(struct hisi_qm *qm);
 	enum acc_err_result (*get_err_result)(struct hisi_qm *qm);
+	bool (*dev_is_abnormal)(struct hisi_qm *qm);
+	int (*set_priv_status)(struct hisi_qm *qm);
 };
 
 struct hisi_qm_cap_info {
-- 
2.33.0

