Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC5FECAAD5
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 10:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiH0K3e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 06:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiH0K3d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 06:29:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6956A5B797;
        Sat, 27 Aug 2022 03:29:32 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MFCXN5RZJz1N7Z8;
        Sat, 27 Aug 2022 18:25:56 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 18:29:30 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 18:29:29 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - check mailbox operation result
Date:   Sat, 27 Aug 2022 18:26:57 +0800
Message-ID: <20220827102657.8478-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After the mailbox operation is complete, the result may be unsuccessful.
It needs to check the status bits of the mailbox register,
if it fails, -EIO is returned.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index cf67fbd4181d..fd9fb159048f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -36,6 +36,7 @@
 #define QM_MB_PING_ALL_VFS		0xffff
 #define QM_MB_CMD_DATA_SHIFT		32
 #define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
+#define QM_MB_STATUS_MASK		GENMASK(12, 9)
 
 /* sqc shift */
 #define QM_SQ_HOP_NUM_SHIFT		0
@@ -728,8 +729,12 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 
 static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 {
+	int ret;
+	u32 val;
+
 	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
 		dev_err(&qm->pdev->dev, "QM mailbox is busy to start!\n");
+		ret = -EBUSY;
 		goto mb_busy;
 	}
 
@@ -737,6 +742,14 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 
 	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
 		dev_err(&qm->pdev->dev, "QM mailbox operation timeout!\n");
+		ret = -ETIMEDOUT;
+		goto mb_busy;
+	}
+
+	val = readl(qm->io_base + QM_MB_CMD_SEND_BASE);
+	if (val & QM_MB_STATUS_MASK) {
+		dev_err(&qm->pdev->dev, "QM mailbox operation failed!\n");
+		ret = -EIO;
 		goto mb_busy;
 	}
 
@@ -744,7 +757,7 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 
 mb_busy:
 	atomic64_inc(&qm->debug.dfx.mb_err_cnt);
-	return -EBUSY;
+	return ret;
 }
 
 int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
-- 
2.33.0

