Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBDDC32771
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Sep 2022 09:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiIXJiD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Sep 2022 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiIXJiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Sep 2022 05:38:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350B7CBAFA;
        Sat, 24 Sep 2022 02:38:01 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZP3J2NfvzlWp5;
        Sat, 24 Sep 2022 17:33:48 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 17:37:59 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 17:37:58 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        <yangyicong@huawei.com>, Yicong Yang <yangyicong@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm: drop unnecessary IS_ENABLE(CONFIG_NUMA) check
Date:   Sat, 24 Sep 2022 17:34:24 +0800
Message-ID: <20220924093424.65529-1-qianweili@huawei.com>
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

From: Yicong Yang <yangyicong@hisilicon.com>

dev_to_node() can handle the case when CONFIG_NUMA is not set, so the
check of CONFIG_NUMA is redundant and can be removed.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8b387de69d22..9a38e170fb1d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4277,16 +4277,14 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
 	struct hisi_qm *qm;
 	struct list_head *n;
 	struct device *dev;
-	int dev_node = 0;
+	int dev_node;
 
 	list_for_each_entry(qm, &qm_list->list, list) {
 		dev = &qm->pdev->dev;
 
-		if (IS_ENABLED(CONFIG_NUMA)) {
-			dev_node = dev_to_node(dev);
-			if (dev_node < 0)
-				dev_node = 0;
-		}
+		dev_node = dev_to_node(dev);
+		if (dev_node < 0)
+			dev_node = 0;
 
 		res = kzalloc(sizeof(*res), GFP_KERNEL);
 		if (!res)
-- 
2.33.0

