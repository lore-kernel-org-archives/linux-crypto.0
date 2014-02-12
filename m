From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/4] crypto: tegra-aes - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 13:26:54 +0900
Message-ID: <000601cf27aa$a8aa4b50$f9fee1f0$%han@samsung.com>
References: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Thierry Reding' <thierry.reding@gmail.com>,
	'Varun Wadekar' <vwadekar@nvidia.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:64970 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLE04 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Feb 2014 23:26:56 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0V00JDQ8CVQK20@mailout3.samsung.com> for
 linux-crypto@vger.kernel.org; Wed, 12 Feb 2014 13:26:55 +0900 (KST)
In-reply-to: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/tegra-aes.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 060eecc..fa3dc14 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -896,23 +896,9 @@ static int tegra_aes_probe(struct platform_device *pdev)
 
 	/* Get the module base address */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "invalid resource type: base\n");
-		err = -ENODEV;
-		goto out;
-	}
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res),
-				     dev_name(&pdev->dev))) {
-		dev_err(&pdev->dev, "Couldn't request MEM resource\n");
-		return -ENODEV;
-	}
-
-	dd->io_base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!dd->io_base) {
-		dev_err(dev, "can't ioremap register space\n");
-		err = -ENOMEM;
+	dd->io_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dd->io_base)) {
+		err = PTR_ERR(dd->io_base);
 		goto out;
 	}
 
-- 
1.7.10.4
