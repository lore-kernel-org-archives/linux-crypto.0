Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735A6C388F7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 09:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1062145D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 09:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKMJcY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 04:32:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7189 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMJcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 04:32:23 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CXYCC4NGlz15L0Y;
        Fri, 13 Nov 2020 17:32:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Nov 2020 17:32:09 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/zip - add a work_queue for zip irq
Date:   Fri, 13 Nov 2020 17:32:35 +0800
Message-ID: <1605259955-17796-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The patch 'irqchip/gic-v3-its: Balance initial LPI affinity across CPUs'
set the IRQ to an uncentain CPU. If an IRQ is bound to the CPU used by the
thread which is sending request, the throughput will be just half.

So allocate a 'work_queue' and set as 'WQ_UNBOUND' to do the back half work
on some different CPUS.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 3d1524b..4fb5a32b 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -747,6 +747,8 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)

 static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
+	int ret;
+
 	qm->pdev = pdev;
 	qm->ver = pdev->revision;
 	qm->algs = "zlib\ngzip";
@@ -772,7 +774,25 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
 	}

-	return hisi_qm_init(qm);
+	qm->wq = alloc_workqueue("%s", WQ_HIGHPRI | WQ_MEM_RECLAIM |
+				 WQ_UNBOUND, num_online_cpus(),
+				 pci_name(qm->pdev));
+	if (!qm->wq) {
+		pci_err(qm->pdev, "fail to alloc workqueue\n");
+		return -ENOMEM;
+	}
+
+	ret = hisi_qm_init(qm);
+	if (ret)
+		destroy_workqueue(qm->wq);
+
+	return ret;
+}
+
+static void hisi_zip_qm_uninit(struct hisi_qm *qm)
+{
+	hisi_qm_uninit(qm);
+	destroy_workqueue(qm->wq);
 }

 static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
@@ -854,7 +874,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hisi_qm_dev_err_uninit(qm);

 err_qm_uninit:
-	hisi_qm_uninit(qm);
+	hisi_zip_qm_uninit(qm);

 	return ret;
 }
@@ -872,7 +892,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 	hisi_zip_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 	hisi_qm_dev_err_uninit(qm);
-	hisi_qm_uninit(qm);
+	hisi_zip_qm_uninit(qm);
 }

 static const struct pci_error_handlers hisi_zip_err_handler = {
--
2.7.4

