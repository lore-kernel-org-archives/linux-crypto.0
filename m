From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 05/12] hwrng: bcm2835-rng: Use device managed helpers
Date: Wed,  1 Nov 2017 18:04:01 -0700
Message-ID: <20171102010408.27736-6-f.fainelli@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.k
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102010408.27736-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that we have moved the RNG disabling into a hwrng::cleanup callback,
we can use the device managed registration operation and remove our
remove callback since it won't do anything necessary.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 4d0356110b1b..67b9bd3be28d 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -138,7 +138,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 		rng_setup(priv->base);
 
 	/* register driver */
-	err = hwrng_register(&priv->rng);
+	err = devm_hwrng_register(dev, &priv->rng);
 	if (err)
 		dev_err(dev, "hwrng registration failed\n");
 	else
@@ -147,16 +147,6 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int bcm2835_rng_remove(struct platform_device *pdev)
-{
-	struct bcm2835_rng_priv *priv = platform_get_drvdata(pdev);
-
-	/* unregister driver */
-	hwrng_unregister(&priv->rng);
-
-	return 0;
-}
-
 MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
 static struct platform_driver bcm2835_rng_driver = {
@@ -165,7 +155,6 @@ static struct platform_driver bcm2835_rng_driver = {
 		.of_match_table = bcm2835_rng_of_match,
 	},
 	.probe		= bcm2835_rng_probe,
-	.remove		= bcm2835_rng_remove,
 };
 module_platform_driver(bcm2835_rng_driver);
 
-- 
2.9.3
