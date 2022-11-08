Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F57C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 08:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiKHI3X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiKHI3R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 03:29:17 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F729BC85
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 00:29:15 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N61Tn6TSgzmVj8;
        Tue,  8 Nov 2022 16:29:01 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 16:29:13 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: ccree - Remove debugfs when platform_driver_register failed
Date:   Tue, 8 Nov 2022 16:29:12 +0800
Message-ID: <20221108082912.1818219-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When platform_driver_register failed, we need to remove debugfs,
which will caused a resource leak, fix it.

Failed logs as follows:
[   32.606488] debugfs: Directory 'ccree' with parent '/' already present!

Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/crypto/ccree/cc_driver.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index cadead18b59e..d489c6f80892 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -651,9 +651,17 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
+	int rc;
+
 	cc_debugfs_global_init();
 
-	return platform_driver_register(&ccree_driver);
+	rc = platform_driver_register(&ccree_driver);
+	if (rc) {
+		cc_debugfs_global_fini();
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ccree_init);
 
-- 
2.25.1

