Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA2CC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0944D64F53
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhBDJDY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:03:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12026 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbhBDJCr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 04:02:47 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DWXZc3kW0zjJnk;
        Thu,  4 Feb 2021 17:00:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 17:01:50 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] crypto: hisilicon/qm - fix use of 'dma_map_single'
Date:   Thu, 4 Feb 2021 16:59:35 +0800
Message-ID: <1612429176-28084-4-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612429176-28084-1-git-send-email-tanghui20@huawei.com>
References: <1612429176-28084-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

Calling 'dma_map_single' after the data is written to
ensure that the cpu cache and dma cache are consistent.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 50 +++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 904b99a..93d4a21 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1747,12 +1747,6 @@ static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	sqc = kzalloc(sizeof(struct qm_sqc), GFP_KERNEL);
 	if (!sqc)
 		return -ENOMEM;
-	sqc_dma = dma_map_single(dev, sqc, sizeof(struct qm_sqc),
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, sqc_dma)) {
-		kfree(sqc);
-		return -ENOMEM;
-	}

 	INIT_QC_COMMON(sqc, qp->sqe_dma, pasid);
 	if (ver == QM_HW_V1) {
@@ -1765,6 +1759,13 @@ static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	sqc->cq_num = cpu_to_le16(qp_id);
 	sqc->w13 = cpu_to_le16(QM_MK_SQC_W13(0, 1, qp->alg_type));

+	sqc_dma = dma_map_single(dev, sqc, sizeof(struct qm_sqc),
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, sqc_dma)) {
+		kfree(sqc);
+		return -ENOMEM;
+	}
+
 	ret = qm_mb(qm, QM_MB_CMD_SQC, sqc_dma, qp_id, 0);
 	dma_unmap_single(dev, sqc_dma, sizeof(struct qm_sqc), DMA_TO_DEVICE);
 	kfree(sqc);
@@ -1784,12 +1785,6 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	cqc = kzalloc(sizeof(struct qm_cqc), GFP_KERNEL);
 	if (!cqc)
 		return -ENOMEM;
-	cqc_dma = dma_map_single(dev, cqc, sizeof(struct qm_cqc),
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, cqc_dma)) {
-		kfree(cqc);
-		return -ENOMEM;
-	}

 	INIT_QC_COMMON(cqc, qp->cqe_dma, pasid);
 	if (ver == QM_HW_V1) {
@@ -1802,6 +1797,13 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	}
 	cqc->dw6 = cpu_to_le32(1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT);

+	cqc_dma = dma_map_single(dev, cqc, sizeof(struct qm_cqc),
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, cqc_dma)) {
+		kfree(cqc);
+		return -ENOMEM;
+	}
+
 	ret = qm_mb(qm, QM_MB_CMD_CQC, cqc_dma, qp_id, 0);
 	dma_unmap_single(dev, cqc_dma, sizeof(struct qm_cqc), DMA_TO_DEVICE);
 	kfree(cqc);
@@ -2558,15 +2560,9 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 	dma_addr_t eqc_dma;
 	int ret;

-	eqc = kzalloc(sizeof(struct qm_eqc), GFP_KERNEL); //todo
+	eqc = kzalloc(sizeof(struct qm_eqc), GFP_KERNEL);
 	if (!eqc)
 		return -ENOMEM;
-	eqc_dma = dma_map_single(dev, eqc, sizeof(struct qm_eqc),
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, eqc_dma)) {
-		kfree(eqc);
-		return -ENOMEM;
-	}

 	eqc->base_l = cpu_to_le32(lower_32_bits(qm->eqe_dma));
 	eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
@@ -2574,6 +2570,13 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 		eqc->dw3 = cpu_to_le32(QM_EQE_AEQE_SIZE);
 	eqc->dw6 = cpu_to_le32((QM_EQ_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));

+	eqc_dma = dma_map_single(dev, eqc, sizeof(struct qm_eqc),
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, eqc_dma)) {
+		kfree(eqc);
+		return -ENOMEM;
+	}
+
 	ret = qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
 	dma_unmap_single(dev, eqc_dma, sizeof(struct qm_eqc), DMA_TO_DEVICE);
 	kfree(eqc);
@@ -2591,6 +2594,11 @@ static int qm_aeq_ctx_cfg(struct hisi_qm *qm)
 	aeqc = kzalloc(sizeof(struct qm_aeqc), GFP_KERNEL);
 	if (!aeqc)
 		return -ENOMEM;
+
+	aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
+	aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
+	aeqc->dw6 = cpu_to_le32((QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
+
 	aeqc_dma = dma_map_single(dev, aeqc, sizeof(struct qm_aeqc),
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, aeqc_dma)) {
@@ -2598,10 +2606,6 @@ static int qm_aeq_ctx_cfg(struct hisi_qm *qm)
 		return -ENOMEM;
 	}

-	aeqc->base_l = cpu_to_le32(lower_32_bits(qm->aeqe_dma));
-	aeqc->base_h = cpu_to_le32(upper_32_bits(qm->aeqe_dma));
-	aeqc->dw6 = cpu_to_le32((QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
-
 	ret = qm_mb(qm, QM_MB_CMD_AEQC, aeqc_dma, 0, 0);
 	dma_unmap_single(dev, aeqc_dma, sizeof(struct qm_aeqc), DMA_TO_DEVICE);
 	kfree(aeqc);
--
2.8.1

