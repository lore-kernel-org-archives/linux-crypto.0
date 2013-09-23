From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: dcp: Check the return value from devm_ioremap_resource()
Date: Mon, 23 Sep 2013 18:12:04 -0300
Message-ID: <1379970724-11983-1-git-send-email-festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:49534 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IWVMU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 17:12:20 -0400
Received: by mail-yh0-f54.google.com with SMTP id z20so1617431yhz.41
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2013 14:12:19 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

devm_ioremap_resource() may fail, so better check its return value and propagate
it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/dcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 7b77c84..247ab80 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -734,6 +734,8 @@ static int dcp_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->dcp_regs_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(dev->dcp_regs_base))
+		return PTR_ERR(dev->dcp_regs_base);
 
 	dcp_set(dev, DCP_CTRL_SFRST, DCP_REG_CTRL);
 	udelay(10);
-- 
1.8.1.2
