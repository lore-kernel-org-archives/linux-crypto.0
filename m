Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56280CA9EB5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306352089C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfJUHk3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 03:40:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57378 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727110AbfJUHk2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 03:40:28 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CEBF4521A6A4A6144FD;
        Mon, 21 Oct 2019 15:40:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 21 Oct 2019 15:40:18 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon - tiny fix about QM/ZIP error callback print
Date:   Mon, 21 Oct 2019 15:41:00 +0800
Message-ID: <1571643663-29593-2-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
References: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

Tiny fix to make QM/ZIP error callback print clear and right. If one version
hardware does not support error handling, we directly print this.

And QM is embedded in ZIP, we can use ZIP print only, so remove unnecessary
QM print.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c           | 9 ++-------
 drivers/crypto/hisilicon/zip/zip_main.c | 3 +--
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a8ed6990..2c17bf3 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -987,9 +987,6 @@ static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
 static void qm_hw_error_init_v1(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 				u32 msi)
 {
-	dev_info(&qm->pdev->dev,
-		 "QM v%d does not support hw error handle\n", qm->ver);
-
 	writel(QM_ABNORMAL_INT_MASK_VALUE, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
@@ -1868,8 +1865,7 @@ void hisi_qm_hw_error_init(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe,
 			   u32 msi)
 {
 	if (!qm->ops->hw_error_init) {
-		dev_err(&qm->pdev->dev, "QM version %d doesn't support hw error handling!\n",
-			qm->ver);
+		dev_err(&qm->pdev->dev, "QM doesn't support hw error handling!\n");
 		return;
 	}
 
@@ -1886,8 +1882,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_hw_error_init);
 int hisi_qm_hw_error_handle(struct hisi_qm *qm)
 {
 	if (!qm->ops->hw_error_handle) {
-		dev_err(&qm->pdev->dev, "QM version %d doesn't support hw error report!\n",
-			qm->ver);
+		dev_err(&qm->pdev->dev, "QM doesn't support hw error report!\n");
 		return PCI_ERS_RESULT_NONE;
 	}
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 1b2ee96..5546edc 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -335,8 +335,7 @@ static void hisi_zip_hw_error_set_state(struct hisi_zip *hisi_zip, bool state)
 
 	if (qm->ver == QM_HW_V1) {
 		writel(HZIP_CORE_INT_DISABLE, qm->io_base + HZIP_CORE_INT_MASK);
-		dev_info(&qm->pdev->dev, "ZIP v%d does not support hw error handle\n",
-			 qm->ver);
+		dev_info(&qm->pdev->dev, "Does not support hw error handle\n");
 		return;
 	}
 
-- 
2.7.4

