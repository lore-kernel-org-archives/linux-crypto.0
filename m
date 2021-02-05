Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910F4C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC1A64FF4
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBEKS3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:18:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12137 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhBEKQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:07 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DXB8r3Bc8z164xV;
        Fri,  5 Feb 2021 18:14:04 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:14 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 6/6] crypto: hisilicon/qm - fix printing format issue
Date:   Fri, 5 Feb 2021 18:12:58 +0800
Message-ID: <1612519978-33340-7-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes inconsistent of printing format with argument type.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 16 ++++++++--------
 drivers/crypto/hisilicon/qm.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 5dbc054..47df981 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -723,7 +723,7 @@ static irqreturn_t qm_aeq_irq(int irq, void *data)
 			dev_err(&qm->pdev->dev, "%s overflow\n",
 				qm_fifo_overflow[type]);
 		else
-			dev_err(&qm->pdev->dev, "unknown error type %d\n",
+			dev_err(&qm->pdev->dev, "unknown error type %u\n",
 				type);
 
 		if (qm->status.aeq_head == QM_Q_DEPTH - 1) {
@@ -1127,7 +1127,7 @@ static int dump_show(struct hisi_qm *qm, void *info,
 
 	dev_info(dev, "%s DUMP\n", info_name);
 	for (i = 0; i < info_size; i += BYTE_PER_DW) {
-		pr_info("DW%d: %02X%02X %02X%02X\n", i / BYTE_PER_DW,
+		pr_info("DW%u: %02X%02X %02X%02X\n", i / BYTE_PER_DW,
 			info_buf[i], info_buf[i + 1UL],
 			info_buf[i + 2UL], info_buf[i + 3UL]);
 	}
@@ -1160,7 +1160,7 @@ static int qm_sqc_dump(struct hisi_qm *qm, const char *s)
 
 	ret = kstrtou32(s, 0, &qp_id);
 	if (ret || qp_id >= qm->qp_num) {
-		dev_err(dev, "Please input qp num (0-%d)", qm->qp_num - 1);
+		dev_err(dev, "Please input qp num (0-%u)", qm->qp_num - 1);
 		return -EINVAL;
 	}
 
@@ -1206,7 +1206,7 @@ static int qm_cqc_dump(struct hisi_qm *qm, const char *s)
 
 	ret = kstrtou32(s, 0, &qp_id);
 	if (ret || qp_id >= qm->qp_num) {
-		dev_err(dev, "Please input qp num (0-%d)", qm->qp_num - 1);
+		dev_err(dev, "Please input qp num (0-%u)", qm->qp_num - 1);
 		return -EINVAL;
 	}
 
@@ -1285,7 +1285,7 @@ static int q_dump_param_parse(struct hisi_qm *qm, char *s,
 
 	ret = kstrtou32(presult, 0, q_id);
 	if (ret || *q_id >= qp_num) {
-		dev_err(dev, "Please input qp num (0-%d)", qp_num - 1);
+		dev_err(dev, "Please input qp num (0-%u)", qp_num - 1);
 		return -EINVAL;
 	}
 
@@ -2714,7 +2714,7 @@ int hisi_qm_start(struct hisi_qm *qm)
 		return -EPERM;
 	}
 
-	dev_dbg(dev, "qm start with %d queue pairs\n", qm->qp_num);
+	dev_dbg(dev, "qm start with %u queue pairs\n", qm->qp_num);
 
 	if (!qm->qp_num) {
 		dev_err(dev, "qp_num should not be 0\n");
@@ -3149,7 +3149,7 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	mutex_unlock(&qm_list->lock);
 	if (ret)
-		pr_info("Failed to create qps, node[%d], alg[%d], qp[%d]!\n",
+		pr_info("Failed to create qps, node[%d], alg[%u], qp[%d]!\n",
 			node, alg_type, qp_num);
 
 err:
@@ -3357,7 +3357,7 @@ pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
 	if (pdev->is_virtfn)
 		return PCI_ERS_RESULT_NONE;
 
-	pci_info(pdev, "PCI error detected, state(=%d)!!\n", state);
+	pci_info(pdev, "PCI error detected, state(=%u)!!\n", state);
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 6be5338..46e3a67 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -306,7 +306,7 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 
 	if (!pdev) {
 		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
-		pr_info("No device found currently, suppose queue number is %d\n",
+		pr_info("No device found currently, suppose queue number is %u\n",
 			q_num);
 	} else {
 		if (pdev->revision == QM_HW_V1)
-- 
2.8.1

