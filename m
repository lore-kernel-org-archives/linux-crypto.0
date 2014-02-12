From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/4] crypto: s5p-sss - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 13:24:57 +0900
Message-ID: <000501cf27aa$62f2da00$28d88e00$%han@samsung.com>
References: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Vladimir Zapolskiy' <vladimir_zapolskiy@mentor.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:10568 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLEZL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Feb 2014 23:25:11 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0V00HFV89LZ700@mailout1.samsung.com> for
 linux-crypto@vger.kernel.org; Wed, 12 Feb 2014 13:24:58 +0900 (KST)
In-reply-to: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/s5p-sss.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index cf149b1..be45762 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -568,17 +568,14 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	if (s5p_dev)
 		return -EEXIST;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	if (!devm_request_mem_region(dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr))
+		return PTR_ERR(pdata->ioaddr);
 
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
@@ -589,8 +586,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	clk_enable(pdata->clk);
 
 	spin_lock_init(&pdata->lock);
-	pdata->ioaddr = devm_ioremap(dev, res->start,
-				     resource_size(res));
 
 	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
 	if (pdata->irq_hash < 0) {
-- 
1.7.10.4
