Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E258C433F4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8404D2080D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgGWHWH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:22:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8357 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726928AbgGWHWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:22:06 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C7E28E1CEE3A9522F29;
        Thu, 23 Jul 2020 15:21:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 15:21:44 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v3 05/10] crypto: hisilicon/qm - fix event queue depth to 2048
Date:   Thu, 23 Jul 2020 15:19:35 +0800
Message-ID: <1595488780-22085-6-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
References: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shukun Tan <tanshukun1@huawei.com>

Increasing depth of 'event queue' from 1024 to 2048, which equals to twice
depth of 'completion queue'. It will fix the easily happened 'event queue
overflow' as using 1024 queue depth for 'event queue'.

Fixes: 263c9959c937("crypto: hisilicon - add queue management driver...")
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9a5a114..0f2a48a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -181,6 +181,7 @@
 #define QM_PCI_COMMAND_INVALID		~0
 
 #define QM_SQE_ADDR_MASK		GENMASK(7, 0)
+#define QM_EQ_DEPTH			(1024 * 2)
 
 #define QM_MK_CQC_DW3_V1(hop_num, pg_sz, buf_sz, cqe_sz) \
 	(((hop_num) << QM_CQ_HOP_NUM_SHIFT)	| \
@@ -652,7 +653,7 @@ static void qm_work_process(struct work_struct *work)
 		qp = qm_to_hisi_qp(qm, eqe);
 		qm_poll_qp(qp, qm);
 
-		if (qm->status.eq_head == QM_Q_DEPTH - 1) {
+		if (qm->status.eq_head == QM_EQ_DEPTH - 1) {
 			qm->status.eqc_phase = !qm->status.eqc_phase;
 			eqe = qm->eqe;
 			qm->status.eq_head = 0;
@@ -661,7 +662,7 @@ static void qm_work_process(struct work_struct *work)
 			qm->status.eq_head++;
 		}
 
-		if (eqe_num == QM_Q_DEPTH / 2 - 1) {
+		if (eqe_num == QM_EQ_DEPTH / 2 - 1) {
 			eqe_num = 0;
 			qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
 		}
@@ -1371,7 +1372,13 @@ static int qm_eq_aeq_dump(struct hisi_qm *qm, const char *s,
 		return -EINVAL;
 
 	ret = kstrtou32(s, 0, &xeqe_id);
-	if (ret || xeqe_id >= QM_Q_DEPTH) {
+	if (ret)
+		return -EINVAL;
+
+	if (!strcmp(name, "EQE") && xeqe_id >= QM_EQ_DEPTH) {
+		dev_err(dev, "Please input eqe num (0-%d)", QM_EQ_DEPTH - 1);
+		return -EINVAL;
+	} else if (!strcmp(name, "AEQE") && xeqe_id >= QM_Q_DEPTH) {
 		dev_err(dev, "Please input aeqe num (0-%d)", QM_Q_DEPTH - 1);
 		return -EINVAL;
 	}
@@ -2284,7 +2291,7 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 } while (0)
 
 	idr_init(&qm->qp_idr);
-	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_Q_DEPTH) +
+	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * QM_EQ_DEPTH) +
 			QMC_ALIGN(sizeof(struct qm_aeqe) * QM_Q_DEPTH) +
 			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
 			QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
@@ -2294,7 +2301,7 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 	if (!qm->qdma.va)
 		return -ENOMEM;
 
-	QM_INIT_BUF(qm, eqe, QM_Q_DEPTH);
+	QM_INIT_BUF(qm, eqe, QM_EQ_DEPTH);
 	QM_INIT_BUF(qm, aeqe, QM_Q_DEPTH);
 	QM_INIT_BUF(qm, sqc, qm->qp_num);
 	QM_INIT_BUF(qm, cqc, qm->qp_num);
@@ -2464,7 +2471,7 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
 	eqc->base_h = cpu_to_le32(upper_32_bits(qm->eqe_dma));
 	if (qm->ver == QM_HW_V1)
 		eqc->dw3 = cpu_to_le32(QM_EQE_AEQE_SIZE);
-	eqc->dw6 = cpu_to_le32((QM_Q_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
+	eqc->dw6 = cpu_to_le32((QM_EQ_DEPTH - 1) | (1 << QM_EQC_PHASE_SHIFT));
 	ret = qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
 	dma_unmap_single(dev, eqc_dma, sizeof(struct qm_eqc), DMA_TO_DEVICE);
 	kfree(eqc);
-- 
2.7.4

