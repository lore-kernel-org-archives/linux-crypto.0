From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 04/12] hwrng: bcm2835-rng: Implementation cleanup callback
Date: Tue,  7 Nov 2017 16:44:41 -0800
Message-ID: <20171108004449.32730-5-f.fainelli@gmail.com>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, Stefan Wahren <stefan.wahren@i2se.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Martin Kaiser <martin@kaiser.cx>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Ray Jui <rjui@broadcom.com>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Harald Freudenberger <freude@linux.vnet.ibm.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Eric Anholt <eric@anholt.net>,
 Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <robh+dt@kernel.org>,
 "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
 <bcm-kernel-feedback-list@broadcom.com>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>,
 Matt Mackall <mpm@selenic.com>, Steffen Trumtrar <s.
To: linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171108004449.32730-1-f.fainelli@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
