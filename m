Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D1FC47247
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9145A21582
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEHG7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbgEHG7E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0BC4FF1ED91C217B38DD;
        Fri,  8 May 2020 14:59:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 14:58:52 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 04/13] crypto: hisilicon - refactor module parameter pf_q_num related code
Date:   Fri, 8 May 2020 14:57:39 +0800
Message-ID: <1588921068-20739-5-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

put q_num_set similar code into qm to reduce the redundancy.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 39 ++++++-------------------------
 drivers/crypto/hisilicon/qm.h             | 39 +++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 35 ++-------------------------
 drivers/crypto/hisilicon/zip/zip_main.c   | 33 +-------------------------
 4 files changed, 49 insertions(+), 97 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index f3859de..f1bb626 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -159,44 +159,19 @@ static struct debugfs_reg32 hpre_com_dfx_regs[] = {
 	{"INT_STATUS               ",  HPRE_INT_STATUS},
 };
 
-static int hpre_pf_q_num_set(const char *val, const struct kernel_param *kp)
+static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
-	struct pci_dev *pdev;
-	u32 n, q_num;
-	u8 rev_id;
-	int ret;
-
-	if (!val)
-		return -EINVAL;
-
-	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_DEVICE_ID, NULL);
-	if (!pdev) {
-		q_num = HPRE_QUEUE_NUM_V2;
-		pr_info("No device found currently, suppose queue number is %d\n",
-			q_num);
-	} else {
-		rev_id = pdev->revision;
-		if (rev_id != QM_HW_V2)
-			return -EINVAL;
-
-		q_num = HPRE_QUEUE_NUM_V2;
-	}
-
-	ret = kstrtou32(val, 10, &n);
-	if (ret != 0 || n == 0 || n > q_num)
-		return -EINVAL;
-
-	return param_set_int(val, kp);
+	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
 }
 
 static const struct kernel_param_ops hpre_pf_q_num_ops = {
-	.set = hpre_pf_q_num_set,
+	.set = pf_q_num_set,
 	.get = param_get_int,
 };
 
-static u32 hpre_pf_q_num = HPRE_PF_DEF_Q_NUM;
-module_param_cb(hpre_pf_q_num, &hpre_pf_q_num_ops, &hpre_pf_q_num, 0444);
-MODULE_PARM_DESC(hpre_pf_q_num, "Number of queues in PF of CS(1-1024)");
+static u32 pf_q_num = HPRE_PF_DEF_Q_NUM;
+module_param_cb(pf_q_num, &hpre_pf_q_num_ops, &pf_q_num, 0444);
+MODULE_PARM_DESC(pf_q_num, "Number of queues in PF of CS(1-1024)");
 
 static const struct kernel_param_ops vfs_num_ops = {
 	.set = vfs_num_set,
@@ -688,7 +663,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 
 	if (pdev->is_physfn) {
 		qm->qp_base = HPRE_PF_DEF_Q_BASE;
-		qm->qp_num = hpre_pf_q_num;
+		qm->qp_num = pf_q_num;
 	}
 	qm->use_dma_api = true;
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 9d17167..d1be8cd 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -8,6 +8,8 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+#define QM_QNUM_V1			4096
+#define QM_QNUM_V2			1024
 #define QM_MAX_VFS_NUM_V2		63
 
 /* qm user domain */
@@ -252,6 +254,43 @@ struct hisi_qp {
 	struct uacce_queue *uacce_q;
 };
 
+static inline int q_num_set(const char *val, const struct kernel_param *kp,
+			    unsigned int device)
+{
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
+					      device, NULL);
+	u32 n, q_num;
+	u8 rev_id;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	if (!pdev) {
+		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
+		pr_info("No device found currently, suppose queue number is %d\n",
+			q_num);
+	} else {
+		rev_id = pdev->revision;
+		switch (rev_id) {
+		case QM_HW_V1:
+			q_num = QM_QNUM_V1;
+			break;
+		case QM_HW_V2:
+			q_num = QM_QNUM_V2;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret || !n || n > q_num)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
 static inline int vfs_num_set(const char *val, const struct kernel_param *kp)
 {
 	u32 n;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ea029e3..5aba775 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -136,45 +136,14 @@ static struct debugfs_reg32 sec_dfx_regs[] = {
 
 static int sec_pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
-	struct pci_dev *pdev;
-	u32 n, q_num;
-	u8 rev_id;
-	int ret;
-
-	if (!val)
-		return -EINVAL;
-
-	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
-			      SEC_PF_PCI_DEVICE_ID, NULL);
-	if (!pdev) {
-		q_num = min_t(u32, SEC_QUEUE_NUM_V1, SEC_QUEUE_NUM_V2);
-		pr_info("No device, suppose queue number is %d!\n", q_num);
-	} else {
-		rev_id = pdev->revision;
-
-		switch (rev_id) {
-		case QM_HW_V1:
-			q_num = SEC_QUEUE_NUM_V1;
-			break;
-		case QM_HW_V2:
-			q_num = SEC_QUEUE_NUM_V2;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	ret = kstrtou32(val, 10, &n);
-	if (ret || !n || n > q_num)
-		return -EINVAL;
-
-	return param_set_int(val, kp);
+	return q_num_set(val, kp, SEC_PF_PCI_DEVICE_ID);
 }
 
 static const struct kernel_param_ops sec_pf_q_num_ops = {
 	.set = sec_pf_q_num_set,
 	.get = param_get_int,
 };
+
 static u32 pf_q_num = SEC_PF_DEF_Q_NUM;
 module_param_cb(pf_q_num, &sec_pf_q_num_ops, &pf_q_num, 0444);
 MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 0-4096, v2 0-1024)");
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4672eaa..3c838e2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -192,38 +192,7 @@ static struct debugfs_reg32 hzip_dfx_regs[] = {
 
 static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
-	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
-					      PCI_DEVICE_ID_ZIP_PF, NULL);
-	u32 n, q_num;
-	u8 rev_id;
-	int ret;
-
-	if (!val)
-		return -EINVAL;
-
-	if (!pdev) {
-		q_num = min_t(u32, HZIP_QUEUE_NUM_V1, HZIP_QUEUE_NUM_V2);
-		pr_info("No device found currently, suppose queue number is %d\n",
-			q_num);
-	} else {
-		rev_id = pdev->revision;
-		switch (rev_id) {
-		case QM_HW_V1:
-			q_num = HZIP_QUEUE_NUM_V1;
-			break;
-		case QM_HW_V2:
-			q_num = HZIP_QUEUE_NUM_V2;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	ret = kstrtou32(val, 10, &n);
-	if (ret != 0 || n > q_num || n == 0)
-		return -EINVAL;
-
-	return param_set_int(val, kp);
+	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
 }
 
 static const struct kernel_param_ops pf_q_num_ops = {
-- 
2.7.4

