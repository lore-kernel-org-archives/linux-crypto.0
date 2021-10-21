Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A685FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 02:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767AA611EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 02:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJUCSi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 22:18:38 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:55730 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUCSh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 22:18:37 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46170cd659e7-0ff83; Thu, 21 Oct 2021 10:16:08 +0800 (CST)
X-RM-TRANSID: 2ee46170cd659e7-0ff83
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96170cd65613-61893;
        Thu, 21 Oct 2021 10:16:08 +0800 (CST)
X-RM-TRANSID: 2ee96170cd65613-61893
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] crypto: sa2ul - Use the defined variable to clean code
Date:   Thu, 21 Oct 2021 10:16:23 +0800
Message-Id: <20211021021624.29672-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the defined variable "dev" to make the code cleaner.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/crypto/sa2ul.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 544d7040c..bcbc38dc6 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2412,8 +2412,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
-			ret);
+		dev_err(dev, "%s: failed to get sync: %d\n", __func__, ret);
 		pm_runtime_disable(dev);
 		return ret;
 	}
@@ -2435,16 +2434,16 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	sa_register_algos(dev_data);
 
-	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret)
 		goto release_dma;
 
-	device_for_each_child(&pdev->dev, &pdev->dev, sa_link_child);
+	device_for_each_child(dev, dev, sa_link_child);
 
 	return 0;
 
 release_dma:
-	sa_unregister_algos(&pdev->dev);
+	sa_unregister_algos(dev);
 
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
@@ -2453,8 +2452,8 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 	return ret;
 }
-- 
2.20.1.windows.1



