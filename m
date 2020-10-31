Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D94DC55179
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 06:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB36220719
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 06:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgJaGgR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 02:36:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6682 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJaGgQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 02:36:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CNTw91g0Fz15PgD;
        Sat, 31 Oct 2020 14:36:09 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 14:36:01 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] crypto: hisilicon/hpre - add initial settings adapt to 'Kunpeng 930'
Date:   Sat, 31 Oct 2020 14:34:24 +0800
Message-ID: <1604126068-29195-2-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604126068-29195-1-git-send-email-yumeng18@huawei.com>
References: <1604126068-29195-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

HPRE device 'Kunpeng 930' is updated based on 'Kunpeng 920', and they
are not all the same, such as cluster numbers and configuration of some
registers, so we try to update this driver to make it running okay not
only on 'Kunpeng 920', but also okay on 'Kunpeng 930' in this patch.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h      |  8 ++-
 drivers/crypto/hisilicon/hpre/hpre_main.c | 93 +++++++++++++++++++++----------
 2 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index f69252b..181c109 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -14,8 +14,7 @@ enum {
 	HPRE_CLUSTER0,
 	HPRE_CLUSTER1,
 	HPRE_CLUSTER2,
-	HPRE_CLUSTER3,
-	HPRE_CLUSTERS_NUM,
+	HPRE_CLUSTER3
 };
 
 enum hpre_ctrl_dbgfs_file {
@@ -36,7 +35,10 @@ enum hpre_dfx_dbgfs_file {
 	HPRE_DFX_FILE_NUM
 };
 
-#define HPRE_DEBUGFS_FILE_NUM    (HPRE_DEBUG_FILE_NUM + HPRE_CLUSTERS_NUM - 1)
+#define HPRE_CLUSTERS_NUM_V2		(HPRE_CLUSTER3 + 1)
+#define HPRE_CLUSTERS_NUM_V3		1
+#define HPRE_CLUSTERS_NUM_MAX		HPRE_CLUSTERS_NUM_V2
+#define HPRE_DEBUGFS_FILE_NUM (HPRE_DEBUG_FILE_NUM + HPRE_CLUSTERS_NUM_MAX - 1)
 
 struct hpre_debugfs_file {
 	int index;
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a33394d..719f8715 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -29,6 +29,8 @@
 #define HPRE_BD_ARUSR_CFG		0x301030
 #define HPRE_BD_AWUSR_CFG		0x301034
 #define HPRE_TYPES_ENB			0x301038
+#define HPRE_RSA_ENB			BIT(0)
+#define HPRE_ECC_ENB			BIT(1)
 #define HPRE_DATA_RUSER_CFG		0x30103c
 #define HPRE_DATA_WUSER_CFG		0x301040
 #define HPRE_INT_MASK			0x301400
@@ -73,7 +75,8 @@
 #define HPRE_QM_AXI_CFG_MASK		0xffff
 #define HPRE_QM_VFG_AX_MASK		0xff
 #define HPRE_BD_USR_MASK		0x3
-#define HPRE_CLUSTER_CORE_MASK		0xf
+#define HPRE_CLUSTER_CORE_MASK_V2	0xf
+#define HPRE_CLUSTER_CORE_MASK_V3	0xff
 
 #define HPRE_AM_OOO_SHUTDOWN_ENB	0x301044
 #define HPRE_AM_OOO_SHUTDOWN_ENABLE	BIT(0)
@@ -86,6 +89,11 @@
 #define HPRE_QM_PM_FLR			BIT(11)
 #define HPRE_QM_SRIOV_FLR		BIT(12)
 
+#define HPRE_CLUSTERS_NUM(qm)		\
+	(((qm)->ver >= QM_HW_V3) ? HPRE_CLUSTERS_NUM_V3 : HPRE_CLUSTERS_NUM_V2)
+#define HPRE_CLUSTER_CORE_MASK(qm)	\
+	(((qm)->ver >= QM_HW_V3) ? HPRE_CLUSTER_CORE_MASK_V3 :\
+		HPRE_CLUSTER_CORE_MASK_V2)
 #define HPRE_VIA_MSI_DSM		1
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
@@ -238,8 +246,40 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 	return 0;
 }
 
+static int hpre_set_cluster(struct hisi_qm *qm)
+{
+	u32 cluster_core_mask = HPRE_CLUSTER_CORE_MASK(qm);
+	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
+	struct device *dev = &qm->pdev->dev;
+	unsigned long offset;
+	u32 val = 0;
+	int ret, i;
+
+	for (i = 0; i < clusters_num; i++) {
+		offset = i * HPRE_CLSTR_ADDR_INTRVL;
+
+		/* clusters initiating */
+		writel(cluster_core_mask,
+		       HPRE_ADDR(qm, offset + HPRE_CORE_ENB));
+		writel(0x1, HPRE_ADDR(qm, offset + HPRE_CORE_INI_CFG));
+		ret = readl_relaxed_poll_timeout(HPRE_ADDR(qm, offset +
+					HPRE_CORE_INI_STATUS), val,
+					((val & cluster_core_mask) ==
+					cluster_core_mask),
+					HPRE_REG_RD_INTVRL_US,
+					HPRE_REG_RD_TMOUT_US);
+		if (ret) {
+			dev_err(dev,
+				"cluster %d int st status timeout!\n", i);
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
 /*
- * For Hi1620, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
+ * For Kunpeng 920, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
  * Or it may stay in D3 state when we bind and unbind hpre quickly,
  * as it does FLR triggered by hardware.
  */
@@ -257,9 +297,8 @@ static void disable_flr_of_bme(struct hisi_qm *qm)
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
-	unsigned long offset;
-	int ret, i;
 	u32 val;
+	int ret;
 
 	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_ARUSER_M_CFG_ENABLE));
 	writel(HPRE_QM_USR_CFG_MASK, HPRE_ADDR(qm, QM_AWUSER_M_CFG_ENABLE));
@@ -270,7 +309,12 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
 	writel_relaxed(val, HPRE_ADDR(qm, HPRE_QM_ABNML_INT_MASK));
 
-	writel(0x1, HPRE_ADDR(qm, HPRE_TYPES_ENB));
+	if (qm->ver >= QM_HW_V3)
+		writel(HPRE_RSA_ENB | HPRE_ECC_ENB,
+			HPRE_ADDR(qm, HPRE_TYPES_ENB));
+	else
+		writel(HPRE_RSA_ENB, HPRE_ADDR(qm, HPRE_TYPES_ENB));
+
 	writel(HPRE_QM_VFG_AX_MASK, HPRE_ADDR(qm, HPRE_VFG_AXCACHE));
 	writel(0x0, HPRE_ADDR(qm, HPRE_BD_ENDIAN));
 	writel(0x0, HPRE_ADDR(qm, HPRE_INT_MASK));
@@ -291,37 +335,25 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 		return -ETIMEDOUT;
 	}
 
-	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
-		offset = i * HPRE_CLSTR_ADDR_INTRVL;
-
-		/* clusters initiating */
-		writel(HPRE_CLUSTER_CORE_MASK,
-		       HPRE_ADDR(qm, offset + HPRE_CORE_ENB));
-		writel(0x1, HPRE_ADDR(qm, offset + HPRE_CORE_INI_CFG));
-		ret = readl_relaxed_poll_timeout(HPRE_ADDR(qm, offset +
-					HPRE_CORE_INI_STATUS), val,
-					((val & HPRE_CLUSTER_CORE_MASK) ==
-					HPRE_CLUSTER_CORE_MASK),
-					HPRE_REG_RD_INTVRL_US,
-					HPRE_REG_RD_TMOUT_US);
-		if (ret) {
-			dev_err(dev,
-				"cluster %d int st status timeout!\n", i);
-			return -ETIMEDOUT;
-		}
-	}
-
-	ret = hpre_cfg_by_dsm(qm);
+	ret = hpre_set_cluster(qm);
 	if (ret)
-		dev_err(dev, "acpi_evaluate_dsm err.\n");
+		return -ETIMEDOUT;
 
-	disable_flr_of_bme(qm);
+	/* This setting is only needed by Kunpeng 920. */
+	if (qm->ver == QM_HW_V2) {
+		ret = hpre_cfg_by_dsm(qm);
+		if (ret)
+			dev_err(dev, "acpi_evaluate_dsm err.\n");
+
+		disable_flr_of_bme(qm);
+	}
 
 	return ret;
 }
 
 static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 {
+	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
 	unsigned long offset;
 	int i;
 
@@ -330,7 +362,7 @@ static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
 
 	/* clear clusterX/cluster_ctrl */
-	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
+	for (i = 0; i < clusters_num; i++) {
 		offset = HPRE_CLSTR_BASE + i * HPRE_CLSTR_ADDR_INTRVL;
 		writel(0x0, qm->io_base + offset + HPRE_CLUSTER_INQURY);
 	}
@@ -629,13 +661,14 @@ static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 
 static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 {
+	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
 	struct device *dev = &qm->pdev->dev;
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
 	struct dentry *tmp_d;
 	int i, ret;
 
-	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
+	for (i = 0; i < clusters_num; i++) {
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
 		if (ret < 0)
 			return -EINVAL;
-- 
2.8.1

