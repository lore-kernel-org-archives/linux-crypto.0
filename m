Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E39C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290F22085B
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGBCcH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:32:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728159AbgGBCcG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 22:32:06 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DEC43EEBFC70642ABB3D;
        Thu,  2 Jul 2020 10:32:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 10:31:53 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] crypto: hisilicon/hpre - disable FLR triggered by hardware
Date:   Thu, 2 Jul 2020 10:31:19 +0800
Message-ID: <1593657079-31990-7-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593657079-31990-1-git-send-email-yumeng18@huawei.com>
References: <1593657079-31990-1-git-send-email-yumeng18@huawei.com>
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
 drivers/crypto/hisilicon/hpre/hpre_main.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 6f7a453..6d8a110 100644
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
@@ -234,6 +238,21 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 	return 0;
 }
 
+/* for Hi1620, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
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
@@ -245,10 +264,6 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_AWUSER_M_CFG_ENABLE));
 	writel_relaxed(HPRE_QM_AXI_CFG_MASK, HPRE_ADDR(qm, QM_AXI_M_CFG));
 
-	/* disable FLR triggered by BME(bus master enable) */
-	writel(PEH_AXUSER_CFG, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
-	writel(PEH_AXUSER_CFG_ENABLE, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG_ENABLE));
-
 	/* HPRE need more time, we close this interrupt */
 	val = readl_relaxed(HPRE_ADDR(qm, HPRE_QM_ABNML_INT_MASK));
 	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
@@ -299,6 +314,8 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	if (ret)
 		dev_err(dev, "acpi_evaluate_dsm err.\n");
 
+	disable_flr_of_bme(qm);
+
 	return ret;
 }
 
-- 
2.8.1

