From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2] crypto: s5p-sss - Use devm_clk_get()
Date: Thu, 10 Jan 2013 11:05:30 +0900
Message-ID: <007501cdeed6$f73f1150$e5bd33f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Jingoo Han' <jg1.han@samsung.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:28289 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab3AJCFb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jan 2013 21:05:31 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGE00D6E0EUTOI0@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 10 Jan 2013 11:05:30 +0900 (KST)
Received: from DOJG1HAN02 ([12.23.120.99])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGE003930H6GYB0@mmp2.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 10 Jan 2013 11:05:30 +0900 (KST)
References: 
In-reply-to: 
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_clk_get() rather than clk_get() to make cleanup paths
more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- modified the commit message

 drivers/crypto/s5p-sss.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 49ad8cb..4b31432 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -580,7 +580,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
-	pdata->clk = clk_get(dev, "secss");
+	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
 		return -ENOENT;
@@ -645,7 +645,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
  err_irq:
 	clk_disable(pdata->clk);
-	clk_put(pdata->clk);
 
 	s5p_dev = NULL;
 	platform_set_drvdata(pdev, NULL);
@@ -667,7 +666,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
 	clk_disable(pdata->clk);
-	clk_put(pdata->clk);
 
 	s5p_dev = NULL;
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.2.5
