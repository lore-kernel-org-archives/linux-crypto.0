Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C014C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33A9220735
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHG7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42636 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgEHG7D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:59:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 02C17736B0BC3AAF5AC0;
        Fri,  8 May 2020 14:59:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 14:58:51 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 01/13] crypto: hisilicon/sec2 - modify the SEC probe process
Date:   Fri, 8 May 2020 14:57:36 +0800
Message-ID: <1588921068-20739-2-git-send-email-tanshukun1@huawei.com>
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

Adjust the position of SMMU status check and
SEC queue initialization in SEC probe

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 67 ++++++++++++++------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 07a5f4e..ea029e3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -765,6 +765,21 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	qm->dev_name = sec_name;
 	qm->fun_type = (pdev->device == SEC_PF_PCI_DEVICE_ID) ?
 			QM_HW_PF : QM_HW_VF;
+	if (qm->fun_type == QM_HW_PF) {
+		qm->qp_base = SEC_PF_DEF_Q_BASE;
+		qm->qp_num = pf_q_num;
+		qm->debug.curr_qm_qp_num = pf_q_num;
+		qm->qm_list = &sec_devices;
+	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V1) {
+		/*
+		 * have no way to get qm configure in VM in v1 hardware,
+		 * so currently force PF to uses SEC_PF_DEF_Q_NUM, and force
+		 * to trigger only one VF in v1 hardware.
+		 * v2 hardware has no such problem.
+		 */
+		qm->qp_base = SEC_PF_DEF_Q_NUM;
+		qm->qp_num = SEC_QUEUE_NUM_V1 - SEC_PF_DEF_Q_NUM;
+	}
 	qm->use_dma_api = true;
 
 	return hisi_qm_init(qm);
@@ -775,8 +790,9 @@ static void sec_qm_uninit(struct hisi_qm *qm)
 	hisi_qm_uninit(qm);
 }
 
-static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
+static int sec_probe_init(struct sec_dev *sec)
 {
+	struct hisi_qm *qm = &sec->qm;
 	int ret;
 
 	/*
@@ -793,40 +809,18 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 		return -ENOMEM;
 	}
 
-	if (qm->fun_type == QM_HW_PF) {
-		qm->qp_base = SEC_PF_DEF_Q_BASE;
-		qm->qp_num = pf_q_num;
-		qm->debug.curr_qm_qp_num = pf_q_num;
-		qm->qm_list = &sec_devices;
-
+	if (qm->fun_type == QM_HW_PF)
 		ret = sec_pf_probe_init(sec);
-		if (ret)
-			goto err_probe_uninit;
-	} else if (qm->fun_type == QM_HW_VF) {
-		/*
-		 * have no way to get qm configure in VM in v1 hardware,
-		 * so currently force PF to uses SEC_PF_DEF_Q_NUM, and force
-		 * to trigger only one VF in v1 hardware.
-		 * v2 hardware has no such problem.
-		 */
-		if (qm->ver == QM_HW_V1) {
-			qm->qp_base = SEC_PF_DEF_Q_NUM;
-			qm->qp_num = SEC_QUEUE_NUM_V1 - SEC_PF_DEF_Q_NUM;
-		} else if (qm->ver == QM_HW_V2) {
-			/* v2 starts to support get vft by mailbox */
-			ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
-			if (ret)
-				goto err_probe_uninit;
-		}
-	} else {
-		ret = -ENODEV;
-		goto err_probe_uninit;
+	else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V2)
+		/* v2 starts to support get vft by mailbox */
+		ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+
+	if (ret) {
+		destroy_workqueue(qm->wq);
+		return ret;
 	}
 
 	return 0;
-err_probe_uninit:
-	destroy_workqueue(qm->wq);
-	return ret;
 }
 
 static void sec_probe_uninit(struct hisi_qm *qm)
@@ -865,18 +859,17 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, sec);
 
-	sec->ctx_q_num = ctx_q_num;
-	sec_iommu_used_check(sec);
-
 	qm = &sec->qm;
-
 	ret = sec_qm_init(qm, pdev);
 	if (ret) {
-		pci_err(pdev, "Failed to pre init qm!\n");
+		pci_err(pdev, "Failed to init SEC QM (%d)!\n", ret);
 		return ret;
 	}
 
-	ret = sec_probe_init(qm, sec);
+	sec->ctx_q_num = ctx_q_num;
+	sec_iommu_used_check(sec);
+
+	ret = sec_probe_init(sec);
 	if (ret) {
 		pci_err(pdev, "Failed to probe!\n");
 		goto err_qm_uninit;
-- 
2.7.4

