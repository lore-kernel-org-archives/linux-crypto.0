Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284DEC433C1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0278619FC
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhC0Ict (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 04:32:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15351 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhC0IcY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 04:32:24 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F6sV45pfsz8y9b;
        Sat, 27 Mar 2021 16:30:20 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:32:16 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - fix PASID setting on kunpeng 920
Date:   Sat, 27 Mar 2021 16:29:44 +0800
Message-ID: <1616833784-5489-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We must confirm the PASID is disabled before using no-sva mode.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 43 +++++++++++++------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 87e8f4d..c7ab06d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -246,28 +246,24 @@ struct hisi_qp *hpre_create_qp(u8 type)
 	return NULL;
 }
 
-static void hpre_pasid_enable(struct hisi_qm *qm)
+static void hpre_config_pasid(struct hisi_qm *qm)
 {
-	u32 val;
-
-	val = readl_relaxed(qm->io_base + HPRE_DATA_RUSER_CFG);
-	val |= BIT(HPRE_PASID_EN_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_DATA_RUSER_CFG);
-	val = readl_relaxed(qm->io_base + HPRE_DATA_WUSER_CFG);
-	val |= BIT(HPRE_PASID_EN_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_DATA_WUSER_CFG);
-}
+	u32 val1, val2;
 
-static void hpre_pasid_disable(struct hisi_qm *qm)
-{
-	u32 val;
+	if (qm->ver >= QM_HW_V3)
+		return;
 
-	val = readl_relaxed(qm->io_base +  HPRE_DATA_RUSER_CFG);
-	val &= ~BIT(HPRE_PASID_EN_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_DATA_RUSER_CFG);
-	val = readl_relaxed(qm->io_base + HPRE_DATA_WUSER_CFG);
-	val &= ~BIT(HPRE_PASID_EN_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_DATA_WUSER_CFG);
+	val1 = readl_relaxed(qm->io_base + HPRE_DATA_RUSER_CFG);
+	val2 = readl_relaxed(qm->io_base + HPRE_DATA_WUSER_CFG);
+	if (qm->use_sva) {
+		val1 |= BIT(HPRE_PASID_EN_BIT);
+		val2 |= BIT(HPRE_PASID_EN_BIT);
+	} else {
+		val1 &= ~BIT(HPRE_PASID_EN_BIT);
+		val2 &= ~BIT(HPRE_PASID_EN_BIT);
+	}
+	writel_relaxed(val1, qm->io_base + HPRE_DATA_RUSER_CFG);
+	writel_relaxed(val2, qm->io_base + HPRE_DATA_WUSER_CFG);
 }
 
 static int hpre_cfg_by_dsm(struct hisi_qm *qm)
@@ -393,12 +389,11 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 			dev_err(dev, "acpi_evaluate_dsm err.\n");
 
 		disable_flr_of_bme(qm);
-
-		/* Enable data buffer pasid */
-		if (qm->use_sva)
-			hpre_pasid_enable(qm);
 	}
 
+	/* Config data buffer pasid needed by Kunpeng 920 */
+	hpre_config_pasid(qm);
+
 	return ret;
 }
 
@@ -1013,8 +1008,6 @@ static void hpre_remove(struct pci_dev *pdev)
 	hisi_qm_stop(qm, QM_NORMAL);
 
 	if (qm->fun_type == QM_HW_PF) {
-		if (qm->use_sva && qm->ver == QM_HW_V2)
-			hpre_pasid_disable(qm);
 		hpre_cnt_regs_clear(qm);
 		qm->debug.curr_qm_qp_num = 0;
 		hisi_qm_dev_err_uninit(qm);
-- 
2.8.1

