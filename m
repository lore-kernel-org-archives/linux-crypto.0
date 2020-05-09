Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113E6C47254
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF010214D8
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 09:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgEIJpW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 05:45:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57992 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728179AbgEIJpV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 05:45:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3C6BC78D33E0BF35A3CA;
        Sat,  9 May 2020 17:45:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:45:10 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 03/12] crypto: hisilicon/zip - modify the ZIP probe process
Date:   Sat, 9 May 2020 17:43:56 +0800
Message-ID: <1589017445-15514-4-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
References: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

Misc fixes on coding style:
1.Merge QM initialization code into a function
2.Merge QM's PF and VF initialization into a function

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 60 +++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 37db11f..4672eaa 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -701,23 +701,14 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	return 0;
 }
 
-static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
-	struct hisi_zip *hisi_zip;
 	enum qm_hw_ver rev_id;
-	struct hisi_qm *qm;
-	int ret;
 
 	rev_id = hisi_qm_get_hw_version(pdev);
 	if (rev_id == QM_HW_UNKNOWN)
 		return -EINVAL;
 
-	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
-	if (!hisi_zip)
-		return -ENOMEM;
-	pci_set_drvdata(pdev, hisi_zip);
-
-	qm = &hisi_zip->qm;
 	qm->use_dma_api = true;
 	qm->pdev = pdev;
 	qm->ver = rev_id;
@@ -725,13 +716,16 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	qm->algs = "zlib\ngzip";
 	qm->sqe_size = HZIP_SQE_SIZE;
 	qm->dev_name = hisi_zip_name;
-	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
-								QM_HW_VF;
-	ret = hisi_qm_init(qm);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to init qm!\n");
-		return ret;
-	}
+	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
+			QM_HW_PF : QM_HW_VF;
+
+	return hisi_qm_init(qm);
+}
+
+static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
+{
+	struct hisi_qm *qm = &hisi_zip->qm;
+	int ret;
 
 	if (qm->fun_type == QM_HW_PF) {
 		ret = hisi_zip_pf_probe_init(hisi_zip);
@@ -754,7 +748,36 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
 		} else if (qm->ver == QM_HW_V2)
 			/* v2 starts to support get vft by mailbox */
-			hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+			return hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+	}
+
+	return 0;
+}
+
+static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct hisi_zip *hisi_zip;
+	struct hisi_qm *qm;
+	int ret;
+
+	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
+	if (!hisi_zip)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, hisi_zip);
+
+	qm = &hisi_zip->qm;
+
+	ret = hisi_zip_qm_init(qm, pdev);
+	if (ret) {
+		pci_err(pdev, "Failed to init ZIP QM (%d)!\n", ret);
+		return ret;
+	}
+
+	ret = hisi_zip_probe_init(hisi_zip);
+	if (ret) {
+		pci_err(pdev, "Failed to probe (%d)!\n", ret);
+		goto err_qm_uninit;
 	}
 
 	ret = hisi_qm_start(qm);
@@ -787,6 +810,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hisi_qm_stop(qm);
 err_qm_uninit:
 	hisi_qm_uninit(qm);
+
 	return ret;
 }
 
-- 
2.7.4

