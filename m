From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/12] hwrng: bcm2835-rng: Obtain base register via resource
Date: Tue,  7 Nov 2017 16:44:38 -0800
Message-ID: <20171108004449.32730-2-f.fainelli@gmail.com>
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

In preparation for consolidating bcm63xx-rng into bcm2835-rng, make sure
that we obtain the base register via platform_get_resource() since we
need to support the non-DT enabled MIPS-based BCM63xx DSL SoCs.

Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 574211a49549..a818418a7e4c 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -81,21 +81,23 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	void (*rng_setup)(void __iomem *base);
 	const struct of_device_id *rng_id;
 	void __iomem *rng_base;
+	struct resource *r;
 	int err;
 
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
 	/* map peripheral */
-	rng_base = of_iomap(np, 0);
-	if (!rng_base) {
+	rng_base = devm_ioremap_resource(dev, r);
+	if (IS_ERR(rng_base)) {
 		dev_err(dev, "failed to remap rng regs");
-		return -ENODEV;
+		return PTR_ERR(rng_base);
 	}
 	bcm2835_rng_ops.priv = (unsigned long)rng_base;
 
 	rng_id = of_match_node(bcm2835_rng_of_match, np);
-	if (!rng_id) {
-		iounmap(rng_base);
+	if (!rng_id)
 		return -EINVAL;
-	}
+
 	/* Check for rng init function, execute it */
 	rng_setup = rng_id->data;
 	if (rng_setup)
@@ -107,10 +109,9 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 	/* register driver */
 	err = hwrng_register(&bcm2835_rng_ops);
-	if (err) {
+	if (err)
 		dev_err(dev, "hwrng registration failed\n");
-		iounmap(rng_base);
-	} else
+	else
 		dev_info(dev, "hwrng registered\n");
 
 	return err;
@@ -125,7 +126,6 @@ static int bcm2835_rng_remove(struct platform_device *pdev)
 
 	/* unregister driver */
 	hwrng_unregister(&bcm2835_rng_ops);
-	iounmap(rng_base);
 
 	return 0;
 }
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
