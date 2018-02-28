From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 2/2] hwrng: omap - Fix clock resource by adding a register
 clock
Date: Wed, 28 Feb 2018 15:27:23 +0100
Message-ID: <20180228142723.11562-3-gregory.clement@bootlin.com>
References: <20180228142723.11562-1-gregory.clement@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Antoine Tenart <antoine.tenart@bootlin.com>,
 Gregory CLEMENT <gregory.clement@bootlin.com>, Omri Itach <omrii@marvell.com>,
 Nadav Haklai <nadavh@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
 Igal Liberman <igall@marvell.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
 Marcin Wojtas <mw@semihalf.com>, Hanna Hawa <hannah@marvell.com>,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Deepak Saxena <dsaxena@plexity.net>, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180228142723.11562-1-gregory.clement@bootlin.com>
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

On Armada 7K/8K we need to explicitly enable the register clock. This
clock is optional because not all the SoCs using this IP need it but at
least for Armada 7K/8K it is actually mandatory.

The binding documentation is updating accordingly.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 Documentation/devicetree/bindings/rng/omap_rng.txt |  7 ++++++-
 drivers/char/hw_random/omap-rng.c                  | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
index 9cf7876ab434..ea434ce50f36 100644
--- a/Documentation/devicetree/bindings/rng/omap_rng.txt
+++ b/Documentation/devicetree/bindings/rng/omap_rng.txt
@@ -13,7 +13,12 @@ Required properties:
 - interrupts : the interrupt number for the RNG module.
 		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
 - clocks: the trng clock source. Only mandatory for the
-  "inside-secure,safexcel-eip76" compatible.
+  "inside-secure,safexcel-eip76" compatible, the second clock is
+  needed for the Armada 7K/8K SoCs
+- clock-names: mandatory if there is a second clock, in this case the
+  name must be "core" for the first clock and "reg" for the second
+  one
+
 
 Example:
 /* AM335x */
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 159d4a1347b8..b65ff6962899 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -150,6 +150,7 @@ struct omap_rng_dev {
 	const struct omap_rng_pdata	*pdata;
 	struct hwrng rng;
 	struct clk 			*clk;
+	struct clk			*clk_reg;
 };
 
 static inline u32 omap_rng_read(struct omap_rng_dev *priv, u16 reg)
@@ -480,6 +481,19 @@ static int omap_rng_probe(struct platform_device *pdev)
 		}
 	}
 
+	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
+	if (IS_ERR(priv->clk_reg) && PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	if (!IS_ERR(priv->clk_reg)) {
+		ret = clk_prepare_enable(priv->clk_reg);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Unable to enable the register clk: %d\n",
+				ret);
+			goto err_register;
+		}
+	}
+
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
 				get_omap_rng_device_details(priv);
 	if (ret)
@@ -499,6 +513,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	clk_disable_unprepare(priv->clk_reg);
 	clk_disable_unprepare(priv->clk);
 err_ioremap:
 	dev_err(dev, "initialization failed.\n");
@@ -517,6 +532,7 @@ static int omap_rng_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	clk_disable_unprepare(priv->clk);
+	clk_disable_unprepare(priv->clk_reg);
 
 	return 0;
 }
-- 
2.16.1
