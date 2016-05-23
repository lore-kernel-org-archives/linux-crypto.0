From: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: [PATCH 2/4] hwrng: bcm2835: Support Broadcom NSP SoC rng
Date: Mon, 23 May 2016 12:20:49 -0400
Message-ID: <1464020451-16520-3-git-send-email-yendapally.reddy@broadcom.com>
References: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com>
Cc: devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	linux-crypto@vger.kernel.org,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
	Russell King <linux@arm.linux.org.uk>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Jon Mason <jonmason@broadcom.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>,
	Richard Weinberger <richard@nod.at>, noltari@gmail.com,
	Joshua Henderson <joshua.henderson@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This supports the random number generator available in NSP SoC.
Masks the rng interrupt for NSP.

Signed-off-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
---
 drivers/char/hw_random/Kconfig       |  2 +-
 drivers/char/hw_random/bcm2835-rng.c | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 67ee8b0..f8d1a2b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -90,7 +90,7 @@ config HW_RANDOM_BCM63XX
 
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835 Random Number Generator support"
-	depends on ARCH_BCM2835
+	depends on ARCH_BCM2835 || ARCH_BCM_NSP
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 7192ec2..b1e8b78 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -19,6 +19,7 @@
 #define RNG_CTRL	0x0
 #define RNG_STATUS	0x4
 #define RNG_DATA	0x8
+#define RNG_INT_MASK	0x10
 
 /* enable rng */
 #define RNG_RBGEN	0x1
@@ -26,6 +27,18 @@
 /* the initial numbers generated are "less random" so will be discarded */
 #define RNG_WARMUP_COUNT 0x40000
 
+#define RNG_INT_OFF	0x1
+
+static void __init nsp_rng_init(void __iomem *base)
+{
+	u32 val;
+
+	/* mask the interrupt */
+	val = readl(base + RNG_INT_MASK);
+	val |= RNG_INT_OFF;
+	writel(val, base + RNG_INT_MASK);
+}
+
 static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 			       bool wait)
 {
@@ -46,10 +59,18 @@ static struct hwrng bcm2835_rng_ops = {
 	.read	= bcm2835_rng_read,
 };
 
+static const struct of_device_id bcm2835_rng_of_match[] = {
+	{ .compatible = "brcm,bcm2835-rng"},
+	{ .compatible = "brcm,bcm-nsp-rng", .data = nsp_rng_init},
+	{},
+};
+
 static int bcm2835_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	void (*rng_setup)(void __iomem *base);
+	const struct of_device_id *rng_id;
 	void __iomem *rng_base;
 	int err;
 
@@ -61,6 +82,15 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	}
 	bcm2835_rng_ops.priv = (unsigned long)rng_base;
 
+	rng_id = of_match_node(bcm2835_rng_of_match, np);
+	if (!rng_id)
+		return -EINVAL;
+
+	/* Check for rng init function, execute it */
+	rng_setup = rng_id->data;
+	if (rng_setup)
+		rng_setup(rng_base);
+
 	/* set warm-up count & enable */
 	__raw_writel(RNG_WARMUP_COUNT, rng_base + RNG_STATUS);
 	__raw_writel(RNG_RBGEN, rng_base + RNG_CTRL);
@@ -90,10 +120,6 @@ static int bcm2835_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id bcm2835_rng_of_match[] = {
-	{ .compatible = "brcm,bcm2835-rng", },
-	{},
-};
 MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
 static struct platform_driver bcm2835_rng_driver = {
-- 
2.1.0
