Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62768C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C360207BC
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgGJHlh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 03:41:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54810 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgGJHlf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 03:41:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 94FB86D307C94840ADF1;
        Fri, 10 Jul 2020 15:41:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 10 Jul 2020 15:41:24 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/6] crypto: hisilicon/hpre - update debugfs interface parameters
Date:   Fri, 10 Jul 2020 15:40:45 +0800
Message-ID: <1594366846-1313-6-git-send-email-yumeng18@huawei.com>
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

Update debugfs interface parameters, and adjust the
processing logic inside the corresponding function.

Fixes: 848974151618("crypto: hisilicon - Add debugfs for HPRE")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 59 ++++++++++++++-----------------
 1 file changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 37c2bc5..b69cea3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -563,15 +563,17 @@ static int hpre_debugfs_atomic64_set(void *data, u64 val)
 DEFINE_DEBUGFS_ATTRIBUTE(hpre_atomic64_ops, hpre_debugfs_atomic64_get,
 			 hpre_debugfs_atomic64_set, "%llu\n");
 
-static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
+static int hpre_create_debugfs_file(struct hisi_qm *qm, struct dentry *dir,
 				    enum hpre_ctrl_dbgfs_file type, int indx)
 {
+	struct hpre *hpre = container_of(qm, struct hpre, qm);
+	struct hpre_debug *dbg = &hpre->debug;
 	struct dentry *file_dir;
 
 	if (dir)
 		file_dir = dir;
 	else
-		file_dir = dbg->debug_root;
+		file_dir = qm->debug.debug_root;
 
 	if (type >= HPRE_DEBUG_FILE_NUM)
 		return -EINVAL;
@@ -586,10 +588,8 @@ static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
 	return 0;
 }
 
-static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
+static int hpre_pf_comm_regs_debugfs_init(struct hisi_qm *qm)
 {
-	struct hpre *hpre = container_of(debug, struct hpre, debug);
-	struct hisi_qm *qm = &hpre->qm;
 	struct device *dev = &qm->pdev->dev;
 	struct debugfs_regset32 *regset;
 
@@ -601,14 +601,12 @@ static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
 	regset->nregs = ARRAY_SIZE(hpre_com_dfx_regs);
 	regset->base = qm->io_base;
 
-	debugfs_create_regset32("regs", 0444,  debug->debug_root, regset);
+	debugfs_create_regset32("regs", 0444,  qm->debug.debug_root, regset);
 	return 0;
 }
 
-static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
+static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 {
-	struct hpre *hpre = container_of(debug, struct hpre, debug);
-	struct hisi_qm *qm = &hpre->qm;
 	struct device *dev = &qm->pdev->dev;
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
@@ -619,7 +617,7 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
 		if (ret < 0)
 			return -EINVAL;
-		tmp_d = debugfs_create_dir(buf, debug->debug_root);
+		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);
 
 		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 		if (!regset)
@@ -630,7 +628,7 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 		regset->base = qm->io_base + hpre_cluster_offsets[i];
 
 		debugfs_create_regset32("regs", 0444, tmp_d, regset);
-		ret = hpre_create_debugfs_file(debug, tmp_d, HPRE_CLUSTER_CTRL,
+		ret = hpre_create_debugfs_file(qm, tmp_d, HPRE_CLUSTER_CTRL,
 					       i + HPRE_CLUSTER_CTRL);
 		if (ret)
 			return ret;
@@ -639,32 +637,31 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 	return 0;
 }
 
-static int hpre_ctrl_debug_init(struct hpre_debug *debug)
+static int hpre_ctrl_debug_init(struct hisi_qm *qm)
 {
 	int ret;
 
-	ret = hpre_create_debugfs_file(debug, NULL, HPRE_CURRENT_QM,
+	ret = hpre_create_debugfs_file(qm, NULL, HPRE_CURRENT_QM,
 				       HPRE_CURRENT_QM);
 	if (ret)
 		return ret;
 
-	ret = hpre_create_debugfs_file(debug, NULL, HPRE_CLEAR_ENABLE,
+	ret = hpre_create_debugfs_file(qm, NULL, HPRE_CLEAR_ENABLE,
 				       HPRE_CLEAR_ENABLE);
 	if (ret)
 		return ret;
 
-	ret = hpre_pf_comm_regs_debugfs_init(debug);
+	ret = hpre_pf_comm_regs_debugfs_init(qm);
 	if (ret)
 		return ret;
 
-	return hpre_cluster_debugfs_init(debug);
+	return hpre_cluster_debugfs_init(qm);
 }
 
-static void hpre_dfx_debug_init(struct hpre_debug *debug)
+static void hpre_dfx_debug_init(struct hisi_qm *qm)
 {
-	struct hpre *hpre = container_of(debug, struct hpre, debug);
+	struct hpre *hpre = container_of(qm, struct hpre, qm);
 	struct hpre_dfx *dfx = hpre->debug.dfx;
-	struct hisi_qm *qm = &hpre->qm;
 	struct dentry *parent;
 	int i;
 
@@ -676,30 +673,27 @@ static void hpre_dfx_debug_init(struct hpre_debug *debug)
 	}
 }
 
-static int hpre_debugfs_init(struct hpre *hpre)
+static int hpre_debugfs_init(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hpre->qm;
 	struct device *dev = &qm->pdev->dev;
-	struct dentry *dir;
 	int ret;
 
-	dir = debugfs_create_dir(dev_name(dev), hpre_debugfs_root);
-	qm->debug.debug_root = dir;
+	qm->debug.debug_root = debugfs_create_dir(dev_name(dev),
+						  hpre_debugfs_root);
+
 	qm->debug.sqe_mask_offset = HPRE_SQE_MASK_OFFSET;
 	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
-
 	ret = hisi_qm_debug_init(qm);
 	if (ret)
 		goto failed_to_create;
 
 	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
-		hpre->debug.debug_root = dir;
-		ret = hpre_ctrl_debug_init(&hpre->debug);
+		ret = hpre_ctrl_debug_init(qm);
 		if (ret)
 			goto failed_to_create;
 	}
 
-	hpre_dfx_debug_init(&hpre->debug);
+	hpre_dfx_debug_init(qm);
 
 	return 0;
 
@@ -708,10 +702,8 @@ static int hpre_debugfs_init(struct hpre *hpre)
 	return ret;
 }
 
-static void hpre_debugfs_exit(struct hpre *hpre)
+static void hpre_debugfs_exit(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &hpre->qm;
-
 	debugfs_remove_recursive(qm->debug.debug_root);
 }
 
@@ -850,7 +842,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_with_err_init;
 
-	ret = hpre_debugfs_init(hpre);
+	ret = hpre_debugfs_init(qm);
 	if (ret)
 		dev_warn(&pdev->dev, "init debugfs fail!\n");
 
@@ -875,6 +867,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_with_qm_start:
 	hisi_qm_del_from_list(qm, &hpre_devices);
+	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm);
 
 err_with_err_init:
@@ -906,7 +899,7 @@ static void hpre_remove(struct pci_dev *pdev)
 		qm->debug.curr_qm_qp_num = 0;
 	}
 
-	hpre_debugfs_exit(hpre);
+	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm);
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
-- 
2.8.1

