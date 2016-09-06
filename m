From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 8/9] hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K
Date: Tue,  6 Sep 2016 17:38:56 +0200
Message-ID: <20160906153857.5503-9-romain.perier@free-electrons.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59318 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933628AbcIFPk1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 11:40:27 -0400
In-Reply-To: <20160906153857.5503-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commits adds a device variant for Safexcel,EIP76 found in Marvell
Armada 8k. It defines registers mapping with the good offset and add a
specific initialization function.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/char/hw_random/Kconfig    |  2 +-
 drivers/char/hw_random/omap-rng.c | 85 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 56ad5a5..aea3613 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -168,7 +168,7 @@ config HW_RANDOM_IXP4XX
 
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
-	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS
+	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU
 	default HW_RANDOM
  	---help---
  	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index f1dcdb3..7c86c0d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -28,6 +28,7 @@
 #include <linux/of_device.h>
 #include <linux/of_address.h>
 #include <linux/interrupt.h>
+#include <linux/clk.h>
 
 #include <asm/io.h>
 
@@ -63,6 +64,7 @@
 
 #define OMAP2_RNG_OUTPUT_SIZE			0x4
 #define OMAP4_RNG_OUTPUT_SIZE			0x8
+#define EIP76_RNG_OUTPUT_SIZE			0x10
 
 enum {
 	RNG_OUTPUT_0_REG = 0,
@@ -108,6 +110,23 @@ static const u16 reg_map_omap4[] = {
 	[RNG_SYSCONFIG_REG]	= 0x1FE4,
 };
 
+static const u16 reg_map_eip76[] = {
+	[RNG_OUTPUT_0_REG]	= 0x0,
+	[RNG_OUTPUT_1_REG]	= 0x4,
+	[RNG_OUTPUT_2_REG]	= 0x8,
+	[RNG_OUTPUT_3_REG]	= 0xc,
+	[RNG_STATUS_REG]	= 0x10,
+	[RNG_INTACK_REG]	= 0x10,
+	[RNG_CONTROL_REG]	= 0x14,
+	[RNG_CONFIG_REG]	= 0x18,
+	[RNG_ALARMCNT_REG]	= 0x1c,
+	[RNG_FROENABLE_REG]	= 0x20,
+	[RNG_FRODETUNE_REG]	= 0x24,
+	[RNG_ALARMMASK_REG]	= 0x28,
+	[RNG_ALARMSTOP_REG]	= 0x2c,
+	[RNG_REV_REG]		= 0x7c,
+};
+
 struct omap_rng_dev;
 /**
  * struct omap_rng_pdata - RNG IP block-specific data
@@ -130,6 +149,7 @@ struct omap_rng_dev {
 	struct device			*dev;
 	const struct omap_rng_pdata	*pdata;
 	struct hwrng rng;
+	struct clk 			*clk;
 };
 
 static inline u32 omap_rng_read(struct omap_rng_dev *priv, u16 reg)
@@ -213,6 +233,38 @@ static inline u32 omap4_rng_data_present(struct omap_rng_dev *priv)
 	return omap_rng_read(priv, RNG_STATUS_REG) & RNG_REG_STATUS_RDY;
 }
 
+static int eip76_rng_init(struct omap_rng_dev *priv)
+{
+	u32 val;
+
+	/* Return if RNG is already running. */
+	if (omap_rng_read(priv, RNG_CONTROL_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
+		return 0;
+
+	/*  Number of 512 bit blocks of raw Noise Source output data that must
+	 *  be processed by either the Conditioning Function or the
+	 *  SP 800-90 DRBG ‘BC_DF’ functionality to yield a ‘full entropy’
+	 *  output value.
+	 */
+	val = 0x5 << RNG_CONFIG_MIN_REFIL_CYCLES_SHIFT;
+
+	/* Number of FRO samples that are XOR-ed together into one bit to be
+	 * shifted into the main shift register
+	 */
+	val |= RNG_CONFIG_MAX_REFIL_CYCLES << RNG_CONFIG_MAX_REFIL_CYCLES_SHIFT;
+	omap_rng_write(priv, RNG_CONFIG_REG, val);
+
+	/* Enable all available FROs */
+	omap_rng_write(priv, RNG_FRODETUNE_REG, 0x0);
+	omap_rng_write(priv, RNG_FROENABLE_REG, RNG_REG_FROENABLE_MASK);
+
+	/* Enable TRNG */
+	val = RNG_CONTROL_ENABLE_TRNG_MASK;
+	omap_rng_write(priv, RNG_CONTROL_REG, val);
+
+	return 0;
+}
+
 static int omap4_rng_init(struct omap_rng_dev *priv)
 {
 	u32 val;
@@ -282,6 +334,14 @@ static struct omap_rng_pdata omap4_rng_pdata = {
 	.cleanup	= omap4_rng_cleanup,
 };
 
+static struct omap_rng_pdata eip76_rng_pdata = {
+	.regs		= (u16 *)reg_map_eip76,
+	.data_size	= EIP76_RNG_OUTPUT_SIZE,
+	.data_present	= omap4_rng_data_present,
+	.init		= eip76_rng_init,
+	.cleanup	= omap4_rng_cleanup,
+};
+
 static const struct of_device_id omap_rng_of_match[] = {
 		{
 			.compatible	= "ti,omap2-rng",
@@ -291,6 +351,10 @@ static const struct of_device_id omap_rng_of_match[] = {
 			.compatible	= "ti,omap4-rng",
 			.data		= &omap4_rng_pdata,
 		},
+		{
+			.compatible	= "inside-secure,safexcel-eip76",
+			.data		= &eip76_rng_pdata,
+		},
 		{},
 };
 MODULE_DEVICE_TABLE(of, omap_rng_of_match);
@@ -309,7 +373,8 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 	}
 	priv->pdata = match->data;
 
-	if (of_device_is_compatible(dev->of_node, "ti,omap4-rng")) {
+	if (of_device_is_compatible(dev->of_node, "ti,omap4-rng") ||
+	    of_device_is_compatible(dev->of_node, "inside-secure,safexcel-eip76")) {
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0) {
 			dev_err(dev, "%s: error getting IRQ resource - %d\n",
@@ -325,6 +390,16 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 			return err;
 		}
 		omap_rng_write(priv, RNG_INTMASK_REG, RNG_SHUTDOWN_OFLO_MASK);
+
+		priv->clk = of_clk_get(pdev->dev.of_node, 0);
+		if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		if (!IS_ERR(priv->clk)) {
+			err = clk_prepare_enable(priv->clk);
+			if (err)
+				dev_err(&pdev->dev, "unable to enable the clk, "
+						    "err = %d\n", err);
+		}
 	}
 	return 0;
 }
@@ -386,7 +461,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
 				get_omap_rng_device_details(priv);
 	if (ret)
-		goto err_ioremap;
+		goto err_register;
 
 	ret = devm_hwrng_register(dev, &priv->rng);
 	if (ret)
@@ -400,6 +475,9 @@ static int omap_rng_probe(struct platform_device *pdev)
 err_register:
 	priv->base = NULL;
 	pm_runtime_disable(&pdev->dev);
+
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
 err_ioremap:
 	dev_err(dev, "initialization failed.\n");
 	return ret;
@@ -414,6 +492,9 @@ static int omap_rng_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
-- 
2.9.3
