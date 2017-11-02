From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 02/12] hwrng: bcm2835-rng: Define a driver private context
Date: Wed,  1 Nov 2017 18:03:58 -0700
Message-ID: <20171102010408.27736-3-f.fainelli@gmail.com>
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

Instead of making hwrng::priv host the base register address, define a
driver private context, make it per platform device instance and pass it
down the different functions.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 55 ++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index a818418a7e4c..0d72147ab45b 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -29,6 +29,11 @@
 
 #define RNG_INT_OFF	0x1
 
+struct bcm2835_rng_priv {
+	struct hwrng rng;
+	void __iomem *base;
+};
+
 static void __init nsp_rng_init(void __iomem *base)
 {
 	u32 val;
@@ -39,34 +44,34 @@ static void __init nsp_rng_init(void __iomem *base)
 	writel(val, base + RNG_INT_MASK);
 }
 
+static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
+{
+	return container_of(rng, struct bcm2835_rng_priv, rng);
+}
+
 static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 			       bool wait)
 {
-	void __iomem *rng_base = (void __iomem *)rng->priv;
+	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
 	u32 max_words = max / sizeof(u32);
 	u32 num_words, count;
 
-	while ((__raw_readl(rng_base + RNG_STATUS) >> 24) == 0) {
+	while ((__raw_readl(priv->base + RNG_STATUS) >> 24) == 0) {
 		if (!wait)
 			return 0;
 		cpu_relax();
 	}
 
-	num_words = readl(rng_base + RNG_STATUS) >> 24;
+	num_words = readl(priv->base + RNG_STATUS) >> 24;
 	if (num_words > max_words)
 		num_words = max_words;
 
 	for (count = 0; count < num_words; count++)
-		((u32 *)buf)[count] = readl(rng_base + RNG_DATA);
+		((u32 *)buf)[count] = readl(priv->base + RNG_DATA);
 
 	return num_words * sizeof(u32);
 }
 
-static struct hwrng bcm2835_rng_ops = {
-	.name	= "bcm2835",
-	.read	= bcm2835_rng_read,
-};
-
 static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm2835-rng"},
 	{ .compatible = "brcm,bcm-nsp-rng", .data = nsp_rng_init},
@@ -80,19 +85,27 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	void (*rng_setup)(void __iomem *base);
 	const struct of_device_id *rng_id;
-	void __iomem *rng_base;
+	struct bcm2835_rng_priv *priv;
 	struct resource *r;
 	int err;
 
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, priv);
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	/* map peripheral */
-	rng_base = devm_ioremap_resource(dev, r);
-	if (IS_ERR(rng_base)) {
+	priv->base = devm_ioremap_resource(dev, r);
+	if (IS_ERR(priv->base)) {
 		dev_err(dev, "failed to remap rng regs");
-		return PTR_ERR(rng_base);
+		return PTR_ERR(priv->base);
 	}
-	bcm2835_rng_ops.priv = (unsigned long)rng_base;
+
+	priv->rng.name = "bcm2835-rng";
+	priv->rng.read = bcm2835_rng_read;
 
 	rng_id = of_match_node(bcm2835_rng_of_match, np);
 	if (!rng_id)
@@ -101,14 +114,14 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	/* Check for rng init function, execute it */
 	rng_setup = rng_id->data;
 	if (rng_setup)
-		rng_setup(rng_base);
+		rng_setup(priv->base);
 
 	/* set warm-up count & enable */
-	__raw_writel(RNG_WARMUP_COUNT, rng_base + RNG_STATUS);
-	__raw_writel(RNG_RBGEN, rng_base + RNG_CTRL);
+	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
+	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
 
 	/* register driver */
-	err = hwrng_register(&bcm2835_rng_ops);
+	err = hwrng_register(&priv->rng);
 	if (err)
 		dev_err(dev, "hwrng registration failed\n");
 	else
@@ -119,13 +132,13 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 static int bcm2835_rng_remove(struct platform_device *pdev)
 {
-	void __iomem *rng_base = (void __iomem *)bcm2835_rng_ops.priv;
+	struct bcm2835_rng_priv *priv = platform_get_drvdata(pdev);
 
 	/* disable rng hardware */
-	__raw_writel(0, rng_base + RNG_CTRL);
+	__raw_writel(0, priv->base + RNG_CTRL);
 
 	/* unregister driver */
-	hwrng_unregister(&bcm2835_rng_ops);
+	hwrng_unregister(&priv->rng);
 
 	return 0;
 }
-- 
2.9.3
