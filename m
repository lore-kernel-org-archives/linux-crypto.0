Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0320C43460
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 818B26128A
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241072AbhDLMer (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:34:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16576 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241049AbhDLMeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Apr 2021 08:34:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FJp5l1jnhz18H67;
        Mon, 12 Apr 2021 20:32:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 12 Apr 2021 20:34:16 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon - dynamic configuration 'err_info'
Date:   Mon, 12 Apr 2021 20:31:32 +0800
Message-ID: <1618230695-22775-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
References: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'err_info' does not support dynamic configuration since it is const type.
Therefore, in order to support new error type later, 'err_info' is changed
to dynamic configuration.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 26 ++++++++++++++++----------
 drivers/crypto/hisilicon/qm.c             | 22 ++++++++++------------
 drivers/crypto/hisilicon/qm.h             |  3 ++-
 drivers/crypto/hisilicon/sec2/sec_main.c  | 26 ++++++++++++++++----------
 drivers/crypto/hisilicon/zip/zip_main.c   | 25 +++++++++++++++----------
 5 files changed, 59 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a8c7921..7fe7434 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -807,6 +807,20 @@ static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
 	       HPRE_ADDR(qm, HPRE_AM_OOO_SHUTDOWN_ENB));
 }
 
+static void hpre_err_info_init(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_info *err_info = &qm->err_info;
+
+	err_info->ce = QM_BASE_CE;
+	err_info->fe = 0;
+	err_info->ecc_2bits_mask = HPRE_CORE_ECC_2BIT_ERR |
+				   HPRE_OOO_ECC_2BIT_ERR;
+	err_info->dev_ce_mask = HPRE_HAC_RAS_CE_ENABLE;
+	err_info->msi_wr_port = HPRE_WR_MSI_PORT;
+	err_info->acpi_rst = "HRST";
+	err_info->nfe = QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT;
+}
+
 static const struct hisi_qm_err_ini hpre_err_ini = {
 	.hw_init		= hpre_set_user_domain_and_cache,
 	.hw_err_enable		= hpre_hw_error_enable,
@@ -815,16 +829,7 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 	.clear_dev_hw_err_status = hpre_clear_hw_err_status,
 	.log_dev_hw_err		= hpre_log_hw_error,
 	.open_axi_master_ooo	= hpre_open_axi_master_ooo,
-	.err_info		= {
-		.ce			= QM_BASE_CE,
-		.nfe			= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT,
-		.fe			= 0,
-		.ecc_2bits_mask		= HPRE_CORE_ECC_2BIT_ERR |
-					  HPRE_OOO_ECC_2BIT_ERR,
-		.dev_ce_mask		= HPRE_HAC_RAS_CE_ENABLE,
-		.msi_wr_port		= HPRE_WR_MSI_PORT,
-		.acpi_rst		= "HRST",
-	}
+	.err_info_init		= hpre_err_info_init,
 };
 
 static int hpre_pf_probe_init(struct hpre *hpre)
@@ -837,6 +842,7 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 		return ret;
 
 	qm->err_ini = &hpre_err_ini;
+	qm->err_ini->err_info_init(qm);
 	hisi_qm_dev_err_init(qm);
 
 	return 0;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 35e6b58..deab797 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1700,7 +1700,7 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 		if (val == (QM_DB_RANDOM_INVALID | QM_BASE_CE)) {
 			writel(error_status, qm->io_base +
 			       QM_ABNORMAL_INT_SOURCE);
-			writel(qm->err_ini->err_info.nfe,
+			writel(qm->err_info.nfe,
 			       qm->io_base + QM_RAS_NFE_ENABLE);
 			return ACC_ERR_RECOVERED;
 		}
@@ -3080,7 +3080,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_debug_regs_clear);
 
 static void qm_hw_error_init(struct hisi_qm *qm)
 {
-	const struct hisi_qm_err_info *err_info = &qm->err_ini->err_info;
+	struct hisi_qm_err_info *err_info = &qm->err_info;
 
 	if (!qm->ops->hw_error_init) {
 		dev_err(&qm->pdev->dev, "QM doesn't support hw error handling!\n");
@@ -3432,15 +3432,15 @@ static enum acc_err_result qm_dev_err_handle(struct hisi_qm *qm)
 	/* get device hardware error status */
 	err_sts = qm->err_ini->get_dev_hw_err_status(qm);
 	if (err_sts) {
-		if (err_sts & qm->err_ini->err_info.ecc_2bits_mask)
+		if (err_sts & qm->err_info.ecc_2bits_mask)
 			qm->err_status.is_dev_ecc_mbit = true;
 
 		if (qm->err_ini->log_dev_hw_err)
 			qm->err_ini->log_dev_hw_err(qm, err_sts);
 
 		/* ce error does not need to be reset */
-		if ((err_sts | qm->err_ini->err_info.dev_ce_mask) ==
-		     qm->err_ini->err_info.dev_ce_mask) {
+		if ((err_sts | qm->err_info.dev_ce_mask) ==
+		     qm->err_info.dev_ce_mask) {
 			if (qm->err_ini->clear_dev_hw_err_status)
 				qm->err_ini->clear_dev_hw_err_status(qm,
 								err_sts);
@@ -3753,7 +3753,7 @@ static int qm_soft_reset(struct hisi_qm *qm)
 		acpi_status s;
 
 		s = acpi_evaluate_integer(ACPI_HANDLE(&pdev->dev),
-					  qm->err_ini->err_info.acpi_rst,
+					  qm->err_info.acpi_rst,
 					  NULL, &value);
 		if (ACPI_FAILURE(s)) {
 			pci_err(pdev, "NO controller reset method!\n");
@@ -3821,12 +3821,11 @@ static void qm_restart_prepare(struct hisi_qm *qm)
 
 	/* temporarily close the OOO port used for PEH to write out MSI */
 	value = readl(qm->io_base + ACC_AM_CFG_PORT_WR_EN);
-	writel(value & ~qm->err_ini->err_info.msi_wr_port,
+	writel(value & ~qm->err_info.msi_wr_port,
 	       qm->io_base + ACC_AM_CFG_PORT_WR_EN);
 
 	/* clear dev ecc 2bit error source if having */
-	value = qm_get_dev_err_status(qm) &
-		qm->err_ini->err_info.ecc_2bits_mask;
+	value = qm_get_dev_err_status(qm) & qm->err_info.ecc_2bits_mask;
 	if (value && qm->err_ini->clear_dev_hw_err_status)
 		qm->err_ini->clear_dev_hw_err_status(qm, value);
 
@@ -3850,7 +3849,7 @@ static void qm_restart_done(struct hisi_qm *qm)
 
 	/* open the OOO port for PEH to write out MSI */
 	value = readl(qm->io_base + ACC_AM_CFG_PORT_WR_EN);
-	value |= qm->err_ini->err_info.msi_wr_port;
+	value |= qm->err_info.msi_wr_port;
 	writel(value, qm->io_base + ACC_AM_CFG_PORT_WR_EN);
 
 	qm->err_status.is_qm_ecc_mbit = false;
@@ -3989,8 +3988,7 @@ static int qm_check_dev_error(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
-	return (qm_get_dev_err_status(qm) &
-		qm->err_ini->err_info.ecc_2bits_mask);
+	return (qm_get_dev_err_status(qm) & qm->err_info.ecc_2bits_mask);
 }
 
 void hisi_qm_reset_prepare(struct pci_dev *pdev)
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 34e69fe..8c67712 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -186,7 +186,7 @@ struct hisi_qm_err_ini {
 	void (*open_axi_master_ooo)(struct hisi_qm *qm);
 	void (*close_axi_master_ooo)(struct hisi_qm *qm);
 	void (*log_dev_hw_err)(struct hisi_qm *qm, u32 err_sts);
-	struct hisi_qm_err_info err_info;
+	void (*err_info_init)(struct hisi_qm *qm);
 };
 
 struct hisi_qm_list {
@@ -226,6 +226,7 @@ struct hisi_qm {
 
 	struct hisi_qm_status status;
 	const struct hisi_qm_err_ini *err_ini;
+	struct hisi_qm_err_info err_info;
 	struct hisi_qm_err_status err_status;
 	unsigned long misc_ctl; /* driver removing and reset sched */
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 1affa1b..26b9904 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -701,6 +701,20 @@ static void sec_open_axi_master_ooo(struct hisi_qm *qm)
 	writel(val | SEC_AXI_SHUTDOWN_ENABLE, qm->io_base + SEC_CONTROL_REG);
 }
 
+static void sec_err_info_init(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_info *err_info = &qm->err_info;
+
+	err_info->ce = QM_BASE_CE;
+	err_info->fe = 0;
+	err_info->ecc_2bits_mask = SEC_CORE_INT_STATUS_M_ECC;
+	err_info->dev_ce_mask = SEC_RAS_CE_ENB_MSK;
+	err_info->msi_wr_port = BIT(0);
+	err_info->acpi_rst = "SRST";
+	err_info->nfe = QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT |
+			QM_ACC_WB_NOT_READY_TIMEOUT;
+}
+
 static const struct hisi_qm_err_ini sec_err_ini = {
 	.hw_init		= sec_set_user_domain_and_cache,
 	.hw_err_enable		= sec_hw_error_enable,
@@ -709,16 +723,7 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 	.clear_dev_hw_err_status = sec_clear_hw_err_status,
 	.log_dev_hw_err		= sec_log_hw_error,
 	.open_axi_master_ooo	= sec_open_axi_master_ooo,
-	.err_info		= {
-		.ce		= QM_BASE_CE,
-		.nfe		= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT |
-				  QM_ACC_WB_NOT_READY_TIMEOUT,
-		.fe		= 0,
-		.ecc_2bits_mask	= SEC_CORE_INT_STATUS_M_ECC,
-		.dev_ce_mask	= SEC_RAS_CE_ENB_MSK,
-		.msi_wr_port	= BIT(0),
-		.acpi_rst	= "SRST",
-	}
+	.err_info_init		= sec_err_info_init,
 };
 
 static int sec_pf_probe_init(struct sec_dev *sec)
@@ -727,6 +732,7 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	int ret;
 
 	qm->err_ini = &sec_err_ini;
+	qm->err_ini->err_info_init(qm);
 
 	ret = sec_set_user_domain_and_cache(qm);
 	if (ret)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4d2e9c8..50407bb 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -657,6 +657,19 @@ static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
 	       qm->io_base + HZIP_CORE_INT_SET);
 }
 
+static void hisi_zip_err_info_init(struct hisi_qm *qm)
+{
+	struct hisi_qm_err_info *err_info = &qm->err_info;
+
+	err_info->ce = QM_BASE_CE;
+	err_info->fe = 0;
+	err_info->ecc_2bits_mask = HZIP_CORE_INT_STATUS_M_ECC;
+	err_info->dev_ce_mask = HZIP_CORE_INT_RAS_CE_ENABLE;
+	err_info->msi_wr_port = HZIP_WR_PORT;
+	err_info->acpi_rst = "ZRST";
+	err_info->nfe = QM_BASE_NFE | QM_ACC_WB_NOT_READY_TIMEOUT;
+}
+
 static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.hw_init		= hisi_zip_set_user_domain_and_cache,
 	.hw_err_enable		= hisi_zip_hw_error_enable,
@@ -666,16 +679,7 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 	.log_dev_hw_err		= hisi_zip_log_hw_error,
 	.open_axi_master_ooo	= hisi_zip_open_axi_master_ooo,
 	.close_axi_master_ooo	= hisi_zip_close_axi_master_ooo,
-	.err_info		= {
-		.ce			= QM_BASE_CE,
-		.nfe			= QM_BASE_NFE |
-					  QM_ACC_WB_NOT_READY_TIMEOUT,
-		.fe			= 0,
-		.ecc_2bits_mask		= HZIP_CORE_INT_STATUS_M_ECC,
-		.dev_ce_mask		= HZIP_CORE_INT_RAS_CE_ENABLE,
-		.msi_wr_port		= HZIP_WR_PORT,
-		.acpi_rst		= "ZRST",
-	}
+	.err_info_init		= hisi_zip_err_info_init,
 };
 
 static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
@@ -690,6 +694,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	hisi_zip->ctrl = ctrl;
 	ctrl->hisi_zip = hisi_zip;
 	qm->err_ini = &hisi_zip_err_ini;
+	qm->err_ini->err_info_init(qm);
 
 	hisi_zip_set_user_domain_and_cache(qm);
 	hisi_qm_dev_err_init(qm);
-- 
2.8.1

