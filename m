From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v2] hwrng: pasemi_rng.c: Migrate to managed API
Date: Sun,  4 Sep 2016 23:43:08 +0530
Message-ID: <1473012788-6262-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: olof@lixom.net, mpm@selenic.com, herbert@gondor.apana.org.au,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        darren@stevens-zone.net, clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35096 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754198AbcIDSNz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Sep 2016 14:13:55 -0400
Received: by mail-pa0-f66.google.com with SMTP id pp5so1687382pac.2
        for <linux-crypto@vger.kernel.org>; Sun, 04 Sep 2016 11:13:55 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap and devm_hwrng_register instead of ioremap and
hwrng_register. This removes unregistering and error handling code.

Changes in v2:
Remove hardcoded resource size in ioremap, use resource struct obtained
by calling platform_get_resource.

Removing hardcoded resource size was suggested by LABBE Corentin.

CC: Darren Stevens <darren@stevens-zone.net>

Suggested-by: LABBE Corentin <clabbe.montjoie@gmail.com>
Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/pasemi-rng.c | 37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 699b725..b4e32f7 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -95,42 +95,20 @@ static struct hwrng pasemi_rng = {
 	.data_read	= pasemi_rng_data_read,
 };
 
-static int rng_probe(struct platform_device *ofdev)
+static int rng_probe(struct platform_device *pdev)
 {
 	void __iomem *rng_regs;
-	struct device_node *rng_np = ofdev->dev.of_node;
-	struct resource res;
-	int err = 0;
+	struct resource *res;
 
-	err = of_address_to_resource(rng_np, 0, &res);
-	if (err)
-		return -ENODEV;
-
-	rng_regs = ioremap(res.start, 0x100);
-
-	if (!rng_regs)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rng_regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rng_regs))
+		return PTR_ERR(rng_regs);
 
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
+	return devm_hwrng_register(&pdev->dev, &pasemi_rng);
 }
 
 static const struct of_device_id rng_match[] = {
@@ -146,7 +124,6 @@ static struct platform_driver rng_driver = {
 		.of_match_table = rng_match,
 	},
 	.probe		= rng_probe,
-	.remove		= rng_remove,
 };
 
 module_platform_driver(rng_driver);
-- 
2.5.0
