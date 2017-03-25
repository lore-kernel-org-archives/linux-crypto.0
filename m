From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sat, 25 Mar 2017 19:26:52 +0300
Message-ID: <20170325162654.3827-2-krzk@kernel.org>
References: <20170325162654.3827-1-krzk@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751392AbdCYQ2Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2017 12:28:16 -0400
In-Reply-To: <20170325162654.3827-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace existing hw_ranndom/exynos-rng driver with a new, reworked one.
This is a driver for pseudo random number generator block which on
Exynos4 chipsets must be seeded with some value.  On newer Exynos5420
chipsets it might seed itself from true random number generator block
but this is not implemented yet.

New driver is a complete rework to use the crypto ALGAPI instead of
hw_random API.  Rationale for the change:
1. hw_random interface is for true RNG devices.
2. The old driver was seeding itself with jiffies which is not a
   reliable source for randomness.
3. Device generates five random numbers in each pass but old driver was
   returning only one thus its performance was reduced.

Compatibility with DeviceTree bindings is preserved.

New driver does not use runtime power management but manually enables
and disables the clock when needed.  This is preferred approach because
using runtime PM just to toggle clock is huge overhead.

Another difference is reseeding itself with generated random data
periodically and during resuming from system suspend (previously driver
was re-seeding itself again with jiffies).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---
 MAINTAINERS                         |   8 +
 drivers/char/hw_random/Kconfig      |  14 --
 drivers/char/hw_random/Makefile     |   1 -
 drivers/char/hw_random/exynos-rng.c | 231 ---------------------
 drivers/crypto/Kconfig              |  15 ++
 drivers/crypto/Makefile             |   1 +
 drivers/crypto/exynos-rng.c         | 390 ++++++++++++++++++++++++++++++++++++
 7 files changed, 414 insertions(+), 246 deletions(-)
 delete mode 100644 drivers/char/hw_random/exynos-rng.c
 create mode 100644 drivers/crypto/exynos-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index affecc6d59f4..371fda859d43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10977,6 +10977,14 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/samsung/
 
+SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (RNG) DRIVER
+M:	Krzysztof Kozlowski <krzk@kernel.org>
+L:	linux-crypto@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/exynos-rng.c
+F:	Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
+
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jingoohan1@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0cafe08919c9..bdae802e7154 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -294,20 +294,6 @@ config HW_RANDOM_POWERNV
 
 	  If unsure, say Y.
 
-config HW_RANDOM_EXYNOS
-	tristate "EXYNOS HW random number generator support"
-	depends on ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_IOMEM
-	default HW_RANDOM
-	---help---
-	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on EXYNOS SOCs.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called exynos-rng.
-
-	  If unsure, say Y.
-
 config HW_RANDOM_TPM
 	tristate "TPM HW Random Number Generator support"
 	depends on TCG_TPM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 5f52b1e4e7be..6f1eecc2045c 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -24,7 +24,6 @@ obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
-obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
 obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
deleted file mode 100644
index 23d358553b21..000000000000
--- a/drivers/char/hw_random/exynos-rng.c
+++ /dev/null
@@ -1,231 +0,0 @@
-/*
- * exynos-rng.c - Random Number Generator driver for the exynos
- *
- * Copyright (C) 2012 Samsung Electronics
- * Jonghwa Lee <jonghwa3.lee@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#include <linux/hw_random.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/pm_runtime.h>
-#include <linux/err.h>
-
-#define EXYNOS_PRNG_STATUS_OFFSET	0x10
-#define EXYNOS_PRNG_SEED_OFFSET		0x140
-#define EXYNOS_PRNG_OUT1_OFFSET		0x160
-#define SEED_SETTING_DONE		BIT(1)
-#define PRNG_START			0x18
-#define PRNG_DONE			BIT(5)
-#define EXYNOS_AUTOSUSPEND_DELAY	100
-
-struct exynos_rng {
-	struct device *dev;
-	struct hwrng rng;
-	void __iomem *mem;
-	struct clk *clk;
-};
-
-static u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
-{
-	return	readl_relaxed(rng->mem + offset);
-}
-
-static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
-{
-	writel_relaxed(val, rng->mem + offset);
-}
-
-static int exynos_rng_configure(struct exynos_rng *exynos_rng)
-{
-	int i;
-	int ret = 0;
-
-	for (i = 0 ; i < 5 ; i++)
-		exynos_rng_writel(exynos_rng, jiffies,
-				EXYNOS_PRNG_SEED_OFFSET + 4*i);
-
-	if (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET)
-						 & SEED_SETTING_DONE))
-		ret = -EIO;
-
-	return ret;
-}
-
-static int exynos_init(struct hwrng *rng)
-{
-	struct exynos_rng *exynos_rng = container_of(rng,
-						struct exynos_rng, rng);
-	int ret = 0;
-
-	pm_runtime_get_sync(exynos_rng->dev);
-	ret = exynos_rng_configure(exynos_rng);
-	pm_runtime_mark_last_busy(exynos_rng->dev);
-	pm_runtime_put_autosuspend(exynos_rng->dev);
-
-	return ret;
-}
-
-static int exynos_read(struct hwrng *rng, void *buf,
-					size_t max, bool wait)
-{
-	struct exynos_rng *exynos_rng = container_of(rng,
-						struct exynos_rng, rng);
-	u32 *data = buf;
-	int retry = 100;
-	int ret = 4;
-
-	pm_runtime_get_sync(exynos_rng->dev);
-
-	exynos_rng_writel(exynos_rng, PRNG_START, 0);
-
-	while (!(exynos_rng_readl(exynos_rng,
-			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE) && --retry)
-		cpu_relax();
-	if (!retry) {
-		ret = -ETIMEDOUT;
-		goto out;
-	}
-
-	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
-
-	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
-
-out:
-	pm_runtime_mark_last_busy(exynos_rng->dev);
-	pm_runtime_put_sync_autosuspend(exynos_rng->dev);
-
-	return ret;
-}
-
-static int exynos_rng_probe(struct platform_device *pdev)
-{
-	struct exynos_rng *exynos_rng;
-	struct resource *res;
-	int ret;
-
-	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
-					GFP_KERNEL);
-	if (!exynos_rng)
-		return -ENOMEM;
-
-	exynos_rng->dev = &pdev->dev;
-	exynos_rng->rng.name = "exynos";
-	exynos_rng->rng.init =	exynos_init;
-	exynos_rng->rng.read = exynos_read;
-	exynos_rng->clk = devm_clk_get(&pdev->dev, "secss");
-	if (IS_ERR(exynos_rng->clk)) {
-		dev_err(&pdev->dev, "Couldn't get clock.\n");
-		return -ENOENT;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	exynos_rng->mem = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(exynos_rng->mem))
-		return PTR_ERR(exynos_rng->mem);
-
-	platform_set_drvdata(pdev, exynos_rng);
-
-	pm_runtime_set_autosuspend_delay(&pdev->dev, EXYNOS_AUTOSUSPEND_DELAY);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
-	ret = devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
-	if (ret) {
-		pm_runtime_dont_use_autosuspend(&pdev->dev);
-		pm_runtime_disable(&pdev->dev);
-	}
-
-	return ret;
-}
-
-static int exynos_rng_remove(struct platform_device *pdev)
-{
-	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
-	return 0;
-}
-
-static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(exynos_rng->clk);
-
-	return 0;
-}
-
-static int __maybe_unused exynos_rng_runtime_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
-
-	return clk_prepare_enable(exynos_rng->clk);
-}
-
-static int __maybe_unused exynos_rng_suspend(struct device *dev)
-{
-	return pm_runtime_force_suspend(dev);
-}
-
-static int __maybe_unused exynos_rng_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = pm_runtime_force_resume(dev);
-	if (ret)
-		return ret;
-
-	return exynos_rng_configure(exynos_rng);
-}
-
-static const struct dev_pm_ops exynos_rng_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(exynos_rng_suspend, exynos_rng_resume)
-	SET_RUNTIME_PM_OPS(exynos_rng_runtime_suspend,
-			   exynos_rng_runtime_resume, NULL)
-};
-
-static const struct of_device_id exynos_rng_dt_match[] = {
-	{
-		.compatible = "samsung,exynos4-rng",
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
-
-static struct platform_driver exynos_rng_driver = {
-	.driver		= {
-		.name	= "exynos-rng",
-		.pm	= &exynos_rng_pm_ops,
-		.of_match_table = exynos_rng_dt_match,
-	},
-	.probe		= exynos_rng_probe,
-	.remove		= exynos_rng_remove,
-};
-
-module_platform_driver(exynos_rng_driver);
-
-MODULE_DESCRIPTION("EXYNOS 4 H/W Random Number Generator driver");
-MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1a60626937e4..7d1fdf6a751c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -388,6 +388,21 @@ config CRYPTO_DEV_MXC_SCC
 	  This option enables support for the Security Controller (SCC)
 	  found in Freescale i.MX25 chips.
 
+config CRYPTO_DEV_EXYNOS_RNG
+	tristate "EXYNOS HW pseudo random number generator support"
+	depends on ARCH_EXYNOS || COMPILE_TEST
+	depends on HAS_IOMEM
+	select CRYPTO_RNG
+	---help---
+	  This driver provides kernel-side support through the
+	  cryptographic API for the pseudo random number generator hardware
+	  found on Exynos SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called exynos-rng.
+
+	  If unsure, say Y.
+
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 41ca339e89d3..9603f1862b30 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
 obj-$(CONFIG_CRYPTO_DEV_CPT) += cavium/cpt/
+obj-$(CONFIG_CRYPTO_DEV_EXYNOS_RNG) += exynos-rng.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
new file mode 100644
index 000000000000..d657b6243d0a
--- /dev/null
+++ b/drivers/crypto/exynos-rng.c
@@ -0,0 +1,390 @@
+/*
+ * exynos-rng.c - Random Number Generator driver for the Exynos
+ *
+ * Copyright (c) 2017 Krzysztof Kozlowski <krzk@kernel.org>
+ *
+ * Loosely based on old driver from drivers/char/hw_random/exynos-rng.c:
+ * Copyright (C) 2012 Samsung Electronics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <crypto/internal/rng.h>
+
+#define EXYNOS_RNG_CONTROL		0x0
+#define EXYNOS_RNG_STATUS		0x10
+#define EXYNOS_RNG_SEED_BASE		0x140
+#define EXYNOS_RNG_SEED(n)		(EXYNOS_RNG_SEED_BASE + (n * 0x4))
+#define EXYNOS_RNG_OUT_BASE		0x160
+#define EXYNOS_RNG_OUT(n)		(EXYNOS_RNG_OUT_BASE + (n * 0x4))
+
+/* EXYNOS_RNG_CONTROL bit fields */
+#define EXYNOS_RNG_CONTROL_START	0x18
+/* EXYNOS_RNG_STATUS bit fields */
+#define EXYNOS_RNG_STATUS_SEED_SETTING_DONE	BIT(1)
+#define EXYNOS_RNG_STATUS_RNG_DONE		BIT(5)
+
+/* Five seed and output registers, each 4 bytes */
+#define EXYNOS_RNG_SEED_REGS		5
+#define EXYNOS_RNG_SEED_SIZE		(EXYNOS_RNG_SEED_REGS * 4)
+
+/*
+ * Driver re-seeds itself with generated random numbers to increase
+ * the randomness.
+ *
+ * Time for next re-seed in ms.
+ */
+#define EXYNOS_RNG_RESEED_TIME		100
+/*
+ * In polling mode, do not wait infinitely for the engine to finish the work.
+ */
+#define EXYNOS_RNG_WAIT_RETRIES		100
+
+/* Context for crypto */
+struct exynos_rng_ctx {
+	struct exynos_rng_dev		*rng;
+};
+
+/* Device associated memory */
+struct exynos_rng_dev {
+	struct device			*dev;
+	struct exynos_rng_ctx		*ctx;
+	void __iomem			*mem;
+	struct clk			*clk;
+	/* Generated numbers stored for seeding during resume */
+	u8				seed_save[EXYNOS_RNG_SEED_SIZE];
+	unsigned int			seed_save_len;
+	/* Time of last seeding in jiffies */
+	unsigned long			last_seeding;
+};
+
+static struct exynos_rng_dev *exynos_rng_dev;
+
+static u32 exynos_rng_readl(struct exynos_rng_dev *rng, u32 offset)
+{
+	return readl_relaxed(rng->mem + offset);
+}
+
+static void exynos_rng_writel(struct exynos_rng_dev *rng, u32 val, u32 offset)
+{
+	writel_relaxed(val, rng->mem + offset);
+}
+
+static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
+			       const u8 *seed, unsigned int slen)
+{
+	u32 val;
+	int i;
+
+	dev_dbg(rng->dev, "Seeding with %u bytes\n", slen);
+
+	if (slen < EXYNOS_RNG_SEED_SIZE) {
+		dev_warn(rng->dev, "Seed too short (only %u bytes)\n", slen);
+		return -EINVAL;
+	}
+
+	for (i = 0 ; i < EXYNOS_RNG_SEED_REGS ; i++) {
+		val = seed[i * 4] << 24;
+		val |= seed[i * 4 + 1] << 16;
+		val |= seed[i * 4 + 2] << 8;
+		val |= seed[i * 4 + 3] << 0;
+
+		exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(i));
+	}
+
+	val = exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
+	if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
+		dev_warn(rng->dev, "Seed setting not finished\n");
+		return -EIO;
+	}
+
+	rng->last_seeding = jiffies;
+
+	return 0;
+}
+
+/*
+ * Read from output registers and put the data under 'dst' array,
+ * up to dlen bytes.
+ *
+ * Returns number of bytes actually stored in 'dst' (dlen
+ * or EXYNOS_RNG_SEED_SIZE).
+ */
+static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rng,
+					   u8 *dst, unsigned int dlen)
+{
+	unsigned int cnt = 0;
+	int i, j;
+	u32 val;
+
+	for (j = 0; j < EXYNOS_RNG_SEED_REGS; j++) {
+		val = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
+
+		for (i = 0; i < 4; i++) {
+			dst[cnt] = val & 0xff;
+			val >>= 8;
+			if (++cnt >= dlen)
+				return cnt;
+		}
+	}
+
+	return cnt;
+}
+
+/*
+ * Start the engine and poll for finish.  Then read from output registers
+ * filling the 'dst' buffer up to 'dlen' bytes or up to size of generated
+ * random data (EXYNOS_RNG_SEED_SIZE).
+ *
+ * On success: return 0 and store number of read bytes under 'read' address.
+ * On error: return -ERRNO.
+ */
+static int exynos_rng_get_random(struct exynos_rng_dev *rng,
+				 u8 *dst, unsigned int dlen,
+				 unsigned int *read)
+{
+	int retry = EXYNOS_RNG_WAIT_RETRIES;
+
+	exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
+			  EXYNOS_RNG_CONTROL);
+
+	while (!(exynos_rng_readl(rng,
+			EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
+		cpu_relax();
+
+	if (!retry)
+		return -ETIMEDOUT;
+
+	/* Clear status bit */
+	exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
+			  EXYNOS_RNG_STATUS);
+
+	*read = exynos_rng_copy_random(rng, dst, dlen);
+
+	return 0;
+}
+
+/* Re-seed itself from time to time */
+static void exynos_rng_reseed(struct exynos_rng_dev *rng)
+{
+	unsigned long next_seeding = rng->last_seeding + \
+				     msecs_to_jiffies(EXYNOS_RNG_RESEED_TIME);
+	unsigned long now = jiffies;
+	u8 seed[EXYNOS_RNG_SEED_SIZE];
+	unsigned int read;
+
+	if (time_before(now, next_seeding))
+		return;
+
+	if (exynos_rng_get_random(rng, seed, sizeof(seed), &read))
+		return;
+
+	exynos_rng_set_seed(rng, seed, read);
+}
+
+static int exynos_rng_generate(struct crypto_rng *tfm,
+			       const u8 *src, unsigned int slen,
+			       u8 *dst, unsigned int dlen)
+{
+	struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct exynos_rng_dev *rng = ctx->rng;
+	unsigned int read = 0;
+	int ret;
+
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	do {
+		ret = exynos_rng_get_random(rng, dst, dlen, &read);
+		if (ret)
+			break;
+
+		dlen -= read;
+		dst += read;
+
+		exynos_rng_reseed(rng);
+	} while (dlen > 0);
+
+	clk_disable_unprepare(rng->clk);
+
+	return ret;
+}
+
+static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
+			   unsigned int slen)
+{
+	struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct exynos_rng_dev *rng = ctx->rng;
+	int ret;
+
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	ret = exynos_rng_set_seed(ctx->rng, seed, slen);
+
+	clk_disable_unprepare(rng->clk);
+
+	return ret;
+}
+
+static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
+{
+	struct exynos_rng_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->rng = exynos_rng_dev;
+
+	return 0;
+}
+
+static struct rng_alg exynos_rng_alg = {
+	.generate		= exynos_rng_generate,
+	.seed			= exynos_rng_seed,
+	.seedsize		= EXYNOS_RNG_SEED_SIZE,
+	.base			= {
+		.cra_name		= "exynos_rng",
+		.cra_driver_name	= "exynos_rng",
+		.cra_priority		= 100,
+		.cra_ctxsize		= sizeof(struct exynos_rng_ctx),
+		.cra_module		= THIS_MODULE,
+		.cra_init		= exynos_rng_kcapi_init,
+	}
+};
+
+static int exynos_rng_probe(struct platform_device *pdev)
+{
+	struct exynos_rng_dev *rng;
+	struct resource *res;
+	int ret;
+
+	if (exynos_rng_dev)
+		return -EEXIST;
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	rng->dev = &pdev->dev;
+	rng->clk = devm_clk_get(&pdev->dev, "secss");
+	if (IS_ERR(rng->clk)) {
+		dev_err(&pdev->dev, "Couldn't get clock.\n");
+		return PTR_ERR(rng->clk);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rng->mem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rng->mem))
+		return PTR_ERR(rng->mem);
+
+	platform_set_drvdata(pdev, rng);
+
+	exynos_rng_dev = rng;
+
+	ret = crypto_register_rng(&exynos_rng_alg);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Couldn't register rng crypto alg: %d\n", ret);
+		exynos_rng_dev = NULL;
+	}
+
+	return ret;
+}
+
+static int exynos_rng_remove(struct platform_device *pdev)
+{
+	crypto_unregister_rng(&exynos_rng_alg);
+
+	exynos_rng_dev = NULL;
+
+	return 0;
+}
+
+static int __maybe_unused exynos_rng_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng_dev *rng = platform_get_drvdata(pdev);
+	int ret;
+
+	/* If we were never seeded then after resume it will be the same */
+	if (!rng->last_seeding)
+		return 0;
+
+	rng->seed_save_len = 0;
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	/* Get new random numbers and store them for seeding on resume. */
+	exynos_rng_get_random(rng, rng->seed_save, sizeof(rng->seed_save),
+			      &(rng->seed_save_len));
+	dev_dbg(rng->dev, "Stored %u bytes for seeding on system resume\n",
+		rng->seed_save_len);
+
+	clk_disable_unprepare(rng->clk);
+
+	return 0;
+}
+
+static int __maybe_unused exynos_rng_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng_dev *rng = platform_get_drvdata(pdev);
+	int ret;
+
+	/* Never seeded so nothing to do */
+	if (!rng->last_seeding)
+		return 0;
+
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	ret = exynos_rng_set_seed(rng, rng->seed_save, rng->seed_save_len);
+
+	clk_disable_unprepare(rng->clk);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_suspend,
+			 exynos_rng_resume);
+
+static const struct of_device_id exynos_rng_dt_match[] = {
+	{
+		.compatible = "samsung,exynos4-rng",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
+
+static struct platform_driver exynos_rng_driver = {
+	.driver		= {
+		.name	= "exynos-rng",
+		.pm	= &exynos_rng_pm_ops,
+		.of_match_table = exynos_rng_dt_match,
+	},
+	.probe		= exynos_rng_probe,
+	.remove		= exynos_rng_remove,
+};
+
+module_platform_driver(exynos_rng_driver);
+
+MODULE_DESCRIPTION("Exynos H/W Random Number Generator driver");
+MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
+MODULE_LICENSE("GPL");
-- 
2.9.3
