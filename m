Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3472C2BA19
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B405420721
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390511AbgDCIR4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:17:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390508AbgDCIRz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 04:17:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0CF5C5C2BAA737A13302;
        Fri,  3 Apr 2020 16:17:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 3 Apr 2020 16:17:40 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Yang Shen <shenyang39@huawei.com>,
        "Shukun Tan" <tanshukun1@huawei.com>
Subject: [PATCH 4/5] crypto: hisilicon/sec2 - add controller reset support for SEC2
Date:   Fri, 3 Apr 2020 16:16:41 +0800
Message-ID: <1585901802-48945-5-git-send-email-tanshukun1@huawei.com>
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

From: Yang Shen <shenyang39@huawei.com>

Add support for controller reset in SEC driver.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 40 ++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index c76c49e..07a5f4e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -249,9 +249,8 @@ static const struct pci_device_id sec_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, sec_dev_ids);
 
-static u8 sec_get_endian(struct sec_dev *sec)
+static u8 sec_get_endian(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
 	u32 reg;
 
 	/*
@@ -279,9 +278,8 @@ static u8 sec_get_endian(struct sec_dev *sec)
 		return SEC_64BE;
 }
 
-static int sec_engine_init(struct sec_dev *sec)
+static int sec_engine_init(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
 	int ret;
 	u32 reg;
 
@@ -324,7 +322,7 @@ static int sec_engine_init(struct sec_dev *sec)
 
 	/* config endian */
 	reg = readl_relaxed(SEC_ADDR(qm, SEC_CONTROL_REG));
-	reg |= sec_get_endian(sec);
+	reg |= sec_get_endian(qm);
 	writel_relaxed(reg, SEC_ADDR(qm, SEC_CONTROL_REG));
 
 	/* Enable sm4 xts mode multiple iv */
@@ -334,10 +332,8 @@ static int sec_engine_init(struct sec_dev *sec)
 	return 0;
 }
 
-static int sec_set_user_domain_and_cache(struct sec_dev *sec)
+static int sec_set_user_domain_and_cache(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
-
 	/* qm user domain */
 	writel(AXUSER_BASE, qm->io_base + QM_ARUSER_M_CFG_1);
 	writel(ARUSER_M_CFG_ENABLE, qm->io_base + QM_ARUSER_M_CFG_ENABLE);
@@ -358,7 +354,7 @@ static int sec_set_user_domain_and_cache(struct sec_dev *sec)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), qm->io_base + QM_CACHE_CTL);
 
-	return sec_engine_init(sec);
+	return sec_engine_init(qm);
 }
 
 /* sec_debug_regs_clear() - clear the sec debug regs */
@@ -683,8 +679,6 @@ static void sec_log_hw_error(struct hisi_qm *qm, u32 err_sts)
 		}
 		errs++;
 	}
-
-	writel(err_sts, qm->io_base + SEC_CORE_INT_SOURCE);
 }
 
 static u32 sec_get_hw_err_status(struct hisi_qm *qm)
@@ -692,17 +686,37 @@ static u32 sec_get_hw_err_status(struct hisi_qm *qm)
 	return readl(qm->io_base + SEC_CORE_INT_STATUS);
 }
 
+static void sec_clear_hw_err_status(struct hisi_qm *qm, u32 err_sts)
+{
+	writel(err_sts, qm->io_base + SEC_CORE_INT_SOURCE);
+}
+
+static void sec_open_axi_master_ooo(struct hisi_qm *qm)
+{
+	u32 val;
+
+	val = readl(SEC_ADDR(qm, SEC_CONTROL_REG));
+	writel(val & SEC_AXI_SHUTDOWN_DISABLE, SEC_ADDR(qm, SEC_CONTROL_REG));
+	writel(val | SEC_AXI_SHUTDOWN_ENABLE, SEC_ADDR(qm, SEC_CONTROL_REG));
+}
+
 static const struct hisi_qm_err_ini sec_err_ini = {
+	.hw_init		= sec_set_user_domain_and_cache,
 	.hw_err_enable		= sec_hw_error_enable,
 	.hw_err_disable		= sec_hw_error_disable,
 	.get_dev_hw_err_status	= sec_get_hw_err_status,
+	.clear_dev_hw_err_status = sec_clear_hw_err_status,
 	.log_dev_hw_err		= sec_log_hw_error,
+	.open_axi_master_ooo	= sec_open_axi_master_ooo,
 	.err_info		= {
 		.ce			= QM_BASE_CE,
 		.nfe			= QM_BASE_NFE | QM_ACC_DO_TASK_TIMEOUT |
 					  QM_ACC_WB_NOT_READY_TIMEOUT,
 		.fe			= 0,
 		.msi			= QM_DB_RANDOM_INVALID,
+		.ecc_2bits_mask		= SEC_CORE_INT_STATUS_M_ECC,
+		.msi_wr_port		= BIT(0),
+		.acpi_rst		= "SRST",
 	}
 };
 
@@ -726,7 +740,7 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 
 	qm->err_ini = &sec_err_ini;
 
-	ret = sec_set_user_domain_and_cache(sec);
+	ret = sec_set_user_domain_and_cache(qm);
 	if (ret)
 		return ret;
 
@@ -783,6 +797,7 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 		qm->qp_base = SEC_PF_DEF_Q_BASE;
 		qm->qp_num = pf_q_num;
 		qm->debug.curr_qm_qp_num = pf_q_num;
+		qm->qm_list = &sec_devices;
 
 		ret = sec_pf_probe_init(sec);
 		if (ret)
@@ -936,6 +951,7 @@ static void sec_remove(struct pci_dev *pdev)
 
 static const struct pci_error_handlers sec_err_handler = {
 	.error_detected = hisi_qm_dev_err_detected,
+	.slot_reset =  hisi_qm_dev_slot_reset,
 };
 
 static struct pci_driver sec_pci_driver = {
-- 
2.7.4

