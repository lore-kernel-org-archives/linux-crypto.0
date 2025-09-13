Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C5B2EC544;
	Sat, 13 Sep 2025 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761083; cv=none; b=CZT8dGjyolrgw8N05u/SOFXQRRmDZorAFiFr0eb7nxoRtxYhmbp98LJO+lYq19tonrTFXub99stC1els8TfdykjRgkY2ZAo2OuceeIhzHoIlvBhlbfah8sa6aBb0XxCRonJsMXhtoEtv1g+lK4De1b6PO2GJRiV77Y8/AeQc1Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761083; c=relaxed/simple;
	bh=487P0K3ZmJylS1hp9G320vQZRRdvWLPrcKV1uby1nEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YTjQ+hBkdZkORupY+XOEPUUXY1gAwfb+Ur7CoCYMeWePPKA+EJ57DZSp+lxDScR1yJhxw2FfUKM0KtH/+bpGnuMMKWRiWk4WAsVVF1QtkVlrXsBd1ocOMHPnIJs4iAXsYNdBWYe5aBh6JIqI2x3Gk0gEpeeUymDK2q1trNz/3CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cP7SM2dQwzdc3B;
	Sat, 13 Sep 2025 18:53:23 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 32D11180464;
	Sat, 13 Sep 2025 18:57:57 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:56 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:56 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/5] crypto: hisilicon/qm - mask axi error before memory init
Date: Sat, 13 Sep 2025 18:57:51 +0800
Message-ID: <20250913105754.3862444-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

After the device memory is cleared, if the software sends
the doorbell operation, the hardware may trigger a axi error
when processing the doorbell. This error is caused by memory
clearing and hardware access to address 0. Therefore, the axi
error is masked during this period.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 100 +++++++++++++--------
 drivers/crypto/hisilicon/qm.c             |  66 ++++++++++----
 drivers/crypto/hisilicon/sec2/sec_main.c  |  90 +++++++++++++------
 drivers/crypto/hisilicon/zip/zip_main.c   | 102 ++++++++++++++--------
 include/linux/hisi_acc_qm.h               |  21 +++--
 5 files changed, 257 insertions(+), 122 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index f437f361a2c9..718abe3fa5fe 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -39,6 +39,7 @@
 #define HPRE_HAC_RAS_NFE_ENB		0x301414
 #define HPRE_HAC_RAS_FE_ENB		0x301418
 #define HPRE_HAC_INT_SET		0x301500
+#define HPRE_AXI_ERROR_MASK		GENMASK(21, 10)
 #define HPRE_RNG_TIMEOUT_NUM		0x301A34
 #define HPRE_CORE_INT_ENABLE		0
 #define HPRE_RDCHN_INI_ST		0x301a00
@@ -798,8 +799,7 @@ static void hpre_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 	val1 = readl(qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 	if (enable) {
 		val1 |= HPRE_AM_OOO_SHUTDOWN_ENABLE;
-		val2 = hisi_qm_get_hw_info(qm, hpre_basic_info,
-					   HPRE_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+		val2 = qm->err_info.dev_err.shutdown_mask;
 	} else {
 		val1 &= ~HPRE_AM_OOO_SHUTDOWN_ENABLE;
 		val2 = 0x0;
@@ -813,38 +813,33 @@ static void hpre_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 
 static void hpre_hw_error_disable(struct hisi_qm *qm)
 {
-	u32 ce, nfe;
-
-	ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CE_MASK_CAP, qm->cap_ver);
-	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	/* disable hpre hw error interrupts */
-	writel(ce | nfe | HPRE_HAC_RAS_FE_ENABLE, qm->io_base + HPRE_INT_MASK);
+	writel(err_mask, qm->io_base + HPRE_INT_MASK);
 	/* disable HPRE block master OOO when nfe occurs on Kunpeng930 */
 	hpre_master_ooo_ctrl(qm, false);
 }
 
 static void hpre_hw_error_enable(struct hisi_qm *qm)
 {
-	u32 ce, nfe, err_en;
-
-	ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CE_MASK_CAP, qm->cap_ver);
-	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	/* clear HPRE hw error source if having */
-	writel(ce | nfe | HPRE_HAC_RAS_FE_ENABLE, qm->io_base + HPRE_HAC_SOURCE_INT);
+	writel(err_mask, qm->io_base + HPRE_HAC_SOURCE_INT);
 
 	/* configure error type */
-	writel(ce, qm->io_base + HPRE_RAS_CE_ENB);
-	writel(nfe, qm->io_base + HPRE_RAS_NFE_ENB);
-	writel(HPRE_HAC_RAS_FE_ENABLE, qm->io_base + HPRE_RAS_FE_ENB);
+	writel(dev_err->ce, qm->io_base + HPRE_RAS_CE_ENB);
+	writel(dev_err->nfe, qm->io_base + HPRE_RAS_NFE_ENB);
+	writel(dev_err->fe, qm->io_base + HPRE_RAS_FE_ENB);
 
 	/* enable HPRE block master OOO when nfe occurs on Kunpeng930 */
 	hpre_master_ooo_ctrl(qm, true);
 
 	/* enable hpre hw error interrupts */
-	err_en = ce | nfe | HPRE_HAC_RAS_FE_ENABLE;
-	writel(~err_en, qm->io_base + HPRE_INT_MASK);
+	writel(~err_mask, qm->io_base + HPRE_INT_MASK);
 }
 
 static inline struct hisi_qm *hpre_file_to_qm(struct hpre_debugfs_file *file)
@@ -1399,9 +1394,8 @@ static void hpre_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 
 static void hpre_disable_error_report(struct hisi_qm *qm, u32 err_type)
 {
-	u32 nfe_mask;
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
 
-	nfe_mask = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
 	writel(nfe_mask & (~err_type), qm->io_base + HPRE_RAS_NFE_ENB);
 }
 
@@ -1422,11 +1416,11 @@ static enum acc_err_result hpre_get_err_result(struct hisi_qm *qm)
 
 	err_status = hpre_get_hw_err_status(qm);
 	if (err_status) {
-		if (err_status & qm->err_info.ecc_2bits_mask)
+		if (err_status & qm->err_info.dev_err.ecc_2bits_mask)
 			qm->err_status.is_dev_ecc_mbit = true;
 		hpre_log_hw_error(qm, err_status);
 
-		if (err_status & qm->err_info.dev_reset_mask) {
+		if (err_status & qm->err_info.dev_err.reset_mask) {
 			/* Disable the same error reporting until device is recovered. */
 			hpre_disable_error_report(qm, err_status);
 			return ACC_ERR_NEED_RESET;
@@ -1442,28 +1436,64 @@ static bool hpre_dev_is_abnormal(struct hisi_qm *qm)
 	u32 err_status;
 
 	err_status = hpre_get_hw_err_status(qm);
-	if (err_status & qm->err_info.dev_shutdown_mask)
+	if (err_status & qm->err_info.dev_err.shutdown_mask)
 		return true;
 
 	return false;
 }
 
+static void hpre_disable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+	u32 val;
+
+	val = ~(err_mask & (~HPRE_AXI_ERROR_MASK));
+	writel(val, qm->io_base + HPRE_INT_MASK);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask & (~HPRE_AXI_ERROR_MASK),
+		       qm->io_base + HPRE_OOO_SHUTDOWN_SEL);
+}
+
+static void hpre_enable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+
+	/* clear axi error source */
+	writel(HPRE_AXI_ERROR_MASK, qm->io_base + HPRE_HAC_SOURCE_INT);
+
+	writel(~err_mask, qm->io_base + HPRE_INT_MASK);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask, qm->io_base + HPRE_OOO_SHUTDOWN_SEL);
+}
+
 static void hpre_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
+	struct hisi_qm_err_mask *qm_err = &err_info->qm_err;
+	struct hisi_qm_err_mask *dev_err = &err_info->dev_err;
+
+	qm_err->fe = HPRE_HAC_RAS_FE_ENABLE;
+	qm_err->ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_QM_CE_MASK_CAP, qm->cap_ver);
+	qm_err->nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_QM_NFE_MASK_CAP, qm->cap_ver);
+	qm_err->shutdown_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
+						    HPRE_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+	qm_err->reset_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
+						 HPRE_QM_RESET_MASK_CAP, qm->cap_ver);
+	qm_err->ecc_2bits_mask = QM_ECC_MBIT;
+
+	dev_err->fe = HPRE_HAC_RAS_FE_ENABLE;
+	dev_err->ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CE_MASK_CAP, qm->cap_ver);
+	dev_err->nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
+	dev_err->shutdown_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
+						     HPRE_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+	dev_err->reset_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
+						  HPRE_RESET_MASK_CAP, qm->cap_ver);
+	dev_err->ecc_2bits_mask = HPRE_CORE_ECC_2BIT_ERR | HPRE_OOO_ECC_2BIT_ERR;
 
-	err_info->fe = HPRE_HAC_RAS_FE_ENABLE;
-	err_info->ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_QM_CE_MASK_CAP, qm->cap_ver);
-	err_info->nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_QM_NFE_MASK_CAP, qm->cap_ver);
-	err_info->ecc_2bits_mask = HPRE_CORE_ECC_2BIT_ERR | HPRE_OOO_ECC_2BIT_ERR;
-	err_info->dev_shutdown_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
-			HPRE_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->qm_shutdown_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
-			HPRE_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->qm_reset_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
-			HPRE_QM_RESET_MASK_CAP, qm->cap_ver);
-	err_info->dev_reset_mask = hisi_qm_get_hw_info(qm, hpre_basic_info,
-			HPRE_RESET_MASK_CAP, qm->cap_ver);
 	err_info->msi_wr_port = HPRE_WR_MSI_PORT;
 	err_info->acpi_rst = "HRST";
 }
@@ -1481,6 +1511,8 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 	.err_info_init		= hpre_err_info_init,
 	.get_err_result		= hpre_get_err_result,
 	.dev_is_abnormal	= hpre_dev_is_abnormal,
+	.disable_axi_error	= hpre_disable_axi_error,
+	.enable_axi_error	= hpre_enable_axi_error,
 };
 
 static int hpre_pf_probe_init(struct hpre *hpre)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 822202e0f11b..32dd755e1867 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -147,9 +147,9 @@
 #define QM_RAS_CE_TIMES_PER_IRQ		1
 #define QM_OOO_SHUTDOWN_SEL		0x1040f8
 #define QM_AXI_RRESP_ERR		BIT(0)
-#define QM_ECC_MBIT			BIT(2)
 #define QM_DB_TIMEOUT			BIT(10)
 #define QM_OF_FIFO_OF			BIT(11)
+#define QM_RAS_AXI_ERROR		(BIT(0) | BIT(1) | BIT(12))
 
 #define QM_RESET_WAIT_TIMEOUT		400
 #define QM_PEH_VENDOR_ID		0x1000d8
@@ -165,7 +165,6 @@
 #define ACC_MASTER_TRANS_RETURN		0x300150
 #define ACC_MASTER_GLOBAL_CTRL		0x300000
 #define ACC_AM_CFG_PORT_WR_EN		0x30001c
-#define QM_RAS_NFE_MBIT_DISABLE		~QM_ECC_MBIT
 #define ACC_AM_ROB_ECC_INT_STS		0x300104
 #define ACC_ROB_ECC_ERR_MULTPL		BIT(1)
 #define QM_MSI_CAP_ENABLE		BIT(16)
@@ -522,7 +521,7 @@ static bool qm_check_dev_error(struct hisi_qm *qm)
 		return false;
 
 	err_status = qm_get_hw_error_status(pf_qm);
-	if (err_status & pf_qm->err_info.qm_shutdown_mask)
+	if (err_status & pf_qm->err_info.qm_err.shutdown_mask)
 		return true;
 
 	if (pf_qm->err_ini->dev_is_abnormal)
@@ -1397,17 +1396,17 @@ static void qm_hw_error_init_v1(struct hisi_qm *qm)
 
 static void qm_hw_error_cfg(struct hisi_qm *qm)
 {
-	struct hisi_qm_err_info *err_info = &qm->err_info;
+	struct hisi_qm_err_mask *qm_err = &qm->err_info.qm_err;
 
-	qm->error_mask = err_info->nfe | err_info->ce | err_info->fe;
+	qm->error_mask = qm_err->nfe | qm_err->ce | qm_err->fe;
 	/* clear QM hw residual error source */
 	writel(qm->error_mask, qm->io_base + QM_ABNORMAL_INT_SOURCE);
 
 	/* configure error type */
-	writel(err_info->ce, qm->io_base + QM_RAS_CE_ENABLE);
+	writel(qm_err->ce, qm->io_base + QM_RAS_CE_ENABLE);
 	writel(QM_RAS_CE_TIMES_PER_IRQ, qm->io_base + QM_RAS_CE_THRESHOLD);
-	writel(err_info->nfe, qm->io_base + QM_RAS_NFE_ENABLE);
-	writel(err_info->fe, qm->io_base + QM_RAS_FE_ENABLE);
+	writel(qm_err->nfe, qm->io_base + QM_RAS_NFE_ENABLE);
+	writel(qm_err->fe, qm->io_base + QM_RAS_FE_ENABLE);
 }
 
 static void qm_hw_error_init_v2(struct hisi_qm *qm)
@@ -1436,7 +1435,7 @@ static void qm_hw_error_init_v3(struct hisi_qm *qm)
 	qm_hw_error_cfg(qm);
 
 	/* enable close master ooo when hardware error happened */
-	writel(qm->err_info.qm_shutdown_mask, qm->io_base + QM_OOO_SHUTDOWN_SEL);
+	writel(qm->err_info.qm_err.shutdown_mask, qm->io_base + QM_OOO_SHUTDOWN_SEL);
 
 	irq_unmask = ~qm->error_mask;
 	irq_unmask &= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
@@ -1498,6 +1497,7 @@ static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 
 static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 {
+	struct hisi_qm_err_mask *qm_err = &qm->err_info.qm_err;
 	u32 error_status;
 
 	error_status = qm_get_hw_error_status(qm);
@@ -1506,17 +1506,16 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
-		if (error_status & qm->err_info.qm_reset_mask) {
+		if (error_status & qm_err->reset_mask) {
 			/* Disable the same error reporting until device is recovered. */
-			writel(qm->err_info.nfe & (~error_status),
-			       qm->io_base + QM_RAS_NFE_ENABLE);
+			writel(qm_err->nfe & (~error_status), qm->io_base + QM_RAS_NFE_ENABLE);
 			return ACC_ERR_NEED_RESET;
 		}
 
 		/* Clear error source if not need reset. */
 		writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
-		writel(qm->err_info.nfe, qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(qm->err_info.ce, qm->io_base + QM_RAS_CE_ENABLE);
+		writel(qm_err->nfe, qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(qm_err->ce, qm->io_base + QM_RAS_CE_ENABLE);
 	}
 
 	return ACC_ERR_RECOVERED;
@@ -4212,9 +4211,9 @@ static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
 		   !qm->err_status.is_qm_ecc_mbit &&
 		   !qm->err_ini->close_axi_master_ooo) {
 		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
+		writel(nfe_enb & ~qm->err_info.qm_err.ecc_2bits_mask,
 		       qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
+		writel(qm->err_info.qm_err.ecc_2bits_mask, qm->io_base + QM_ABNORMAL_INT_SET);
 	}
 }
 
@@ -4493,12 +4492,12 @@ static void qm_restart_prepare(struct hisi_qm *qm)
 	       qm->io_base + ACC_AM_CFG_PORT_WR_EN);
 
 	/* clear dev ecc 2bit error source if having */
-	value = qm_get_dev_err_status(qm) & qm->err_info.ecc_2bits_mask;
+	value = qm_get_dev_err_status(qm) & qm->err_info.dev_err.ecc_2bits_mask;
 	if (value && qm->err_ini->clear_dev_hw_err_status)
 		qm->err_ini->clear_dev_hw_err_status(qm, value);
 
 	/* clear QM ecc mbit error source */
-	writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+	writel(qm->err_info.qm_err.ecc_2bits_mask, qm->io_base + QM_ABNORMAL_INT_SOURCE);
 
 	/* clear AM Reorder Buffer ecc mbit source */
 	writel(ACC_ROB_ECC_ERR_MULTPL, qm->io_base + ACC_AM_ROB_ECC_INT_STS);
@@ -4525,6 +4524,34 @@ static void qm_restart_done(struct hisi_qm *qm)
 	qm->err_status.is_dev_ecc_mbit = false;
 }
 
+static void qm_disable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *qm_err = &qm->err_info.qm_err;
+	u32 val;
+
+	val = ~(qm->error_mask & (~QM_RAS_AXI_ERROR));
+	writel(val, qm->io_base + QM_ABNORMAL_INT_MASK);
+	if (qm->ver > QM_HW_V2)
+		writel(qm_err->shutdown_mask & (~QM_RAS_AXI_ERROR),
+		       qm->io_base + QM_OOO_SHUTDOWN_SEL);
+
+	if (qm->err_ini->disable_axi_error)
+		qm->err_ini->disable_axi_error(qm);
+}
+
+static void qm_enable_axi_error(struct hisi_qm *qm)
+{
+	/* clear axi error source */
+	writel(QM_RAS_AXI_ERROR, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+
+	writel(~qm->error_mask, qm->io_base + QM_ABNORMAL_INT_MASK);
+	if (qm->ver > QM_HW_V2)
+		writel(qm->err_info.qm_err.shutdown_mask, qm->io_base + QM_OOO_SHUTDOWN_SEL);
+
+	if (qm->err_ini->enable_axi_error)
+		qm->err_ini->enable_axi_error(qm);
+}
+
 static int qm_controller_reset_done(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -4558,6 +4585,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 
 	qm_restart_prepare(qm);
 	hisi_qm_dev_err_init(qm);
+	qm_disable_axi_error(qm);
 	if (qm->err_ini->open_axi_master_ooo)
 		qm->err_ini->open_axi_master_ooo(qm);
 
@@ -4580,7 +4608,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 	ret = qm_wait_vf_prepare_finish(qm);
 	if (ret)
 		pci_err(pdev, "failed to start by vfs in soft reset!\n");
-
+	qm_enable_axi_error(qm);
 	qm_cmd_init(qm);
 	qm_restart_done(qm);
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index bdb2d52ee1b6..19fda486fefb 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -47,6 +47,8 @@
 #define SEC_RAS_FE_ENB_MSK		0x0
 #define SEC_OOO_SHUTDOWN_SEL		0x301014
 #define SEC_RAS_DISABLE		0x0
+#define SEC_AXI_ERROR_MASK		(BIT(0) | BIT(1))
+
 #define SEC_MEM_START_INIT_REG	0x301100
 #define SEC_MEM_INIT_DONE_REG		0x301104
 
@@ -713,8 +715,7 @@ static void sec_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 	val1 = readl(qm->io_base + SEC_CONTROL_REG);
 	if (enable) {
 		val1 |= SEC_AXI_SHUTDOWN_ENABLE;
-		val2 = hisi_qm_get_hw_info(qm, sec_basic_info,
-					   SEC_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+		val2 = qm->err_info.dev_err.shutdown_mask;
 	} else {
 		val1 &= SEC_AXI_SHUTDOWN_DISABLE;
 		val2 = 0x0;
@@ -728,7 +729,8 @@ static void sec_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 
 static void sec_hw_error_enable(struct hisi_qm *qm)
 {
-	u32 ce, nfe;
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	if (qm->ver == QM_HW_V1) {
 		writel(SEC_CORE_INT_DISABLE, qm->io_base + SEC_CORE_INT_MASK);
@@ -736,22 +738,19 @@ static void sec_hw_error_enable(struct hisi_qm *qm)
 		return;
 	}
 
-	ce = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_CE_MASK_CAP, qm->cap_ver);
-	nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
-
 	/* clear SEC hw error source if having */
-	writel(ce | nfe | SEC_RAS_FE_ENB_MSK, qm->io_base + SEC_CORE_INT_SOURCE);
+	writel(err_mask, qm->io_base + SEC_CORE_INT_SOURCE);
 
 	/* enable RAS int */
-	writel(ce, qm->io_base + SEC_RAS_CE_REG);
-	writel(SEC_RAS_FE_ENB_MSK, qm->io_base + SEC_RAS_FE_REG);
-	writel(nfe, qm->io_base + SEC_RAS_NFE_REG);
+	writel(dev_err->ce, qm->io_base + SEC_RAS_CE_REG);
+	writel(dev_err->fe, qm->io_base + SEC_RAS_FE_REG);
+	writel(dev_err->nfe, qm->io_base + SEC_RAS_NFE_REG);
 
 	/* enable SEC block master OOO when nfe occurs on Kunpeng930 */
 	sec_master_ooo_ctrl(qm, true);
 
 	/* enable SEC hw error interrupts */
-	writel(ce | nfe | SEC_RAS_FE_ENB_MSK, qm->io_base + SEC_CORE_INT_MASK);
+	writel(err_mask, qm->io_base + SEC_CORE_INT_MASK);
 }
 
 static void sec_hw_error_disable(struct hisi_qm *qm)
@@ -1108,9 +1107,8 @@ static void sec_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 
 static void sec_disable_error_report(struct hisi_qm *qm, u32 err_type)
 {
-	u32 nfe_mask;
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
 
-	nfe_mask = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
 	writel(nfe_mask & (~err_type), qm->io_base + SEC_RAS_NFE_REG);
 }
 
@@ -1129,11 +1127,11 @@ static enum acc_err_result sec_get_err_result(struct hisi_qm *qm)
 
 	err_status = sec_get_hw_err_status(qm);
 	if (err_status) {
-		if (err_status & qm->err_info.ecc_2bits_mask)
+		if (err_status & qm->err_info.dev_err.ecc_2bits_mask)
 			qm->err_status.is_dev_ecc_mbit = true;
 		sec_log_hw_error(qm, err_status);
 
-		if (err_status & qm->err_info.dev_reset_mask) {
+		if (err_status & qm->err_info.dev_err.reset_mask) {
 			/* Disable the same error reporting until device is recovered. */
 			sec_disable_error_report(qm, err_status);
 			return ACC_ERR_NEED_RESET;
@@ -1149,28 +1147,62 @@ static bool sec_dev_is_abnormal(struct hisi_qm *qm)
 	u32 err_status;
 
 	err_status = sec_get_hw_err_status(qm);
-	if (err_status & qm->err_info.dev_shutdown_mask)
+	if (err_status & qm->err_info.dev_err.shutdown_mask)
 		return true;
 
 	return false;
 }
 
+static void sec_disable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+
+	writel(err_mask & ~SEC_AXI_ERROR_MASK, qm->io_base + SEC_CORE_INT_MASK);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask & (~SEC_AXI_ERROR_MASK),
+		       qm->io_base + SEC_OOO_SHUTDOWN_SEL);
+}
+
+static void sec_enable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+
+	/* clear axi error source */
+	writel(SEC_AXI_ERROR_MASK, qm->io_base + SEC_CORE_INT_SOURCE);
+
+	writel(err_mask, qm->io_base + SEC_CORE_INT_MASK);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask, qm->io_base + SEC_OOO_SHUTDOWN_SEL);
+}
+
 static void sec_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
+	struct hisi_qm_err_mask *qm_err = &err_info->qm_err;
+	struct hisi_qm_err_mask *dev_err = &err_info->dev_err;
+
+	qm_err->fe = SEC_RAS_FE_ENB_MSK;
+	qm_err->ce = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_QM_CE_MASK_CAP, qm->cap_ver);
+	qm_err->nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_QM_NFE_MASK_CAP, qm->cap_ver);
+	qm_err->shutdown_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
+						    SEC_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+	qm_err->reset_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
+						 SEC_QM_RESET_MASK_CAP, qm->cap_ver);
+	qm_err->ecc_2bits_mask = QM_ECC_MBIT;
+
+	dev_err->fe = SEC_RAS_FE_ENB_MSK;
+	dev_err->ce = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_CE_MASK_CAP, qm->cap_ver);
+	dev_err->nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
+	dev_err->shutdown_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
+						     SEC_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+	dev_err->reset_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
+						  SEC_RESET_MASK_CAP, qm->cap_ver);
+	dev_err->ecc_2bits_mask = SEC_CORE_INT_STATUS_M_ECC;
 
-	err_info->fe = SEC_RAS_FE_ENB_MSK;
-	err_info->ce = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_QM_CE_MASK_CAP, qm->cap_ver);
-	err_info->nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_QM_NFE_MASK_CAP, qm->cap_ver);
-	err_info->ecc_2bits_mask = SEC_CORE_INT_STATUS_M_ECC;
-	err_info->qm_shutdown_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
-				     SEC_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->dev_shutdown_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
-			SEC_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->qm_reset_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
-			SEC_QM_RESET_MASK_CAP, qm->cap_ver);
-	err_info->dev_reset_mask = hisi_qm_get_hw_info(qm, sec_basic_info,
-			SEC_RESET_MASK_CAP, qm->cap_ver);
 	err_info->msi_wr_port = BIT(0);
 	err_info->acpi_rst = "SRST";
 }
@@ -1188,6 +1220,8 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 	.err_info_init		= sec_err_info_init,
 	.get_err_result		= sec_get_err_result,
 	.dev_is_abnormal        = sec_dev_is_abnormal,
+	.disable_axi_error	= sec_disable_axi_error,
+	.enable_axi_error	= sec_enable_axi_error,
 };
 
 static int sec_pf_probe_init(struct sec_dev *sec)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index fcb72d5cf592..e206443ac8ef 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -65,6 +65,7 @@
 #define HZIP_SRAM_ECC_ERR_NUM_SHIFT	16
 #define HZIP_SRAM_ECC_ERR_ADDR_SHIFT	24
 #define HZIP_CORE_INT_MASK_ALL		GENMASK(12, 0)
+#define HZIP_AXI_ERROR_MASK		(BIT(2) | BIT(3))
 #define HZIP_SQE_SIZE			128
 #define HZIP_PF_DEF_Q_NUM		64
 #define HZIP_PF_DEF_Q_BASE		0
@@ -655,8 +656,7 @@ static void hisi_zip_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 	val1 = readl(qm->io_base + HZIP_SOFT_CTRL_ZIP_CONTROL);
 	if (enable) {
 		val1 |= HZIP_AXI_SHUTDOWN_ENABLE;
-		val2 = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-				ZIP_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+		val2 = qm->err_info.dev_err.shutdown_mask;
 	} else {
 		val1 &= ~HZIP_AXI_SHUTDOWN_ENABLE;
 		val2 = 0x0;
@@ -670,7 +670,8 @@ static void hisi_zip_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 
 static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 {
-	u32 nfe, ce;
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	if (qm->ver == QM_HW_V1) {
 		writel(HZIP_CORE_INT_MASK_ALL,
@@ -679,33 +680,29 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 		return;
 	}
 
-	nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
-	ce = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CE_MASK_CAP, qm->cap_ver);
-
 	/* clear ZIP hw error source if having */
-	writel(ce | nfe | HZIP_CORE_INT_RAS_FE_ENB_MASK, qm->io_base + HZIP_CORE_INT_SOURCE);
+	writel(err_mask, qm->io_base + HZIP_CORE_INT_SOURCE);
 
 	/* configure error type */
-	writel(ce, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
-	writel(HZIP_CORE_INT_RAS_FE_ENB_MASK, qm->io_base + HZIP_CORE_INT_RAS_FE_ENB);
-	writel(nfe, qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+	writel(dev_err->ce, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
+	writel(dev_err->fe, qm->io_base + HZIP_CORE_INT_RAS_FE_ENB);
+	writel(dev_err->nfe, qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
 
 	hisi_zip_master_ooo_ctrl(qm, true);
 
 	/* enable ZIP hw error interrupts */
-	writel(0, qm->io_base + HZIP_CORE_INT_MASK_REG);
+	writel(~err_mask, qm->io_base + HZIP_CORE_INT_MASK_REG);
 
 	hisi_dae_hw_error_enable(qm);
 }
 
 static void hisi_zip_hw_error_disable(struct hisi_qm *qm)
 {
-	u32 nfe, ce;
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	/* disable ZIP hw error interrupts */
-	nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
-	ce = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CE_MASK_CAP, qm->cap_ver);
-	writel(ce | nfe | HZIP_CORE_INT_RAS_FE_ENB_MASK, qm->io_base + HZIP_CORE_INT_MASK_REG);
+	writel(err_mask, qm->io_base + HZIP_CORE_INT_MASK_REG);
 
 	hisi_zip_master_ooo_ctrl(qm, false);
 
@@ -1179,9 +1176,8 @@ static void hisi_zip_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 
 static void hisi_zip_disable_error_report(struct hisi_qm *qm, u32 err_type)
 {
-	u32 nfe_mask;
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
 
-	nfe_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
 	writel(nfe_mask & (~err_type), qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
 }
 
@@ -1223,14 +1219,14 @@ static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
 	/* Get device hardware new error status */
 	err_status = hisi_zip_get_hw_err_status(qm);
 	if (err_status) {
-		if (err_status & qm->err_info.ecc_2bits_mask)
+		if (err_status & qm->err_info.dev_err.ecc_2bits_mask)
 			qm->err_status.is_dev_ecc_mbit = true;
 		hisi_zip_log_hw_error(qm, err_status);
 
-		if (err_status & qm->err_info.dev_reset_mask) {
+		if (err_status & qm->err_info.dev_err.reset_mask) {
 			/* Disable the same error reporting until device is recovered. */
 			hisi_zip_disable_error_report(qm, err_status);
-			return ACC_ERR_NEED_RESET;
+			zip_result = ACC_ERR_NEED_RESET;
 		} else {
 			hisi_zip_clear_hw_err_status(qm, err_status);
 		}
@@ -1248,7 +1244,7 @@ static bool hisi_zip_dev_is_abnormal(struct hisi_qm *qm)
 	u32 err_status;
 
 	err_status = hisi_zip_get_hw_err_status(qm);
-	if (err_status & qm->err_info.dev_shutdown_mask)
+	if (err_status & qm->err_info.dev_err.shutdown_mask)
 		return true;
 
 	return hisi_dae_dev_is_abnormal(qm);
@@ -1259,23 +1255,59 @@ static int hisi_zip_set_priv_status(struct hisi_qm *qm)
 	return hisi_dae_close_axi_master_ooo(qm);
 }
 
+static void hisi_zip_disable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+	u32 val;
+
+	val = ~(err_mask & (~HZIP_AXI_ERROR_MASK));
+	writel(val, qm->io_base + HZIP_CORE_INT_MASK_REG);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask & (~HZIP_AXI_ERROR_MASK),
+		       qm->io_base + HZIP_OOO_SHUTDOWN_SEL);
+}
+
+static void hisi_zip_enable_axi_error(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
+	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
+
+	/* clear axi error source */
+	writel(HZIP_AXI_ERROR_MASK, qm->io_base + HZIP_CORE_INT_SOURCE);
+
+	writel(~err_mask, qm->io_base + HZIP_CORE_INT_MASK_REG);
+
+	if (qm->ver > QM_HW_V2)
+		writel(dev_err->shutdown_mask, qm->io_base + HZIP_OOO_SHUTDOWN_SEL);
+}
+
 static void hisi_zip_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
+	struct hisi_qm_err_mask *qm_err = &err_info->qm_err;
+	struct hisi_qm_err_mask *dev_err = &err_info->dev_err;
+
+	qm_err->fe = HZIP_CORE_INT_RAS_FE_ENB_MASK;
+	qm_err->ce = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_QM_CE_MASK_CAP, qm->cap_ver);
+	qm_err->nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+					  ZIP_QM_NFE_MASK_CAP, qm->cap_ver);
+	qm_err->ecc_2bits_mask = QM_ECC_MBIT;
+	qm_err->reset_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+						 ZIP_QM_RESET_MASK_CAP, qm->cap_ver);
+	qm_err->shutdown_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+						    ZIP_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+
+	dev_err->fe = HZIP_CORE_INT_RAS_FE_ENB_MASK;
+	dev_err->ce = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CE_MASK_CAP, qm->cap_ver);
+	dev_err->nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
+	dev_err->ecc_2bits_mask = HZIP_CORE_INT_STATUS_M_ECC;
+	dev_err->shutdown_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+						     ZIP_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
+	dev_err->reset_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+						  ZIP_RESET_MASK_CAP, qm->cap_ver);
 
-	err_info->fe = HZIP_CORE_INT_RAS_FE_ENB_MASK;
-	err_info->ce = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_QM_CE_MASK_CAP, qm->cap_ver);
-	err_info->nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-					    ZIP_QM_NFE_MASK_CAP, qm->cap_ver);
-	err_info->ecc_2bits_mask = HZIP_CORE_INT_STATUS_M_ECC;
-	err_info->qm_shutdown_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-							 ZIP_QM_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->dev_shutdown_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-							  ZIP_OOO_SHUTDOWN_MASK_CAP, qm->cap_ver);
-	err_info->qm_reset_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-						      ZIP_QM_RESET_MASK_CAP, qm->cap_ver);
-	err_info->dev_reset_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-						       ZIP_RESET_MASK_CAP, qm->cap_ver);
 	err_info->msi_wr_port = HZIP_WR_PORT;
 	err_info->acpi_rst = "ZRST";
 }
@@ -1295,6 +1327,8 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.get_err_result		= hisi_zip_get_err_result,
 	.set_priv_status	= hisi_zip_set_priv_status,
 	.dev_is_abnormal	= hisi_zip_dev_is_abnormal,
+	.disable_axi_error	= hisi_zip_disable_axi_error,
+	.enable_axi_error	= hisi_zip_enable_axi_error,
 };
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 0c4c84b8c3be..5abafb25a79b 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -104,6 +104,8 @@
 #define UACCE_MODE_SVA			1 /* use uacce sva mode */
 #define UACCE_MODE_DESC	"0(default) means only register to crypto, 1 means both register to crypto and uacce"
 
+#define QM_ECC_MBIT			BIT(2)
+
 enum qm_stop_reason {
 	QM_NORMAL,
 	QM_SOFT_RESET,
@@ -239,19 +241,22 @@ enum acc_err_result {
 	ACC_ERR_RECOVERED,
 };
 
-struct hisi_qm_err_info {
-	char *acpi_rst;
-	u32 msi_wr_port;
+struct hisi_qm_err_mask {
 	u32 ecc_2bits_mask;
-	u32 qm_shutdown_mask;
-	u32 dev_shutdown_mask;
-	u32 qm_reset_mask;
-	u32 dev_reset_mask;
+	u32 shutdown_mask;
+	u32 reset_mask;
 	u32 ce;
 	u32 nfe;
 	u32 fe;
 };
 
+struct hisi_qm_err_info {
+	char *acpi_rst;
+	u32 msi_wr_port;
+	struct hisi_qm_err_mask qm_err;
+	struct hisi_qm_err_mask dev_err;
+};
+
 struct hisi_qm_err_status {
 	u32 is_qm_ecc_mbit;
 	u32 is_dev_ecc_mbit;
@@ -272,6 +277,8 @@ struct hisi_qm_err_ini {
 	enum acc_err_result (*get_err_result)(struct hisi_qm *qm);
 	bool (*dev_is_abnormal)(struct hisi_qm *qm);
 	int (*set_priv_status)(struct hisi_qm *qm);
+	void (*disable_axi_error)(struct hisi_qm *qm);
+	void (*enable_axi_error)(struct hisi_qm *qm);
 };
 
 struct hisi_qm_cap_info {
-- 
2.43.0

