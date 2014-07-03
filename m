From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH v2] crypto: caam - fix memleak in caam_jr module
Date: Thu, 3 Jul 2014 15:07:50 +0300
Message-ID: <1404389270-19588-1-git-send-email-cristian.stoica@freescale.com>
References: <75b67e0fc305452fb5075e5bee5fff9c@BL2PR03MB162.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:21881
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017AbaGCMII (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 08:08:08 -0400
In-Reply-To: <75b67e0fc305452fb5075e5bee5fff9c@BL2PR03MB162.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a memory leak that appears when caam_jr module is unloaded.

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/jr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1d80bd3..e0b91fc 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -453,7 +453,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
+	jrpriv = devm_kzalloc(jrdev, sizeof(struct caam_drv_private_jr),
 			 GFP_KERNEL);
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
