Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B960C433C1
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 11:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D558961972
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 11:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCTLax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Mar 2021 07:30:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14111 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCTLaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Mar 2021 07:30:22 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F2dmm3YX1z17NPy;
        Sat, 20 Mar 2021 19:28:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sat, 20 Mar 2021 19:30:11 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - set the total number of queues
Date:   Sat, 20 Mar 2021 19:27:43 +0800
Message-ID: <1616239666-43572-2-git-send-email-qianweili@huawei.com>
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

Move the configuration of the total number of queues 'ctrl_qp_num'
from sec2/hpre/zip to qm.c. And get the total number of queues
from the hardware register for Kunpeng930.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  3 ---
 drivers/crypto/hisilicon/qm.c             | 16 ++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  |  6 ------
 drivers/crypto/hisilicon/zip/zip_main.c   |  7 -------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 87e8f4d..818e7f3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -13,7 +13,6 @@
 #include <linux/uacce.h>
 #include "hpre.h"
 
-#define HPRE_QUEUE_NUM_V2		1024
 #define HPRE_QM_ABNML_INT_MASK		0x100004
 #define HPRE_CTRL_CNT_CLR_CE_BIT	BIT(0)
 #define HPRE_COMM_CNT_CLR_CE		0x0
@@ -899,8 +898,6 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 	struct hisi_qm *qm = &hpre->qm;
 	int ret;
 
-	qm->ctrl_qp_num = HPRE_QUEUE_NUM_V2;
-
 	ret = hpre_set_user_domain_and_cache(qm);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bc23174..3c215ba 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -93,6 +93,8 @@
 #define QM_DB_PRIORITY_SHIFT_V1		48
 #define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
 #define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
+#define QM_CAPBILITY			0x100158
+#define QM_QP_NUN_MASK			GENMASK(10, 0)
 #define QM_DB_CMD_SHIFT_V2		12
 #define QM_DB_RAND_SHIFT_V2		16
 #define QM_DB_INDEX_SHIFT_V2		32
@@ -4119,6 +4121,17 @@ void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_alg_unregister);
 
+static void qm_get_qp_num(struct hisi_qm *qm)
+{
+	if (qm->ver == QM_HW_V1)
+		qm->ctrl_qp_num = QM_QNUM_V1;
+	else if (qm->ver == QM_HW_V2)
+		qm->ctrl_qp_num = QM_QNUM_V2;
+	else
+		qm->ctrl_qp_num = readl(qm->io_base + QM_CAPBILITY) &
+					QM_QP_NUN_MASK;
+}
+
 static int hisi_qm_pci_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -4146,6 +4159,9 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 		goto err_release_mem_regions;
 	}
 
+	if (qm->fun_type == QM_HW_PF)
+		qm_get_qp_num(qm);
+
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret < 0)
 		goto err_iounmap;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 78a6043..2360d31 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -19,7 +19,6 @@
 
 #define SEC_VF_NUM			63
 #define SEC_QUEUE_NUM_V1		4096
-#define SEC_QUEUE_NUM_V2		1024
 #define SEC_PF_PCI_DEVICE_ID		0xa255
 #define SEC_VF_PCI_DEVICE_ID		0xa256
 
@@ -784,11 +783,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	struct hisi_qm *qm = &sec->qm;
 	int ret;
 
-	if (qm->ver == QM_HW_V1)
-		qm->ctrl_qp_num = SEC_QUEUE_NUM_V1;
-	else
-		qm->ctrl_qp_num = SEC_QUEUE_NUM_V2;
-
 	qm->err_ini = &sec_err_ini;
 
 	ret = sec_set_user_domain_and_cache(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 02c44572..8f67d70 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -18,7 +18,6 @@
 #define PCI_DEVICE_ID_ZIP_VF		0xa251
 
 #define HZIP_QUEUE_NUM_V1		4096
-#define HZIP_QUEUE_NUM_V2		1024
 
 #define HZIP_CLOCK_GATE_CTRL		0x301004
 #define COMP0_ENABLE			BIT(0)
@@ -746,12 +745,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 
 	hisi_zip->ctrl = ctrl;
 	ctrl->hisi_zip = hisi_zip;
-
-	if (qm->ver == QM_HW_V1)
-		qm->ctrl_qp_num = HZIP_QUEUE_NUM_V1;
-	else
-		qm->ctrl_qp_num = HZIP_QUEUE_NUM_V2;
-
 	qm->err_ini = &hisi_zip_err_ini;
 
 	hisi_zip_set_user_domain_and_cache(qm);
-- 
2.8.1

