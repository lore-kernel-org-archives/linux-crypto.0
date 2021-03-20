Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97B5C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 11:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A35A61972
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 11:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCTLay (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Mar 2021 07:30:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14110 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCTLaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Mar 2021 07:30:22 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F2dmm3KSNz17NPt;
        Sat, 20 Mar 2021 19:28:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sat, 20 Mar 2021 19:30:12 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - set the number of queues for function
Date:   Sat, 20 Mar 2021 19:27:45 +0800
Message-ID: <1616239666-43572-4-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616239666-43572-1-git-send-email-qianweili@huawei.com>
References: <1616239666-43572-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 supports queue doorbell isolation.
When doorbell isolation is enabled, it supports to obtain the
maximum number of queues of one function from hardware register.
Otherwise, the 'max_qp_num' is the total number of queues.

When assigning queues to VF, it is necessary to ensure that the number
of VF queues does not exceed 'max_qp_num'.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 100 +++++++++++++++++++++++++++++++-----------
 drivers/crypto/hisilicon/qm.h |   4 ++
 2 files changed, 78 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 02f4d02..683ee0c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -93,8 +93,11 @@
 #define QM_DB_PRIORITY_SHIFT_V1		48
 #define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
 #define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
+#define QM_QUE_ISO_CFG_V		0x0030
+#define QM_QUE_ISO_EN			0x100154
 #define QM_CAPBILITY			0x100158
 #define QM_QP_NUN_MASK			GENMASK(10, 0)
+#define QM_QP_MAX_NUM_SHIFT		11
 #define QM_DB_CMD_SHIFT_V2		12
 #define QM_DB_RAND_SHIFT_V2		16
 #define QM_DB_INDEX_SHIFT_V2		32
@@ -876,6 +879,26 @@ static int qm_get_vft_v2(struct hisi_qm *qm, u32 *base, u32 *number)
 	return 0;
 }
 
+static int qm_get_vf_qp_num(struct hisi_qm *qm, u32 fun_num)
+{
+	u32 remain_q_num, vfq_num;
+	u32 num_vfs = qm->vfs_num;
+
+	vfq_num = (qm->ctrl_qp_num - qm->qp_num) / num_vfs;
+	if (vfq_num >= qm->max_qp_num)
+		return qm->max_qp_num;
+
+	remain_q_num = (qm->ctrl_qp_num - qm->qp_num) % num_vfs;
+	if (vfq_num + remain_q_num <= qm->max_qp_num)
+		return fun_num == num_vfs ? vfq_num + remain_q_num : vfq_num;
+
+	/*
+	 * if vfq_num + remain_q_num > max_qp_num, the last VFs,
+	 * each with one more queue.
+	 */
+	return fun_num + remain_q_num > num_vfs ? vfq_num + 1 : vfq_num;
+}
+
 static struct hisi_qm *file_to_qm(struct debugfs_file *file)
 {
 	struct qm_debug *debug = file->debug;
@@ -939,25 +962,16 @@ static u32 current_qm_read(struct debugfs_file *file)
 static int current_qm_write(struct debugfs_file *file, u32 val)
 {
 	struct hisi_qm *qm = file_to_qm(file);
-	u32 vfq_num;
 	u32 tmp;
 
 	if (val > qm->vfs_num)
 		return -EINVAL;
 
 	/* According PF or VF Dev ID to calculation curr_qm_qp_num and store */
-	if (!val) {
+	if (!val)
 		qm->debug.curr_qm_qp_num = qm->qp_num;
-	} else {
-		vfq_num = (qm->ctrl_qp_num - qm->qp_num) / qm->vfs_num;
-
-		if (val == qm->vfs_num)
-			qm->debug.curr_qm_qp_num =
-				qm->ctrl_qp_num - qm->qp_num -
-				(qm->vfs_num - 1) * vfq_num;
-		else
-			qm->debug.curr_qm_qp_num = vfq_num;
-	}
+	else
+		qm->debug.curr_qm_qp_num = qm_get_vf_qp_num(qm, val);
 
 	writel(val, qm->io_base + QM_DFX_MB_CNT_VF);
 	writel(val, qm->io_base + QM_DFX_DB_CNT_VF);
@@ -3236,30 +3250,46 @@ EXPORT_SYMBOL_GPL(hisi_qm_alloc_qps_node);
 
 static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 {
-	u32 remain_q_num, q_num, i, j;
+	u32 remain_q_num, vfs_q_num, act_q_num, q_num, i, j;
+	u32 max_qp_num = qm->max_qp_num;
 	u32 q_base = qm->qp_num;
 	int ret;
 
 	if (!num_vfs)
 		return -EINVAL;
 
-	remain_q_num = qm->ctrl_qp_num - qm->qp_num;
+	vfs_q_num = qm->ctrl_qp_num - qm->qp_num;
 
-	/* If remain queues not enough, return error. */
-	if (qm->ctrl_qp_num < qm->qp_num || remain_q_num < num_vfs)
+	/* If vfs_q_num is less than num_vfs, return error. */
+	if (vfs_q_num < num_vfs)
 		return -EINVAL;
 
-	q_num = remain_q_num / num_vfs;
-	for (i = 1; i <= num_vfs; i++) {
-		if (i == num_vfs)
-			q_num += remain_q_num % num_vfs;
-		ret = hisi_qm_set_vft(qm, i, q_base, q_num);
+	q_num = vfs_q_num / num_vfs;
+	remain_q_num = vfs_q_num % num_vfs;
+
+	for (i = num_vfs; i > 0; i--) {
+		/*
+		 * if q_num + remain_q_num > max_qp_num in last vf, divide the
+		 * remaining queues equally.
+		 */
+		if (i == num_vfs && q_num + remain_q_num <= max_qp_num) {
+			act_q_num = q_num + remain_q_num;
+			remain_q_num = 0;
+		} else if (remain_q_num > 0) {
+			act_q_num = q_num + 1;
+			remain_q_num--;
+		} else {
+			act_q_num = q_num;
+		}
+
+		act_q_num = min_t(int, act_q_num, max_qp_num);
+		ret = hisi_qm_set_vft(qm, i, q_base, act_q_num);
 		if (ret) {
-			for (j = i; j > 0; j--)
+			for (j = num_vfs; j > i; j--)
 				hisi_qm_set_vft(qm, j, 0, 0);
 			return ret;
 		}
-		q_base += q_num;
+		q_base += act_q_num;
 	}
 
 	return 0;
@@ -4180,7 +4210,7 @@ void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_alg_unregister);
 
-static void qm_get_qp_num(struct hisi_qm *qm)
+static int qm_get_qp_num(struct hisi_qm *qm)
 {
 	if (qm->ver == QM_HW_V1)
 		qm->ctrl_qp_num = QM_QNUM_V1;
@@ -4189,6 +4219,21 @@ static void qm_get_qp_num(struct hisi_qm *qm)
 	else
 		qm->ctrl_qp_num = readl(qm->io_base + QM_CAPBILITY) &
 					QM_QP_NUN_MASK;
+
+	if (qm->use_db_isolation)
+		qm->max_qp_num = (readl(qm->io_base + QM_CAPBILITY) >>
+				  QM_QP_MAX_NUM_SHIFT) & QM_QP_NUN_MASK;
+	else
+		qm->max_qp_num = qm->ctrl_qp_num;
+
+	/* check if qp number is valid */
+	if (qm->qp_num > qm->max_qp_num) {
+		dev_err(&qm->pdev->dev, "qp num(%u) is more than max qp num(%u)!\n",
+			qm->qp_num, qm->max_qp_num);
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int hisi_qm_pci_init(struct hisi_qm *qm)
@@ -4218,8 +4263,11 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 		goto err_release_mem_regions;
 	}
 
-	if (qm->fun_type == QM_HW_PF)
-		qm_get_qp_num(qm);
+	if (qm->fun_type == QM_HW_PF) {
+		ret = qm_get_qp_num(qm);
+		if (ret)
+			goto err_iounmap;
+	}
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret < 0)
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 5c4797b..cf0290f 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -207,6 +207,7 @@ struct hisi_qm {
 	u32 qp_num;
 	u32 qp_in_used;
 	u32 ctrl_qp_num;
+	u32 max_qp_num;
 	u32 vfs_num;
 	struct list_head list;
 	struct hisi_qm_list *qm_list;
@@ -245,6 +246,9 @@ struct hisi_qm {
 	const char *algs;
 	bool use_sva;
 	bool is_frozen;
+
+	/* doorbell isolation enable */
+	bool use_db_isolation;
 	resource_size_t phys_base;
 	resource_size_t phys_size;
 	struct uacce_device *uacce;
-- 
2.8.1

