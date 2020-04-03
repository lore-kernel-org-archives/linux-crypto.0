Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591DDC2D0E8
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3934920B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390504AbgDCIRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:17:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12676 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390511AbgDCIRy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 04:17:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 08737D83D20A21844FFA;
        Fri,  3 Apr 2020 16:17:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 3 Apr 2020 16:17:41 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Yang Shen <shenyang39@huawei.com>,
        "Shukun Tan" <tanshukun1@huawei.com>
Subject: [PATCH 5/5] crypto: hisilicon/qm - stop qp by judging sq and cq tail
Date:   Fri, 3 Apr 2020 16:16:42 +0800
Message-ID: <1585901802-48945-6-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585901802-48945-1-git-send-email-tanshukun1@huawei.com>
References: <1585901802-48945-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yang Shen <shenyang39@huawei.com>

It is not working well to determine whether the queue is empty based on
whether the used count is 0. It is more stable to get if the queue is
stopping by checking if the tail pointer of the send queue and the
completion queue are equal.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 123 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 114 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2a44ccb..88cdf0d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -55,6 +55,7 @@
 #define QM_SQ_TYPE_SHIFT		8
 
 #define QM_SQ_TYPE_MASK			GENMASK(3, 0)
+#define QM_SQ_TAIL_IDX(sqc)		((le16_to_cpu((sqc)->w11) >> 6) & 0x1)
 
 /* cqc shift */
 #define QM_CQ_HOP_NUM_SHIFT		0
@@ -66,6 +67,7 @@
 
 #define QM_CQE_PHASE(cqe)		(le16_to_cpu((cqe)->w7) & 0x1)
 #define QM_QC_CQE_SIZE			4
+#define QM_CQ_TAIL_IDX(cqc)		((le16_to_cpu((cqc)->w11) >> 6) & 0x1)
 
 /* eqc shift */
 #define QM_EQE_AEQE_SIZE		(2UL << 12)
@@ -162,6 +164,8 @@
 
 #define POLL_PERIOD			10
 #define POLL_TIMEOUT			1000
+#define WAIT_PERIOD_US_MAX		200
+#define WAIT_PERIOD_US_MIN		100
 #define MAX_WAIT_COUNTS			1000
 #define QM_CACHE_WB_START		0x204
 #define QM_CACHE_WB_DONE		0x208
@@ -1362,6 +1366,107 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 
+static void *qm_ctx_alloc(struct hisi_qm *qm, size_t ctx_size,
+			  dma_addr_t *dma_addr)
+{
+	struct device *dev = &qm->pdev->dev;
+	void *ctx_addr;
+
+	ctx_addr = kzalloc(ctx_size, GFP_KERNEL);
+	if (!ctx_addr)
+		return ERR_PTR(-ENOMEM);
+
+	*dma_addr = dma_map_single(dev, ctx_addr, ctx_size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, *dma_addr)) {
+		dev_err(dev, "DMA mapping error!\n");
+		kfree(ctx_addr);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return ctx_addr;
+}
+
+static void qm_ctx_free(struct hisi_qm *qm, size_t ctx_size,
+			const void *ctx_addr, dma_addr_t *dma_addr)
+{
+	struct device *dev = &qm->pdev->dev;
+
+	dma_unmap_single(dev, *dma_addr, ctx_size, DMA_FROM_DEVICE);
+	kfree(ctx_addr);
+}
+
+static int qm_dump_sqc_raw(struct hisi_qm *qm, dma_addr_t dma_addr, u16 qp_id)
+{
+	return qm_mb(qm, QM_MB_CMD_SQC, dma_addr, qp_id, 1);
+}
+
+static int qm_dump_cqc_raw(struct hisi_qm *qm, dma_addr_t dma_addr, u16 qp_id)
+{
+	return qm_mb(qm, QM_MB_CMD_CQC, dma_addr, qp_id, 1);
+}
+
+/**
+ * Determine whether the queue is cleared by judging the tail pointers of
+ * sq and cq.
+ */
+static int qm_drain_qp(struct hisi_qp *qp)
+{
+	size_t size = sizeof(struct qm_sqc) + sizeof(struct qm_cqc);
+	struct hisi_qm *qm = qp->qm;
+	struct device *dev = &qm->pdev->dev;
+	struct qm_sqc *sqc;
+	struct qm_cqc *cqc;
+	dma_addr_t dma_addr;
+	int ret = 0, i = 0;
+	void *addr;
+
+	/*
+	 * No need to judge if ECC multi-bit error occurs because the
+	 * master OOO will be blocked.
+	 */
+	if (qm->err_status.is_qm_ecc_mbit || qm->err_status.is_dev_ecc_mbit)
+		return 0;
+
+	addr = qm_ctx_alloc(qm, size, &dma_addr);
+	if (IS_ERR(addr)) {
+		dev_err(dev, "Failed to alloc ctx for sqc and cqc!\n");
+		return -ENOMEM;
+	}
+
+	while (++i) {
+		ret = qm_dump_sqc_raw(qm, dma_addr, qp->qp_id);
+		if (ret) {
+			dev_err_ratelimited(dev, "Failed to dump sqc!\n");
+			break;
+		}
+		sqc = addr;
+
+		ret = qm_dump_cqc_raw(qm, (dma_addr + sizeof(struct qm_sqc)),
+				      qp->qp_id);
+		if (ret) {
+			dev_err_ratelimited(dev, "Failed to dump cqc!\n");
+			break;
+		}
+		cqc = addr + sizeof(struct qm_sqc);
+
+		if ((sqc->tail == cqc->tail) &&
+		    (QM_SQ_TAIL_IDX(sqc) == QM_CQ_TAIL_IDX(cqc)))
+			break;
+
+		if (i == MAX_WAIT_COUNTS) {
+			dev_err(dev, "Fail to empty queue %u!\n", qp->qp_id);
+			ret = -EBUSY;
+			break;
+		}
+
+		usleep_range(WAIT_PERIOD_US_MIN, WAIT_PERIOD_US_MAX);
+	}
+
+	qm_ctx_free(qm, size, addr, &dma_addr);
+
+	return ret;
+}
+
 /**
  * hisi_qm_stop_qp() - Stop a qp in qm.
  * @qp: The qp we want to stop.
@@ -1371,20 +1476,20 @@ EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 int hisi_qm_stop_qp(struct hisi_qp *qp)
 {
 	struct device *dev = &qp->qm->pdev->dev;
-	int i = 0;
+	int ret;
 
 	/* it is stopped */
 	if (test_bit(QP_STOP, &qp->qp_status.flags))
 		return 0;
 
-	while (atomic_read(&qp->qp_status.used)) {
-		i++;
-		msleep(20);
-		if (i == 10) {
-			dev_err(dev, "Cannot drain out data for stopping, Force to stop!\n");
-			return 0;
-		}
-	}
+	ret = qm_drain_qp(qp);
+	if (ret)
+		dev_err(dev, "Failed to drain out data for stopping!\n");
+
+	if (qp->qm->wq)
+		flush_workqueue(qp->qm->wq);
+	else
+		flush_work(&qp->qm->work);
 
 	set_bit(QP_STOP, &qp->qp_status.flags);
 
-- 
2.7.4

