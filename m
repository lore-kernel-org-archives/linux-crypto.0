From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/12] hwrng: bcm2835-rng: Abstract I/O accessors
Date: Tue,  7 Nov 2017 16:44:45 -0800
Message-ID: <20171108004449.32730-9-f.fainelli@gmail.com>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>,
        Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        linux-crypto@vger.k
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108004449.32730-1-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

In preparation for allowing BCM63xx to use this driver, we abstract I/O
accessors such that we can easily change those later on.

Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 99b56fd5482c..3a607472687d 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -42,6 +42,17 @@ static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
 	return container_of(rng, struct bcm2835_rng_priv, rng);
 }
 
+static inline u32 rng_readl(struct bcm2835_rng_priv *priv, u32 offset)
+{
+	return readl(priv->base + offset);
+}
+
+static inline void rng_writel(struct bcm2835_rng_priv *priv, u32 val,
+			      u32 offset)
+{
+	writel(val, priv->base + offset);
+}
+
 static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 			       bool wait)
 {
@@ -49,18 +60,18 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 	u32 max_words = max / sizeof(u32);
 	u32 num_words, count;
 
-	while ((__raw_readl(priv->base + RNG_STATUS) >> 24) == 0) {
+	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
 		if (!wait)
 			return 0;
 		cpu_relax();
 	}
 
-	num_words = readl(priv->base + RNG_STATUS) >> 24;
+	num_words = rng_readl(priv, RNG_STATUS) >> 24;
 	if (num_words > max_words)
 		num_words = max_words;
 
 	for (count = 0; count < num_words; count++)
-		((u32 *)buf)[count] = readl(priv->base + RNG_DATA);
+		((u32 *)buf)[count] = rng_readl(priv, RNG_DATA);
 
 	return num_words * sizeof(u32);
 }
@@ -79,14 +90,14 @@ static int bcm2835_rng_init(struct hwrng *rng)
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
-		val = readl(priv->base + RNG_INT_MASK);
+		val = rng_readl(priv, RNG_INT_MASK);
 		val |= RNG_INT_OFF;
-		writel(val, priv->base + RNG_INT_MASK);
+		rng_writel(priv, val, RNG_INT_MASK);
 	}
 
 	/* set warm-up count & enable */
-	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
-	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
+	rng_writel(priv, RNG_WARMUP_COUNT, RNG_STATUS);
+	rng_writel(priv, RNG_RBGEN, RNG_CTRL);
 
 	return ret;
 }
@@ -96,7 +107,7 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
 	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
 
 	/* disable rng hardware */
-	__raw_writel(0, priv->base + RNG_CTRL);
+	rng_writel(priv, 0, RNG_CTRL);
 
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
