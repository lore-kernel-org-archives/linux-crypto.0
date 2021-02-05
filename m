Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C6DC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A156564F38
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBEK3C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:29:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12136 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhBEKQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:07 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DXB8r2mjkz164xQ;
        Fri,  5 Feb 2021 18:14:04 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:14 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 5/6] crypto: hisilicon/qm - do not reset hardware when CE happens
Date:   Fri, 5 Feb 2021 18:12:57 +0800
Message-ID: <1612519978-33340-6-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need to reset hardware when Corrected Error(CE) happens.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  1 +
 drivers/crypto/hisilicon/qm.c             | 23 +++++++++++++++++------
 drivers/crypto/hisilicon/qm.h             |  1 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |  1 +
 drivers/crypto/hisilicon/zip/zip_main.c   |  5 ++++-
 5 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index ef2fe4d..6681e9a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -848,6 +848,7 @@ static const struct hisi_qm_err_ini hpre_err_ini = {
 		.fe			= 0,
 		.ecc_2bits_mask		= HPRE_CORE_ECC_2BIT_ERR |
 					  HPRE_OOO_ECC_2BIT_ERR,
+		.dev_ce_mask		= HPRE_HAC_RAS_CE_ENABLE,
 		.msi_wr_port		= HPRE_WR_MSI_PORT,
 		.acpi_rst		= "HRST",
 	}
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ec7d068..5dbc054 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1610,7 +1610,7 @@ static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 
 static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 {
-	u32 error_status, tmp;
+	u32 error_status, tmp, val;
 
 	/* read err sts */
 	tmp = readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
@@ -1621,9 +1621,13 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 			qm->err_status.is_qm_ecc_mbit = true;
 
 		qm_log_hw_error(qm, error_status);
-		if (error_status == QM_DB_RANDOM_INVALID) {
+		val = error_status | QM_DB_RANDOM_INVALID | QM_BASE_CE;
+		/* ce error does not need to be reset */
+		if (val == (QM_DB_RANDOM_INVALID | QM_BASE_CE)) {
 			writel(error_status, qm->io_base +
 			       QM_ABNORMAL_INT_SOURCE);
+			writel(qm->err_ini->err_info.nfe,
+			       qm->io_base + QM_RAS_NFE_ENABLE);
 			return ACC_ERR_RECOVERED;
 		}
 
@@ -3302,12 +3306,19 @@ static enum acc_err_result qm_dev_err_handle(struct hisi_qm *qm)
 		if (err_sts & qm->err_ini->err_info.ecc_2bits_mask)
 			qm->err_status.is_dev_ecc_mbit = true;
 
-		if (!qm->err_ini->log_dev_hw_err) {
-			dev_err(&qm->pdev->dev, "Device doesn't support log hw error!\n");
-			return ACC_ERR_NEED_RESET;
+		if (qm->err_ini->log_dev_hw_err)
+			qm->err_ini->log_dev_hw_err(qm, err_sts);
+
+		/* ce error does not need to be reset */
+		if ((err_sts | qm->err_ini->err_info.dev_ce_mask) ==
+		     qm->err_ini->err_info.dev_ce_mask) {
+			if (qm->err_ini->clear_dev_hw_err_status)
+				qm->err_ini->clear_dev_hw_err_status(qm,
+								err_sts);
+
+			return ACC_ERR_RECOVERED;
 		}
 
-		qm->err_ini->log_dev_hw_err(qm, err_sts);
 		return ACC_ERR_NEED_RESET;
 	}
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index c08ffe3..6be5338 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -173,6 +173,7 @@ struct hisi_qm_err_info {
 	char *acpi_rst;
 	u32 msi_wr_port;
 	u32 ecc_2bits_mask;
+	u32 dev_ce_mask;
 	u32 ce;
 	u32 nfe;
 	u32 fe;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 7db0e86..73866f2 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -752,6 +752,7 @@ static const struct hisi_qm_err_ini sec_err_ini = {
 				  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe		= 0,
 		.ecc_2bits_mask	= SEC_CORE_INT_STATUS_M_ECC,
+		.dev_ce_mask	= SEC_RAS_CE_ENB_MSK,
 		.msi_wr_port	= BIT(0),
 		.acpi_rst	= "SRST",
 	}
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index c5609f4..ca02e9c 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -66,6 +66,7 @@
 #define HZIP_CORE_INT_STATUS_M_ECC	BIT(1)
 #define HZIP_CORE_SRAM_ECC_ERR_INFO	0x301148
 #define HZIP_CORE_INT_RAS_CE_ENB	0x301160
+#define HZIP_CORE_INT_RAS_CE_ENABLE	0x1
 #define HZIP_CORE_INT_RAS_NFE_ENB	0x301164
 #define HZIP_CORE_INT_RAS_FE_ENB        0x301168
 #define HZIP_CORE_INT_RAS_NFE_ENABLE	0x7FE
@@ -327,7 +328,8 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 	writel(HZIP_CORE_INT_MASK_ALL, qm->io_base + HZIP_CORE_INT_SOURCE);
 
 	/* configure error type */
-	writel(0x1, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
+	writel(HZIP_CORE_INT_RAS_CE_ENABLE,
+	       qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
 	writel(0x0, qm->io_base + HZIP_CORE_INT_RAS_FE_ENB);
 	writel(HZIP_CORE_INT_RAS_NFE_ENABLE,
 	       qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
@@ -727,6 +729,7 @@ static const struct hisi_qm_err_ini hisi_zip_err_ini = {
 					  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe			= 0,
 		.ecc_2bits_mask		= HZIP_CORE_INT_STATUS_M_ECC,
+		.dev_ce_mask		= HZIP_CORE_INT_RAS_CE_ENABLE,
 		.msi_wr_port		= HZIP_WR_PORT,
 		.acpi_rst		= "ZRST",
 	}
-- 
2.8.1

