Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFCDC433C1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF38E619F9
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhC0IgF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 04:36:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15072 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhC0Ifj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 04:35:39 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6sYr0TwSz1BHyb;
        Sat, 27 Mar 2021 16:33:36 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:35:30 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon - check if debugfs opened
Date:   Sat, 27 Mar 2021 16:33:00 +0800
Message-ID: <1616833980-11006-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'xx_debugfs_init' check if debugfs opened.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 5 ++++-
 drivers/crypto/hisilicon/qm.c             | 3 +++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 5 ++++-
 drivers/crypto/hisilicon/zip/zip_main.c   | 3 +++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index c7ab06d..f2605c4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -779,6 +779,9 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
+	if (!debugfs_initialized())
+		return -ENOENT;
+
 	qm->debug.debug_root = debugfs_create_dir(dev_name(dev),
 						  hpre_debugfs_root);
 
@@ -949,7 +952,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = hpre_debugfs_init(qm);
 	if (ret)
-		dev_warn(&pdev->dev, "init debugfs fail!\n");
+		dev_warn(&pdev->dev, "init debugfs fail (%d)!\n", ret);
 
 	ret = hisi_qm_alg_register(qm, &hpre_devices);
 	if (ret < 0) {
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bc23174..14f2656 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2926,6 +2926,9 @@ void hisi_qm_debug_init(struct hisi_qm *qm)
 	void *data;
 	int i;
 
+	if (!debugfs_initialized())
+		return;
+
 	qm_d = debugfs_create_dir("qm", qm->debug.debug_root);
 	qm->debug.qm_d = qm_d;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 78a6043..226475d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -695,6 +695,9 @@ static int sec_debugfs_init(struct hisi_qm *qm)
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
+	if (!debugfs_initialized())
+		return -ENOENT;
+
 	qm->debug.debug_root = debugfs_create_dir(dev_name(dev),
 						  sec_debugfs_root);
 	qm->debug.sqe_mask_offset = SEC_SQE_MASK_OFFSET;
@@ -928,7 +931,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = sec_debugfs_init(qm);
 	if (ret)
-		pci_warn(pdev, "Failed to init debugfs!\n");
+		pci_warn(pdev, "Failed to init debugfs (%d)!\n", ret);
 
 	ret = hisi_qm_alg_register(qm, &sec_devices);
 	if (ret < 0) {
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 02c44572..4b111c0 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -600,6 +600,9 @@ static int hisi_zip_debugfs_init(struct hisi_qm *qm)
 	struct dentry *dev_d;
 	int ret;
 
+	if (!debugfs_initialized())
+		return -ENOENT;
+
 	dev_d = debugfs_create_dir(dev_name(dev), hzip_debugfs_root);
 
 	qm->debug.sqe_mask_offset = HZIP_SQE_MASK_OFFSET;
-- 
2.8.1

