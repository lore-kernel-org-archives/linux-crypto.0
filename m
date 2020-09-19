Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BEAC43464
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 11:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A68208C3
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 11:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgISLC4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Sep 2020 07:02:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13773 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISLC4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Sep 2020 07:02:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 84D0F58C6467D70AF53F;
        Sat, 19 Sep 2020 19:02:54 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 19:02:47 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/2] crypto: hisilicon/qm - fix wrong return type of 'pci_get_drvdata'
Date:   Sat, 19 Sep 2020 19:01:35 +0800
Message-ID: <1600513296-29287-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
References: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yang Shen <shenyang39@huawei.com>

The parameter type of 'pci_set_drvdata' is 'struct hisi_qm',
so here the return type of 'pci_get_drvdata' should be 'struct hisi_qm'
too.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 3 +--
 drivers/crypto/hisilicon/sec2/sec_main.c  | 3 +--
 drivers/crypto/hisilicon/zip/zip_main.c   | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index cf9169d..a33394d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -900,8 +900,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void hpre_remove(struct pci_dev *pdev)
 {
-	struct hpre *hpre = pci_get_drvdata(pdev);
-	struct hisi_qm *qm = &hpre->qm;
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
 	int ret;
 
 	hisi_qm_wait_task_finish(qm, &hpre_devices);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index de42264..5488963 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -915,8 +915,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void sec_remove(struct pci_dev *pdev)
 {
-	struct sec_dev *sec = pci_get_drvdata(pdev);
-	struct hisi_qm *qm = &sec->qm;
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
 
 	hisi_qm_wait_task_finish(qm, &sec_devices);
 	hisi_qm_alg_unregister(qm, &sec_devices);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index ee5f3d9..bd53ee7 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -844,8 +844,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void hisi_zip_remove(struct pci_dev *pdev)
 {
-	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
-	struct hisi_qm *qm = &hisi_zip->qm;
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
 
 	hisi_qm_wait_task_finish(qm, &zip_devices);
 	hisi_qm_alg_unregister(qm, &zip_devices);
-- 
2.8.1

