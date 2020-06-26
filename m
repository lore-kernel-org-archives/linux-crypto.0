Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B64C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8DB820768
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgFZKcq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:32:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6832 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727870AbgFZKcp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 06:32:45 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 980232EFFCD9929409C7
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 18:32:43 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 26 Jun 2020
 18:32:40 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 4/5] crypto: hisilicon/sec2 - update debugfs interface parameters
Date:   Fri, 26 Jun 2020 18:32:08 +0800
Message-ID: <1593167529-22463-5-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update debugfs interface parameters, and adjust the
processing logic inside the corresponding function

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 54 ++++++++++++++++----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 16bb3d7..5bef3d8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -586,16 +586,16 @@ static int sec_debugfs_atomic64_set(void *data, u64 val)
 DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
 			 sec_debugfs_atomic64_set, "%lld\n");
 
-static int sec_core_debug_init(struct sec_dev *sec)
+static int sec_core_debug_init(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
+	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
 	struct device *dev = &qm->pdev->dev;
 	struct sec_dfx *dfx = &sec->debug.dfx;
 	struct debugfs_regset32 *regset;
 	struct dentry *tmp_d;
 	int i;
 
-	tmp_d = debugfs_create_dir("sec_dfx", sec->qm.debug.debug_root);
+	tmp_d = debugfs_create_dir("sec_dfx", qm->debug.debug_root);
 
 	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 	if (!regset)
@@ -618,44 +618,44 @@ static int sec_core_debug_init(struct sec_dev *sec)
 	return 0;
 }
 
-static int sec_debug_init(struct sec_dev *sec)
+static int sec_debug_init(struct hisi_qm *qm)
 {
+	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
 	int i;
 
-	for (i = SEC_CURRENT_QM; i < SEC_DEBUG_FILE_NUM; i++) {
-		spin_lock_init(&sec->debug.files[i].lock);
-		sec->debug.files[i].index = i;
-		sec->debug.files[i].qm = &sec->qm;
-
-		debugfs_create_file(sec_dbg_file_name[i], 0600,
-				    sec->qm.debug.debug_root,
-				    sec->debug.files + i,
-				    &sec_dbg_fops);
+	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID) {
+		for (i = SEC_CURRENT_QM; i < SEC_DEBUG_FILE_NUM; i++) {
+			spin_lock_init(&sec->debug.files[i].lock);
+			sec->debug.files[i].index = i;
+			sec->debug.files[i].qm = qm;
+
+			debugfs_create_file(sec_dbg_file_name[i], 0600,
+						  qm->debug.debug_root,
+						  sec->debug.files + i,
+						  &sec_dbg_fops);
+		}
 	}
 
-	return sec_core_debug_init(sec);
+	return sec_core_debug_init(qm);
 }
 
-static int sec_debugfs_init(struct sec_dev *sec)
+static int sec_debugfs_init(struct hisi_qm *qm)
 {
-	struct hisi_qm *qm = &sec->qm;
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
 	qm->debug.debug_root = debugfs_create_dir(dev_name(dev),
 						  sec_debugfs_root);
-
 	qm->debug.sqe_mask_offset = SEC_SQE_MASK_OFFSET;
 	qm->debug.sqe_mask_len = SEC_SQE_MASK_LEN;
 	ret = hisi_qm_debug_init(qm);
 	if (ret)
 		goto failed_to_create;
 
-	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID) {
-		ret = sec_debug_init(sec);
-		if (ret)
-			goto failed_to_create;
-	}
+	ret = sec_debug_init(qm);
+	if (ret)
+		goto failed_to_create;
+
 
 	return 0;
 
@@ -665,9 +665,9 @@ static int sec_debugfs_init(struct sec_dev *sec)
 	return ret;
 }
 
-static void sec_debugfs_exit(struct sec_dev *sec)
+static void sec_debugfs_exit(struct hisi_qm *qm)
 {
-	debugfs_remove_recursive(sec->qm.debug.debug_root);
+	debugfs_remove_recursive(qm->debug.debug_root);
 }
 
 static void sec_log_hw_error(struct hisi_qm *qm, u32 err_sts)
@@ -877,7 +877,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_probe_uninit;
 	}
 
-	ret = sec_debugfs_init(sec);
+	ret = sec_debugfs_init(qm);
 	if (ret)
 		pci_warn(pdev, "Failed to init debugfs!\n");
 
@@ -902,7 +902,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_remove_from_list:
 	hisi_qm_del_from_list(qm, &sec_devices);
-	sec_debugfs_exit(sec);
+	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm);
 
 err_probe_uninit:
@@ -926,7 +926,7 @@ static void sec_remove(struct pci_dev *pdev)
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
 		hisi_qm_sriov_disable(pdev);
 
-	sec_debugfs_exit(sec);
+	sec_debugfs_exit(qm);
 
 	(void)hisi_qm_stop(qm);
 
-- 
2.8.1

