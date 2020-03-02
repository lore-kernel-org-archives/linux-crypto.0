Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19DBC3F2D1
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8162B24697
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgCBGTA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 01:19:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbgCBGTA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 01:19:00 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 60F6B93CB52BECD51BF3;
        Mon,  2 Mar 2020 14:18:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 2 Mar 2020 14:18:51 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <yekai13@huawei.com>, <liulongfang@huawei.com>,
        <qianweili@huawei.com>, <zhangwei375@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH v2 2/5] crypto: hisilicon/sec2 - Add workqueue for SEC driver.
Date:   Mon, 2 Mar 2020 14:15:13 +0800
Message-ID: <1583129716-28382-3-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
References: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: yekai13 <yekai13@huawei.com>

Allocate one workqueue for each QM instead of one for all QMs,
we found the throughput of SEC engine can be increased to
the hardware limit throughput during testing sec2 performance.
so we added this scheme.

Signed-off-by: yekai13 <yekai13@huawei.com>
Signed-off-by: liulongfang <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 3767fdb..ebafc1c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -774,12 +774,24 @@ static void sec_qm_uninit(struct hisi_qm *qm)
 
 static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
 {
+	int ret;
+
+	qm->wq = alloc_workqueue("%s", WQ_HIGHPRI | WQ_CPU_INTENSIVE |
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
@@ -792,18 +804,26 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
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

