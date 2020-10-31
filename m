Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6827DC4741F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 400792076D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgJaJJE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:09:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:7386 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgJaJIt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CNYJH04GCz70kF;
        Sat, 31 Oct 2020 17:08:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:35 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 7/8] crypto: hisilicon/qm - split 'qm_eq_ctx_cfg' into smaller pieces
Date:   Sat, 31 Oct 2020 17:07:07 +0800
Message-ID: <1604135228-18410-8-git-send-email-qianweili@huawei.com>
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

'qm_eq_ctx_cfg' initializes configuration of EQ and AEQ,
split it into two pieces to improve code readability.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 44 +++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4c5cc60..6e8d20d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1735,7 +1735,7 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
 
-static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
@@ -1772,7 +1772,7 @@ static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	return ret;
 }
 
-static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
@@ -1784,7 +1784,6 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	cqc = kzalloc(sizeof(struct qm_cqc), GFP_KERNEL);
 	if (!cqc)
 		return -ENOMEM;
-
 	cqc_dma = dma_map_single(dev, cqc, sizeof(struct qm_cqc),
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, cqc_dma)) {
@@ -1810,7 +1809,7 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 	return ret;
 }
 
-static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 {
 	int ret;
 
@@ -2550,14 +2549,10 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct qm_eqc *eqc;
-	struct qm_aeqc *aeqc;
 	dma_addr_t eqc_dma;
-	dma_addr_t aeqc_dma;
 	int ret;
 
-	qm_init_eq_aeq_status(qm);
-
-	eqc = kzalloc(sizeof(struct qm_eqc), GFP_KERNEL);
+	eqc = kzalloc(sizeof(struct qm_eqc), GFP_KERNEL); //todo
 	if (!eqc)
 		return -ENOMEM;
 	eqc_dma = dma_map_single(dev, eqc, sizeof(struct qm_eqc),
@@ -2572,11 +2567,20 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 	if (qm->ver == QM_HW_V1)
 		eqc->dw3 = cpu_to_le32(QM_EQE_AEQE_SIZE);
 	eqc->dw6 = cpu_to_le32((QM_EQ_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
+
 	ret = qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
 	dma_unmap_single(dev, eqc_dma, sizeof(struct qm_eqc), DMA_TO_DEVICE);
 	kfree(eqc);
-	if (ret)
-		return ret;
+
+	return ret;
+}
+
+static int qm_aeq_ctx_cfg(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	struct qm_aeqc *aeqc;
+	dma_addr_t aeqc_dma;
+	int ret;
 
 	aeqc = kzalloc(sizeof(struct qm_aeqc), GFP_KERNEL);
 	if (!aeqc)
@@ -2599,6 +2603,22 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 	return ret;
 }
 
+static int qm_eq_aeq_ctx_cfg(struct hisi_qm *qm)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+
+	qm_init_eq_aeq_status(qm);
+
+	ret = qm_eq_ctx_cfg(qm);
+	if (ret) {
+		dev_err(dev, "Set eqc failed!\n");
+		return ret;
+	}
+
+	return qm_aeq_ctx_cfg(qm);
+}
+
 static int __hisi_qm_start(struct hisi_qm *qm)
 {
 	int ret;
@@ -2615,7 +2635,7 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 			return ret;
 	}
 
-	ret = qm_eq_ctx_cfg(qm);
+	ret = qm_eq_aeq_ctx_cfg(qm);
 	if (ret)
 		return ret;
 
-- 
2.8.1

