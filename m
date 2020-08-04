Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EAFC433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 08:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FF722CA1
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 08:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgHDIJD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 04:09:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729767AbgHDIJD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 04:09:03 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C1D1C28AAF784F1D2308;
        Tue,  4 Aug 2020 16:09:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 4 Aug 2020 16:08:54 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <zhouyanjie@wanyeetech.com>,
        <prasannatsmkumar@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] crypto: ingenic - Drop kfree for memory allocated with devm_kzalloc
Date:   Tue, 4 Aug 2020 08:11:53 +0000
Message-ID: <20200804081153.45342-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It's not necessary to free memory allocated with devm_kzalloc
and using kfree leads to a double free.

Fixes: 190873a0ea45 ("crypto: ingenic - Add hardware RNG for Ingenic JZ4780 and X1000")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/ingenic-rng.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/ingenic-rng.c b/drivers/char/hw_random/ingenic-rng.c
index d704cef64b64..055cfe59f519 100644
--- a/drivers/char/hw_random/ingenic-rng.c
+++ b/drivers/char/hw_random/ingenic-rng.c
@@ -92,8 +92,7 @@ static int ingenic_rng_probe(struct platform_device *pdev)
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		pr_err("%s: Failed to map RNG registers\n", __func__);
-		ret = PTR_ERR(priv->base);
-		goto err_free_rng;
+		return PTR_ERR(priv->base);
 	}
 
 	priv->version = (enum ingenic_rng_version)of_device_get_match_data(&pdev->dev);
@@ -106,17 +105,13 @@ static int ingenic_rng_probe(struct platform_device *pdev)
 	ret = hwrng_register(&priv->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register hwrng\n");
-		goto err_free_rng;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, priv);
 
 	dev_info(&pdev->dev, "Ingenic RNG driver registered\n");
 	return 0;
-
-err_free_rng:
-	kfree(priv);
-	return ret;
 }
 
 static int ingenic_rng_remove(struct platform_device *pdev)



