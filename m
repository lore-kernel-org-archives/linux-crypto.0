From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] crypto: omap-des - use devm_ioremap_resource()
Date: Tue, 08 Apr 2014 13:54:22 +0900
Message-ID: <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
References: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Joel Fernandes' <joelf@ti.com>,
	'Jingoo Han' <jg1.han@samsung.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40101 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaDHEyX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Apr 2014 00:54:23 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N3P00HAH4AMR160@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Tue, 08 Apr 2014 13:54:22 +0900 (KST)
In-reply-to: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- remove unnecessary error message, because devm_ioremap_resource()
  already prints one in all failure cases.

 drivers/crypto/omap-des.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ec5f131..4a13624 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1074,10 +1074,9 @@ static int omap_des_probe(struct platform_device *pdev)
 	if (err)
 		goto err_res;
 
-	dd->io_base = devm_request_and_ioremap(dev, res);
-	if (!dd->io_base) {
-		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+	dd->io_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dd->io_base)) {
+		err = PTR_ERR(dd->io_base);
 		goto err_res;
 	}
 	dd->phys_base = res->start;
-- 
1.7.10.4
