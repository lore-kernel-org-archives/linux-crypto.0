Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E39C2BA15
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0728020721
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbgDCISI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:18:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12677 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390467AbgDCISI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 04:18:08 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 03D6624E6752FE023323;
        Fri,  3 Apr 2020 16:17:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 3 Apr 2020 16:17:39 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Hui Tang <tanghui20@huawei.com>,
        "Shukun Tan" <tanshukun1@huawei.com>
Subject: [PATCH 3/5] crypto: hisilicon/hpre - add controller reset support for HPRE
Date:   Fri, 3 Apr 2020 16:16:40 +0800
Message-ID: <1585901802-48945-4-git-send-email-tanshukun1@huawei.com>
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

From: Hui Tang <tanghui20@huawei.com>

Add support for the controller reset in HPRE driver.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 46 +++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 9cff5c1..0d63666 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -59,10 +59,6 @@
 #define HPRE_HAC_ECC2_CNT		0x301a08
 #define HPRE_HAC_INT_STATUS		0x301800
 #define HPRE_HAC_SOURCE_INT		0x301600
-#define MASTER_GLOBAL_CTRL_SHUTDOWN	1
-#define MASTER_TRANS_RETURN_RW		3
-#define HPRE_MASTER_TRANS_RETURN	0x300150
-#define HPRE_MASTER_GLOBAL_CTRL		0x300000
 #define HPRE_CLSTR_ADDR_INTRVL		0x1000
 #define HPRE_CLUSTER_INQURY		0x100
 #define HPRE_CLSTR_ADDR_INQRY_RSLT	0x104
@@ -80,6 +76,13 @@
 #define HPRE_BD_USR_MASK		0x3
 #define HPRE_CLUSTER_CORE_MASK		0xf
 
+#define HPRE_AM_OOO_SHUTDOWN_ENB	0x301044
+#define HPRE_AM_OOO_SHUTDOWN_ENABLE	BIT(0)
+#define HPRE_WR_MSI_PORT		BIT(2)
+
+#define HPRE_CORE_ECC_2BIT_ERR		BIT(1)
+#define HPRE_OOO_ECC_2BIT_ERR		BIT(5)
+
 #define HPRE_VIA_MSI_DSM		1
 
 static struct hisi_qm_list hpre_devices;
@@ -241,9 +244,8 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 	return 0;
 }
 
-static int hpre_set_user_domain_and_cache(struct hpre *hpre)
+static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hpre->qm;
 	struct device *dev = &qm->pdev->dev;
 	unsigned long offset;
 	int ret, i;
@@ -339,6 +341,9 @@ static void hpre_hw_error_disable(struct hisi_qm *qm)
 
 static void hpre_hw_error_enable(struct hisi_qm *qm)
 {
+	/* clear HPRE hw error source if having */
+	writel(HPRE_CORE_INT_DISABLE, qm->io_base + HPRE_HAC_SOURCE_INT);
+
 	/* enable hpre hw error interrupts */
 	writel(HPRE_CORE_INT_ENABLE, qm->io_base + HPRE_INT_MASK);
 	writel(HPRE_HAC_RAS_CE_ENABLE, qm->io_base + HPRE_RAS_CE_ENB);
@@ -700,8 +705,6 @@ static void hpre_log_hw_error(struct hisi_qm *qm, u32 err_sts)
 				 err->msg, err->int_msk);
 		err++;
 	}
-
-	writel(err_sts, qm->io_base + HPRE_HAC_SOURCE_INT);
 }
 
 static u32 hpre_get_hw_err_status(struct hisi_qm *qm)
@@ -709,16 +712,39 @@ static u32 hpre_get_hw_err_status(struct hisi_qm *qm)
 	return readl(qm->io_base + HPRE_HAC_INT_STATUS);
 }
 
+static void hpre_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
+{
+	writel(err_sts, qm->io_base + HPRE_HAC_SOURCE_INT);
+}
+
+static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 value;
+
+	value = readl(qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
+	writel(value & ~HPRE_AM_OOO_SHUTDOWN_ENABLE,
+	       HPRE_ADDR(qm, HPRE_AM_OOO_SHUTDOWN_ENB));
+	writel(value | HPRE_AM_OOO_SHUTDOWN_ENABLE,
+	       HPRE_ADDR(qm, HPRE_AM_OOO_SHUTDOWN_ENB));
+}
+
 static const struct hisi_qm_err_ini hpre_err_ini = {
+	.hw_init		= hpre_set_user_domain_and_cache,
 	.hw_err_enable		= hpre_hw_error_enable,
 	.hw_err_disable		= hpre_hw_error_disable,
 	.get_dev_hw_err_status	= hpre_get_hw_err_status,
+	.clear_dev_hw_err_status = hpre_clear_hw_err_status,
 	.log_dev_hw_err		= hpre_log_hw_error,
+	.open_axi_master_ooo	= hpre_open_axi_master_ooo,
 	.err_info		= {
 		.ce			= QM_BASE_CE,
 		.nfe			= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT,
 		.fe			= 0,
 		.msi			= QM_DB_RANDOM_INVALID,
+		.ecc_2bits_mask		= HPRE_CORE_ECC_2BIT_ERR |
+					  HPRE_OOO_ECC_2BIT_ERR,
+		.msi_wr_port		= HPRE_WR_MSI_PORT,
+		.acpi_rst		= "HRST",
 	}
 };
 
@@ -729,10 +755,11 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 
 	qm->ctrl_qp_num = HPRE_QUEUE_NUM_V2;
 
-	ret = hpre_set_user_domain_and_cache(hpre);
+	ret = hpre_set_user_domain_and_cache(qm);
 	if (ret)
 		return ret;
 
+	qm->qm_list = &hpre_devices;
 	qm->err_ini = &hpre_err_ini;
 	hisi_qm_dev_err_init(qm);
 
@@ -840,6 +867,7 @@ static void hpre_remove(struct pci_dev *pdev)
 
 static const struct pci_error_handlers hpre_err_handler = {
 	.error_detected		= hisi_qm_dev_err_detected,
+	.slot_reset		= hisi_qm_dev_slot_reset,
 };
 
 static struct pci_driver hpre_pci_driver = {
-- 
2.7.4

