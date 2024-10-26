Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2931D0F44;
	Sat, 26 Oct 2024 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729943089; cv=none; b=i9DuUH0G1mbu1Dcia+XDk6lCQfVjoPhRTxv7HnXshHDK7c3A5Z8ov/8VM0RLbH1Wv4j45y9nZdBeqsGKAgVRycdAy25XfqpvyQHxjae9XGmDCcIcMpxu44VrKiZU0ydTX2IrmiaDcQsuY/BkUI0qpZsbNgCR0YMkN1RIwbpYlvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729943089; c=relaxed/simple;
	bh=/O1tFky8fUiRfdLY53ZNMM7BmBaQMWx+CynXTfViA2s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xqv4FIfMF4gxAw9jhsXZSe8QyRyQALFbAOJGMIQtiNBXaD7YLewf67iCCAU5vuIiOCsSgmfK8rGi1Nqq1lCnhOk9+hU2z3hX8txEWf0ztEmPCmGLcCDwyIDMLe3H6mahVf4UMTaCjUrpzMvpzlPHs1dYbhTA3uc3nAWrSabzGzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XbHnl59sHz1T8xX;
	Sat, 26 Oct 2024 19:42:35 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A2B41400E3;
	Sat, 26 Oct 2024 19:44:41 +0800 (CST)
Received: from ubuntu.huawei.com (10.69.192.56) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Oct 2024 19:44:40 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - disable same error report before resetting
Date: Sat, 26 Oct 2024 19:44:29 +0800
Message-ID: <20241026114429.54090-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemk500010.china.huawei.com (7.202.194.95)

If an error indicating that the device needs to be reset is reported,
disable the error reporting before device reset is complete,
enable the error reporting after the reset is complete to prevent
the same error from being reported repeatedly.

Fixes: eaebf4c3b103 ("crypto: hisilicon - Unify hardware error init/uninit into QM")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 35 ++++++++++++++---
 drivers/crypto/hisilicon/qm.c             | 47 +++++++----------------
 drivers/crypto/hisilicon/sec2/sec_main.c  | 35 ++++++++++++++---
 drivers/crypto/hisilicon/zip/zip_main.c   | 35 ++++++++++++++---
 include/linux/hisi_acc_qm.h               |  8 +++-
 5 files changed, 110 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index f129878559c8..3132f08d5e7d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1292,11 +1292,15 @@ static u32 hpre_get_hw_err_status(struct hisi_qm *qm)
 
 static void hpre_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + HPRE_HAC_SOURCE_INT);
-	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + HPRE_RAS_NFE_ENB);
+}
+
+static void hpre_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + HPRE_RAS_NFE_ENB);
 }
 
 static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1310,6 +1314,27 @@ static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
 	       qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 }
 
+static enum acc_err_result hpre_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hpre_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		hpre_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			hpre_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		hpre_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void hpre_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1336,12 +1361,12 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 	.hw_err_disable		= hpre_hw_error_disable,
 	.get_dev_hw_err_status	= hpre_get_hw_err_status,
 	.clear_dev_hw_err_status = hpre_clear_hw_err_status,
-	.log_dev_hw_err		= hpre_log_hw_error,
 	.open_axi_master_ooo	= hpre_open_axi_master_ooo,
 	.open_sva_prefetch	= hpre_open_sva_prefetch,
 	.close_sva_prefetch	= hpre_close_sva_prefetch,
 	.show_last_dfx_regs	= hpre_show_last_dfx_regs,
 	.err_info_init		= hpre_err_info_init,
+	.get_err_result		= hpre_get_err_result,
 };
 
 static int hpre_pf_probe_init(struct hpre *hpre)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f7e8237e3a93..eebc5557a088 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -271,12 +271,6 @@ enum vft_type {
 	SHAPER_VFT,
 };
 
-enum acc_err_result {
-	ACC_ERR_NONE,
-	ACC_ERR_NEED_RESET,
-	ACC_ERR_RECOVERED,
-};
-
 enum qm_alg_type {
 	ALG_TYPE_0,
 	ALG_TYPE_1,
@@ -1456,22 +1450,25 @@ static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 
 static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 {
-	u32 error_status, tmp;
-
-	/* read err sts */
-	tmp = readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
-	error_status = qm->error_mask & tmp;
+	u32 error_status;
 
-	if (error_status) {
+	error_status = qm_get_hw_error_status(qm);
+	if (error_status & qm->error_mask) {
 		if (error_status & QM_ECC_MBIT)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
-		if (error_status & qm->err_info.qm_reset_mask)
+		if (error_status & qm->err_info.qm_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			writel(qm->err_info.nfe & (~error_status),
+			       qm->io_base + QM_RAS_NFE_ENABLE);
 			return ACC_ERR_NEED_RESET;
+		}
 
+		/* Clear error source if not need reset. */
 		writel(error_status, qm->io_base + QM_ABNORMAL_INT_SOURCE);
 		writel(qm->err_info.nfe, qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(qm->err_info.ce, qm->io_base + QM_RAS_CE_ENABLE);
 	}
 
 	return ACC_ERR_RECOVERED;
@@ -3892,30 +3889,12 @@ EXPORT_SYMBOL_GPL(hisi_qm_sriov_configure);
 
 static enum acc_err_result qm_dev_err_handle(struct hisi_qm *qm)
 {
-	u32 err_sts;
-
-	if (!qm->err_ini->get_dev_hw_err_status) {
-		dev_err(&qm->pdev->dev, "Device doesn't support get hw error status!\n");
+	if (!qm->err_ini->get_err_result) {
+		dev_err(&qm->pdev->dev, "Device doesn't support reset!\n");
 		return ACC_ERR_NONE;
 	}
 
-	/* get device hardware error status */
-	err_sts = qm->err_ini->get_dev_hw_err_status(qm);
-	if (err_sts) {
-		if (err_sts & qm->err_info.ecc_2bits_mask)
-			qm->err_status.is_dev_ecc_mbit = true;
-
-		if (qm->err_ini->log_dev_hw_err)
-			qm->err_ini->log_dev_hw_err(qm, err_sts);
-
-		if (err_sts & qm->err_info.dev_reset_mask)
-			return ACC_ERR_NEED_RESET;
-
-		if (qm->err_ini->clear_dev_hw_err_status)
-			qm->err_ini->clear_dev_hw_err_status(qm, err_sts);
-	}
-
-	return ACC_ERR_RECOVERED;
+	return qm->err_ini->get_err_result(qm);
 }
 
 static enum acc_err_result qm_process_dev_error(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 3abd12017250..9300776dd191 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1010,11 +1010,15 @@ static u32 sec_get_hw_err_status(struct hisi_qm *qm)
 
 static void sec_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + SEC_CORE_INT_SOURCE);
-	nfe = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + SEC_RAS_NFE_REG);
+}
+
+static void sec_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, sec_basic_info, SEC_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + SEC_RAS_NFE_REG);
 }
 
 static void sec_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1026,6 +1030,27 @@ static void sec_open_axi_master_ooo(struct hisi_qm *qm)
 	writel(val | SEC_AXI_SHUTDOWN_ENABLE, qm->io_base + SEC_CONTROL_REG);
 }
 
+static enum acc_err_result sec_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = sec_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		sec_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			sec_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		sec_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void sec_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1052,12 +1077,12 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 	.hw_err_disable		= sec_hw_error_disable,
 	.get_dev_hw_err_status	= sec_get_hw_err_status,
 	.clear_dev_hw_err_status = sec_clear_hw_err_status,
-	.log_dev_hw_err		= sec_log_hw_error,
 	.open_axi_master_ooo	= sec_open_axi_master_ooo,
 	.open_sva_prefetch	= sec_open_sva_prefetch,
 	.close_sva_prefetch	= sec_close_sva_prefetch,
 	.show_last_dfx_regs	= sec_show_last_dfx_regs,
 	.err_info_init		= sec_err_info_init,
+	.get_err_result		= sec_get_err_result,
 };
 
 static int sec_pf_probe_init(struct sec_dev *sec)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f547e6732bf5..bb77edd772c2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1059,11 +1059,15 @@ static u32 hisi_zip_get_hw_err_status(struct hisi_qm *qm)
 
 static void hisi_zip_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
 {
-	u32 nfe;
-
 	writel(err_sts, qm->io_base + HZIP_CORE_INT_SOURCE);
-	nfe = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
-	writel(nfe, qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+}
+
+static void hisi_zip_disable_error_report(struct hisi_qm *qm, u32 err_type)
+{
+	u32 nfe_mask;
+
+	nfe_mask = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_NFE_MASK_CAP, qm->cap_ver);
+	writel(nfe_mask & (~err_type), qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
 }
 
 static void hisi_zip_open_axi_master_ooo(struct hisi_qm *qm)
@@ -1093,6 +1097,27 @@ static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
 	       qm->io_base + HZIP_CORE_INT_SET);
 }
 
+static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
+{
+	u32 err_status;
+
+	err_status = hisi_zip_get_hw_err_status(qm);
+	if (err_status) {
+		if (err_status & qm->err_info.ecc_2bits_mask)
+			qm->err_status.is_dev_ecc_mbit = true;
+		hisi_zip_log_hw_error(qm, err_status);
+
+		if (err_status & qm->err_info.dev_reset_mask) {
+			/* Disable the same error reporting until device is recovered. */
+			hisi_zip_disable_error_report(qm, err_status);
+			return ACC_ERR_NEED_RESET;
+		}
+		hisi_zip_clear_hw_err_status(qm, err_status);
+	}
+
+	return ACC_ERR_RECOVERED;
+}
+
 static void hisi_zip_err_info_init(struct hisi_qm *qm)
 {
 	struct hisi_qm_err_info *err_info = &qm->err_info;
@@ -1120,13 +1145,13 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.hw_err_disable		= hisi_zip_hw_error_disable,
 	.get_dev_hw_err_status	= hisi_zip_get_hw_err_status,
 	.clear_dev_hw_err_status = hisi_zip_clear_hw_err_status,
-	.log_dev_hw_err		= hisi_zip_log_hw_error,
 	.open_axi_master_ooo	= hisi_zip_open_axi_master_ooo,
 	.close_axi_master_ooo	= hisi_zip_close_axi_master_ooo,
 	.open_sva_prefetch	= hisi_zip_open_sva_prefetch,
 	.close_sva_prefetch	= hisi_zip_close_sva_prefetch,
 	.show_last_dfx_regs	= hisi_zip_show_last_dfx_regs,
 	.err_info_init		= hisi_zip_err_info_init,
+	.get_err_result		= hisi_zip_get_err_result,
 };
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 389e95754776..ad8dbc063a75 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -229,6 +229,12 @@ struct hisi_qm_status {
 
 struct hisi_qm;
 
+enum acc_err_result {
+	ACC_ERR_NONE,
+	ACC_ERR_NEED_RESET,
+	ACC_ERR_RECOVERED,
+};
+
 struct hisi_qm_err_info {
 	char *acpi_rst;
 	u32 msi_wr_port;
@@ -257,9 +263,9 @@ struct hisi_qm_err_ini {
 	void (*close_axi_master_ooo)(struct hisi_qm *qm);
 	void (*open_sva_prefetch)(struct hisi_qm *qm);
 	void (*close_sva_prefetch)(struct hisi_qm *qm);
-	void (*log_dev_hw_err)(struct hisi_qm *qm, u32 err_sts);
 	void (*show_last_dfx_regs)(struct hisi_qm *qm);
 	void (*err_info_init)(struct hisi_qm *qm);
+	enum acc_err_result (*get_err_result)(struct hisi_qm *qm);
 };
 
 struct hisi_qm_cap_info {
-- 
2.33.0

