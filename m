Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FA5C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC6D61433
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhEJJLE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:11:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2743 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhEJJLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:11:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FdwCZ6BHNzqV1c;
        Mon, 10 May 2021 17:06:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:09:47 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] crypto: hisilicon/hpre - replace macro with inline function
Date:   Mon, 10 May 2021 17:06:46 +0800
Message-ID: <1620637611-41643-4-git-send-email-tanghui20@huawei.com>
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

Functional macro lacks type checking, which is not as strict as function
call checking.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 47a169c..1e7d1fb 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -87,11 +87,6 @@
 #define HPRE_QM_PM_FLR			BIT(11)
 #define HPRE_QM_SRIOV_FLR		BIT(12)
 
-#define HPRE_CLUSTERS_NUM(qm)		\
-	(((qm)->ver >= QM_HW_V3) ? HPRE_CLUSTERS_NUM_V3 : HPRE_CLUSTERS_NUM_V2)
-#define HPRE_CLUSTER_CORE_MASK(qm)	\
-	(((qm)->ver >= QM_HW_V3) ? HPRE_CLUSTER_CORE_MASK_V3 :\
-		HPRE_CLUSTER_CORE_MASK_V2)
 #define HPRE_VIA_MSI_DSM		1
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
@@ -251,6 +246,18 @@ static u32 vfs_num;
 module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
 
+static inline int hpre_cluster_num(struct hisi_qm *qm)
+{
+	return (qm->ver >= QM_HW_V3) ? HPRE_CLUSTERS_NUM_V3 :
+		HPRE_CLUSTERS_NUM_V2;
+}
+
+static inline int hpre_cluster_core_mask(struct hisi_qm *qm)
+{
+	return (qm->ver >= QM_HW_V3) ?
+		HPRE_CLUSTER_CORE_MASK_V3 : HPRE_CLUSTER_CORE_MASK_V2;
+}
+
 struct hisi_qp *hpre_create_qp(u8 type)
 {
 	int node = cpu_to_node(smp_processor_id());
@@ -317,8 +324,8 @@ static int hpre_cfg_by_dsm(struct hisi_qm *qm)
 
 static int hpre_set_cluster(struct hisi_qm *qm)
 {
-	u32 cluster_core_mask = HPRE_CLUSTER_CORE_MASK(qm);
-	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
+	u32 cluster_core_mask = hpre_cluster_core_mask(qm);
+	u8 clusters_num = hpre_cluster_num(qm);
 	struct device *dev = &qm->pdev->dev;
 	unsigned long offset;
 	u32 val = 0;
@@ -424,7 +431,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 {
-	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
+	u8 clusters_num = hpre_cluster_num(qm);
 	unsigned long offset;
 	int i;
 
@@ -677,7 +684,7 @@ static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 
 static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 {
-	u8 clusters_num = HPRE_CLUSTERS_NUM(qm);
+	u8 clusters_num = hpre_cluster_num(qm);
 	struct device *dev = &qm->pdev->dev;
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
-- 
2.8.1

