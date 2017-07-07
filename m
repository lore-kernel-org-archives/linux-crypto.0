From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 11/13] crypto: caam - remove unused variables in caam_drv_private
Date: Fri, 7 Jul 2017 16:05:21 +0300
Message-ID: <20170707130523.32427-12-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:7621
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbdGGNGG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:06:06 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c   | 1 -
 drivers/crypto/caam/intern.h | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index dd353e342c12..7338f15b8674 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -444,7 +444,6 @@ static int caam_probe(struct platform_device *pdev)
 
 	dev = &pdev->dev;
 	dev_set_drvdata(dev, ctrlpriv);
-	ctrlpriv->pdev = pdev;
 	nprop = pdev->dev.of_node;
 
 	/* Enable clocking */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 85b6c5835b8f..9e3f3e0a7ffa 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -64,12 +64,9 @@ struct caam_drv_private_jr {
  * Driver-private storage for a single CAAM block instance
  */
 struct caam_drv_private {
-
-	struct device *dev;
 #ifdef CONFIG_CAAM_QI
 	struct device *qidev;
 #endif
-	struct platform_device *pdev;
 
 	/* Physical-presence section */
 	struct caam_ctrl __iomem *ctrl; /* controller region */
-- 
2.12.0.264.gd6db3f216544
