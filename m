Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A007AC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C63120721
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390515AbgDCISO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:18:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36406 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390480AbgDCISN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 04:18:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D973AB0EE68454EBB2DE;
        Fri,  3 Apr 2020 16:17:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 3 Apr 2020 16:17:38 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 2/5] crypto: hisilicon/zip - add controller reset support for zip
Date:   Fri, 3 Apr 2020 16:16:39 +0800
Message-ID: <1585901802-48945-3-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585901802-48945-1-git-send-email-tanshukun1@huawei.com>
References: <1585901802-48945-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register controller reset handle with PCIe AER.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 57 +++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index fe9d6d2..37db11f 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -62,6 +62,7 @@
 
 #define HZIP_CORE_INT_SOURCE		0x3010A0
 #define HZIP_CORE_INT_MASK_REG		0x3010A4
+#define HZIP_CORE_INT_SET		0x3010A8
 #define HZIP_CORE_INT_STATUS		0x3010AC
 #define HZIP_CORE_INT_STATUS_M_ECC	BIT(1)
 #define HZIP_CORE_SRAM_ECC_ERR_INFO	0x301148
@@ -83,6 +84,9 @@
 
 #define HZIP_SOFT_CTRL_CNT_CLR_CE	0x301000
 #define SOFT_CTRL_CNT_CLR_CE_BIT	BIT(0)
+#define HZIP_SOFT_CTRL_ZIP_CONTROL	0x30100C
+#define HZIP_AXI_SHUTDOWN_ENABLE	BIT(14)
+#define HZIP_WR_PORT			BIT(11)
 
 #define HZIP_BUF_SIZE			22
 
@@ -254,9 +258,9 @@ int zip_create_qps(struct hisi_qp **qps, int qp_num)
 	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, 0, node, qps);
 }
 
-static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
+static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 {
-	void __iomem *base = hisi_zip->qm.io_base;
+	void __iomem *base = qm->io_base;
 
 	/* qm user domain */
 	writel(AXUSER_BASE, base + QM_ARUSER_M_CFG_1);
@@ -283,7 +287,7 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
 	writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	writel(AXUSER_BASE, base + HZIP_BD_WUSER_32_63);
 
-	if (hisi_zip->qm.use_sva) {
+	if (qm->use_sva) {
 		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_RUSER_32_63);
 		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_WUSER_32_63);
 	} else {
@@ -299,6 +303,8 @@ static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
 	writel(SQC_CACHE_ENABLE | CQC_CACHE_ENABLE | SQC_CACHE_WB_ENABLE |
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
+
+	return 0;
 }
 
 static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
@@ -601,8 +607,6 @@ static void hisi_zip_log_hw_error(struct hisi_qm *qm, u32 err_sts)
 		}
 		err++;
 	}
-
-	writel(err_sts, qm->io_base + HZIP_CORE_INT_SOURCE);
 }
 
 static u32 hisi_zip_get_hw_err_status(struct hisi_qm *qm)
@@ -610,17 +614,56 @@ static u32 hisi_zip_get_hw_err_status(struct hisi_qm *qm)
 	return readl(qm->io_base + HZIP_CORE_INT_STATUS);
 }
 
+static void hisi_zip_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
+{
+	writel(err_sts, qm->io_base + HZIP_CORE_INT_SOURCE);
+}
+
+static void hisi_zip_open_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 val;
+
+	val = readl(qm->io_base + HZIP_SOFT_CTRL_ZIP_CONTROL);
+
+	writel(val & ~HZIP_AXI_SHUTDOWN_ENABLE,
+	       qm->io_base + HZIP_SOFT_CTRL_ZIP_CONTROL);
+
+	writel(val | HZIP_AXI_SHUTDOWN_ENABLE,
+	       qm->io_base + HZIP_SOFT_CTRL_ZIP_CONTROL);
+}
+
+static void hisi_zip_close_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 nfe_enb;
+
+	/* Disable ECC Mbit error report. */
+	nfe_enb = readl(qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+	writel(nfe_enb & ~HZIP_CORE_INT_STATUS_M_ECC,
+	       qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+
+	/* Inject zip ECC Mbit error to block master ooo. */
+	writel(HZIP_CORE_INT_STATUS_M_ECC,
+	       qm->io_base + HZIP_CORE_INT_SET);
+}
+
 static const struct hisi_qm_err_ini hisi_zip_err_ini = {
+	.hw_init		= hisi_zip_set_user_domain_and_cache,
 	.hw_err_enable		= hisi_zip_hw_error_enable,
 	.hw_err_disable		= hisi_zip_hw_error_disable,
 	.get_dev_hw_err_status	= hisi_zip_get_hw_err_status,
+	.clear_dev_hw_err_status = hisi_zip_clear_hw_err_status,
 	.log_dev_hw_err		= hisi_zip_log_hw_error,
+	.open_axi_master_ooo	= hisi_zip_open_axi_master_ooo,
+	.close_axi_master_ooo	= hisi_zip_close_axi_master_ooo,
 	.err_info		= {
 		.ce			= QM_BASE_CE,
 		.nfe			= QM_BASE_NFE |
 					  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe			= 0,
 		.msi			= QM_DB_RANDOM_INVALID,
+		.ecc_2bits_mask		= HZIP_CORE_INT_STATUS_M_ECC,
+		.msi_wr_port		= HZIP_WR_PORT,
+		.acpi_rst		= "ZRST",
 	}
 };
 
@@ -651,7 +694,7 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 
 	qm->err_ini = &hisi_zip_err_ini;
 
-	hisi_zip_set_user_domain_and_cache(hisi_zip);
+	hisi_zip_set_user_domain_and_cache(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(hisi_zip);
 
@@ -697,6 +740,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		qm->qp_base = HZIP_PF_DEF_Q_BASE;
 		qm->qp_num = pf_q_num;
+		qm->qm_list = &zip_devices;
 	} else if (qm->fun_type == QM_HW_VF) {
 		/*
 		 * have no way to get qm configure in VM in v1 hardware,
@@ -764,6 +808,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 
 static const struct pci_error_handlers hisi_zip_err_handler = {
 	.error_detected	= hisi_qm_dev_err_detected,
+	.slot_reset	= hisi_qm_dev_slot_reset,
 };
 
 static struct pci_driver hisi_zip_pci_driver = {
-- 
2.7.4

