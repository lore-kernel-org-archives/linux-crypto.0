Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E744CC4742C
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65ED2076E
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgJaJJN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:09:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7021 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgJaJIo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:44 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNYJ95TPvzhcgV;
        Sat, 31 Oct 2020 17:08:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:33 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/8] crypto: hisilicon/qm - numbers are replaced by macros
Date:   Sat, 31 Oct 2020 17:07:01 +0800
Message-ID: <1604135228-18410-2-git-send-email-qianweili@huawei.com>
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

Some numbers are replaced by macros to avoid incomprehension.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 050fe4e..1de3aac 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -473,7 +473,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
 
 	return readl_relaxed_poll_timeout(qm->io_base + QM_MB_CMD_SEND_BASE,
 					  val, !((val >> QM_MB_BUSY_SHIFT) &
-					  0x1), 10, 1000);
+					  0x1), POLL_PERIOD, POLL_TIMEOUT);
 }
 
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
@@ -583,7 +583,8 @@ static int qm_dev_mem_reset(struct hisi_qm *qm)
 
 	writel(0x1, qm->io_base + QM_MEM_START_INIT);
 	return readl_relaxed_poll_timeout(qm->io_base + QM_MEM_INIT_DONE, val,
-					  val & BIT(0), 10, 1000);
+					  val & BIT(0), POLL_PERIOD,
+					  POLL_TIMEOUT);
 }
 
 static u32 qm_get_irq_num_v1(struct hisi_qm *qm)
@@ -804,7 +805,8 @@ static int qm_set_vft_common(struct hisi_qm *qm, enum vft_type type,
 	int ret;
 
 	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
-					 val & BIT(0), 10, 1000);
+					 val & BIT(0), POLL_PERIOD,
+					 POLL_TIMEOUT);
 	if (ret)
 		return ret;
 
@@ -818,7 +820,8 @@ static int qm_set_vft_common(struct hisi_qm *qm, enum vft_type type,
 	writel(0x1, qm->io_base + QM_VFT_CFG_OP_ENABLE);
 
 	return readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
-					  val & BIT(0), 10, 1000);
+					  val & BIT(0), POLL_PERIOD,
+					  POLL_TIMEOUT);
 }
 
 /* The config should be conducted after qm_dev_mem_reset() */
@@ -1785,10 +1788,11 @@ static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 
 	INIT_QC_COMMON(cqc, qp->cqe_dma, pasid);
 	if (ver == QM_HW_V1) {
-		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V1(0, 0, 0, 4));
+		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V1(0, 0, 0,
+							QM_QC_CQE_SIZE));
 		cqc->w8 = cpu_to_le16(QM_Q_DEPTH - 1);
 	} else {
-		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(4));
+		cqc->dw3 = cpu_to_le32(QM_MK_CQC_DW3_V2(QM_QC_CQE_SIZE));
 		cqc->w8 = 0;
 	}
 	cqc->dw6 = cpu_to_le32(1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT);
@@ -2011,7 +2015,8 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
 
 	writel(0x1, qm->io_base + QM_CACHE_WB_START);
 	if (readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
-					    val, val & BIT(0), 10, 1000))
+				       val, val & BIT(0), POLL_PERIOD,
+				       POLL_TIMEOUT))
 		dev_err(&qm->pdev->dev, "QM writeback sqc cache fail!\n");
 }
 
-- 
2.8.1

