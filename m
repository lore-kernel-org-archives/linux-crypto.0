From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] crypto: omap-des - use devm_ioremap_resource()
Date: Thu, 03 Apr 2014 09:18:49 +0900
Message-ID: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Joel Fernandes' <joelf@ti.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29745 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbaDCASv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2014 20:18:51 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N3F002DZI7DMX10@mailout3.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 03 Apr 2014 09:18:50 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/omap-des.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ec5f131..f5bafd0 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1074,10 +1074,10 @@ static int omap_des_probe(struct platform_device *pdev)
 	if (err)
 		goto err_res;
 
-	dd->io_base = devm_request_and_ioremap(dev, res);
-	if (!dd->io_base) {
+	dd->io_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dd->io_base)) {
 		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+		err = PTR_ERR(dd->io_base);
 		goto err_res;
 	}
 	dd->phys_base = res->start;
-- 
1.7.10.4
