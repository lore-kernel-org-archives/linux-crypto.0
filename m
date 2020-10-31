Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1FAC4742C
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7962076D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgJaJIy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:08:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:7388 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgJaJIw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:52 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CNYJH0P8Dz70tb;
        Sat, 31 Oct 2020 17:08:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:36 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 8/8] crypto: hisilicon/qm - split 'hisi_qm_init' into smaller pieces
Date:   Sat, 31 Oct 2020 17:07:08 +0800
Message-ID: <1604135228-18410-9-git-send-email-qianweili@huawei.com>
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

'hisi_qm_init' initializes configuration of QM.
To improve code readability, split it into two pieces.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 86 ++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6e8d20d..f21ccae 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2442,6 +2442,16 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	qm->is_frozen = false;
 }
 
+static void hisi_qm_pci_uninit(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+
+	pci_free_irq_vectors(pdev);
+	iounmap(qm->io_base);
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+
 /**
  * hisi_qm_uninit() - Uninitialize qm.
  * @qm: The qm needed uninit.
@@ -2460,9 +2470,6 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 		return;
 	}
 
-	uacce_remove(qm->uacce);
-	qm->uacce = NULL;
-
 	hisi_qp_memory_uninit(qm, qm->qp_num);
 	idr_destroy(&qm->qp_idr);
 
@@ -2474,10 +2481,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	}
 
 	qm_irq_unregister(qm);
-	pci_free_irq_vectors(pdev);
-	iounmap(qm->io_base);
-	pci_release_mem_regions(pdev);
-	pci_disable_device(pdev);
+	hisi_qm_pci_uninit(qm);
+	uacce_remove(qm->uacce);
+	qm->uacce = NULL;
 
 	up_write(&qm->qps_lock);
 }
@@ -4038,34 +4044,22 @@ void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_alg_unregister);
 
-/**
- * hisi_qm_init() - Initialize configures about qm.
- * @qm: The qm needing init.
- *
- * This function init qm, then we can call hisi_qm_start to put qm into work.
- */
-int hisi_qm_init(struct hisi_qm *qm)
+static int hisi_qm_pci_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 	struct device *dev = &pdev->dev;
 	unsigned int num_vec;
 	int ret;
 
-	hisi_qm_pre_init(qm);
-
-	ret = qm_alloc_uacce(qm);
-	if (ret < 0)
-		dev_warn(&pdev->dev, "fail to alloc uacce (%d)\n", ret);
-
 	ret = pci_enable_device_mem(pdev);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to enable device mem!\n");
-		goto err_remove_uacce;
+		dev_err(dev, "Failed to enable device mem!\n");
+		return ret;
 	}
 
 	ret = pci_request_mem_regions(pdev, qm->dev_name);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to request mem regions!\n");
+		dev_err(dev, "Failed to request mem regions!\n");
 		goto err_disable_pcidev;
 	}
 
@@ -4093,9 +4087,42 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_iounmap;
 	}
 
+	return 0;
+
+err_iounmap:
+	iounmap(qm->io_base);
+err_release_mem_regions:
+	pci_release_mem_regions(pdev);
+err_disable_pcidev:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+/**
+ * hisi_qm_init() - Initialize configures about qm.
+ * @qm: The qm needing init.
+ *
+ * This function init qm, then we can call hisi_qm_start to put qm into work.
+ */
+int hisi_qm_init(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	hisi_qm_pre_init(qm);
+
+	ret = qm_alloc_uacce(qm);
+	if (ret < 0)
+		dev_warn(dev, "fail to alloc uacce (%d)\n", ret);
+
+	ret = hisi_qm_pci_init(qm);
+	if (ret)
+		goto err_remove_uacce;
+
 	ret = qm_irq_register(qm);
 	if (ret)
-		goto err_free_irq_vectors;
+		goto err_pci_uninit;
 
 	if (qm->fun_type == QM_HW_VF && qm->ver != QM_HW_V1) {
 		/* v2 starts to support get vft by mailbox */
@@ -4118,14 +4145,8 @@ int hisi_qm_init(struct hisi_qm *qm)
 
 err_irq_unregister:
 	qm_irq_unregister(qm);
-err_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
-err_iounmap:
-	iounmap(qm->io_base);
-err_release_mem_regions:
-	pci_release_mem_regions(pdev);
-err_disable_pcidev:
-	pci_disable_device(pdev);
+err_pci_uninit:
+	hisi_qm_pci_uninit(qm);
 err_remove_uacce:
 	uacce_remove(qm->uacce);
 	qm->uacce = NULL;
@@ -4133,7 +4154,6 @@ int hisi_qm_init(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_init);
 
-
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zhou Wang <wangzhou1@hisilicon.com>");
 MODULE_DESCRIPTION("HiSilicon Accelerator queue manager driver");
-- 
2.8.1

