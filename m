From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 04/12] hwrng: bcm2835-rng: Implementation cleanup callback
Date: Wed,  1 Nov 2017 18:04:00 -0700
Message-ID: <20171102010408.27736-5-f.fainelli@gmail.com>
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

We should be disabling the RNG in a hwrng::cleanup callback if we are
not longer the system selected RNG, not wait until the device driver is
removed.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 82000a637504..4d0356110b1b 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -83,6 +83,14 @@ static int bcm2835_rng_init(struct hwrng *rng)
 	return 0;
 }
 
+static void bcm2835_rng_cleanup(struct hwrng *rng)
+{
+	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
+
+	/* disable rng hardware */
+	__raw_writel(0, priv->base + RNG_CTRL);
+}
+
 static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm2835-rng"},
 	{ .compatible = "brcm,bcm-nsp-rng", .data = nsp_rng_init},
@@ -118,6 +126,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	priv->rng.name = "bcm2835-rng";
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
+	priv->rng.cleanup = bcm2835_rng_cleanup;
 
 	rng_id = of_match_node(bcm2835_rng_of_match, np);
 	if (!rng_id)
@@ -142,9 +151,6 @@ static int bcm2835_rng_remove(struct platform_device *pdev)
 {
 	struct bcm2835_rng_priv *priv = platform_get_drvdata(pdev);
 
-	/* disable rng hardware */
-	__raw_writel(0, priv->base + RNG_CTRL);
-
 	/* unregister driver */
 	hwrng_unregister(&priv->rng);
 
-- 
2.9.3
