Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335B3C3F2D9
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1612120842
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCECKP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:10:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbgCECKN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 21:10:13 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1BB5237181449ABE785D;
        Thu,  5 Mar 2020 10:10:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 10:10:01 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v3 2/5] crypto: hisilicon/sec2 - Add workqueue for SEC driver.
Date:   Thu, 5 Mar 2020 10:06:22 +0800
Message-ID: <1583373985-718-3-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
References: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ye Kai <yekai13@huawei.com>

Allocate one workqueue for each QM instead of one for all QMs,
we found the throughput of SEC engine can be increased to
the hardware limit throughput during testing sec2 performance.
so we added this scheme.

Signed-off-by: Ye Kai <yekai13@huawei.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 3767fdb..1fe2558 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -774,12 +774,30 @@ static void sec_qm_uninit(struct hisi_qm *qm)
 
 static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 {
+	int ret;
+
+	/*
+	 * WQ_HIGHPRI: SEC request must be low delayed,
+	 * so need a high priority workqueue.
+	 * WQ_UNBOUND: SEC task is likely with long
+	 * running CPU intensive workloads.
+	 */
+	qm->wq = alloc_workqueue("%s", WQ_HIGHPRI |
+		WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus(),
+		pci_name(qm->pdev));
+	if (!qm->wq) {
+		pci_err(qm->pdev, "fail to alloc workqueue\n");
+		return -ENOMEM;
+	}
+
 	if (qm->fun_type == QM_HW_PF) {
 		qm->qp_base = SEC_PF_DEF_Q_BASE;
 		qm->qp_num = pf_q_num;
 		qm->debug.curr_qm_qp_num = pf_q_num;
 
-		return sec_pf_probe_init(sec);
+		ret = sec_pf_probe_init(sec);
+		if (ret)
+			goto err_probe_uninit;
 	} else if (qm->fun_type == QM_HW_VF) {
 		/*
 		 * have no way to get qm configure in VM in v1 hardware,
@@ -792,18 +810,26 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 			qm->qp_num = SEC_QUEUE_NUM_V1 - SEC_PF_DEF_Q_NUM;
 		} else if (qm->ver == QM_HW_V2) {
 			/* v2 starts to support get vft by mailbox */
-			return hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+			ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
+			if (ret)
+				goto err_probe_uninit;
 		}
 	} else {
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_probe_uninit;
 	}
 
 	return 0;
+err_probe_uninit:
+	destroy_workqueue(qm->wq);
+	return ret;
 }
 
 static void sec_probe_uninit(struct hisi_qm *qm)
 {
 	hisi_qm_dev_err_uninit(qm);
+
+	destroy_workqueue(qm->wq);
 }
 
 static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
2.8.1

