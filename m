Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33134C4742C
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEBC2076D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgJaJIt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:08:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7022 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgJaJIo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:44 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNYJ9589dzhcf1;
        Sat, 31 Oct 2020 17:08:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:34 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 3/8] crypto: hisilicon/qm - modify the return type of debugfs interface
Date:   Sat, 31 Oct 2020 17:07:03 +0800
Message-ID: <1604135228-18410-4-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
References: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since 'qm_create_debugfs_file' always returns 0, change it as 'void'.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  4 +---
 drivers/crypto/hisilicon/qm.c             | 19 ++++---------------
 drivers/crypto/hisilicon/qm.h             |  2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |  4 +---
 drivers/crypto/hisilicon/zip/zip_main.c   |  4 +---
 5 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a33394d..e5c9919 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -705,9 +705,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
 
 	qm->debug.sqe_mask_offset = HPRE_SQE_MASK_OFFSET;
 	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
-	ret = hisi_qm_debug_init(qm);
-	if (ret)
-		goto failed_to_create;
+	hisi_qm_debug_init(qm);
 
 	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
 		ret = hpre_ctrl_debug_init(qm);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index d5d06ae..627479f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1520,7 +1520,7 @@ static const struct file_operations qm_cmd_fops = {
 	.write = qm_cmd_write,
 };
 
-static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
+static void qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
 {
 	struct dentry *qm_d = qm->debug.qm_d;
 	struct debugfs_file *file = qm->debug.files + index;
@@ -1531,8 +1531,6 @@ static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
 	file->index = index;
 	mutex_init(&file->lock);
 	file->debug = &qm->debug;
-
-	return 0;
 }
 
 static void qm_hw_error_init_v1(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe)
@@ -2824,12 +2822,12 @@ DEFINE_DEBUGFS_ATTRIBUTE(qm_atomic64_ops, qm_debugfs_atomic64_get,
  *
  * Create qm related debugfs files.
  */
-int hisi_qm_debug_init(struct hisi_qm *qm)
+void hisi_qm_debug_init(struct hisi_qm *qm)
 {
 	struct qm_dfx *dfx = &qm->debug.dfx;
 	struct dentry *qm_d;
 	void *data;
-	int i, ret;
+	int i;
 
 	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
 	qm->debug.qm_d = qm_d;
@@ -2837,10 +2835,7 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 	/* only show this in PF */
 	if (qm->fun_type == QM_HW_PF)
 		for (i = CURRENT_Q; i < DEBUG_FILE_NUM; i++)
-			if (qm_create_debugfs_file(qm, i)) {
-				ret = -ENOENT;
-				goto failed_to_create;
-			}
+			qm_create_debugfs_file(qm, i);
 
 	debugfs_create_file("regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
@@ -2856,12 +2851,6 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 			data,
 			&qm_atomic64_ops);
 	}
-
-	return 0;
-
-failed_to_create:
-	debugfs_remove_recursive(qm_d);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_debug_init);
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 0420f4c..8624d12 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -350,7 +350,7 @@ void hisi_qm_release_qp(struct hisi_qp *qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg);
 int hisi_qm_get_free_qp_num(struct hisi_qm *qm);
 int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number);
-int hisi_qm_debug_init(struct hisi_qm *qm);
+void hisi_qm_debug_init(struct hisi_qm *qm);
 enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev);
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm);
 int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 2f52581..b35c1c2 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -652,9 +652,7 @@ static int sec_debugfs_init(struct hisi_qm *qm)
 						  sec_debugfs_root);
 	qm->debug.sqe_mask_offset = SEC_SQE_MASK_OFFSET;
 	qm->debug.sqe_mask_len = SEC_SQE_MASK_LEN;
-	ret = hisi_qm_debug_init(qm);
-	if (ret)
-		goto failed_to_create;
+	hisi_qm_debug_init(qm);
 
 	ret = sec_debug_init(qm);
 	if (ret)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4bd2c81..3d1524b 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -590,9 +590,7 @@ static int hisi_zip_debugfs_init(struct hisi_qm *qm)
 	qm->debug.sqe_mask_offset = HZIP_SQE_MASK_OFFSET;
 	qm->debug.sqe_mask_len = HZIP_SQE_MASK_LEN;
 	qm->debug.debug_root = dev_d;
-	ret = hisi_qm_debug_init(qm);
-	if (ret)
-		goto failed_to_create;
+	hisi_qm_debug_init(qm);
 
 	if (qm->fun_type == QM_HW_PF) {
 		ret = hisi_zip_ctrl_debug_init(qm);
-- 
2.8.1

