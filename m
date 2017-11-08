From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Tue,  7 Nov 2017 16:44:44 -0800
Message-ID: <20171108004449.32730-8-f.fainelli@gmail.com>
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

One of the last steps before bcm63xx-rng can be eliminated is to manage
a clock during hwrng::init and hwrng::cleanup, so fetch it in the probe
function, and manage it during these two steps when valid.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index ed20e0b6b7ae..99b56fd5482c 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -15,6 +15,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/printk.h>
+#include <linux/clk.h>
 
 #define RNG_CTRL	0x0
 #define RNG_STATUS	0x4
@@ -33,6 +34,7 @@ struct bcm2835_rng_priv {
 	struct hwrng rng;
 	void __iomem *base;
 	bool mask_interrupts;
+	struct clk *clk;
 };
 
 static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
@@ -66,8 +68,15 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 static int bcm2835_rng_init(struct hwrng *rng)
 {
 	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
+	int ret = 0;
 	u32 val;
 
+	if (!IS_ERR(priv->clk)) {
+		ret = clk_prepare_enable(priv->clk);
+		if (ret)
+			return ret;
+	}
+
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
 		val = readl(priv->base + RNG_INT_MASK);
@@ -79,7 +88,7 @@ static int bcm2835_rng_init(struct hwrng *rng)
 	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
 	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
 
-	return 0;
+	return ret;
 }
 
 static void bcm2835_rng_cleanup(struct hwrng *rng)
@@ -88,6 +97,9 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
 
 	/* disable rng hardware */
 	__raw_writel(0, priv->base + RNG_CTRL);
+
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
 }
 
 struct bcm2835_rng_of_data {
@@ -130,6 +142,9 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 	}
 
+	/* Clock is optional on most platforms */
+	priv->clk = devm_clk_get(dev, NULL);
+
 	priv->rng.name = "bcm2835-rng";
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
-- 
2.9.3
