From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: pasemi_rng.c: Migrate to managed API
Date: Thu, 25 Aug 2016 17:04:16 +0530
Message-ID: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: prasannatsmkumar@gmail.com
To: olof@lixom.net, mpm@selenic.com, herbert@gondor.apana.org.au,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35679 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933184AbcHYLee (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 07:34:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap and devm_hwrng_register instead of ioremap and
hwrng_register. This removes unregistering and error handling code.

This patch is not tested with hardware as I don't have access to it.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/pasemi-rng.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 699b725..0f03397 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -100,37 +100,18 @@ static int rng_probe(struct platform_device *ofdev)
 	void __iomem *rng_regs;
 	struct device_node *rng_np = ofdev->dev.of_node;
 	struct resource res;
-	int err = 0;
 
-	err = of_address_to_resource(rng_np, 0, &res);
-	if (err)
+	if (of_address_to_resource(rng_np, 0, &res))
 		return -ENODEV;
 
-	rng_regs = ioremap(res.start, 0x100);
-
+	rng_regs = devm_ioremap(&ofdev->dev, res.start, 0x100);
 	if (!rng_regs)
 		return -ENOMEM;
 
 	pasemi_rng.priv = (unsigned long)rng_regs;
 
 	pr_info("Registering PA Semi RNG\n");
-
-	err = hwrng_register(&pasemi_rng);
-
-	if (err)
-		iounmap(rng_regs);
-
-	return err;
-}
-
-static int rng_remove(struct platform_device *dev)
-{
-	void __iomem *rng_regs = (void __iomem *)pasemi_rng.priv;
-
-	hwrng_unregister(&pasemi_rng);
-	iounmap(rng_regs);
-
-	return 0;
+	return devm_hwrng_register(&ofdev->dev, &pasemi_rng);
 }
 
 static const struct of_device_id rng_match[] = {
@@ -146,7 +127,6 @@ static struct platform_driver rng_driver = {
 		.of_match_table = rng_match,
 	},
 	.probe		= rng_probe,
-	.remove		= rng_remove,
 };
 
 module_platform_driver(rng_driver);
-- 
2.5.0
