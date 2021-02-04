Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29301C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57D464F51
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhBDJDW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:03:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12027 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhBDJCq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 04:02:46 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DWXZc3680zjJn8;
        Thu,  4 Feb 2021 17:00:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 17:01:50 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] crypto: hisilicon - PASID fixed on Kunpeng 930
Date:   Thu, 4 Feb 2021 16:59:36 +0800
Message-ID: <1612429176-28084-5-git-send-email-tanghui20@huawei.com>
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

Enable PASID by setting 'sqc' and 'cqc' pasid bits
per queue in Kunpeng 930.

For Kunpeng 920, PASID is effective for all queues once set
in SVA scenarios.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 18 ++++++++++--------
 drivers/crypto/hisilicon/qm.c             | 11 +++++++++++
 drivers/crypto/hisilicon/qm.h             |  1 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  2 +-
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 06448b8..67f1fca 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -356,10 +356,6 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(0x0, HPRE_ADDR(qm, HPRE_COMM_CNT_CLR_CE));
 	writel(0x0, HPRE_ADDR(qm, HPRE_ECC_BYPASS));

-	/* Enable data buffer pasid */
-	if (qm->use_sva)
-		hpre_pasid_enable(qm);
-
 	writel(HPRE_BD_USR_MASK, HPRE_ADDR(qm, HPRE_BD_ARUSR_CFG));
 	writel(HPRE_BD_USR_MASK, HPRE_ADDR(qm, HPRE_BD_AWUSR_CFG));
 	writel(0x1, HPRE_ADDR(qm, HPRE_RDCHN_INI_CFG));
@@ -383,6 +379,10 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 			dev_err(dev, "acpi_evaluate_dsm err.\n");

 		disable_flr_of_bme(qm);
+
+		/* Enable data buffer pasid */
+		if (qm->use_sva)
+			hpre_pasid_enable(qm);
 	}

 	return ret;
@@ -993,16 +993,18 @@ static void hpre_remove(struct pci_dev *pdev)
 			return;
 		}
 	}
+
+	hpre_debugfs_exit(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
+
 	if (qm->fun_type == QM_HW_PF) {
-		if (qm->use_sva)
+		if (qm->use_sva && qm->ver == QM_HW_V2)
 			hpre_pasid_disable(qm);
 		hpre_cnt_regs_clear(qm);
 		qm->debug.curr_qm_qp_num = 0;
+		hisi_qm_dev_err_uninit(qm);
 	}

-	hpre_debugfs_exit(qm);
-	hisi_qm_stop(qm, QM_NORMAL);
-	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
 }

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 93d4a21..c36c4a5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -54,6 +54,8 @@
 #define QM_SQ_PRIORITY_SHIFT		0
 #define QM_SQ_ORDERS_SHIFT		4
 #define QM_SQ_TYPE_SHIFT		8
+#define QM_QC_PASID_ENABLE		0x1
+#define QM_QC_PASID_ENABLE_SHIFT	7

 #define QM_SQ_TYPE_MASK			GENMASK(3, 0)
 #define QM_SQ_TAIL_IDX(sqc)		((le16_to_cpu((sqc)->w11) >> 6) & 0x1)
@@ -1685,6 +1687,7 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 	qp->req_cb = NULL;
 	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
+	qp->is_in_kernel = true;
 	qm->qp_in_used++;
 	atomic_set(&qp->qp_status.flags, QP_INIT);

@@ -1759,6 +1762,10 @@ static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	sqc->cq_num = cpu_to_le16(qp_id);
 	sqc->w13 = cpu_to_le16(QM_MK_SQC_W13(0, 1, qp->alg_type));

+	if (ver >= QM_HW_V3 && qm->use_sva && !qp->is_in_kernel)
+		sqc->w11 = cpu_to_le16(QM_QC_PASID_ENABLE <<
+				       QM_QC_PASID_ENABLE_SHIFT);
+
 	sqc_dma = dma_map_single(dev, sqc, sizeof(struct qm_sqc),
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, sqc_dma)) {
@@ -1797,6 +1804,9 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
 	}
 	cqc->dw6 = cpu_to_le32(1 << QM_CQ_PHASE_SHIFT | 1 << QM_CQ_FLAG_SHIFT);

+	if (ver >= QM_HW_V3 && qm->use_sva && !qp->is_in_kernel)
+		cqc->w11 = cpu_to_le16(QM_QC_PASID_ENABLE);
+
 	cqc_dma = dma_map_single(dev, cqc, sizeof(struct qm_cqc),
 				 DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, cqc_dma)) {
@@ -2067,6 +2077,7 @@ static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
 	qp->uacce_q = q;
 	qp->event_cb = qm_qp_event_notifier;
 	qp->pasid = arg;
+	qp->is_in_kernel = false;

 	return 0;
 }
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index c1dd0fc..8f5a3b9 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -288,6 +288,7 @@ struct hisi_qp {

 	struct hisi_qm *qm;
 	bool is_resetting;
+	bool is_in_kernel;
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 };
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 4809c19..b5c2f7e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -323,7 +323,7 @@ static int sec_engine_init(struct hisi_qm *qm)

 	reg = readl_relaxed(SEC_ADDR(qm, SEC_INTERFACE_USER_CTRL1_REG));
 	reg &= SEC_USER1_SMMU_MASK;
-	if (qm->use_sva)
+	if (qm->use_sva && qm->ver == QM_HW_V2)
 		reg |= SEC_USER1_SMMU_SVA;
 	else
 		reg |= SEC_USER1_SMMU_NORMAL;
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 9cdecff..115560f 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -292,7 +292,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	writel(AXUSER_BASE, base + HZIP_BD_WUSER_32_63);

-	if (qm->use_sva) {
+	if (qm->use_sva && qm->ver == QM_HW_V2) {
 		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_RUSER_32_63);
 		writel(AXUSER_BASE | AXUSER_SSV, base + HZIP_DATA_WUSER_32_63);
 	} else {
--
2.8.1

