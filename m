Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273B9C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Nov 2022 09:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiKMJdV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 04:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMJdV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 04:33:21 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868C012A8C
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 01:33:20 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N96gM3bpnzRp1W;
        Sun, 13 Nov 2022 17:33:03 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 13 Nov
 2022 17:33:18 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] crypto: ccree - Fix error handling in ccree_init()
Date:   Sun, 13 Nov 2022 09:31:37 +0000
Message-ID: <20221113093137.20178-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A problem about ccree create debugfs failed is triggered with the
following log given:

 [  398.049333] debugfs: Directory 'ccree' with parent '/' already present!

The reason is that ccree_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without remove debugfs of ccree, resulting the
debugfs of ccree can never be created later.
A simple call graph is shown as below:

 ccree_init()
   cc_debugfs_global_init() # create debugfs ccree
   platform_driver_register()
     driver_register()
       bus_add_driver()
         dev = kzalloc(...) # OOM happened
   # return without destroy debugfs ccree

Fix by removing debugfs when platform_driver_register() returns error.

Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/crypto/ccree/cc_debugfs.c | 2 +-
 drivers/crypto/ccree/cc_driver.c  | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 7083767602fc..8f008f024f8f 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -55,7 +55,7 @@ void __init cc_debugfs_global_init(void)
 	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
 }
 
-void __exit cc_debugfs_global_fini(void)
+void cc_debugfs_global_fini(void)
 {
 	debugfs_remove(cc_debugfs_dir);
 }
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index cadead18b59e..1969d1e6df40 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -651,9 +651,15 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
+	int ret;
+
 	cc_debugfs_global_init();
 
-	return platform_driver_register(&ccree_driver);
+	ret = platform_driver_register(&ccree_driver);
+	if (ret)
+		cc_debugfs_global_fini();
+
+	return ret;
 }
 module_init(ccree_init);
 
-- 
2.17.1

