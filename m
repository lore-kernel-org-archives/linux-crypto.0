Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FD1C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhKTEwz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14963 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhKTEwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hx1Gz41BBzZd4C;
        Sat, 20 Nov 2021 12:47:23 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 12:49:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 12:49:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - modify the value of qos initialization
Date:   Sat, 20 Nov 2021 12:47:37 +0800
Message-ID: <20211120044739.5667-3-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211120044739.5667-1-yekai13@huawei.com>
References: <20211120044739.5667-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of qos should be reset after flr resetting or device
resetting. So set the max of qos value for every function. Then
update the value of qos when user writing the alg_qos.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index fed52ae516ba..b5837e8b2ab4 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1126,10 +1126,10 @@ static int qm_set_vft_common(struct hisi_qm *qm, enum vft_type type,
 
 static int qm_shaper_init_vft(struct hisi_qm *qm, u32 fun_num)
 {
+	u32 qos = qm->factor[fun_num].func_qos;
 	int ret, i;
 
-	qm->factor[fun_num].func_qos = QM_QOS_MAX_VAL;
-	ret = qm_get_shaper_para(QM_QOS_MAX_VAL * QM_QOS_RATE, &qm->factor[fun_num]);
+	ret = qm_get_shaper_para(qos * QM_QOS_RATE, &qm->factor[fun_num]);
 	if (ret) {
 		dev_err(&qm->pdev->dev, "failed to calculate shaper parameter!\n");
 		return ret;
@@ -5750,13 +5750,15 @@ static int hisi_qp_alloc_memory(struct hisi_qm *qm)
 static int hisi_qm_memory_init(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
-	int ret, total_vfs;
+	int ret, total_func, i;
 	size_t off = 0;
 
-	total_vfs = pci_sriov_get_totalvfs(qm->pdev);
-	qm->factor = kcalloc(total_vfs + 1, sizeof(struct qm_shaper_factor), GFP_KERNEL);
+	total_func = pci_sriov_get_totalvfs(qm->pdev) + 1;
+	qm->factor = kcalloc(total_func, sizeof(struct qm_shaper_factor), GFP_KERNEL);
 	if (!qm->factor)
 		return -ENOMEM;
+	for (i = 0; i < total_func; i++)
+		qm->factor[i].func_qos = QM_QOS_MAX_VAL;
 
 #define QM_INIT_BUF(qm, type, num) do { \
 	(qm)->type = ((qm)->qdma.va + (off)); \
-- 
2.33.0

