Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D99C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 08:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D40E60F70
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 08:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhI0IUI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 04:20:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:25922 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhI0IUH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 04:20:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHwQY29r7zbmqQ;
        Mon, 27 Sep 2021 16:14:13 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 16:18:28 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 27 Sep
 2021 16:18:28 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - modify the uacce mode check
Date:   Mon, 27 Sep 2021 16:16:55 +0800
Message-ID: <20210927081655.14242-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As qm should register to uacce in UACCE_DEV_SVA mode,
this patch modifies to checks uacce mode before doing uacce
registration.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9f97042efefc..b288c0b57615 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3045,7 +3045,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	if (IS_ERR(uacce))
 		return PTR_ERR(uacce);
 
-	if (uacce->flags & UACCE_DEV_SVA && qm->mode == UACCE_MODE_SVA) {
+	if (uacce->flags & UACCE_DEV_SVA) {
 		qm->use_sva = true;
 	} else {
 		/* only consider sva case */
@@ -3316,8 +3316,10 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 
 	qm_irq_unregister(qm);
 	hisi_qm_pci_uninit(qm);
-	uacce_remove(qm->uacce);
-	qm->uacce = NULL;
+	if (qm->use_sva) {
+		uacce_remove(qm->uacce);
+		qm->uacce = NULL;
+	}
 
 	up_write(&qm->qps_lock);
 }
@@ -5701,9 +5703,11 @@ int hisi_qm_init(struct hisi_qm *qm)
 			goto err_irq_register;
 	}
 
-	ret = qm_alloc_uacce(qm);
-	if (ret < 0)
-		dev_warn(dev, "fail to alloc uacce (%d)\n", ret);
+	if (qm->mode == UACCE_MODE_SVA) {
+		ret = qm_alloc_uacce(qm);
+		if (ret < 0)
+			dev_warn(dev, "fail to alloc uacce (%d)\n", ret);
+	}
 
 	ret = hisi_qm_memory_init(qm);
 	if (ret)
@@ -5716,8 +5720,10 @@ int hisi_qm_init(struct hisi_qm *qm)
 	return 0;
 
 err_alloc_uacce:
-	uacce_remove(qm->uacce);
-	qm->uacce = NULL;
+	if (qm->use_sva) {
+		uacce_remove(qm->uacce);
+		qm->uacce = NULL;
+	}
 err_irq_register:
 	qm_irq_unregister(qm);
 err_pci_init:
-- 
2.33.0

