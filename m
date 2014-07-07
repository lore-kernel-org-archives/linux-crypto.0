From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH v3] crypto: caam - fix memleak in caam_jr module
Date: Mon, 7 Jul 2014 11:52:41 +0300
Message-ID: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Garg Vakul-B16394 <vakul@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>,
	<stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:46718
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751399AbaGGIxO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2014 04:53:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/jr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3..b512a4b 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -453,8 +453,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
-			 GFP_KERNEL);
+	jrpriv = devm_kmalloc(jrdev, sizeof(struct caam_drv_private_jr),
+			      GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
@@ -487,10 +487,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
-	if (error) {
-		kfree(jrpriv);
+	if (error)
 		return error;
-	}
 
 	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);
-- 
1.8.3.1
