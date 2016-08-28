From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] Use devm_hwrng_register instead of hwrng_register
Date: Sun, 28 Aug 2016 14:19:12 +0530
Message-ID: <1472374152-19319-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35110 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcH1It5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Aug 2016 04:49:57 -0400
Received: by mail-pa0-f66.google.com with SMTP id cf3so7136573pad.2
        for <linux-crypto@vger.kernel.org>; Sun, 28 Aug 2016 01:49:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

By using devm_hwrng_register instead of hwrng_register the .remove
callback in platform_driver can be removed. This reduces a few lines in
code.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/tx4939-rng.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
index a7b6949..1093583 100644
--- a/drivers/char/hw_random/tx4939-rng.c
+++ b/drivers/char/hw_random/tx4939-rng.c
@@ -144,22 +144,13 @@ static int __init tx4939_rng_probe(struct platform_device *dev)
 	}
 
 	platform_set_drvdata(dev, rngdev);
-	return hwrng_register(&rngdev->rng);
-}
-
-static int __exit tx4939_rng_remove(struct platform_device *dev)
-{
-	struct tx4939_rng *rngdev = platform_get_drvdata(dev);
-
-	hwrng_unregister(&rngdev->rng);
-	return 0;
+	return devm_hwrng_register(&dev->dev, &rngdev->rng);
 }
 
 static struct platform_driver tx4939_rng_driver = {
 	.driver		= {
 		.name	= "tx4939-rng",
 	},
-	.remove = tx4939_rng_remove,
 };
 
 module_platform_driver_probe(tx4939_rng_driver, tx4939_rng_probe);
-- 
2.5.0
