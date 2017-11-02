From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 03/12] hwrng: bcm2835-rng: Move enabling to hwrng::init
Date: Wed,  1 Nov 2017 18:03:59 -0700
Message-ID: <20171102010408.27736-4-f.fainelli@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
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
In-Reply-To: <20171102010408.27736-1-f.fainelli@gmail.com>
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
