From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 03/12] hwrng: bcm2835-rng: Move enabling to hwrng::init
Date: Tue,  7 Nov 2017 16:44:40 -0800
Message-ID: <20171108004449.32730-4-f.fainelli@gmail.com>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:54099 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758901AbdKHApG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 19:45:06 -0500
In-Reply-To: <20171108004449.32730-1-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We should be moving the enabling of the HWRNG into a hwrng::init
callback since we can be disabled and enabled every time a different
hwrng is selected in the system.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 0d72147ab45b..82000a637504 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -72,6 +72,17 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 	return num_words * sizeof(u32);
 }
 
+static int bcm2835_rng_init(struct hwrng *rng)
+{
+	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
+
+	/* set warm-up count & enable */
+	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
+	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
+
+	return 0;
+}
+
 static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm2835-rng"},
 	{ .compatible = "brcm,bcm-nsp-rng", .data = nsp_rng_init},
@@ -105,6 +116,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->rng.name = "bcm2835-rng";
+	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
 
 	rng_id = of_match_node(bcm2835_rng_of_match, np);
@@ -116,10 +128,6 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	if (rng_setup)
 		rng_setup(priv->base);
 
-	/* set warm-up count & enable */
-	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
-	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
-
 	/* register driver */
 	err = hwrng_register(&priv->rng);
 	if (err)
-- 
2.9.3
