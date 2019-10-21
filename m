Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3E0CA9EB7
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9D12089C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJUHk3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 03:40:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57406 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbfJUHk3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 03:40:29 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D6E12CA1ECCE4CC5F8C2;
        Mon, 21 Oct 2019 15:40:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 21 Oct 2019 15:40:19 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon - fix endianness verification problem of QM
Date:   Mon, 21 Oct 2019 15:41:03 +0800
Message-ID: <1571643663-29593-5-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
References: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes following sparse warning:

qm.c:345:33: warning: cast removes address space '<asn:2>' of expression
qm.c:359:20: warning: incorrect type in assignment (different base types)
qm.c:359:20:    expected restricted __le16 [usertype] w0
qm.c:359:20:    got int
qm.c:362:27: warning: incorrect type in assignment (different base types)
qm.c:362:27:    expected restricted __le16 [usertype] queue_num
qm.c:362:27:    got unsigned short [usertype] queue
qm.c:363:24: warning: incorrect type in assignment (different base types)
qm.c:363:24:    expected restricted __le32 [usertype] base_l
qm.c:363:24:    got unsigned int [usertype]
qm.c:364:24: warning: incorrect type in assignment (different base types)
qm.c:364:24:    expected restricted __le32 [usertype] base_h
qm.c:364:24:    got unsigned int [usertype]
qm.c:451:22: warning: restricted __le32 degrades to integer
qm.c:471:24: warning: restricted __le16 degrades to integer
......
qm.c:1617:19: warning: incorrect type in assignment (different base types)
qm.c:1617:19:    expected restricted __le32 [usertype] dw6
qm.c:1617:19:    got int
qm.c:1891:24: warning: incorrect type in return expression (different base types)
qm.c:1891:24:    expected int
qm.c:1891:24:    got restricted pci_ers_result_t
qm.c:1894:40: warning: incorrect type in return expression (different base types)
qm.c:1894:40:    expected int
qm.c:1894:40:    got restricted pci_ers_result_t

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 87 ++++++++++++++++++++++---------------------
 drivers/crypto/hisilicon/qm.h |  2 +-
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2c17bf3..4dc8825 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -59,17 +59,17 @@
 #define QM_CQ_PHASE_SHIFT		0
 #define QM_CQ_FLAG_SHIFT		1
 
-#define QM_CQE_PHASE(cqe)		((cqe)->w7 & 0x1)
+#define QM_CQE_PHASE(cqe)		(le16_to_cpu((cqe)->w7) & 0x1)
 #define QM_QC_CQE_SIZE			4
 
 /* eqc shift */
 #define QM_EQE_AEQE_SIZE		(2UL << 12)
 #define QM_EQC_PHASE_SHIFT		16
 
-#define QM_EQE_PHASE(eqe)		(((eqe)->dw0 >> 16) & 0x1)
+#define QM_EQE_PHASE(eqe)		((le32_to_cpu((eqe)->dw0) >> 16) & 0x1)
 #define QM_EQE_CQN_MASK			GENMASK(15, 0)
 
-#define QM_AEQE_PHASE(aeqe)		(((aeqe)->dw0 >> 16) & 0x1)
+#define QM_AEQE_PHASE(aeqe)		((le32_to_cpu((aeqe)->dw0) >> 16) & 0x1)
 #define QM_AEQE_TYPE_SHIFT		17
 
 #define QM_DOORBELL_CMD_SQ		0
@@ -169,17 +169,17 @@
 #define QM_MK_SQC_DW3_V2(sqe_sz) \
 	((QM_Q_DEPTH - 1) | ((u32)ilog2(sqe_sz) << QM_SQ_SQE_SIZE_SHIFT))
 
-#define INIT_QC_COMMON(qc, base, pasid) do {	\
-	(qc)->head = 0;				\
-	(qc)->tail = 0;				\
-	(qc)->base_l = lower_32_bits(base);	\
-	(qc)->base_h = upper_32_bits(base);	\
-	(qc)->dw3 = 0;				\
-	(qc)->w8 = 0;				\
-	(qc)->rsvd0 = 0;			\
-	(qc)->pasid = pasid;			\
-	(qc)->w11 = 0;				\
-	(qc)->rsvd1 = 0;			\
+#define INIT_QC_COMMON(qc, base, pasid) do {			\
+	(qc)->head = 0;						\
+	(qc)->tail = 0;						\
+	(qc)->base_l = cpu_to_le32(lower_32_bits(base));	\
+	(qc)->base_h = cpu_to_le32(upper_32_bits(base));	\
+	(qc)->dw3 = 0;						\
+	(qc)->w8 = 0;						\
+	(qc)->rsvd0 = 0;					\
+	(qc)->pasid = cpu_to_le16(pasid);			\
+	(qc)->w11 = 0;						\
+	(qc)->rsvd1 = 0;					\
 } while (0)
 
 enum vft_type {
@@ -342,7 +342,7 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 		     "dsb sy\n"
 		     : "=&r" (tmp0),
 		       "=&r" (tmp1),
-		       "+Q" (*((char *)fun_base))
+		       "+Q" (*((char __iomem *)fun_base))
 		     : "Q" (*((char *)src))
 		     : "memory");
 }
@@ -356,12 +356,12 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%llx\n",
 		queue, cmd, (unsigned long long)dma_addr);
 
-	mailbox.w0 = cmd |
+	mailbox.w0 = cpu_to_le16(cmd |
 		     (op ? 0x1 << QM_MB_OP_SHIFT : 0) |
-		     (0x1 << QM_MB_BUSY_SHIFT);
-	mailbox.queue_num = queue;
-	mailbox.base_l = lower_32_bits(dma_addr);
-	mailbox.base_h = upper_32_bits(dma_addr);
+		     (0x1 << QM_MB_BUSY_SHIFT));
+	mailbox.queue_num = cpu_to_le16(queue);
+	mailbox.base_l = cpu_to_le32(lower_32_bits(dma_addr));
+	mailbox.base_h = cpu_to_le32(upper_32_bits(dma_addr));
 	mailbox.rsvd = 0;
 
 	mutex_lock(&qm->mailbox_lock);
@@ -448,7 +448,7 @@ static u32 qm_get_irq_num_v2(struct hisi_qm *qm)
 
 static struct hisi_qp *qm_to_hisi_qp(struct hisi_qm *qm, struct qm_eqe *eqe)
 {
-	u16 cqn = eqe->dw0 & QM_EQE_CQN_MASK;
+	u16 cqn = le32_to_cpu(eqe->dw0) & QM_EQE_CQN_MASK;
 
 	return qm->qp_array[cqn];
 }
@@ -470,7 +470,8 @@ static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
 	if (qp->req_cb) {
 		while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
 			dma_rmb();
-			qp->req_cb(qp, qp->sqe + qm->sqe_size * cqe->sq_head);
+			qp->req_cb(qp, qp->sqe + qm->sqe_size *
+				   le16_to_cpu(cqe->sq_head));
 			qm_cq_head_update(qp);
 			cqe = qp->cqe + qp->qp_status.cq_head;
 			qm_db(qm, qp->qp_id, QM_DOORBELL_CMD_CQ,
@@ -548,7 +549,7 @@ static irqreturn_t qm_aeq_irq(int irq, void *data)
 		return IRQ_NONE;
 
 	while (QM_AEQE_PHASE(aeqe) == qm->status.aeqc_phase) {
-		type = aeqe->dw0 >> QM_AEQE_TYPE_SHIFT;
+		type = le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT;
 		if (type < ARRAY_SIZE(qm_fifo_overflow))
 			dev_err(&qm->pdev->dev, "%s overflow\n",
 				qm_fifo_overflow[type]);
@@ -652,7 +653,7 @@ static void qm_init_qp_status(struct hisi_qp *qp)
 
 	qp_status->sq_tail = 0;
 	qp_status->cq_head = 0;
-	qp_status->cqc_phase = 1;
+	qp_status->cqc_phase = true;
 	qp_status->flags = 0;
 }
 
@@ -1221,14 +1222,14 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 
 	INIT_QC_COMMON(sqc, qp->sqe_dma, pasid);
 	if (ver == QM_HW_V1) {
-		sqc->dw3 = QM_MK_SQC_DW3_V1(0, 0, 0, qm->sqe_size);
-		sqc->w8 = QM_Q_DEPTH - 1;
+		sqc->dw3 = cpu_to_le32(QM_MK_SQC_DW3_V1(0, 0, 0, qm->sqe_size));
+		sqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
 	} else if (ver == QM_HW_V2) {
-		sqc->dw3 = QM_MK_SQC_DW3_V2(qm->sqe_size);
+		sqc->dw3 = cpu_to_le32(QM_MK_SQC_DW3_V2(qm->sqe_size));
 		sqc->w8 = 0; /* rand_qc */
 	}
-	sqc->cq_num = qp_id;
-	sqc->w13 = QM_MK_SQC_W13(0, 1, qp->alg_type);
+	sqc->cq_num = cpu_to_le16(qp_id);
+	sqc->w13 = cpu_to_le16(QM_MK_SQC_W13(0, 1, qp->alg_type));
 
 	ret = qm_mb(qm, QM_MB_CMD_SQC, sqc_dma, qp_id, 0);
 	dma_unmap_single(dev, sqc_dma, sizeof(struct qm_sqc), DMA_TO_DEVICE);
@@ -1248,13 +1249,13 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 
 	INIT_QC_COMMON(cqc, qp->cqe_dma, pasid);
 	if (ver == QM_HW_V1) {
-		cqc->dw3 = QM_MK_CQC_DW3_V1(0, 0, 0, 4);
-		cqc->w8 = QM_Q_DEPTH - 1;
+		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V1(0, 0, 0, 4));
+		cqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
 	} else if (ver == QM_HW_V2) {
-		cqc->dw3 = QM_MK_CQC_DW3_V2(4);
+		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(4));
 		cqc->w8 = 0;
 	}
-	cqc->dw6 = 1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT;
+	cqc->dw6 = cpu_to_le32(1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT);
 
 	ret = qm_mb(qm, QM_MB_CMD_CQC, cqc_dma, qp_id, 0);
 	dma_unmap_single(dev, cqc_dma, sizeof(struct qm_cqc), DMA_TO_DEVICE);
@@ -1563,8 +1564,8 @@ static void qm_init_eq_aeq_status(struct hisi_qm *qm)
 
 	status->eq_head = 0;
 	status->aeq_head = 0;
-	status->eqc_phase = 1;
-	status->aeqc_phase = 1;
+	status->eqc_phase = true;
+	status->aeqc_phase = true;
 }
 
 static int qm_eq_ctx_cfg(struct hisi_qm *qm)
@@ -1588,11 +1589,11 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 		return -ENOMEM;
 	}
 
-	eqc->base_l = lower_32_bits(qm->eqe_dma);
-	eqc->base_h = upper_32_bits(qm->eqe_dma);
+	eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
+	eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
 	if (qm->ver == QM_HW_V1)
-		eqc->dw3 = QM_EQE_AEQE_SIZE;
-	eqc->dw6 = (QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT);
+		eqc->dw3 = cpu_to_le32(QM_EQE_AEQE_SIZE);
+	eqc->dw6 = cpu_to_le32((QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
 	ret = qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
 	dma_unmap_single(dev, eqc_dma, sizeof(struct qm_eqc), DMA_TO_DEVICE);
 	kfree(eqc);
@@ -1609,9 +1610,9 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 		return -ENOMEM;
 	}
 
-	aeqc->base_l = lower_32_bits(qm->aeqe_dma);
-	aeqc->base_h = upper_32_bits(qm->aeqe_dma);
-	aeqc->dw6 = (QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT);
+	aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
+	aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
+	aeqc->dw6 = cpu_to_le32((QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
 
 	ret = qm_mb(qm, QM_MB_CMD_AEQC, aeqc_dma, 0, 0);
 	dma_unmap_single(dev, aeqc_dma, sizeof(struct qm_aeqc), DMA_TO_DEVICE);
@@ -1879,7 +1880,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_hw_error_init);
  *
  * Accelerators use this function to handle qm non-fatal hardware errors.
  */
-int hisi_qm_hw_error_handle(struct hisi_qm *qm)
+pci_ers_result_t hisi_qm_hw_error_handle(struct hisi_qm *qm)
 {
 	if (!qm->ops->hw_error_handle) {
 		dev_err(&qm->pdev->dev, "QM doesn't support hw error report!\n");
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 103e2fd..61064bd 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -211,7 +211,7 @@ int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base, u32 number);
 int hisi_qm_debug_init(struct hisi_qm *qm);
 void hisi_qm_hw_error_init(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 			   u32 msi);
-int hisi_qm_hw_error_handle(struct hisi_qm *qm);
+pci_ers_result_t hisi_qm_hw_error_handle(struct hisi_qm *qm);
 enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev);
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm);
 
-- 
2.7.4

