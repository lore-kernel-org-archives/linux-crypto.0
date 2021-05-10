Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707E3C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46248610A7
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhEJJLG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:11:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2747 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhEJJLC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:11:02 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FdwCZ59RkzqV1R;
        Mon, 10 May 2021 17:06:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:09:46 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] crypto: hisilicon/hpre - the macro 'HPRE_ADDR' expands
Date:   Mon, 10 May 2021 17:06:44 +0800
Message-ID: <1620637611-41643-2-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
References: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The macro 'HPRE_ADDR' is unnecessary, so expanding it.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 59 +++++++++++++++----------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 046bc96..c914e00 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -69,7 +69,6 @@
 #define HPRE_DBGFS_VAL_MAX_LEN		20
 #define HPRE_PCI_DEVICE_ID		0xa258
 #define HPRE_PCI_VF_DEVICE_ID		0xa259
-#define HPRE_ADDR(qm, offset)		((qm)->io_base + (offset))
 #define HPRE_QM_USR_CFG_MASK		0xfffffffe
 #define HPRE_QM_AXI_CFG_MASK		0xffff
 #define HPRE_QM_VFG_AX_MASK		0xff
@@ -302,10 +301,10 @@ static int hpre_set_cluster(struct hisi_qm *qm)
 
 		/* clusters initiating */
 		writel(cluster_core_mask,
-		       HPRE_ADDR(qm, offset + HPRE_CORE_ENB));
-		writel(0x1, HPRE_ADDR(qm, offset + HPRE_CORE_INI_CFG));
-		ret = readl_relaxed_poll_timeout(HPRE_ADDR(qm, offset +
-					HPRE_CORE_INI_STATUS), val,
+		       qm->io_base + offset + HPRE_CORE_ENB);
+		writel(0x1, qm->io_base + offset + HPRE_CORE_INI_CFG);
+		ret = readl_relaxed_poll_timeout(qm->io_base + offset +
+					HPRE_CORE_INI_STATUS, val,
 					((val & cluster_core_mask) ==
 					cluster_core_mask),
 					HPRE_REG_RD_INTVRL_US,
@@ -329,11 +328,11 @@ static void disable_flr_of_bme(struct hisi_qm *qm)
 {
 	u32 val;
 
-	val = readl(HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
+	val = readl(qm->io_base + QM_PEH_AXUSER_CFG);
 	val &= ~(HPRE_QM_BME_FLR | HPRE_QM_SRIOV_FLR);
 	val |= HPRE_QM_PM_FLR;
-	writel(val, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG));
-	writel(PEH_AXUSER_CFG_ENABLE, HPRE_ADDR(qm, QM_PEH_AXUSER_CFG_ENABLE));
+	writel(val, qm->io_base + QM_PEH_AXUSER_CFG);
+	writel(PEH_AXUSER_CFG_ENABLE, qm->io_base + QM_PEH_AXUSER_CFG_ENABLE);
 }
 
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
@@ -342,33 +341,33 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_ARUSER_M_CFG_ENABLE));
-	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_AWUSER_M_CFG_ENABLE));
-	writel_relaxed(HPRE_QM_AXI_CFG_MASK, HPRE_ADDR(qm, QM_AXI_M_CFG));
+	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_ARUSER_M_CFG_ENABLE);
+	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_AWUSER_M_CFG_ENABLE);
+	writel_relaxed(HPRE_QM_AXI_CFG_MASK, qm->io_base + QM_AXI_M_CFG);
 
 	/* HPRE need more time, we close this interrupt */
-	val = readl_relaxed(HPRE_ADDR(qm, HPRE_QM_ABNML_INT_MASK));
+	val = readl_relaxed(qm->io_base + HPRE_QM_ABNML_INT_MASK);
 	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
-	writel_relaxed(val, HPRE_ADDR(qm, HPRE_QM_ABNML_INT_MASK));
+	writel_relaxed(val, qm->io_base + HPRE_QM_ABNML_INT_MASK);
 
 	if (qm->ver >= QM_HW_V3)
 		writel(HPRE_RSA_ENB | HPRE_ECC_ENB,
-			HPRE_ADDR(qm, HPRE_TYPES_ENB));
+			qm->io_base + HPRE_TYPES_ENB);
 	else
-		writel(HPRE_RSA_ENB, HPRE_ADDR(qm, HPRE_TYPES_ENB));
-
-	writel(HPRE_QM_VFG_AX_MASK, HPRE_ADDR(qm, HPRE_VFG_AXCACHE));
-	writel(0x0, HPRE_ADDR(qm, HPRE_BD_ENDIAN));
-	writel(0x0, HPRE_ADDR(qm, HPRE_INT_MASK));
-	writel(0x0, HPRE_ADDR(qm, HPRE_POISON_BYPASS));
-	writel(0x0, HPRE_ADDR(qm, HPRE_COMM_CNT_CLR_CE));
-	writel(0x0, HPRE_ADDR(qm, HPRE_ECC_BYPASS));
-
-	writel(HPRE_BD_USR_MASK, HPRE_ADDR(qm, HPRE_BD_ARUSR_CFG));
-	writel(HPRE_BD_USR_MASK, HPRE_ADDR(qm, HPRE_BD_AWUSR_CFG));
-	writel(0x1, HPRE_ADDR(qm, HPRE_RDCHN_INI_CFG));
-	ret = readl_relaxed_poll_timeout(HPRE_ADDR(qm, HPRE_RDCHN_INI_ST), val,
-					 val & BIT(0),
+		writel(HPRE_RSA_ENB, qm->io_base + HPRE_TYPES_ENB);
+
+	writel(HPRE_QM_VFG_AX_MASK, qm->io_base + HPRE_VFG_AXCACHE);
+	writel(0x0, qm->io_base + HPRE_BD_ENDIAN);
+	writel(0x0, qm->io_base + HPRE_INT_MASK);
+	writel(0x0, qm->io_base + HPRE_POISON_BYPASS);
+	writel(0x0, qm->io_base + HPRE_COMM_CNT_CLR_CE);
+	writel(0x0, qm->io_base + HPRE_ECC_BYPASS);
+
+	writel(HPRE_BD_USR_MASK, qm->io_base + HPRE_BD_ARUSR_CFG);
+	writel(HPRE_BD_USR_MASK, qm->io_base + HPRE_BD_AWUSR_CFG);
+	writel(0x1, qm->io_base + HPRE_RDCHN_INI_CFG);
+	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_RDCHN_INI_ST, val,
+			val & BIT(0),
 			HPRE_REG_RD_INTVRL_US,
 			HPRE_REG_RD_TMOUT_US);
 	if (ret) {
@@ -802,9 +801,9 @@ static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
 
 	value = readl(qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 	writel(value & ~HPRE_AM_OOO_SHUTDOWN_ENABLE,
-	       HPRE_ADDR(qm, HPRE_AM_OOO_SHUTDOWN_ENB));
+	       qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 	writel(value | HPRE_AM_OOO_SHUTDOWN_ENABLE,
-	       HPRE_ADDR(qm, HPRE_AM_OOO_SHUTDOWN_ENB));
+	       qm->io_base + HPRE_AM_OOO_SHUTDOWN_ENB);
 }
 
 static void hpre_err_info_init(struct hisi_qm *qm)
-- 
2.8.1

