From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 1/2] crypto: caam: pair irq map and dispose in the same function
Date: Thu, 22 Jan 2015 16:00:48 +0200
Message-ID: <1421935249-27549-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <horia.geanta@freescale.com>,
	"Cristian Stoica" <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:53396
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751236AbbAVOBH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 09:01:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

irq_dispose_mapping is not called on all error paths from caam_jr_init.
This takes care of several clean-up issues by performing resource
clean-up and allocation at the same level.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/jr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 9b3ef1bc..bce2959 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -384,8 +384,6 @@ static int caam_jr_init(struct device *dev)
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
-		irq_dispose_mapping(jrp->irq);
-		jrp->irq = 0;
 		return -EINVAL;
 	}
 
@@ -484,8 +482,10 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
-	if (error)
+	if (error) {
+		irq_dispose_mapping(jrpriv->irq);
 		return error;
+	}
 
 	jrpriv->dev = jrdev;
 	spin_lock(&driver_data.jr_alloc_lock);
-- 
2.2.0
