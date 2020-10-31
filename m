Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F7AC5517A
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946C42076D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgJaJIt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:08:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:7387 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgJaJIt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CNYJH0F7gz70s3;
        Sat, 31 Oct 2020 17:08:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:35 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 6/8] crypto: hisilicon/qm - split 'qm_qp_ctx_cfg' into smaller pieces
Date:   Sat, 31 Oct 2020 17:07:06 +0800
Message-ID: <1604135228-18410-7-git-send-email-qianweili@huawei.com>
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

'qm_qp_ctx_cfg' initializes configuration of SQ and CQ,
split it into two pieces to improve code readability.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 25c5414..4c5cc60 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1735,19 +1735,15 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
 
-static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
+static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
 {
 	struct hisi_qm *qm = qp->qm;
 	struct device *dev = &qm->pdev->dev;
 	enum qm_hw_ver ver = qm->ver;
 	struct qm_sqc *sqc;
-	struct qm_cqc *cqc;
 	dma_addr_t sqc_dma;
-	dma_addr_t cqc_dma;
 	int ret;
 
-	qm_init_qp_status(qp);
-
 	sqc = kzalloc(sizeof(struct qm_sqc), GFP_KERNEL);
 	if (!sqc)
 		return -ENOMEM;
@@ -1772,12 +1768,23 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	ret = qm_mb(qm, QM_MB_CMD_SQC, sqc_dma, qp_id, 0);
 	dma_unmap_single(dev, sqc_dma, sizeof(struct qm_sqc), DMA_TO_DEVICE);
 	kfree(sqc);
-	if (ret)
-		return ret;
+
+	return ret;
+}
+
+static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+{
+	struct hisi_qm *qm = qp->qm;
+	struct device *dev = &qm->pdev->dev;
+	enum qm_hw_ver ver = qm->ver;
+	struct qm_cqc *cqc;
+	dma_addr_t cqc_dma;
+	int ret;
 
 	cqc = kzalloc(sizeof(struct qm_cqc), GFP_KERNEL);
 	if (!cqc)
 		return -ENOMEM;
+
 	cqc_dma = dma_map_single(dev, cqc, sizeof(struct qm_cqc),
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, cqc_dma)) {
@@ -1792,7 +1799,7 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 		cqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
 	} else {
 		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(QM_QC_CQE_SIZE));
-		cqc->w8 = 0;
+		cqc->w8 = 0; /* rand_qc */
 	}
 	cqc->dw6 = cpu_to_le32(1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT);
 
@@ -1803,6 +1810,19 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	return ret;
 }
 
+static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
+{
+	int ret;
+
+	qm_init_qp_status(qp);
+
+	ret = qm_sq_ctx_cfg(qp, qp_id, pasid);
+	if (ret)
+		return ret;
+
+	return qm_cq_ctx_cfg(qp, qp_id, pasid);
+}
+
 static int qm_start_qp_nolock(struct hisi_qp *qp, unsigned long arg)
 {
 	struct hisi_qm *qm = qp->qm;
-- 
2.8.1

