Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D9CC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 766C02078D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGJHmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 03:42:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGJHlg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 03:41:36 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BDDEFE5A13F98D4BEC88;
        Fri, 10 Jul 2020 15:41:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 10 Jul 2020 15:41:24 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/6] crypto: hisilicon/hpre - disable FLR triggered by hardware
Date:   Fri, 10 Jul 2020 15:40:46 +0800
Message-ID: <1594366846-1313-7-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
References: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

for Hi1620 hardware, we should disable these hardware flr:
1. BME_FLR - bit 7,
2. PM_FLR - bit 11,
3. SRIOV_FLR - bit 12,
Or HPRE may goto D3 state, when we bind and unbind HPRE quickly,
as it does FLR triggered by BME/PM/SRIOV.

Fixes: c8b4b477079d("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index b69cea3..b135c74 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -82,6 +82,10 @@
 #define HPRE_CORE_ECC_2BIT_ERR		BIT(1)
 #define HPRE_OOO_ECC_2BIT_ERR		BIT(5)
 
+#define HPRE_QM_BME_FLR			BIT(7)
+#define HPRE_QM_PM_FLR			BIT(11)
+#define HPRE_QM_SRIOV_FLR		BIT(12)
+
 #define HPRE_VIA_MSI_DSM		1
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
@@ -230,6 +234,22 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 	return 0;
 }
 
+/*
+ * For Hi1620, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
+ * Or it may stay in D3 state when we bind and unbind hpre quickly,
+ * as it does FLR triggered by hardware.
+ */
+static void disable_flr_of_bme(struct hisi_qm *qm)
+{
+	u32 val;
+
+	val = readl(HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
+	val &= ~(HPRE_QM_BME_FLR | HPRE_QM_SRIOV_FLR);
+	val |= HPRE_QM_PM_FLR;
+	writel(val, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
+	writel(PEH_AXUSER_CFG_ENABLE, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG_ENABLE));
+}
+
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -241,10 +261,6 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_AWUSER_M_CFG_ENABLE));
 	writel_relaxed(HPRE_QM_AXI_CFG_MASK, HPRE_ADDR(qm, QM_AXI_M_CFG));
 
-	/* disable FLR triggered by BME(bus master enable) */
-	writel(PEH_AXUSER_CFG, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
-	writel(PEH_AXUSER_CFG_ENABLE, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG_ENABLE));
-
 	/* HPRE need more time, we close this interrupt */
 	val = readl_relaxed(HPRE_ADDR(qm, HPRE_QM_ABNML_INT_MASK));
 	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
@@ -295,6 +311,8 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	if (ret)
 		dev_err(dev, "acpi_evaluate_dsm err.\n");
 
+	disable_flr_of_bme(qm);
+
 	return ret;
 }
 
-- 
2.8.1

