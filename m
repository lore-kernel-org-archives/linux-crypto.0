Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C51C47257
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D3C2192A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEHG7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42608 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgEHG7D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:59:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EE0E64678534578F6ED2;
        Fri,  8 May 2020 14:58:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 14:58:52 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 02/13] crypto: hisilicon/hpre - modify the HPRE probe process
Date:   Fri, 8 May 2020 14:57:37 +0800
Message-ID: <1588921068-20739-3-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
References: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
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
1.Merge pre-initialization and initialization of QM
2.Package the initialization of QM's PF and VF into a function

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 42 ++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 0d63666..f3859de 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -666,7 +666,7 @@ static void hpre_debugfs_exit(struct hpre *hpre)
 	debugfs_remove_recursive(qm->debug.debug_root);
 }
 
-static int hpre_qm_pre_init(struct hisi_qm *qm, struct pci_dev *pdev)
+static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	enum qm_hw_ver rev_id;
 
@@ -685,13 +685,14 @@ static int hpre_qm_pre_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	qm->dev_name = hpre_name;
 	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
 		       QM_HW_PF : QM_HW_VF;
+
 	if (pdev->is_physfn) {
 		qm->qp_base = HPRE_PF_DEF_Q_BASE;
 		qm->qp_num = hpre_pf_q_num;
 	}
 	qm->use_dma_api = true;
 
-	return 0;
+	return hisi_qm_init(qm);
 }
 
 static void hpre_log_hw_error(struct hisi_qm *qm, u32 err_sts)
@@ -766,6 +767,20 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 	return 0;
 }
 
+static int hpre_probe_init(struct hpre *hpre)
+{
+	struct hisi_qm *qm = &hpre->qm;
+	int ret = -ENODEV;
+
+	if (qm->fun_type == QM_HW_PF)
+		ret = hpre_pf_probe_init(hpre);
+	else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2)
+		/* v2 starts to support get vft by mailbox */
+		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+
+	return ret;
+}
+
 static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_qm *qm;
@@ -779,23 +794,16 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, hpre);
 
 	qm = &hpre->qm;
-	ret = hpre_qm_pre_init(qm, pdev);
-	if (ret)
-		return ret;
-
-	ret = hisi_qm_init(qm);
-	if (ret)
+	ret = hpre_qm_init(qm, pdev);
+	if (ret) {
+		pci_err(pdev, "Failed to init HPRE QM (%d)!\n", ret);
 		return ret;
+	}
 
-	if (pdev->is_physfn) {
-		ret = hpre_pf_probe_init(hpre);
-		if (ret)
-			goto err_with_qm_init;
-	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2) {
-		/* v2 starts to support get vft by mailbox */
-		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
-		if (ret)
-			goto err_with_qm_init;
+	ret = hpre_probe_init(hpre);
+	if (ret) {
+		pci_err(pdev, "Failed to probe (%d)!\n", ret);
+		goto err_with_qm_init;
 	}
 
 	ret = hisi_qm_start(qm);
-- 
2.7.4

