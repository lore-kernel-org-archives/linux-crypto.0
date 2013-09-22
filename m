From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/3] crypto: dcp: Use devm_ioremap_resource()
Date: Sun, 22 Sep 2013 14:42:25 -0300
Message-ID: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Cc: tobias.rauter@gmail.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ye0-f179.google.com ([209.85.213.179]:55485 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVRmg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Sep 2013 13:42:36 -0400
Received: by mail-ye0-f179.google.com with SMTP id r6so906102yen.38
        for <linux-crypto@vger.kernel.org>; Sun, 22 Sep 2013 10:42:35 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Using devm_ioremap_resource() can make the code simpler and smaller.

When devm_ioremap_resource() is used there is no need to explicitely check the 
error returned by platform_get_resource().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/dcp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index a8a7dd4..90a7cb7 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -733,12 +733,7 @@ static int dcp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "failed to get IORESOURCE_MEM\n");
-		return -ENXIO;
-	}
-	dev->dcp_regs_base = devm_ioremap(&pdev->dev, r->start,
-					  resource_size(r));
+	dev->dcp_regs_base = devm_ioremap_resource(&pdev->dev, r);
 
 	dcp_set(dev, DCP_CTRL_SFRST, DCP_REG_CTRL);
 	udelay(10);
-- 
1.8.1.2
