From: Varun Wadekar <vwadekar@nvidia.com>
Subject: RE: [PATCH 4/4] crypto: tegra-aes - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 10:01:22 +0530
Message-ID: <A8BD086EC2BB774E8EBDDFB12114CB2A6CCF4E060A@BGMAIL02.nvidia.com>
References: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
 <000601cf27aa$a8aa4b50$f9fee1f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: 'David Miller' <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Thierry Reding' <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>,
	'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8993 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBLEdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Feb 2014 23:33:16 -0500
In-Reply-To: <000601cf27aa$a8aa4b50$f9fee1f0$%han@samsung.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Looks good. Please add my ACK.

Thanks.

-----Original Message-----
From: Jingoo Han [mailto:jg1.han@samsung.com] 
Sent: Wednesday, February 12, 2014 9:57 AM
To: 'Herbert Xu'
Cc: 'David Miller'; linux-crypto@vger.kernel.org; 'Jingoo Han'; 'Stephen Warren'; 'Thierry Reding'; Varun Wadekar
Subject: [PATCH 4/4] crypto: tegra-aes - Use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and remove redundant return value check of platform_get_resource() because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/tegra-aes.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c index 060eecc..fa3dc14 100644
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


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
