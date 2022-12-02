Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924C5C47088
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 13:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbiLBNFM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 08:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiLBNFM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 08:05:12 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C04CF7B5
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 05:05:11 -0800 (PST)
Received: from dggpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NNtPM648szpW4X;
        Fri,  2 Dec 2022 21:01:43 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 21:05:09 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
        <mpm@selenic.com>, <mb@bu3sch.de>, <dilinger@queued.net>
CC:     <linux-crypto@vger.kernel.org>, <yangyingliang@huawei.com>,
        <wangxiongfeng2@huawei.com>
Subject: [PATCH v2 1/2] hwrng: amd - Fix PCI device refcount leak
Date:   Fri, 2 Dec 2022 21:22:33 +0800
Message-ID: <20221202132234.60631-2-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221202132234.60631-1-wangxiongfeng2@huawei.com>
References: <20221202132234.60631-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() for the normal and error path.

Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/char/hw_random/amd-rng.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index c22d4184bb61..0555e3838bce 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -143,15 +143,19 @@ static int __init amd_rng_mod_init(void)
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
 	if (err)
-		return err;
+		goto put_dev;
 
 	pmbase &= 0x0000FF00;
-	if (pmbase == 0)
-		return -EIO;
+	if (pmbase == 0) {
+		err = -EIO;
+		goto put_dev;
+	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		err = -ENOMEM;
+		goto put_dev;
+	}
 
 	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
@@ -185,6 +189,8 @@ static int __init amd_rng_mod_init(void)
 	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
+put_dev:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -200,6 +206,8 @@ static void __exit amd_rng_mod_exit(void)
 
 	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 
+	pci_dev_put(priv->pcidev);
+
 	kfree(priv);
 }
 
-- 
2.20.1

